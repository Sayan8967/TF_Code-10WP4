resource "aws_vpc" "vpc" {
    cidr_block = var.VPC_CIDR
    instance_tenancy = "default" # Default tenancy for instances launched in the VPC
    enable_dns_hostnames = true
    enable_dns_support = true
    #enable_classiclink   = false
    #enable_classiclink_dns_support = false
    assign_generated_ipv6_cidr_block = false

    tags = {
        Name = "${var.PROJECT_NAME}-vpc"
    }
}

# Create Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "${var.PROJECT_NAME}-igw"
    }
  
}

# Use data source to fetch availability zones
data "aws_availability_zones" "availability_zones" {
    state = "available"
}

# Create Public subnet pub-sub1
resource "aws_subnet" "pub-sub1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.PUB_SUB1_CIDR
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.availability_zones.names[0] # Use the first available zone
    
    tags = {
        Name = "pub-sub1"
        "kubernetes.io/cluster/${var.PROJECT_NAME}" = "shared" # Tag for Kubernetes cluster
        "kubernetes.io/role/elb" = "1" # Tag for ELB role
    }
}

# Create Public subnet pub-sub2
resource "aws_subnet" "pub-sub2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.PUB_SUB2_CIDR
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.availability_zones.names[1] # Use the second available zone

    tags = {
        Name = "pub-sub2"
        "kubernetes.io/cluster/${var.PROJECT_NAME}" = "shared" # Tag for Kubernetes cluster
        "kubernetes.io/role/elb" = "1" # Tag for ELB role
    }
}

# Create Public Route Table
resource "aws_route_table" "pub_rt" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0" # Route all traffic to the internet - outbound traffic
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "${var.PROJECT_NAME}-pub-rt"
    }
}

# Associate Public Route Table with Public Subnet (pub-sub1)\
resource "aws_route_table_association" "pub_rt_a" {
    subnet_id = aws_subnet.pub-sub1.id
    route_table_id = aws_route_table.pub_rt.id
  
}

# Associate Public Route Table with Public Subnet (pub-sub2)
resource "aws_route_table_association" "pub_rt_b" {
    subnet_id = aws_subnet.pub-sub2.id
    route_table_id = aws_route_table.pub_rt.id
}



# Create Private subnet pri-sub3
resource "aws_subnet" "pri-sub3" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.PRI_SUB3_CIDR
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.availability_zones.names[0] # Use the third available zone

    tags = {
        Name = "pri-sub3"
        "kubernetes.io/cluster/${var.PROJECT_NAME}" = "shared" # Tag for Kubernetes cluster
        "kubernetes.io/role/internal-elb" = "1" # Tag for internal ELB role
    }
}

# Create Private subnet pri-sub4
resource "aws_subnet" "pri-sub4" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.PRI_SUB4_CIDR
    map_public_ip_on_launch = false
    availability_zone = data.aws_availability_zones.availability_zones.names[1] # Use the fourth available zone

    tags = {
        Name = "pri-sub4"
        "kubernetes.io/cluster/${var.PROJECT_NAME}" = "shared" # Tag for Kubernetes cluster
        "kubernetes.io/role/internal-elb" = "1" # Tag for internal ELB role
    }
}