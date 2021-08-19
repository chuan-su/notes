# AWS KMS

## Data Encryption

### With Data Keys

*Data keys* are encryption keys that you can use to encrypt data.

You can generate a data key from a AWS KMS (Customer Master Key), which returns a `Plaintext data key` and `Encrypted Data key`. 

AWS KMS cannot use a data key to encrypt data and can only use a data key to decrypt data.

You can use the `Plaintext data key` to encrypt data. But remove it from memory as soon as possible.

To decrypt your data, pass the `encrypted data key` to the `Decrypt` operation.

AWS KMS uses your CMK to decrypt the data key and then it returns the plaintext data key. Use the plaintext data key to decrypt your data and then remove the plaintext data key from memory as soon as possible. 

### With Data Key Pairs

You can generate a data key pair from a AWS KMS, which returns a `Public key`, `Plaintext private key` and `Encrypted data key`.

When you encrypt with a data key pair, you use the `public key` of the pair to `encrypt` the data and the `plaintext private key` of the same pair to `decrypt` the data.

If you only have the `Encrypted private key`, you need to decrypt the encrypted private key first byby passing it to the `Decrypt` operation. Then, use the `plaintext private key` to decrypt the data.Remeber to remove the plaintext private key from memory as soon as possible. 

Typically, data key pairs are used when many parties need to encrypt data that only the party that holds the private key can decrypt. 

## Message Sign and Signature

To generate a cryptographic signature for a message, use the `private plaintext key` in the data key pair. Anyone with the `public key` can use it to verify that the message was signed with your private key and that it has not changed since it was signed. 

If you only have the `Encrypted private key`, you need to decrypt the encrypted private key first byby passing it to the `Decrypt` operation. AWS KMS uses your CMK to decrypt the data key and then it returns the plaintext private key. Use the `plaintext private key` to generate the signature. Then remove the plaintext private key from memory as soon as possible. 

## Key Policies

Every customer master key (CMK) must have `exactly one` key policy. This key policy controls access only to its associated CMK, along with IAM policies and grants. Unlike IAM policies, which are global, key policies are `Regional`. Each key policy is effective only in the Region that hosts the CMK. 

 This default key policy has one policy statement that gives the AWS account (root user) that owns the CMK full access to the CMK and enables IAM policies in the account to allow access to the CMK.

### Key Users

- Use the CMS Directly

```json
{
  action": [
    "kms:Encrypt",
    "kms:Decrypt",
    "kms:ReEncrypt",
    "kms:GenerateDataKey",
    "kms:DescribeKey"
  ]
}
```

- Use the CMK with AWS Services through `grant`:

```json
{
  action": [
    "kms:CreateGrant",
    "kms:ListGrants",
    "kms:RevokeGrant"
  ]
}
```

### Key Administrator

Key administrators have permissions to manage the CMK, but do not have permissions to use the CMK in cryptographic operations. 

## Reference

- [AWS Key Management Service](https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html)
