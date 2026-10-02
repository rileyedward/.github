# .github

Account-wide default issue templates plus shared labels for `rileyedward` repos.

## Issue templates

Three templates: **Feature**, **Bug**, and **Task**. They apply automatically to
any repo that doesn't have its own `.github/ISSUE_TEMPLATE` folder. No commits
are made to other repos.

## The one rule

Every template's `## Done when` checklist is the definition of done. Everything
else is freeform.

## Labels

`labels.yml` is the source of truth. To change labels, edit it, then sync:

```bash
./scripts/sync-labels.sh              # all repos
./scripts/sync-labels.sh --repo NAME  # one repo
```

- `--dry-run` prints what would run without changing anything.
- `--prune-defaults` removes GitHub's default labels, which also strips them
  from existing issues.

## Project board

Issues are pulled onto the Dispatch project board (user project #7) manually,
not automatically.
