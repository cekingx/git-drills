#!/bin/bash

# Git Utilities
# Helper functions for Git operations in Git Drills

# Check if we're in a git repository
is_git_repo() {
    git rev-parse --git-dir &> /dev/null
}

# Check if the working directory is clean
is_working_dir_clean() {
    if [[ -z $(git status --porcelain) ]]; then
        return 0
    else
        return 1
    fi
}

# Get current branch name
get_current_branch() {
    git rev-parse --abbrev-ref HEAD
}

# Get commit count
get_commit_count() {
    local branch="${1:-HEAD}"
    git rev-list --count "$branch"
}

# Get commit hash
get_commit_hash() {
    local ref="${1:-HEAD}"
    git rev-parse "$ref"
}

# Get short commit hash
get_short_hash() {
    local ref="${1:-HEAD}"
    git rev-parse --short "$ref"
}

# Check if commit exists
commit_exists() {
    local commit="$1"
    git rev-parse --verify "$commit" &> /dev/null
}

# Get commit message
get_commit_message() {
    local commit="${1:-HEAD}"
    git log -1 --pretty=format:"%s" "$commit"
}

# Get commit author
get_commit_author() {
    local commit="${1:-HEAD}"
    git log -1 --pretty=format:"%an" "$commit"
}

# Get commit date
get_commit_date() {
    local commit="${1:-HEAD}"
    git log -1 --pretty=format:"%ad" --date=short "$commit"
}

# Get list of changed files in a commit
get_changed_files() {
    local commit="${1:-HEAD}"
    git diff-tree --no-commit-id --name-only -r "$commit"
}

# Create a new branch
create_branch() {
    local branch_name="$1"
    local base_commit="${2:-HEAD}"
    
    if git show-ref --verify --quiet "refs/heads/$branch_name"; then
        echo "Branch $branch_name already exists"
        return 1
    fi
    
    git checkout -b "$branch_name" "$base_commit"
}

# Switch to branch
switch_to_branch() {
    local branch_name="$1"
    
    if ! git show-ref --verify --quiet "refs/heads/$branch_name"; then
        echo "Branch $branch_name does not exist"
        return 1
    fi
    
    git checkout "$branch_name"
}

# Delete branch
delete_branch() {
    local branch_name="$1"
    local force="${2:-false}"
    
    if [[ "$force" == true ]]; then
        git branch -D "$branch_name"
    else
        git branch -d "$branch_name"
    fi
}

# Get list of branches
get_branches() {
    git branch --format="%(refname:short)"
}

# Get list of remote branches
get_remote_branches() {
    git branch -r --format="%(refname:short)"
}

# Check if branch exists
branch_exists() {
    local branch_name="$1"
    git show-ref --verify --quiet "refs/heads/$branch_name"
}

# Get common ancestor of two commits
get_merge_base() {
    local commit1="$1"
    local commit2="$2"
    git merge-base "$commit1" "$commit2"
}

# Get commits between two refs
get_commits_between() {
    local start_ref="$1"
    local end_ref="$2"
    local format="${3:-%H}"
    
    git log --pretty=format:"$format" "$start_ref..$end_ref"
}

# Check if commit is an ancestor of another
is_ancestor() {
    local ancestor="$1"
    local descendant="$2"
    
    git merge-base --is-ancestor "$ancestor" "$descendant"
}

# Get the root commit
get_root_commit() {
    git rev-list --max-parents=0 HEAD
}

# Get commits with specific pattern in message
find_commits_by_message() {
    local pattern="$1"
    local branch="${2:-HEAD}"
    
    git log --grep="$pattern" --pretty=format:"%H %s" "$branch"
}

# Get commits by author
find_commits_by_author() {
    local author="$1"
    local branch="${2:-HEAD}"
    
    git log --author="$author" --pretty=format:"%H %s" "$branch"
}

# Get commits that modified a specific file
find_commits_by_file() {
    local file="$1"
    local branch="${2:-HEAD}"
    
    git log --follow --pretty=format:"%H %s" "$branch" -- "$file"
}

# Backup current branch
backup_branch() {
    local branch_name="$1"
    local backup_name="${2:-${branch_name}-backup-$(date +%Y%m%d-%H%M%S)}"
    
    git branch "$backup_name" "$branch_name"
    echo "Branch $branch_name backed up as $backup_name"
}

# Restore branch from backup
restore_branch() {
    local branch_name="$1"
    local backup_name="$2"
    
    if ! branch_exists "$backup_name"; then
        echo "Backup branch $backup_name does not exist"
        return 1
    fi
    
    git checkout "$branch_name"
    git reset --hard "$backup_name"
    echo "Branch $branch_name restored from $backup_name"
}

# Create temporary branch
create_temp_branch() {
    local prefix="${1:-temp}"
    local temp_name="${prefix}-$(date +%Y%m%d-%H%M%S)-$$"
    
    git checkout -b "$temp_name"
    echo "$temp_name"
}

# Clean up temporary branches
cleanup_temp_branches() {
    local prefix="${1:-temp}"
    
    git for-each-ref --format="%(refname:short)" refs/heads/ | \
        grep "^$prefix-" | \
        xargs -r git branch -D
}

# Get file content at specific commit
get_file_at_commit() {
    local commit="$1"
    local file="$2"
    
    git show "$commit:$file"
}

# Check if file exists at commit
file_exists_at_commit() {
    local commit="$1"
    local file="$2"
    
    git cat-file -e "$commit:$file" 2>/dev/null
}

# Get diff between commits
get_diff() {
    local commit1="$1"
    local commit2="${2:-HEAD}"
    local file="${3:-}"
    
    if [[ -n "$file" ]]; then
        git diff "$commit1" "$commit2" -- "$file"
    else
        git diff "$commit1" "$commit2"
    fi
}

# Get diff stats
get_diff_stats() {
    local commit1="$1"
    local commit2="${2:-HEAD}"
    
    git diff --stat "$commit1" "$commit2"
}

# Check if there are unstaged changes
has_unstaged_changes() {
    git diff --quiet
    return $?
}

# Check if there are staged changes
has_staged_changes() {
    git diff --cached --quiet
    return $?
}

# Get status of specific file
get_file_status() {
    local file="$1"
    git status --porcelain "$file" | cut -c1-2
}

# Stage file
stage_file() {
    local file="$1"
    git add "$file"
}

# Unstage file
unstage_file() {
    local file="$1"
    git reset HEAD "$file"
}

# Discard changes in file
discard_file_changes() {
    local file="$1"
    git checkout -- "$file"
}

# Get list of modified files
get_modified_files() {
    git diff --name-only
}

# Get list of staged files
get_staged_files() {
    git diff --cached --name-only
}

# Get list of untracked files
get_untracked_files() {
    git ls-files --others --exclude-standard
}

# Validate commit message format
validate_commit_message() {
    local message="$1"
    local pattern="^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .{1,50}$"
    
    if [[ "$message" =~ $pattern ]]; then
        return 0
    else
        return 1
    fi
}

# Get commit message suggestions
suggest_commit_message() {
    local staged_files=$(get_staged_files)
    local file_count=$(echo "$staged_files" | wc -l)
    
    if [[ $file_count -eq 1 ]]; then
        echo "feat: update $(basename "$staged_files")"
    elif [[ $file_count -lt 5 ]]; then
        echo "feat: update multiple files"
    else
        echo "feat: major changes across multiple files"
    fi
}

# Check for common Git issues
check_git_health() {
    local issues=()
    
    # Check for uncommitted changes
    if ! is_working_dir_clean; then
        issues+=("Uncommitted changes in working directory")
    fi
    
    # Check for untracked files
    local untracked=$(get_untracked_files)
    if [[ -n "$untracked" ]]; then
        issues+=("Untracked files present")
    fi
    
    # Check for merge conflicts
    if git ls-files --unmerged | grep -q .; then
        issues+=("Merge conflicts present")
    fi
    
    # Check for detached HEAD
    if [[ $(get_current_branch) == "HEAD" ]]; then
        issues+=("In detached HEAD state")
    fi
    
    if [[ ${#issues[@]} -eq 0 ]]; then
        echo "Git repository is healthy"
        return 0
    else
        echo "Git repository issues found:"
        printf '  - %s\n' "${issues[@]}"
        return 1
    fi
}

# Get repository statistics
get_repo_stats() {
    local total_commits=$(get_commit_count)
    local total_branches=$(get_branches | wc -l)
    local current_branch=$(get_current_branch)
    local last_commit=$(get_commit_hash)
    local last_commit_date=$(get_commit_date)
    
    echo "Repository Statistics:"
    echo "  Total commits: $total_commits"
    echo "  Total branches: $total_branches"
    echo "  Current branch: $current_branch"
    echo "  Last commit: $(get_short_hash) ($last_commit_date)"
    echo "  Working directory: $(is_working_dir_clean && echo "clean" || echo "dirty")"
}

# Export functions for use in other scripts
export -f is_git_repo is_working_dir_clean get_current_branch get_commit_count
export -f get_commit_hash get_short_hash commit_exists get_commit_message
export -f create_branch switch_to_branch delete_branch get_branches branch_exists
export -f backup_branch restore_branch create_temp_branch cleanup_temp_branches
export -f has_unstaged_changes has_staged_changes get_file_status
export -f validate_commit_message suggest_commit_message check_git_health get_repo_stats