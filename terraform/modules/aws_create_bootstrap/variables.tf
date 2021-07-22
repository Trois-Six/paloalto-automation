## Required Variables

variable "bootstrap_xml_tpl_path" {
  description = "Path to the input template bootstrap.xml.tpl file"
  default     = "../../../common/bootstrap/bootstrap.xml.tpl"
}

variable "bootstrap_xml_path" {
  description = "Path to the output bootstrap.xml file"
  default     = "../../../common/bootstrap/bootstrap.xml"
}

variable "init_cfg_tpl_path" {
  description = "Path to the input template init-cfg.txt.tpl file"
  default     = "../../../common/bootstrap/init-cfg.txt.tpl"
}

variable "init_cfg_path" {
  description = "Path to the output init-cfg.txt file"
  default     = "../../../common/bootstrap/init-cfg.txt"
}

variable "name_suffix" {
  description = "Suffix of the firewall instance name. Other types of resources will be named by the type + suffix."
  default     = "paloalto"
}

variable "fw_admin" {
  description = "Firewall admin user"
  default     = "admin"
}
