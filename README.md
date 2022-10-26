# coalfire_project
Coalfire Technical Challenge

Coalfire Project Documentation
Darcy Wood 10.26.22

Project Requirements:
A company is looking to create a proof-of-concept environment in AWS.  They want a simple VPC as outlined below.  The company would also like to use Terraform to manage their infrastructure via code.
•	1 VPC – 10.1.0.0/16
•	4 subnets (spread evenly across two availability zones)
o	Sub1 – 10.1.0.0/24 (should be accessible from internet)
o	Sub2 – 10.1.1.0/24 (should be accessible from internet)
o	Sub3 – 10.1.2.0/24 (should NOT be accessible from internet)
o	Sub4 – 10.1.3.0/24 (should NOT be accessible from internet)
•	1 EC2 instance running Red Hat Linux in subnet sub2
o	20 GB storage
o	t2.micro
•	1 auto scaling group (ASG) that will spread out instances across subnets sub3 and sub4 
o	Use Red Hat Linux
o	20 GB storage
o	Script the installation of Apache web server (httpd) on these instances
o	2 minimum, 6 maximum hosts
o	t2.micro
•	1 application load balancer (ALB) that listens on TCP port 80 (HTTP) and forwards traffic to the ASG in subnets sub3 and sub4
•	Security groups should be used to allow necessary traffic
•	1 S3 bucket with two folders and the following lifecycle policies
o	“Images” folder - move objects older than 90 days to glacier
o	“Logs” folder - delete objects older than 90 days

