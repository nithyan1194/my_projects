Dynamic AWS EC2 Fleet Telemetry Collector
A cloud-native operational diagnostic utility designed to dynamically discover active AWS EC2 instances via the AWS CLI 
and execute agentless performance telemetry sweeps over secure SSH connection streams.

Goal & Overview
In dynamically scaling cloud environments (such as Auto Scaling Groups), static IP inventory files quickly become obsolete.
Deploying heavy APM agents (e.g., Datadog, New Relic) to short-lived staging or testing instances introduces high licensing fees, 
setup friction, and RAM overhead.

The primary goal of this project is to build an autonomous, zero-agent cloud telemetry collector. The orchestrator queries
the AWS EC2 API to discover running instances dynamically , extracts health metrics (CPU utilization, RAM consumption, 
root disk usage, and top resource-consuming processes) over non-interactive SSH sessions , and aggregates output logs 
into an audited report ledger.
