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
  key_name= "aws_key"
  security_groups = [aws_security_group.ec2web2-sg.name]
  tags = {
    Name = "web2"
  }
  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "jenkins"
      private_key = file("/home/jenkins/keys/aws_key")
      timeout     = "4m"
   }
}

resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7sdlkeQmUlFovLFrPGJuL+DyqcZzlqmtdCFY390lUjTvSqUVqLpgeJ0xFg+d8RD6LU+lPnv1rEBED4ax2FcCgumSmw1LYj+xEOQik+MxeJed1oRX2sHgMRy2IloFnyg+g6oBt8q30AhVy4eN+3qykhDQxYflpi3enVJgu5oD5hBJlfrLtj7Zr6hDlWQnCFkJ6PvwijhVYC6Sr3UIdMP9bA9DLxrkxkUHR/gzbFqdO3iWtDAgODG/gKRB8zhPl093dXGeZx85aG0sjCYt4UUqRdXV6EtDJPMxwN6NPP8uWbbCsz5tH0q1AcJwyVlvr5QfmgrF9Zx2zxC5Ts21lu3CX jenkins@ip-172-31-39-222.ap-south-1.compute.internal"
}
output "instance_ips" {
  value = aws_instance.web2.public_ip
}
