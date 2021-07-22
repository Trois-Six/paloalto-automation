## Optional Variables

variable "bootstrap_xml_path" {
  description = "Path to the bootstrap.xml file"
  default     = "../../../common/bootstrap/bootstrap.xml"
}

variable "init_cfg_path" {
  description = "Path to the init-cfg.txt file"
  default     = "../../../common/bootstrap/init-cfg.txt"
}

variable "name_suffix" {
  description = "Bucket name suffix."
  default     = "paloalto"
}
