# Security

![security](../img/aws-security.svg)

## DDoS attack
To protect your system from DDoS attack, you can do the following:

- Use an Amazon CloudFront service for distributing both static and dynamic content.

- Use an Application Load Balancer with Auto Scaling groups for your EC2 instances then restrict direct Internet traffic to your Amazon RDS database by deploying to a private subnet.

- Set up alerts in Amazon CloudWatch to look for high `Network In` and CPU utilization metrics.

- AWS Shield and AWS WAF to fortify your cloud network. 


