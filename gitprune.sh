#!/bin/bash

# Helper function to remove a list of branches
remove_branches() {
    git checkout main
    for branch in "$@"; do
        git branch -D "$branch"
        removed_branches+=("$branch")
    done
}

# Display the main menu
main_menu() {
    echo "1) remove all branches except main"
    echo "2) select branches to remove"
    echo "3) exit"
}

# Display branches to select for deletion
select_branch_menu() {
    branches=($(git branch | grep -v "^\*" | grep -v "main" | tr -d ' '))
    if [ ${#branches[@]} -eq 0 ]; then
        echo "No branches to display."
        return
    fi
    selected_branch=$(printf '%s\n' "${branches[@]}" "exit" | fzf)
    if [ "$selected_branch" != "exit" ]; then
        remove_branches "$selected_branch"
    else
        return
    fi
}

removed_branches=()
while true; do
    main_menu
    read -p "Select an option: " choice

    case $choice in
        1)
            branches_to_remove=($(git branch | grep -v "^\*" | grep -v "main" | tr -d ' '))
            remove_branches "${branches_to_remove[@]}"
            ;;
        2)
            select_branch_menu
            ;;
        3)
            break
            ;;
        *)
            echo "Invalid choice"
            ;;
    esac
done

if [ ${#removed_branches[@]} -ne 0 ]; then
    echo "Removed branches: ${removed_branches[@]}"
fi
