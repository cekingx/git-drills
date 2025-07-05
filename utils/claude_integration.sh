#!/bin/bash

# Claude Integration
# Functions for integrating with Claude Code for hints and explanations

source "${SCRIPT_DIR}/config.sh"

# Claude integration settings
CLAUDE_ENABLED="${ENABLE_CLAUDE_INTEGRATION:-true}"
CLAUDE_API_BASE="https://api.anthropic.com/v1"
CLAUDE_MAX_TOKENS=2000
CLAUDE_TEMPERATURE=0.7

# Color codes for Claude output
CLAUDE_BLUE='\033[0;34m'
CLAUDE_GREEN='\033[0;32m'
CLAUDE_YELLOW='\033[1;33m'
CLAUDE_PURPLE='\033[0;35m'
CLAUDE_NC='\033[0m' # No Color

# Check if Claude integration is available
is_claude_available() {
    if [[ "$CLAUDE_ENABLED" != "true" ]]; then
        return 1
    fi
    
    # Check if claude command is available
    if ! command -v claude &> /dev/null; then
        return 1
    fi
    
    return 0
}

# Generate context-aware hint
generate_claude_hint() {
    local level="$1"
    local concept="$2"
    local problem="$3"
    local current_state="$4"
    
    if ! is_claude_available; then
        echo -e "${CLAUDE_YELLOW}Claude integration not available. Using built-in hints.${CLAUDE_NC}"
        return 1
    fi
    
    local prompt="You are a Git expert helping a student with a Git challenge.

Challenge Details:
- Level: $level
- Concept: $concept
- Problem: $problem

Current Git State:
$current_state

Please provide a helpful hint (2-3 sentences) that guides the student toward the solution without giving the complete answer. Focus on the next step they should take or the Git command they should consider using.

Hint:"
    
    echo -e "${CLAUDE_BLUE}🤖 Getting Claude hint...${CLAUDE_NC}"
    
    local hint=$(claude --prompt "$prompt" --max-tokens 200 --temperature 0.5 2>/dev/null)
    
    if [[ -n "$hint" ]]; then
        echo -e "${CLAUDE_GREEN}💡 Claude Hint:${CLAUDE_NC}"
        echo -e "${CLAUDE_PURPLE}$hint${CLAUDE_NC}"
        return 0
    else
        echo -e "${CLAUDE_YELLOW}Failed to get Claude hint. Using built-in hints.${CLAUDE_NC}"
        return 1
    fi
}

# Generate detailed explanation
generate_claude_explanation() {
    local level="$1"
    local concept="$2"
    local problem="$3"
    local solution_state="$4"
    
    if ! is_claude_available; then
        echo -e "${CLAUDE_YELLOW}Claude integration not available. Using built-in explanations.${CLAUDE_NC}"
        return 1
    fi
    
    local prompt="You are a Git expert explaining a completed Git challenge solution.

Challenge Details:
- Level: $level
- Concept: $concept
- Problem: $problem

Final Git State:
$solution_state

Please provide a detailed explanation (4-5 sentences) that covers:
1. What Git operations were performed
2. Why these operations were necessary
3. How this relates to real-world Git workflows
4. Key concepts the student should remember

Explanation:"
    
    echo -e "${CLAUDE_BLUE}🤖 Getting Claude explanation...${CLAUDE_NC}"
    
    local explanation=$(claude --prompt "$prompt" --max-tokens 400 --temperature 0.6 2>/dev/null)
    
    if [[ -n "$explanation" ]]; then
        echo -e "${CLAUDE_GREEN}📚 Claude Explanation:${CLAUDE_NC}"
        echo -e "${CLAUDE_PURPLE}$explanation${CLAUDE_NC}"
        return 0
    else
        echo -e "${CLAUDE_YELLOW}Failed to get Claude explanation. Using built-in explanations.${CLAUDE_NC}"
        return 1
    fi
}

# Generate new challenge
generate_claude_challenge() {
    local level="$1"
    local concept="$2"
    
    if ! is_claude_available; then
        echo -e "${CLAUDE_YELLOW}Claude integration not available. Cannot generate challenges.${CLAUDE_NC}"
        return 1
    fi
    
    local prompt="You are a Git expert creating a new Git challenge.

Requirements:
- Level: $level
- Concept: $concept

Please generate a complete challenge including:
1. A realistic scenario description
2. Initial Git repository setup commands
3. Clear goal statement
4. Verification criteria
5. Expected solution approach

Format the response as a structured challenge that can be used in the Git Drills system.

Challenge:"
    
    echo -e "${CLAUDE_BLUE}🤖 Generating Claude challenge...${CLAUDE_NC}"
    
    local challenge=$(claude --prompt "$prompt" --max-tokens 800 --temperature 0.8 2>/dev/null)
    
    if [[ -n "$challenge" ]]; then
        echo -e "${CLAUDE_GREEN}🎯 Generated Challenge:${CLAUDE_NC}"
        echo -e "${CLAUDE_PURPLE}$challenge${CLAUDE_NC}"
        return 0
    else
        echo -e "${CLAUDE_YELLOW}Failed to generate Claude challenge.${CLAUDE_NC}"
        return 1
    fi
}

# Get solution alternatives
get_claude_alternatives() {
    local level="$1"
    local concept="$2"
    local current_solution="$3"
    
    if ! is_claude_available; then
        echo -e "${CLAUDE_YELLOW}Claude integration not available. Cannot show alternatives.${CLAUDE_NC}"
        return 1
    fi
    
    local prompt="You are a Git expert analyzing a solution to a Git challenge.

Challenge Details:
- Level: $level
- Concept: $concept

Current Solution:
$current_solution

Please provide 2-3 alternative approaches to solve this same problem. For each alternative, explain:
1. The different Git commands that could be used
2. Pros and cons compared to the current solution
3. When you might prefer this alternative

Alternatives:"
    
    echo -e "${CLAUDE_BLUE}🤖 Getting Claude alternatives...${CLAUDE_NC}"
    
    local alternatives=$(claude --prompt "$prompt" --max-tokens 600 --temperature 0.7 2>/dev/null)
    
    if [[ -n "$alternatives" ]]; then
        echo -e "${CLAUDE_GREEN}🔄 Alternative Solutions:${CLAUDE_NC}"
        echo -e "${CLAUDE_PURPLE}$alternatives${CLAUDE_NC}"
        return 0
    else
        echo -e "${CLAUDE_YELLOW}Failed to get Claude alternatives.${CLAUDE_NC}"
        return 1
    fi
}

# Analyze solution efficiency
analyze_claude_efficiency() {
    local commands_used="$1"
    local time_taken="$2"
    local level="$3"
    local concept="$4"
    
    if ! is_claude_available; then
        echo -e "${CLAUDE_YELLOW}Claude integration not available. Cannot analyze efficiency.${CLAUDE_NC}"
        return 1
    fi
    
    local prompt="You are a Git expert analyzing the efficiency of a Git solution.

Solution Details:
- Commands used: $commands_used
- Time taken: $time_taken seconds
- Level: $level
- Concept: $concept

Please provide an efficiency analysis that includes:
1. Assessment of command usage (too many/too few/optimal)
2. Suggestions for improving efficiency
3. Common patterns that could be optimized
4. Time management tips for similar challenges

Analysis:"
    
    echo -e "${CLAUDE_BLUE}🤖 Getting Claude efficiency analysis...${CLAUDE_NC}"
    
    local analysis=$(claude --prompt "$analysis" --max-tokens 500 --temperature 0.6 2>/dev/null)
    
    if [[ -n "$analysis" ]]; then
        echo -e "${CLAUDE_GREEN}⚡ Efficiency Analysis:${CLAUDE_NC}"
        echo -e "${CLAUDE_PURPLE}$analysis${CLAUDE_NC}"
        return 0
    else
        echo -e "${CLAUDE_YELLOW}Failed to get Claude efficiency analysis.${CLAUDE_NC}"
        return 1
    fi
}

# Get conceptual explanation
get_claude_concept_explanation() {
    local concept="$1"
    local level="$2"
    
    if ! is_claude_available; then
        echo -e "${CLAUDE_YELLOW}Claude integration not available. Cannot explain concepts.${CLAUDE_NC}"
        return 1
    fi
    
    local prompt="You are a Git expert explaining a Git concept to a student.

Concept: $concept
Level: $level

Please provide a clear explanation suitable for a $level level student that covers:
1. What this concept is and why it's important
2. Common use cases in real-world development
3. Best practices and common pitfalls
4. How it relates to other Git concepts

Keep the explanation practical and focused on actionable knowledge.

Explanation:"
    
    echo -e "${CLAUDE_BLUE}🤖 Getting Claude concept explanation...${CLAUDE_NC}"
    
    local explanation=$(claude --prompt "$prompt" --max-tokens 600 --temperature 0.6 2>/dev/null)
    
    if [[ -n "$explanation" ]]; then
        echo -e "${CLAUDE_GREEN}📖 Concept Explanation:${CLAUDE_NC}"
        echo -e "${CLAUDE_PURPLE}$explanation${CLAUDE_NC}"
        return 0
    else
        echo -e "${CLAUDE_YELLOW}Failed to get Claude concept explanation.${CLAUDE_NC}"
        return 1
    fi
}

# Get current Git state for context
get_git_state_context() {
    local context=""
    
    if is_git_repo; then
        context+="Current branch: $(get_current_branch)\n"
        context+="Commit count: $(get_commit_count)\n"
        context+="Working directory: $(is_working_dir_clean && echo "clean" || echo "dirty")\n"
        context+="Recent commits:\n"
        context+="$(git log --oneline -5 2>/dev/null || echo "No commits")\n"
        context+="Branch status:\n"
        context+="$(git status --porcelain 2>/dev/null || echo "No git repository")\n"
    else
        context="Not in a git repository"
    fi
    
    echo -e "$context"
}

# Interactive Claude session
start_claude_session() {
    local level="$1"
    local concept="$2"
    local problem="$3"
    
    if ! is_claude_available; then
        echo -e "${CLAUDE_YELLOW}Claude integration not available.${CLAUDE_NC}"
        return 1
    fi
    
    echo -e "${CLAUDE_BLUE}🤖 Starting Claude interactive session...${CLAUDE_NC}"
    echo -e "${CLAUDE_GREEN}Context: $level/$concept/problem$problem${CLAUDE_NC}"
    echo -e "${CLAUDE_YELLOW}Type 'help' for available commands, 'exit' to quit${CLAUDE_NC}"
    echo
    
    while true; do
        echo -e "${CLAUDE_PURPLE}Claude> ${CLAUDE_NC}"
        read -r input
        
        case "$input" in
            "help")
                echo -e "${CLAUDE_BLUE}Available commands:${CLAUDE_NC}"
                echo -e "  hint     - Get a helpful hint"
                echo -e "  explain  - Get detailed explanation"
                echo -e "  concept  - Explain the concept"
                echo -e "  status   - Show current git state"
                echo -e "  exit     - Exit Claude session"
                ;;
            "hint")
                local state=$(get_git_state_context)
                generate_claude_hint "$level" "$concept" "$problem" "$state"
                ;;
            "explain")
                local state=$(get_git_state_context)
                generate_claude_explanation "$level" "$concept" "$problem" "$state"
                ;;
            "concept")
                get_claude_concept_explanation "$concept" "$level"
                ;;
            "status")
                echo -e "${CLAUDE_BLUE}Current Git State:${CLAUDE_NC}"
                echo -e "${CLAUDE_PURPLE}$(get_git_state_context)${CLAUDE_NC}"
                ;;
            "exit")
                echo -e "${CLAUDE_GREEN}Goodbye!${CLAUDE_NC}"
                break
                ;;
            "")
                # Empty input, just continue
                ;;
            *)
                echo -e "${CLAUDE_YELLOW}Unknown command. Type 'help' for available commands.${CLAUDE_NC}"
                ;;
        esac
        echo
    done
}

# Test Claude integration
test_claude_integration() {
    echo -e "${CLAUDE_BLUE}Testing Claude integration...${CLAUDE_NC}"
    
    if ! command -v claude &> /dev/null; then
        echo -e "${CLAUDE_YELLOW}⚠️  Claude CLI not found. Install with: pip install claude-cli${CLAUDE_NC}"
        return 1
    fi
    
    local test_prompt="Respond with 'Claude integration working' if you can see this message."
    local response=$(claude --prompt "$test_prompt" --max-tokens 50 2>/dev/null)
    
    if [[ "$response" == *"Claude integration working"* ]]; then
        echo -e "${CLAUDE_GREEN}✅ Claude integration is working!${CLAUDE_NC}"
        return 0
    else
        echo -e "${CLAUDE_YELLOW}⚠️  Claude integration test failed. Check your configuration.${CLAUDE_NC}"
        return 1
    fi
}

# Export Claude functions
export -f is_claude_available generate_claude_hint generate_claude_explanation
export -f get_claude_alternatives analyze_claude_efficiency get_claude_concept_explanation
export -f start_claude_session test_claude_integration