#!/usr/bin/env bash

# Load ui2.sh library
source "$(dirname "$0")/ui2.sh" 2>/dev/null || source "$HOME/lib/ui2.sh"

ui::title "UI2 Library Demo"

ui::section "1. Basic Messages"
ui::info "This is an info message. (ui::info)"
ui::ok "This is a success message. (ui::ok)"
ui::warn "This is a warning message. (ui::warn)"
ui::error "This is an error message. (ui::error)"

ui::section "2. Fields & Items"
ui::field "OS" "Ubuntu 22.04 LTS"
ui::field "Kernel" "$(uname -r)"
ui::field "Uptime" "10 days, 2 hours"
echo
ui::item "This is the first item. (ui::item)"
ui::item "This is the second item."

ui::section "3. Lines & Indents"
ui::info "Default line (max 80 chars):"
ui::line
ui::info "Custom character line:"
ui::line "*"
ui::info "Indented text:"
ui::indent "This text is indented using"
ui::indent "the ui::indent function (4 spaces)."

ui::section "4. Step & Debug"
ui::step "Starting a new task step... (ui::step)"
ui::info "Debug message output (when DEBUG=1):"
DEBUG=1 ui::debug "This message is for debugging purposes only. (ui::debug)"

ui::section "5. Tables"
ui::info "Default table (3 columns):"
ui::table_row --header "ID" "NAME" "STATUS"
ui::table_row "user_01" "Alice" "Active"
ui::table_row "user_02" "Bob" "Inactive"

echo
ui::info "Custom table format applied (UI_TABLE_FORMAT):"
export UI_TABLE_FORMAT="%-20s %-20s\n"
ui::table_row --header "CONFIGURATION" "VALUE"
ui::table_row "Max Connections" "1024"
ui::table_row "Timeout" "30s"

ui::section "6. Interactive Prompt"
if ui::ask_confirm "Do you want to proceed to the next step? (ui::ask_confirm)"; then
    ui::ok "User selected 'y'."
else
    ui::warn "User selected 'n'."
fi

ui::section "7. Pause & Die"
ui::pause "Press Enter to finish the demo... (ui::pause)"

# ui::die is commented out to just show how it's used in this demo
# ui::info "Use ui::die for fatal errors:"
# ui::die "Terminating the script immediately!"

ui::ok "Demo completed."
