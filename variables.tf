variable "aws_secrets_engine_name" {
  type        = string
  description = "Name of Vault AWS Secrets Engine where Vault AWS role exists within"
}

variable "aws_secrets_engine_role" {
  type        = string
  description = "Name of Vault role to retrieve creds from"
}
