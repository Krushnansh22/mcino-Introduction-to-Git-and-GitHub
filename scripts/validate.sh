#!/usr/bin/env bash
#
# validate.sh - check every graded item for the Course 5 final project.
#
# Usage:
#   bash scripts/validate.sh
#
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

pass=0
fail=0
warn=0

ok()   { printf 'PASS  %s\n' "$1"; pass=$((pass + 1)); }
bad()  { printf 'FAIL  %s\n      %s\n' "$1" "${2:-}"; fail=$((fail + 1)); }
note() { printf 'WARN  %s\n      %s\n' "$1" "${2:-}"; warn=$((warn + 1)); }

has() {
    local name="$1" file="$2" needle="$3"
    if [ -f "$file" ] && grep -qF -- "$needle" "$file"; then
        ok "$name"
    else
        bad "$name" "missing '$needle' in $file"
    fi
}

# ---------------------------------------------------------------------------
# Part 1 - required files
# ---------------------------------------------------------------------------
for f in README.md LICENSE CODE_OF_CONDUCT.md CONTRIBUTING.md simple-interest.sh; do
    if [ -f "$f" ]; then ok "file exists: $f"; else bad "file exists: $f" "not found"; fi
done

# Task 1: README contains the project name details
has "README: project name"        README.md "Simple Interest Calculator"
has "README: principal field"     README.md "principal"
has "README: rate field"          README.md "rate"
has "README: time field"          README.md "time period"
has "README: formula"             README.md "Simple Interest ="

# Task 2: Apache 2.0 license with the nine required topics
has "LICENSE: Apache 2.0"         LICENSE "Apache License"
has "LICENSE: Version 2.0"        LICENSE "Version 2.0"
for section in \
    "Definitions" \
    "Grant of Copyright License" \
    "Grant of Patent License" \
    "Redistribution" \
    "Submission of Contributions" \
    "Trademarks" \
    "Disclaimer of Warranty" \
    "Limitation of Liability" \
    "Accepting Warranty or Additional Liability"
do
    has "LICENSE section: $section" LICENSE "$section"
done

# Task 3: Code of Conduct with the seven required sections
has "COC: title"                  CODE_OF_CONDUCT.md "Contributor Covenant"
for section in \
    "Our Pledge" \
    "Our Standards" \
    "Enforcement Responsibilities" \
    "Scope" \
    "Enforcement" \
    "Enforcement Guidelines" \
    "Attribution"
do
    has "COC section: $section" CODE_OF_CONDUCT.md "## $section"
done

# Task 4: contributing sentence
has "CONTRIBUTING: required sentence" CONTRIBUTING.md \
    "All contributions, bug reports, bug fixes, documentation improvements, enhancements, and ideas are welcome."

# Task 5: calculator script
has "script: shebang"             simple-interest.sh "#!/usr/bin/env bash"
has "script: principal"           simple-interest.sh "principal"
has "script: rate"                simple-interest.sh "rate"
has "script: time"                simple-interest.sh "time"
has "script: interest formula"    simple-interest.sh "(p * r * t) / 100"
if [ -x simple-interest.sh ]; then ok "script: executable"; else bad "script: executable" "chmod +x simple-interest.sh"; fi

# ---------------------------------------------------------------------------
# Part 2 - evidence files
# ---------------------------------------------------------------------------
for f in forked-repo merge_branches bug-fix-revert github-branches; do
    if [ -f "evidence/$f" ]; then ok "evidence exists: $f"; else bad "evidence exists: $f" "not found"; fi
done

has "merge_branches: checkout main"  evidence/merge_branches "git checkout main"
has "merge_branches: merge bug-fix-typo" evidence/merge_branches "git merge bug-fix-typo"
has "merge_branches: 1 file changed" evidence/merge_branches "1 file changed"

has "github-branches: main"           evidence/github-branches "main"
has "github-branches: bug-fix-typo"   evidence/github-branches "bug-fix-typo"
has "github-branches: bug-fix-revert" evidence/github-branches "bug-fix-revert"

if grep -q 'NOT GENERATED YET' evidence/forked-repo 2>/dev/null; then
    note "forked-repo: not generated yet" "run: bash scripts/generate-evidence.sh Krushnansh22"
elif grep -qE '^  "fork": true' evidence/forked-repo 2>/dev/null; then
    ok "forked-repo: fork flag present"
else
    bad "forked-repo: fork flag missing" "expected a live \"fork\": true field"
fi

if grep -q 'NOT GENERATED YET' evidence/bug-fix-revert 2>/dev/null; then
    note "bug-fix-revert: not generated yet" "open the PR, then run scripts/generate-evidence.sh"
elif grep -qE '^  "head": \{' evidence/bug-fix-revert 2>/dev/null; then
    ok "bug-fix-revert: pull request JSON present"
else
    bad "bug-fix-revert: pull request JSON missing" "expected a live \"head\" object"
fi

# ---------------------------------------------------------------------------
# Git state
# ---------------------------------------------------------------------------
if git rev-parse --git-dir >/dev/null 2>&1; then
    ok "git repository initialised"
    for branch in main bug-fix-typo bug-fix-revert; do
        if git show-ref --verify --quiet "refs/heads/$branch"; then
            ok "branch exists: $branch"
        else
            bad "branch exists: $branch" "run scripts/setup-local-repo.sh --force"
        fi
    done
    if git log --oneline main | grep -q 'Revert'; then
        ok "main contains a revert commit"
    else
        bad "main contains a revert commit" "expected the bug-fix-revert change to be reverted"
    fi
else
    bad "git repository initialised" "run scripts/setup-local-repo.sh"
fi

# ---------------------------------------------------------------------------
# Scripts and tests
# ---------------------------------------------------------------------------
for script in simple-interest.sh scripts/*.sh tests/*.sh; do
    if bash -n "$script" 2>/dev/null; then
        ok "bash -n: $script"
    else
        bad "bash -n: $script" "syntax error"
    fi
done

if bash tests/test_simple_interest.sh >/tmp/course5-tests.log 2>&1; then
    ok "calculator tests"
else
    bad "calculator tests" "see /tmp/course5-tests.log"
fi

printf '\n%d passed, %d failed, %d warnings\n' "$pass" "$fail" "$warn"
[ "$fail" -eq 0 ]
