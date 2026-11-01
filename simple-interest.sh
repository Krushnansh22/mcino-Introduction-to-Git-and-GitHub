#!/usr/bin/env bash
#
# simple-interest.sh - Simple Interest Calculator
#
# Computes simple interest from a principal amount, an annual rate of
# interest, and a time period in years.
#
#   Simple Interest = (Principal x Rate x Time) / 100
#
# Usage:
#   ./simple-interest.sh                     # interactive prompts
#   ./simple-interest.sh 1000 5 3            # positional arguments
#   ./simple-interest.sh -p 1000 -r 5 -t 3   # named arguments
#   ./simple-interest.sh --help
#
# Exit codes:
#   0  success
#   1  invalid input
#   2  usage error
#
set -euo pipefail

PROGRAM="$(basename "$0")"

usage() {
    cat <<EOF
Usage: $PROGRAM [OPTIONS] [PRINCIPAL RATE TIME]

Compute simple interest: (principal x rate x time) / 100

Arguments:
  PRINCIPAL   Principal amount (must be > 0)
  RATE        Annual rate of interest in percent (must be >= 0)
  TIME        Time period in years (must be >= 0)

Options:
  -p, --principal VALUE   Principal amount
  -r, --rate VALUE        Annual rate of interest in percent
  -t, --time VALUE        Time period in years
  -h, --help              Show this help message and exit

Examples:
  $PROGRAM
  $PROGRAM 1000 5 3
  $PROGRAM --principal 2500 --rate 7.5 --time 2
EOF
}

die() {
    printf 'Error: %s\n' "$1" >&2
    exit "${2:-1}"
}

# Validate that a value is a non-negative decimal number.
is_non_negative_number() {
    awk -v v="$1" 'BEGIN {
        if (v ~ /^[0-9]+([.][0-9]+)?$/ || v ~ /^[.][0-9]+$/) exit 0
        exit 1
    }'
}

# Validate that a value is a strictly positive decimal number.
is_positive_number() {
    awk -v v="$1" 'BEGIN {
        if ((v ~ /^[0-9]+([.][0-9]+)?$/ || v ~ /^[.][0-9]+$/) && v + 0 > 0) exit 0
        exit 1
    }'
}

principal=""
rate=""
time=""

# ---- Parse arguments -------------------------------------------------------
positional=()
while [ "$#" -gt 0 ]; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        -p|--principal)
            [ "$#" -ge 2 ] || die "option $1 requires a value" 2
            principal="$2"
            shift 2
            ;;
        -r|--rate)
            [ "$#" -ge 2 ] || die "option $1 requires a value" 2
            rate="$2"
            shift 2
            ;;
        -t|--time)
            [ "$#" -ge 2 ] || die "option $1 requires a value" 2
            time="$2"
            shift 2
            ;;
        --)
            shift
            while [ "$#" -gt 0 ]; do positional+=("$1"); shift; done
            ;;
        -[0-9]*|-[.]*)
            # Negative numbers are values, not options, so they can be
            # rejected later by validation with a clear message.
            positional+=("$1")
            shift
            ;;
        -*)
            die "unknown option: $1 (try --help)" 2
            ;;
        *)
            positional+=("$1")
            shift
            ;;
    esac
done

# Positional arguments fill whichever values were not supplied by flags.
if [ "${#positional[@]}" -gt 0 ]; then
    [ "${#positional[@]}" -le 3 ] || die "too many arguments (try --help)" 2
    idx=0
    for value in "${positional[@]}"; do
        case "$idx" in
            0) [ -n "$principal" ] || principal="$value" ;;
            1) [ -n "$rate" ]      || rate="$value" ;;
            2) [ -n "$time" ]      || time="$value" ;;
        esac
        idx=$((idx + 1))
    done
fi

# ---- Interactive prompts for anything still missing ------------------------
if [ -z "$principal" ]; then
    read -r -p "Enter the principal amount: " principal || die "no principal supplied"
fi
if [ -z "$rate" ]; then
    read -r -p "Enter the annual rate of interest (%): " rate || die "no rate supplied"
fi
if [ -z "$time" ]; then
    read -r -p "Enter the time period in years: " time || die "no time supplied"
fi

# ---- Validate --------------------------------------------------------------
is_positive_number "$principal" \
    || die "principal must be a number greater than 0 (got '$principal')"
is_non_negative_number "$rate" \
    || die "rate of interest must be a non-negative number (got '$rate')"
is_non_negative_number "$time" \
    || die "time period must be a non-negative number (got '$time')"

# ---- Compute ---------------------------------------------------------------
interest=$(awk -v p="$principal" -v r="$rate" -v t="$time" \
    'BEGIN { printf "%.2f", (p * r * t) / 100 }')
total=$(awk -v p="$principal" -v i="$interest" \
    'BEGIN { printf "%.2f", p + i }')

printf 'Principal amount: %s\n' "$principal"
printf 'Annual rate of interest: %s%%\n' "$rate"
printf 'Time period: %s year(s)\n' "$time"
printf 'Simple interest = %s\n' "$interest"
printf 'Total amount = %s\n' "$total"
