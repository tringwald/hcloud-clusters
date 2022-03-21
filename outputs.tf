# Domain name to IPv4 mapping
output "nodes_ipv4" {
  value = merge([for k, v in merge(cloudflare_record.dns_A[*]...) : { (v.hostname) = v.value }]...)
}

output "masters_ipv4" {
  value = merge([for k, v in merge(cloudflare_record.dns_master_A[*]...) : { (v.hostname) = v.value }]...)
}
