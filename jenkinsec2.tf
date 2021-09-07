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
  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "jenkins"
      private_key = file("/home/jenkins/aws_key")
      timeout     = "4m"
   }
}

resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxl0BZRxinbQQm45+pKn47SWDYKjCvP0TTslq8E7vL2uZ/VEC0hm4c4Fe6+qMJhl8tg2tt5JNG6PY0d1yWgZMu47QpVciYfYNJLSvGGlXknFVU6FXlNRQEmuZqNWqemJZq5qEHsUGjwwoS2wqL9Z3kih0QdnxhjFpWJYVvc85mpN7sqqLAeawNEY2v31n/AuVvJ785/BaxWsvAaFTBa0U0R5I/asurhgphuHovcTCP7I335t4FF1UhS0OHFJQi2CxUxuKq/8KE6QHTZ27+YSNZ092BMOHWGehhFwvzBYIkHTszjMS8eEmuIekia4DJoyJ/luMLQ+KhxPGWhYQlXohL jenkins@ip-172-31-36-82.ap-south-1.compute.internal"
}
