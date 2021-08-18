# DynamoDB

## Auto Scaling

With Application Auto Scaling, you create a scaling policy for `a table` or `a global secondary index`. The scaling policy specifies whether you want to scale `read capacity` or `write capacity` (or both), and the minimum and maximum provisioned capacit unit settings for the table or index. 

You can set the auto scaling target utilization values between 20 and 90 percent for your read and write capacity. 

In addition to tables, DynamoDB auto scaling also supports global secondary indexes. Every global secondary index has its own provisioned throughput capacity, separate from that of its base table. 

#### Read More

- [Auto Scaling](https://aws.amazon.com/blogs/aws/new-auto-scaling-for-amazon-dynamodb/)
- [Managing Throughput Capacity with Auto Scaling](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/AutoScaling.html)
