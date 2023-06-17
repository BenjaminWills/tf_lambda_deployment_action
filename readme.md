# Terraform X Github action

- [Terraform X Github action](#terraform-x-github-action)
  - [What does it do?](#what-does-it-do)
  - [How does it work?](#how-does-it-work)
    - [Defining secrets](#defining-secrets)
    - [The action](#the-action)
      - [Checkout](#checkout)
      - [Python](#python)
      - [AWS access](#aws-access)
      - [Terraform](#terraform)


This is a project exploring the use case of terraform within a github action. 

Github actions now come with `terraform` installed.

## What does it do?

Upon pushing to main, the `lambda_payload` file is zipped and then a lambda function is created on aws as well as a bucket with file notifications enabled.

## How does it work?

### Defining secrets

First we define the following secrets:

- `MY_GITHUB_TOKEN` - github token
- `AWS_ACCESS_KEY_ID` - AWS access key
- `AWS_SECRET_ACCESS_KEY` - AWS secret access key
- `TERRAFORM_DIRECTORY` - Directory that terraform file exists in

Using the github secret manager so that we can reference them in the github action and authenticate the `vm` that powers the action.

### The action

#### Checkout

We begin by `checking out`, which clones all the files from within the repository into the `vm` controlling the action.

#### Python

Next we need to set up `python` so that we can zip the lambda payload file, so we use the `setup-python` action. Then we run the zipper - I could make this into a command line function in the future.

#### AWS access

Next we use the `aws-actions/configure-aws-credentials` action to connect to `AWS` this is dependent on the declaration of the env variables:

```yml
AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY }}
AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

#### Terraform

Next we begin with terraform first stating the version, then we initialise and validate the terraform. Note that we have a remote backend - so that we can take down the infrastructure if the action fails. Then we run terraform apply to deploy these resources (and then immediately destroy them for testing).
