#!/usr/bin/env bash
# Sync labels.yml to rileyedward repos.
# Usage: ./scripts/sync-labels.sh [--repo NAME] [--prune-defaults] [--dry-run]
set -euo pipefail

OWNER="rileyedward"
LABELS_FILE="$(cd "$(dirname "$0")/.." && pwd)/labels.yml"
DRY_RUN=false
PRUNE=false
ONLY_REPO=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true ;;
    --prune-defaults) PRUNE=true ;;
    --repo) ONLY_REPO="$2"; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
  shift
done

command -v gh >/dev/null || { echo "Needs the gh CLI"; exit 1; }
command -v yq >/dev/null || { echo "Needs yq: brew install yq"; exit 1; }

DEFAULTS=("bug" "enhancement" "documentation" "duplicate" "invalid"
          "question" "wontfix" "help wanted" "good first issue")

if [[ -n "$ONLY_REPO" ]]; then
  REPOS="$OWNER/$ONLY_REPO"
else
  REPOS=$(gh repo list "$OWNER" --source --no-archived --limit 500 \
            --json nameWithOwner -q '.[].nameWithOwner')
fi

run() { if $DRY_RUN; then echo "  [dry-run] $*"; else "$@" >/dev/null; fi; }

for repo in $REPOS; do
  echo "→ $repo"
  while IFS=$'\t' read -r name color desc; do
    run gh label create "$name" --repo "$repo" --color "$color" \
      --description "$desc" --force
  done < <(yq -r '.[] | [.name, .color, .description] | @tsv' "$LABELS_FILE")

  if $PRUNE; then
    for l in "${DEFAULTS[@]}"; do
      run gh label delete "$l" --repo "$repo" --yes 2>/dev/null || true
    done
  fi
done
echo "Done."
