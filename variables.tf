variable "aws_secrets_engine_name" {
  type        = string
  description = "Name of AWS Secrets Engine where role exists"
}

variable "aws_secrets_engine_role" {
  type        = string
  description = "Name of Vault role to retrieve creds from"
}