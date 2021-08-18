# IAM

An AWS account has two types of users, root user and IAM user. And they are belong to the same AWS account. When we login onto AWS management console, both root user and IAM user share the same account ID.

## IAM user policies

IAM user policies are identity-based policies that control an IAM user's access to account resources, such as a S3 bucket.

- `Action` element refers to the kind of action requested (list, create, etc.);
- `Resource` element refers to the particular AWS **account resource** that’s the target of the policy;
- `Effect` element refers to the way IAM should react to a request.

The user policy example below allows an IAM user to upload and read objects in `awsexamplebucket` S3 bucket.

```json
{
  "Version":"2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action":[
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Resource":"arn:aws:s3:::awsexamplebucket/*"
    }
  ]
}
```
Read more at 
[https://docs.aws.amazon.com/AmazonS3/latest/userguide/user-policies.htm](https://docs.aws.amazon.com/AmazonS3/latest/userguide/user-policies.html)

### Permission Bundaries

You may create the following policy that allows all actions for the EC2 service and then attach that policy to an IAM user as a permissions boundary:

```json
{
  "Version": "2012-10-17",
  "Statement": [
     {
       "Effect": "Allow",
       "Action": ["ec2.*"], 
       "Resource": "*"
     }
  ]
}  
```
If you then attach the `AdministratorAccess` policy which grants full access to all AWS services—to the user, the user will still only be able to perform actions in EC2.
The permissions boundary limits the user to performing only those actions laid out in the permissions boundary policy. 

## Bucket policies

Bucket policies are resource-based policies.

If an AWS account that **owns a bucket** wants to grant permission to **users in its account**, it can use either a bucket policy or a user policy.

However, if we want manage cross-account access to a bucket, then we have to use bucket policies.

For instance, we can use the bucket policy below to grant permissions to other AWS accounts, `AccountB` to upload objects to the bucket `awsexamplebucket` that we own.

```json
{
  "Version":"2012-10-17",
  "Statement": [
    {
      "Sid":"AddCannedAcl",
      "Effect":"Allow",
      "Principal": {"AWS": "arn:aws:iam::AccountB-ID:user/Dave"},
      "Action": ["s3:PutObject","s3:PutObjectAcl"],
      "Resource": "arn:aws:s3:::awsexamplebucket/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
         }
       }
     }
   ]
}
```

The `Condition` in the example makes sure that the owner of the bucket, `AccountA` has full control over the uploaded objects. Read more at [https://docs.aws.amazon.com/AmazonS3/latest/userguide/amazon-s3-policy-keys.html](https://docs.aws.amazon.com/AmazonS3/latest/userguide/amazon-s3-policy-keys.html)

After we add this bucket policy, user Dave must include the required ACL as part of the request:

```bash
aws s3 cp example.jpg s3://awsexamplebucket --acl bucket-owner-full-control
```

Read more about [s3-require-object-ownership](https://aws.amazon.com/premiumsupport/knowledge-center/s3-require-object-ownership/)

This example is about cross-account permission. However, if Dave (who is getting the permission) belongs to the AWS account that owns the bucket, this conditional permission is not necessary. This is because the parent account to which Dave belongs owns objects that the user uploads. 

Read more about bucket policies at 
[https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-policies.html](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-policies.html)

## Object ACL and Bucket ACL

Read more at [https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-policy-alternatives-guidelines.html](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-policy-alternatives-guidelines.html)

## Other Resource-based Polices

- `S3` offers optional bucket policies that control access to objects or entire buckets. 
- `Key Management Service` (KMS) requires you to define a key policy to specify the administrators and users of a key.
- `SNS` topics have resource policies to control who can publish messages or subscribe to a topic, as well as which delivery protocols they can use.
- `Simple Queue Service` (SQS) queues also use resource-based SQS access policies to control who can send to and receive messages from a queue.
