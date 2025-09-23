# Ferramentas de limpeza
# Remove logs antigos e arquivos temporários

:global cleanupSystem do={
    # Limpar logs antigos
    /log print file=old-logs
    /file remove [find name~"old-logs"]
    
    # Limpar arquivos de backup antigos (manter apenas os 5 mais recentes)
    :local backupFiles [/file find name~".backup"]
    :if ([:len $backupFiles] > 5) do={
        :for i from=5 to=([:len $backupFiles] - 1) do={
            /file remove [:pick $backupFiles $i]
        }
    }
    
    :log info "Limpeza do sistema concluída"
}

$cleanupSystem

# Agendar limpeza semanal
/system scheduler add name=weekly-cleanup start-time=03:00:00 interval=7d on-event="/system script run cleanup-tools"