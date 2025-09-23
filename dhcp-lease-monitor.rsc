# Monitor de leases DHCP
# Registra novos dispositivos na rede

:global monitorDHCPLeases do={
    :foreach lease in=[/ip dhcp-server lease find] do={
        :local mac [/ip dhcp-server lease get $lease mac-address]
        :local ip [/ip dhcp-server lease get $lease address]
        :local hostname [/ip dhcp-server lease get $lease host-name]
        
        :log info "DHCP Lease: MAC=$mac IP=$ip Hostname=$hostname"
    }
}

# Executar monitoramento
$monitorDHCPLeases