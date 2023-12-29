# Read the IaC/system.yml file
system_file="/path/to/IaC/system.yml"
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

    if [ $? -eq 0 ]; then
        # Connect to PostgreSQL DB and write system definition, timestamp, and network details
        psql -h localhost -U username -d dbname -c "INSERT INTO network_info (system_definition, timestamp, network_name, network_cidr) VALUES ('$system_file', NOW(), '$network_name', '$network_cidr');" &
    fi
done
wait

TODO