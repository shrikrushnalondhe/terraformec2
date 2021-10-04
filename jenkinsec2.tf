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
    type ="terraform-test-security-group21"
  }
}

resource "aws_instance" "dockerec2" {
  ami = "ami-0a23ccb2cdd9286bb"
  instance_type = "t2.micro"
  key_name= "aws_key"
  security_groups = [aws_security_group.ec2docker-sg.name]
  tags = {
    Name = "dockerec2"
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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCl4Kna3RpqRfVZiLXZIYWQYC5k5XLCLKKHWNRsGtA1KbqFT9hJm3BDO85PbJM6XUH1xtL9b+nI8Tsh93hOr40LDS1bEN7gra549/9LKLU3RNHwe3eZaaRUY/pXC47ZomA6Btom8i5avAownAzVDlQTNQykxvLel5iEOaZ4N2tLDWWYoOhcaIokDFZCbCrLQB68xjIzefM5A19homM9PRda50rEa55EpNkjaEY6TIVOiisPfqIc8HOT8fmmV1YVKvGYjqKBfQpxCG2w2UKMTgOuMRVlOkWHtD5GTTVuyz5/i8fOn56OEtQVL4VQntpLXUhtRvKgDNGgQjkxXJb3Bpsr root@ip-172-31-13-174.ap-south-1.compute.internal"
}
output "instance_ips" {
  value = aws_instance.dockerec2.public_ip
}
