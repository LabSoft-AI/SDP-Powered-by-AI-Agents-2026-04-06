#!/usr/bin/env bash
# Validate commit message format: #<issue-number> <type>(<scope>): <description>

COMMIT_MSG_FILE=$1

if [ -z "$COMMIT_MSG_FILE" ] || [ ! -r "$COMMIT_MSG_FILE" ]; then
    echo "❌ Error: expected a readable commit message file as the first argument." >&2
    exit 1
fi

COMMIT_MSG=$(head -n 1 "$COMMIT_MSG_FILE")

# Skip merge commits
if echo "$COMMIT_MSG" | grep -qE "^Merge (branch|pull request)"; then
    exit 0
fi

# Skip revert commits
if echo "$COMMIT_MSG" | grep -qE "^Revert "; then
    exit 0
fi

# Regex pattern: #<number> <type>(<scope>): <description> - scope is MANDATORY
PATTERN="^#[0-9]+ (feat|fix|docs|style|refactor|test|chore|ci|perf)\([a-z0-9-]+\): .+"

if ! echo "$COMMIT_MSG" | grep -qE "$PATTERN"; then
    echo "❌ Invalid commit message format!"
    echo ""
    echo "Expected format:"
    echo "  #<issue-number> <type>(<scope>): <description>"
    echo ""
    echo "Valid types: feat, fix, docs, style, refactor, test, chore, ci, perf"
    echo "Scope is MANDATORY and must be lowercase with hyphens"
    echo ""
    echo "Examples:"
    echo "  #15 feat(auth): add OAuth2 authentication"
    echo "  #23 fix(api): fix email validation"
    echo "  #8 docs(readme): update README with new API endpoints"
    echo "  #42 ci(deployment): add deployment for staging environment"
    echo ""
    echo "Your message:"
    echo "  $COMMIT_MSG"
    exit 1
fi

exit 0
