# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "healthcare_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "healthcare-vpc"
  }
}

# Create Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.healthcare_vpc.id
  cidr_block             = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "healthcare-public-subnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "healthcare_igw" {
  vpc_id = aws_vpc.healthcare_vpc.id

  tags = {
    Name = "healthcare-igw"
  }
}

# Create Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.healthcare_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.healthcare_igw.id
  }

  tags = {
    Name = "healthcare-public-rt"
  }
}

# Associate Public Subnet with Route Table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Create Security Group
resource "aws_security_group" "healthcare_sg" {
  name        = "healthcare-all-traffic"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = aws_vpc.healthcare_vpc.id

  # Allow all inbound traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "healthcare-open-sg"
  }
}

# Create EC2 Instances
resource "aws_instance" "healthcare_servers" {
  count         = 3
  ami           = "ami-084568db4383264d4"  # Ubuntu 24 AMI
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.healthcare_sg.id]

  root_block_device {
    volume_size = count.index == 1 ? 30 : 20  # 30GB for worker node 1, 20GB for others
  }

  tags = {
    Name = count.index == 0 ? "healthcare-master" : "healthcare-worker-${count.index}"
    Role = count.index == 0 ? "master" : "worker"
  }
}
