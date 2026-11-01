#!/usr/bin/env bash
#
# publish.sh - push the local repository to your GitHub fork.
#
# Prerequisites:
#   1. Fork the IBM template on GitHub (one click):
#      https://github.com/ibm-developer-skills-network/mcino-Introduction-to-Git-and-GitHub/fork
#   2. Make sure your SSH key is registered with GitHub:
#      ssh -T git@github.com
#
# Usage:
#   bash scripts/publish.sh [github-username] [repo-name]
#
# Example:
#   bash scripts/publish.sh Krushnansh22
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

DEFAULT_USER="$(git config user.name 2>/dev/null || true)"
USER="${1:-${GITHUB_USER:-$DEFAULT_USER}}"
REPO="${2:-mcino-Introduction-to-Git-and-GitHub}"

if [ -z "$USER" ]; then
    echo "Usage: bash scripts/publish.sh <github-username> [repo-name]" >&2
    exit 2
fi

API="https://api.github.com/repos/$USER/$REPO"
REMOTE="git@github.com:$USER/$REPO.git"

echo "Checking for fork: $USER/$REPO"
status=$(curl -s -o /dev/null -w '%{http_code}' "$API")
if [ "$status" != "200" ]; then
    cat >&2 <<EOF
Fork not found (GitHub API returned $status).

Create it first - it takes one click:
  https://github.com/ibm-developer-skills-network/mcino-Introduction-to-Git-and-GitHub/fork

Choose the owner "$USER" and keep the repository name "$REPO",
then run this script again.
EOF
    exit 1
fi

echo "Configuring origin -> $REMOTE"
git remote remove origin 2>/dev/null || true
git remote add origin "$REMOTE"

echo "Pushing main"
git push -u origin main

echo "Pushing bug-fix-typo"
git push origin bug-fix-typo

echo "Pushing bug-fix-revert"
git push origin bug-fix-revert

echo
echo "Done. Public repository:"
echo "  https://github.com/$USER/$REPO"
echo
echo "Next: open the pull request for bug-fix-revert"
echo "  bash scripts/open-pr.sh $USER $REPO"
