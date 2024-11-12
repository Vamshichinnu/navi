provider "aws" {
  region = "us-west-2"
}

variable "instance_type" {}
variable "pg_version" {}
variable "max_connections" {}
variable "shared_buffers" {}
variable "num_replicas" {}

resource "aws_security_group" "pg_sg" {
  name = "pg-sg"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "primary" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
  security_groups = [aws_security_group.pg_sg.name]
  tags = {
    Name = "pg-primary"
  }
}

resource "aws_instance" "replica" {
  count         = var.num_replicas
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
  security_groups = [aws_security_group.pg_sg.name]
  tags = {
    Name = "pg-replica-${count.index + 1}"
  }
}
