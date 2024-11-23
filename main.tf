# Define the AWS provider
provider "aws" {
  region = "us-east-1" # Change to your desired region
}

# Define a key pair (replace with your key pair name or create a new one)
resource "aws_key_pair" "my_key" {
  key_name   = "my-key-pair"
  public_key = file("~/.ssh/id_rsa.pub") # Replace with your public key file
}

# Define a security group to allow SSH and HTTP access
resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg-"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
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

# Create an EC2 instance
resource "aws_instance" "web_server" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI (replace with your AMI)
  instance_type = "t2.micro"

  key_name               = aws_key_pair.my_key.key_name
  security_groups        = [aws_security_group.web_sg.name]
  associate_public_ip_address = true

  tags = {
    Name = "MyWebServer"
  }
}

# Output the instance's public IP
output "instance_public_ip" {
  value = aws_instance.web_server.public_ip
}
