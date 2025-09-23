# Script de hardening de segurança
# Implementa configurações avançadas de segurança

# Configurar banner de login
/system note set note="ACESSO AUTORIZADO APENAS - Todas as atividades são monitoradas"

# Configurar logging
/system logging add topics=info,warning,error,critical action=memory
/system logging add topics=info,warning,error,critical action=disk disk-file-name=system-log

# Limitar tentativas de login
/user settings set minimum-password-length=8

# Configurar SNMP (se necessário)
/snmp set enabled=no

# Desabilitar discovery protocols desnecessários
/ip neighbor discovery-settings set discover-interface-list=none

# MAC Server security
/tool mac-server set allowed-interface-list=LAN
/tool mac-server mac-winbox set allowed-interface-list=LAN

:log info "Hardening de segurança aplicado"