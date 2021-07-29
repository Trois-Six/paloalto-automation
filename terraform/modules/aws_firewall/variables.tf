## Required Variables

variable "ssh_key_name" {
  description = "SSH keypair name to provision firewall."
}

variable "vpc_id" {
  description = "VPC to create firewall instance in."
}

variable "fw_mgmt_allowed_from" {
  description = "Public subnet allowed to manage the firewall."
}

variable "fw_mgmt_subnet_id" {
  description = "Subnet ID for firewall management interface."
}

variable "fw_mgmt_ip" {
  description = "Internal IP address for firewall management interface."
}

variable "fw_eth1_subnet_id" {
  description = "Subnet ID for firewall ethernet1/1."
}

variable "fw_eth1_ip" {
  description = " IP address for firewall ethernet1/1."
}

variable "fw_eth2_subnet_id" {
  description = "Subnet ID for firewall ethernet1/2."
}

variable "fw_eth2_ip" {
  description = " IP address for firewall ethernet1/2."
}

variable "fw_bootstrap_bucket" {
  description = "S3 bucket holding bootstrap configuration."
}

## Optional Variables

variable "name_prefix" {
  description = "Prefix of the firewall instance name. Other types of resources will be named by the prefix + type."
  default     = "paloalto"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "fw_instance_type" {
  description = "Instance type for firewall instance."
  default     = "m5.xlarge"
}

variable "fw_version" {
  description = "Firewall version to deploy."
  default     = "10.1.0"
}

variable "iam_role_document_path" {
  description = "Path to the AWS document to define the bootstrap IAM role"
  default     = "../../../common/aws_documents/iam_role.json"
}

variable "iam_policy_document_path" {
  description = "Path to the AWS document to define the bootstrap IAM policy"
  default     = "../../../common/aws_documents/iam_policy.json"
}
