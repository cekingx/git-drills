#!/bin/bash
set -euo pipefail

# Verification script for Squash Commits Problem 1

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

echo -e "${BLUE}Verifying Squash Commits Problem 1 Solution...${NC}\n"

# Test 1: Check commit count on feature branch
verify_feature_branch_commit_count() {
    local feature_commits=$(git log --oneline main..feature/shopping-cart | wc -l)
    if [[ $feature_commits -eq 3 ]]; then
        return 0
    else
        echo "Expected 3 commits on feature branch, found $feature_commits"
        return 1
    fi
}

# Test 2: Check commit messages follow conventional format and logical grouping
verify_commit_messages() {
    local commits=$(git log --pretty=format:"%s" main..feature/shopping-cart)
    local commit_array=()
    while IFS= read -r line; do
        commit_array+=("$line")
    done <<< "$commits"
    
    # Reverse order to check from oldest to newest
    local reversed_commits=()
    for (( i=${#commit_array[@]}-1 ; i>=0 ; i-- )); do
        reversed_commits+=("${commit_array[i]}")
    done
    
    # Check for conventional format and logical content
    local expected_keywords=(
        "logic|core|class|cart\.js"
        "UI|component|html|css|styling"
        "integrat|main|connect|load"
    )
    
    for i in "${!expected_keywords[@]}"; do
        local commit_msg="${reversed_commits[i]}"
        
        # Check conventional format
        if [[ ! "$commit_msg" =~ ^(feat|feature): ]]; then
            echo "Commit $((i+1)) doesn't follow conventional format: $commit_msg"
            return 1
        fi
        
        # Check logical grouping
        if [[ ! "$commit_msg" =~ ${expected_keywords[i]} ]]; then
            echo "Commit $((i+1)) doesn't match expected logical grouping"
            echo "Expected keywords: ${expected_keywords[i]}"
            echo "Actual message: $commit_msg"
            return 1
        fi
    done
    
    return 0
}

# Test 3: Check that all files exist and have correct content
verify_files_integrity() {
    # Check cart.js has all methods
    local cart_content=$(git show HEAD:src/cart.js)
    if [[ ! "$cart_content" =~ "constructor" ]] || 
       [[ ! "$cart_content" =~ "addItem" ]] ||
       [[ ! "$cart_content" =~ "removeItem" ]] ||
       [[ ! "$cart_content" =~ "getTotalPrice" ]]; then
        echo "Shopping cart class missing required methods"
        return 1
    fi
    
    # Check cart component HTML exists
    if ! git show HEAD:components/cart.html | grep -q "cart-container"; then
        echo "Cart component HTML missing"
        return 1
    fi
    
    # Check cart styles exist
    if ! git show HEAD:styles/cart.css | grep -q "cart-container"; then
        echo "Cart styles missing"
        return 1
    fi
    
    # Check integration file exists
    if ! git show HEAD:src/main.js | grep -q "ShoppingCart"; then
        echo "Cart integration missing"
        return 1
    fi
    
    return 0
}

# Test 4: Check logical file grouping in commits
verify_logical_grouping() {
    local commits=$(git log --pretty=format:"%H" main..feature/shopping-cart)
    local commit_array=()
    while IFS= read -r line; do
        commit_array+=("$line")
    done <<< "$commits"
    
    # Reverse order to check from oldest to newest
    local reversed_commits=()
    for (( i=${#commit_array[@]}-1 ; i>=0 ; i-- )); do
        reversed_commits+=("${commit_array[i]}")
    done
    
    # Check first commit (logic) contains cart.js
    local first_commit_files=$(git show --name-only --pretty=format: "${reversed_commits[0]}")
    if [[ ! "$first_commit_files" =~ "src/cart.js" ]]; then
        echo "First commit should contain cart logic (src/cart.js)"
        return 1
    fi
    
    # Check second commit (UI) contains component and styles
    local second_commit_files=$(git show --name-only --pretty=format: "${reversed_commits[1]}")
    if [[ ! "$second_commit_files" =~ "components/cart.html" ]] || 
       [[ ! "$second_commit_files" =~ "styles/cart.css" ]]; then
        echo "Second commit should contain UI files (components/cart.html, styles/cart.css)"
        return 1
    fi
    
    # Check third commit (integration) contains main.js
    local third_commit_files=$(git show --name-only --pretty=format: "${reversed_commits[2]}")
    if [[ ! "$third_commit_files" =~ "src/main.js" ]]; then
        echo "Third commit should contain integration (src/main.js)"
        return 1
    fi
    
    return 0
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
    if [[ "$current_branch" == "feature/shopping-cart" ]]; then
        return 0
    else
        echo "Expected to be on feature/shopping-cart branch, currently on $current_branch"
        return 1
    fi
}

# Test 7: Check no merge commits exist
verify_no_merge_commits() {
    local merge_commits=$(git log --merges --oneline main..feature/shopping-cart | wc -l)
    if [[ $merge_commits -eq 0 ]]; then
        return 0
    else
        echo "Found $merge_commits merge commits (clean history expected)"
        return 1
    fi
}

# Run all verification tests
echo -e "${BLUE}Running verification tests...${NC}\n"

add_verification_test "Feature branch has 3 commits" "verify_feature_branch_commit_count" 3
add_verification_test "Commits follow conventional format and logical grouping" "verify_commit_messages" 3
add_verification_test "All files have correct content" "verify_files_integrity" 2
add_verification_test "Commits contain logically grouped files" "verify_logical_grouping" 3
add_verification_test "Working directory is clean" "verify_clean_working_directory" 1
add_verification_test "On correct branch" "verify_current_branch" 1
add_verification_test "No merge commits exist" "verify_no_merge_commits" 1

# Show results
echo -e "\n${BLUE}========================================${NC}"
if show_verification_results; then
    echo -e "${GREEN}🎉 Excellent! You've successfully squashed commits into logical units!${NC}"
    echo -e "${GREEN}🎯 Key accomplishments:${NC}"
    echo -e "${GREEN}  • Combined 10 WIP commits into 3 atomic commits${NC}"
    echo -e "${GREEN}  • Applied logical grouping (logic → UI → integration)${NC}"
    echo -e "${GREEN}  • Used conventional commit message format${NC}"
    echo -e "${GREEN}  • Maintained all functionality while improving history${NC}"
    echo -e "${GREEN}💡 Next steps: Practice squashing with conflict resolution${NC}"
    exit 0
else
    echo -e "${RED}❌ Challenge not completed successfully${NC}"
    echo -e "${YELLOW}💡 Tips for success:${NC}"
    echo -e "${YELLOW}  • Use 'git rebase -i HEAD~10' to start interactive rebase${NC}"
    echo -e "${YELLOW}  • Group related commits: cart logic, UI components, integration${NC}"
    echo -e "${YELLOW}  • Use 'pick' for first commit of each group, 'squash' for others${NC}"
    echo -e "${YELLOW}  • Write descriptive commit messages following conventional format${NC}"
    echo -e "${YELLOW}  • Think about logical flow: implement → display → connect${NC}"
    exit 1
fi