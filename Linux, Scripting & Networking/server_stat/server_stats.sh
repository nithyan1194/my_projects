#!/bin/bash

echo "=========================================="
echo "        SERVER PERFORMANCE STATS          "
echo "=========================================="

# 1. OS Version
echo -e "\n--- OS Version ---"
if [ -f /etc/os-release ]; then
    grep "PRETTY_NAME" /etc/os-release | cut -d= -f2 | tr -d '"'
else
    uname -sr
fi

# 2. Total CPU Usage
echo -e "\n--- CPU Usage ---"
# Calculates total CPU usage by looking at idle time
cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
cpu_use=$(echo "100 - $cpu_idle" | bc 2>/dev/null || awk "BEGIN {print 100 - $cpu_idle}")
echo "Total CPU Usage: ${cpu_use}%"

# 3. Total Memory Usage (Free vs Used)
echo -e "\n--- Memory Usage ---"
free -h | awk 'NR==2{printf "Used: %s / Total: %s (%.2f%%)\n", $3, $2, $3/$2*100}'

# 4. Total Disk Usage
echo -e "\n--- Disk Usage ---"
df -h / | awk 'NR==2{printf "Used: %s / Total: %s (%s)\n", $3, $2, $5}'

# 5. Top 5 Processes by CPU & Memory
echo -e "\n--- Top 5 Processes by CPU Usage ---"
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6

echo -e "\n--- Top 5 Processes by Memory Usage ---"
ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 6
echo "=========================================="
