#!/usr/bin/env bash
#
# bootstrap.sh - guided end-to-end publish for the Course 5 final project.
#
# It walks through the only two steps that need a browser (creating the fork
# and opening the pull request), then pushes, generates the evidence, and runs
# the validator.
#
# Usage:
#   bash scripts/bootstrap.sh [github-username] [repo-name]
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

DEFAULT_USER="$(git config user.name 2>/dev/null || true)"
USER="${1:-${GITHUB_USER:-$DEFAULT_USER}}"
REPO="${2:-mcino-Introduction-to-Git-and-GitHub}"

if [ -z "$USER" ]; then
    echo "Usage: bash scripts/bootstrap.sh <github-username> [repo-name]" >&2
    exit 2
fi

FORK_URL="https://github.com/ibm-developer-skills-network/mcino-Introduction-to-Git-and-GitHub/fork"

echo "============================================================"
echo " Step 1 of 3 - fork the IBM template"
echo "============================================================"
echo
echo "  $FORK_URL"
echo
echo "Keep the owner '$USER' and the name '$REPO'."
if [ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ] && command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$FORK_URL" >/dev/null 2>&1 || true
fi
read -r -p "Press Enter when the fork exists... " _ || true

echo
echo "============================================================"
echo " Step 2 of 3 - push and open the pull request"
echo "============================================================"
bash scripts/publish.sh "$USER" "$REPO"
echo
bash scripts/open-pr.sh "$USER" "$REPO"
read -r -p "Press Enter when the pull request is created... " _ || true

echo
echo "============================================================"
echo " Step 3 of 3 - generate and validate the evidence"
echo "============================================================"
bash scripts/generate-evidence.sh "$USER" "$REPO"
echo
bash scripts/validate.sh
