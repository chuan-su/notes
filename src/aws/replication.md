# Replication & Backups

### S3

All S3 storage classes except `One Zone-Infrequent Access` distribute objects across multiple
availability zones.

You can also enable cross-region replication between a source bucket in one region and destination bucket in another.
Note that cross-region replication requires versioning to be enabled on both buckets. Note that cross-region replication does not apply to existing objects. Also, if the source bucket get deleted,the target bucket is NOT deleted. For replicating object deletion, you can [enable delete marker replication](https://docs.aws.amazon.com/AmazonS3/latest/userguide/delete-marker-replication.html)

In addtion to [S3 Intelligent Tier Storage](https://aws.amazon.com/about-aws/whats-new/2018/11/s3-intelligent-tiering/) that moves objects that have not been accessed for 30 consecutive days to the infrequent access tier. You can also manually configure [lifecycle rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html) for a bucket that will automatically transition an object’s storage class after a set number of days. 

Read more about [Replicating objects](https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication.html#crr-scenario).

### EBS Volume

EBS automatically replicates volumes across multiple availability zones in a region.

You can use [Amazon Data Lifecycle Manager](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/snapshot-lifecycle.html) to automatically create a snapshot for you at regular intervals. To use the Amazon Data Lifecycle Manager, you create a Snapshot Lifecycle Policy and specify an interval of up to 24 hours, as well as a snapshot creation time. You also must specify the number of automatic snapshots to retain, up to 1,000
snapshots. You can also enable `cross-region` copy and cross-account sharing.

### EFS

EFS filesystems are stored across multiple zones in a region.

To protect against data loss and corruption, you can back up individual files to an S3 bucket or another EFS filesystem in the same region. 
You can also use the [AWS Backup Service](https://docs.aws.amazon.com/efs/latest/ug/awsbackup.html) to schedule incremental backups of your EFS filesystem

### DynamoDB

DynamoDB stores tables across multiple availability zones.
To replicate DynamoDB table to different region, you can use [DynamoDB global tables](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GlobalTables.html). 

You can also configure point-in-time recovery to automatically take backups of your DynamoDB tables.
Point-in-time recovery lets you restore your DynamoDB tables to any point in time from 35 days until 5 minutes before the current time.

### RDS

#### Multi-AZ Deployments

Multi-AZ deployment provides a *standby database instance* in a different availibity zone that the *primary database* instance resides.

RDS synchronously replicates data from the primary to the standby instance. And if the primray instance experiences an outage, it will fail over to the standby instance. 

**Note that** in the multi-AZ deployment, all instances resides in the same region. And the standby instance is not a read replica and cannot serve read traffic. And you can't directly connect to the standby instance. This is only used in the event of a database failover when your primary instance encountered an outage


#### Read Replica

With Amazon RDS, you can create a read replica of the primary database instance in a different AZ even different region.
However, creating a cross-region read replica isn't supported for SQL Server on Amazon RDS.

When creating a read replica, you must enable automatic backups on the source DB instance by setting the backup retention period to
a value other than 0.

You can have up to 5 replicas and each read replica will have its own DNS endpoint.

Replicas can be promoted to their own standalone database, but this breaks the replication. 
Moreover, no automatic failover, if primary database fails you must manually update urls to point at the newly promoted database.

##### Compare

| Mutil-AZ Deployments                                             | Read Replicas                                                       |
| :---                                                             | :---                                                                |
| Synchronous replication - highly durable                         | Asynchronous replication - highly scalable                          |
| Only database engine on primary instance is active               | All read replicas are accessible and can be used for read scaling   |
| Automated backups are taken from standby instance                | No backups configured by default                                    |
| Always span at least 2 Availability Zones within a single region | Can be within Availability Zone, Cross-AZ, or Cross-Region          |
| Database engine version upgrades happen on primary instance      | Database engine version upgrade is independent from source instance |
| Automatic failover to standby when a problem is detected         | can be manually promoted to a standalone database instance          |

#### Point-in-time recovery

Enabling automatic backups enables point-in-time recovery, which archives database change logs to S3 every 5 minutes.

RDS keeps automated snapshots for a limited period of time and then deletes them. You can choose a retention period between one day and 35 days. 
The default is seven days. To disable automated snapshots, set the retention period to 0. 


Note that disabling automated snapshots immediately deletes all existing automated snapshots and disables point-in-time recovery. Also, if you change the retention period from 0 to any other value, it will trigger an immediate snapshot.


Reference

- [Working with read replicas](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html)
- [Cross-region read replicas](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.XRgn.html)
- [Read replicas, Mutil-AZ deployments, and multi-region deployments](https://aws.amazon.com/rds/features/read-replicas/)


### Aurora

- [Aurora DB cluster](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Overview.html)
- [Aurora Connection](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Overview.Endpoints.html)
- [Aurora Replication](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Replication.html)

### Redshift

Snapshots are point-in-time backups of a cluster. There are two types of snapshots: automated and manual. Amazon Redshift stores these snapshots internally in Amazon S3 by using an encrypted Secure Sockets Layer (SSL) connection. 

When automated snapshots are enabled for a cluster, Amazon Redshift periodically takes snapshots of that cluster. By default Amazon Redshift takes a snapshot about every eight hours or following every 5 GB per node of data changes, or whichever comes first. 

You can configure Amazon Redshift to automatically copy snapshots (automated or manual) for a cluster to another AWS Region. When a snapshot is created in the cluster's primary AWS Region, it's copied to a secondary AWS Region.

Reference

- [https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-snapshots.html#working-with-snapshots-overview](https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-snapshots.html#working-with-snapshots-overview)
