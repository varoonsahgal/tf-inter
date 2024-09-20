# Lab: Terraform Workspaces - OSS

Those who adopt Terraform typically want to leverage the principles of DRY (Don't Repeat Yourself) development practices. One way to adopt this principle with respect to IaC is to utilize the same code base for different environments (development, quality, production, etc.)

Workspaces is a Terraform feature that allows us to organize infrastructure by environments and variables in a single directory.

Terraform is based on a stateful architecture and therefore stores state about your managed infrastructure and configuration. This state is used by Terraform to map real world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures.

The persistent data stored in the state belongs to a Terraform workspace. Initially the backend has only one workspace, called "default", and thus there is only one Terraform state associated with that configuration.


# Exercise: Managing Multiple Environments with Terraform Workspaces

**Objective**: Create a basic infrastructure (an AWS S3 bucket) and manage separate environments (`development` and `production`) using Terraform workspaces.

## Step-by-Step Guide


### 1. Modify the Terraform Configuration File

First, view the current workspace:

```
terraform workspace show
```

You should see default.

Now, add this to your `main.tf` to create an AWS S3 bucket with a name that includes the current workspace name.

Also, append your name to the bucket to ensure uniqueness as S3 bucket names must be globally unique and get rid of the `<` and `>`.

```hcl
resource "aws_s3_bucket" "example" {
  bucket = "my-tf-bucket-${terraform.workspace}-<add-your-name>"
  acl    = "private"
}

output "bucket_name" {
  value = aws_s3_bucket.example.bucket
}
```

The S3 bucket's name includes `${terraform.workspace}`, which appends the workspace name to the bucket. 


### 2. Create and Use the Default Workspace (`default`)

By default, Terraform uses the `default` workspace. Let’s first see what happens in the default workspace.

```bash
terraform apply
```

This will create an S3 bucket named `my-tf-bucket-default-<yourname>`.

### 3. Create a New Workspace for `development`

Create a new workspace named `development`.

```bash
terraform workspace new development
```

This command creates a new workspace and switches to it.

### 4. Apply Changes in the `development` Workspace

Now, apply the configuration again. This will create a new S3 bucket specific to the `development` environment.

```bash
terraform apply
```

Terraform will create a bucket named `my-tf-bucket-development`.

### 5. Create and Switch to the `production` Workspace

Create another workspace named `production` for the production environment.

```bash
terraform workspace new production
```

You are now in the `production` workspace.

### 6. Apply Changes in the `production` Workspace

Apply the configuration in the `production` workspace.

```bash
terraform apply
```

Terraform will create a bucket named `my-tf-bucket-production`.

### 7. List All Workspaces

To see all created workspaces, use:

```bash
terraform workspace list
```

This will show `default`, `development`, and `production`, with the current workspace marked with an asterisk (`*`).

### 8. Cleanup

To clean up, switch to each workspace and destroy the resources:

```bash
terraform workspace select development
terraform destroy

terraform workspace select production
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
- - **Same Lock file**: You should notice that there is only one lock file that stays the same across workspaces.


## Reference

[Terraform Workflow](https://www.terraform.io/docs/cloud/guides/recommended-practices/part1.html)
