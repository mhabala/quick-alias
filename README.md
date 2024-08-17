# quick-alias
Fast alias creator for multiple shells with auto-reload


## Quick Installation

To install Quick Alias, run the following command in your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/mhabala/quick-alias/main/install-script.sh | bash
```


## Usage
```bash
quick-alias [options] [alias] [command]
```
qa is an alias for quick-alias if not already defined
Example:
```bash
qa ls 'ls -la'
```

Update quick-alias
```bash
qa-update='curl -fsSL $INSTALL_SCRIPT_URL | bash'
```

Options:
-a, adds alias to all supported shells, without this option alias will be added only to the current shell

Supported shells:
- bash
- zsh
- fish
