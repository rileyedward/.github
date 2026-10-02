# Agent Guide

How to work a ticket from my Dispatch board. Read this in full before starting any issue.

The short version: read the ticket, make every **Done when** item true, verify it, push a branch linked to the issue, and report back in a comment. No pull requests — I review branches locally.

## Before you start

1. **Read the whole issue, including every comment.** Later comments override the original description — that's how I clarify or ask for changes.
2. **Check the labels and stop if needed:**
   - `blocked` → don't start. Report back that it's blocked.
   - `needs-info` → don't start. My answers haven't arrived yet.
   - `security` → you may work it, but flag it for close review when you finish (see Finishing).
3. **Check the Autonomy field on the board:**
   - `Agent` → work it end to end.
   - `Agent draft` → work it, but flag anything unfinished or uncertain for me to complete.
   - `Human` → don't start.
4. **Read the repo's `CLAUDE.md`** for setup, test commands, and conventions.
5. **Check for an existing branch.** If the issue already has a linked branch (`gh issue develop --list <number>`), continue on that branch instead of creating a new one — it means I sent the work back with feedback in the comments.

## Reading the ticket

- **`## Done when` is the definition of done.** Every box must be true before you finish. If you can't make one true, that's a blocker (see When you're stuck), not something to skip.
- **Everything else is context.** I write loosely and think out loud. Treat brain-dump sections as intent and background, not a spec. If the rambling and Done when disagree, Done when wins.
- **Anything in Notes marked "don't touch," "leave alone," "out of scope," or similar is a hard rule.**
- I may add my own `##` sections. Read them all; they're there for a reason.

## By ticket type

- **`type:feature`** — Build what Done when describes. Follow existing patterns in the codebase rather than inventing new ones.
- **`type:bug`** — **First** write a test that reproduces the bug and fails. Then fix it and show the test passes. If you can't reproduce it, stop and ask.
- **`type:task`** — If the ticket says behavior must not change, existing tests must pass **without modification**. Needing to change a test to make it pass means something's wrong — stop and ask.

## While working

- Create the branch **linked to the issue**, then work in its own worktree:
  ```bash
  gh issue develop <number> --name issue-<number>-<short-slug>
  git fetch origin
  git worktree add ../<repo>-issue-<number> issue-<number>-<short-slug>
  ```
  (If continuing an existing branch, skip `gh issue develop` and just add the worktree for it.)
- Move the card to **In Progress**.
- Stay in scope. Note unrelated problems you find in your final comment; don't fix them.
- Don't add dependencies unless the ticket calls for it.
- Database: add new migrations only. Never edit existing ones.
- Make small, clear commits.

## When you're stuck

If the ticket is ambiguous, contradictory, or you can't meet a Done when item:

1. Push whatever useful work you have to the branch.
2. Comment on the issue with **specific** questions — offer options where possible ("A or B?").
3. Add the `needs-info` label.
4. Move the card back to **Backlog**.
5. Stop. Don't guess on anything that would be expensive to undo.

## Verifying

Before finishing:

- Run the test, lint, and type-check commands from `CLAUDE.md`. All must pass.
- Check every Done when item yourself, including manual checks where possible.
- Review your own diff once more against the ticket and the Notes constraints.

## Finishing

1. Push the branch: `git push origin issue-<number>-<short-slug>`
2. **Remove your worktree** (`git worktree remove ../<repo>-issue-<number>`) so I can check the branch out in my main working copy.
3. Comment on the issue using this format:

   ```markdown
   **Branch:** `issue-<number>-<short-slug>`
   `git fetch origin && git checkout issue-<number>-<short-slug>`

   **Summary**
   What changed, in a few sentences.

   **Done when**
   - [x] Item — how it was verified
   - [ ] Item — why it isn't done (if any)

   **Notes**
   Deviations, assumptions, anything I should look at, unrelated problems noticed.
   ```

   If the ticket has the `security` label or Autonomy is `Agent draft`, start the comment with **Needs your attention before merging:** and list exactly what to look at.
4. Move the card to **Review**.

## Never

- Open a pull request.
- Push to the default branch or merge anything.
- Force-push, rewrite history, or delete branches you didn't create.
- Touch `.env` files, secrets, or credentials.
- Skip, disable, or weaken tests to make them pass.
- Run destructive commands against real data.
