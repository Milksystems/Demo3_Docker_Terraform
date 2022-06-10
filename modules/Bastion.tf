# Create instance Bastion server
resource "aws_instance" "bastion_server" {
  count         = local.number_bastion_servers
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data = templatefile("${path.module}/server.tftpl", {
    app_port        = var.app_port,
    app_target_port = var.app_target_port
  })
  availability_zone      = local.azs[count.index]
  subnet_id              = aws_subnet.public_subnet[count.index].id
  vpc_security_group_ids = [aws_security_group.sg_bastion_server.id]

  tags = {
    Name = "bastion_server"
  }
}

# Security group for Bastion server
resource "aws_security_group" "sg_bastion_server" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security_group_bastion_server"
  }
}