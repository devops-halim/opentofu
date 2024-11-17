terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.33.1"
    }
  }
}

provider "hcloud" {
  token = "YOUR_HETZNER_API_TOKEN"
}

resource "hcloud_server" "web" {
  name        = "my-server"
  server_type = "cx22"
  image       = "debian-12" #"ubuntu-20.04"
  location    = "fsn1" # https://docs.hetzner.com/cloud/general/locations/
  user_data = file("user_data.yml")
  

}
# Create a new SSH key
# resource "hcloud_ssh_key" "default" {
#   name = "Terraform Example"
#   public_key = file("~/.ssh/hetzner/hetzner-cloud.pub")
# }

output "server_ip" {
  value = hcloud_server.web.ipv4_address
 
}

# output "server_ip" {
#    value = hcloud_server.web.ipv6_address
# }