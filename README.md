# .github

Shared issue templates and labels for my repos.

## Overview

### What is .github?

This is the account-wide default repository for `rileyedward`. It holds the Feature, Bug and Task issue templates, which GitHub applies automatically to any repo that doesn't have its own `.github/ISSUE_TEMPLATE` folder, so no commits are made to other repos. It is also the single source of truth for the labels shared across those repos, which are kept in `labels.yml` and copied out with a sync script.

## Getting Started

### Prerequisites

The issue templates need nothing installed. Syncing labels needs the tools below. You can verify each installation by running the provided commands in your terminal.

1. **GitHub CLI** is required to read your repos and write labels, and must be signed in. Check it by running:

   ```bash
   gh auth status
   ```

2. **yq** is needed to read `labels.yml`. Verify its installation with:

   ```bash
   yq --version
   ```

### Syncing Labels

1. Edit `labels.yml` to add, rename or recolor a label.

2. Preview the changes without touching any repo:

   ```bash
   ./scripts/sync-labels.sh --dry-run
   ```

3. Sync the labels to every repo, or to a single one:

   ```bash
   ./scripts/sync-labels.sh
   ./scripts/sync-labels.sh --repo NAME
   ```

Add `--prune-defaults` to remove GitHub's default labels (`bug`, `enhancement` and so on). This also strips them from existing issues.

## Issue Templates

The templates live in `.github/ISSUE_TEMPLATE` and blank issues are turned off. There is one rule: every template's `## Done when` checklist is the definition of done. Everything else is freeform.

## Project Board

Issues are pulled onto the Dispatch project board (user project #7) manually, not automatically.
