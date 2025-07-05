# Edit Messages Challenge 1: Fix Unclear Commit Messages

## Scenario

You're working on a feature branch for a new Express.js API. During development, you made several commits with vague and unclear messages like "fix stuff", "update code", and "changes". Now you're preparing to merge this branch into main, but your team requires clear, descriptive commit messages that explain what each commit actually does.

## Current State

Your repository contains these unclear commit messages:
- `fix stuff` - What was fixed?
- `update code` - What code was updated and why?
- `changes` - What changes were made?
- `more stuff` - What additional functionality was added?
- `add some tests` - What tests were added?

## Goal

Use `git rebase -i` with the `reword` command to transform these vague commit messages into clear, descriptive ones that:

1. **Explain what was changed**: Be specific about what functionality was added or modified
2. **Explain why**: If the reason isn't obvious, include context
3. **Use imperative mood**: Write messages as if completing the sentence "This commit will..."
4. **Be concise but descriptive**: Aim for 50-72 characters in the subject line

## Expected Result

Transform the commit messages to something like:
- `Add JSON body parsing middleware to Express app`
- `Implement authentication middleware for API routes`
- `Add user management endpoints (GET and POST)`
- `Add error handling middleware for server errors`
- `Add unit tests for API endpoints and authentication`

## Constraints

- Use only `git rebase -i` with the `reword` command
- Do not change the actual code - only the commit messages
- Maintain the same number of commits (5 commits after initial setup)
- Keep the commits in the same order

## Efficiency Goals

- **Target Commands**: ≤ 2 git commands (rebase -i + any follow-up commands)
- **Target Time**: ≤ 3 minutes
- **Bonus**: Complete without needing to look up Git rebase documentation

## Hints

- Use `git log --oneline` to see the current commit history
- Use `git rebase -i HEAD~5` to edit the last 5 commits
- In the rebase editor, change `pick` to `reword` (or just `r`) for each commit you want to edit
- For each commit you're rewording, Git will open your editor to change the message
- Good commit messages start with a verb in imperative mood (Add, Fix, Update, Remove, etc.)

## Learning Objectives

After completing this challenge, you'll understand:
- How to use `git rebase -i` with the `reword` command
- What makes a good commit message
- How to write clear, descriptive commit messages
- The importance of commit message quality in team collaboration