data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  aws_region    = "us-west-2"
  instance_type = var.instance_type

  # First AZ in the region — simple one-off.
  az_name = data.aws_availability_zones.available.names[0]

  # Graviton instance families use arm64; everything else is x86_64.
  is_arm64 = length(regexall("^[a-z]+[0-9]+g", local.instance_type)) > 0
  arch     = local.is_arm64 ? "arm64" : "x86_64"
}

# NixOS 25.x AMI from the official NixOS account.
data "aws_ami" "nixos" {
  most_recent = true
  owners      = ["427812963091"]

  filter {
    name   = "name"
    values = ["nixos/25.*"]
  }

  filter {
    name   = "architecture"
    values = [local.arch]
  }
}
