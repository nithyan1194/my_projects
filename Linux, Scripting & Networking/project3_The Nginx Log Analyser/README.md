In high-throughput microservice architectures and web servers, access.log files continuously capture real-time inbound traffic telemetry.
During operational incidents—such as sudden spike loads, brute-force security probes, or elevated 5xx server error rates—manually 
inspecting raw multi-gigabyte log streams line-by-line introduces significant diagnostic latency and increases Mean Time to Resolution (MTTR).

🚀 Objective
The primary goal of Project 3 is to build a high-performance, stream-oriented analytical engine using POSIX-compliant shell tools.
The utility parses live web server access logs to instantly aggregate, compute, and present critical metrics:


Top 5 Requesting IP Addresses: Quickly isolate potential DDoS vectors or web scraping bots.

Top 5 Requested Endpoints: Identify backend application bottlenecks and high-demand paths.

HTTP Status Code Breakdown: Track total success rates (2xx), redirects (3xx), client errors (4xx), and backend failures (5xx).

🔒 Operational Constraint
The parser must operate directly on streaming text input without loading entire multi-gigabyte files into host memory (RAM),
ensuring diagnostic runs can be executed safely on resource-constrained production hosts during an active incident.

Step 1: Write the Analyzer Script
Step 2: Create Dummy Nginx Log Data (To Test)
Step 3: Run the Script
Step 4: Interview Deep Dive — How the Stream Pipeline Works


