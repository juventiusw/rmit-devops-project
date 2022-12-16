#!/bin/bash
set +ex

echo -n "bucket = " > ../infra/terraform.tfvars
terraform output state_bucket_name >> ../infra/terraform.tfvars
echo
echo -n "dynamodb_table = " >> ../infra/terraform.tfvars
terraform output dynamoDb_lock_table_name >> ../infra/terraform.tfvars