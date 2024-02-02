resource "aws_subnet" "public_subnets" {

  vpc_id            = var.vpc_id
  cidr_block        = var.public_subnet_cidrs
  availability_zone = var.availability_zones

  tags ={
    Name = "public-subnet"
  }
}

resource "aws_route_table" "public_routs" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
 
  subnet_id      = aws_subnet.public_subnets.id
  route_table_id = aws_route_table.public_routs.id
}



