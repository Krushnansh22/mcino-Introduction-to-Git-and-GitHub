# Final Project — Ready-to-Paste Answers

Course: **Getting Started with Git and GitHub**
Fork: `Krushnansh22/mcino-Introduction-to-Git-and-GitHub`

> Tasks 1–5 work as soon as the fork exists.
> Tasks 6, 8 and 9 need `bash scripts/generate-evidence.sh Krushnansh22` to have
> been run after the fork was pushed and the pull request was opened.

---

## Part 1 — GitHub UI (12 points)

### Task 1 — README.md URL (4 points)

```
https://github.com/Krushnansh22/mcino-Introduction-to-Git-and-GitHub/blob/main/README.md
```

### Task 2 — LICENSE URL (2 points)

```
https://github.com/Krushnansh22/mcino-Introduction-to-Git-and-GitHub/blob/main/LICENSE
```

### Task 3 — CODE_OF_CONDUCT URL (2 points)

```
https://github.com/Krushnansh22/mcino-Introduction-to-Git-and-GitHub/blob/main/CODE_OF_CONDUCT.md
```

### Task 4 — CONTRIBUTING.md URL (2 points)

```
https://github.com/Krushnansh22/mcino-Introduction-to-Git-and-GitHub/blob/main/CONTRIBUTING.md
```

### Task 5 — simple-interest.sh URL (2 points)

```
https://github.com/Krushnansh22/mcino-Introduction-to-Git-and-GitHub/blob/main/simple-interest.sh
```

---

## Part 2 — Git CLI (8 points)

### Task 6 — forked-repo (2 points)

Open `evidence/forked-repo` and paste everything. It looks like this once
generated:

```
$ curl -s https://api.github.com/repos/Krushnansh22/mcino-Introduction-to-Git-and-GitHub
{
  "id": 1234567890,
  "name": "mcino-Introduction-to-Git-and-GitHub",
  "full_name": "Krushnansh22/mcino-Introduction-to-Git-and-GitHub",
  "private": false,
  "html_url": "https://github.com/Krushnansh22/mcino-Introduction-to-Git-and-GitHub",
  "fork": true,
  "parent": {
    "id": 1050225087,
    "name": "mcino-Introduction-to-Git-and-GitHub",
    "full_name": "ibm-developer-skills-network/mcino-Introduction-to-Git-and-GitHub",
    "html_url": "https://github.com/ibm-developer-skills-network/mcino-Introduction-to-Git-and-GitHub"
  },
  ...
}
```

> The values above are illustrative. Always paste the file produced by
> `scripts/generate-evidence.sh`, not this example.

### Task 7 — merge_branches (2 points)

Paste the contents of `evidence/merge_branches`:

```
$ git checkout main
Switched to branch 'main'
$ git merge bug-fix-typo
Updating <old>..<new>
Fast-forward
 README.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
```

### Task 8 — bug-fix-revert (2 points)

Open `evidence/bug-fix-revert` and paste everything. It contains the pull
request JSON with:

```
"head": {
  "ref": "bug-fix-revert",
  "repo": {
    "full_name": "Krushnansh22/mcino-Introduction-to-Git-and-GitHub"
  }
},
"base": {
  "ref": "main",
  "repo": {
    "full_name": "Krushnansh22/mcino-Introduction-to-Git-and-GitHub"
  }
}
```

### Task 9 — github-branches (2 points)

Paste the contents of `evidence/github-branches`:

```
$ git branch -vv
  bug-fix-revert <hash> Add troubleshooting section to README
  bug-fix-typo   <hash> Fix copyright year typo in README footer
* main           <hash> Revert "Merge pull request #1 from bug-fix-revert"

$ git branch -a
  bug-fix-revert
  bug-fix-typo
* main
```

---

## Point total

| Part | Tasks | Points |
| ---- | ----- | ------ |
| GitHub UI | 1–5 | 12 |
| Git CLI | 6–9 | 8 |
| **Total** | **9** | **20** |

Passing grade is 80% (16/20). With every item above you score 20/20.
