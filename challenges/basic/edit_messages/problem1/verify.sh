#!/bin/bash
set -euo pipefail

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Expected commit count (excluding initial setup commit)
EXPECTED_COMMITS=6

echo -e "${BLUE}🔍 Verifying Edit Messages Challenge 1...${NC}"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ Not in a Git repository${NC}"
    exit 1
fi

# Function to verify commit count
verify_commit_count() {
    local actual_count=$(git rev-list --count HEAD)
    
    if [ "$actual_count" -eq "$EXPECTED_COMMITS" ]; then
        echo -e "${GREEN}✅ Correct number of commits: $actual_count${NC}"
        return 0
    else
        echo -e "${RED}❌ Expected $EXPECTED_COMMITS commits, found $actual_count${NC}"
        echo -e "${YELLOW}💡 Hint: You should have the initial commit plus 5 feature commits${NC}"
        return 1
    fi
}

# Function to verify commit messages are improved
verify_commit_messages() {
    local has_issues=false
    
    # Get commit messages (excluding the initial setup commit)
    local messages=$(git log --format="%s" HEAD~5..HEAD)
    
    echo -e "${BLUE}📝 Checking commit message quality...${NC}"
    
    # Check for vague/unclear messages
    local bad_patterns=("fix stuff" "update code" "changes" "more stuff" "add some tests")
    
    for pattern in "${bad_patterns[@]}"; do
        if echo "$messages" | grep -qi "$pattern"; then
            echo -e "${RED}❌ Found unclear commit message: '$pattern'${NC}"
            has_issues=true
        fi
    done
    
    # Check for improved messages
    local good_indicators=("Add" "Implement" "Fix" "Update" "Remove" "Create")
    local good_count=0
    
    while IFS= read -r message; do
        if [ -n "$message" ]; then
            # Check if message starts with a proper verb
            for indicator in "${good_indicators[@]}"; do
                if echo "$message" | grep -q "^$indicator"; then
                    good_count=$((good_count + 1))
                    break
                fi
            done
            
            # Check message length (should be reasonable)
            if [ ${#message} -lt 10 ]; then
                echo -e "${YELLOW}⚠️  Very short commit message: '$message'${NC}"
                has_issues=true
            elif [ ${#message} -gt 72 ]; then
                echo -e "${YELLOW}⚠️  Long commit message (>72 chars): '$message'${NC}"
                echo -e "${YELLOW}   Consider making it more concise${NC}"
            fi
        fi
    done <<< "$messages"
    
    if [ "$good_count" -ge 3 ]; then
        echo -e "${GREEN}✅ Found $good_count well-structured commit messages${NC}"
    else
        echo -e "${RED}❌ Only $good_count commit messages follow good practices${NC}"
        echo -e "${YELLOW}💡 Hint: Use imperative mood (Add, Fix, Update, etc.)${NC}"
        has_issues=true
    fi
    
    if [ "$has_issues" = true ]; then
        return 1
    else
        return 0
    fi
}

# Function to verify file integrity
verify_file_integrity() {
    # Check that all expected files exist
    local expected_files=("src/app.js" "package.json" "README.md" "tests/app.test.js")
    
    for file in "${expected_files[@]}"; do
        if [ ! -f "$file" ]; then
            echo -e "${RED}❌ Missing expected file: $file${NC}"
            return 1
        fi
    done
    
    # Check that the main functionality is intact
    if ! grep -q "express" src/app.js; then
        echo -e "${RED}❌ Express.js setup appears to be missing${NC}"
        return 1
    fi
    
    if ! grep -q "auth" src/app.js; then
        echo -e "${RED}❌ Authentication middleware appears to be missing${NC}"
        return 1
    fi
    
    if ! grep -q "/api/users" src/app.js; then
        echo -e "${RED}❌ API endpoints appear to be missing${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ All files and functionality intact${NC}"
    return 0
}

# Function to show current commit history
show_commit_history() {
    echo -e "${BLUE}📋 Current commit history:${NC}"
    git log --oneline --decorate -6
    echo ""
}

# Function to provide helpful feedback
provide_feedback() {
    echo -e "${BLUE}💡 Commit Message Best Practices:${NC}"
    echo "• Start with a verb in imperative mood (Add, Fix, Update, etc.)"
    echo "• Be specific about what was changed"
    echo "• Keep the subject line under 72 characters"
    echo "• Use present tense as if completing 'This commit will...'"
    echo ""
    echo -e "${BLUE}📖 Example good messages:${NC}"
    echo "• Add JSON body parsing middleware to Express app"
    echo "• Implement authentication middleware for API routes"
    echo "• Add user management endpoints (GET and POST)"
    echo "• Add error handling middleware for server errors"
    echo "• Add unit tests for API endpoints and authentication"
}

# Main verification
main() {
    local all_passed=true
    
    if ! verify_commit_count; then
        all_passed=false
    fi
    
    if ! verify_commit_messages; then
        all_passed=false
    fi
    
    if ! verify_file_integrity; then
        all_passed=false
    fi
    
    echo ""
    show_commit_history
    
    if [ "$all_passed" = true ]; then
        echo -e "${GREEN}🎉 Challenge completed successfully!${NC}"
        echo -e "${GREEN}✅ Your commit messages are now clear and descriptive${NC}"
        echo -e "${GREEN}💡 Key concepts mastered: git rebase -i, reword command, good commit messages${NC}"
        echo ""
        echo -e "${BLUE}🚀 Ready for the next challenge!${NC}"
        exit 0
    else
        echo -e "${RED}❌ Challenge not completed${NC}"
        echo -e "${YELLOW}💡 Hint: Use 'git rebase -i HEAD~5' and change 'pick' to 'reword' for unclear messages${NC}"
        echo ""
        provide_feedback
        exit 1
    fi
}

# Run main function
main