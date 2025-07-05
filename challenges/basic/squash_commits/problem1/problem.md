# Squash Commits Challenge 1: Combine WIP Commits

## Scenario
You've been implementing a shopping cart feature using a work-in-progress (WIP) development style, creating small commits as you build each piece. While this approach helped you stay organized during development, the commit history is now too granular for a clean pull request. You need to combine these WIP commits into logical, atomic commits.

## Current State
Your feature branch has 10 commits, all prefixed with "WIP:" representing different aspects of the shopping cart implementation:
- Multiple WIP commits for cart class methods
- Multiple WIP commits for UI components
- Multiple WIP commits for styling
- WIP commits for integration

## Goal
Squash the WIP commits into 3 logical, atomic commits:
1. **feat: implement shopping cart core logic**
2. **feat: add shopping cart UI components**
3. **feat: integrate cart with main application**

## Constraints
- Use `git rebase -i` with `squash` commands
- Maintain all functionality (no lost changes)
- Follow conventional commit message format
- Each final commit should represent a complete, logical unit of work

## Efficiency Goals
- **Target Commands**: ≤ 4 git commands
- **Target Time**: ≤ 4 minutes
- **Bonus**: Complete without referencing git log more than once

## Current Commit History
```
WIP: cart integration
WIP: style total and checkout button
WIP: improve cart styling
WIP: basic cart styles
WIP: add total and checkout button
WIP: cart component structure
WIP: add total price calculation
WIP: remove item method
WIP: add item method
WIP: start shopping cart class
Initial project setup
```

## Logical Grouping Strategy
- **Cart Logic**: All commits related to `src/cart.js` (constructor, methods, calculations)
- **Cart UI**: All commits related to `components/cart.html` and `styles/cart.css`
- **Integration**: Commits related to `src/main.js` and connecting components

## Hints
- Use `git rebase -i HEAD~10` to start interactive rebase
- Group related functionality together using `squash` commands
- Use `pick` for the first commit of each logical group
- Use `squash` for subsequent commits in the same group
- Rewrite commit messages to be descriptive and follow conventional format
- Consider the order: typically logic → UI → integration

## Key Concepts
- Squashing commits with `squash` command
- Atomic commits (each commit represents one complete feature)
- Logical grouping of related changes
- Conventional commit message format
- Clean history for code review

## Success Criteria
- Exactly 3 commits on the feature branch (excluding initial setup)
- All commits follow conventional commit format
- No functionality lost
- Each commit contains logically related changes
- Clean, meaningful commit messages