# VPC

![vpc](../img/aws-vpc.svg)

## Subnets

VPC CIDR: 172.16.0.0/16

Given a subnet CIDR within the VPC.

172.16.17.30/20
10101100.00010000.**0001**0001.00011110

The next non-overlaping CIDR (subnet) is to keep the first 16 bits of VPC CIDR prefix and only modify the next 4 bits that are highlighted. And we get the next subnet CIDR within the VPC:

172.16.33.30/20
10101100.00010000.**0010**0001.00011110

To get an IP address within a subnet, modify the bits other than the 20 bits of subnet CIDR prefix:

172.16.32.31 
10101100.00010000.0010**0000.00011111**

### Read More

- [https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html)
