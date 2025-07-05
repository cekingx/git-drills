#!/bin/bash

# Quiz System
# Functions for running quizzes and testing knowledge

source "${SCRIPT_DIR}/config.sh"

# Quiz state variables
QUIZ_SCORE=0
QUIZ_TOTAL=0
QUIZ_CURRENT_QUESTION=0
QUIZ_ANSWERS=()
QUIZ_START_TIME=0

# Color codes for quiz output
QUIZ_GREEN='\033[0;32m'
QUIZ_RED='\033[0;31m'
QUIZ_YELLOW='\033[1;33m'
QUIZ_BLUE='\033[0;34m'
QUIZ_PURPLE='\033[0;35m'
QUIZ_NC='\033[0m' # No Color

# Initialize quiz session
init_quiz() {
    QUIZ_SCORE=0
    QUIZ_TOTAL=0
    QUIZ_CURRENT_QUESTION=0
    QUIZ_ANSWERS=()
    QUIZ_START_TIME=$(date +%s)
}

# Load quiz questions from file
load_quiz_questions() {
    local quiz_file="$1"
    
    if [[ ! -f "$quiz_file" ]]; then
        echo -e "${QUIZ_RED}Error: Quiz file '$quiz_file' not found${QUIZ_NC}"
        return 1
    fi
    
    # Parse quiz file format
    # Each question block starts with Q: and ends with a blank line
    # Format: Q:, TYPE:, A1:, A2:, A3:, A4:, CORRECT:, EXPLANATION:, CONCEPT:, DIFFICULTY:
    
    local questions=()
    local current_question=""
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^Q: ]]; then
            if [[ -n "$current_question" ]]; then
                questions+=("$current_question")
            fi
            current_question="$line"
        elif [[ -n "$current_question" ]]; then
            if [[ -z "$line" ]]; then
                questions+=("$current_question")
                current_question=""
            else
                current_question+=$'\n'"$line"
            fi
        fi
    done < "$quiz_file"
    
    # Add the last question if file doesn't end with blank line
    if [[ -n "$current_question" ]]; then
        questions+=("$current_question")
    fi
    
    echo "${#questions[@]}"
}

# Parse question block
parse_question() {
    local question_block="$1"
    local -A question_data
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^Q: ]]; then
            question_data["question"]="${line#Q: }"
        elif [[ "$line" =~ ^TYPE: ]]; then
            question_data["type"]="${line#TYPE: }"
        elif [[ "$line" =~ ^A1: ]]; then
            question_data["a1"]="${line#A1: }"
        elif [[ "$line" =~ ^A2: ]]; then
            question_data["a2"]="${line#A2: }"
        elif [[ "$line" =~ ^A3: ]]; then
            question_data["a3"]="${line#A3: }"
        elif [[ "$line" =~ ^A4: ]]; then
            question_data["a4"]="${line#A4: }"
        elif [[ "$line" =~ ^CORRECT: ]]; then
            question_data["correct"]="${line#CORRECT: }"
        elif [[ "$line" =~ ^EXPLANATION: ]]; then
            question_data["explanation"]="${line#EXPLANATION: }"
        elif [[ "$line" =~ ^CONCEPT: ]]; then
            question_data["concept"]="${line#CONCEPT: }"
        elif [[ "$line" =~ ^DIFFICULTY: ]]; then
            question_data["difficulty"]="${line#DIFFICULTY: }"
        fi
    done <<< "$question_block"
    
    # Output as JSON for easier handling
    printf '{"question":"%s","type":"%s","a1":"%s","a2":"%s","a3":"%s","a4":"%s","correct":"%s","explanation":"%s","concept":"%s","difficulty":"%s"}' \
        "${question_data["question"]}" "${question_data["type"]}" \
        "${question_data["a1"]}" "${question_data["a2"]}" \
        "${question_data["a3"]}" "${question_data["a4"]}" \
        "${question_data["correct"]}" "${question_data["explanation"]}" \
        "${question_data["concept"]}" "${question_data["difficulty"]}"
}

# Display question
display_question() {
    local question_json="$1"
    local question_num="$2"
    
    local question=$(echo "$question_json" | jq -r '.question')
    local type=$(echo "$question_json" | jq -r '.type')
    local a1=$(echo "$question_json" | jq -r '.a1')
    local a2=$(echo "$question_json" | jq -r '.a2')
    local a3=$(echo "$question_json" | jq -r '.a3')
    local a4=$(echo "$question_json" | jq -r '.a4')
    local difficulty=$(echo "$question_json" | jq -r '.difficulty')
    
    echo -e "${QUIZ_BLUE}Question $question_num${QUIZ_NC} ${QUIZ_YELLOW}(Difficulty: $difficulty)${QUIZ_NC}"
    echo -e "${QUIZ_BLUE}$question${QUIZ_NC}"
    echo
    
    if [[ "$type" == "multiple_choice" ]]; then
        echo -e "${QUIZ_GREEN}1)${QUIZ_NC} $a1"
        echo -e "${QUIZ_GREEN}2)${QUIZ_NC} $a2"
        echo -e "${QUIZ_GREEN}3)${QUIZ_NC} $a3"
        echo -e "${QUIZ_GREEN}4)${QUIZ_NC} $a4"
        echo
        echo -e "${QUIZ_YELLOW}Enter your answer (1-4):${QUIZ_NC}"
    elif [[ "$type" == "true_false" ]]; then
        echo -e "${QUIZ_GREEN}1)${QUIZ_NC} True"
        echo -e "${QUIZ_GREEN}2)${QUIZ_NC} False"
        echo
        echo -e "${QUIZ_YELLOW}Enter your answer (1-2):${QUIZ_NC}"
    elif [[ "$type" == "fill_blank" ]]; then
        echo -e "${QUIZ_YELLOW}Enter your answer:${QUIZ_NC}"
    fi
}

# Get user answer
get_user_answer() {
    local type="$1"
    local answer=""
    
    read -r answer
    
    if [[ "$type" == "multiple_choice" ]]; then
        if [[ "$answer" =~ ^[1-4]$ ]]; then
            echo "$answer"
        else
            echo -e "${QUIZ_RED}Invalid input. Please enter 1-4.${QUIZ_NC}"
            return 1
        fi
    elif [[ "$type" == "true_false" ]]; then
        if [[ "$answer" =~ ^[1-2]$ ]]; then
            echo "$answer"
        else
            echo -e "${QUIZ_RED}Invalid input. Please enter 1 or 2.${QUIZ_NC}"
            return 1
        fi
    else
        echo "$answer"
    fi
}

# Check answer
check_answer() {
    local question_json="$1"
    local user_answer="$2"
    
    local correct=$(echo "$question_json" | jq -r '.correct')
    local explanation=$(echo "$question_json" | jq -r '.explanation')
    
    if [[ "$user_answer" == "$correct" ]]; then
        echo -e "${QUIZ_GREEN}✅ Correct!${QUIZ_NC}"
        echo -e "${QUIZ_BLUE}$explanation${QUIZ_NC}"
        return 0
    else
        echo -e "${QUIZ_RED}❌ Incorrect. The correct answer is $correct.${QUIZ_NC}"
        echo -e "${QUIZ_BLUE}$explanation${QUIZ_NC}"
        return 1
    fi
}

# Run single question
run_question() {
    local question_json="$1"
    local question_num="$2"
    
    local type=$(echo "$question_json" | jq -r '.type')
    local attempts=0
    local max_attempts=3
    
    while [[ $attempts -lt $max_attempts ]]; do
        display_question "$question_json" "$question_num"
        
        if user_answer=$(get_user_answer "$type"); then
            if check_answer "$question_json" "$user_answer"; then
                QUIZ_SCORE=$((QUIZ_SCORE + 1))
                QUIZ_ANSWERS+=("$user_answer:correct")
                return 0
            else
                QUIZ_ANSWERS+=("$user_answer:incorrect")
                return 1
            fi
        else
            attempts=$((attempts + 1))
            if [[ $attempts -lt $max_attempts ]]; then
                echo -e "${QUIZ_YELLOW}Try again...${QUIZ_NC}"
            fi
        fi
    done
    
    echo -e "${QUIZ_RED}Maximum attempts reached. Moving to next question.${QUIZ_NC}"
    QUIZ_ANSWERS+=("timeout:incorrect")
    return 1
}

# Run complete quiz
run_complete_quiz() {
    local quiz_file="$1"
    local concept_filter="$2"
    local difficulty_filter="$3"
    
    echo -e "${QUIZ_PURPLE}Starting Quiz: $(basename "$quiz_file" .txt)${QUIZ_NC}"
    echo
    
    init_quiz
    
    # Load and parse questions
    local questions=()
    local current_question=""
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^Q: ]]; then
            if [[ -n "$current_question" ]]; then
                local question_json=$(parse_question "$current_question")
                
                # Apply filters
                local should_include=true
                
                if [[ -n "$concept_filter" ]]; then
                    local concept=$(echo "$question_json" | jq -r '.concept')
                    if [[ "$concept" != "$concept_filter" ]]; then
                        should_include=false
                    fi
                fi
                
                if [[ -n "$difficulty_filter" && "$should_include" == true ]]; then
                    local difficulty=$(echo "$question_json" | jq -r '.difficulty')
                    if [[ "$difficulty" != "$difficulty_filter" ]]; then
                        should_include=false
                    fi
                fi
                
                if [[ "$should_include" == true ]]; then
                    questions+=("$question_json")
                fi
            fi
            current_question="$line"
        elif [[ -n "$current_question" ]]; then
            if [[ -z "$line" ]]; then
                local question_json=$(parse_question "$current_question")
                questions+=("$question_json")
                current_question=""
            else
                current_question+=$'\n'"$line"
            fi
        fi
    done < "$quiz_file"
    
    # Add the last question if file doesn't end with blank line
    if [[ -n "$current_question" ]]; then
        local question_json=$(parse_question "$current_question")
        questions+=("$question_json")
    fi
    
    QUIZ_TOTAL=${#questions[@]}
    
    if [[ $QUIZ_TOTAL -eq 0 ]]; then
        echo -e "${QUIZ_RED}No questions found matching the criteria.${QUIZ_NC}"
        return 1
    fi
    
    echo -e "${QUIZ_BLUE}Found $QUIZ_TOTAL questions${QUIZ_NC}"
    echo
    
    # Run questions
    for i in "${!questions[@]}"; do
        QUIZ_CURRENT_QUESTION=$((i + 1))
        echo -e "${QUIZ_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${QUIZ_NC}"
        run_question "${questions[$i]}" "$QUIZ_CURRENT_QUESTION"
        echo
        
        # Ask if user wants to continue
        if [[ $QUIZ_CURRENT_QUESTION -lt $QUIZ_TOTAL ]]; then
            echo -e "${QUIZ_YELLOW}Press Enter to continue to next question...${QUIZ_NC}"
            read -r
        fi
    done
    
    # Show final results
    show_quiz_results
}

# Show quiz results
show_quiz_results() {
    local end_time=$(date +%s)
    local duration=$((end_time - QUIZ_START_TIME))
    local percentage=$((QUIZ_SCORE * 100 / QUIZ_TOTAL))
    
    echo -e "${QUIZ_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${QUIZ_NC}"
    echo -e "${QUIZ_BLUE}Quiz Results${QUIZ_NC}"
    echo -e "${QUIZ_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${QUIZ_NC}"
    
    echo -e "${QUIZ_BLUE}Score: ${QUIZ_SCORE}/${QUIZ_TOTAL} (${percentage}%)${QUIZ_NC}"
    echo -e "${QUIZ_BLUE}Time: ${duration} seconds${QUIZ_NC}"
    
    if [[ $percentage -ge $QUIZ_PASSING_SCORE ]]; then
        echo -e "${QUIZ_GREEN}🎉 Congratulations! You passed the quiz!${QUIZ_NC}"
        
        # Award badges based on performance
        if [[ $percentage -eq 100 ]]; then
            echo -e "${QUIZ_YELLOW}🏆 Perfect Score Badge Earned!${QUIZ_NC}"
        elif [[ $percentage -ge 90 ]]; then
            echo -e "${QUIZ_YELLOW}🥇 Excellence Badge Earned!${QUIZ_NC}"
        elif [[ $percentage -ge 80 ]]; then
            echo -e "${QUIZ_YELLOW}🥈 Proficiency Badge Earned!${QUIZ_NC}"
        fi
        
        return 0
    else
        echo -e "${QUIZ_RED}You need ${QUIZ_PASSING_SCORE}% to pass. Keep studying!${QUIZ_NC}"
        
        # Suggest specific areas for improvement
        suggest_improvement_areas
        
        return 1
    fi
}

# Suggest improvement areas
suggest_improvement_areas() {
    echo -e "${QUIZ_YELLOW}Areas for improvement:${QUIZ_NC}"
    
    # Analyze wrong answers by concept
    local concepts=()
    local wrong_concepts=()
    
    # This would require storing more detailed answer data
    # For now, provide general suggestions
    echo -e "  • Review interactive rebase commands"
    echo -e "  • Practice commit message formatting"
    echo -e "  • Study conflict resolution techniques"
    echo -e "  • Learn about Git workflow best practices"
}

# Get quiz recommendations
get_quiz_recommendations() {
    local level="$1"
    local concept="$2"
    
    echo -e "${QUIZ_BLUE}Recommended quizzes for $level level:${QUIZ_NC}"
    
    case "$level" in
        basic)
            echo -e "  • ${QUIZ_GREEN}rebase_concepts.txt${QUIZ_NC} - Learn rebasing fundamentals"
            echo -e "  • ${QUIZ_GREEN}workflow_optimization.txt${QUIZ_NC} - Basic workflow improvements"
            ;;
        intermediate)
            echo -e "  • ${QUIZ_GREEN}conflict_resolution.txt${QUIZ_NC} - Handle merge conflicts"
            echo -e "  • ${QUIZ_GREEN}best_practices.txt${QUIZ_NC} - Git best practices"
            ;;
        advanced)
            echo -e "  • ${QUIZ_GREEN}workflow_optimization.txt${QUIZ_NC} - Advanced optimizations"
            echo -e "  • ${QUIZ_GREEN}best_practices.txt${QUIZ_NC} - Expert-level practices"
            ;;
        workflows)
            echo -e "  • ${QUIZ_GREEN}best_practices.txt${QUIZ_NC} - Team workflow practices"
            echo -e "  • ${QUIZ_GREEN}conflict_resolution.txt${QUIZ_NC} - Collaboration challenges"
            ;;
    esac
}

# Create practice quiz
create_practice_quiz() {
    local concept="$1"
    local difficulty="$2"
    
    # Generate a small quiz based on concept and difficulty
    echo -e "${QUIZ_BLUE}Creating practice quiz for $concept (difficulty: $difficulty)${QUIZ_NC}"
    
    # This would dynamically generate questions
    # For now, provide a message
    echo -e "${QUIZ_YELLOW}Practice quiz generation is not yet implemented.${QUIZ_NC}"
    echo -e "${QUIZ_YELLOW}Please use the existing quiz files in the quizzes/ directory.${QUIZ_NC}"
}

# Export quiz functions
export -f init_quiz load_quiz_questions run_complete_quiz show_quiz_results
export -f get_quiz_recommendations create_practice_quiz