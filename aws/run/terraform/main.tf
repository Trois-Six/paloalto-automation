resource "panos_ethernet_interface" "untrust" {
  name                      = "ethernet1/1"
  comment                   = "untrust interface"
  vsys                      = "vsys1"
  mode                      = "layer3"
  enable_dhcp               = true
  create_dhcp_default_route = true
}

resource "panos_ethernet_interface" "trust" {
  name        = "ethernet1/2"
  comment     = "trust interface"
  vsys        = "vsys1"
  mode        = "layer3"
  enable_dhcp = true
}

resource "panos_virtual_router" "vr1" {
  name = "vr1"
  interfaces = [
    panos_ethernet_interface.untrust.name,
    panos_ethernet_interface.trust.name,
  ]
  vsys = "vsys1"
}

resource "panos_zone" "untrust" {
  name = "untrust"
  mode = "layer3"
  interfaces = [
    panos_ethernet_interface.untrust.name,
  ]
  vsys = "vsys1"
}

resource "panos_zone" "trust" {
  name = "trust"
  mode = "layer3"
  interfaces = [
    panos_ethernet_interface.trust.name,
  ]
  vsys = "vsys1"
}

resource "panos_administrative_tag" "inbound" {
  color = "color4"
  name  = "Inbound"
  vsys  = "vsys1"
}

resource "panos_administrative_tag" "outbound" {
  color = "color3"
  name  = "Outbound"
  vsys  = "vsys1"
}

resource "panos_security_rule_group" "security_rules" {
  position_keyword = "top"
  rule {
    name                  = "allow SSH to whoami"
    source_zones          = [panos_zone.untrust.name]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.trust.name]
    destination_addresses = [data.terraform_remote_state.build.outputs.fw_untrust_ip]
    applications          = ["ssh"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
    tags                  = [panos_administrative_tag.inbound.name]
  }
  rule {
    name                  = "allow HTTP to whoami"
    source_zones          = [panos_zone.untrust.name]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.trust.name]
    destination_addresses = [data.terraform_remote_state.build.outputs.fw_untrust_ip]
    applications          = ["web-browsing"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
    tags                  = [panos_administrative_tag.inbound.name]
  }
  rule {
    name                  = "allow any from trust"
    source_zones          = [panos_zone.trust.name]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.untrust.name]
    destination_addresses = ["any"]
    applications          = ["any"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
    tags                  = [panos_administrative_tag.outbound.name]
  }
  vsys = "vsys1"
}

resource "panos_service_object" "ssh" {
  name             = "service-ssh"
  protocol         = "tcp"
  destination_port = "22"
  vsys             = "vsys1"
}

resource "panos_service_object" "http" {
  name             = "service-http"
  protocol         = "tcp"
  destination_port = "80,8080"
  vsys             = "vsys1"
}

resource "panos_nat_rule_group" "nats" {
  position_keyword = "top"
  rule {
    name = "whoami HTTP from untrust"
    tags = [panos_administrative_tag.inbound.name]
    original_packet {
      source_zones          = [panos_zone.untrust.name]
      destination_zone      = panos_zone.untrust.name
      destination_interface = panos_ethernet_interface.untrust.name
      source_addresses      = ["any"]
      destination_addresses = [data.terraform_remote_state.build.outputs.fw_untrust_ip]
      service               = panos_service_object.http.name
    }
    translated_packet {
      source {}
      destination {
        static_translation {
          address = data.terraform_remote_state.build.outputs.whoami_ip
        }
      }
    }
  }
  rule {
    name = "whoami SSH from untrust"
    tags = [panos_administrative_tag.inbound.name]
    original_packet {
      source_zones          = [panos_zone.untrust.name]
      destination_zone      = panos_zone.untrust.name
      destination_interface = panos_ethernet_interface.untrust.name
      source_addresses      = ["any"]
      destination_addresses = [data.terraform_remote_state.build.outputs.fw_untrust_ip]
      service               = panos_service_object.ssh.name
    }
    translated_packet {
      source {}
      destination {
        static_translation {
          address = data.terraform_remote_state.build.outputs.whoami_ip
        }
      }
    }
  }
  rule {
    name = "trust outbound"
    tags = [panos_administrative_tag.outbound.name]
    original_packet {
      source_zones          = [panos_zone.trust.name]
      destination_zone      = panos_zone.untrust.name
      destination_interface = "any"
      source_addresses      = ["any"]
      destination_addresses = ["any"]
    }
    translated_packet {
      source {
        dynamic_ip_and_port {
          interface_address {
            interface = panos_ethernet_interface.untrust.name
          }
        }
      }
      destination {}
    }
  }
  vsys = "vsys1"
}