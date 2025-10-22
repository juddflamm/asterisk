# Asterisk - Claude Code Multi-Account Manager Project

## Project Overview

This project creates a terminal command called `asterisk` that allows users to manage multiple Anthropic account profiles for Claude Code CLI. It enables running different Claude sessions simultaneously, each with different account configurations, without setting global environment variables.

**Platform Support**: macOS and Linux
**Repository**: https://github.com/juddflamm/asterisk

## Current Project Status (October 2025)

**Version**: See `version.txt` for current version
**Installation**: One-command curl installer from GitHub
**Interface**: Boxed UI with full-width borders, colored elements, single-key input
**Terminology**: Uses "account profiles" to clarify these are Claude Code configuration folders
**Menu**: Shows configurable default account first, followed by additional profiles
**Updates**: Automatic version checking with one-click updates
**MCP Support**: Built-in MCP tool installation for specific profiles
**Distribution**: Published as open-source project with comprehensive documentation

## Project Purpose

- **Problem**: Users with multiple Anthropic accounts (work, personal, etc.) need to manually switch between them when using Claude Code CLI
- **Solution**: A simple interactive menu that lets users select which account profile to use for each Claude session
- **Terminology**: Uses "account profiles" to refer to Claude Code configuration folders, not actual Anthropic accounts
- **Benefits**: 
  - Multiple terminals can run different accounts simultaneously
  - No global environment variable pollution
  - Clean account switching workflow
  - Lazy directory creation (only creates folders when needed)

## Architecture & Design Decisions

### Command Name Evolution
- Started as `claude-account` (descriptive but long)
- Briefly considered `*` (rejected - shell conflicts)
- Tried `cc` (rejected - conflicts with C compiler)
- Considered `claudex` (good but changed)
- Final choice: `asterisk` (unique, memorable, no conflicts)

### Hidden Directory Structure
- **Location**: `~/.asterisk/`
- **Reasoning**: Hidden folder in user home directory, follows Unix conventions
- **Contents**:
  - `settings.json` - Account configuration
  - Individual account directories (created on-demand)

### Settings File Format
**Current Format** (v1.3.0+):
```json
{
  "defaultAccountName": "Personal",
  "additionalAccounts": [
    "Work",
    "Client"
  ]
}
```

**Legacy Format** (v1.2.x and earlier):
```json
{
  "accounts": [
    "Work",
    "Personal"
  ]
}
```

**Migration**: Asterisk automatically migrates old format to new on startup.

**Key Changes**:
- `defaultAccountName`: Configurable name for the default profile (launches without custom config)
- `additionalAccounts`: Renamed from `accounts` for clarity
- Backward compatible: old settings files are automatically upgraded

**Reasoning**:
- Allows users to customize the default account name instead of hardcoding "Personal"
- Clearer separation between default and additional profiles
- Account name serves as both display name and directory name

### Directory Creation Strategy
**Decision**: Lazy creation
- **What**: Only create account directories when user first selects them
- **Why**: Avoids creating unused folders that clutter the file system
- **Implementation**: Check if directory exists before launching Claude, create if missing

### Environment Variable Management
**Key Requirements**:
1. **Per-session only**: No global environment variables
2. **Clean default**: "Personal (default)" option must explicitly unset `CLAUDE_CONFIG_DIR` 
3. **Isolation**: Each terminal session runs independently

**Implementation**:
- Account selection: `exec env CLAUDE_CONFIG_DIR="$config_dir" claude "$@"`
- Personal (default) selection: `exec env -u CLAUDE_CONFIG_DIR claude "$@"`

### Parameter Pass-through
**Decision**: All parameters passed to `asterisk` are forwarded to `claude`
- **Implementation**: Use `"$@"` to preserve all arguments
- **Benefit**: Makes `asterisk` a complete drop-in wrapper for Claude CLI

## Technical Implementation

### Core Components

1. **Main Script** (`asterisk`):
   - Bash script with color-coded output
   - Interactive menu system with single-key input
   - JSON parsing (with fallback parsing if `jq` not available)
   - Automatic setup on first run

2. **Setup Function** (`setup_accounts_dir()`):
   - Creates `~/.asterisk/` directory
   - Creates default `settings.json` with example accounts
   - Does NOT pre-create account directories

3. **Menu System** (`show_menu()`):
   - Personal (default) option as first menu item (launches without config)
   - Dynamic account list from `settings.json`
   - Edit settings option (E key, opens in VSCode)
   - Single-key input (no enter required)
   - First letter matching for account selection

4. **Account Selection Logic**:
   - Creates directory if missing
   - Sets `CLAUDE_CONFIG_DIR` environment variable
   - Launches Claude with all passed parameters

### Menu Options

1. **Personal (default) - Option 1**: 
   - Always the first menu item
   - Explicitly unsets `CLAUDE_CONFIG_DIR` 
   - Launches standard Claude CLI

2. **Account Selection (2, 3, etc.)**: 
   - Creates account directory if needed
   - Launches Claude with `CLAUDE_CONFIG_DIR` set

3. **Edit settings.json (E key)**: 
   - Opens settings file in VSCode
   - Exits after opening (doesn't launch Claude)

4. **Input Methods**:
   - Number keys (1, 2, 3, etc.)
   - First letter of account name (W for Work, etc.)
   - E key for editing settings

### Error Handling & User Experience

- **Color-coded output**: Green for success, Red for errors, Yellow for warnings, Blue for info
- **Graceful fallbacks**: Works without `jq` using basic shell parsing  
- **Input validation**: Prevents invalid menu selections
- **Clear messaging**: Informs user when directories are created

## File Structure

```
asterisk/
├── asterisk               # Main executable script
├── example_settings.json  # Example settings file
├── README.md              # User documentation
└── CLAUDE.md              # This project documentation

~/.asterisk/  # Created on first run
├── settings.json        # User's actual settings
├── Work/               # Created when "Work" first selected
│   └── [Claude config files]
└── Personal/           # Created when "Personal" first selected
    └── [Claude config files]
```

## Usage Workflow

1. **Installation**: Use curl-based installer: `sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/juddflamm/asterisk/main/install.sh)"`
2. **First run**: Creates hidden directory and settings file automatically
3. **Daily use**: Run `asterisk`, select account profile, Claude launches with that config
4. **Account Setup**: If account profile hasn't logged in, Claude Code will prompt for Anthropic login
5. **Multiple sessions**: Each terminal can run different account profiles simultaneously
6. **Settings management**: Select "Edit settings.json" to modify account profile list
7. **Uninstall**: Simply delete `asterisk` from `/usr/local/bin/` and optionally delete `~/.asterisk/`

## Key Features Implemented

✅ **Interactive account selection menu with single-key input**
✅ **Lazy directory creation** (only when needed)
✅ **Per-session environment variables** (no globals)
✅ **Parameter pass-through** to Claude CLI
✅ **Personal (default) option** with explicit env var cleanup
✅ **Settings editing** via VS Code integration
✅ **Automatic setup** on first run
✅ **Boxed UI with full-width borders** using Unicode box drawing characters
✅ **Colored title** (orange asterisk, white "Asterisk" text)
✅ **JSON parsing** with fallback (works with or without `jq`)
✅ **First letter account matching** for quick selection
✅ **ESC key support** (back navigation and exit)
✅ **Input validation** and error handling
✅ **Cross-platform support** (macOS and Linux)
✅ **One-command installation** via curl installer
✅ **Automatic update checking** with in-menu update option
✅ **Version display** in menu title
✅ **MCP tool installation** support with profile selection
✅ **Comprehensive uninstall process**  

## Development History

1. **Initial Concept**: Simple account switching for Claude CLI
2. **Architecture Design**: Hidden folder approach with settings file
3. **Settings Format**: Evolved from complex objects to simple array, then to configurable default + additional accounts
4. **Directory Strategy**: Changed from pre-creation to lazy creation
5. **Command Naming**: Multiple iterations to find conflict-free name (`assterix` → `asterisk`)
6. **Environment Variables**: Added explicit cleanup for default option
7. **Parameter Handling**: Added full pass-through support
8. **User Interface**: Evolved from simple text to boxed UI with colors and borders
9. **Installation Method**: Added curl-based installer from GitHub
10. **Platform Support**: Expanded from macOS-only to macOS and Linux
11. **Terminology Clarification**: Adopted "account profiles" to clarify these are Claude Code config folders
12. **Documentation**: Added comprehensive uninstall instructions
13. **Update System**: Added automatic version checking with one-click updates
14. **MCP Integration**: Added MCP tool installation with profile selection
15. **Settings Migration**: Added automatic migration from old to new settings format
16. **Version Comparison**: Implemented proper semantic versioning comparison

## Versioning & Updates

### Version Management
**Current Version**: Check `version.txt` file for the current version number.

The version number is stored in **two locations** and must be updated in both places when bumping versions:

1. **`asterisk` script**: Line 3, `VERSION="x.x.x"`
2. **`version.txt` file**: Contains only the version number (e.g., `1.3.3`)

**IMPORTANT**: When bumping the version, update BOTH files to keep them in sync.

**NOTE**: This documentation (CLAUDE.md) intentionally does NOT hardcode the version number. Always check `version.txt` for the current version to ensure accuracy.

### Automatic Update Checking

The script implements automatic update checking with these characteristics:

**How It Works**:
1. On first menu load, script checks GitHub for latest `version.txt`
2. Compares remote version with local `VERSION` variable
3. If newer version available, stores in global variables
4. Displays orange menu item: "u) Update to latest version: vX.X.X"
5. User can press 'u' to automatically run the installer and update

**Performance**:
- Update check only runs ONCE on initial startup
- Menu renders immediately (fast/snappy UI)
- Check happens after menu is displayed
- Subsequent menu visits use cached result (no re-checking)

**Update Process**:
1. User presses 'u' when update available
2. Screen clears, shows "Updating Asterisk to vX.X.X..."
3. Runs: `curl -fsSL https://raw.githubusercontent.com/juddflamm/asterisk/main/install.sh | sudo bash`
4. Script exits after update completes

**Implementation Details**:
- Function: `check_for_updates()`
- Global flags: `FIRST_MENU_LOAD`, `UPDATE_AVAILABLE`, `NEW_VERSION`
- Version comparison: Simple string comparison (works for semantic versioning)
- Update notification: Orange-colored menu item for visibility
- Help text: Dynamically includes 'u' option when update available

### Version History
- **v1.3.1**: Added automatic settings migration from old to new format
- **v1.3.0**: Configurable default account name, proper semantic version comparison
- **v1.2.1**: Fixed version comparison for patch releases
- **v1.2.0**: Added automatic update checking, boxed UI, ESC key support, MCP tool installation, version display
- **v1.1.0**: Added colored UI elements, full-width borders, improved menu system
- **v1.0.0**: Initial release with basic account switching functionality

## Future Considerations

- **Shell Completion**: Could add bash/zsh completion for account names
- **Configuration Validation**: Could validate settings.json format
- **Account Templates**: Could provide template configs for new accounts
- **Usage Statistics**: Could track which accounts are used most
- **Import/Export**: Could backup/restore account configurations
- **Version comparison**: Could implement proper semantic version comparison instead of string comparison

## Installation & Usage

**Current Installation Method**: 
```bash
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/juddflamm/asterisk/main/install.sh)"
```

**Usage**: Simply run `asterisk` command to see interactive menu.

See `README.md` for complete documentation.

## Project Summary

This project successfully solves the multi-account management problem for Claude Code CLI users in a clean, user-friendly way that respects Unix conventions and shell best practices. The tool has evolved from a simple account switcher to a comprehensive account profile management system with cross-platform support, automated installation, and polished user experience.
