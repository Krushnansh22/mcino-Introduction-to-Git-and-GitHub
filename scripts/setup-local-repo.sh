#!/usr/bin/env bash
#
# setup-local-repo.sh - rebuild the exact Git history used by the final project.
#
# It creates:
#   main             initial commit, then a fast-forward merge of bug-fix-typo
#   bug-fix-typo     fixes the copyright year in the README footer (2022 -> 2023)
#   bug-fix-revert   adds a troubleshooting section that is later reverted on main
#
# The `git checkout main` + `git merge bug-fix-typo` transcript is captured in
# evidence/merge_branches, which is the file graded in Task 7.
#
# Usage:
#   bash scripts/setup-local-repo.sh [--force]
#
# Environment:
#   GIT_AUTHOR_NAME, GIT_AUTHOR_EMAIL   identity used for the commits
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

force=0
case "${1:-}" in
    --force|-f) force=1 ;;
    -h|--help)
        sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'
        exit 0
        ;;
    "") ;;
    *) echo "Unknown option: $1 (try --help)" >&2; exit 2 ;;
esac

if [ -d .git ]; then
    if [ "$force" -ne 1 ]; then
        echo "A Git repository already exists in:"
        echo "  $ROOT"
        echo "Re-run with --force to delete .git and rebuild the history." >&2
        exit 1
    fi
    rm -rf .git
fi

# Remove stale evidence so it is regenerated from this run.
mkdir -p evidence
rm -f evidence/merge_branches evidence/github-branches

git_name="${GIT_AUTHOR_NAME:-XYZ Developer}"
git_email="${GIT_AUTHOR_EMAIL:-developer@xyz.com}"

# The lab starts from the template README, whose footer says 2022. Make sure the
# initial commit contains that typo so bug-fix-typo has something to fix.
if grep -q '_© 2023 XYZ, Inc._' README.md; then
    sed -i 's/_© 2023 XYZ, Inc._/_© 2022 XYZ, Inc._/' README.md
fi

echo "Initialising repository in $ROOT"
git init -q -b main
git config user.name "$git_name"
git config user.email "$git_email"

# The initial commit mirrors the template repository plus the calculator.
git add README.md LICENSE CODE_OF_CONDUCT.md CONTRIBUTING.md simple-interest.sh .gitignore
git commit -q -m "Initial commit: Simple Interest Calculator"
echo "  main: initial commit"

# ---------------------------------------------------------------------------
# bug-fix-typo: the README footer says 2022, it should say 2023.
# ---------------------------------------------------------------------------
git checkout -q -b bug-fix-typo
if grep -q '_© 2022 XYZ, Inc._' README.md; then
    sed -i 's/_© 2022 XYZ, Inc._/_© 2023 XYZ, Inc._/' README.md
elif grep -q '_© 2023 XYZ, Inc._' README.md; then
    echo "  note: README footer already says 2023"
else
    echo "Could not find the copyright footer in README.md" >&2
    exit 1
fi
git add README.md
git commit -q -m "Fix copyright year typo in README footer"
echo "  bug-fix-typo: fixed footer year"

# ---------------------------------------------------------------------------
# Merge into main and capture the graded transcript for Task 7.
# ---------------------------------------------------------------------------
mkdir -p evidence
{
    echo '$ git checkout main'
    git checkout main 2>&1
    echo '$ git merge bug-fix-typo'
    git merge bug-fix-typo 2>&1
} | tee evidence/merge_branches
echo "  main: merged bug-fix-typo (evidence/merge_branches)"

# ---------------------------------------------------------------------------
# bug-fix-revert: a change that is merged and then reverted on main.
# ---------------------------------------------------------------------------
git checkout -q -b bug-fix-revert
cat >> README.md <<'EOF'

## Troubleshooting

If the script reports `Permission denied`, make it executable first:

```bash
chmod +x simple-interest.sh
```
EOF
git add README.md
git commit -q -m "Add troubleshooting section to README"
echo "  bug-fix-revert: added troubleshooting section"

git checkout -q main
git merge -q --no-ff bug-fix-revert \
    -m "Merge pull request #1 from bug-fix-revert"
git revert --no-edit -m 1 HEAD >/dev/null
echo "  main: merged and reverted pull request #1"

# Commit the tooling, documentation, and merge evidence.
git add -A
if ! git diff --cached --quiet; then
    git commit -q -m "Add submission guide, helper scripts, tests, and merge evidence"
    echo "  main: added project tooling and evidence"
fi

# ---------------------------------------------------------------------------
# Branch listing evidence for Task 9 (a snapshot of the current branch state).
# ---------------------------------------------------------------------------
{
    echo '$ git branch -vv'
    git branch -vv
    echo
    echo '$ git branch -a'
    git branch -a
} > evidence/github-branches

git add evidence/github-branches
if ! git diff --cached --quiet; then
    git commit -q -m "Add branch listing evidence"
fi
echo "  evidence/github-branches written"

echo
echo "History:"
git log --oneline --graph --decorate --all
