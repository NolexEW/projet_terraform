resource "aws_default_security_group" "app_security_group_public" {
  count = var.is_public ? 1 : 0
  vpc_id = var.vpc_accostage

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = var.cidr_blocks_pool
    description = "ssh"
  }

    ingress {
    protocol  = "tcp"
    from_port = 5000
    to_port   = 5000
    cidr_blocks = var.cidr_blocks_pool
  }

    ingress {
    protocol  = "tcp"
    from_port = 8080
    to_port   = 8080
    cidr_blocks = var.cidr_blocks_pool
  }
    ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    cidr_blocks = var.cidr_blocks_pool
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cidr_blocks_pool
  }
    tags = {
    Name = "sg-wissam-public"
  }
}


resource "aws_default_security_group" "app_security_group_private" {
  count = var.is_public ? 0 : 1
  vpc_id = var.vpc_accostage

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = var.cidr_blocks_pool
    description = "ssh"
  }

  #   ingress {
  #   protocol  = "tcp"
  #   from_port = 5000
  #   to_port   = 5000
  #   cidr_blocks = var.cidr_blocks_pool
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cidr_blocks_pool
  }
    tags = {
    Name = "sg-wissam-public"
  }
}



# resource "aws_internet_gateway" "app_internet_gateway" {
#   vpc_id = aws_vpc.app_vpc.id
#   tags = {
#     Name = "gateway_wissam"
#   }
# }
resource "aws_route_table" "app_route_pub" {
  count = var.is_public ? 1 : 0
  vpc_id = var.vpc_accostage
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.ig_id 
    }

  tags = {
    Name = "app_route_table_public"
  }
}

resource "aws_route_table" "app_route_priv" {
  count = var.is_public ? 0 : 1
  vpc_id = var.vpc_accostage
  route = []

  tags = {
    Name = "app_route_table_private"
  }
}

resource "aws_route_table_association" "app_route_table" {
  subnet_id      = aws_subnet.app_subnet.id
  route_table_id = var.is_public ? aws_route_table.app_route_pub[0].id : aws_route_table.app_route_priv[0].id 
}

# resource "aws_vpc" "app_vpc" {
#   cidr_block = var.vpc_cidr_block
#   tags = {
#     Name = "app-vpc-wissam"
#   }
# }

resource "aws_subnet" "app_subnet" {
  vpc_id            = var.vpc_accostage
  cidr_block        = var.subnet_cidr_block
  map_public_ip_on_launch = var.is_public
  availability_zone = var.availability_zone
  tags = {
    Name = "app-vpc-wissam"
  }
}


resource "aws_network_interface" "net_inter" {
  subnet_id   = aws_subnet.app_subnet.id
  private_ips = var.private_ips

  tags = {
    Name = "network-interface"
  }
}

resource "aws_instance" "app_server" {
  ami           = var.ami
  instance_type = var.instance_type 
  user_data = "${base64encode(file("script.sh"))}"

  network_interface {
    network_interface_id = aws_network_interface.net_inter.id
    device_index         = var.device_index
  }
  tags = {
    Name = "EC2-wissam-${var.is_public  ? "public" : "private"}"
  }
}

resource "docker_image" "frontend_image" {
  name = "employee-frontend"
  build {
    context = "${path.module}/employee-frontend"
    dockerfile = "${path.module}/employee-frontend/Dockerfile"
  }
}

resource "docker_container" "frontend_container" {
  name  = "employee-frontend-container"
  image = docker_image.frontend_image.latest
  ports {
    internal = 8080
    external = 8080
  }
  subnet_id = aws_subnet.app_subnet.id
  security_groups = [aws_security_group.my_sg.id]
}

resource "docker_image" "backend_image" {
  name = "employes-backend"
  build {
    context = "${path.module}/employee-backend"
    dockerfile = "${path.module}/employee-backend/Dockerfile"
  }
}

resource "docker_container" "backend_container" {
  name  = "employee-backend-container"
  image = docker_image.backend_image.latest
  ports {
    internal = 5000
    external = 5000
  }
  subnet_id = aws_subnet.aws_subnet.id
  security_groups = [aws_security_group.my_sg.id]
}
