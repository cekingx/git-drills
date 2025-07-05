# Git Drills - Advanced Git Learning Tool

A comprehensive command-line learning tool focused on mastering advanced Git operations, with emphasis on rebasing, history management, and workflow optimization.

## Overview

Git Drills is designed for developers who have basic Git knowledge but want to master clean commit histories, efficient Git workflows, and advanced Git operations. The tool provides hands-on challenges that simulate real-world scenarios where advanced Git skills are essential.

## Target Audience

**Current Skills**: add, commit, push, pull, branch switching, basic merge  
**Pain Points**: Messy commit history from dev→main→dev merges  
**Goals**: Personal workflow optimization, open source contribution readiness  

## Installation

1. Clone the repository:

   ```bash
   git clone <repository-url>
   cd git-drills
   ```

2. Make the main script executable:

   ```bash
   chmod +x git-drill.sh
   ```

3. Optionally, add to PATH for global access:

   ```bash
   echo 'export PATH="$PATH:/path/to/git-drills"' >> ~/.bashrc
   source ~/.bashrc
   ```

## Quick Start

### Run Your First Challenge

```bash
# Start with a basic interactive rebase challenge
./git-drill.sh --level basic --concept interactive_rebase --problem 1

# Or try a random challenge
./git-drill.sh --random --level basic
```

### Take a Quiz

```bash
# Test your knowledge with a quiz
./git-drill.sh --quiz --level basic --concept interactive_rebase
```

### View Progress

```bash
# Check your completion progress
./git-drill.sh --progress
```

## Usage

### Basic Commands

#### Challenge Management

```bash
# Run specific challenge
./git-drill.sh --level LEVEL --concept CONCEPT [--problem N]

# List available challenges
./git-drill.sh --list [--level LEVEL] [--concept CONCEPT]

# Run random challenge
./git-drill.sh --random [--level LEVEL]
```

#### Learning Aids

```bash
# Take quiz on concepts
./git-drill.sh --quiz [--level LEVEL] [--concept CONCEPT]

# Get hint for current challenge
./git-drill.sh --hint

# Get detailed explanation
./git-drill.sh --explain
```

#### Progress Tracking

```bash
# Show completion progress
./git-drill.sh --progress

# Show detailed statistics
./git-drill.sh --stats

# Reset all progress data
./git-drill.sh --reset-progress
```

### Advanced Features

#### Efficiency Training

```bash
# Enable efficiency tracking
./git-drill.sh --efficiency-mode --level basic --concept interactive_rebase

# Track command usage
./git-drill.sh --track-commands --level basic --concept squash_commits

# Time-based challenges
./git-drill.sh --speed-challenge
```

#### Safety Features

```bash
# Create backup branches before challenges
./git-drill.sh --safe-mode --level basic --concept interactive_rebase

# Practice recovery scenarios
./git-drill.sh --recovery-mode
```

#### Claude Integration

```bash
# Get AI-powered hints
./git-drill.sh --claude-hint

# Get detailed AI explanations
./git-drill.sh --claude-explain

# Generate new challenges
./git-drill.sh --generate --level basic --concept interactive_rebase
```

## Learning Path

### 1. Basic Level (12 challenges)

Master fundamental rebasing concepts:

- **Interactive Rebase** (3 challenges): Learn `git rebase -i` basics
- **Squash Commits** (3 challenges): Combine related commits
- **Reorder Commits** (2 challenges): Arrange commits logically
- **Edit Messages** (2 challenges): Improve commit message quality
- **Split Commits** (2 challenges): Break large commits into focused units

### 2. Intermediate Level (10 challenges)

Handle more complex scenarios:

- **Rebase Conflicts** (3 challenges): Resolve conflicts during rebase
- **Branch Cleanup** (3 challenges): Clean up messy branch histories
- **History Rewriting** (2 challenges): Safely rewrite commit history
- **Reflog Recovery** (2 challenges): Recover from rebase mistakes

### 3. Advanced Level (8 challenges)

Master expert-level operations:

- **Complex Rebases** (2 challenges): Multi-branch rebase scenarios
- **Git Archaeology** (2 challenges): Investigate using Git history
- **Workflow Optimization** (2 challenges): Maximize Git efficiency
- **Advanced Recovery** (2 challenges): Handle complex Git disasters

### 4. Workflow Integration (6 challenges)

Apply skills in real-world contexts:

- **Feature Branch Flow** (2 challenges): Integrate rebasing into development
- **Open Source Contribution** (2 challenges): Prepare PR-ready commits
- **Team Collaboration** (2 challenges): Balance rebasing with team workflows

## Examples

### Example 1: Clean Up Feature Branch

```bash
# Run interactive rebase challenge
./git-drill.sh --level basic --concept interactive_rebase --problem 1

# The challenge creates a messy commit history
# Your goal: use git rebase -i to clean it up
# Expected: 3 clean, logical commits with conventional messages
```

### Example 2: Squash WIP Commits

```bash
# Run squash commits challenge
./git-drill.sh --level basic --concept squash_commits --problem 1

# The challenge creates multiple WIP commits
# Your goal: squash them into atomic commits
# Expected: logical grouping of related changes
```

### Example 3: Take Knowledge Quiz

```bash
# Test your understanding
./git-drill.sh --quiz --concept interactive_rebase

# Answer multiple choice questions
# Get explanations for correct answers
# Earn badges for high scores
```

## Challenge Structure

Each challenge includes:

- **setup.sh**: Creates realistic Git scenario
- **problem.md**: Detailed problem description and goals
- **verify.sh**: Automated solution verification

### Success Criteria

- Correct commit count and structure
- Proper commit message format
- Maintained functionality
- Clean, linear history
- Efficiency targets met

## Efficiency Metrics

Git Drills tracks your performance:

- **Command Count**: How many Git commands you use
- **Time Taken**: How long to complete challenges
- **Accuracy**: Percentage of tests passed
- **Improvement**: Progress over time

### Target Metrics by Level

- **Basic**: ≤5 commands, ≤3 minutes
- **Intermediate**: ≤8 commands, ≤5 minutes  
- **Advanced**: ≤12 commands, ≤10 minutes
- **Workflows**: ≤15 commands, ≤15 minutes

## Configuration

### Environment Variables

```bash
# Enable/disable features
export ENABLE_CLAUDE_INTEGRATION=true
export ENABLE_EFFICIENCY_TRACKING=true
export ENABLE_AUTO_HINTS=true

# Set logging level
export LOG_LEVEL=INFO

# Configure safety settings
export AUTO_BACKUP=true
export SAFE_MODE_DEFAULT=false
```

### Git Configuration

Git Drills automatically sets up Git configuration for challenges:

```bash
git config user.name "Git Drills Student"
git config user.email "student@git-drills.local"
```

## Tips for Success

### General Strategy

1. **Read the Problem**: Understand the scenario and goals
2. **Analyze Current State**: Use `git log --oneline` to see history
3. **Plan Your Approach**: Decide which commits to squash/reorder
4. **Execute Carefully**: Use interactive rebase step by step
5. **Verify Results**: Check that all criteria are met

### Common Patterns

- **Squash debug commits** with their related feature commits
- **Reorder commits** for logical flow (setup → implementation → tests)
- **Use conventional commit messages** (feat:, fix:, docs:, etc.)
- **Keep atomic commits** (one logical change per commit)

### Interactive Rebase Commands

- `pick`: Keep commit as-is
- `reword`: Change commit message
- `edit`: Stop and modify commit
- `squash`: Combine with previous commit (edit message)
- `fixup`: Combine with previous commit (keep message)
- `drop`: Remove commit entirely

## Troubleshooting

### Common Issues

**Challenge won't start**:

- Check that you're in the correct directory
- Ensure setup.sh is executable
- Verify Git is installed and configured

**Verification fails**:

- Read error messages carefully
- Check commit count and messages
- Ensure working directory is clean
- Verify you're on the correct branch

**Rebase conflicts**:

- Read conflict markers carefully
- Edit files to resolve conflicts
- Use `git add` to stage resolved files
- Continue with `git rebase --continue`

### Recovery Commands

```bash
# Abort current rebase
git rebase --abort

# View reflog to see previous states
git reflog

# Reset to previous state
git reset --hard HEAD@{1}

# Create backup branch
git branch backup-branch
```

## Dependencies

### Required

- **Git**: Version 2.0 or higher
- **Bash**: Version 4.0 or higher
- **jq**: For JSON processing

### Optional

- **Claude CLI**: For AI-powered hints and explanations
- **fzf**: For enhanced command-line experience
- **bat**: For syntax-highlighted file viewing

## Contributing

We welcome contributions! Here's how to get started:

1. Fork the repository
2. Create a feature branch
3. Add new challenges or improve existing ones
4. Test your changes
5. Submit a pull request

### Adding New Challenges

1. Create directory structure in `challenges/`
2. Write `setup.sh` to create scenario
3. Write `problem.md` with clear instructions
4. Write `verify.sh` to check solution
5. Test thoroughly with different approaches

## License

This project is licensed under the MIT License. See LICENSE file for details.

## Support

- **Issues**: Report bugs and request features on GitHub
- **Documentation**: Check the docs/ directory for detailed guides
- **Community**: Join our discussions for tips and help

## Roadmap

### Version 1.1

- [ ] Web interface for challenges
- [ ] Integration with popular Git hosting services
- [ ] Advanced analytics and progress tracking
- [ ] Multiplayer challenges and competitions

### Version 1.2

- [ ] Mobile app for theory and quizzes
- [ ] Integration with VS Code extension
- [ ] Custom challenge creation tools
- [ ] Team training features

---

**Happy Learning!** 🚀

Master Git like a pro with hands-on practice and real-world scenarios.

---

## Development Attribution

This project was created with significant assistance from Claude AI (Anthropic). Claude was heavily involved in the design, implementation, and documentation of this learning tool, contributing to the architecture, challenge creation, verification systems, and educational content structure.
