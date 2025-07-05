#!/bin/bash
set -euo pipefail

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Expected commit count (including initial setup commit)
EXPECTED_COMMITS=7

echo -e "${BLUE}🔍 Verifying Edit Messages Challenge 2: Conventional Commits...${NC}"

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
        echo -e "${YELLOW}💡 Hint: You should have the initial commit plus 6 feature commits${NC}"
        return 1
    fi
}

# Function to verify conventional commit format
verify_conventional_format() {
    local has_issues=false
    local conventional_count=0
    
    # Get commit messages (excluding the initial setup commit)
    local messages=$(git log --format="%s" HEAD~6..HEAD)
    
    echo -e "${BLUE}📝 Checking conventional commit format...${NC}"
    
    # Valid conventional commit types
    local valid_types=("feat" "fix" "docs" "test" "build" "refactor" "style" "ci" "chore")
    
    # Check for old informal messages
    local old_patterns=("added power function" "build configuration" "fixed error message" "unit tests for calculator" "documentation update" "contributing guidelines")
    
    for pattern in "${old_patterns[@]}"; do
        if echo "$messages" | grep -qi "$pattern"; then
            echo -e "${RED}❌ Found unconverted informal message: '$pattern'${NC}"
            has_issues=true
        fi
    done
    
    # Check each commit message for conventional format
    while IFS= read -r message; do
        if [ -n "$message" ]; then
            # Check if message follows conventional format (type: description)
            if echo "$message" | grep -q "^[a-z]\+:"; then
                # Extract the type
                local type=$(echo "$message" | sed 's/:.*$//')
                
                # Check if type is valid
                local valid_type=false
                for valid in "${valid_types[@]}"; do
                    if [ "$type" = "$valid" ]; then
                        valid_type=true
                        conventional_count=$((conventional_count + 1))
                        break
                    fi
                done
                
                if [ "$valid_type" = false ]; then
                    echo -e "${YELLOW}⚠️  Invalid conventional commit type: '$type' in message: '$message'${NC}"
                    has_issues=true
                fi
                
                # Check if description exists and is reasonable
                local description=$(echo "$message" | sed 's/^[a-z]\+: *//')
                if [ ${#description} -lt 5 ]; then
                    echo -e "${YELLOW}⚠️  Very short description in: '$message'${NC}"
                    has_issues=true
                fi
            else
                echo -e "${RED}❌ Message doesn't follow conventional format: '$message'${NC}"
                echo -e "${YELLOW}   Expected format: type: description${NC}"
                has_issues=true
            fi
        fi
    done <<< "$messages"
    
    echo -e "${GREEN}✅ Found $conventional_count properly formatted conventional commits${NC}"
    
    if [ "$conventional_count" -ge 5 ]; then
        echo -e "${GREEN}✅ Most commits follow conventional format${NC}"
    else
        echo -e "${RED}❌ Only $conventional_count commits follow conventional format${NC}"
        echo -e "${YELLOW}💡 Hint: Use format 'type: description' (e.g., 'feat: add new feature')${NC}"
        has_issues=true
    fi
    
    if [ "$has_issues" = true ]; then
        return 1
    else
        return 0
    fi
}

# Function to verify specific conventional commit types are used correctly
verify_commit_types() {
    local messages=$(git log --format="%s" HEAD~6..HEAD)
    local has_issues=false
    
    echo -e "${BLUE}🔍 Checking appropriate use of conventional commit types...${NC}"
    
    # Check for expected types based on the changes
    if ! echo "$messages" | grep -q "^feat:"; then
        echo -e "${YELLOW}⚠️  Expected at least one 'feat:' commit for new functionality${NC}"
        has_issues=true
    fi
    
    if ! echo "$messages" | grep -q "^fix:"; then
        echo -e "${YELLOW}⚠️  Expected at least one 'fix:' commit for bug fixes${NC}"
        has_issues=true
    fi
    
    if ! echo "$messages" | grep -q "^docs:"; then
        echo -e "${YELLOW}⚠️  Expected at least one 'docs:' commit for documentation${NC}"
        has_issues=true
    fi
    
    if ! echo "$messages" | grep -q "^test:"; then
        echo -e "${YELLOW}⚠️  Expected at least one 'test:' commit for test additions${NC}"
        has_issues=true
    fi
    
    if ! echo "$messages" | grep -q "^build:"; then
        echo -e "${YELLOW}⚠️  Expected at least one 'build:' commit for build configuration${NC}"
        has_issues=true
    fi
    
    if [ "$has_issues" = false ]; then
        echo -e "${GREEN}✅ Good variety of conventional commit types used${NC}"
    fi
    
    return 0  # Don't fail on this check, just provide feedback
}

# Function to verify file integrity
verify_file_integrity() {
    # Check that all expected files exist
    local expected_files=("src/calculator.js" "package.json" "README.md" "src/calculator.test.js" "docs/API.md" "CONTRIBUTING.md" ".babelrc")
    
    for file in "${expected_files[@]}"; do
        if [ ! -f "$file" ]; then
            echo -e "${RED}❌ Missing expected file: $file${NC}"
            return 1
        fi
    done
    
    # Check that the calculator functionality is intact
    if ! grep -q "power" src/calculator.js; then
        echo -e "${RED}❌ Power function appears to be missing${NC}"
        return 1
    fi
    
    if ! grep -q "Cannot divide by zero" src/calculator.js; then
        echo -e "${RED}❌ Fixed error message appears to be missing${NC}"
        return 1
    fi
    
    if ! grep -q "test" src/calculator.test.js; then
        echo -e "${RED}❌ Unit tests appear to be missing${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ All files and functionality intact${NC}"
    return 0
}

# Function to show current commit history
show_commit_history() {
    echo -e "${BLUE}📋 Current commit history:${NC}"
    git log --oneline --decorate -7
    echo ""
}

# Function to provide helpful feedback
provide_feedback() {
    echo -e "${BLUE}💡 Conventional Commit Format:${NC}"
    echo "• feat: A new feature"
    echo "• fix: A bug fix"
    echo "• docs: Documentation only changes"
    echo "• test: Adding missing tests or correcting existing tests"
    echo "• build: Changes that affect the build system or external dependencies"
    echo "• refactor: A code change that neither fixes a bug nor adds a feature"
    echo "• style: Changes that do not affect the meaning of the code"
    echo "• ci: Changes to CI configuration files and scripts"
    echo "• chore: Other changes that don't modify src or test files"
    echo ""
    echo -e "${BLUE}📖 Example conventional messages:${NC}"
    echo "• feat: add power function for exponentiation"
    echo "• fix: improve error message clarity in divide method"
    echo "• docs: add API documentation for calculator methods"
    echo "• test: add comprehensive unit tests for all calculator methods"
    echo "• build: add Babel configuration for ES6 transpilation"
}

# Main verification
main() {
    local all_passed=true
    
    if ! verify_commit_count; then
        all_passed=false
    fi
    
    if ! verify_conventional_format; then
        all_passed=false
    fi
    
    verify_commit_types  # This provides feedback but doesn't fail
    
    if ! verify_file_integrity; then
        all_passed=false
    fi
    
    echo ""
    show_commit_history
    
    if [ "$all_passed" = true ]; then
        echo -e "${GREEN}🎉 Challenge completed successfully!${NC}"
        echo -e "${GREEN}✅ All commits now follow conventional commit format${NC}"
        echo -e "${GREEN}💡 Key concepts mastered: conventional commits, open source standards${NC}"
        echo -e "${GREEN}🚀 Your commits are now ready for open source contribution!${NC}"
        echo ""
        echo -e "${BLUE}📚 Next: Learn about squashing commits to create atomic changes${NC}"
        exit 0
    else
        echo -e "${RED}❌ Challenge not completed${NC}"
        echo -e "${YELLOW}💡 Hint: Use 'git rebase -i HEAD~6' and reword commits to conventional format${NC}"
        echo ""
        provide_feedback
        exit 1
    fi
}

# Run main function
main