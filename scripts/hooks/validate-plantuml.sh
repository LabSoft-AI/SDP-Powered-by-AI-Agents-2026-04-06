#!/usr/bin/env bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
VERBOSE=${PLANTUML_VERBOSE:-false}
PLANTUML_CMD=""

log() {
    if [[ "$VERBOSE" == "true" ]]; then
        echo -e "${YELLOW}[DEBUG]${NC} $1"
    fi
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Detect PlantUML installation
detect_plantuml() {
    log "Detecting PlantUML installation..."

    # Try user-installed PlantUML jar first (from setup.sh)
    local user_jar="$HOME/.local/share/plantuml/plantuml.jar"
    if command -v java >/dev/null 2>&1 && [ -f "$user_jar" ]; then
        PLANTUML_CMD="java -Dplantuml.allowincludeurl=true -jar $user_jar"
        log "Found user PlantUML jar: $user_jar (with C4 compatibility flags)"
        return 0
    fi

    # Try local plantuml.jar (legacy)
    if command -v java >/dev/null 2>&1 && [ -f "plantuml.jar" ]; then
        PLANTUML_CMD="java -Dplantuml.allowincludeurl=true -jar plantuml.jar"
        log "Found local PlantUML jar: plantuml.jar (with C4 compatibility flags)"
        return 0
    fi

    # Try system PlantUML (may have compatibility issues)
    if command -v plantuml >/dev/null 2>&1; then
        PLANTUML_CMD="plantuml"
        log "Found system PlantUML: $(which plantuml) (may have C4 compatibility issues)"
        return 0
    fi

    # Fallback to Docker
    if command -v docker >/dev/null 2>&1; then
        PLANTUML_CMD="docker run --rm -v \$(pwd):/work -w /work plantuml/plantuml:latest"
        log "Using Docker PlantUML"
        return 0
    fi

    error "PlantUML not found. Run ./setup.sh to install PlantUML, or install Docker."
    return 1
}

# Get staged .puml files
get_staged_puml_files() {
    git diff --cached --name-only --diff-filter=AM | grep '\.puml$' || true
}

# Validate SVG file
validate_svg() {
    local svg_file="$1"
    local validation_errors=()

    log "Validating SVG: $svg_file"

    # Check file existence
    if [ ! -f "$svg_file" ]; then
        validation_errors+=("File does not exist")
        printf '%s\n' "${validation_errors[@]}"
        return 1
    fi

    # Check file size (should be > 0)
    if [ ! -s "$svg_file" ]; then
        validation_errors+=("File is empty")
    fi

    # Check XML structure
    if command -v xmllint >/dev/null 2>&1; then
        if ! xmllint --noout "$svg_file" 2>/dev/null; then
            validation_errors+=("Invalid XML structure")
        fi
    else
        log "xmllint not found, skipping XML validation"
    fi

    # Check for PlantUML error messages in SVG content
    if grep -q "PlantUML version" "$svg_file" && grep -q "Error" "$svg_file"; then
        validation_errors+=("Contains PlantUML error messages")
    fi

    # Check for PlantUML fatal parsing errors
    if grep -q "Fatal parsing error" "$svg_file"; then
        validation_errors+=("Contains PlantUML fatal parsing error")
    fi

    # Check for basic SVG structure
    if ! grep -q "<svg" "$svg_file"; then
        validation_errors+=("Missing SVG root element")
    fi

    # Check minimum file size (valid SVGs should be at least 100 bytes)
    local file_size=$(wc -c < "$svg_file")
    if [ "$file_size" -lt 100 ]; then
        validation_errors+=("File too small ($file_size bytes)")
    fi

    if [ ${#validation_errors[@]} -gt 0 ]; then
        error "SVG validation failed for $svg_file:"
        printf '  - %s\n' "${validation_errors[@]}"
        return 1
    fi

    log "SVG validation passed: $svg_file"
    return 0
}

# Fix @startuml directive to match filename
fix_startuml_directive() {
    local puml_file="$1"
    local filename=$(basename "$puml_file" .puml)

    # Check if @startuml directive matches filename
    local current_directive=$(grep -m1 "^@startuml" "$puml_file" || echo "")
    local expected_directive="@startuml $filename"

    if [ -n "$current_directive" ] && [ "$current_directive" != "$expected_directive" ]; then
        log "Fixing @startuml directive in $puml_file: '$current_directive' -> '$expected_directive'"
        sed -i "1s/^@startuml.*/@startuml $filename/" "$puml_file"
        echo "  🔧 Fixed @startuml directive: $filename"
        return 0
    fi

    return 1
}

# Generate SVG from PUML file
generate_svg() {
    local puml_file="$1"
    local expected_svg_file="${puml_file%.puml}.svg"

    log "Generating SVG for: $puml_file"

    # Fix @startuml directive if needed
    fix_startuml_directive "$puml_file"

    if [[ "$PLANTUML_CMD" == *"docker"* ]]; then
        eval "$PLANTUML_CMD -tsvg \"$puml_file\""
    else
        $PLANTUML_CMD -tsvg "$puml_file"
    fi

    # Check if the expected SVG was created
    if [ -f "$expected_svg_file" ]; then
        local svg_file="$expected_svg_file"
    else
        # Look for any SVG file created in the same directory
        local dir=$(dirname "$puml_file")
        local generated_svg=$(find "$dir" -name "*.svg" -newer "$puml_file" 2>/dev/null | head -1)

        if [ -n "$generated_svg" ] && [ -f "$generated_svg" ]; then
            # Rename to match the expected naming convention
            mv "$generated_svg" "$expected_svg_file"
            log "Renamed $generated_svg to $expected_svg_file"
            local svg_file="$expected_svg_file"
        else
            error "Failed to generate SVG: $expected_svg_file"
            return 1
        fi
    fi

    # Validate the generated SVG
    if ! validate_svg "$svg_file"; then
        error "Generated SVG failed validation: $svg_file"
        return 1
    fi

    # Auto-stage the generated SVG
    git add "$svg_file"
    echo "Generated and staged: $svg_file"

    return 0
}

# Attempt to regenerate SVG from corresponding PUML file
regenerate_svg() {
    local svg_file="$1"
    local puml_file="${svg_file%.svg}.puml"

    if [ -f "$puml_file" ]; then
        log "Attempting to regenerate $svg_file from $puml_file"

        # Fix @startuml directive if needed
        fix_startuml_directive "$puml_file"

        # Capture both stdout and stderr, suppress output
        if generate_svg "$puml_file" 2>/dev/null; then
            log "Successfully regenerated $svg_file"
            return 0
        else
            log "Failed to regenerate $svg_file (PlantUML error)"
            echo "    ⚠️  PlantUML generation failed for $puml_file"
            return 1
        fi
    else
        log "No corresponding .puml file found for $svg_file"
        echo "    ⚠️  No corresponding .puml file found: $puml_file"
        return 1
    fi
}

# Get all SVG files in repository
get_all_svg_files() {
    find . -name "*.svg" -type f | grep -v ".git" || true
}

# Get all PUML files that don't have corresponding SVG files
get_missing_svg_files() {
    find . -name "*.puml" -type f | grep -v ".git" | while read puml_file; do
        svg_file="${puml_file%.puml}.svg"
        if [ ! -f "$svg_file" ]; then
            echo "$puml_file"
        fi
    done
}

# Main execution
main() {
    echo "🎨 PlantUML Pre-commit Validation"
    echo "================================="

    # Detect PlantUML
    if ! detect_plantuml; then
        exit 1
    fi

    # Get staged PUML files
    staged_files=$(get_staged_puml_files)

    if [ -n "$staged_files" ]; then
        echo "📄 Processing staged .puml files:"
        echo "$staged_files"
        echo

        # Process each file
        failed_files=()
        while IFS= read -r file; do
            if [ -n "$file" ]; then
                echo "🔧 Processing: $file"
                if ! generate_svg "$file"; then
                    failed_files+=("$file")
                fi
            fi
        done <<< "$staged_files"

        # Check results
        if [ ${#failed_files[@]} -gt 0 ]; then
            error "Failed to process files:"
            printf '%s\n' "${failed_files[@]}"
            exit 1
        fi

        success "All PlantUML files processed successfully"
    else
        success "No staged .puml files found"
    fi

    # Generate SVGs for PUML files that don't have corresponding SVG files
    echo "🔍 Checking for PUML files without corresponding SVG files..."
    missing_svg_files=$(get_missing_svg_files)

    if [ -n "$missing_svg_files" ]; then
        echo "📄 Found PUML files without SVG files:"
        echo "$missing_svg_files"
        echo

        failed_generation=()
        while IFS= read -r puml_file; do
            if [ -n "$puml_file" ]; then
                echo "🔧 Generating SVG for: $puml_file"
                if ! generate_svg "$puml_file"; then
                    failed_generation+=("$puml_file")
                fi
            fi
        done <<< "$missing_svg_files"

        if [ ${#failed_generation[@]} -gt 0 ]; then
            error "Failed to generate SVGs for:"
            printf '%s\n' "${failed_generation[@]}"
            exit 1
        fi

        success "✅ All missing SVG files generated successfully"
    else
        success "✅ All PUML files have corresponding SVG files"
    fi

    # Fix @startuml directives in all PUML files
    echo "🔧 Checking and fixing @startuml directives..."
    all_puml_files=$(find . -name "*.puml" -type f | grep -v ".git" || true)

    if [ -n "$all_puml_files" ]; then
        fixed_files=()
        while IFS= read -r puml_file; do
            if [ -n "$puml_file" ]; then
                if fix_startuml_directive "$puml_file"; then
                    fixed_files+=("$puml_file")
                fi
            fi
        done <<< "$all_puml_files"

        if [ ${#fixed_files[@]} -gt 0 ]; then
            echo "Fixed @startuml directives in ${#fixed_files[@]} files:"
            printf '  - %s\n' "${fixed_files[@]}"
            # Auto-stage the fixed files
            git add "${fixed_files[@]}"
        else
            success "✅ All @startuml directives are correct"
        fi
    fi

    # Validate all existing SVG files
    echo "🔍 Validating all SVG files in repository..."
    all_svg_files=$(get_all_svg_files)

    if [ -n "$all_svg_files" ]; then
        corrupted_svg_files=()

        # First pass: collect all corrupted SVG files
        while IFS= read -r svg_file; do
            if [ -n "$svg_file" ]; then
                if ! validate_svg "$svg_file" 2>/dev/null; then
                    corrupted_svg_files+=("$svg_file")
                    echo "  ❌ Corrupted: $svg_file"
                fi
            fi
        done <<< "$all_svg_files"

        # Second pass: attempt to regenerate corrupted SVGs
        if [ ${#corrupted_svg_files[@]} -gt 0 ]; then
            echo "🔧 Found ${#corrupted_svg_files[@]} corrupted SVG files, attempting regeneration..."
            echo "Corrupted files found:"
            printf '  - %s\n' "${corrupted_svg_files[@]}"
            echo

            still_corrupted=()
            for svg_file in "${corrupted_svg_files[@]}"; do
                echo "🔄 Attempting to regenerate: $svg_file"
                if regenerate_svg "$svg_file"; then
                    echo "  ✅ Successfully regenerated: $svg_file"
                else
                    echo "  ❌ Failed to regenerate: $svg_file"
                    # Validate again after regeneration attempt
                    if ! validate_svg "$svg_file" 2>/dev/null; then
                        still_corrupted+=("$svg_file")
                    fi
                fi
            done

            # Final report
            if [ ${#still_corrupted[@]} -gt 0 ]; then
                echo
                error "❌ COMMIT BLOCKED - Corrupted SVG files found:"
                echo "=============================================="
                for svg_file in "${still_corrupted[@]}"; do
                    echo "❌ $svg_file"
                    # Show specific validation errors by calling validate_svg and capturing output
                    local validation_output
                    validation_output=$(validate_svg "$svg_file" 2>&1 | grep -E "^\s*-" || echo "  - Validation failed")
                    echo "$validation_output"
                done
                echo
                echo "💡 To fix these issues:"
                echo "  1. Check corresponding .puml files exist and are valid"
                echo "  2. Run: plantuml -tsvg <file>.puml"
                echo "  3. Or delete invalid SVG files if no .puml source exists"
                exit 1
            else
                success "✅ All corrupted SVG files were successfully regenerated"
            fi
        else
            success "✅ All SVG files are valid"
        fi
    else
        success "No SVG files found to validate"
    fi
}

# Run main function
main "$@"
