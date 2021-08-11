# Reliability Pillar

## Network
### Route 53

You can use Route 53 [failover routing](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-failover) policy to route traffic to the secondary cluster deployed in another region in case outage of the primary cluster.

![failover](../img/aws-53-failover)

As Elastic Load Blancer does not support RDS instances, you can, however, use Route 53 [weighted routing](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html#routing-policy-weighted) policy to distribute traffic across the RDS Read Replicas. In case of a Read Replica health-check failure, Route 53 weighted record will exlcude those adresses in its reponse to a DNS query.

![weighted](../img/aws-53-weighted)

Reference
- [Scale RDS instances](https://aws.amazon.com/blogs/database/scaling-your-amazon-rds-instance-vertically-and-horizontally/)
- [Distribute requests to RDS read replicas](https://aws.amazon.com/premiumsupport/knowledge-center/requests-rds-read-replicas/)

Note that [a reader endpoint for an Aurora DB cluster provides load-balancing support for read-only connections to the DB cluster.](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Overview.Endpoints.html)

Read more about [Routing internet traffic to AWS resources using Route 53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-to-aws-resources.html)

## Storage 

### Replication

#### S3

All S3 storage classes except `One Zone-Infrequent Access` distribute objects across multiple
availability zones.

To protect your data against multiple availability zone failures or the failure of an
entire region you can enable cross-region replication between a source bucket in one
region and destination bucket in another.

Note that cross-region replication requires versioning to be enabled on both buckets. Also, if the source bucket get deleted,the target bucket is NOT deleted. For replicating object deletion, you can [enable delete marker replication](https://docs.aws.amazon.com/AmazonS3/latest/userguide/delete-marker-replication.html)

#### EBS Volume

EBS automatically replicates volumes across multiple availability zones in a region so that
they’re resilient to a single availability zone failure.

You can use Amazon Data Lifecycle Manager to automatically create a snapshot for
you at regular intervals. To use the Amazon Data Lifecycle Manager, you create a Snapshot
Lifecycle Policy and specify an interval of up to 24 hours, as well as a snapshot creation
time. You also must specify the number of automatic snapshots to retain, up to 1,000
snapshots. You can also enable `cross-region` copy and cross-account sharing.

### EFS
EFS filesystems are stored across multiple zones in a region, allowing you to withstand an availability zone failure.

To protect against data loss and corruption, you can back up individual files to an S3
bucket or another EFS filesystem in the same region. You can also use the [AWS Backup Service](https://docs.aws.amazon.com/efs/latest/ug/awsbackup.html) to schedule incremental backups of your EFS filesystem

### DynamoDB

DynamoDB stores tables across multiple availability zones, which along with giving
you low-latency performance provides additional protection against an availability zone
failure.

To replicate DynamoDB table to different region, you can use [DynamoDB global tables](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GlobalTables.html). 

### RDS

### Aurora

### Backup & Recovery

## Elastic Cache & DAX

## Shading
