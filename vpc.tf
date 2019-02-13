#vpc
resource "aws_vpc" "my_vpc" {
  cidr_block = "${var.vpc_cidr}"

  tags = {
    Name = "tf-example-vpc"
  }
}

# subnet public
resource "aws_subnet" "my_pub_subnet" {
  vpc_id                  = "${aws_vpc.my_vpc.id}"
  cidr_block              = "${var.public_subnet_cidr}"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "tf-public-subnet"
  }
}

# subnet private
resource "aws_subnet" "my_pri_subnet" {
  vpc_id            = "${aws_vpc.my_vpc.id}"
  cidr_block        = "${var.private_subnet_cidr}"
  availability_zone = "us-east-1a"

  #  map_public_ip_on_launch = "true"

  tags = {
    Name = "tf-private-subnet"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  tags {
    Name = "VPC IGW"
  }
}

# Define the route table
resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "Public Subnet RT"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "web-public-rt-associate" {
  subnet_id      = "${aws_subnet.my_pub_subnet.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}
