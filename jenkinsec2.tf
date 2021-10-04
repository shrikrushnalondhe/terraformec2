provider "aws" {
  region     = "ap-south-1"
}
resource "aws_security_group" "ec2docker-sg" {
  name = "ec2docker-sg"
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
   from_port   = 8080
   to_port     = 8080
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

resource "aws_instance" "dockerec21" {
  ami = "ami-04db49c0fb2215364"
  instance_type = "t2.micro"
  key_name= "aws_key"
  security_groups = [aws_security_group.ec2docker-sg.name]
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
  key_name   = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5fmqkSwm2QrQjZ49LxlnpASPxGJnPW0IJ0BIkhakO77zDV3R6BZFNn5rpNUijl3SCIVRdl2oh8lta66KdVNFAxskntohO/xrflEjD7ki0vy/ogldwK/Te9MvtMhtmZgbHGXCscsCaCmDL6eH3F4CNnZVX0/fhsRl1BnRgrGfH3m2JxvJrqqn/o46HmJMNRKFs1WIP0US9V2lcKJdQ0Qyx7pEn17uHTGgDADElE9ZjY/Wx+mzQwGBdN5xPN3vS++/+rLe/uMNVNATUtzBmMxkLLB1avCZrtBLM8Uib7/XjX0TVfPDuPlwAdH+K1bskrj/WFKA0kA4uY1Th0XgmQip5 root@ip-172-31-11-83.ap-south-1.compute.internal"
}
output "instance_ips" {
  value = aws_instance.dockerec21.public_ip
}
