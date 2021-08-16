# Global Accelerator

AWS Global Accelerator is a networking service that helps you improve the **availability** and performance of the applications that you offer to your global users.

## VS. ELB

ELB provides load balancing within one Region, AWS Global Accelerator provides traffic management across multiple Regions.
A regional ELB load balancer is an ideal target for AWS Global Accelerator. AWS Global Accelerator complements ELB by extending these capabilities beyond a single AWS Region, allowing you to provision a global interface for your applications in any number of Regions. 

## VS. CloudFront

AWS Global Accelerator and Amazon CloudFront are separate services that use the AWS global network and its edge locations around the world.

Both services integrate with AWS Shield for DDoS protection.

-  CloudFront improves performance for both cacheable content (such as images and videos) and dynamic content (such as API acceleration and dynamic site delivery).
- Global Accelerator is a good fit for non-HTTP use cases, such as gaming (UDP), IoT (MQTT), or Voice over IP, as well as for HTTP use cases that specifically require static IP addresses or deterministic, fast regional failover.

## VS. Route 53

In short: AWS Global Accelerator doesn't have problems with DNS record caching TTL when failing over to another region.

- First, some client devices and internet resolvers cache DNS answers for long periods of time. So when you make a configuration update, or there’s an application failure or change in your routing preference, you don’t know how long it will take before all of your users receive updated IP addresses. With AWS Global Accelerator, you don’t have to rely on the IP address caching settings of client devices. Change propagation takes a matter of seconds, which reduces your application downtime.
- Second, with Global Accelerator, you get static IP addresses that provide a fixed entry point to your applications. This lets you easily move your endpoints between Availability Zones or between AWS Regions, without having to update the DNS configuration or client-facing applications.

You can create a Route 53 record to point to AWS Global Accelerator alias.

### Read More

- [AWS Global Accelerator FAQs](https://aws.amazon.com/global-accelerator/faqs/)
- [DNS addressing in Global Accelerator](https://docs.aws.amazon.com/global-accelerator/latest/dg/dns-addressing-custom-domains.dns-addressing.html)
