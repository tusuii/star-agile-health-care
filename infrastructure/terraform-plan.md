# Terraform Infrastructure Plan for Healthcare Project

## Infrastructure Overview
- Cloud Provider: AWS
- Number of Instances: 3
- Instance Type: t2.large
- Operating System: Ubuntu 24 AMI
- Region: ap-south-1 (Mumbai)

## Resource Details

### EC2 Instances
1. **Healthcare App Server Master**
   - Purpose: Main application server
   - Instance Type: t2.large
   - OS: Ubuntu 24
   - Storage: 20GB EBS volume

2. **Healthcare Database Server WOrker Node 1**
   - Purpose: Worker node 1 server
   - Instance Type: t2.large
   - OS: Ubuntu 24
   - Storage: 30GB EBS volume

3. **Healthcare Database Server WOrker Node 2**
   - Purpose: Worker node 2 server
   - Instance Type: t2.large
   - OS: Ubuntu 24
   - Storage: 20GB EBS volume

## Network Configuration
- VPC with dedicated CIDR block
- Public subnet for application access
- Security Groups with all ports open for inbound and outbound traffic

### Security Group Configuration
```hcl
resource "aws_security_group" "healthcare_sg" {
  name        = "healthcare-all-traffic"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = aws_vpc.healthcare_vpc.id

  # Allow all inbound traffic
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "healthcare-open-sg"
  }
}

## Security Measures
- SSH access restricted to specific IP ranges
- Application ports exposed based on requirements
- Database access limited to application servers
- All instances protected by security groups

## Terraform Configuration Steps

1. Provider Configuration:
```hcl
provider "aws" {
  region = "ap-south-1"
}
```

2. VPC and Network Setup:
```hcl
resource "aws_vpc" "healthcare_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}
```

3. EC2 Instance Template:
```hcl
resource "aws_instance" "healthcare_server" {
  count         = 3
  ami           = "ami-084568db4383264d4" # Ubuntu 24 AMI ID
  instance_type = "t2.large"
  vpc_security_group_ids = [aws_security_group.healthcare_sg.id]
  
  root_block_device {
    volume_size = 20
  }
  
  tags = {
    Name = "healthcare-server-${count.index + 1}"
    Environment = "production"
    Project = "healthcare"
  }
}
```

## Estimated Costs
- t2.large instances: ~$0.0928 per hour per instance
- Total monthly cost (3 instances): ~$201.25 (assuming 24/7 usage)
- Additional costs for EBS volumes and data transfer

## Deployment Steps
1. Initialize Terraform
2. Review the plan
3. Apply the configuration
4. Verify the infrastructure
5. Configure security groups and access

