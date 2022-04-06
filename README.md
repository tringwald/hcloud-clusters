# Terraform setup for clusters on HCloud

Currently a WIP. Basic support for k8s/k3s/docker swarm clusters on Hetzner Cloud is available.
Hetzner Cloud is used for compute and network infrastructure, Cloudflare is used for DNS.

Additional variables that should be set in the environment or CLI are shown below. 
These are used for authentication to HCloud and Cloudflare.

```
export HCLOUD_TOKEN="1234abcdef"
export HCLOUD_CONTEXT="cluster"
export CLOUDFLARE_API_TOKEN="1234abcdef"
export CLOUDFLARE_EMAIL="user@example.com"
# Cloudflare zone ID
export TF_VAR_zone_id="1234abcdef"
```

Please refer to the `template.tfvars` file for further configuration.