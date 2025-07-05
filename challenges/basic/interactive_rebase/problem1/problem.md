# Interactive Rebase Challenge 1: Clean Up Feature Branch

## Scenario
You've been working on a user authentication feature and have created a messy commit history with debug commits, typo fixes, and work-in-progress commits. Before submitting a pull request, you need to clean up the history to make it easy for reviewers to understand your changes.

## Current State
Your feature branch has 8 commits with the following messy history:
- Mix of feature commits, debug commits, and fixes
- Multiple small commits that should be combined
- Debug code that was added and then removed
- Typo fixes that should be squashed with the original commits

## Goal
Create a clean, linear history with 3 logical commits:
1. **feat: add User class with authentication**
2. **test: add user authentication tests**
3. **docs: update documentation for user auth**

## Constraints
- Use only `git rebase -i` and related commands
- Maintain all functionality (no lost changes)
- Follow conventional commit message format
- Remove all debug-related commits by squashing them appropriately

## Efficiency Goals
- **Target Commands**: ≤ 5 git commands
- **Target Time**: ≤ 3 minutes
- **Bonus**: Complete without looking at git log more than twice

## Current Commit History
```
Remove debug code
Update documentation
debug: add test logging
Add user tests
fix typo in password
WIP: add auth method
debug: add debug logging
Add user class
Initial project setup
```

## Hints
- Use `git rebase -i HEAD~8` to start interactive rebase
- Focus on the `squash` and `reword` commands
- Group related commits together (implementation, tests, docs)
- The debug commits should be squashed into their related feature commits
- Use conventional commit format: `type: description`

## Key Concepts
- Interactive rebase with `pick`, `squash`, and `reword`
- Commit message improvement
- Logical grouping of changes
- Clean commit history preparation for code review

## Success Criteria
- Exactly 3 commits on the feature branch (excluding initial setup)
- All commits follow conventional commit format
- No functionality lost
- Clean, logical progression of changes