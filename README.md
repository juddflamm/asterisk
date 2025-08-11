# <img src="https://claude.ai/favicon.ico" alt="Claude" width="26" height="26"> Asterisk - for Multiple [Claude Code](https://github.com/anthropics/claude-code) Accounts

> **Asterisk manages your multiple [Claude Code](https://www.anthropic.com/claude-code) accounts.** It is a free command-line tool for macOS and Linux that lets you quickly launch [Claude Code CLI](https://github.com/anthropics/claude-code) with any of your [Anthropic accounts](http://claude.ai/login). Allowing you to easily run multiple Claude Code instances simultaneously on different Anthropic accounts.


**Bash Command Line Tool** • **Written by Claude Code for Claude Code** • Easy Installation • Interactive Menu • Zero Global Config Pollution

<img width="488" height="317" alt="Screenshot 2025-08-10 at 8 57 54 PM" src="https://github.com/user-attachments/assets/b7dbb0c4-64f7-4528-81ea-a6723e981ad8" />

*Asterisk bash command shown in Hyper terminal app*

## Why Use This Tool?

If you work with multiple Anthropic accounts (personal, work, client projects), switching between them in Claude Code can be tedious. Instead of logging in and out repeatedly, Asterisk launches Claude Code with your choice of Anthropic Account.

- **Select From Many Anthropic Accounts**: Type `asterisk`, pick your account, and you're coding
- **Multiple Simultaneous Sessions**: Run Claude Code with your Work account in one terminal, and with your Personal account in another
- **Customizable**: Simply use the `Edit settings.json` menu option to customize Asterisk for your specific Anthropic accounts
- **Automates Claude Code's CLAUDE_CONFIG_DIR Environment Variable**: Under the hood Asterisk launches Claude Code with specific account profile config directory, created automatically for you
- **No Conflicts**: Asterisk won't conflict with running Claude Code normally either.  There's no environment pollution or configuration conflicts.

Perfect for developers, consultants, and teams who need to run Claude Code using multiple different Anthropic accounts.

## 🚀 Quick Start

### Installation (macOS)

1. **Install:**
  Use the below bash command to install...
  (This only requires sudo permission to place the asterisk bash command in your `/user/local/bin` folder)
   ```bash
   sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/juddflamm/asterisk/main/install.sh)"
   ```

3. **Start using:**
  Run the following command
   ```bash
   asterisk
   ```
  - It will show you a list of your configured account profiles. 
  - You then select an account profile or select edit to edit the names of the account profiles.  
  - Once you select an account profile it will launch Claude Code with that account profile. The account profile refers to a Claude Code configuration folder. If the selected account profile hasn't logged in yet to Anthropic, Claude Code will ask you to do so.  Claude Code will save it's settings and your login session in that account profile's folder.


## What It Does

- **Multiple Custom Account Names**: Switch between custom named accounts like (Work, Client-ABC, Personal-Fun, etc.)
- **Isolated Sessions**: Each terminal can run different accounts simultaneously
- **Clean Environment**: Uses Claude Code's `CLAUDE_CONFIG_DIR` - no global variables

## ⚙️ Configuration

### Adding New Accounts

You can completely customize your account names to fit your workflow. Account names can be anything you want - they serve as both the display name in the menu and the directory name for that account's configuration.

1. Run `asterisk` and select **"Edit settings.json"**
2. Add your custom account names to the array:

```json
{
  "accounts": [
    "Work",
    "Side-Projects", 
    "Client-Acme",
    "Freelance",
    "OpenSource",
    "Personal-Fun"
  ]
}
```

3. Save the file - account directories are created automatically when first used


### Account Storage Structure

Your accounts are stored in `~/.asterisk/`:

```
~/.asterisk/
├── settings.json
├── Work/
└── Other/
```

### How Account Selection Works

The tool uses Claude Code CLI's built-in `CLAUDE_CONFIG_DIR` environment variable:

- **Personal (default) Selection**: Explicitly unsets `CLAUDE_CONFIG_DIR` (clean slate)
- **Account Selection**: Sets `CLAUDE_CONFIG_DIR=~/.asterisk/AccountName/`
- **Per-Session**: Each terminal gets its own environment, no conflicts

## Dependencies

- **Required**: [Claude Code CLI](https://github.com/anthropics/claude-code)
- **Optional**: [VS Code](https://code.visualstudio.com/) (for built-in settings editing)

## Parameter Pass-Through

Any parameters passed to the `asterisk` command will be passed on to the Claude Code CLI.

## 🤝 Contributing

Feel free to submit issues, feature requests, or pull requests. This project aims to keep the Claude Code multi-account experience simple and reliable.

## 📄 License

MIT License - feel free to use and modify as needed.

## Uninstall

Simply delete the `asterisk` bash command from your `/usr/local/bin/` folder.

If you want to delete Asterisk's profiles for Claude Code, then you can delete the `~/.asterisk` folder.  It contains subfolders for each profile you setup.  

Uninstalling will not affect your actual Anthropic accounts in any way.  It only affects the storage of Claude Code's settings stored in the asterisk profiles you created.

After uninstalling `asterisk`, you would launch Cluade Code using the normal `claude` bash command.

---

**Made for Claude Code CLI users who juggle multiple Anthropic accounts** 🎯
