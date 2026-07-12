# Scoped IAM credentials for ztls benchmark runs.
#
# This creates an IAM user with the minimum EC2 permissions that infra/bench/
# needs to provision and destroy its VPC/subnet/IGW/route-table/security-group/
# key-pair/instance resources. It does NOT grant access to IAM, S3, or any
# non-EC2 service. The user cannot escalate privileges.
#
# Setup (run with an account that has IAM access, e.g. the playground-ops
# profile):
#
#   AWS_PROFILE=playground-ops tofu -chdir=infra/iam init
#   AWS_PROFILE=playground-ops tofu -chdir=infra/iam apply
#   AWS_PROFILE=playground-ops infra/iam/write-credentials.sh
#
# That writes a [ztls-bench] profile to ~/.aws/credentials. Then run benchmarks
# with:
#
#   AWS_PROFILE=ztls-bench just bench-regression-check
#
# Teardown (revokes the credentials when no longer needed):
#
#   AWS_PROFILE=playground-ops tofu -chdir=infra/iam destroy

terraform {
  required_version = ">= 1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.49"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

locals {
  region = "us-west-2"
}

resource "aws_iam_user" "ztls_bench" {
  name = "ztls-bench"
  tags = { Name = "ztls-bench", Project = "ztls" }
}

# Minimum EC2 permissions for infra/bench/ provision + destroy. Scoped to EC2
# only — no IAM, no S3, no other services. Region is not condition-restricted
# because EC2 Describe actions are global and the bench infra is us-west-2-only
# by configuration (infra/bench/data.tf local.aws_region), not by IAM policy.
resource "aws_iam_user_policy" "ztls_bench_ec2" {
  name = "ztls-bench-ec2"
  user = aws_iam_user.ztls_bench.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "BenchEc2Describe"
        Effect = "Allow"
        # All read-only EC2 Describe/Get actions. The AWS provider calls many
        # of these (DescribeVpcAttribute, DescribeSubnetAttribute,
        # DescribeSecurityGroupRules, etc.) during resource management. Granting
        # them broadly avoids whack-a-mole; they are read-only and cannot modify
        # resources.
        Action = [
          "ec2:Describe*",
          "ec2:Get*",
        ]
        Resource = "*"
      },
      {
        Sid    = "BenchEc2Manage"
        Effect = "Allow"
        Action = [
          # VPC + networking
          "ec2:CreateVpc", "ec2:DeleteVpc",
          "ec2:CreateSubnet", "ec2:DeleteSubnet", "ec2:ModifySubnetAttribute",
          "ec2:CreateInternetGateway", "ec2:DeleteInternetGateway",
          "ec2:AttachInternetGateway", "ec2:DetachInternetGateway",
          "ec2:CreateRouteTable", "ec2:DeleteRouteTable",
          "ec2:AssociateRouteTable", "ec2:DisassociateRouteTable",
          "ec2:CreateRoute", "ec2:DeleteRoute",
          # Security groups
          "ec2:CreateSecurityGroup", "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress", "ec2:RevokeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress", "ec2:RevokeSecurityGroupEgress",
          # Key pairs
          "ec2:CreateKeyPair", "ec2:DeleteKeyPair", "ec2:ImportKeyPair",
          # Instances
          "ec2:RunInstances", "ec2:TerminateInstances",
          "ec2:StartInstances", "ec2:StopInstances",
          # Tags
          "ec2:CreateTags", "ec2:DeleteTags",
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_access_key" "ztls_bench" {
  user = aws_iam_user.ztls_bench.name
}

output "access_key_id" {
  description = "AWS access key ID for the ztls-bench IAM user"
  value       = aws_iam_access_key.ztls_bench.id
}

output "secret_access_key" {
  description = "AWS secret access key for the ztls-bench IAM user (sensitive)"
  value       = aws_iam_access_key.ztls_bench.secret
  sensitive   = true
}

output "region" {
  value = local.region
}
