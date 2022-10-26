#!/bin/bash
#update server, install httpd apache, and create test page

yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
echo "Hello World from $(hostname -f)" > /var/www/html/index.html
echo "<html><body><h1>Hello. Thank you for checking out my Coalfire Project!</h1></body></html>" > /var/www/html/index.html