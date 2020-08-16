provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_vpc" "main" {
  cidr_block           = "10.95.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_security_group" "exposed" {
  name   = "exposed"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds-exposed" {
  name   = "rds-exposed"
  vpc_id = aws_vpc.main.id

  # Pool postgres
  ingress {
    from_port   = 54322
    to_port     = 54322
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 54323
    to_port     = 54323
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Pool Maria
  ingress {
    from_port   = 33066
    to_port     = 33066
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 33067
    to_port     = 33067
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Nats
  ingress {
    from_port   = 14222
    to_port     = 14222
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 18222
    to_port     = 18222
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}