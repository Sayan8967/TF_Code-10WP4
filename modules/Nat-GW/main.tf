# Allocate elastic IP for NAT Gateway in the Public Subnet 1
resource "aws_eip" "EIP-NAT-GW1" {

    tags = {
        Name = "NAT-GW-EIP1"
    }
}

# Allocate Elastic IP for NAT Gateway in the Public Subnet 2
resource "aws_eip" "EIP-NAT-GW2" {

    tags = {
        Name = "NAT-GW-EIP2"
    }
}

resource "aws_nat_gateway" "nat_gw1" {
    allocation_id = aws_eip.EIP-NAT-GW1.id
    subnet_id     = var.PUB_SUB1_ID

    tags = {
        Name = "NAT-GW1"
    } 

    depends_on = [ var.IGW_ID ]
}

resource "aws_nat_gateway" "nat_gw2" {
    allocation_id = aws_eip.EIP-NAT-GW2.id
    subnet_id     = var.PUB_SUB2_ID

    tags = {
        Name = "NAT-GW2"
    } 

    depends_on = [ var.IGW_ID ]
}

# Create private route table for Private Subnet 3 and associate it with the NAT Gateway in Public Subnet 1
resource "aws_route_table" "pri-rt-a" {
    vpc_id = var.VPC_ID

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gw1.id
    }

    tags = {
        Name = "Private-Route-Table-A"
    }
}
# Associate Private Subnet 3 with private route table
resource "aws_route_table_association" "pri-sub3-with-pri-rt-a" {
    subnet_id      = var.PRI_SUB3_ID
    route_table_id = aws_route_table.pri-rt-a.id
  
}



#Create private route table for Private Subnet 4 and associate it with the NAT Gateway in Public Subnet 2
resource "aws_route_table" "pri-rt-b" {
    vpc_id = var.VPC_ID

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gw2.id
    }
    tags = {
      Name = "Private-Route-Table-B"
    }
}
# Associate Private Subnet 4 with private route table
resource "aws_route_table_association" "pri-sub4-with-pri-rt-b" {
    subnet_id      = var.PRI_SUB4_ID
    route_table_id = aws_route_table.pri-rt-b.id
  
}
