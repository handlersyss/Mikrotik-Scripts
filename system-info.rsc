# Script de informações do sistema
# Coleta informações detalhadas

:global getSystemInfo do={
    :local identity [/system identity get name]
    :local version [/system package get [find name=routeros] version]
    :local board [/system routerboard get model]
    :local uptime [/system resource get uptime]
    :local cpu [/system resource get cpu-load]
    :local memory [/system resource get total-memory]
    :local freeMem [/system resource get free-memory]
    
    :log info "Sistema: $identity"
    :log info "Versão: $version"
    :log info "Placa: $board"
    :log info "Uptime: $uptime"
    :log info "CPU: $cpu%"
    :log info "Memória: $freeMem / $memory"
}

$getSystemInfo