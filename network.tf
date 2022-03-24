resource "hcloud_network" "network" {
  name     = "network"
  ip_range = "10.10.0.0/16"
}

resource "hcloud_network_subnet" "network_subnet" {
  type         = "cloud"
  network_id   = hcloud_network.network.id
  network_zone = "eu-central"
  ip_range     = local.private_subnet
}

variable "subnet_allocation_range" {
  description = "Full range of IPv4 allocation. A subnet will be generated based on this."
}

locals {
  private_subnet = cidrsubnet(var.subnet_allocation_range, 8, 1)
}