resource "hcloud_firewall" "basic_rules" {
  name = "basic_rules"

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  #rule {
  #  direction = "in"
  #  protocol  = "tcp"
  #  port = "10-32000"
  #  source_ips = [
  #    hcloud_network_subnet.network-subnet.ip_range
  #  ]
  #}
}