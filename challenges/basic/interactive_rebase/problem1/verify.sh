#!/bin/bash
set -euo pipefail

# Verification script for Interactive Rebase Problem 1

# Source verification utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../../../utils/verification.sh"

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Initialize verification
init_verification

echo -e "${BLUE}Verifying Interactive Rebase Problem 1 Solution...${NC}\n"

# Test 1: Check commit count on feature branch
verify_feature_branch_commit_count() {
    local feature_commits=$(git log --oneline main..feature/user-authentication | wc -l)
    if [[ $feature_commits -eq 3 ]]; then
        return 0
    else
        echo "Expected 3 commits on feature branch, found $feature_commits"
        return 1
    fi
}

# Test 2: Check commit messages follow conventional format
verify_conventional_commits() {
    local commits=$(git log --pretty=format:"%s" main..feature/user-authentication)
    local expected_patterns=(
        "^(feat|feature): add [Uu]ser class.*auth"
        "^(test|tests): add.*user.*auth"
        "^(docs|doc): update.*doc.*auth"
    )
    
    local commit_array=()
    while IFS= read -r line; do
        commit_array+=("$line")
    done <<< "$commits"
    
    # Reverse order to check from oldest to newest
    local reversed_commits=()
    for (( i=${#commit_array[@]}-1 ; i>=0 ; i-- )); do
        reversed_commits+=("${commit_array[i]}")
    done
    
    for i in "${!expected_patterns[@]}"; do
        if [[ ! "${reversed_commits[i]}" =~ ${expected_patterns[i]} ]]; then
            echo "Commit $((i+1)) doesn't match expected pattern"
            echo "Expected pattern: ${expected_patterns[i]}"
            echo "Actual message: ${reversed_commits[i]}"
            return 1
        fi
    done
    
    return 0
}

# Test 3: Check that all files exist and have correct content
verify_files_integrity() {
    # Check that User class exists and has authentication method
    if ! git show HEAD:src/user.js | grep -q "authenticate"; then
        echo "User class missing authenticate method"
        return 1
    fi
    
    # Check that tests exist
    if ! git show HEAD:tests/user.test.js | grep -q "User"; then
        echo "User tests missing"
        return 1
    fi
    
    # Check that documentation is updated
    if ! git show HEAD:docs/README.md | grep -q "Authentication"; then
        echo "Documentation not updated"
        return 1
    fi
    
    # Check that no debug code remains
    if git show HEAD:src/user.js | grep -q "DEBUG"; then
        echo "Debug code still present in source"
        return 1
    fi
    
    if git show HEAD:tests/user.test.js | grep -q "DEBUG"; then
        echo "Debug code still present in tests"
        return 1
    fi
    
    return 0
}

# Test 4: Check linear history (no merge commits)
verify_linear_history() {
    local merge_commits=$(git log --merges --oneline main..feature/user-authentication | wc -l)
    if [[ $merge_commits -eq 0 ]]; then
        return 0
    else
        echo "Found $merge_commits merge commits (linear history expected)"
        return 1
    fi
}

# Test 5: Check working directory is clean
verify_clean_working_directory() {
    if [[ -z $(git status --porcelain) ]]; then
        return 0
    else
        echo "Working directory is not clean"
        git status --porcelain
        return 1
    fi
}

# Test 6: Check that we're on the feature branch
verify_current_branch() {
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    if [[ "$current_branch" == "feature/user-authentication" ]]; then
        return 0
    else
        echo "Expected to be on feature/user-authentication branch, currently on $current_branch"
        return 1
    fi
}

# Run all verification tests
echo -e "${BLUE}Running verification tests...${NC}\n"

add_verification_test "Feature branch has 3 commits" "verify_feature_branch_commit_count" 3
add_verification_test "Commits follow conventional format" "verify_conventional_commits" 3
add_verification_test "All files have correct content" "verify_files_integrity" 2
add_verification_test "History is linear (no merge commits)" "verify_linear_history" 1
add_verification_test "Working directory is clean" "verify_clean_working_directory" 1
add_verification_test "On correct branch" "verify_current_branch" 1

# Show results
echo -e "\n${BLUE}========================================${NC}"
if show_verification_results; then
    echo -e "${GREEN}🎉 Congratulations! You've successfully cleaned up the commit history!${NC}"
    echo -e "${GREEN}🎯 Key accomplishments:${NC}"
    echo -e "${GREEN}  • Reduced 8 messy commits to 3 logical commits${NC}"
    echo -e "${GREEN}  • Applied conventional commit message format${NC}"
    echo -e "${GREEN}  • Maintained all functionality while removing debug code${NC}"
    echo -e "${GREEN}  • Created a clean, review-ready history${NC}"
    echo -e "${GREEN}💡 Next steps: Practice with more complex rebase scenarios${NC}"
    exit 0
else
    echo -e "${RED}❌ Challenge not completed successfully${NC}"
    echo -e "${YELLOW}💡 Tips for success:${NC}"
    echo -e "${YELLOW}  • Use 'git rebase -i HEAD~8' to start interactive rebase${NC}"
    echo -e "${YELLOW}  • Squash debug commits into their related feature commits${NC}"
    echo -e "${YELLOW}  • Use 'reword' to improve commit messages${NC}"
    echo -e "${YELLOW}  • Follow conventional commit format: 'type: description'${NC}"
    echo -e "${YELLOW}  • Group related changes (implementation, tests, docs)${NC}"
    exit 1
fi