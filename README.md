# Refactoring AWS Lambda Infrastructure into terraform modules starter

The starter repo for the tutorial on refactoring AWS Lambda infrastructure into terraform modules.

**By the end of this module, you should:**

- ✅ Have a better understanding of the benefit of using terraform modules

- ✅ Have a better understanding of the AWS Lambda terraform module we are using in the context of this project

<img src="https://www.jerrychang.ca/images/aws-lambda-terraform-module-visualization.png" alt="AWS lambda functions setup" style="width:100%">

## Getting started 

You have to run ` pnpm run generate-assets -r` to output the `main.zip`.

#### Upon generating the main.zip, run the terraform setup: 

```sh
export AWS_ACCESS_KEY_ID=<your-key>
export AWS_SECRET_ACCESS_KEY=<your-secret>
export AWS_DEFAULT_REGION=us-east-1

terraform init
terraform plan
terraform apply -auto-approve
```

## Interested in going through this tutorial ?

<img src="https://www.jerrychang.ca/images/og-image-tf-modules-refactor.png" alt="Simplify your AWS Lambda infrastructure in 9 steps" style="width:100%">

Read the tutorial here - [Simplify your AWS Infrastructure in 9 steps](https://www.jerrychang.ca/writing/simplify-your-aws-infrastructure-in-9-steps).
