#!/usr/bin/env bash
#
# tests/test_simple_interest.sh - regression tests for simple-interest.sh
#
# Run from the repository root:
#   bash tests/test_simple_interest.sh
#
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT/simple-interest.sh"

pass=0
fail=0

check() {
    local name="$1" expected="$2" actual="$3"
    if [ "$expected" = "$actual" ]; then
        printf 'PASS  %s\n' "$name"
        pass=$((pass + 1))
    else
        printf 'FAIL  %s\n      expected: %s\n      actual:   %s\n' "$name" "$expected" "$actual"
        fail=$((fail + 1))
    fi
}

check_contains() {
    local name="$1" needle="$2" haystack="$3"
    if printf '%s' "$haystack" | grep -qF -- "$needle"; then
        printf 'PASS  %s\n' "$name"
        pass=$((pass + 1))
    else
        printf 'FAIL  %s\n      expected to contain: %s\n      actual: %s\n' "$name" "$needle" "$haystack"
        fail=$((fail + 1))
    fi
}

# --- positional arguments ---------------------------------------------------
out=$("$SCRIPT" 1000 5 3)
check "1000 @ 5% for 3 years" "150.00" "$(printf '%s\n' "$out" | awk -F'= ' '/Simple interest/ {print $2}')"

out=$("$SCRIPT" 2500 7.5 2)
check "2500 @ 7.5% for 2 years" "375.00" "$(printf '%s\n' "$out" | awk -F'= ' '/Simple interest/ {print $2}')"

out=$("$SCRIPT" 0.5 10 1)
check "decimal principal" "0.05" "$(printf '%s\n' "$out" | awk -F'= ' '/Simple interest/ {print $2}')"

# --- named arguments --------------------------------------------------------
out=$("$SCRIPT" --principal 1000 --rate 5 --time 3)
check "named arguments" "150.00" "$(printf '%s\n' "$out" | awk -F'= ' '/Simple interest/ {print $2}')"

out=$("$SCRIPT" -p 2000 -r 4 -t 5)
check "short flags" "400.00" "$(printf '%s\n' "$out" | awk -F'= ' '/Simple interest/ {print $2}')"

# --- interactive prompts ----------------------------------------------------
out=$(printf '1000\n5\n3\n' | "$SCRIPT")
check "interactive prompts" "150.00" "$(printf '%s\n' "$out" | awk -F'= ' '/Simple interest/ {print $2}')"

# --- total amount -----------------------------------------------------------
out=$("$SCRIPT" 1000 5 3)
check_contains "total amount" "Total amount = 1150.00" "$out"

# --- help -------------------------------------------------------------------
out=$("$SCRIPT" --help)
check_contains "help mentions usage" "Usage:" "$out"
check_contains "help lists principal" "--principal" "$out"

# --- validation -------------------------------------------------------------
"$SCRIPT" abc 5 3 >/dev/null 2>&1
check "rejects non-numeric principal" "1" "$?"

"$SCRIPT" -1000 5 3 >/dev/null 2>&1
check "rejects negative principal" "1" "$?"

"$SCRIPT" 1000 -5 3 >/dev/null 2>&1
check "rejects negative rate" "1" "$?"

"$SCRIPT" 1000 5 -3 >/dev/null 2>&1
check "rejects negative time" "1" "$?"

"$SCRIPT" 1000 5 >/dev/null 2>&1 </dev/null
check "rejects missing time" "1" "$?"

"$SCRIPT" --bogus >/dev/null 2>&1
check "rejects unknown option" "2" "$?"

# --- syntax -----------------------------------------------------------------
bash -n "$SCRIPT"
check "script passes bash -n" "0" "$?"

printf '\n%d passed, %d failed\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
