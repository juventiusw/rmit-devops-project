terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3"
    }
  }
  backend "s3" {
    encrypt           = true
    dynamodb_endpoint = "https://dynamodb.us-east-1.amazonaws.com"
    region            = "us-east-1"
    key               = "assignment-2/infra-deployment"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_lb" "todo_app" {
  name               = "todo-app-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_az1.id, aws_subnet.public_az2.id, aws_subnet.public_az3.id]
  security_groups    = [aws_security_group.allow_http.id]

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "todo_app" {
  name     = "todo-app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.todo_app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.todo_app.arn
  }
}

resource "aws_security_group" "allow_http" {
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from internet"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

resource "aws_security_group" "web_security_group" {
  description = "Allow app and ssh inbound traffic"
  vpc_id      = aws_vpc.main.id

  // application port
  ingress {
    description = "application port"
    from_port   = 3000
    protocol    = "tcp"
    to_port     = 3000
    cidr_blocks = ["0.0.0.0/0"]
  }

  // HTTP port
  ingress {
    description = "HTTP from internet"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  // HTTPS port
  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  // SSH port
  ingress {
    description = "SSH from internet"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_security_group"
  }
}

resource "aws_security_group" "db_security_group" {
  description = "Allow db and ssh inbound traffic"
  vpc_id      = aws_vpc.main.id

  // database port (mongodb)
  ingress {
    from_port   = 27017
    protocol    = "tcp"
    to_port     = 27017
    cidr_blocks = ["0.0.0.0/0"]
  }

  // SSH port
  ingress {
    description = "SSH from internet"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db_security_group"
  }
}

// EC2 Instance for 'web'
resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux2.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_az1.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.web_security_group.id]
  count                       = 1

  tags = {
    Name = "web"
  }
}

// EC2 instance for 'db'
resource "aws_instance" "db" {
  ami                         = data.aws_ami.amazon_linux2.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.deployer.key_name
  subnet_id                   = aws_subnet.data_az1.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.db_security_group.id]
  count                       = 1

  tags = {
    Name = "db"
  }
}

// Data source for fetching the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}