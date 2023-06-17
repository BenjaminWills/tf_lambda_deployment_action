# File notification lambda

In this project I have made a terraform configuration that will deploy a lambda function that is triggered by putting files into an S3 bucket.

## Running instructions

Ensure that you have filled in the keys in `aws_credentials.tf` and that you've configured the `variables.tf` file.

The `lambda_payload.zip` file is a zipped directory containing code files that will be placed into the lambda function, change this as you see fit.

First `initialise` the project by running:

```shell
terraform init
```

Then run:

```shell
terraform plan
terraform apply
```

And your resources should be up and running.
