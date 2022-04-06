# Hetzner instance/server type name
instance_type = "cx21"

# Location of the servers
region = "hel1"

# Number of nodes in the cluster
num_master_nodes = 1
node_count       = 5

# SSH key name as provided in the Hetzner interface, used to connect to the nodes.
ssh_key_name = "user@cluster"

# Local SSH key paths for node-to-node communication
pubkey_path     = "~/.ssh/id_rsa.pub"
privatekey_path = "~/.ssh/id_rsa"

# These variables are assembled to:
# external DNS (public IP): <node-name>.<subdomain>.<domain_name> and
# internal DNS (private IP): <node-name>.<subdomain_internal>.<domain_name>
domain_name        = "example.com"
subdomain          = "k8s"
subdomain_internal = "internal.k8s"

# Subnet for private node-to-node communication
subnet_allocation_range = "10.10.0.0/16"

# Setting up either "k8s" or "swarm" cluster
init_file = "k8s"


