#!/bin/bash

# Git Drills Configuration
# Centralized configuration for the Git Drills learning tool

# Version information
VERSION="1.0.0"
AUTHOR="Git Drills Project"
DESCRIPTION="Advanced Git Learning Tool"

# Directory structure
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHALLENGES_DIR="${SCRIPT_DIR}/challenges"
UTILS_DIR="${SCRIPT_DIR}/utils"
PROGRESS_DIR="${SCRIPT_DIR}/.progress"
QUIZZES_DIR="${SCRIPT_DIR}/quizzes"
TEMP_DIR="${SCRIPT_DIR}/.temp"

# Progress tracking files
PROGRESS_FILE="${PROGRESS_DIR}/progress.json"
STATS_FILE="${PROGRESS_DIR}/stats.json"
COMMAND_LOG="${PROGRESS_DIR}/commands.log"
TIME_LOG="${PROGRESS_DIR}/time.log"

# Challenge configuration
CHALLENGE_LEVELS=(basic intermediate advanced workflows)
BASIC_CONCEPTS=(interactive_rebase squash_commits reorder_commits edit_messages split_commits)
INTERMEDIATE_CONCEPTS=(rebase_conflicts branch_cleanup history_rewriting reflog_recovery merge_to_rebase)
ADVANCED_CONCEPTS=(complex_rebases git_archaeology workflow_optimization advanced_recovery)
WORKFLOW_CONCEPTS=(feature_branch_flow open_source_contribution team_collaboration)

# Color configuration
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[1;33m'
COLOR_BLUE='\033[0;34m'
COLOR_PURPLE='\033[0;35m'
COLOR_CYAN='\033[0;36m'
COLOR_WHITE='\033[1;37m'
COLOR_NC='\033[0m' # No Color

# Efficiency targets
TARGET_COMMANDS_BASIC=5
TARGET_COMMANDS_INTERMEDIATE=8
TARGET_COMMANDS_ADVANCED=12
TARGET_COMMANDS_WORKFLOWS=15

TARGET_TIME_BASIC=180    # 3 minutes
TARGET_TIME_INTERMEDIATE=300  # 5 minutes
TARGET_TIME_ADVANCED=600     # 10 minutes
TARGET_TIME_WORKFLOWS=900    # 15 minutes

# Git configuration
GIT_EDITOR_BACKUP=""
GIT_SEQUENCE_EDITOR_BACKUP=""

# Safety settings
BACKUP_BRANCH_PREFIX="git-drills-backup"
AUTO_BACKUP=true
SAFE_MODE_DEFAULT=false

# Quiz configuration
QUIZ_PASSING_SCORE=80
QUIZ_RETRY_LIMIT=3
QUIZ_TIME_LIMIT=300  # 5 minutes per quiz

# Logging configuration
LOG_LEVEL="INFO"  # DEBUG, INFO, WARN, ERROR
LOG_FILE="${PROGRESS_DIR}/git-drills.log"
MAX_LOG_SIZE=10485760  # 10MB
MAX_LOG_FILES=5

# Performance settings
CHALLENGE_TIMEOUT=3600  # 1 hour max per challenge
VERIFICATION_TIMEOUT=30  # 30 seconds max for verification

# Feature flags
ENABLE_CLAUDE_INTEGRATION=true
ENABLE_EFFICIENCY_TRACKING=true
ENABLE_COMMAND_SUGGESTIONS=true
ENABLE_AUTO_HINTS=true
ENABLE_PROGRESS_BADGES=true

# Development settings
DEBUG_MODE=false
VERBOSE_OUTPUT=false
DRY_RUN=false

# External dependencies
REQUIRED_COMMANDS=(git jq)
OPTIONAL_COMMANDS=(fzf bat)

# Challenge problem counts per concept
declare -A PROBLEM_COUNTS=(
    ["interactive_rebase"]=3
    ["squash_commits"]=3
    ["reorder_commits"]=2
    ["edit_messages"]=2
    ["split_commits"]=2
    ["rebase_conflicts"]=3
    ["branch_cleanup"]=3
    ["history_rewriting"]=2
    ["reflog_recovery"]=2
    ["merge_to_rebase"]=2
    ["complex_rebases"]=2
    ["git_archaeology"]=2
    ["workflow_optimization"]=2
    ["advanced_recovery"]=2
    ["feature_branch_flow"]=2
    ["open_source_contribution"]=2
    ["team_collaboration"]=2
)

# Efficiency scoring weights
COMMAND_COUNT_WEIGHT=0.4
TIME_WEIGHT=0.3
ACCURACY_WEIGHT=0.3

# Badge thresholds
BADGE_NOVICE=10      # Complete 10 challenges
BADGE_INTERMEDIATE=25 # Complete 25 challenges
BADGE_EXPERT=36      # Complete all challenges
BADGE_SPEEDSTER=0.8  # Complete 80% of challenges under target time
BADGE_EFFICIENT=0.9  # Complete 90% of challenges under target commands

# Git configuration for challenges
GIT_USER_NAME="Git Drills Student"
GIT_USER_EMAIL="student@git-drills.local"

# Function to validate configuration
validate_config() {
    local errors=0
    
    # Check required directories
    for dir in "$CHALLENGES_DIR" "$UTILS_DIR" "$PROGRESS_DIR" "$QUIZZES_DIR"; do
        if [[ ! -d "$dir" ]]; then
            echo "Warning: Directory $dir does not exist"
        fi
    done
    
    # Check required commands
    for cmd in "${REQUIRED_COMMANDS[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            echo "Error: Required command '$cmd' not found"
            errors=$((errors + 1))
        fi
    done
    
    # Check optional commands
    for cmd in "${OPTIONAL_COMMANDS[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            echo "Warning: Optional command '$cmd' not found (some features may be limited)"
        fi
    done
    
    return $errors
}

# Function to initialize configuration
init_config() {
    # Create required directories
    mkdir -p "$CHALLENGES_DIR" "$UTILS_DIR" "$PROGRESS_DIR" "$QUIZZES_DIR" "$TEMP_DIR"
    
    # Initialize progress files if they don't exist
    if [[ ! -f "$PROGRESS_FILE" ]]; then
        echo '{"challenges": {}, "stats": {"total_attempts": 0, "total_completions": 0}}' > "$PROGRESS_FILE"
    fi
    
    if [[ ! -f "$STATS_FILE" ]]; then
        echo '{"global": {"start_date": "'$(date -Iseconds)'", "sessions": 0}}' > "$STATS_FILE"
    fi
    
    # Initialize log file
    touch "$LOG_FILE"
    
    # Set Git configuration for challenges
    git config --global user.name "$GIT_USER_NAME" 2>/dev/null || true
    git config --global user.email "$GIT_USER_EMAIL" 2>/dev/null || true
}

# Function to get challenge target metrics
get_target_commands() {
    local level="$1"
    case "$level" in
        basic) echo "$TARGET_COMMANDS_BASIC" ;;
        intermediate) echo "$TARGET_COMMANDS_INTERMEDIATE" ;;
        advanced) echo "$TARGET_COMMANDS_ADVANCED" ;;
        workflows) echo "$TARGET_COMMANDS_WORKFLOWS" ;;
        *) echo "$TARGET_COMMANDS_BASIC" ;;
    esac
}

get_target_time() {
    local level="$1"
    case "$level" in
        basic) echo "$TARGET_TIME_BASIC" ;;
        intermediate) echo "$TARGET_TIME_INTERMEDIATE" ;;
        advanced) echo "$TARGET_TIME_ADVANCED" ;;
        workflows) echo "$TARGET_TIME_WORKFLOWS" ;;
        *) echo "$TARGET_TIME_BASIC" ;;
    esac
}

# Function to get concepts for a level
get_concepts_for_level() {
    local level="$1"
    case "$level" in
        basic) echo "${BASIC_CONCEPTS[@]}" ;;
        intermediate) echo "${INTERMEDIATE_CONCEPTS[@]}" ;;
        advanced) echo "${ADVANCED_CONCEPTS[@]}" ;;
        workflows) echo "${WORKFLOW_CONCEPTS[@]}" ;;
        *) echo "" ;;
    esac
}

# Function to get problem count for a concept
get_problem_count() {
    local concept="$1"
    echo "${PROBLEM_COUNTS[$concept]:-1}"
}

# Function to log messages
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    if [[ "$LOG_LEVEL" == "DEBUG" ]] || [[ "$level" != "DEBUG" ]]; then
        echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    fi
    
    if [[ "$VERBOSE_OUTPUT" == true ]]; then
        echo "[$level] $message" >&2
    fi
}

# Cleanup function
cleanup_config() {
    # Clean up temporary files
    if [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
    
    # Restore Git editor settings if they were changed
    if [[ -n "$GIT_EDITOR_BACKUP" ]]; then
        git config --global core.editor "$GIT_EDITOR_BACKUP"
    fi
    
    if [[ -n "$GIT_SEQUENCE_EDITOR_BACKUP" ]]; then
        git config --global sequence.editor "$GIT_SEQUENCE_EDITOR_BACKUP"
    fi
}

# Set up cleanup trap
trap cleanup_config EXIT

# Initialize configuration on source
init_config