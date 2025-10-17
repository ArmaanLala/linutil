#!/bin/sh -e

. ../common-script.sh

installLalaDesktop() {
    printf "%b\n" "${YELLOW}Installing Lala Desktop packages...${RC}"
    printf "%b\n" "${YELLOW}Note: This requires lala-base to be installed first${RC}"

    case "$PACKAGER" in
        pacman)
            printf "%b\n" "${CYAN}Installing Hyprland desktop environment...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                hyprland waybar mako swaybg hyprshot hyprpolkitagent xdg-desktop-portal-hyprland

            printf "%b\n" "${CYAN}Installing display manager...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                sddm

            printf "%b\n" "${CYAN}Installing file manager...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                thunar

            printf "%b\n" "${CYAN}Installing desktop applications...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                firefox steam ghostty fuzzel udiskie wine

            printf "%b\n" "${CYAN}Installing media tools...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                ffmpeg imv mpv vlc

            printf "%b\n" "${CYAN}Installing audio tools...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                pavucontrol pipewire-alsa pipewire-pulse

            printf "%b\n" "${CYAN}Installing system integration tools...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                qt5-wayland wl-clipboard wl-clipboard-x11 brightnessctl playerctl grim slurp

            printf "%b\n" "${CYAN}Installing essential fonts...${RC}"
            "$ESCALATION_TOOL" "$PACKAGER" -S --needed --noconfirm \
                ttf-dejavu ttf-liberation ttf-jetbrains-mono ttf-jetbrains-mono-nerd \
                ttf-fira-code ttf-nerd-fonts-symbols noto-fonts noto-fonts-emoji \
                ttf-font-awesome ttf-roboto ttf-roboto-mono ttf-ibm-plex ttf-ubuntu-nerd
            ;;
        *)
            printf "%b\n" "${RED}This script is designed for Arch Linux (pacman). Your package manager ($PACKAGER) is not supported.${RC}"
            exit 1
            ;;
    esac

    printf "%b\n" "${GREEN}Lala Desktop packages installed successfully!${RC}"
}

checkEnv
checkEscalationTool
installLalaDesktop
