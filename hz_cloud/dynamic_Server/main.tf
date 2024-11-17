terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.33.1"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

# Variables
variable "hcloud_token" {
  type        = string
  description = "Hetzner Cloud API token"
}

variable "server_configs" {
  type = list(object({
    name        = string
    server_type = string
    image       = string
    location    = string
  }))
  description = "List of server configurations"
  default = [
    {
      name        = "server-1"
      server_type = "cx22"
      image       = "ubuntu-20.04"
      location    = "fsn1"
    },
    {
      name        = "server-2"
      server_type = "cx22"
      image       = "ubuntu-22.04"
      location    = "nbg1"
    }
  ]
}

# Creating servers dynamically using for_each
resource "hcloud_server" "web" {
  for_each    = { for server in var.server_configs : server.name => server }
  name        = each.value.name
  server_type = each.value.server_type
  image       = each.value.image
  location    = each.value.location
}

# Output server IPs
output "server_ips" {
  value = { for name, server in hcloud_server.web : name => server.ipv4_address }
}
