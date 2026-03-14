provider "aws" {
  region = "ap-southeast-1"
}

# Security Group for Jenkins
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow SSH and Jenkins"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
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

# IAM Instance Profile (attach existing SSM role)
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm-instance-profile"
  role = "ssm"
}

# Jenkins EC2 Instance
resource "aws_instance" "jenkins_server" {
  ami           = "ami-0df7a207adb9748c7" # Amazon Linux 2023
  instance_type = "t3.micro"

  key_name = "newec2-publickey"

  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  vpc_security_group_ids = [
    aws_security_group.jenkins_sg.id
  ]

  tags = {
    Name = "jenkins-server"
  }
}

# Output public IP
output "jenkins_public_ip" {
  value = aws_instance.jenkins_server.public_ip
}