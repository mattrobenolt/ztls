output "ssh_key_file" {
  description = "Path to the SSH private key"
  value       = local_sensitive_file.bench_pem.filename
}

output "instance_ip" {
  description = "Public IP of the benchmark instance"
  value       = aws_instance.bench.public_ip
}

output "instance_type" {
  description = "EC2 instance type"
  value       = aws_instance.bench.instance_type
}

output "aws_region" {
  description = "Region"
  value       = local.aws_region
}

output "ssh_command" {
  description = "SSH command to connect as root"
  value       = "ssh -i ${local_sensitive_file.bench_pem.filename} root@${aws_instance.bench.public_ip}"
}
