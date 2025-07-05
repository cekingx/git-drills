#!/bin/bash

# Verification System
# Functions for verifying challenge solutions

source "${SCRIPT_DIR}/utils/git_utils.sh"

# Color codes for verification output
VERIFY_GREEN='\033[0;32m'
VERIFY_RED='\033[0;31m'
VERIFY_YELLOW='\033[1;33m'
VERIFY_BLUE='\033[0;34m'
VERIFY_NC='\033[0m' # No Color

# Verification result tracking
VERIFICATION_RESULTS=()
VERIFICATION_SCORE=0
VERIFICATION_MAX_SCORE=0

# Initialize verification session
init_verification() {
    VERIFICATION_RESULTS=()
    VERIFICATION_SCORE=0
    VERIFICATION_MAX_SCORE=0
}

# Add verification test
add_verification_test() {
    local test_name="$1"
    local test_function="$2"
    local points="${3:-1}"
    
    VERIFICATION_MAX_SCORE=$((VERIFICATION_MAX_SCORE + points))
    
    echo -e "${VERIFY_BLUE}Testing: $test_name${VERIFY_NC}"
    
    if $test_function; then
        VERIFICATION_RESULTS+=("✅ $test_name: PASS")
        VERIFICATION_SCORE=$((VERIFICATION_SCORE + points))
        echo -e "${VERIFY_GREEN}✅ $test_name: PASS${VERIFY_NC}"
        return 0
    else
        VERIFICATION_RESULTS+=("❌ $test_name: FAIL")
        echo -e "${VERIFY_RED}❌ $test_name: FAIL${VERIFY_NC}"
        return 1
    fi
}

# Show verification results
show_verification_results() {
    echo -e "\n${VERIFY_BLUE}Verification Results:${VERIFY_NC}"
    printf '%s\n' "${VERIFICATION_RESULTS[@]}"
    
    local percentage=$((VERIFICATION_SCORE * 100 / VERIFICATION_MAX_SCORE))
    echo -e "\n${VERIFY_BLUE}Score: $VERIFICATION_SCORE/$VERIFICATION_MAX_SCORE ($percentage%)${VERIFY_NC}"
    
    if [[ $VERIFICATION_SCORE -eq $VERIFICATION_MAX_SCORE ]]; then
        echo -e "${VERIFY_GREEN}🎉 All tests passed! Challenge completed successfully!${VERIFY_NC}"
        return 0
    else
        echo -e "${VERIFY_YELLOW}Some tests failed. Please review and try again.${VERIFY_NC}"
        return 1
    fi
}

# Verify commit count
verify_commit_count() {
    local expected="$1"
    local branch="${2:-HEAD}"
    local actual=$(get_commit_count "$branch")
    
    if [[ "$actual" -eq "$expected" ]]; then
        return 0
    else
        echo "Expected $expected commits, found $actual"
        return 1
    fi
}

# Verify commit count range
verify_commit_count_range() {
    local min="$1"
    local max="$2"
    local branch="${3:-HEAD}"
    local actual=$(get_commit_count "$branch")
    
    if [[ "$actual" -ge "$min" && "$actual" -le "$max" ]]; then
        return 0
    else
        echo "Expected $min-$max commits, found $actual"
        return 1
    fi
}

# Verify commit message
verify_commit_message() {
    local expected="$1"
    local commit="${2:-HEAD}"
    local actual=$(get_commit_message "$commit")
    
    if [[ "$actual" == "$expected" ]]; then
        return 0
    else
        echo "Expected message: '$expected', found: '$actual'"
        return 1
    fi
}

# Verify commit message pattern
verify_commit_message_pattern() {
    local pattern="$1"
    local commit="${2:-HEAD}"
    local actual=$(get_commit_message "$commit")
    
    if [[ "$actual" =~ $pattern ]]; then
        return 0
    else
        echo "Message '$actual' does not match pattern '$pattern'"
        return 1
    fi
}

# Verify commit message format (conventional commits)
verify_conventional_commit() {
    local commit="${1:-HEAD}"
    local message=$(get_commit_message "$commit")
    
    if validate_commit_message "$message"; then
        return 0
    else
        echo "Commit message '$message' does not follow conventional commit format"
        return 1
    fi
}

# Verify all commits follow conventional format
verify_all_conventional_commits() {
    local branch="${1:-HEAD}"
    local base="${2:-$(get_root_commit)}"
    
    local commits=$(git log --pretty=format:"%H" "$base..$branch")
    
    for commit in $commits; do
        if ! verify_conventional_commit "$commit"; then
            return 1
        fi
    done
    
    return 0
}

# Verify commit author
verify_commit_author() {
    local expected="$1"
    local commit="${2:-HEAD}"
    local actual=$(get_commit_author "$commit")
    
    if [[ "$actual" == "$expected" ]]; then
        return 0
    else
        echo "Expected author: '$expected', found: '$actual'"
        return 1
    fi
}

# Verify file exists
verify_file_exists() {
    local file="$1"
    local commit="${2:-HEAD}"
    
    if file_exists_at_commit "$commit" "$file"; then
        return 0
    else
        echo "File '$file' does not exist at commit $commit"
        return 1
    fi
}

# Verify file content
verify_file_content() {
    local file="$1"
    local expected="$2"
    local commit="${3:-HEAD}"
    
    if ! file_exists_at_commit "$commit" "$file"; then
        echo "File '$file' does not exist at commit $commit"
        return 1
    fi
    
    local actual=$(get_file_at_commit "$commit" "$file")
    
    if [[ "$actual" == "$expected" ]]; then
        return 0
    else
        echo "File '$file' content mismatch"
        echo "Expected: '$expected'"
        echo "Actual: '$actual'"
        return 1
    fi
}

# Verify file content pattern
verify_file_content_pattern() {
    local file="$1"
    local pattern="$2"
    local commit="${3:-HEAD}"
    
    if ! file_exists_at_commit "$commit" "$file"; then
        echo "File '$file' does not exist at commit $commit"
        return 1
    fi
    
    local content=$(get_file_at_commit "$commit" "$file")
    
    if [[ "$content" =~ $pattern ]]; then
        return 0
    else
        echo "File '$file' content does not match pattern '$pattern'"
        return 1
    fi
}

# Verify working directory is clean
verify_clean_working_dir() {
    if is_working_dir_clean; then
        return 0
    else
        echo "Working directory is not clean"
        echo "Uncommitted changes:"
        git status --porcelain
        return 1
    fi
}

# Verify branch exists
verify_branch_exists() {
    local branch="$1"
    
    if branch_exists "$branch"; then
        return 0
    else
        echo "Branch '$branch' does not exist"
        return 1
    fi
}

# Verify current branch
verify_current_branch() {
    local expected="$1"
    local actual=$(get_current_branch)
    
    if [[ "$actual" == "$expected" ]]; then
        return 0
    else
        echo "Expected branch: '$expected', current branch: '$actual'"
        return 1
    fi
}

# Verify branch does not exist
verify_branch_not_exists() {
    local branch="$1"
    
    if ! branch_exists "$branch"; then
        return 0
    else
        echo "Branch '$branch' should not exist"
        return 1
    fi
}

# Verify merge commit does not exist
verify_no_merge_commits() {
    local branch="${1:-HEAD}"
    local base="${2:-$(get_root_commit)}"
    
    local merge_commits=$(git log --merges --pretty=format:"%H" "$base..$branch")
    
    if [[ -z "$merge_commits" ]]; then
        return 0
    else
        echo "Found merge commits (linear history expected):"
        echo "$merge_commits"
        return 1
    fi
}

# Verify linear history
verify_linear_history() {
    local branch="${1:-HEAD}"
    local base="${2:-$(get_root_commit)}"
    
    verify_no_merge_commits "$branch" "$base"
}

# Verify commit order
verify_commit_order() {
    local branch="${1:-HEAD}"
    shift
    local expected_messages=("$@")
    
    local actual_messages=()
    while IFS= read -r message; do
        actual_messages+=("$message")
    done < <(git log --pretty=format:"%s" --reverse "$branch" | head -n ${#expected_messages[@]})
    
    if [[ ${#actual_messages[@]} -ne ${#expected_messages[@]} ]]; then
        echo "Expected ${#expected_messages[@]} commits, found ${#actual_messages[@]}"
        return 1
    fi
    
    for i in "${!expected_messages[@]}"; do
        if [[ "${actual_messages[$i]}" != "${expected_messages[$i]}" ]]; then
            echo "Commit $((i+1)): expected '${expected_messages[$i]}', found '${actual_messages[$i]}'"
            return 1
        fi
    done
    
    return 0
}

# Verify files changed in commit
verify_files_changed() {
    local commit="$1"
    shift
    local expected_files=("$@")
    
    local actual_files=()
    while IFS= read -r file; do
        actual_files+=("$file")
    done < <(get_changed_files "$commit" | sort)
    
    local sorted_expected=($(printf '%s\n' "${expected_files[@]}" | sort))
    
    if [[ ${#actual_files[@]} -ne ${#sorted_expected[@]} ]]; then
        echo "Expected ${#sorted_expected[@]} files changed, found ${#actual_files[@]}"
        return 1
    fi
    
    for i in "${!sorted_expected[@]}"; do
        if [[ "${actual_files[$i]}" != "${sorted_expected[$i]}" ]]; then
            echo "File $((i+1)): expected '${sorted_expected[$i]}', found '${actual_files[$i]}'"
            return 1
        fi
    done
    
    return 0
}

# Verify repository integrity
verify_repo_integrity() {
    # Check if we're in a git repository
    if ! is_git_repo; then
        echo "Not in a git repository"
        return 1
    fi
    
    # Check for corruption
    if ! git fsck --quiet 2>/dev/null; then
        echo "Repository integrity check failed"
        return 1
    fi
    
    return 0
}

# Verify no data loss
verify_no_data_loss() {
    local before_snapshot="$1"
    local after_snapshot="$2"
    
    # Compare file contents between snapshots
    local before_files=$(echo "$before_snapshot" | jq -r '.files | keys[]')
    local after_files=$(echo "$after_snapshot" | jq -r '.files | keys[]')
    
    # Check that no files were lost
    for file in $before_files; do
        if ! echo "$after_files" | grep -q "^$file$"; then
            echo "File '$file' was lost"
            return 1
        fi
        
        local before_content=$(echo "$before_snapshot" | jq -r ".files[\"$file\"]")
        local after_content=$(echo "$after_snapshot" | jq -r ".files[\"$file\"]")
        
        if [[ "$before_content" != "$after_content" ]]; then
            echo "Content of file '$file' changed unexpectedly"
            return 1
        fi
    done
    
    return 0
}

# Create repository snapshot
create_repo_snapshot() {
    local snapshot="{\"files\": {}"
    
    # Get all tracked files
    local files=$(git ls-files)
    
    for file in $files; do
        local content=$(git show HEAD:"$file" | jq -Rs .)
        snapshot=$(echo "$snapshot" | jq ".files[\"$file\"] = $content")
    done
    
    snapshot=$(echo "$snapshot" | jq .)
    echo "$snapshot"
}

# Verify efficiency metrics
verify_efficiency() {
    local max_commands="$1"
    local max_time="$2"
    local actual_commands="${3:-0}"
    local actual_time="${4:-0}"
    
    local efficiency_score=100
    
    if [[ $actual_commands -gt $max_commands ]]; then
        echo "Command count exceeded target: $actual_commands > $max_commands"
        efficiency_score=$((efficiency_score - 20))
    fi
    
    if [[ $actual_time -gt $max_time ]]; then
        echo "Time exceeded target: ${actual_time}s > ${max_time}s"
        efficiency_score=$((efficiency_score - 20))
    fi
    
    echo "Efficiency score: $efficiency_score%"
    
    if [[ $efficiency_score -ge 80 ]]; then
        return 0
    else
        return 1
    fi
}

# Common verification patterns
verify_squash_pattern() {
    local original_count="$1"
    local expected_count="$2"
    
    add_verification_test "Commit count reduced" "verify_commit_count $expected_count" 2
    add_verification_test "Linear history maintained" "verify_linear_history" 1
    add_verification_test "Working directory clean" "verify_clean_working_dir" 1
}

verify_rebase_pattern() {
    add_verification_test "No merge commits" "verify_no_merge_commits" 2
    add_verification_test "Linear history" "verify_linear_history" 2
    add_verification_test "Working directory clean" "verify_clean_working_dir" 1
}

verify_message_pattern() {
    add_verification_test "Conventional commit format" "verify_all_conventional_commits" 3
    add_verification_test "Working directory clean" "verify_clean_working_dir" 1
}

# Export verification functions
export -f init_verification add_verification_test show_verification_results
export -f verify_commit_count verify_commit_message verify_file_exists
export -f verify_clean_working_dir verify_branch_exists verify_linear_history
export -f verify_efficiency verify_squash_pattern verify_rebase_pattern verify_message_pattern