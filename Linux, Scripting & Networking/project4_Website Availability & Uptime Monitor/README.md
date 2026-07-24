This is an extremely practical DevOps utility—a script that continuously polls web endpoints, checks HTTP status codes and 
response latencies, detects outages, and logs failure telemetry.

Objective
Create an automated uptime monitor that tests a list of web URLs, validates HTTP response status codes, records performance latency, 
and logs any detected downtime or timeout failures.

Intro & Goal
In distributed microservice topologies, external HTTP dependencies and public endpoints can experience silent failures or latency spikes.
Manually pinging or polling endpoints during an incident increases diagnostic latency.

The primary goal of this Project is to create a lightweight, agentless availability probe using 
native POSIX networking utilities (curl, awk). The utility iterates through a dynamic list of target URLs, 
captures exact HTTP response codes, records network latency with sub-second precision, and routes structured 
status logs for audit tracing—all without requiring heavy background monitoring agents.

Constraints
Must use native networking tools (curl, awk, date).

Must process a list of targets dynamically from an external configuration file (targets.txt).

Must differentiate between normal responses (200 OK), client/server errors (4xx/5xx), and connection timeouts.

************************
Why Your Constraints Rule Them Out
The goal of your architecture constraint is to avoid these agents for three main reasons:
Resource Overhead: External daemons consume CPU and memory, which eats into your microservices' operational budget.
Security & Compliance: Installing root-level or privileged background processes introduces new security attack vectors.
Maintenance & Bloat: Updating, configuring, and managing the lifecycle of an external monitoring stack across thousands
of edge points creates massive DevOps overhead
************************

Step 1: Writing the Script
1. Create the targets list (targets.txt)
2. Create the script (uptime_monitor.sh)

Step 2: Run & Verify
1. Grant execution permissions
2. Run the script
3. Inspect the telemetry log
  


