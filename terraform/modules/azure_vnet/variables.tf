## Required Variables

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "address_space" {
  description = "The address space for the virtual network"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network"
  type        = string
}

variable "private_subnet" {
  description = "The private subnet inside the virtual network"
  type        = string
}

## Optional Variables

variable "location" {
  description = "The location/region where the virtual network is created"
  type        = string
  default     = "eastus"
}

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "private"
}
