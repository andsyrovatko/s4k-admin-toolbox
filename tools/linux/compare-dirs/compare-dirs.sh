#!/usr/bin/env bash
# =============================================================================
# Script Name : compare-dirs.sh
# Description : Compares files with the same names in two folders.
#               File names are taken from the first folder (DIR_A).
# Usage       : ./compare-dirs.sh [options] <dir_a> <dir_b>
# Options     : -o <file>   - Save the full report to a file (instead of ./compare-dirs.log)
#               -q          - Quiet — summary only, no diff output
#               -h          - Show this help
# Author      : syr4ok (Andrii Syrovatko)
# Version     : 1.0.0
# =============================================================================

set -euo pipefail
IFS=$'\n\t'

# Configration
LOG_FILE="./compare-dirs.log"
QUIET=false

# COLORS
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Logging
log() {
    local level="$1"; shift
    local msg="$*"
    local ts
    ts=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${ts} [${level}] ${msg}" | tee -a "${LOG_FILE}"
}
log_info()  { log "INFO " "${GREEN}${*}${NC}"; }
log_warn()  { log "WARN " "${YELLOW}${*}${NC}"; }
log_error() { log "ERROR" "${RED}${*}${NC}"; }

# Helpers
print_header() {
    echo -e "\n${BOLD}${BLUE}========================================${NC}"
    echo -e "${BOLD}${BLUE}  $1${NC}"
    echo -e "${BOLD}${BLUE}========================================${NC}\n"
}

usage() {
    echo -e "${BOLD}Usage:${NC} $0 [options] <dir_a> <dir_b>"
    echo ""
    echo "  Compares files with the same names in two folders."
    echo "  The list of files is taken from <dir_a>."
    echo ""
    echo "  Options:"
    echo "    -o <file>   Save the report to the specified file"
    echo "    -q          Summary only (no diff output)"
    echo "    -h          Show this help"
    exit 0
}

check_deps() {
    for cmd in "$@"; do
        command -v "${cmd}" &>/dev/null || { log_error "Missing dependency: ${cmd}"; exit 1; }
    done
}

# Trap
cleanup() {
    local exit_code=$?
    [[ $exit_code -ne 0 ]] && log_error "Script exited with code ${exit_code}"
}
trap cleanup EXIT

# Argument parsing
parse_args() {
    while getopts ":o:qh" opt; do
        case $opt in
            o) LOG_FILE="${OPTARG}" ;;
            q) QUIET=true ;;
            h) usage ;;
            :) echo -e "${RED}Option -${OPTARG} requires an argument.${NC}"; exit 1 ;;
            *) echo -e "${RED}Unknown option: -${OPTARG}${NC}"; exit 1 ;;
        esac
    done
    shift $((OPTIND - 1))

    if [[ $# -lt 2 ]]; then
        echo -e "${RED}Error: need to specify two folders.${NC}"
        usage
    fi

    DIR_A="$1"
    DIR_B="$2"
}

# --- MAIN ---
main() {
    parse_args "$@"

    check_deps diff find

    print_header "Directory Diff: compare-dirs.sh"
    log_info "DIR_A (source of file names) : ${DIR_A}"
    log_info "DIR_B (comparison target)    : ${DIR_B}"

    # Existing check
    [[ -d "${DIR_A}" ]] || { log_error "DIR_A does not exist: ${DIR_A}"; exit 1; }
    [[ -d "${DIR_B}" ]] || { log_error "DIR_B does not exist: ${DIR_B}"; exit 1; }

    local count_identical=0
    local count_different=0
    local count_missing=0
    local total=0

    # Recursively take all files from DIR_A
    while IFS= read -r -d '' rel_file; do
        (( total++ )) || true

        file_a="${DIR_A}/${rel_file}"
        file_b="${DIR_B}/${rel_file}"

        echo -e "\n${BOLD}${CYAN}── File: ${rel_file}${NC}"

        # File missing in DIR_B
        if [[ ! -f "${file_b}" ]]; then
            log_warn "MISSING in DIR_B: ${rel_file}"
            (( count_missing++ )) || true
            continue
        fi

        # Comparing files
        if diff --color=always -u "${file_a}" "${file_b}" > /tmp/_cmp_diff_out 2>&1; then
            log_info "IDENTICAL: ${rel_file}"
            (( count_identical++ )) || true
        else
            log_warn "DIFFERENT: ${rel_file}"
            (( count_different++ )) || true
            # Output diff if not quiet mode
            if [[ "${QUIET}" == false ]]; then
                echo -e "${YELLOW}--- DIR_A/${rel_file}${NC}"
                echo -e "${YELLOW}+++ DIR_B/${rel_file}${NC}"
                cat /tmp/_cmp_diff_out | tee -a "${LOG_FILE}"
            fi
        fi

    done < <(find "${DIR_A}" -type f -printf '%P\0' | sort -z)

    rm -f /tmp/_cmp_diff_out

    # --- STDOUT ---
    echo ""
    print_header "Summary"
    echo -e "  ${BOLD}Total files checked :${NC} ${total}"
    echo -e "  ${GREEN}Identical           : ${count_identical}${NC}"
    echo -e "  ${RED}Different           : ${count_different}${NC}"
    echo -e "  ${YELLOW}Missing in DIR_B    : ${count_missing}${NC}"
    echo ""
    log_info "Log saved to: ${LOG_FILE}"
}

main "$@"
