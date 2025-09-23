# Backup automático do sistema
# Cria backup e envia por email

:global createBackup do={
    :local date [/system clock get date]
    :local time [/system clock get time]
    :local name "backup-$date-$time"
    
    # Criar backup
    /system backup save name=$name
    
    # Export da configuração
    /export file=$name
    
    :log info "Backup criado: $name"
    
    # Opcional: Enviar por email
    # /tool e-mail send to="admin@domain.com" subject="Backup $name" body="Backup automático criado" file="$name.backup"
}

$createBackup

# Agendar backup diário às 2:00
/system scheduler add name=daily-backup start-time=02:00:00 interval=1d on-event="/system script run auto-backup"