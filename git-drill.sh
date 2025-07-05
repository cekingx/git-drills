#!/bin/bash

set -euo pipefail

# Git Drills - Advanced Git Learning Tool
# Main CLI script for managing Git challenges and learning

# Source configuration and utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"
source "${SCRIPT_DIR}/utils/git_utils.sh"
source "${SCRIPT_DIR}/utils/verification.sh"
source "${SCRIPT_DIR}/utils/quiz.sh"

# Global variables
CURRENT_CHALLENGE=""
CURRENT_LEVEL=""
CURRENT_CONCEPT=""
CURRENT_PROBLEM=""
EFFICIENCY_MODE=false
SAFE_MODE=false
TRACK_COMMANDS=false
TRACK_TIME=false

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Usage information
usage() {
    cat << EOF
Git Drills - Advanced Git Learning Tool

USAGE:
    $0 [COMMAND] [OPTIONS]

COMMANDS:
    Challenge Management:
        --level LEVEL --concept CONCEPT [--problem N]
                                Run specific challenge
        --list [--level LEVEL] [--concept CONCEPT]
                                List available challenges
        --random [--level LEVEL]
                                Run random challenge

    Learning Aids:
        --quiz [--level LEVEL] [--concept CONCEPT]
                                Take quiz on concepts
        --hint                  Get hint for current challenge
        --explain               Get detailed explanation

    Progress Tracking:
        --progress              Show completion progress
        --stats                 Show detailed statistics
        --reset-progress        Reset all progress data

    Efficiency Features:
        --efficiency-mode       Enable efficiency tracking
        --track-commands        Track command usage
        --track-time           Track completion time
        --speed-challenge      Time-based challenge mode

    Git Features:
        --show-alternatives     Show alternative solutions
        --optimize-solution     Analyze solution efficiency
        --safe-mode            Create backup branches
        --recovery-mode        Practice with reflog

    Claude Integration:
        --generate --level LEVEL --concept CONCEPT
                                Generate new challenge
        --claude-hint          Get AI-powered hint
        --claude-explain       Get AI explanation

    Other:
        --help                 Show this help message
        --version              Show version information

LEVELS:
    basic, intermediate, advanced, workflows

CONCEPTS:
    Basic: interactive_rebase, squash_commits, reorder_commits, edit_messages, split_commits
    Intermediate: rebase_conflicts, branch_cleanup, history_rewriting, reflog_recovery, merge_to_rebase
    Advanced: complex_rebases, git_archaeology, workflow_optimization, advanced_recovery
    Workflows: feature_branch_flow, open_source_contribution, team_collaboration

EXAMPLES:
    $0 --level basic --concept interactive_rebase --problem 1
    $0 --random --level intermediate
    $0 --quiz --concept squash_commits
    $0 --progress
    $0 --safe-mode --level basic --concept interactive_rebase

EOF
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --level)
                CURRENT_LEVEL="$2"
                shift 2
                ;;
            --concept)
                CURRENT_CONCEPT="$2"
                shift 2
                ;;
            --problem)
                CURRENT_PROBLEM="$2"
                shift 2
                ;;
            --list)
                list_challenges
                exit 0
                ;;
            --random)
                run_random_challenge
                exit 0
                ;;
            --quiz)
                run_quiz
                exit 0
                ;;
            --hint)
                show_hint
                exit 0
                ;;
            --explain)
                show_explanation
                exit 0
                ;;
            --progress)
                show_progress
                exit 0
                ;;
            --stats)
                show_stats
                exit 0
                ;;
            --reset-progress)
                reset_progress
                exit 0
                ;;
            --efficiency-mode)
                EFFICIENCY_MODE=true
                shift
                ;;
            --track-commands)
                TRACK_COMMANDS=true
                shift
                ;;
            --track-time)
                TRACK_TIME=true
                shift
                ;;
            --speed-challenge)
                run_speed_challenge
                exit 0
                ;;
            --show-alternatives)
                show_alternatives
                exit 0
                ;;
            --optimize-solution)
                optimize_solution
                exit 0
                ;;
            --safe-mode)
                SAFE_MODE=true
                shift
                ;;
            --recovery-mode)
                RECOVERY_MODE=true
                shift
                ;;
            --generate)
                generate_challenge
                exit 0
                ;;
            --claude-hint)
                claude_hint
                exit 0
                ;;
            --claude-explain)
                claude_explain
                exit 0
                ;;
            --help)
                usage
                exit 0
                ;;
            --version)
                echo "Git Drills version $VERSION"
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
}

# Validate required arguments
validate_args() {
    if [[ -n "$CURRENT_LEVEL" && -n "$CURRENT_CONCEPT" ]]; then
        return 0
    fi
    
    if [[ -z "$CURRENT_LEVEL" && -z "$CURRENT_CONCEPT" ]]; then
        echo -e "${RED}Error: Must specify --level and --concept${NC}"
        echo "Use --help for usage information"
        exit 1
    fi
    
    if [[ -z "$CURRENT_LEVEL" ]]; then
        echo -e "${RED}Error: Must specify --level${NC}"
        exit 1
    fi
    
    if [[ -z "$CURRENT_CONCEPT" ]]; then
        echo -e "${RED}Error: Must specify --concept${NC}"
        exit 1
    fi
}

# List available challenges
list_challenges() {
    echo -e "${BLUE}Available Challenges:${NC}\n"
    
    for level in basic intermediate advanced workflows; do
        echo -e "${YELLOW}$level level:${NC}"
        
        level_dir="${CHALLENGES_DIR}/${level}"
        if [[ -d "$level_dir" ]]; then
            for concept_dir in "$level_dir"/*; do
                if [[ -d "$concept_dir" ]]; then
                    concept=$(basename "$concept_dir")
                    echo -e "  ${GREEN}$concept${NC}"
                    
                    problem_count=$(find "$concept_dir" -name "problem*" -type d | wc -l)
                    echo -e "    Problems: $problem_count"
                fi
            done
        else
            echo -e "    ${RED}No challenges available${NC}"
        fi
        echo
    done
}

# Run a specific challenge
run_challenge() {
    local level="$1"
    local concept="$2"
    local problem="${3:-1}"
    
    local challenge_dir="${CHALLENGES_DIR}/${level}/${concept}/problem${problem}"
    
    if [[ ! -d "$challenge_dir" ]]; then
        echo -e "${RED}Error: Challenge not found: $level/$concept/problem$problem${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}Starting Challenge: ${level}/${concept}/problem${problem}${NC}\n"
    
    # Setup challenge environment
    if [[ "$SAFE_MODE" == true ]]; then
        create_backup_branch
    fi
    
    # Initialize tracking if enabled
    if [[ "$TRACK_COMMANDS" == true ]]; then
        start_command_tracking
    fi
    
    if [[ "$TRACK_TIME" == true ]]; then
        start_time_tracking
    fi
    
    # Run challenge setup
    if [[ -f "${challenge_dir}/setup.sh" ]]; then
        echo -e "${YELLOW}Setting up challenge environment...${NC}"
        cd "$challenge_dir"
        bash setup.sh
        cd - > /dev/null
    fi
    
    # Show problem description
    if [[ -f "${challenge_dir}/problem.md" ]]; then
        echo -e "${CYAN}Challenge Description:${NC}"
        cat "${challenge_dir}/problem.md"
        echo
    fi
    
    # Wait for user to complete challenge
    echo -e "${GREEN}Complete the challenge and press Enter to verify your solution...${NC}"
    read -r
    
    # Verify solution
    if [[ -f "${challenge_dir}/verify.sh" ]]; then
        echo -e "${YELLOW}Verifying solution...${NC}"
        cd "$challenge_dir"
        if bash verify.sh; then
            record_success "$level" "$concept" "$problem"
            
            if [[ "$EFFICIENCY_MODE" == true ]]; then
                analyze_efficiency
            fi
        else
            record_failure "$level" "$concept" "$problem"
        fi
        cd - > /dev/null
    fi
    
    # Stop tracking
    if [[ "$TRACK_COMMANDS" == true ]]; then
        stop_command_tracking
    fi
    
    if [[ "$TRACK_TIME" == true ]]; then
        stop_time_tracking
    fi
}

# Run random challenge
run_random_challenge() {
    local level_filter="$CURRENT_LEVEL"
    
    if [[ -z "$level_filter" ]]; then
        local levels=(basic intermediate advanced workflows)
        level_filter="${levels[$RANDOM % ${#levels[@]}]}"
    fi
    
    local level_dir="${CHALLENGES_DIR}/${level_filter}"
    if [[ ! -d "$level_dir" ]]; then
        echo -e "${RED}Error: No challenges found for level: $level_filter${NC}"
        exit 1
    fi
    
    local concepts=($(find "$level_dir" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;))
    if [[ ${#concepts[@]} -eq 0 ]]; then
        echo -e "${RED}Error: No concepts found for level: $level_filter${NC}"
        exit 1
    fi
    
    local concept="${concepts[$RANDOM % ${#concepts[@]}]}"
    local concept_dir="${level_dir}/${concept}"
    local problems=($(find "$concept_dir" -name "problem*" -type d -exec basename {} \;))
    
    if [[ ${#problems[@]} -eq 0 ]]; then
        echo -e "${RED}Error: No problems found for concept: $concept${NC}"
        exit 1
    fi
    
    local problem="${problems[$RANDOM % ${#problems[@]}]}"
    local problem_num="${problem#problem}"
    
    echo -e "${PURPLE}Random Challenge Selected: ${level_filter}/${concept}/problem${problem_num}${NC}\n"
    
    run_challenge "$level_filter" "$concept" "$problem_num"
}

# Show progress
show_progress() {
    echo -e "${BLUE}Progress Overview:${NC}\n"
    
    local total_challenges=0
    local completed_challenges=0
    
    for level in basic intermediate advanced workflows; do
        level_dir="${CHALLENGES_DIR}/${level}"
        if [[ -d "$level_dir" ]]; then
            echo -e "${YELLOW}$level level:${NC}"
            
            local level_total=0
            local level_completed=0
            
            for concept_dir in "$level_dir"/*; do
                if [[ -d "$concept_dir" ]]; then
                    concept=$(basename "$concept_dir")
                    problem_count=$(find "$concept_dir" -name "problem*" -type d | wc -l)
                    completed_count=$(get_completed_count "$level" "$concept")
                    
                    level_total=$((level_total + problem_count))
                    level_completed=$((level_completed + completed_count))
                    
                    echo -e "  ${GREEN}$concept${NC}: $completed_count/$problem_count"
                fi
            done
            
            total_challenges=$((total_challenges + level_total))
            completed_challenges=$((completed_challenges + level_completed))
            
            echo -e "  Level Total: $level_completed/$level_total"
            echo
        fi
    done
    
    echo -e "${CYAN}Overall Progress: $completed_challenges/$total_challenges${NC}"
    if [[ $total_challenges -gt 0 ]]; then
        local percentage=$((completed_challenges * 100 / total_challenges))
        echo -e "${CYAN}Completion: ${percentage}%${NC}"
    fi
}

# Main execution
main() {
    parse_args "$@"
    
    if [[ $# -eq 0 ]]; then
        usage
        exit 0
    fi
    
    # Initialize directories if they don't exist
    initialize_directories
    
    # Run challenge if level and concept are specified
    if [[ -n "$CURRENT_LEVEL" && -n "$CURRENT_CONCEPT" ]]; then
        validate_args
        run_challenge "$CURRENT_LEVEL" "$CURRENT_CONCEPT" "$CURRENT_PROBLEM"
    fi
}

# Initialize required directories
initialize_directories() {
    mkdir -p "$CHALLENGES_DIR"
    mkdir -p "$PROGRESS_DIR"
    mkdir -p "$QUIZZES_DIR"
}

# Placeholder functions for features to be implemented
show_hint() { echo "Hint system not yet implemented"; }
show_explanation() { echo "Explanation system not yet implemented"; }
show_stats() { echo "Statistics system not yet implemented"; }
reset_progress() { echo "Progress reset not yet implemented"; }
run_speed_challenge() { echo "Speed challenge not yet implemented"; }
show_alternatives() { echo "Alternatives system not yet implemented"; }
optimize_solution() { echo "Solution optimization not yet implemented"; }
generate_challenge() { echo "Challenge generation not yet implemented"; }
claude_hint() { echo "Claude hint not yet implemented"; }
claude_explain() { echo "Claude explanation not yet implemented"; }
run_quiz() { echo "Quiz system not yet implemented"; }
create_backup_branch() { echo "Backup system not yet implemented"; }
start_command_tracking() { echo "Command tracking not yet implemented"; }
stop_command_tracking() { echo "Command tracking not yet implemented"; }
start_time_tracking() { echo "Time tracking not yet implemented"; }
stop_time_tracking() { echo "Time tracking not yet implemented"; }
analyze_efficiency() { echo "Efficiency analysis not yet implemented"; }
record_success() { echo "Success recording not yet implemented"; }
record_failure() { echo "Failure recording not yet implemented"; }
get_completed_count() { echo "0"; }

# Execute main function
main "$@"