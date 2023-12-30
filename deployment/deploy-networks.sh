# Read the IaC/networks.yml file
system_file="IaC/networks.yml"
networks=$(cat "$system_file" | yq eval '.networks[]')

# Loop through each network and create it using Proxmox PVE CLI API calls
for network in $networks; do
    network_name=$(echo "$network" | yq eval '.name')
    network_cidr=$(echo "$network" | yq eval '.cidr')
    
    pvesh create /nodes/{node}/networks -method POST -content-type "application/json" -data '{
        "iface": "vmbr0",
        "type": "bridge",
        "autostart": 1,
        "bridge_ports": "eth0",
        "bridge_stp": 0,
        "bridge_fd": 0,
        "address": "'"$network_cidr"'",
        "netmask": "255.255.255.0",
        "gateway": "192.168.1.1",
        "dns1": "8.8.8.8",
        "dns2": "8.8.4.4"
    }' &
done