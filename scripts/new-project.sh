#!/usr/bin/env bash
#
# new-project.sh — create a new project (or experiment) branch from main.
#
# Usage:
#   ./scripts/new-project.sh "Project Name"
#   ./scripts/new-project.sh --experiment "Quick Spike"
#
# The new branch:
#   - is named project/<slug> (or experiment/<slug>)
#   - gets a README built from project-template/README.md
#   - drops the main-only files (project-template/, scripts/)
#   - starts with one commit: "Start project: <name>"

set -euo pipefail

prefix="project"
name=""

for arg in "$@"; do
  case "$arg" in
    --experiment) prefix="experiment" ;;
    -h|--help)
      sed -n '3,14p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) name="$arg" ;;
  esac
done

if [[ -z "$name" ]]; then
  echo "Error: please give the project a name." >&2
  echo "Usage: $0 [--experiment] \"Project Name\"" >&2
  exit 1
fi

# Run from the repository root
repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "Error: not inside a git repository." >&2
  exit 1
}
cd "$repo_root"

# Must start from a clean main
current_branch="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$current_branch" != "main" ]]; then
  echo "Error: switch to main first (currently on '$current_branch')." >&2
  exit 1
fi
if [[ -n "$(git status --porcelain)" ]]; then
  echo "Error: main has uncommitted changes. Commit or stash them first." >&2
  exit 1
fi

# Slugify: lowercase, non-alphanumerics to hyphens, trim hyphens
slug="$(printf '%s' "$name" \
  | tr '[:upper:]' '[:lower:]' \
  | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"

if [[ -z "$slug" ]]; then
  echo "Error: '$name' doesn't produce a usable branch name." >&2
  exit 1
fi

branch="$prefix/$slug"

if git show-ref --verify --quiet "refs/heads/$branch"; then
  echo "Error: branch '$branch' already exists." >&2
  exit 1
fi

template="project-template/README.md"
if [[ ! -f "$template" ]]; then
  echo "Error: $template not found on main." >&2
  exit 1
fi

git switch -c "$branch"

# Build the project README from the template
today="$(date +%Y-%m-%d)"
# Escape characters that are special in sed replacements
safe_name="$(printf '%s' "$name" | sed -e 's/[\/&|]/\\&/g')"
sed -e "s|{{PROJECT_NAME}}|$safe_name|g" \
    -e "s|{{BRANCH}}|$branch|g" \
    -e "s|{{DATE}}|$today|g" \
    "$template" > README.md

# Remove main-only files from the project branch
git rm -r --quiet project-template scripts

git add -A
git commit --quiet -m "Start project: $name"

echo
echo "Created branch '$branch'."
echo "Next steps:"
echo "  1. Edit README.md to describe the project"
echo "  2. git push -u origin $branch"
echo "  3. Add the project to the index in main's README"
