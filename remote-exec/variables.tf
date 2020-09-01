variable common_tags {
  type        = map(string)
  description = "(Optional) Map of common tags for taggable AWS resources."
  default     = {}
}

variable vpc_id {
  type        = string
  description = "VPC to deploy EC2 instance and Security Group in."
}

variable os_distro {
  type        = string
  description = "Operating System distribution (amzn2, ubuntu)."
  default     = "amzn2"
}

variable ssh_keypair_name {
  type        = string
  description = "Name of existing SSH Key Pair to attach to EC2 instance."
}

variable public_subnet_id {
  type        = string
  description = "Public Subnet ID to deploy EC2 instance on."
  default     = null
}

variable private_subnet_id {
  type        = string
  description = "Private Subnet ID to deploy EC2 instance on."
  default     = null
}

variable ssh_cidr_ingress_allow {
  type        = list(string)
  description = "Subnet ID to deploy EC2 instance on."
}

variable remote_exec_private_key {
  type        = string
  description = "Private Key for remote-exec provisioner connection."
}

variable remote_exec_bastion_host {
  type        = string
  description = "Bastion host to connect to for remote-exec provisioner connection."
  default     = null
}

variable remote_exec_bastion_user {
  type        = string
  description = "Bastion host to connect to for remote-exec provisioner connection."
  default     = "ec2-user"
}