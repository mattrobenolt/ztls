variable "name_prefix" {
  description = "Prefix for resource names and tags"
  type        = string
  default     = "ztls-bench"
}

variable "instance_type" {
  description = "EC2 instance type for the benchmark host"
  type        = string
  default     = "c7i.large"
}
