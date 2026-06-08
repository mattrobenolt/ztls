resource "tls_private_key" "bench" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "bench" {
  key_name   = "${var.name_prefix}-key"
  public_key = tls_private_key.bench.public_key_openssh
}

resource "local_sensitive_file" "bench_pem" {
  content         = tls_private_key.bench.private_key_openssh
  filename        = "${path.module}/bench.pem"
  file_permission = "0600"
}

resource "aws_security_group" "bench" {
  name_prefix = "${var.name_prefix}-"
  vpc_id      = aws_vpc.bench.id

  ingress {
    description = "SSH"
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

  tags = { Name = "${var.name_prefix}-sg" }
}

resource "aws_instance" "bench" {
  ami                    = data.aws_ami.nixos.id
  instance_type          = local.instance_type
  subnet_id              = aws_subnet.bench.id
  vpc_security_group_ids = [aws_security_group.bench.id]
  key_name               = aws_key_pair.bench.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  user_data = file("${path.module}/configuration.nix")

  tags = { Name = var.name_prefix }
}
