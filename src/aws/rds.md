# RDS

## Multi-AZ Deployments

Multi-AZ deployment provides a *standby database instance* in a different availibity zone that the *primary database* instance resides.

RDS synchronously replicates data from the primary to the standby instance. And if the primray instance experiences an outage, it will fail over to the standby instance. 

**Note that** in the multi-AZ deployment, all instances resides in the same region. And the standby instance is not a read replica and cannot serve read traffic.

## Read Replica

With Amazon RDS, you can create a read replica of the primary database instance in a different AZ even different region.
However, creating a cross-region read replica isn't supported for SQL Server on Amazon RDS.

When creating a read replica, you must enable automatic backups on the source DB instance by setting the backup retention period to
a value other than 0.

You can have up to 5 replicas and each read replica will have its own DNS endpoint.

Replicas can be promoted to their own standalone database, but this breaks the replication. 
Moreover, no automatic failover, if primary database fails you must manually update urls to point at the newly promoted database.

### Compare

| Mutil-AZ Deployments                                             | Read Replicas                                                       |
| :---                                                             | :---                                                                |
| Synchronous replication - highly durable                         | Asynchronous replication - highly scalable                          |
| Only database engine on primary instance is active               | All read replicas are accessible and can be used for read scaling   |
| Automated backups are taken from standby instance                | No backups configured by default                                    |
| Always span at least 2 Availability Zones within a single region | Can be within Availability Zone, Cross-AZ, or Cross-Region          |
| Database engine version upgrades happen on primary instance      | Database engine version upgrade is independent from source instance |
| Automatic failover to standby when a problem is detected         | can be manually promoted to a standalone database instance          |

## Point-in-time recovery

Enabling automatic backups enables point-in-time recovery, which archives database change logs to S3 every 5 minutes.

RDS keeps automated snapshots for a limited period of time and then deletes them. You can choose a retention period between one day and 35 days. 
The default is seven days. To disable automated snapshots, set the retention period to 0. 


Note that disabling automated snapshots immediately deletes all existing automated snapshots and disables point-in-time recovery. Also, if you change the retention period from 0 to any other value, it will trigger an immediate snapshot.


Reference

- [Working with read replicas](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html)
- [Cross-region read replicas](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.XRgn.html)
- [Read replicas, Mutil-AZ deployments, and multi-region deployments](https://aws.amazon.com/rds/features/read-replicas/)


