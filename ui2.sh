#!/usr/bin/env bash

# 엄격한 모드(set -u)에서도 에러가 발생하지 않도록 전역 변수 초기화
C_RESET=""
C_BOLD=""
C_DIM=""
C_RED=""
C_GREEN=""
C_YELLOW=""
C_BLUE=""
C_MAGENTA=""
C_CYAN=""

ui::init_colors() {
    local ncolors

    if [[ -t 1 ]]; then
        ncolors=$(tput colors 2>/dev/null || echo 0)
        if [[ -n "$ncolors" && "$ncolors" -ge 8 ]]; then
            C_RESET="$(tput sgr0)"
            C_BOLD="$(tput bold)"
            C_DIM="$(tput dim)"
            C_RED="$(tput setaf 1)"
            C_GREEN="$(tput setaf 2)"
            C_YELLOW="$(tput setaf 3)"
            C_BLUE="$(tput setaf 4)"
            C_MAGENTA="$(tput setaf 5)"
            C_CYAN="$(tput setaf 6)"
        fi
    fi
}

# 터미널 너비를 동적으로 계산 (기본값 80)
ui::_get_width() {
    local width
    width=$(tput cols 2>/dev/null || echo 80)
    printf '%s\n' "$width"
}

ui::line() {
    local width
    local char
    local line

    width=$(ui::_get_width)
    if (( width > 80 )); then
        width=80
    fi

    char="${1:--}"

    printf -v line '%*s' "$width" ''
    printf '%s\n' "${line// /$char}"
}

# 텍스트 길이에 맞춘 가변 구분선 (내부용)
ui::_draw_line_by_text() {
    local text="$1"
    local char="${2:-=}"
    local len
    local line

    len=${#text}
    printf -v line '%*s' "$len" ''
    printf '%s\n' "${line// /$char}"
}

# 개선된 Title (텍스트 길이에 맞춤)
ui::title() {
    local msg="  $1  "

    printf '\n%b' "${C_BOLD}${C_BLUE}"
    ui::_draw_line_by_text "$msg" "="
    printf '%s\n' "$msg"
    ui::_draw_line_by_text "$msg" "="
    printf '%b' "${C_RESET}"
}

# ui::indent (들여쓰기 블록)
# 사용법: ui::indent "출력할 내용" (공백 4칸 추가)
ui::indent() {
    local indent="    "
    printf '%s\n' "$*" | sed "s/^/$indent/"
}

# ui::ask_confirm (사용자 확인)
ui::ask_confirm() {
    local prompt="${1:-continue?}"
    local resp

    if [[ ! -r /dev/tty ]]; then
        ui::error "interactive tty is not available"
        return 1
    fi

    while true; do
        printf "\n%b%s (y/n): %b" "${C_YELLOW}${C_BOLD}" "$prompt" "${C_RESET}" > /dev/tty

        if ! read -r -n 1 resp < /dev/tty; then
            ui::error "failed to read from /dev/tty"
            return 1
        fi

        printf '\n' > /dev/tty

        case "$resp" in
            [yY]) return 0 ;;
            [nN]) return 1 ;;
            *) ui::warn "type y or n" ;;
        esac
    done
}

ui::section() {
    printf '\n%b\n' "${C_BOLD}${C_MAGENTA}▶ $1${C_RESET}"
}

ui::info() {
    printf '%b %s\n' "${C_CYAN}[INFO]${C_RESET}" "$*"
}

ui::ok() {
    printf '%b %s\n' "${C_GREEN}[ OK ]${C_RESET}" "$*"
}

ui::warn() {
    printf '%b %s\n' "${C_YELLOW}[WARN]${C_RESET}" "$*"
}

ui::error() {
    printf '%b %s\n' "${C_RED}[FAIL]${C_RESET}" "$*" >&2
}

ui::die() {
    ui::error "$*"
    exit 1
}

ui::debug() {
    # DEBUG=1 또는 DEBUG=true 일 때만 stderr로 출력
    if [[ "${DEBUG:-0}" == "1" || "${DEBUG:-}" == "true" ]]; then
        printf '%b %s\n' "${C_DIM}[DEBUG]${C_RESET}" "$*" >&2
    fi
}

# 주요 작업 단계 표시 (예: ==> 작업 시작)
ui::step() {
    printf '\n%b==>%b %b%s%b\n' "${C_BOLD}${C_BLUE}" "${C_RESET}" "${C_BOLD}" "$*" "${C_RESET}"
}

ui::field() {
    printf '  %b%-20s%b %s\n' "${C_DIM}" "$1:" "${C_RESET}" "${*:2}"
}

ui::item() {
    printf '  %b•%b %s\n' "${C_YELLOW}" "${C_RESET}" "$1"
}

ui::pause() {
    local msg="${1:-press Enter to continue ...}"

    if [[ ! -r /dev/tty ]]; then
        ui::error "interactive tty is not available"
        return 1
    fi

    printf '\n%b' "${C_YELLOW}${msg}${C_RESET}" > /dev/tty

    if ! read -r < /dev/tty; then
        ui::error "failed to read from /dev/tty"
        return 1
    fi
}

# 테이블 형식을 유연하게 (배열 사용 권장)
ui::table_row() {
    local format="${UI_TABLE_FORMAT:-%-24s %-16s %-20s\n}"

    if [[ "$1" == "--header" ]]; then
        shift
        printf "${C_BOLD}$format${C_RESET}" "$@"
        ui::line "-"
    else
        printf "$format" "$@"
    fi
}

ui::init_colors
