#!/usr/bin/env bash

# =========================
# Color detection
# =========================
if [[ -t 1 ]]; then
    C_RESET=$'\033[0m'
    C_BOLD=$'\033[1m'
    C_DIM=$'\033[2m'

    C_RED=$'\033[31m'
    C_GREEN=$'\033[32m'
    C_YELLOW=$'\033[33m'
    C_BLUE=$'\033[34m'
    C_MAGENTA=$'\033[35m'
    C_CYAN=$'\033[36m'
else
    C_RESET=""
    C_BOLD=""
    C_DIM=""
    C_RED=""
    C_GREEN=""
    C_YELLOW=""
    C_BLUE=""
    C_MAGENTA=""
    C_CYAN=""
fi

ui::line() {
    printf '%s\n' "--------------------------------------------------------------------------------"
}

ui::title() {
    ui::line
    printf '%b\n' "${C_BOLD}${C_BLUE}$1${C_RESET}"
    ui::line
}

ui::section() {
    printf '\n%b\n' "${C_BOLD}${C_MAGENTA}▶ $1${C_RESET}"
}

ui::info() {
    printf '%b\n' "${C_CYAN}[INFO]${C_RESET} $*"
}

ui::ok() {
    printf '%b\n' "${C_GREEN}[ OK ]${C_RESET} $*"
}

ui::warn() {
    printf '%b\n' "${C_YELLOW}[WARN]${C_RESET} $*"
}

ui::error() {
    printf '%b\n' "${C_RED}[FAIL]${C_RESET} $*"
}

ui::field() {
    local key="$1"
    local value="$2"
    printf '  %b%-20s%b %s\n' "${C_DIM}" "${key}:" "${C_RESET}" "${value}"
}

ui::item() {
    printf '  %b- %s%b\n' "${C_YELLOW}" "$1" "${C_RESET}"
}

ui::pause() {
    local msg="${1:-Press Enter to continue...}"
    printf '\n%b' "${C_YELLOW}${msg}${C_RESET}"
    read -r < /dev/tty
}

ui::table_header() {
    printf '%b%-24s %-16s %-20s%b\n' \
        "${C_BOLD}" "$1" "$2" "$3" "${C_RESET}"
    ui::line
}

ui::table_row() {
    printf '%-24s %-16s %-20s\n' "$1" "$2" "$3"
}
