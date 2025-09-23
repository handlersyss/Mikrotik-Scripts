# Script de monitoramento do sistema
# Verifica recursos e gera alertas

:global checkSystemResources do={
    :local cpuLoad [/system resource get cpu-load]
    :local memoryUsed [/system resource get free-memory]
    :local diskFree [/system resource get free-hdd-space]
    
    # Verificar CPU
    :if ($cpuLoad > 80) do={
        :log warning "CPU Load alto: $cpuLoad%"
    }
    
    # Verificar memória
    :if ($memoryUsed < 10485760) do={
        :log warning "Memória baixa: $memoryUsed bytes livres"
    }
    
    # Verificar espaço em disco
    :if ($diskFree < 10485760) do={
        :log warning "Espaço em disco baixo: $diskFree bytes livres"
    }
}

# Executar verificação
$checkSystemResources

# Agendar para executar a cada 5 minutos
/system scheduler add name=system-monitor interval=5m on-event="/system script run system-monitoring"

:log info "Monitoramento do sistema configurado"