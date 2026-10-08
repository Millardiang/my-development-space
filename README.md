# My Development Space

A personal workspace for development projects, experiments and prototypes.

This `main` branch doesn't hold any project code. It is the **front door** to the repository: it explains how things are organised and provides the starting point that every new project is created from. Each project lives on its own branch.

---

## How this repository is organised

```
main                      ← you are here: introduction + project starter
├── project/<name>        ← one branch per project
├── project/<name>        
└── experiment/<name>     ← optional: short-lived spikes and throwaway tests
```

| Branch pattern       | Purpose                                                        | Lifetime            |
| -------------------- | -------------------------------------------------------------- | ------------------- |
| `main`               | Introduction, conventions, project template and helper script  | Permanent           |
| `project/<name>`     | A self-contained project with its own code, docs and history   | As long as needed   |
| `experiment/<name>`  | Quick spikes, proofs of concept, things that may be deleted    | Short               |

Project branches are **never merged back into `main`**. They start from `main` so they inherit the shared basics (license, `.gitignore`, `.editorconfig`), then go their own way.

---

## Starting a new project

### Option 1 — helper script (recommended)

From an up-to-date `main`:

```bash
./scripts/new-project.sh "Weather Dashboard"
git push -u origin project/weather-dashboard
```

The script will:

1. Create a branch called `project/<slugified-name>` from `main`
2. Replace this README with a project README built from `project-template/README.md`
3. Remove the `main`-only files (`project-template/`, `scripts/`) from the new branch
4. Make the first commit: `Start project: <name>`

Add `--experiment` to create an `experiment/<name>` branch instead.

> On Windows, run the script from Git Bash or WSL.

### Option 2 — manually

```bash
git switch main
git pull
git switch -c project/my-new-project
cp project-template/README.md README.md      # then edit the placeholders
git rm -r project-template scripts
git add -A
git commit -m "Start project: My New Project"
git push -u origin project/my-new-project
```

---

## Project index

Keep this list up to date as projects come and go.

| Project | Branch | Status | Description |
| ------- | ------ | ------ | ----------- |
| _None yet_ | — | — | — |

Suggested status values: 🟢 Active · 🟡 Paused · ✅ Complete · 🗄️ Archived

---

## Conventions

- **Branch names**: lowercase, hyphen-separated (`project/weather-dashboard`).
- **Commits**: short imperative summary line (`Add login form`, `Fix date parsing`).
- **Each project branch is self-contained**: its README should explain what it is, how to set it up and how to run it.
- **Archiving**: when a project is finished, tag its last commit (e.g. `archive/weather-dashboard`) before deleting the branch, so the history is kept.

  ```bash
  git tag archive/weather-dashboard project/weather-dashboard
  git push origin archive/weather-dashboard
  git push origin --delete project/weather-dashboard
  ```

---

## What's on `main`

| File / folder        | Purpose                                                  |
| -------------------- | -------------------------------------------------------- |
| `README.md`          | This introduction                                        |
| `LICENSE`            | MIT license, inherited by every project branch           |
| `.gitignore`         | Common ignores for OS files, editors, and popular stacks |
| `.gitattributes`     | Consistent line endings across platforms                 |
| `.editorconfig`      | Shared editor formatting defaults                        |
| `project-template/`   | README template used for new projects                    |
| `scripts/`           | Helper script for creating project branches              |

---

## License

Released under the [MIT License](LICENSE) unless a project branch states otherwise.
