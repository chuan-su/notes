# Cloud Front

## CloudFront Caching

- [Caching based on Query String](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/QueryStringParameters.html)
  - Always Use the Same Case for Parameter Names and Values.
- Caching based on cookies
- Caching based on request headers


## CloudFront private content

- Signed URL for individual files
- Signed Cookies for multiple files
- Origin Access Identify for restricting access to S3 buckets
- Custom Headers for restricting access to ELB
- Use AWS WAF firewall to control content access

## Lambda@Edge

- [Visitor Prioritization](https://aws.amazon.com/blogs/networking-and-content-delivery/visitor-prioritization-on-e-commerce-websites-with-cloudfront-and-lambdaedge/)

## Resilient

To set up [CloudFront origin failover](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/high_availability_origin_failover.html), you must have a distribution with at least two origins. Next, you create an origin group for your distribution that includes two origins, setting one as the primary. Finally, you create or update a cache behavior to use the origin group.



#### Read More

- [CloudFront Caching](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/ConfiguringCaching.html)
- [CloudFront Private Content](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-overview.html)
