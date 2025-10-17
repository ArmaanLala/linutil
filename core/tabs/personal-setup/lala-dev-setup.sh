#!/bin/sh -e

. ../common-script.sh

installLalaDev() {
    printf "%b\n" "${YELLOW}Installing Lala Dev packages...${RC}"

    case "$PACKAGER" in
        pacman)
            printf "%b\n" "${CYAN}Installing build tools...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                base-devel cmake meson ninja pkgconf clang

            printf "%b\n" "${CYAN}Installing version control tools...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                git-lfs github-cli

            printf "%b\n" "${CYAN}Installing programming languages...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                go nodejs npm python python-pip rust jdk-openjdk

            printf "%b\n" "${CYAN}Installing development utilities...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                docker docker-compose ghidra

            printf "%b\n" "${CYAN}Installing debugging and testing tools...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                gdb lldb strace valgrind

            printf "%b\n" "${CYAN}Installing network tools...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                curl netcat
            ;;
        *)
            printf "%b\n" "${RED}This script is designed for Arch Linux (pacman). Your package manager ($PACKAGER) is not supported.${RC}"
            exit 1
            ;;
    esac

    printf "%b\n" "${GREEN}Lala Dev packages installed successfully!${RC}"
}

checkEnv
checkEscalationTool
installLalaDev
