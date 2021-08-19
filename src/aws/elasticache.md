# ElastiCache

A *node* is the smallest buidling block of an ElastiCache deployment. Each node has its own DNS name and port.

Both Redis and Memcached cluster need to be run in a VPC, a collection of subnets within that VPC.

## Redis

A Redis *shard* is a grouping of one to six related nodes. Redis clusters can have up to 500 shards, with data partitioned across the shards.

Redis Repliation happens in a shard where one of the nodes is the read/write primary node. All the other nodes are read-only replica nodes. Locating read replicas in multiple Availibility Zones improves fault tolerance.

The primary endpoint of a Redis cluster is a DNS name that always resolves to the primary node in the cluster. The primary endpoint is **immune** to changes to the cluster, such as promoting a read replica to the primary role. Note that Read Replica failover or promotion is happened automatically which is different to RDS (non-Aurora) database.

The reader endpoint of a Redis cluster will evenly split incoming connections to the endpoint between all read replicas in a ElastiCache for Redis cluster.

In addition, you can use [global datastores](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/Redis-Global-Datastore.html) to create cross-region read replica clusters for ElastiCache for Redis to enable low-latency reads and disaster recovery across AWS Regions.

### AUTH

Redis *AUTH* can only be enabled for encryption in-transit enabled ElastiCache for Redis clusters.

## Memchached

A Memcached cluster is a logical grouping of one or more ElastiCache nodes. Data is partitioned across the nodes in the Memcached cluster. A Memcached cluster can have up to 300 nodes. And nodes can be run across multiple Availibility Zones.

A Memcached cluster does not have the concept of *sharding* as Redis. Memcached cluster relies on the client [Auto-Discovery](https://docs.aws.amazon.com/AmazonElastiCache/latest/mem-ug/AutoDiscovery.html) to automatically identify all of the nodes in a cached cluster, and to initiate and maitain connetions to all of these nodes.

### Comparing between Redis and Memecached

[https://aws.amazon.com/elasticache/redis-vs-memcached/](https://aws.amazon.com/elasticache/redis-vs-memcached/)

<style>
table {
  margin: 0!important;
}
</style>

||Memcached|Redis|
|:---|:---|:---|
|Data Partitioning|Yes|Yes|
|Advanced data structures|-|Yes|
|Multithreaded architecture|Yes|-|
|Snapshots/Backups|-|Yes|
|Replication|-|Yes|

### Read More

- [Elasticache Redis](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/WhatIs.Components.html)
- [Elasticache Memcached](https://docs.aws.amazon.com/AmazonElastiCache/latest/mem-ug/WhatIs.Components.html)
