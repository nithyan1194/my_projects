#!/bin/bash
# ==============================================================================
# Script Name:    uptime_monitor.sh
# Description:    Automated website availability and response time monitor.
# ==============================================================================

# Configuration
readonly TARGETS_FILE="${1:-targets.txt}"
readonly LOG_FILE="uptime_audit.log"
readonly TIMEOUT=5 # seconds

# Input Validation
if [ ! -f "$TARGETS_FILE" ]; then
    echo "Error: Targets file '$TARGETS_FILE' not found." >&2
    echo "Usage: $0 [path_to_targets_file]" >&2
    exit 1
fi

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo "=========================================================="
echo "          WEBSITE AVAILABILITY CHECK REPORT"
echo "=========================================================="
echo "Execution Time: $TIMESTAMP"
echo "Target List:    $TARGETS_FILE"
echo "----------------------------------------------------------"

while IFS= read -r url || [ -n "$url" ]; do
    # Skip empty lines and comments
    [[ -z "$url" || "$url" =~ ^# ]] && continue

    # Measure HTTP status code and total response time (in seconds)
    response=$(curl -s -o /dev/null -w "%{http_code} %{time_total}" --max-time "$TIMEOUT" "$url")
    
    status_code=$(echo "$response" | awk '{print $1}')
    response_time=$(echo "$response" | awk '{print $2}')

    # Validate response status
    if [ "$status_code" -eq 200 ]; then
        status="UP"
        echo -e "[SUCCESS] $url | Status: $status_code | Latency: ${response_time}s"
    elif [ "$status_code" -eq 000 ]; then
        status="TIMEOUT/DOWN"
        echo -e "[CRITICAL] $url | Connection Timed Out (> ${TIMEOUT}s)" >&2
    else
        status="ERROR"
        echo -e "[WARNING]  $url | Status: $status_code | Latency: ${response_time}s" >&2
    fi

    # Append telemetry data to audit log
    echo "[$TIMESTAMP] URL: $url | Status: $status ($status_code) | Response Time: ${response_time}s" >> "$LOG_FILE"

done < "$TARGETS_FILE"

echo "=========================================================="
echo "Telemetry recorded to: $LOG_FILE"
