## Amazon FSx for Lustre

Amazon FSx also integrates with Amazon S3, making it easy for you to process cloud data sets with the Lustre high-performance file system. When linked to an S3 bucket, an FSx for Lustre file system transparently presents S3 objects as files and allows you to write changed data back to S3.

- [FAQ](https://aws.amazon.com/es/fsx/lustre/faqs/?nc=sn&loc=5)

## Aurora
You can invoke a [Lambda function from an Amazon Aurora MySQL DB cluster](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Integrating.Lambda.html#AuroraMySQL.Integrating.LambdaAccess). This approach can be useful when you want to integrate your database running on Aurora MySQL with other AWS services. For example, you might want to send a notification using Amazon Simple Notification Service (Amazon SNS) whenever a row is inserted into a specific table in your database. 

To invoke a Lambda, the Aurora DB cluster must: 
- Create an IAM role, and attach the IAM polcy for providing permissions that allow Aurora DB cluster to invoke Lambda functions.
- Configure your Aurora MySQL DB cluster to allow outbound connections to Lambda. 

## Elatic Beanstalk

- [Deploying Elastic Beanstalk applications from Docker containers](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create_deploy_docker.html)

## CloudTrail

By default, CloudTrail event log files are encrypted using Amazon S3 server-side encryption (SSE). You can also choose to encrypt your log files with an AWS Key Management Service (AWS KMS) key. 

For global services such as AWS Identity and Access Management (IAM), AWS STS, and Amazon CloudFront, events are delivered to any trail that includes global services.

To avoid receiving duplicate global service events,

- If you have multiple single region trails, consider configuring your trails so that global service events are delivered in only one of the trails.


Read More:

- [Data Protection in AWS CloudTrail](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/data-protection.html)
- [Avoid duplicate global service events](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-concepts.html#cloudtrail-concepts-global-service-events)

## AWS Trusted Advisor

- S3 Versioning
- Redshift Clusters
- Exposed Access Keys
- Reserved EC2 Instance
- Service Limit

- [https://aws.amazon.com/about-aws/whats-new/2016/03/aws-trusted-advisor-adds-checks-for-amazon-s3-amazon-redshift-reserved-instances-security-and-service-limits/](https://aws.amazon.com/about-aws/whats-new/2016/03/aws-trusted-advisor-adds-checks-for-amazon-s3-amazon-redshift-reserved-instances-security-and-service-limits/)

## Cost

The main distinction between RIs and Savings Plans is the former commits to number of instances used (RIs), while the latter commits to a minimum dollar per hour spend (Savings Plans). 

## Reserved Instance

- **Standard Reserved Instance**, enables modify AZ, scope, networking type and instance size. 
- **Convertable Reserved Instance**, enables modify instance family, operating system and tenancy.

## Spot Instance

Spot Instance runs whenever capacity is available and the maximum price per hour for your request exceeds the Spot price. 
Spot Instances are a cost-effective choice if you can be flexible about when your applications run and if your applications can be interrupted

## Saving Plan

- **Compute Saving Plans**, reduce costs of EC2 Instance usage by up to 66%, regardless of `instance family`,`region`, size, AZ, OS or tenancy, EC2 Intance usage even includes ECS and Lambda. 
- **EC2 Instance Saving Plans**, reduce costs of EC2 Instance usage by up to 72%, regardless of instance size, AZ, OS or tenancy

#### Read more

- [Saving Plans FAQ](https://aws.amazon.com/savingsplans/faq/?nc1=h_ls)
- [AWS Savings Plans: What They Are And Why You Should Care](https://go.forrester.com/blogs/aws-savings-plans-what-they-are-and-why-you-should-care/)
- [https://aws.amazon.com/blogs/aws/new-savings-plans-for-aws-compute-services/](https://aws.amazon.com/blogs/aws/new-savings-plans-for-aws-compute-services/)
- [Using Sport instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-spot-instances.html)

## Others
- Cloud Search
- AWS Step Functions
- AWS Batch
- [AWS KMS](https://d0.awsstatic.com/whitepapers/aws-kms-best-practices.pdf)
- [Disaster Recovery](https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-options-in-the-cloud.html)
- AWS CloudHSM
- Amazon Polly
- Amazon EMR
