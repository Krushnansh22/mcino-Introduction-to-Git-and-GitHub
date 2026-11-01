#!/usr/bin/env bash
#
# open-pr.sh - open the pull request used for Task 8 (bug-fix-revert).
#
# GitHub does not allow opening a pull request from the command line without an
# API token, so this script prints a pre-filled compare URL. Open it, click
# "Create pull request", then run scripts/generate-evidence.sh.
#
# If GITHUB_TOKEN is set, the pull request is created through the REST API.
#
# Usage:
#   bash scripts/open-pr.sh [github-username] [repo-name]
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

DEFAULT_USER="$(git config user.name 2>/dev/null || true)"
USER="${1:-${GITHUB_USER:-$DEFAULT_USER}}"
REPO="${2:-mcino-Introduction-to-Git-and-GitHub}"

if [ -z "$USER" ]; then
    echo "Usage: bash scripts/open-pr.sh <github-username> [repo-name]" >&2
    exit 2
fi

COMPARE="https://github.com/$USER/$REPO/compare/main...bug-fix-revert?expand=1"

if [ -n "${GITHUB_TOKEN:-}" ]; then
    echo "Creating pull request through the GitHub API..."
    response=$(curl -s -X POST \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github+json" \
        "https://api.github.com/repos/$USER/$REPO/pulls" \
        -d "{\"title\":\"Add troubleshooting section\",\"head\":\"bug-fix-revert\",\"base\":\"main\"}")

    url=$(printf '%s' "$response" | python3 -c \
        'import json,sys; print(json.load(sys.stdin).get("html_url",""))' 2>/dev/null || true)

    if [ -n "$url" ]; then
        echo "Pull request created: $url"
        exit 0
    fi
    echo "API creation failed, falling back to the web URL." >&2
    printf '%s\n' "$response" >&2
fi

cat <<EOF
Open this URL in your browser and click "Create pull request":

  $COMPARE

Title: Add troubleshooting section
Base:  main
Head:  bug-fix-revert

Then generate the Task 8 evidence:

  bash scripts/generate-evidence.sh $USER $REPO
EOF
