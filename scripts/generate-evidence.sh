#!/usr/bin/env bash
#
# generate-evidence.sh - build the four Git CLI evidence files from live data.
#
# Produces:
#   evidence/forked-repo      Task 6: fork metadata (curl + JSON)
#   evidence/bug-fix-revert   Task 8: pull request (curl + JSON)
#   evidence/github-branches  Task 9: branch names and status
#
# evidence/merge_branches (Task 7) is produced by scripts/setup-local-repo.sh
# when the bug-fix-typo branch is merged.
#
# Usage:
#   bash scripts/generate-evidence.sh [github-username] [repo-name]
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

DEFAULT_USER="$(git config user.name 2>/dev/null || true)"
USER="${1:-${GITHUB_USER:-$DEFAULT_USER}}"
REPO="${2:-mcino-Introduction-to-Git-and-GitHub}"

if [ -z "$USER" ]; then
    cat >&2 <<'EOF'
Usage: bash scripts/generate-evidence.sh <github-username> [repo-name]

Example:
  bash scripts/generate-evidence.sh Krushnansh22
EOF
    exit 2
fi

API="https://api.github.com/repos/$USER/$REPO"
mkdir -p evidence
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# ---------------------------------------------------------------------------
# Task 6 - forked-repo
# ---------------------------------------------------------------------------
printf 'Task 6: fetching fork metadata for %s/%s\n' "$USER" "$REPO"
code=$(curl -s -o "$tmp/repo.json" -w '%{http_code}' "$API")
if [ "$code" != "200" ]; then
    cat >&2 <<EOF
GitHub API returned $code for $API

Fork the template first:
  https://github.com/ibm-developer-skills-network/mcino-Introduction-to-Git-and-GitHub/fork

Then run:
  bash scripts/publish.sh $USER $REPO
EOF
    exit 1
fi

{
    echo "# Task 6 - repository fork metadata"
    echo "# The \"fork\": true flag and the \"parent\" object prove that this"
    echo "# repository was forked from"
    echo "# ibm-developer-skills-network/mcino-Introduction-to-Git-and-GitHub."
    echo "\$ curl -s $API"
    cat "$tmp/repo.json"
} > evidence/forked-repo

python3 - "$tmp/repo.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1]))
parent = (d.get("parent") or {}).get("full_name", "<missing>")
print("  full_name :", d.get("full_name"))
print("  fork      :", d.get("fork"))
print("  parent    :", parent)
if d.get("fork") is not True or "mcino-Introduction-to-Git-and-GitHub" not in parent:
    print("  WARNING: this repository is not a fork of the IBM template", file=sys.stderr)
PY

# ---------------------------------------------------------------------------
# Task 8 - bug-fix-revert
# ---------------------------------------------------------------------------
printf '\nTask 8: looking up the bug-fix-revert pull request\n'
curl -s "$API/pulls?state=all&per_page=100" -o "$tmp/pulls.json"

number=$(python3 - "$tmp/pulls.json" <<'PY'
import json, sys
try:
    pulls = json.load(open(sys.argv[1]))
except Exception:
    print("")
    raise SystemExit
if not isinstance(pulls, list):
    print("")
    raise SystemExit
match = [p for p in pulls if (p.get("head") or {}).get("ref") == "bug-fix-revert"]
chosen = (match or pulls or [None])[0]
print(chosen["number"] if chosen else "")
PY
)

if [ -z "$number" ]; then
    cat >&2 <<EOF
No pull request found for the bug-fix-revert branch.

Open one in the browser:
  https://github.com/$USER/$REPO/compare/main...bug-fix-revert?expand=1

Then run this script again.
EOF
    exit 1
fi

curl -s "$API/pulls/$number" -o "$tmp/pr.json"
{
    echo "# Task 8 - pull request for the bug-fix-revert branch"
    echo "# The \"head\" object shows the forked repository the pull request"
    echo "# was created from, and \"base\" shows where it targets."
    echo "\$ curl -s $API/pulls/$number"
    cat "$tmp/pr.json"
} > evidence/bug-fix-revert

python3 - "$tmp/pr.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1]))
head = d.get("head") or {}
base = d.get("base") or {}
print("  html_url :", d.get("html_url"))
print("  state    :", d.get("state"), "| merged:", d.get("merged"))
print("  head     :", (head.get("repo") or {}).get("full_name"), "|", head.get("ref"))
print("  base     :", (base.get("repo") or {}).get("full_name"), "|", base.get("ref"))
PY

# ---------------------------------------------------------------------------
# Task 9 - github-branches
# ---------------------------------------------------------------------------
printf '\nTask 9: writing local branch listing\n'
{
    echo '$ git branch -vv'
    git branch -vv
    echo
    echo '$ git branch -a'
    git branch -a
    echo
    echo '$ git remote -v'
    git remote -v
} > evidence/github-branches

printf '\nEvidence written to evidence/\n'
ls -l evidence/
