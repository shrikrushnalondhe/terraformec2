provider "aws" {
  region     = "ap-south-1"
}
resource "aws_security_group" "ec2web2-sg" {
  name = "ec2web2-sg"
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

  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "all"
   cidr_blocks = ["0.0.0.0/0"]
  }

  tags ={
    type ="terraform-test-security-group2"
  }
}

resource "aws_instance" "web2" {
  ami = "ami-04db49c0fb2215364"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.ec2web2-sg.name]
  tags = {
    Name = "web2"
  }
}
