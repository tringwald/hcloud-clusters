locals {
  subdomain          = ".k8s"
  subdomain_internal = ".internal${local.subdomain}"
}

variable "zone_id" {
  # From ENV
}

variable "domain_name" {
  type = string
}


# Public DNS
resource "cloudflare_record" "dns_A" {
  for_each        = zipmap(hcloud_server.server[*].name, hcloud_server.server)
  zone_id         = var.zone_id
  name            = join("", [replace(each.value.name, "master", "node"), local.subdomain])
  value           = each.value.ipv4_address
  type            = "A"
  ttl             = 1
  allow_overwrite = true
}

resource "cloudflare_record" "dns_master_A" {
  for_each        = merge([for entry in hcloud_server.server : { (entry.name) = entry } if length(regexall("^master", entry.name)) > 0]...)
  zone_id         = var.zone_id
  name            = "${each.key}${local.subdomain}"
  value           = each.value.ipv4_address
  type            = "A"
  ttl             = 1
  allow_overwrite = true
}

resource "cloudflare_record" "dns_AAAA" {
  for_each        = zipmap(hcloud_server.server[*].name, hcloud_server.server)
  zone_id         = var.zone_id
  name            = "${each.value.name}${local.subdomain}"
  value           = each.value.ipv6_address
  type            = "AAAA"
  ttl             = 1
  allow_overwrite = true
}

# Internal DNS
resource "cloudflare_record" "dns_internal_A" {
  for_each        = zipmap(hcloud_server.server[*].name, hcloud_server.server)
  zone_id         = var.zone_id
  name            = join("", [replace(each.value.name, "master", "node"), local.subdomain_internal])
  value           = tolist(each.value.network)[0].ip
  type            = "A"
  ttl             = 1
  allow_overwrite = true
}

resource "cloudflare_record" "dns_internal_master_A" {
  for_each        = merge([for entry in hcloud_server.server : { (entry.name) = entry } if length(regexall("^master", entry.name)) > 0]...)
  zone_id         = var.zone_id
  name            = "${each.key}${local.subdomain_internal}"
  value           = tolist(each.value.network)[0].ip
  type            = "A"
  ttl             = 1
  allow_overwrite = true
}
