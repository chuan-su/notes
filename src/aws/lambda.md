# Lambda

First of all, we need to distinguish between `Lambda` and `Lambda functions`. Lambda is AWS service that invokes your `Lambda functions`.

## Lambda functions invocation

A Lambda function can be either invoked synchrously or asynchronously. Based on the invocation type, the retry and error handling mechanism differs.

### Synchronous invocation

When a function is invoked synchronously, Lambda runs the function and waits for a response.

Services that Invoke Lambda Functions Synchronously:

- ALB
- API Gateway
- CloudFront (Lambda@Edge)
- Step Functions

There is no automatic retry for the failed lambda functions except the functions that are invoked of [Even source mapping](https://docs.aws.amazon.com/lambda/latest/dg/invocation-eventsourcemapping.html).

#### Polling & Synchronous processing (Even source mapping)  

Services that Lambda reads (poll) events from:

- DynamoDB
- [Kinesis](https://docs.aws.amazon.com/lambda/latest/dg/with-kinesis.html)
- [Amazon SQS](https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html)
- Amazon MQ
- Apache Kafka

Lambda polls the queue or stream and invokes your Lambda function **synchronously** with an event that contains queue messages. 

Lambda reads messages in batches and invokes your function once for each batch. When your function successfully processes a batch, Lambda deletes its messages from the queue. The `batch size` and `batch window` are configured inLambda `triggers`. 

By default, if your function returns an error, the entire batch is reprocessed until the function succeeds, or **the items in the batch expire**.

For `Kinesis data stream`, you can either configure a failed destination in the Lambda [triggers](https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-concepts.html) or specify a destination in `Destination Configuration`.

##### Destination Configuration (Kinesis & DynamoDB Stream)

- SQS queue
- SNS topic
- Lambda function
- EventBridge eventbug

For trigger a lambda function from a SQS queue, you can configure a DLQ for the failed items. Note, the DQL has to be configured in the source SQS queue.

```
“Make sure that you configure the dead-letter queue on the source queue, not on the Lambda function. The dead-letter queue that you configure on a function is used for the function’s asynchronous invocation queue, not for event source queues.“
```

### Asynchronous invocation

Services that invoke Lambda Functions Asynchronously:

- S3
- SNS
- CloudWath Logs
- CloudWath Events
- AWS Config
- CloudFormation
- AWS CodeCommit
- AWS CodePiplines

##### Asynchronous configuration

- Maximum age of event (60 seconds to 6 hours).
- Retry attempts (from 0 to 2)

If the event exceeds the maximum `age of event` or `retry attemps`, you can configure either a DLQ or a Destination to save the failed events. Otherwise the events are discarded.

###### Destination configuration

![lambda destinations](../img/aws-lambda-destinations.png)

###### DLQ

- SQS queue
- SNS topic

### Cloud Watch Event
[Simply Serverless: Use constant values in Cloudwatch event triggered Lambda functions](https://aws.amazon.com/blogs/compute/simply-serverless-use-constant-values-in-cloudwatch-event-triggered-lambda-functions/)

## VPC

[How do I give internet access to a Lambda function that's connected to an Amazon VPC?](https://aws.amazon.com/premiumsupport/knowledge-center/internet-access-lambda-function/)

### Read More

- [Invoking AWS Lambda functions](https://docs.aws.amazon.com/lambda/latest/dg/lambda-invocation.html)
- [Introducing AWS Lambda Destinations](https://aws.amazon.com/blogs/compute/introducing-aws-lambda-destinations/)
- [https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html](https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html)
- [Lessons learned from combining SQS and Lambda](https://data.solita.fi/lessons-learned-from-combining-sqs-and-lambda-in-a-data-project/)

