## Optional Variables

variable "bootstrap_xml_path" {
  description = "Path to the bootstrap.xml file"
  default     = "../../../common/bootstrap/bootstrap.xml"
}

variable "init_cfg_path" {
  description = "Path to the init-cfg.txt file"
  default     = "../../../common/bootstrap/init-cfg.txt"
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network"
  type        = string
}

variable "name_prefix" {
  description = "Storage account name prefix."
  default     = "paloalto"
}

variable "location" {
  description = "The location/region where the virtual network is created"
  type        = string
  default     = "eastus"
}
