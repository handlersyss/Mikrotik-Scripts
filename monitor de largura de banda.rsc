# Monitor de largura de banda
# Identifica usuários com alto consumo

:global monitorBandwidth do={
    :foreach rule in=[/queue simple find] do={
        :local name [/queue simple get $rule name]
        :local bytesIn [/queue simple get $rule bytes]
        
        # Converter para MB
        :local mbIn ($bytesIn / 1048576)
        
        :if ($mbIn > 100) do={
            :log warning "Alto consumo detectado: $name - $mbIn MB"
        }
    }
}

# Configurar QoS básico
/queue simple add name="Total-Bandwidth" max-limit=100M/20M target=192.168.1.0/24

$monitorBandwidth