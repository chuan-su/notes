# IAM

## IAM Policies

- `Action` element refers to the kind of action requested (list, create, etc.);
- `Resource` element refers to the particular AWS **account resource** that’s the target of the policy;
- `Effect` element refers to the way IAM should react to a request.

## IAM Roles

An IAM role is not assigned to a user (by an admin). Rather, the IAM user assumes the role created by the admin.
Therefore, the admin needs to ensure that the user (trusted entity) has the permission to perform the `sts:AssumeRole` operation (action).

To provide such a permission, the admin needs to create an `IAM Policy` and attach it to the user or group.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::<admin_account-id>:role/*" // any roles in this account
        }
    ]
}
```

With this IAM policy attached to the user, the user is now able to **perform** the `sts:AssumeRole` operationa. However, this does not mean that the user will get the role.

It is like 

```
You are now allowed to ask questions, but you may or may not get an answer".
```

Whether you will get the answer or not is determined by the `Trusted entity` which is covered below.

### Create the role

Next, we can create the IAM role.

An IAM Role consists of the following core elements:

- **Permission**
	  specifies what account resources can be accessed and what actions can be taken, which is exactly what the IAM Policy does. For instance: adding `AmazonS3FullAccess` to the role permissions will allow the user who has successfully assumed this role to have full access to `S3`.

- **Trusted Entity**
	  specifies what entitiy can assume **this role** (Don't be confused with the IAM Policy `sts:AssumeRole` action above).
 
	```json
	{
	  "Version": "2012-10-17",
	  "Statement": [
	    {
	      "Effect": "Allow",
	      "Principal": {
			"AWS": "arn:aws:iam::<user_account-id>:root" // the user who performs the AssumeRole action
	      },
	      "Action": "sts:AssumeRole",
	      "Condition": {}
	    }
	  ]
	}
	```

### Assume the role

Before we assume the role, let's first verify that we don't have access to `S3`.

```bash
aws s3 ls
```

Next, let's assume the role `s3fullaccess-user1` created above.

One way is to add a `profile` to `~/.aws/config`, as shown below.
For simplicity, we use the role name `s3fullaccess-user1` as the `[profile_name]`.

```
[s3fullaccess-user1]
role_arn=arn:aws:iam::<admin_account-id>:role/s3fullaccess-user1
source_profile=account1
```

Now if we invoke the command with the `s3fullaccess-user1` profile, we will be able to list the buckets in `S3`.

```bash
aws s3 ls --profile s3fullaccess-user1
```

Read more about the how to config `awscli` to use an IAM role [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html).

Anothe way to consume the IAM role is to use `awscli`:

```bash
aws sts assume-role --role-arn "arn:aws:iam::<admin_account-id>:role/s3fullaccess-user1" --role-session-name AWSCLI-Session
```

A full example for assuming IAM role using `awscli` is [here](https://aws.amazon.com/premiumsupport/knowledge-center/iam-assume-role-cli/)
