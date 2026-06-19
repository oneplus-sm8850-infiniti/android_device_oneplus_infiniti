#!/bin/bash

# ============================================================
#   O n e P l u s   1 5   |   I n f i n i t i   —   V e n d o r   S e t u p
# ============================================================
#   Made with 💖 and power by Raphael
# ============================================================

# ── Colour Palette ──────────────────────────────────────────
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
CYAN='\033[36m'
BGREEN='\033[92m'
BYELLOW='\033[93m'
BBLUE='\033[94m'
BMAGENTA='\033[95m'
BWHITE='\033[97m'
BRED='\033[91m'

FAILED=0
CLONED_COUNT=0
SKIPPED_COUNT=0
TOTAL_REPOS=13

# ── Helper: horizontal rule ──────────────────────────────────
hr() { echo -e "${DIM}${1:-$CYAN}$(printf '─%.0s' {1..70})${RESET}"; }

# ── Boot sequence animation ─────────────────────────
boot_flash() {
    clear
    local colours=("$BBLUE" "$CYAN" "$BMAGENTA" "$BYELLOW" "$BGREEN")
    for c in "${colours[@]}"; do
        echo -ne "\033[0;0H"
        echo ""
        echo -e "${c}${BOLD}"
        cat << 'BANNER'
 ██████╗ ███╗   ██╗███████╗██████╗ ██╗     ██╗   ██╗███████╗
██╔═══██╗████╗  ██║██╔════╝██╔══██╗██║     ██║   ██║██╔════╝
██║   ██║██╔██╗ ██║█████╗  ██████╔╝██║     ██║   ██║███████╗
██║   ██║██║╚██╗██║██╔══╝  ██╔═══╝ ██║     ██║   ██║╚════██║
╚██████╔╝██║ ╚████║███████╗██║     ███████╗╚██████╔╝███████║
 ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝     ╚══════╝ ╚═════╝ ╚══════╝
BANNER
        echo -e "${RESET}"
        sleep 0.05
    done
}

# ── Main Banner (OnePlus 15 - INFINITI) ───────────────────────
show_banner() {
    clear
    echo ""
    echo -e "${BBLUE}${BOLD}"
    cat << 'BANNER'
██╗███╗   ██╗███████╗██╗███╗   ██╗██╗████████╗██╗
██║████╗  ██║██╔════╝██║████╗  ██║██║╚══██╔══╝██║
██║██╔██╗ ██║█████╗  ██║██╔██╗ ██║██║   ██║   ██║
██║██║╚██╗██║██╔══╝  ██║██║╚██╗██║██║   ██║   ██║
██║██║ ╚████║██║     ██║██║ ╚████║██║   ██║   ██║
╚═╝╚═╝  ╚═══╝╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝   ╚═╝
BANNER
    echo -e "${RESET}"
    echo -e "  ${BMAGENTA}${BOLD}▌${RESET}${BOLD}${BWHITE} O n e P l u s   1 5   ·   C o d e n a m e : ${CYAN}I N F I N I T I${RESET}${BMAGENTA}${BOLD} ▐${RESET}"
    echo ""
    hr "$BBLUE"
    echo -e "  ${DIM}${CYAN}Snapdragon 8 Gen 4 (sm8850)  ·  Dependency Setup  ·  Raphael Free Zone${RESET}"
    hr "$BBLUE"
    echo ""
}

# ── Process a single repository ──────────────────────────────
clone_repo() {
    local NAME="$1"
    local DIR="$2"
    local URL="$3"
    local BRANCH="$4"
    local CLONE_TYPE="$5"

    echo -e "  📦  ${BOLD}${NAME}${RESET}"
    echo -e "      ${DIM}Path  :${RESET} ${BWHITE}${DIR}${RESET}"
    echo -e "      ${DIM}Remote:${RESET} ${DIM}${URL}${RESET}"
    [ -n "$BRANCH" ] && echo -e "      ${DIM}Branch:${RESET} ${CYAN}${BRANCH}${RESET}"
    
    if [ "$CLONE_TYPE" == "FULL" ]; then
        echo -e "      ${DIM}Mode  :${RESET} ${BMAGENTA}Full Clone (Complete History)${RESET}"
    else
        echo -e "      ${DIM}Mode  :${RESET} ${BYELLOW}Shallow Clone (Depth=1)${RESET}"
    fi
    echo ""

    # Check if directory exists and ask user
    if [ -d "$DIR" ]; then
        echo -ne "  ${BYELLOW}   ↻  Directory exists. Remove and re-clone? [y/N]: ${RESET}"
        
        read -r choice < /dev/tty
        
        if [[ "$choice" == [Yy]* ]]; then
            echo -e "  ${BYELLOW}   ↻  Deleting '$DIR'...${RESET}"
            rm -rf "$DIR"
        else
            echo -e "  ${BGREEN}   ✔  Skipped!${RESET}"
            SKIPPED_COUNT=$(( SKIPPED_COUNT + 1 ))
            echo ""
            hr "$DIM"
            echo ""
            return 0
        fi
    fi

    echo -e "  ${BYELLOW}   ⬇  Initiating clone…${RESET}"
    echo ""

    if [ "$CLONE_TYPE" == "FULL" ]; then
        if [ -n "$BRANCH" ]; then
            git clone -b "$BRANCH" "$URL" "$DIR"
        else
            git clone "$URL" "$DIR"
        fi
    else
        if [ -n "$BRANCH" ]; then
            git clone --depth=1 -b "$BRANCH" "$URL" "$DIR"
        else
            git clone --depth=1 "$URL" "$DIR"
        fi
    fi

    if [ $? -eq 0 ]; then
        echo -e "  ${BGREEN}   ✔  ${NAME} — cloned successfully ✨${RESET}"
        CLONED_COUNT=$(( CLONED_COUNT + 1 ))
    else
        echo -e "  ${BRED}   ✘  ${NAME} — clone FAILED${RESET}"
        FAILED=1
    fi
    
    echo ""
    hr "$DIM"
    echo ""
}

# ── Main Entrypoint ──────────────────────────────────────────
boot_flash
show_banner

show_tree_legend() {
    echo ""
    hr "$BMAGENTA"
    echo -e "  ${BMAGENTA}${BOLD}⬡  SOURCE TREE — Required Repositories${RESET}"
    hr "$BMAGENTA"
    echo ""
    echo -e "  ${BYELLOW}${BOLD}ROM Source Root  (/)${RESET}"
    echo -e "  ${CYAN}│${RESET}"
    echo -e "  ${CYAN}├──${RESET} ${BBLUE}device/oneplus/${RESET}"
    echo -e "  ${CYAN}│  ├──${RESET} ${BWHITE}infiniti${RESET}                ${DIM}← Main OnePlus 15 Device Tree (Manual)${RESET}"
    echo -e "  ${CYAN}│  ├──${RESET} ${BWHITE}infiniti-kernel${RESET}         ${DIM}← Prebuilt kernel & modules${RESET}"
    echo -e "  ${CYAN}│  └──${RESET} ${BWHITE}sm8850-common${RESET}           ${DIM}← Platform common tree${RESET}"
    echo -e "  ${CYAN}│${RESET}"
    echo -e "  ${CYAN}├──${RESET} ${BBLUE}device/qcom/${RESET}"
    echo -e "  ${CYAN}│  └──${RESET} ${BWHITE}sepolicy_vndr${RESET}           ${DIM}← QCOM SEPolicy Blobs${RESET}"
    echo -e "  ${CYAN}│${RESET}"
    echo -e "  ${CYAN}├──${RESET} ${BMAGENTA}hardware/qcom-caf/${RESET}"
    echo -e "  ${CYAN}│  ├──${RESET} ${BWHITE}common${RESET}                  ${DIM}← QCOM common HALs${RESET}"
    echo -e "  ${CYAN}│  └──${RESET} ${BWHITE}sm8850/audio${RESET}            ${DIM}← Audio HAL (lineage-23.2)${RESET}"
    echo -e "  ${CYAN}│${RESET}"
    echo -e "  ${CYAN}├──${RESET} ${BGREEN}vendor/oneplus/${RESET}"
    echo -e "  ${CYAN}│  ├──${RESET} ${BWHITE}infiniti${RESET}                ${DIM}← OnePlus 15 specific blobs${RESET}"
    echo -e "  ${CYAN}│  └──${RESET} ${BWHITE}sm8850-common${RESET}           ${DIM}← Common vendor blobs${RESET}"
    echo -e "  ${CYAN}│${RESET}"
    echo -e "  ${CYAN}└──${RESET} ${BYELLOW}kernel/oneplus/sm8850${RESET}       ${DIM}← AOSP Common Kernel${RESET}"
    echo ""
    hr "$BMAGENTA"
    echo ""
}

show_tree_legend
echo -e "  ${BOLD}Starting dependency resolution...${RESET}"
echo ""

# Device dependencies (FULL CLONE)
clone_repo "OnePlus 15 Kernel Tree" "device/oneplus/infiniti-kernel" "https://github.com/OnePlus-SM8850-Development/android_device_oneplus_infiniti-kernel.git" "" "FULL"
clone_repo "SM8850 Common Device" "device/oneplus/sm8850-common" "https://github.com/OnePlus-SM8850-Development/android_device_oneplus_sm8850-common.git" "" "FULL"
clone_repo "QCOM SEPolicy Vendor" "device/qcom/sepolicy_vndr/sm8850" "https://github.com/OnePlus-SM8850-Development/android_device_qcom_sepolicy_vndr.git" "" "FULL"

# Vendor dependencies (FULL CLONE)
clone_repo "OnePlus 15 Vendor Tree" "vendor/oneplus/infiniti" "https://github.com/OnePlus-SM8850-Development/proprietary_vendor_oneplus_infiniti.git" "" "FULL"
clone_repo "SM8850 Common Vendor" "vendor/oneplus/sm8850-common" "https://github.com/OnePlus-SM8850-Development/proprietary_vendor_oneplus_sm8850-common.git" "" "FULL"
clone_repo "Lineage Vendor" "vendor/lineage" "https://github.com/OnePlus-SM8850-Development/android_vendor_lineage.git" "" "FULL"
clone_repo "QCOM USB Vendor" "vendor/qcom/opensource/usb" "https://github.com/OnePlus-SM8850-Development/android_vendor_qcom_opensource_usb.git" "" "FULL"

# Hardware dependencies (FULL CLONE)
clone_repo "Lineage Compat" "hardware/lineage/compat" "https://github.com/OnePlus-SM8850-Development/android_hardware_lineage_compat.git" "" "FULL"
clone_repo "QCOM CAF Common" "hardware/qcom-caf/common" "https://github.com/OnePlus-SM8850-Development/android_hardware_qcom-caf_common.git" "" "FULL"
clone_repo "QCOM Audio HAL" "hardware/qcom-caf/sm8850/audio/primary-hal" "https://github.com/OnePlus-SM8850-Development/android_hardware_qcom_audio-ar.git" "lineage-23.2-caf-sm8850" "FULL"
clone_repo "QCOM Thermal" "hardware/qcom-caf/thermal" "https://github.com/OnePlus-SM8850-Development/android_hardware_qcom_thermal.git" "" "FULL"
clone_repo "Hardware Oplus" "hardware/oplus" "https://github.com/OnePlus-SM8850-Development/android_hardware_oplus.git" "" "FULL"

# Kernel dependencies (SHALLOW CLONE)
clone_repo "Common Kernel (AOSP)" "kernel/oneplus/sm8850" "https://android.googlesource.com/kernel/common" "android16-6.12-lts" ""

# ── Linkfile Creation ──────────────────────────────────────
echo -e "  📦  ${BOLD}QCOM CAF Android.bp Linkfile${RESET}"
if [ -f "hardware/qcom-caf/sm8850/Android.bp" ]; then
    echo -e "  ${BGREEN}   ✔  Linkfile already exists, skipping...${RESET}"
else
    mkdir -p hardware/qcom-caf/sm8850
    ln -sf ../common/os_pickup_qssi.bp hardware/qcom-caf/sm8850/Android.bp
    echo -e "  ${BGREEN}   ✔  Linkfile created successfully ✨${RESET}"
fi
echo ""
hr "$DIM"
echo ""

# ── Summary Footer ─────────────────────────────────────────
hr "$CYAN"
echo -e "  ${CYAN}${BOLD}⬡  SETUP SUMMARY${RESET}"
hr "$CYAN"
echo ""
echo -e "  ${BGREEN}   ✔  Cloned   :  ${BOLD}${CLONED_COUNT}${RESET}"
echo -e "  ${BYELLOW}   ⊙  Skipped  :  ${BOLD}${SKIPPED_COUNT}${RESET}"

if [ $FAILED -ne 0 ]; then
    echo -e "  ${BRED}   ✘  Failed   :  ${BOLD}$(( TOTAL_REPOS - CLONED_COUNT - SKIPPED_COUNT ))${RESET}"
    echo ""
    hr "$CYAN"
    echo -e "  ${BYELLOW}   Please check your internet connection and the links above.${RESET}"
else
    echo ""
    hr "$CYAN"
    echo -e "  ${BGREEN}${BOLD}  All trees are in place. You're ready to build! 🚀${RESET}"
fi
echo ""
