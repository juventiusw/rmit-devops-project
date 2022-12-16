terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}

resource "random_string" "tfstatename" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket" "tfrmstate" {
  bucket        = "rmit-tfstate-${random_string.tfstatename.result}"
  force_destroy = true

  tags = {
    Name = "TF remote state"
  }
}

resource "aws_s3_bucket_acl" "tfrmstate_acl" {
  bucket = aws_s3_bucket.tfrmstate.id
  acl    = "private"
}

resource "aws_dynamodb_table" "terraform_statelock" {
  name           = "rmit-locktable-${random_string.tfstatename.result}"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_docdb_cluster_parameter_group" "tlsdisable" {
  family      = "docdb4.0"
  name        = "tls-disable"
  description = "docdb cluster parameter group dissable tls"

  parameter {
    name  = "tls"
    value = "disabled"
  }
}

output "aws_docdb_cluster_paramater_group_id" {
  value = aws_docdb_cluster_parameter_group.tlsdisable.id
}

output "state_bucket_name" {
  value = aws_s3_bucket.tfrmstate.bucket
}

output "dynamoDb_lock_table_name" {
  value = aws_dynamodb_table.terraform_statelock.name
}
