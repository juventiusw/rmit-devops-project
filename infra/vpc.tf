resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "RMIT Assignment 2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "RMIT Assignment 2"
  }
}

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "RMIT Assignment 2 default table"
  }

}

resource "aws_subnet" "public_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/22"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public AZ1"
  }
}

resource "aws_subnet" "private_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.16.0/22"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private AZ1"
  }
}

resource "aws_subnet" "data_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/22"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Data AZ1"
  }
}

resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/22"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public AZ2"
  }
}

resource "aws_subnet" "private_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.20.0/22"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private AZ2"
  }
}

resource "aws_subnet" "data_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.36.0/22"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Data AZ2"
  }
}

resource "aws_subnet" "public_az3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.8.0/22"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public AZ3"
  }
}

resource "aws_subnet" "private_az3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.24.0/22"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private AZ3"
  }
}

resource "aws_subnet" "data_az3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.40.0/22"
  availability_zone = "us-east-1c"

  tags = {
    Name = "Data AZ3"
  }
}