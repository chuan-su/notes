# Data Encryption

## Data at Rest

Data stored in Glacier and Storage Gateway are encrypted by default.

### RDS

You can only enable encryption for an Amazon RDS DB instance when you create it, not after the DB instance is created.

However, because you can encrypt a copy of an unencrypted snapshot, you can effectively add encryption to an unencrypted DB instance. That is, you can create a snapshot of your DB instance, and then create an encrypted copy of that snapshot. You can then restore a DB instance from the encrypted snapshot, and thus you have an encrypted copy of your original DB instance.


## Data in Trasit

- All traffic between AZs is encrypted.
- All cross-Region traffic that uses Amazon `VPC Peering` and `Transit Gateway peering` is automatically bulk-encrypted when it exits a Region. 
- Remote access to your instances using `AWS Systems Manager` Session Manager or the Run Command is encrypted using TLS 1.2.
- AWS DataSync uses TLS 1.2 to encrypt all network traffic
- All data that `Storage Gateway` transfers to AWS is encrypted in transit and at rest in AWS.
- Use the `EFS mount helper` to mount a file system so that all NFS traffic is encrypted in transit using Transport Layer Security 1.2 (TLS).
- Amazon Certificate Manager (ACM) to generate a TLS certifi- cate and then install it on an `application load balancer`, `Network load balancer` or a `CloudFront distribution`. Also note about `SNI`.
- `AWS Direct Connect` does not encrypt your traffic that is in transit. You can combine DataSync with Direct Connect for private connectivity.
- `AWS Direct Connect` and AWS Site-to-Site VPN combination  provides an IPsec-encrypted private connection that also reduces network costs, increases bandwidth throughput, and provides a more consistent network experience than internet-based VPN connection
- You can use Secure Socket Layer (SSL) or Transport Layer Security (TLS) from your application to encrypt a connection to a DB instance running MySQL, MariaDB, SQL Server, Oracle, or PostgreSQL. 
 `Amazon RDS` creates an SSL certificate and installs the certificate on the DB instance when the instance is provisioned. [Read more](https://aws.amazon.com/rds/features/security/)

## TLS listener

To use a TLS listener, you must deploy at least one server certificate on your load balancer. The load balancer uses a server certificate to terminate the front-end connection and then to decrypt requests from clients before sending them to the targets.

Elastic Load Balancing uses a TLS negotiation configuration, known as a security policy, to negotiate TLS connections between a client and the load balancer. **A security policy is a combination of protocols and ciphers**. The protocol establishes a secure connection between a client and a server and ensures that all data passed between the client and your load balancer is private. A cipher is an encryption algorithm that uses encryption keys to create a coded message. Protocols use several ciphers to encrypt data over the internet. During the connection negotiation process, the client and the load balancer present a list of ciphers and protocols that they each support, in order of preference. The first cipher on the server's list that matches any one of the client's ciphers is selected for the secure connection.

Network Load Balancers do not support TLS renegotiation.

Read more about [TLS listener for Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/create-tls-listener.html)
