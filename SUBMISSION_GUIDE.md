# Course 5 — Final Project Submission Guide

**Course:** Getting Started with Git and GitHub
**Assignment:** Final Project: Submission and Evaluation
**Format:** 9 tasks, 20 points, passing grade 80%, unlimited attempts
**Graded by:** AI grader (public GitHub URLs + copied terminal output)

This folder is a complete, working copy of the final-project repository. It
already contains the five required files, the `bug-fix-typo` and
`bug-fix-revert` branches, the merge transcript, and helper scripts.

---

## 1. What gets graded

### Part 1 — GitHub UI (12 points)

| Task | Points | What you submit | File in this folder |
| ---- | ------ | --------------- | ------------------- |
| 1 | 4 | Public URL of `README.md` with the project name details | `README.md` |
| 2 | 2 | Public URL of Apache 2.0 `LICENSE` with 9 required sections | `LICENSE` |
| 3 | 2 | Public URL of `CODE_OF_CONDUCT` with 7 required sections | `CODE_OF_CONDUCT.md` |
| 4 | 2 | Public URL of `CONTRIBUTING.md` with the required sentence | `CONTRIBUTING.md` |
| 5 | 2 | Public URL of `simple-interest.sh` calculator | `simple-interest.sh` |

### Part 2 — Git CLI (8 points)

| Task | Points | What you submit | File in this folder |
| ---- | ------ | --------------- | ------------------- |
| 6 | 2 | `curl` output proving the repo is forked from IBM's template | `evidence/forked-repo` |
| 7 | 2 | `git checkout main` + `git merge bug-fix-typo`, showing **1 file changed** | `evidence/merge_branches` |
| 8 | 2 | `curl` output proving the pull request is valid and shows the fork | `evidence/bug-fix-revert` |
| 9 | 2 | `git branch` output with branch names and status | `evidence/github-branches` |

---

## 2. What is already done

The local repository has this history:

```
* Revert "Merge pull request #1 from bug-fix-revert"     (main)
*   Merge pull request #1 from bug-fix-revert
|\
| * Add troubleshooting section to README               (bug-fix-revert)
|/
* Fix copyright year typo in README footer              (bug-fix-typo)
* Initial commit: Simple Interest Calculator            (main)
```

- `main` — stable branch
- `bug-fix-typo` — changes the README footer from `© 2022` to `© 2023`
- `bug-fix-revert` — adds a troubleshooting section that is merged and then
  reverted on `main`

The merge of `bug-fix-typo` is a fast-forward that changes exactly one file,
which is what Task 7 requires:

```
$ git checkout main
Switched to branch 'main'
$ git merge bug-fix-typo
Updating <old>..<new>
Fast-forward
 README.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
```

Your commit hashes will differ; the graded parts are the two commands and the
`1 file changed` line.

---

## 3. Publish to GitHub (about 3 minutes)

### Fast path

```bash
cd "Getting Started with Git and GitHub"
bash scripts/bootstrap.sh Krushnansh22
```

This walks through the fork, the push, the pull request, the evidence, and the
validator. The manual steps below are the same thing, one command at a time.

### Step 1 — Fork IBM's template

Open this URL and click **Create fork**:

<https://github.com/ibm-developer-skills-network/mcino-Introduction-to-Git-and-GitHub/fork>

Keep the owner as **Krushnansh22** and the repository name as
**mcino-Introduction-to-Git-and-GitHub**. Do not rename it.

> This step is mandatory. Task 6 checks the GitHub API for `"fork": true` and a
> `"parent"` pointing at `ibm-developer-skills-network/mcino-Introduction-to-Git-and-GitHub`.
> A brand-new repository that is not a fork will fail Task 6.

### Step 2 — Push this local repository to the fork

```bash
cd "Getting Started with Git and GitHub"
bash scripts/publish.sh Krushnansh22
```

This adds `origin` over SSH and pushes `main`, `bug-fix-typo`, and
`bug-fix-revert`.

Check that SSH works first if the push is rejected:

```bash
ssh -T git@github.com
```

### Step 3 — Open the pull request for Task 8

```bash
bash scripts/open-pr.sh Krushnansh22
```

The script prints a pre-filled compare URL. Open it, confirm:

- **base:** `main` (your fork)
- **compare:** `bug-fix-revert`
- **title:** `Add troubleshooting section`

then click **Create pull request**. Do not merge it — an open pull request is
valid for Task 8. (Merging is also fine; the API still returns the PR.)

> Open the pull request against **your own fork**, not against IBM's upstream
> repository.

### Step 4 — Generate the real evidence

```bash
bash scripts/generate-evidence.sh Krushnansh22
```

This calls the public GitHub API and rewrites:

- `evidence/forked-repo` — live fork metadata
- `evidence/bug-fix-revert` — live pull request metadata
- `evidence/github-branches` — local branches plus remote tracking

`evidence/merge_branches` is left untouched because it is a historical
transcript captured during the merge.

### Step 5 — Commit the evidence (optional but recommended)

```bash
git add evidence
git commit -m "Add final project Git CLI evidence"
git push
```

### Step 6 — Verify

```bash
bash scripts/validate.sh
```

Expect `0 failed`. The two warnings disappear once the fork and pull request
exist and Step 4 has run.

---

## 4. Copy-paste answers

Replace nothing if your username is `Krushnansh22` and the fork keeps its
default name. Otherwise replace the username in every URL.

### Task 1 — README.md (4 points)

```
https://github.com/Krushnansh22/mcino-Introduction-to-Git-and-GitHub/blob/main/README.md
```

### Task 2 — LICENSE (2 points)

```
https://github.com/Krushnansh22/mcino-Introduction-to-Git-and-GitHub/blob/main/LICENSE
```

### Task 3 — CODE_OF_CONDUCT (2 points)

```
https://github.com/Krushnansh22/mcino-Introduction-to-Git-and-GitHub/blob/main/CODE_OF_CONDUCT.md
```

### Task 4 — CONTRIBUTING.md (2 points)

```
https://github.com/Krushnansh22/mcino-Introduction-to-Git-and-GitHub/blob/main/CONTRIBUTING.md
```

### Task 5 — simple-interest.sh (2 points)

```
https://github.com/Krushnansh22/mcino-Introduction-to-Git-and-GitHub/blob/main/simple-interest.sh
```

### Task 6 — forked-repo (2 points)

Paste the entire contents of `evidence/forked-repo`, including the
`curl` command line. It must contain `"fork": true` and the `"parent"` object.

### Task 7 — merge_branches (2 points)

Paste the entire contents of `evidence/merge_branches`. It must contain:

- `$ git checkout main`
- `$ git merge bug-fix-typo`
- `1 file changed`

### Task 8 — bug-fix-revert (2 points)

Paste the entire contents of `evidence/bug-fix-revert`, including the
`curl` command line. It must contain the `"head"` object with
`"full_name": "Krushnansh22/mcino-Introduction-to-Git-and-GitHub"`.

### Task 9 — github-branches (2 points)

Paste the entire contents of `evidence/github-branches`. It must list
`main`, `bug-fix-typo`, and `bug-fix-revert`.

---

## 5. Rebuilding the repository from scratch

The repository is reproducible. If you break the history:

```bash
bash scripts/setup-local-repo.sh --force
```

This deletes `.git`, recreates the commits and branches, and regenerates
`evidence/merge_branches` and `evidence/github-branches`.

Use a different Git identity if needed:

```bash
GIT_AUTHOR_NAME="Your Name" \
GIT_AUTHOR_EMAIL="you@example.com" \
bash scripts/setup-local-repo.sh --force
```

> Rebuild **before** pushing. Rewriting history after a push requires
> `git push --force`.

---

## 6. Checklist before you submit

- [ ] The fork exists at `https://github.com/Krushnansh22/mcino-Introduction-to-Git-and-GitHub`
- [ ] The fork is public
- [ ] `main` contains `README.md`, `LICENSE`, `CODE_OF_CONDUCT.md`,
      `CONTRIBUTING.md`, `simple-interest.sh`
- [ ] `bug-fix-typo` and `bug-fix-revert` are visible under **Branches**
- [ ] The pull request from `bug-fix-revert` exists
- [ ] `evidence/forked-repo` contains `"fork": true`
- [ ] `evidence/merge_branches` contains `1 file changed`
- [ ] `evidence/bug-fix-revert` contains the `head` repository
- [ ] `evidence/github-branches` lists all three branches
- [ ] `bash scripts/validate.sh` reports `0 failed`
- [ ] All five Part 1 URLs open in a private/incognito window

---

## 7. Troubleshooting

**`git push` says `Permission denied (publickey)`**
Register `~/.ssh/id_ed25519.pub` at <https://github.com/settings/keys>, then run
`ssh -T git@github.com` until you see `Hi <username>!`.

**`Fork not found` from `publish.sh`**
The fork has not been created yet, or the owner/name differs. Create it at the
fork URL in Step 1 and keep the default name.

**Task 6 fails because `"fork": false`**
You created a new repository instead of forking. Delete it, fork the IBM
template, and push again.

**Task 7 fails because "1 file changed" is missing**
The merge was already applied, so Git reports `Already up to date`. Rebuild the
history with `bash scripts/setup-local-repo.sh --force` and re-capture
`evidence/merge_branches`.

**Task 8 says the pull request is invalid**
The PR must come from `bug-fix-revert` and target `main` in your fork. Re-run
`bash scripts/open-pr.sh Krushnansh22` and create the PR from the printed URL.

**The lab environment reset**
The cloud lab is not persistent. Everything here runs locally, so you can redo
the steps at any time.

**GitHub API rate limit**
Unauthenticated requests are limited to 60 per hour. Wait, or export a token:

```bash
export GITHUB_TOKEN=ghp_xxxxxxxx
bash scripts/generate-evidence.sh Krushnansh22
```
