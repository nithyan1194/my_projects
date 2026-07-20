#!/bin/bash
# ==============================================================================
# Script Name:    nginx_analyser.sh
# Description:    High-efficiency POSIX stream engine for parsing Nginx logs.
# Tier:           Intermediate DevOps Scripting
# ==============================================================================

# Ensure target file argument is provided
if [ -z "$1" ]; then
    echo "Error: Target Nginx log file path is required." >&2
    echo "Usage: $0 /path/to/access.log" >&2
    exit 1
fi

readonly LOG_FILE="$1"

# Structural Validation Constraint
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Target file '$LOG_FILE' does not exist." >&2
    exit 1
fi

echo "=========================================================="
echo "          NGINX ACCESS LOG ANALYSIS REPORT"
echo "=========================================================="
echo "Target Resource: $LOG_FILE"
echo "Execution Time:  $(date)"
echo "----------------------------------------------------------"

# 1. Top 5 IP Addresses
echo -e "\n[+] TOP 5 REQUESTING IP ADDRESSES:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5

# 2. Top 5 Requested Paths
echo -e "\n[+] TOP 5 REQUESTED URL PATHS:"
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5

# 3. HTTP Status Code Breakdown
echo -e "\n[+] HTTP RESPONSE CODE DISTRIBUTION:"
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr

echo "=========================================================="
