# Advanced Git Drills Project Specification

## Overview

A command-line learning tool focused on advanced Git operations with emphasis on rebasing, history management, and workflow optimization. Designed for developers with basic Git knowledge who want to master clean commit histories and efficient Git workflows.

## Learning Objectives

### Primary Focus

- **Rebasing Mastery**: Interactive rebase, squashing, reordering, and conflict resolution
- **History Cleanup**: Transform messy merge histories into clean, linear progressions
- **Workflow Optimization**: Reduce Git operation time and command count
- **Open Source Preparation**: Learn contribution-ready commit practices

### Target User Profile

- **Current Skills**: add, commit, push, pull, branch switching, basic merge
- **Pain Points**: Messy commit history from dev->main->dev merges
- **Goals**: Personal workflow optimization, open source contribution readiness
- **Team Context**: Basic collaboration with git merge workflows

## Project Structure

```bash
git-drills/
├── README.md
├── git-drill.sh                    # Main CLI script
├── config.sh                       # Configuration variables
├── utils/
│   ├── git_utils.sh               # Git-specific utilities
│   ├── verification.sh            # Answer verification helpers
│   ├── quiz.sh                    # Quiz system
│   └── claude_integration.sh      # Claude Code integration
├── challenges/
│   ├── basic/
│   │   ├── interactive_rebase/
│   │   │   ├── problem1/
│   │   │   │   ├── setup.sh
│   │   │   │   ├── problem.md
│   │   │   │   ├── verify.sh
│   │   │   │   └── git_files/
│   │   │   ├── problem2/
│   │   │   └── problem3/
│   │   ├── squash_commits/
│   │   │   ├── problem1/
│   │   │   ├── problem2/
│   │   │   └── problem3/
│   │   ├── reorder_commits/
│   │   │   ├── problem1/
│   │   │   └── problem2/
│   │   ├── edit_messages/
│   │   │   ├── problem1/
│   │   │   └── problem2/
│   │   └── split_commits/
│   │       ├── problem1/
│   │       └── problem2/
│   ├── intermediate/
│   │   ├── rebase_conflicts/
│   │   │   ├── problem1/
│   │   │   ├── problem2/
│   │   │   └── problem3/
│   │   ├── branch_cleanup/
│   │   │   ├── problem1/
│   │   │   ├── problem2/
│   │   │   └── problem3/
│   │   ├── history_rewriting/
│   │   │   ├── problem1/
│   │   │   └── problem2/
│   │   ├── reflog_recovery/
│   │   │   ├── problem1/
│   │   │   └── problem2/
│   │   └── merge_to_rebase/
│   │       ├── problem1/
│   │       └── problem2/
│   ├── advanced/
│   │   ├── complex_rebases/
│   │   │   ├── problem1/
│   │   │   └── problem2/
│   │   ├── git_archaeology/
│   │   │   ├── problem1/
│   │   │   └── problem2/
│   │   ├── workflow_optimization/
│   │   │   ├── problem1/
│   │   │   └── problem2/
│   │   └── advanced_recovery/
│   │       ├── problem1/
│   │       └── problem2/
│   └── workflows/
│       ├── feature_branch_flow/
│       │   ├── problem1/
│       │   └── problem2/
│       ├── open_source_contribution/
│       │   ├── problem1/
│       │   └── problem2/
│       └── team_collaboration/
│           ├── problem1/
│           └── problem2/
└── quizzes/
    ├── rebase_concepts.txt
    ├── workflow_optimization.txt
    ├── conflict_resolution.txt
    └── best_practices.txt
```

## Challenge Categories

### 1. Basic Level (12 challenges)

#### Interactive Rebase Fundamentals (3 challenges)

- **Goal**: Master `git rebase -i` basics
- **Concepts**: pick, edit, drop commands
- **Scenarios**: 
  - Clean up a feature branch before merge
  - Remove debug commits from history
  - Prepare commits for code review

#### Squash Commits (3 challenges)

- **Goal**: Combine related commits into logical units
- **Concepts**: squash, fixup commands
- **Scenarios**:
  - Combine "fix typo" commits with main feature
  - Squash WIP commits into final implementation
  - Create atomic commits from messy development

#### Reorder Commits (2 challenges)

- **Goal**: Arrange commits in logical order
- **Concepts**: Reordering in interactive rebase
- **Scenarios**:
  - Fix chronological order of related changes
  - Group related functionality together

#### Edit Commit Messages (2 challenges)

- **Goal**: Improve commit message quality
- **Concepts**: reword command, conventional commits
- **Scenarios**:
  - Fix unclear commit messages
  - Apply conventional commit standards

#### Split Commits (2 challenges)

- **Goal**: Break large commits into focused units
- **Concepts**: edit command, partial staging
- **Scenarios**:
  - Split refactoring from feature addition
  - Separate bug fix from feature implementation

### 2. Intermediate Level (10 challenges)

#### Rebase Conflicts (3 challenges)

- **Goal**: Resolve conflicts during rebase operations
- **Concepts**: conflict resolution, `git rebase --continue`
- **Scenarios**:
  - Resolve conflicts in interactive rebase
  - Handle complex multi-file conflicts
  - Manage conflicts when squashing commits

#### Branch Cleanup (3 challenges)

- **Goal**: Clean up messy branch histories
- **Concepts**: rebase onto, branch renaming
- **Scenarios**:
  - Fix dev->main->dev merge history
  - Clean up feature branch with multiple merges
  - Linearize complex branch structure

#### History Rewriting (2 challenges)

- **Goal**: Safely rewrite commit history
- **Concepts**: filter-branch, BFG alternatives
- **Scenarios**:
  - Remove sensitive data from history
  - Fix author information across commits

#### Reflog Recovery (2 challenges)

- **Goal**: Recover from rebase mistakes
- **Concepts**: reflog, reset with SHA
- **Scenarios**:
  - Recover lost commits after bad rebase
  - Restore branch state before rebase

### 3. Advanced Level (8 challenges)

#### Complex Rebases (2 challenges)

- **Goal**: Handle multi-branch rebase scenarios
- **Concepts**: rebase onto different bases
- **Scenarios**:
  - Rebase feature branch onto updated main
  - Handle rebasing with multiple dependent branches

#### Git Archaeology (2 challenges)

- **Goal**: Investigate and debug using Git history
- **Concepts**: bisect, blame, log analysis
- **Scenarios**:
  - Find commit that introduced a bug
  - Analyze code evolution over time

#### Workflow Optimization (2 challenges)

- **Goal**: Maximize Git workflow efficiency
- **Concepts**: aliases, custom commands, scripts
- **Scenarios**:
  - Create efficient rebase workflows
  - Optimize common Git operations

#### Advanced Recovery (2 challenges)

- **Goal**: Handle complex Git disasters
- **Concepts**: fsck, advanced reflog usage
- **Scenarios**:
  - Recover from corrupted repository
  - Restore complex multi-branch state

### 4. Workflow Integration (6 challenges)

#### Feature Branch Flow (2 challenges)

- **Goal**: Integrate rebasing into feature development
- **Scenarios**:
  - Maintain clean feature branch during development
  - Prepare feature for merge/PR with perfect history

#### Open Source Contribution (2 challenges)

- **Goal**: Prepare contributions for external repositories
- **Scenarios**:
  - Create PR-ready commit history
  - Handle upstream changes during contribution

#### Team Collaboration (2 challenges)

- **Goal**: Balance rebasing with team workflows
- **Scenarios**:
  - Coordinate rebasing in team environment
  - Maintain shared branch integrity

## CLI Interface Specification

### Required Commands

```bash
# Challenge management
./git-drill.sh --level {basic|intermediate|advanced|workflows} --concept {concept_name} [--problem {n}]
./git-drill.sh --list [--level {level}] [--concept {concept}]
./git-drill.sh --random [--level {level}]

# Learning aids
./git-drill.sh --quiz [--level {level}] [--concept {concept}]
./git-drill.sh --hint
./git-drill.sh --explain

# Progress tracking
./git-drill.sh --progress
./git-drill.sh --stats
./git-drill.sh --reset-progress

# Efficiency tracking
./git-drill.sh --efficiency-mode
./git-drill.sh --track-commands
./git-drill.sh --track-time
./git-drill.sh --speed-challenge

# Git-specific features
./git-drill.sh --show-alternatives
./git-drill.sh --optimize-solution
./git-drill.sh --safe-mode          # Creates backup branches
./git-drill.sh --recovery-mode      # Practice with reflog

# Claude integration
./git-drill.sh --generate --level {level} --concept {concept}
./git-drill.sh --claude-hint
./git-drill.sh --claude-explain
```

## Challenge Structure Standards

### Setup.sh Requirements

```bash
#!/bin/bash
set -euo pipefail

# Initialize git repository with realistic scenario
# Create commits, branches, and states that match real-world problems
# Set up challenging but solvable situations
# Ensure reproducible starting conditions

create_messy_history() {
    # Create the specific type of messy history for this challenge
}

setup_files() {
    # Create realistic files and content
}

create_scenario() {
    # Set up the specific problem scenario
}
```

### Problem.md Template

```markdown
# {Challenge Title}

## Scenario
{Real-world context - e.g., "You're preparing a feature branch for code review"}

## Current State
{Description of the messy Git state}

## Goal
{Clear objective - e.g., "Create a clean, linear history with 3 logical commits"}

## Constraints
- Use only `git rebase -i` and related commands
- Maintain all functionality (no lost changes)
- Follow conventional commit message format

## Efficiency Goals
- **Target Commands**: ≤ 5 git commands
- **Target Time**: ≤ 3 minutes
- **Bonus**: Complete without looking at git log more than once

## Hints
- Focus on the squash and reword commands
- Use git log --oneline to see current state
- Remember: git rebase -i HEAD~{n} for last n commits
```

### Verify.sh Standards

```bash
#!/bin/bash
set -euo pipefail

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

verify_commit_count() {
    local expected=$1
    local actual=$(git log --oneline | wc -l)
    
    if [ "$actual" -eq "$expected" ]; then
        return 0
    else
        echo -e "${RED}❌ Expected $expected commits, found $actual${NC}"
        return 1
    fi
}

verify_commit_messages() {
    # Check commit message quality and format
}

verify_file_integrity() {
    # Ensure no functionality was lost
}

verify_efficiency() {
    # Check if solution meets efficiency goals
}

# Main verification
main() {
    if verify_commit_count 3 && verify_commit_messages && verify_file_integrity; then
        echo -e "${GREEN}✅ Challenge completed successfully!${NC}"
        echo -e "${GREEN}🎯 History is now clean and linear${NC}"
        echo -e "${GREEN}💡 Key concepts: interactive rebase, squashing${NC}"
        exit 0
    else
        echo -e "${RED}❌ Challenge not completed${NC}"
        echo -e "${YELLOW}💡 Hint: Use git log --oneline to check your progress${NC}"
        exit 1
    fi
}
```

## Efficiency Metrics

### Command Tracking

- Count git commands used
- Identify inefficient patterns
- Suggest optimizations

### Time Tracking

- Measure challenge completion time
- Track improvement over time
- Set realistic target times

### Quality Metrics

- Commit message quality scores
- History cleanliness ratings
- Best practice adherence

## Quiz System

### Sample Questions

#### Rebase Concepts

```text
Q: What is the main advantage of using rebase over merge for feature branches?
TYPE: multiple_choice
A1: Rebase is faster than merge
A2: Rebase creates a linear history without merge commits
A3: Rebase automatically resolves conflicts
A4: Rebase works better with remote repositories
CORRECT: 2
EXPLANATION: Rebase creates a linear history by replaying commits on top of the target branch, avoiding merge commits that can clutter the history.
CONCEPT: interactive_rebase
DIFFICULTY: 2
```

#### Workflow Optimization

```text
Q: You have 5 commits with messages "WIP", "fix bug", "WIP", "add feature", "fix typo". What's the best rebase strategy?
TYPE: multiple_choice
A1: Squash all commits into one
A2: Squash WIP commits with related feature commits, keep bug fix separate
A3: Reorder commits then squash
A4: Edit all commit messages first
CORRECT: 2
EXPLANATION: Group related commits together while keeping logically separate changes (like bug fixes) in their own commits.
CONCEPT: squash_commits
DIFFICULTY: 3
```

## Safety Features

### Backup System

- Automatic branch backup before dangerous operations
- Easy rollback mechanism
- Reflog integration for recovery practice

### Safe Mode

- Non-destructive practice environment
- Sandbox repositories for learning
- Recovery challenges with safety net

## Success Criteria

### Learning Outcomes

1. **Rebase Mastery**: Complete interactive rebase operations confidently
2. **History Cleanup**: Transform messy histories into clean, linear progressions
3. **Workflow Efficiency**: Reduce Git operation time by 50%
4. **Conflict Resolution**: Handle rebase conflicts systematically
5. **Recovery Skills**: Recover from Git mistakes using reflog and reset

### Measurable Goals

- Complete all 36 challenges with 90% accuracy
- Achieve target efficiency metrics in 80% of challenges
- Demonstrate clean commit history practices
- Show confidence in advanced Git operations

### Progression Tracking

- Challenge completion rates by difficulty
- Time improvement trends
- Command efficiency improvements
- Error recovery success rates

## Implementation Priority

### Phase 1: Core Rebasing (Weeks 1-2)

- Interactive rebase fundamentals
- Squashing and reordering
- Basic conflict resolution

### Phase 2: History Management (Weeks 3-4)

- Branch cleanup scenarios
- Reflog recovery
- Complex rebase operations

### Phase 3: Workflow Integration (Weeks 5-6)

- Efficiency optimization
- Team collaboration scenarios
- Open source preparation

### Phase 4: Advanced Features (Week 7)

- Git archaeology
- Advanced recovery
- Custom workflow development

This specification provides a comprehensive framework for mastering advanced Git operations with a focus on rebasing and workflow optimization, tailored specifically for developers looking to improve their Git practices and prepare for open source contributions.