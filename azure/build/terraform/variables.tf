## Required Variables

variable "azure_location" {
  description = "The Azure region in which to deploy."
}

variable "public_key_file" {
  description = "Full path to the SSH public key file."
}

variable "name" {
  description = "Suffix used for some resources."
}

variable "vnet_address_space" {
  description = "Virtual network address space."
}

variable "public_subnet" {
  description = "Public subnet in VPC (in CIDR format)."
}

variable "mgmt_subnet" {
  description = "Management subnet in VPC (in CIDR format)."
}

variable "private_subnet" {
  description = "Private subnet in VPC (in CIDR format)."
}

variable "fw_mgmt_allowed_from" {
  description = "Public subnet allowed to manage the firewall."
  type        = list(string)
}

variable "fw_version" {
  description = "Version of the firewall"
}

## Optional Variables

variable "fw_admin" {
  description = "Firewall admin user"
  default     = "admin"
}
