resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "app-vpc-wissam"
  }
}

resource "aws_internet_gateway" "app_internet_gateway" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "gateway_wissam"
  }
}


module "docker_front" {
  source = "../app-server"
  vpc_accostage = aws_vpc.app_vpc.id
  ig_id = aws_internet_gateway.app_internet_gateway.id
  subnet_cidr_block = "50.20.10.0/24"
  availability_zone = "us-west-1a"
  private_ips = ["50.20.10.25"]
  cidr_blocks_pool = ["0.0.0.0/0"]
  is_public = true
}

module "docker_back" {
  source = "../app-server"
  vpc_accostage = aws_vpc.app_vpc.id
  ig_id = aws_internet_gateway.app_internet_gateway.id
  subnet_cidr_block = "50.20.20.0/24"
  availability_zone = "us-west-1a"
  cidr_blocks_pool = ["0.0.0.0/0"]#[format("%s/24" ,module.docker_front.private_ip)]
  private_ips = ["50.20.20.25"]
  is_public = false
}