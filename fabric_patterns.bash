_llm_fabric_patterns() {
    # This function provides completions for the `llm` command with the `-t` flag
    # ie `llm -t fabric:<TAB>`, eg `llm -t fabric:find_logical_fallacies`.
    # It lists all available patterns in the `~/.cache/fabric_patterns_list.txt` file.
    local current_word previous_word opts
    COMPREPLY=()
    [[ $COMP_CWORD -ge 0 ]] && current_word="${COMP_WORDS[COMP_CWORD]}"
    [[ $COMP_CWORD -ge 1 ]] && previous_word="${COMP_WORDS[COMP_CWORD - 1]}"
    opts=$(cat ~/.cache/fabric_patterns_list.txt 2>/dev/null)

    # Check if the previous word is -t or --type
    case "${previous_word}" in
    "-t" | "--type")
        # Add fabric: prefix to each option
        opts=$(echo "$opts" | awk '{print "fabric:" $0}')
        COMPREPLY=($(compgen -W "${opts}" -- "${current_word}"))
        ;;
    *)
        COMPREPLY=()
        ;;
    esac
    return 0
}

# Bind the `_llm_fabric_patterns` function to the `llm` command for tab completion
complete -F _llm_fabric_patterns llm
# Unit test for the completion function:

test_llm_fabric_patterns_completion() {
    # Let's write a unit test for the completion function:
    local temp_file
    temp_file=$(mktemp)
    echo -e "find_logical_fallacies\nidentify_biases\nanalyze_sentiment" >"$temp_file"

    # Update the test function to use the temporary file
    opts=$(cat "$temp_file" 2>/dev/null)
    # Create a mock file with patterns
    echo -e "find_logical_fallacies\nidentify_biases\nanalyze_sentiment" >~/.cache/fabric_patterns_list.txt

    # Simulate the completion environment
    local current_word="-t fabric:"
    local previous_word="-t"
    local expected_patterns=("fabric:find_logical_fallacies" "fabric:identify_biases" "fabric:analyze_sentiment")
    COMPREPLY=()
    COMP_WORDS=("llm" "-t" "fabric:")
    COMP_CWORD=2

    # Call the completion function
    _llm_fabric_patterns

    # Verify the output
    echo "Expected patterns: ${expected_patterns[@]}"
    echo "Actual completions: ${COMPREPLY[@]}"
    if [[ "${COMPREPLY[@]}" == "${expected_patterns[@]}" ]]; then
        echo "Test passed: COMPREPLY matches expected patterns."
    else
        echo "Test failed: COMPREPLY does not match expected patterns."
    fi

    # Clean up the temporary file
    rm "$temp_file"
}
