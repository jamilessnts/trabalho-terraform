# Criação da VPC
resource "aws_vpc" "puc_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "puc_vpc"
  }
}

# Criação da Subnet Pública
resource "aws_subnet" "puc_public_subnet" {
  vpc_id     = aws_vpc.puc_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "puc_public_subnet"
  }
}

# Criação do Internet Gateway
resource "aws_internet_gateway" "puc_igw" {
  vpc_id = aws_vpc.puc_vpc.id

  tags = {
    Name = "puc_igw"
  }
}

# Criação da Tabela de Roteamento
resource "aws_route_table" "puc_rt" {
  vpc_id = aws_vpc.puc_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.puc_igw.id
  }

  tags = {
    Name = "puc_rt"
  }
}

# Criação da Rota Default para Acesso à Internet
resource "aws_route" "puc_routetointernet" {
  route_table_id            = aws_route_table.puc_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.puc_igw.id
}

# Associação da Subnet Pública com a Tabela de Roteamento
resource "aws_route_table_association" "puc_pub_association" {
  subnet_id      = aws_subnet.puc_public_subnet.id
  route_table_id = aws_route_table.puc_rt.id
}
