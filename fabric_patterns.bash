_llm_fabric_patterns() {
    # This function provides completions for the `llm` command with the `-t` flag
    # ie `llm -t fabric:<TAB>`, eg `llm -t fabric:find_logical_fallacies`.
    # It lists all available patterns in the `~/.cache/fabric_patterns_list.txt` file.
    local current_word previous_word wordlist
    COMPREPLY=()
    [[ $COMP_CWORD -ge 0 ]] && current_word="${COMP_WORDS[COMP_CWORD]}"
    [[ $COMP_CWORD -ge 1 ]] && previous_word="${COMP_WORDS[COMP_CWORD - 1]}"

    wordlist=$(cat ~/.cache/fabric_patterns_list.txt 2>/dev/null)

    # Check if the previous word is -t or --type
    case "${previous_word}" in
    ":")
        COMPREPLY=($(compgen_with_prefix "$wordlist" "${current_word#:}"))
        ;;
    "fabric")
        COMPREPLY=($(compgen_with_prefix "$wordlist" "${current_word}"))
        ;;
    *)
        COMPREPLY=()
        ;;
    esac
    return 0
}

# Bind the `_llm_fabric_patterns` function to the `llm` command for tab completion
complete -F _llm_fabric_patterns llm
compgen_with_prefix() {
    local patterns=$1 # Input patterns
    local word=$2     # Current word being completed

    word=${word#:} # Remove leading colon if present
    compgen -W "$patterns" -- "$word"
}

test_llm_fabric_patterns_completion() {
    # Update the test function to use the temporary file
    wordlist=$(cat "$temp_file" 2>/dev/null)
    # Create a mock file with patterns
    echo -e "find_logical_fallacies\nidentify_biases\nanalyze_sentiment" >~/.cache/fabric_patterns_list.txt

    # Simulate the completion environment
    local current_word="-t fabric:"
    local previous_word="-t"
    local expected_patterns=("find_logical_fallacies" "identify_biases" "analyze_sentiment")
    COMPREPLY=()
    COMP_WORDS=("llm" "-t" "fabric" ":")
    COMP_CWORD=3

    # Call the completion function
    _llm_fabric_patterns

    # Verify the output
    echo "Expected patterns: ${expected_patterns[@]}"
    echo "Actual completions: ${COMPREPLY[@]}"
    if [[ "${COMPREPLY[@]}" == "${expected_patterns[@]}" ]]; then
        echo -e "\033[0;32mTest passed: COMPREPLY matches expected patterns.\033[0m"
    else
        echo -e "\033[0;31mTest failed: COMPREPLY does not match expected patterns.\033[0m"
        echo "Expected: ${expected_patterns[@]}"
        echo "Got: ${COMPREPLY[@]}"
    fi
}

# Test case:     COMP_WORDS=("llm" "-t" "fabric" ":find")
test_llm_fabric_patterns_completion_case() {
    # Create a mock file with patterns
    echo -e "find_logical_fallacies\nidentify_biases\nanalyze_sentiment" >~/.cache/fabric_patterns_list.txt

    # Simulate the completion environment
    local current_word="-t fabric:"
    local previous_word="-t"
    local expected_patterns=("find_logical_fallacies")
    COMPREPLY=()
    COMP_WORDS=("llm" "-t" "fabric" ":" "find")
    COMP_CWORD=4

    # Call the completion function
    _llm_fabric_patterns

    # Verify the output
    echo "Expected patterns: ${expected_patterns[@]}"
    echo "Actual completions: ${COMPREPLY[@]}"
    if [[ "${COMPREPLY[@]}" == "${expected_patterns[@]}" ]]; then
        echo -e "\033[0;32mTest passed: COMPREPLY matches expected patterns.\033[0m"
    else
        echo -e "\033[0;31mTest failed: COMPREPLY does not match expected patterns.\033[0m"
        echo "Expected: ${expected_patterns[@]}"
        echo "Got: ${COMPREPLY[@]}"
    fi
}
