# VPC

![vpc](../img/aws-vpc.svg)

## Subnets

VPC CIDR: 172.16.0.0/16

Given a subnet CIDR within the VPC, as follows:

172.16.17.30/20

10101100.00010000.**0001**0001.00011110

The next non-overlaping CIDR (subnet) is to keep the first 16 bits of VPC CIDR prefix and only modify the next 4 bits that are highlighted. And we get the next subnet CIDR within the VPC:

172.16.33.30/20

10101100.00010000.**0010**0001.00011110

To get an IP address within a subnet, modify the bits other than the 20 bits of subnet CIDR prefix:

172.16.32.31 

10101100.00010000.0010**0000.00011111**

## VPC endpoint

A [VPC endpoint](https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints.html) enables private connections **between your VPC and supported AWS services** and [VPC endpoint services](https://docs.aws.amazon.com/vpc/latest/privatelink/endpoint-service.html) powered by AWS PrivateLink.

A VPC endpoint does not require an internet gateway, virtual private gateway, NAT device, VPN connection, or AWS Direct Connect connection. Instances in your VPC do not require public IP addresses to communicate with resources in the service. 

One usecase of VPC endpoint is to [create VPC endpoints for Amazon ECS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/vpc-endpoints.html)

### VPC endpoint service

- [VPC endpoint serices (AWS PrivateLink](https://docs.aws.amazon.com/vpc/latest/privatelink/endpoint-service-overview.html)

## VPC Link

You can create an `API Gateway API` with private integration to provide your customers access to HTTP/HTTPS resources within your Amazon VPC.

Such VPC resources are HTTP/HTTPS endpoints on an EC2 instance behind a `Network Load Balancer` in the VPC. The Network Load Balancer encapsulates the VPC resource and routes incoming requests to the targeted resource. 

- [API Gateway privat integration](https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-api-with-vpclink-console.html)
- [Tutorial: Build a REST API with API Gateway private integration](https://docs.aws.amazon.com/apigateway/latest/developerguide/getting-started-with-private-integration.html)

## Multi-VPC Network Infrastructure

- [Whitepaper: Building a Scalable and Secure Multi-VPC AWS Network Infrastructure](https://docs.aws.amazon.com/whitepapers/latest/building-scalable-secure-multi-vpc-network-infrastructure/welcome.html)
- [Centralized egress to Internet](https://docs.aws.amazon.com/whitepapers/latest/building-scalable-secure-multi-vpc-network-infrastructure/centralized-egress-to-internet.html)
- [Creating a single internet exit point from multiple VPCs Using AWS Transit Gateway](https://aws.amazon.com/blogs/networking-and-content-delivery/creating-a-single-internet-exit-point-from-multiple-vpcs-using-aws-transit-gateway/)
- [Egress VPC](https://www.gilles.cloud/2020/10/egress-vpc-and-aws-transit-gateway.html)

## DHCP option set

# Hybrid Cloud

- [Whitepaper: AWS VPC Connectivity Options](https://d1.awsstatic.com/whitepapers/aws-amazon-vpc-connectivity-options.pdf)

### Read More

- [https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html)
- [https://www.cisco.com/c/en/us/support/docs/ip/routing-information-protocol-rip/13788-3.html](https://www.cisco.com/c/en/us/support/docs/ip/routing-information-protocol-rip/13788-3.html)
