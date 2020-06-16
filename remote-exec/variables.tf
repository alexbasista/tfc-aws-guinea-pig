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

variable subnet_id {
    type        = string
    description = "Subnet ID to deploy EC2 instance on."
}

variable ssh_cidr_ingress_allow {
    type        = list(string)
    description = "Subnet ID to deploy EC2 instance on."
}