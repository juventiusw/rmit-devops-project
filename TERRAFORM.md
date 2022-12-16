
## Terraform

### Connect To AWS

Follow the steps given in LAB6 to start an AWS instance and update your `~/.aws/credentials` file.

Your session will expire every 4 hours, after which you will need to again update your credentials file.

### Initalising your TF Repo

To initialise your terraform repo, run the following command from your root directory

```
make infra-init
```

### Create an ec2 key-pair

To create a key-pair that will be used to ssh into your ec2 instances, run the following command from the root directory. You only need to run this once.

```
make ssh-gen
```

### Validate your TF Code

To validate & format your terraform repo, run the following command from your root directory

```
make infra-validate
```

### View an execution plan

To create an execution plan and view the changes your terraform template will create, run the following

```
make infra-plan
```

To show the plan, then apply, run the following

```
make infra-apply
```

### To instantiate and destroy your TF Infra:

To instantiate your infra in AWS, execute the following command from the root directory:

```
make infra-up
```

To destroy the infra already deployed in AWS, ensure your AWS Programmatic credentials are set and execute the following command from the root directory:

```
make infra-down
```



###### This project is licensed under the MIT Open Source License
