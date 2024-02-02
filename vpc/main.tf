# Create vpc
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc-cidr

  tags = {
    Name = var.names.vpc-name
  }
}
# Create internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = var.names.igw-name
  }
}