#!/usr/bin/env bash
set -e

echo "🔧 SDP Course Development Environment Setup"
echo "============================================="

# PlantUML
PLANTUML_VERSION="1.2024.8"
PLANTUML_DIR="$HOME/.local/share/plantuml"
PLANTUML_JAR="$PLANTUML_DIR/plantuml.jar"

if [ ! -f "$PLANTUML_JAR" ] || [ "$1" == "--force" ]; then
    echo "📦 Installing PlantUML $PLANTUML_VERSION..."
    mkdir -p "$PLANTUML_DIR"
    curl -fsSL "https://github.com/plantuml/plantuml/releases/download/v$PLANTUML_VERSION/plantuml-$PLANTUML_VERSION.jar" \
        -o "$PLANTUML_JAR"
    echo "$PLANTUML_VERSION" > "$PLANTUML_DIR/version"
    echo "✅ PlantUML installed to $PLANTUML_JAR"
else
    echo "✅ PlantUML already installed ($(cat "$PLANTUML_DIR/version" 2>/dev/null || echo 'unknown'))"
fi

# Java check (required for PlantUML)
if ! command -v java >/dev/null 2>&1; then
    echo "⚠️  Java not found. PlantUML requires Java. Install: sudo apt install default-jre"
    exit 1
fi

# Python virtual environment
echo "📦 Setting up Python virtual environment..."
if command -v python3 >/dev/null 2>&1; then
    if [ ! -d ".venv" ]; then
        python3 -m venv .venv
    fi
    source .venv/bin/activate
    python3 -m pip install "pre-commit>=4.0.0" "detect-secrets==1.5.0" --quiet
else
    echo "⚠️  python3 not found. Install Python 3.12+ first."
    exit 1
fi

# Secrets baseline
if [ ! -f ".secrets.baseline" ]; then
    echo "🔒 Creating secrets baseline..."
    detect-secrets scan > .secrets.baseline 2>/dev/null || \
        echo '{"results": {}, "version": "1.5.0"}' > .secrets.baseline
fi

# Pre-commit hooks
echo "🪝 Installing pre-commit hooks..."
pre-commit install
pre-commit install --hook-type commit-msg
echo "✅ Pre-commit hooks installed (pre-commit + commit-msg)"

echo ""
echo "✅ Setup complete!"
echo ""
echo "Hooks installed:"
echo "  - Filesystem checks (trailing whitespace, JSON, merge conflicts)"
echo "  - Secret detection"
echo "  - PlantUML SVG generation"
echo "  - Commit message format validation"
