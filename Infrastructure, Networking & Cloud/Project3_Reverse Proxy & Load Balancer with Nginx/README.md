In Project 2, Nginx served files directly from disk (/var/www/static-site/public). Now, we will elevate Nginx into an Application Gateway / Load Balancer.

Instead of serving static files, Nginx will sit in front of backend applications, route incoming web traffic, distribute load across multiple application instances, and handle health checks.
