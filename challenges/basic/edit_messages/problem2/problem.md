# Edit Messages Challenge 2: Apply Conventional Commit Standards

## Scenario

You're preparing to contribute to an open source project that requires conventional commit format. Your calculator library is ready, but the commit messages don't follow the conventional commit standard that most open source projects expect. Before submitting your pull request, you need to clean up the commit history to match the project's contribution guidelines.

## Current State

Your repository contains these informal commit messages:
- `added power function` - Should specify this is a new feature
- `build configuration` - Should clarify this is build system setup
- `fixed error message` - Should specify this is a bug fix
- `unit tests for calculator` - Should specify this is test addition
- `documentation update` - Should use conventional format for docs
- `contributing guidelines` - Should use conventional format for docs

## Goal

Use `git rebase -i` with the `reword` command to convert these informal commit messages to conventional commit format.

### Conventional Commit Format

```
<type>[optional scope]: <description>

Types:
- feat: A new feature
- fix: A bug fix
- docs: Documentation only changes
- test: Adding missing tests or correcting existing tests
- build: Changes that affect the build system or external dependencies
- refactor: A code change that neither fixes a bug nor adds a feature
- style: Changes that do not affect the meaning of the code (formatting, etc.)
- ci: Changes to CI configuration files and scripts
- chore: Other changes that don't modify src or test files
```

## Expected Result

Transform the commit messages to conventional format:
- `feat: add power function for exponentiation`
- `build: add Babel configuration for ES6 transpilation`
- `fix: improve error message clarity in divide method`
- `test: add comprehensive unit tests for all calculator methods`
- `docs: add API documentation for calculator methods`
- `docs: add contributing guidelines for open source contributions`

## Constraints

- Use only `git rebase -i` with the `reword` command
- Convert ALL informal messages to conventional commit format
- Do not change the actual code - only the commit messages
- Maintain the same number of commits (6 commits after initial setup)
- Keep the commits in the same order

## Efficiency Goals

- **Target Commands**: ≤ 2 git commands (rebase -i + any follow-up commands)
- **Target Time**: ≤ 4 minutes
- **Bonus**: Complete without referencing conventional commit documentation

## Conventional Commit Types Reference

- **feat**: New features or functionality
- **fix**: Bug fixes
- **docs**: Documentation changes
- **test**: Adding or modifying tests
- **build**: Build system or dependency changes
- **refactor**: Code changes that don't add features or fix bugs
- **style**: Formatting changes that don't affect code meaning
- **ci**: Continuous integration configuration changes
- **chore**: Maintenance tasks that don't modify src or test files

## Hints

- Use `git log --oneline` to see the current commit history
- Use `git rebase -i HEAD~6` to edit the last 6 commits
- Change `pick` to `reword` (or `r`) for each commit you want to edit
- Think about what each commit actually accomplishes:
  - Adding new functionality = `feat:`
  - Fixing a problem = `fix:`
  - Adding tests = `test:`
  - Adding documentation = `docs:`
  - Build/tooling changes = `build:`
- Keep descriptions concise but descriptive
- Use imperative mood (add, fix, update, etc.)

## Learning Objectives

After completing this challenge, you'll understand:
- How to apply conventional commit standards
- The different types of conventional commits
- Why consistent commit message format matters in open source
- How to prepare commits for open source contributions
- The importance of clear, standardized commit messages in collaborative projects

## Open Source Context

Conventional commits are widely adopted in open source projects because they:
- Enable automatic changelog generation
- Make it easier to understand the nature of changes
- Support semantic versioning automation
- Improve collaboration between contributors
- Provide consistent history across different contributors