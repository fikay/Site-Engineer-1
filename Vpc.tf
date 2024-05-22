resource "aws_vpc" "faks_vpc" {
    cidr_block = "10.0.0.0/24"
}

resource "aws_internet_gateway" "Igw" {
  vpc_id = aws_vpc.faks_vpc.id

  tags = {
    Name = "Main_Igw"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.faks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Igw.id
  }

  tags = {
    Name = "Public_Route_Table"
  }
  
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.faks_vpc.id

  # route {
    
  # }

  tags = {
    Name = "Private_Route_table"
  }
  
}

resource "aws_subnet" "Public_subnet" {
  vpc_id = aws_vpc.faks_vpc.id
  cidr_block = "10.0.0.0/28"
  tags = {
    Name = "Public_subnet"
  }
}

resource "aws_subnet" "Private_subnet" {
  vpc_id = aws_vpc.faks_vpc.id
  cidr_block = "10.0.0.16/28"
  tags = {
    Name = "Private_subnet"
  }
}


resource "aws_route_table_association" "Public_subnet_association" {
  subnet_id = aws_subnet.Public_subnet.id
  route_table_id = aws_route_table.public_route.id
  
}

resource "aws_route_table_association" "Private_subnet_association" {
  subnet_id = aws_subnet.Private_subnet.id
  route_table_id = aws_route_table.private_route.id
  
}

resource "aws_security_group" "Faks_Sg" {
  name = "Faks_Sg"
  description =  "Security group  for faks vpc"
  vpc_id = aws_vpc.faks_vpc.id

  tags = {
    "key" ="Faks_Sg" 
  }
  
}


resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.Faks_Sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  ip_protocol = "tcp"
  to_port = 80
  
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.Faks_Sg.id
  cidr_ipv4 = aws_vpc.faks_vpc.cidr_block
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
  
}