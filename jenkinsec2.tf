provider "aws" {
  region     = "ap-south-1"
}
resource "aws_security_group" "ec21docker-sg" {
  name = "ec21docker-sg"
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
   from_port   = 3000
   to_port     = 3000
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
   from_port   = 8080
   to_port     = 8080
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
   from_port   = 8081
   to_port     = 8081
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
    type ="terraform-test-security-group21"
  }
}

resource "aws_instance" "dockerec21" {
  ami = "ami-0a23ccb2cdd9286bb"
  instance_type = "t2.medium"
  key_name= "aws_key1"
  security_groups = [aws_security_group.ec21docker-sg.name]
  tags = {
    Name = "dockerec21"
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
  key_name   = "aws_key1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdnfYe7KDxdXvc3FetMhpUhRuv/Ff275RmhDpNSswwyXbrY3fzmv7E+3OGr9eP+T244b1ZOUN9buWnlbnTKGqcZMqIYpJnXbXJ1pHNBDlhrHSRnd2+YoFEwt2F+jIyAPPo0LZ1DwaVavYtbmtOag/EAtXDTlgkq8kWoK1c4Uq3M6OGCVLiPEyKeGq8KTV4VvV/w+nq4o8298wmh5ExAm02IJY3jYLHsmk9dbVu6qsFkJLUFBPHjnHtTWZLJ2z/WN429Zjdy6MQJi9DkyPsID4yKVJWGPXOU8IiIrQDQ62hL8uRx7i7xfYcc1cBOaWkaaQXNWDRGGwEK99Zq0hlWWXT jenkins@ip-172-31-3-249.ap-south-1.compute.internal"
}
output "instance_ips" {
  value = aws_instance.dockerec21.public_ip
}
