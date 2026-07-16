#!/bin/bash

# Ensure an argument was passed
if [ -z "$1" ]; then
    echo "Error: Target log directory path is required."
    echo "Usage: $0 /path/to/logs"
    exit 1
fi

LOG_DIR="$1"
ARCHIVE_DIR="/var/log/archive"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_NAME="logs_backup_${TIMESTAMP}.tar.gz"
AUDIT_LOG="/var/log/archive_audit.log"

# 1. Validation Constraints
if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Directory '$LOG_DIR' does not exist." >&2
    exit 1
fi

# Ensure archive directory exists
mkdir -p "$ARCHIVE_DIR"

# 2. Execution & Compression
echo "Archiving logs from: $LOG_DIR..."

tar -czf "${ARCHIVE_DIR}/${ARCHIVE_NAME}" -C "$LOG_DIR" . 2>/dev/null

# 3. Validation & Auditing
if [ $? -eq 0 ]; then
    echo "Success: Archive created at ${ARCHIVE_DIR}/${ARCHIVE_NAME}"
    
    # Calculate archive file size
    FILE_SIZE=$(du -sh "${ARCHIVE_DIR}/${ARCHIVE_NAME}" | awk '{print $1}')
    
    # Write metadata to central audit log
    echo "[${TIMESTAMP}] SUCCESS: Archived ${LOG_DIR} | File: ${ARCHIVE_NAME} | Size: ${FILE_SIZE}" >> "$AUDIT_LOG"
else
    echo "Error: Tar compression failed." >&2
    echo "[${TIMESTAMP}] FAILED: Archive attempt on ${LOG_DIR} failed." >> "$AUDIT_LOG"
    exit 1
fi
