#!/bin/sh -e

. ../common-script.sh

installLalaFull() {
    printf "%b\n" "${YELLOW}===================================================${RC}"
    printf "%b\n" "${YELLOW}Starting Lala Full Setup${RC}"
    printf "%b\n" "${YELLOW}This will install all Lala packages (base, desktop, and dev)${RC}"
    printf "%b\n" "${YELLOW}===================================================${RC}"
    printf "\n"

    # Check if we're on Arch Linux
    case "$PACKAGER" in
        pacman)
            # Install Lala Base
            printf "%b\n" "${CYAN}[1/3] Installing Lala Base packages...${RC}"
            sh "$(dirname "$0")/lala-base-setup.sh"
            printf "\n"

            # Install Lala Desktop
            printf "%b\n" "${CYAN}[2/3] Installing Lala Desktop packages...${RC}"
            sh "$(dirname "$0")/lala-desktop-setup.sh"
            printf "\n"

            # Install Lala Dev
            printf "%b\n" "${CYAN}[3/3] Installing Lala Dev packages...${RC}"
            sh "$(dirname "$0")/lala-dev-setup.sh"
            printf "\n"

            printf "%b\n" "${YELLOW}===================================================${RC}"
            printf "%b\n" "${GREEN}Lala Full Setup completed successfully!${RC}"
            printf "%b\n" "${YELLOW}===================================================${RC}"
            ;;
        *)
            printf "%b\n" "${RED}This script is designed for Arch Linux (pacman). Your package manager ($PACKAGER) is not supported.${RC}"
            exit 1
            ;;
    esac
}

checkEnv
checkEscalationTool
installLalaFull
