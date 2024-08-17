# URL of the quick-alias.sh script
SCRIPT_URL="https://raw.githubusercontent.com/mhabala/quick-alias/main/quick-alias.sh"
INSTALL_SCRIPT_URL="https://raw.githubusercontent.com/mhabala/quick-alias/main/install-script.sh"

# Directory to store the script
INSTALL_DIR="$HOME/.local/bin"

# Full path where the script will be saved
SCRIPT_PATH="$INSTALL_DIR/quick-alias.sh"

# Ensure the installation directory exists
mkdir -p "$INSTALL_DIR"

# Download the script
echo "Downloading quick-alias.sh..."
curl -fsSL "$SCRIPT_URL" -o "$SCRIPT_PATH"

# Make the script executable
chmod +x "$SCRIPT_PATH"

# Function to add aliases and PATH to a shell config file
add_to_shell_config() {
    local config_file="$1"
    local qa_alias_line="alias qa='$SCRIPT_PATH'"
    local update_alias_line="alias qa-update='curl -fsSL $INSTALL_SCRIPT_URL | bash'"
    local path_line='export PATH="$PATH:$HOME/.local/bin"'

    # Add the qa alias if it doesn't exist
    if ! grep -q "alias qa=" "$config_file"; then
        echo "$qa_alias_line" >> "$config_file"
        echo "Alias 'qa' added to $config_file"
    else
        echo "Alias 'qa' already exists in $config_file"
    fi

    # Add the qa-update alias if it doesn't exist
    if ! grep -q "alias qa-update=" "$config_file"; then
        echo "$update_alias_line" >> "$config_file"
        echo "Alias 'qa-update' added to $config_file"
    else
        echo "Alias 'qa-update' already exists in $config_file"
    fi

    # Add the PATH if it doesn't exist
    if ! grep -q "$INSTALL_DIR" "$config_file"; then
        echo "$path_line" >> "$config_file"
        echo "PATH updated in $config_file"
    else
        echo "PATH already includes $INSTALL_DIR in $config_file"
    fi
}

# Detect the current shell and update the appropriate config file
case "$SHELL" in
    */bash)
        config_file="$HOME/.bashrc"
        add_to_shell_config "$config_file"
        ;;
    */zsh)
        config_file="$HOME/.zshrc"
        add_to_shell_config "$config_file"
        ;;
    */fish)
        config_file="$HOME/.config/fish/config.fish"
        mkdir -p "$(dirname "$config_file")"
        echo "alias qa '$SCRIPT_PATH'" >> "$config_file"
        echo "alias qa-update 'curl -fsSL $INSTALL_SCRIPT_URL | bash'" >> "$config_file"
        echo "set -gx PATH \$PATH $INSTALL_DIR" >> "$config_file"
        echo "Updated $config_file"
        ;;
    *)
        echo "Unsupported shell. Please add the aliases and update your PATH manually."
        exit 1
        ;;
esac

echo "Installation complete. Restarting your shell..."

# Restart the shell
exec "$SHELL"
