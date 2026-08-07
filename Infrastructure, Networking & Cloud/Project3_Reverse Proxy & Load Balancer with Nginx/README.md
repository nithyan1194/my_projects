In Project 2, Nginx served files directly from disk (/var/www/static-site/public). Now, we will elevate Nginx into an Application Gateway / Load Balancer.

Instead of serving static files, Nginx will sit in front of backend applications, route incoming web traffic, distribute load across multiple application instances, and handle health checks.

An enterprise-grade infrastructure implementation demonstrating how to configure Nginx as an edge application gateway, reverse proxy, and round-robin load balancer in front of multiple backend application instances running on an AWS EC2 host.
