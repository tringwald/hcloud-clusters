terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~>1.33.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.10.1"
    }
  }
}


resource "hcloud_server" "server" {
  name        = count.index < var.num_master_nodes ? "master-${count.index + 1}" : "node-${count.index + 1}"
  server_type = var.instance_type
  image       = "ubuntu-20.04"
  location    = var.region
  ssh_keys    = [var.ssh_key_name]
  firewall_ids = [hcloud_firewall.basic_rules.id]
  count = var.node_count
  user_data = templatefile("./cloud-init/${var.init_file}.yaml", {
    name                 = "node-${count.index + 1}"
    pubkey               = base64encode(file(var.pubkey_path))
    privatekey           = base64encode(file(var.privatekey_path))
    node_internal_ip      = cidrhost(local.private_subnet, count.index + 1)
    domain_name          = var.domain_name
    fqdn_public          = join(".", [count.index < var.num_master_nodes ? "master-${count.index + 1}" : "node-${count.index + 1}", var.subdomain, var.domain_name])
    fqdn_internal        = join(".", [count.index < var.num_master_nodes ? "master-${count.index + 1}" : "node-${count.index + 1}", var.subdomain_internal, var.domain_name])
    fqdn_public_noname   = join(".", [var.subdomain, var.domain_name])
    fqdn_internal_noname = join(".", [var.subdomain_internal, var.domain_name])
    subdomain_public     = var.subdomain
    subdomain_internal   = var.subdomain_internal
  })


  network {
    network_id = hcloud_network.network.id
    ip         = cidrhost(local.private_subnet, count.index + 1)
  }

  depends_on = [
    hcloud_network_subnet.network_subnet
  ]
}

variable "num_master_nodes" {
  type = number
}

variable "node_count" {
  type = number
}

variable "ssh_key_name" {
  type = string
}

variable "init_file" {
  type = string
}

variable "pubkey_path" {

}

variable "privatekey_path" {

}

variable "instance_type" {

}

variable "region" {

}
