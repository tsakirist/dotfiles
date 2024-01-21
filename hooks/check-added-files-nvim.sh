#!/usr/bin/env bash

function update_readme_tree() {
    declare -r tree_output_file="/tmp/tree_output.txt"

    # Check if a staged lua file (A|M|D) is added in nvim folder.
    if git diff --cached --name-status | grep -E '^[AMD]' | awk '{print $2}' | grep '^nvim/'; then
        pushd nvim || exit
        tree --dirsfirst --noreport -F -n . -o $tree_output_file
        popd || exit

        # Find the range for the to-be modified text
        declare -r start_marker="^\`\`\`bash"
        declare -r end_marker="\`\`\`$"
        declare -r readme="README.md"

        declare -i start end
        start=$(grep -n $start_marker $readme | cut -d ":" -f1)
        end=$(grep -n $end_marker $readme | cut -d ":" -f1)

        # Clear out the previous tree output
        sed -i "$((start + 1)),$((end - 1))d" $readme

        # Write tree output there
        sed -i "${start}r ${tree_output_file}" $readme

        # Add the file to the index before the commit
        git add $readme
    fi
}

update_readme_tree
