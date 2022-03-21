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
  name         = count.index < var.num_master_nodes ? "master-${count.index + 1}" : "node-${count.index + 1}"
  server_type  = "cx21"
  image        = "ubuntu-20.04"
  location     = "hel1"
  ssh_keys     = [var.ssh_key_name]
  #firewall_ids = [hcloud_firewall.basic_rules.id]
  count        = var.node_count
  user_data = templatefile("./cloud-init-user-data.yaml", {
    name       = "node-${count.index + 1}"
    pubkey     = base64encode(file("~/.ssh/k8s/id_rsa_k8s.pub"))
    privatekey = base64encode(file("~/.ssh/k8s/id_rsa_k8s"))
    node_ip    = "10.10.1.${count.index + 1}"
    domain_name = var.domain_name
  })


  network {
    network_id = hcloud_network.network.id
    ip         = "10.10.1.${count.index + 1}"
  }

  depends_on = [
    hcloud_network_subnet.network_subnet
  ]
}


data "template_cloudinit_config" "setup" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = file("./cloud-init-user-data.yaml")
  }
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