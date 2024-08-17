#!/bin/bash

# Print usage
print_usage() {
    echo "Usage: $0 [-a] <alias_name> <command>"
    echo "  -a: Apply to all shell config files (optional)"
    echo "Without -a, applies only to the current shell's config file"
    exit 1
}

# Check for minimum arguments
if [ $# -lt 2 ]; then
    print_usage
fi

# Parse arguments
apply_all=false
if [ "$1" = "-a" ]; then
    apply_all=true
    shift
fi

if [ $# -ne 2 ]; then
    print_usage
fi

alias_name="$1"
command="$2"

current_shell=$(basename "$SHELL")

# Add alias to a file if it exists
add_alias_to_file() {
    local file="$1"
    if [ -f "$file" ]; then
        if ! grep -q "alias $alias_name=" "$file"; then
            echo "alias $alias_name='$command'" >> "$file"
            echo "Alias added to $file"
            return 0
        fi
    fi
    return 1
}

# Config file for a specific shell
get_config_file() {
    case "$1" in
        bash)
            echo "$HOME/.bashrc"
            ;;
        zsh)
            echo "$HOME/.zshrc"
            ;;
        fish)
            echo "$HOME/.config/fish/config.fish"
            ;;
        *)
            echo "$HOME/.profile"
            ;;
    esac
}

# Apply alias
if $apply_all; then
    config_files=(
        "$(get_config_file bash)"
        "$(get_config_file zsh)"
        "$(get_config_file fish)"
        "$HOME/.profile"
    )
    for file in "${config_files[@]}"; do
        add_alias_to_file "$file"
    done
else
    config_file=$(get_config_file "$current_shell")
    if add_alias_to_file "$config_file"; then
        echo "Alias added to $config_file"
    else
        echo "Alias already exists in $config_file or file not found"
    fi
fi

echo "Alias '$alias_name' has been processed."

# Restart shell
case "$current_shell" in
    bash|zsh)
        exec "$SHELL"
        ;;
    fish)
        exec fish
        ;;
    *)
        echo "Unable to automatically restart $current_shell. Please restart your shell manually."
        exit 0
        ;;
esac

