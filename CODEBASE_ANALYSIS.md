# Linutil Codebase Analysis

## Architecture Overview

### Technology Stack
- **Backend**: Rust (workspace with 3 crates: `core`, `tui`, `xtask`)
- **UI**: Ratatui (terminal UI framework)
- **Scripts**: Shell scripts (~9,000 lines across 130+ scripts)
- **Config**: TOML files for menu structure

## Project Structure

```
linutil/
├── core/                    # Backend logic
│   ├── src/                # Rust code for parsing & execution
│   └── tabs/               # ★ ALL SCRIPTS & CONFIG HERE ★
│       ├── tabs.toml       # Main category definitions
│       ├── common-script.sh # Shared utility functions
│       ├── applications-setup/
│       ├── gaming/
│       ├── security/
│       ├── system-setup/
│       └── utils/
├── tui/                    # Terminal UI
│   └── src/                # Ratatui-based interface
└── xtask/                  # Build tasks
```

## How the System Works

### 1. Script Organization (TOML-based hierarchy)

- `core/tabs/tabs.toml` lists main categories
- Each category has a `tab_data.toml` defining its menu structure
- Supports nested subcategories and individual scripts

### 2. TOML Structure Example

```toml
name = "Category Name"

[[data]]
name = "Subcategory or Item"
description = "What it does"
script = "relative/path/to/script.sh"  # For scripts
task_list = "I"  # Task indicators (I=Install, FM=File Mod, SS=System Service, etc.)
multi_select = true/false

[[data.entries]]  # For nested items
name = "Item Name"
script = "path/to/script.sh"
```

### 3. Script Pattern

All scripts follow this template:

```bash
#!/bin/sh -e
. ../../common-script.sh  # Import utilities

functionName() {
    if ! command_exists package; then
        # Installation logic per package manager
        case "$PACKAGER" in
            pacman) ... ;;
            apt-get) ... ;;
            dnf) ... ;;
        esac
    fi
}

checkEnv  # Detect distro, package manager, etc.
functionName
```

### 4. Common Utilities (`common-script.sh`)

- `checkPackageManager` - Detects apt/dnf/pacman/zypper/apk
- `checkEscalationTool` - Finds sudo/doas
- `checkAURHelper` - Sets up yay/paru on Arch
- `checkFlatpak` - Ensures Flatpak is available
- `command_exists` - Checks if command is installed

### 5. Preconditions (conditional visibility)

```toml
[[data.preconditions]]
matches = true
data = { environment = "XDG_SESSION_TYPE" }
values = ["wayland", "Wayland"]
```

## Current Categories

### 1. applications-setup/ (60+ scripts)
- **browsers/** (11 browsers): Firefox, Chrome, Brave, Chromium, LibreWolf, Lynx, Thorium, Tor, Vivaldi, Waterfox, Zen
- **communication-apps/** (8 apps): Discord, Jitsi, Signal, Slack, Telegram, Thunderbird, ZapZap, Zoom
- **developer-tools/** (9 tools): GitHub Desktop, JetBrains Toolbox, Meld, Neovim, Ngrok, Sublime Text, VS Code, VSCodium, Zed
- **office-suites/** (4 suites): FreeOffice, LibreOffice, OnlyOffice, WPS Office
- **pdf-suites/** (4 viewers): Evince, Okular, PDF Studio, PDF Studio Viewer
- **Other**: Terminal emulators (Alacritty, Kitty, Ghostty), Docker, Podman, DWM, Fastfetch, Flatpak, Grub Theme, Rofi, Waydroid, ZSH/Bash prompts

### 2. gaming/ (2 scripts)
- Diablo II loot filters
- Fallout 76 settings

### 3. security/ (2 scripts)
- Firewall configurations (ufw, firewalld)

### 4. system-setup/ (20+ scripts)
- **Distro-specific folders**: arch/, fedora/, debian/, ubuntu/, alpine/
- **Arch**: Chaotic AUR, Hyprland, Linux Neptune, NVIDIA drivers, Omarchy, Paru, Yay, Server setup, Virtualization
- **Fedora**: DNF config, BTRFS assistant, Fedora upgrade, Hyprland, Multimedia codecs, NVIDIA drivers, RPM Fusion, Virtualization
- **Debian/Ubuntu**: Hyprland for each distro
- **General**: Gaming setup, Global theme, Remove snaps, System cleanup, System update, Terminus TTY

### 5. utils/ (40+ scripts)
- **monitor-control/** (12 scripts): Auto detect, Change orientation, Disable/Enable monitors, Duplicate/Extend displays, Manage arrangement, Scaling, Brightness, Primary monitor, Resolution
- **user-account-manager/** (5 scripts): Add user, Add to group, Change password, Delete user, Remove from group
- **printers/** (3 scripts): CUPS, Epson drivers, HP drivers
- **Other utilities**: Auto mount, Auto login, Bluetooth manager, Bootable USB creator, Crypto tool, Locale setup, Numlock, Ollama, Service manager, SSH, Samba, Timeshift, WiFi manager

## How to Add Your Own Scripts

### Option 1: Add to Existing Category

1. Create your script in the appropriate folder:
```bash
core/tabs/utils/my-script.sh
```

2. Make it executable and add shebang:
```bash
#!/bin/sh -e
```

3. Source common utilities:
```bash
. ../common-script.sh
```

4. Add entry to `tab_data.toml`:
```toml
[[data]]
name = "My Script"
description = "What it does"
script = "my-script.sh"
task_list = "I"
```

### Option 2: Create New Category

1. Create folder:
```bash
mkdir core/tabs/my-category/
```

2. Add scripts to the folder

3. Create `core/tabs/my-category/tab_data.toml`:
```toml
name = "My Category"

[[data]]
name = "Script 1"
description = "Description here"
script = "script1.sh"
task_list = "I"
```

4. Add to `core/tabs/tabs.toml`:
```toml
directories = [
    "applications-setup",
    "gaming",
    "security",
    "system-setup",
    "utils",
    "my-category"  # Add your category
]
```

### Option 3: Create Subcategory

Add to existing `tab_data.toml`:

```toml
[[data]]
name = "My Subcategory"

[[data.entries]]
name = "Item 1"
description = "What it does"
script = "subfolder/script.sh"
task_list = "I"

[[data.entries]]
name = "Item 2"
script = "subfolder/script2.sh"
```

## Best Practices for Scripts

1. **Always source common-script.sh** for cross-distro compatibility
2. **Check before installing**: Use `command_exists` to avoid reinstalls
3. **Support multiple package managers**: Use case statements
4. **Use colored output**: `${GREEN}`, `${RED}`, `${YELLOW}`, `${CYAN}` from common-script
5. **Call checkEnv**: Ensures system is properly detected
6. **Make executable**: `chmod +x your-script.sh`
7. **Use proper shebang**: `#!/bin/sh -e` for POSIX compliance

## Task List Indicators

Used in the `task_list` field:

- `I` - Install
- `FM` - File Modification
- `SS` - System Service
- `PFM` - Prompt File Modification
- `D` - Dependency
- `FI` - Flatpak Install

## Script Template

```bash
#!/bin/sh -e

. ../../common-script.sh

installMyApp() {
    if ! command_exists myapp; then
        printf "%b\n" "${YELLOW}Installing MyApp...${RC}"
        case "$PACKAGER" in
            pacman)
                "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm myapp
                ;;
            apt-get|nala)
                "$ESCALATION_TOOL" "$PACKAGER" install -y myapp
                ;;
            dnf)
                "$ESCALATION_TOOL" "$PACKAGER" install -y myapp
                ;;
            zypper)
                "$ESCALATION_TOOL" "$PACKAGER" --non-interactive install myapp
                ;;
            xbps-install)
                "$ESCALATION_TOOL" "$PACKAGER" -Sy myapp
                ;;
            apk)
                "$ESCALATION_TOOL" "$PACKAGER" add myapp
                ;;
            *)
                printf "%b\n" "${RED}Unsupported package manager: $PACKAGER${RC}"
                exit 1
                ;;
        esac
        printf "%b\n" "${GREEN}MyApp installed successfully!${RC}"
    else
        printf "%b\n" "${GREEN}MyApp is already installed.${RC}"
    fi
}

checkEnv
checkEscalationTool
installMyApp
```

## Testing Your Changes

### Build and Run

```bash
# Build release version
cargo build --release
./target/release/linutil

# Or use the dev script
./startdev.sh

# Or run directly with cargo
cargo run --release
```

### Validation

The system validates:
- Script file existence
- Shebang correctness
- Executable permissions (when validate flag is true)
- Preconditions (environment variables, file contents, command existence)

## Reorganization Ideas

### 1. Split Large Categories
`applications-setup` could be split into:
- `browsers`
- `communication`
- `development`
- `office`
- `terminals`
- `containerization` (Docker, Podman)

### 2. Add More Subcategories
Group related scripts:
- Networking tools (SSH, Samba, WiFi, Bluetooth)
- Media tools
- System utilities
- Backup tools

### 3. Create Distro-Specific Tabs
Instead of mixing in system-setup, create:
- `arch-tools`
- `fedora-tools`
- `debian-ubuntu-tools`

### 4. Add Custom Categories
- `development` (programming languages, tools, IDEs)
- `media` (players, editors, converters)
- `networking` (VPN, SSH, file sharing)
- `backup` (Timeshift, rsync tools, etc.)
- `productivity` (note-taking, task management)

## Key Files Reference

- **Main category list**: `core/tabs/tabs.toml`
- **Common utilities**: `core/tabs/common-script.sh`
- **Common service utilities**: `core/tabs/common-service-script.sh`
- **Category configs**: `core/tabs/*/tab_data.toml`
- **Core parser**: `core/src/inner.rs`
- **Data structures**: `core/src/lib.rs`
- **TUI main**: `tui/src/main.rs`
- **App state**: `tui/src/state.rs`

## Environment Variables Used

- `PACKAGER` - Package manager (pacman, apt-get, dnf, etc.)
- `ESCALATION_TOOL` - Privilege escalation (sudo, doas)
- `AUR_HELPER` - AUR helper for Arch (yay, paru)
- `SUGROUP` - Super user group (wheel, sudo)
- `DTYPE` - Distribution type (from /etc/os-release)
- `ARCH` - System architecture (x86_64, aarch64)
- `XDG_SESSION_TYPE` - Session type (x11, wayland, tty)
- `DISPLAY` - X11 display server

## Color Codes Available

Defined in `common-script.sh`:

```bash
RC='\033[0m'      # Reset Color
RED='\033[31m'    # Red
YELLOW='\033[33m' # Yellow
CYAN='\033[36m'   # Cyan
GREEN='\033[32m'  # Green
```

Usage:
```bash
printf "%b\n" "${GREEN}Success message${RC}"
printf "%b\n" "${RED}Error message${RC}"
printf "%b\n" "${YELLOW}Warning message${RC}"
printf "%b\n" "${CYAN}Info message${RC}"
```
