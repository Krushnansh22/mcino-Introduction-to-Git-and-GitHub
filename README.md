# Simple Interest Calculator

A Bash command-line calculator that computes **simple interest** from three
inputs: the **principal amount**, the **annual rate of interest**, and the
**time period in years**.

This repository is the final project for the Coursera course
**Getting Started with Git and GitHub** (IBM DevOps and Software Engineering
Professional Certificate).

## Project name

**Simple Interest Calculator** (`simple-interest.sh`)

## What the calculator does

Simple interest is the interest charged on the original principal only. It does
not compound. The calculator applies the standard formula:

```
Simple Interest = (Principal x Rate x Time) / 100
```

where:

| Symbol | Meaning                    | Unit    |
| ------ | -------------------------- | ------- |
| `p`    | Principal amount           | currency |
| `r`    | Annual rate of interest    | percent  |
| `t`    | Time period                | years    |

The amount payable at the end of the period is `Principal + Simple Interest`.

## Input fields

```
Input:
   p, principal amount
   r, annual rate of interest
   t, time period in years
Output:
   simple interest = p * r * t / 100
```

## Usage

Run the script and answer the three prompts:

```bash
chmod +x simple-interest.sh
./simple-interest.sh
```

```
Enter the principal amount: 1000
Enter the annual rate of interest (%): 5
Enter the time period in years: 3
Simple interest = 150.00
```

You can also pass the three values as arguments (useful for scripting and
tests):

```bash
./simple-interest.sh 1000 5 3
# Simple interest = 150.00

./simple-interest.sh --principal 2500 --rate 7.5 --time 2
# Simple interest = 375.00
```

Show help:

```bash
./simple-interest.sh --help
```

## Input validation

The script rejects anything that is not a non-negative number, rejects a zero or
negative principal, and exits with a non-zero status on bad input. This keeps
the calculator safe to call from other scripts.

## Repository contents

| File                 | Purpose                                              |
| -------------------- | ---------------------------------------------------- |
| `simple-interest.sh` | The calculator script                                |
| `README.md`          | Project name, description, inputs, and usage         |
| `LICENSE`            | Apache License 2.0                                   |
| `CODE_OF_CONDUCT.md` | Contributor Covenant Code of Conduct                 |
| `CONTRIBUTING.md`    | How to contribute to the project                     |
| `scripts/`           | Helper scripts to publish and reproduce the lab      |
| `tests/`             | Shell tests for the calculator                       |
| `evidence/`          | Git CLI terminal outputs required by the final project |

## Branches used in the final project

| Branch            | Purpose                                                        |
| ----------------- | -------------------------------------------------------------- |
| `main`            | Stable line of development                                     |
| `bug-fix-typo`    | Fixes the copyright year typo in the README footer (2022 → 2023) |
| `bug-fix-revert`  | Demonstrates opening a pull request and then reverting it      |

## Troubleshooting

**The calculator rejects my input**
Use non-negative numbers only, and a principal greater than zero. The script
prints a short error message and exits with a non-zero status on bad input.

**Permission denied when running the script**
Make it executable first: `chmod +x simple-interest.sh`.

**The merge says "Already up to date"**
The branch was already merged. This is expected after `bug-fix-typo` has been
merged into `main`.

## Contributing

Read `CONTRIBUTING.md`. All contributions, bug reports, bug fixes,
documentation improvements, enhancements, and ideas are welcome.

## License

Licensed under the **Apache License 2.0**. See `LICENSE`.

_© 2023 XYZ, Inc._
