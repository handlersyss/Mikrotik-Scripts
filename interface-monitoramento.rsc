# Monitoramento de interfaces
# Verifica status e tráfego das interfaces

:global monitorInterfaces do={
    :foreach interface in=[/interface ethernet find] do={
        :local ifname [/interface ethernet get $interface name]
        :local running [/interface ethernet get $interface running]
        :local rxBytes [/interface ethernet get $interface rx-byte]
        :local txBytes [/interface ethernet get $interface tx-byte]
        
        :if (!$running) do={
            :log warning "Interface $ifname está down"
        } else={
            :log info "Interface $ifname: RX=$rxBytes TX=$txBytes"
        }
    }
}

$monitorInterfaces

# Agendar verificação
/system scheduler add name=interface-monitor interval=10m on-event="/system script run interface-monitoring"