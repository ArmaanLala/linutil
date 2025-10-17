#!/bin/sh -e

. ../common-script.sh

installLalaBase() {
    printf "%b\n" "${YELLOW}Installing Lala Base packages...${RC}"

    case "$PACKAGER" in
        pacman)
            printf "%b\n" "${CYAN}Installing system base packages...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                base linux linux-firmware man-db man-pages texinfo sudo

            printf "%b\n" "${CYAN}Installing package management tools...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                aurutils paru

            printf "%b\n" "${CYAN}Installing shell and terminal tools...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                fish starship tmux zoxide

            printf "%b\n" "${CYAN}Installing file management tools...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                p7zip bat duf dust eza fd fzf gdu ripgrep rsync stow tree unzip zip

            printf "%b\n" "${CYAN}Installing system monitoring tools...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                btop fastfetch htop inxi nvtop procs

            printf "%b\n" "${CYAN}Installing development tools...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                age git git-delta lazygit neovim python-uv wget

            printf "%b\n" "${CYAN}Installing documentation tools...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                tealdeer wikiman

            printf "%b\n" "${CYAN}Installing network tools...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                bc netscanner fail2ban openssh

            printf "%b\n" "${CYAN}Installing data processing tools...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                jq yq tokei hyperfine
            ;;
        *)
            printf "%b\n" "${RED}This script is designed for Arch Linux (pacman). Your package manager ($PACKAGER) is not supported.${RC}"
            exit 1
            ;;
    esac

    printf "%b\n" "${GREEN}Lala Base packages installed successfully!${RC}"
}

checkEnv
checkEscalationTool
installLalaBase
