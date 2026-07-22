#!/bin/bash
# ==============================================================================
# Script Name:    cloud_fleet_stats.sh
# Description:    Dynamic AWS EC2 fleet discovery and telemetry orchestrator.
# Tier:           Cloud Infrastructure Diagnostics
# ==============================================================================

# Configuration
readonly REGION="${AWS_REGION:-us-east-1}"
readonly SSH_KEY="${1:-~/.ssh/id_ed25519}"
readonly SSH_USER="ec2-user"
readonly REPORT_FILE="cloud_fleet_telemetry_$(date +'%Y%m%d_%H%M%S').log"
readonly SSH_TIMEOUT=5

# Prerequisites Validation
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed or not available in PATH." >&2
    exit 1
fi

if [ ! -f "$SSH_KEY" ]; then
    echo "Error: Specified SSH Key '$SSH_KEY' does not exist." >&2
    echo "Usage: $0 [path_to_ssh_key]" >&2
    exit 1
fi

echo "=========================================================="
echo "          AWS EC2 FLEET DIAGNOSTIC ORCHESTRATOR           "
echo "=========================================================="
echo "Region:         $REGION"
echo "Execution Time: $(date)"
echo "----------------------------------------------------------"

# 1. Dynamic Discovery Phase: Query running instances using AWS CLI JSON parsing
echo "[+] Discovering active EC2 instances in region: $REGION..."

INSTANCES=$(aws ec2 describe-instances \
    --region "$REGION" \
    --filters "Name=instance-state-name,Values=running" \
    --query "Reservations[*].Instances[*].[InstanceId, PublicIpAddress, Tags[?Key=='Name'].Value | [0]]" \
    --output text)

if [ -z "$INSTANCES" ]; then
    echo "No running EC2 instances found in region $REGION."
    exit 0
fi

# Payload Script to Execute Remotely
REMOTE_CMD=$(cat << 'EOF'
echo "=== HOST: $(hostname) | INSTANCE_TYPE: $(curl -s http://169.254.169.254/latest/meta-data/instance-type 2>/dev/null || echo 'N/A') ==="
cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
cpu_use=$(awk "BEGIN {print 100 - $cpu_idle}")
echo "CPU Utilization:    ${cpu_use}%"
echo "Memory Utilization: $(free -h | awk 'NR==2{printf "%s / %s (%.2f%%)", $3, $2, $3/$2*100}')"
echo "Disk Utilization:   $(df -h / | awk 'NR==2{printf "%s / %s (%s)", $3, $2, $5}')"
echo "Top CPU Process:    $(ps -eo cmd,%cpu --sort=-%cpu | sed -n '2p')"
echo "----------------------------------------------------------------------"
EOF
)

# 2. Iteration Phase: Process target servers discovered from API
echo "$INSTANCES" | while read -r instance_id ip name; do
    server_name="${name:-$instance_id}"
    
    if [ "$ip" == "None" ] || [ -z "$ip" ]; then
        echo -e "\n[!] Skipping $server_name ($instance_id): No public IP assigned."
        continue
    fi

    echo -e "\n[+] Connecting to Cloud Host: $server_name ($ip)..."

    # Execute over secure, non-interactive SSH
    output=$(ssh -i "$SSH_KEY" \
                 -o ConnectTimeout="$SSH_TIMEOUT" \
                 -o BatchMode=yes \
                 -o StrictHostKeyChecking=no \
                 "${SSH_USER}@${ip}" "$REMOTE_CMD" 2>&1)

    if [ $? -eq 0 ]; then
        echo "$output"
        echo "$output" >> "$REPORT_FILE"
    else
        echo "[ERROR] Connectivity failed for $server_name ($ip): $output" >&2
        echo "[$server_name | $ip] CONNECTION_FAILED: $output" >> "$REPORT_FILE"
    fi
done

echo "=========================================================="
echo "Cloud telemetry report archived to: $REPORT_FILE"
