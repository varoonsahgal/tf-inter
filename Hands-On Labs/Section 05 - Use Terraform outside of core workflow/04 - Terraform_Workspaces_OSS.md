# Lab: Terraform Workspaces - OSS

Those who adopt Terraform typically want to leverage the principles of DRY (Don't Repeat Yourself) development practices. One way to adopt this principle with respect to IaC is to utilize the same code base for different environments (development, quality, production, etc.)

Workspaces is a Terraform feature that allows us to organize infrastructure by environments and variables in a single directory.

Terraform is based on a stateful architecture and therefore stores state about your managed infrastructure and configuration. This state is used by Terraform to map real world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures.

The persistent data stored in the state belongs to a Terraform workspace. Initially the backend has only one workspace, called "default", and thus there is only one Terraform state associated with that configuration.

- Task 1: Using Terraform Workspaces (Open Source)
- Task 2: Create a new Terraform Workspace for Development State
- Task 3: Deploy Infrastructure within the Terraform development workspace
- Task 4: Changing between Workspaces
- Task 5: Utilizing the ${terraform.workspace} interpolation sequence within your configuration


# Exercise: Managing Multiple Environments with Terraform Workspaces

**Objective**: Create a basic infrastructure (an AWS S3 bucket) and manage separate environments (`development` and `production`) using Terraform workspaces.

## Step-by-Step Guide

### 1. Create a New Terraform Configuration Directory

Create a new directory for your exercise and navigate into it.

```bash
mkdir terraform-workspace-demo
cd terraform-workspace-demo
```

### 2. Create a Terraform Configuration File

Create a file named `main.tf` with the following content. This configuration creates an AWS S3 bucket with a name that includes the current workspace name.

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.4.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-bucket-${terraform.workspace}"
  acl    = "private"
}

output "bucket_name" {
  value = aws_s3_bucket.example.bucket
}
```

The S3 bucket's name includes `${terraform.workspace}`, which appends the workspace name to the bucket. This ensures that each workspace creates a unique bucket.

### 3. Initialize Terraform

Initialize your Terraform working directory. This downloads the required provider plugins and sets up the project.

```bash
terraform init
```

### 4. Create and Use the Default Workspace (`default`)

By default, Terraform uses the `default` workspace. Let’s first see what happens in the default workspace.

```bash
terraform apply
```

This will create an S3 bucket named `my-tf-bucket-default`.

### 5. Create a New Workspace for `development`

Create a new workspace named `development`.

```bash
terraform workspace new development
```

This command creates a new workspace and switches to it.

### 6. Apply Changes in the `development` Workspace

Now, apply the configuration again. This will create a new S3 bucket specific to the `development` environment.

```bash
terraform apply
```

Terraform will create a bucket named `my-tf-bucket-development`.

### 7. Create and Switch to the `production` Workspace

Create another workspace named `production` for the production environment.

```bash
terraform workspace new production
```

You are now in the `production` workspace.

### 8. Apply Changes in the `production` Workspace

Apply the configuration in the `production` workspace.

```bash
terraform apply
```

Terraform will create a bucket named `my-tf-bucket-production`.

### 9. List All Workspaces

To see all created workspaces, use:

```bash
terraform workspace list
```

This will show `default`, `development`, and `production`, with the current workspace marked with an asterisk (`*`).

### 10. Cleanup

To clean up, switch to each workspace and destroy the resources:

```bash
terraform workspace select development
terraform destroy

terraform workspace select production
terraform destroy

terraform workspace select default
terraform destroy
```

Finally, delete the workspaces:

```bash
terraform workspace delete development
terraform workspace delete production
```

## Key Takeaways

- **Separate State Files**: Each workspace manages its own state file, allowing you to manage resources independently for different environments.
- **Environment Isolation**: By using workspaces, you can isolate environments (`development`, `production`) within the same Terraform configuration.
- **Consistent Configuration**: You maintain the same infrastructure code while deploying to different environments, reducing duplication and errors.


## Reference

[Terraform Workflow](https://www.terraform.io/docs/cloud/guides/recommended-practices/part1.html)
