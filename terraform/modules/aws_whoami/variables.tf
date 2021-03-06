## Required Variables

variable "ssh_key_name" {}

variable "subnet_id" {}

variable "ip" {}

## Optional Variables

variable "name_prefix" {
  description = "Prefix of the whoami instance name. Other types of resources will be named by the prefix + type."
  default     = "paloalto"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}
