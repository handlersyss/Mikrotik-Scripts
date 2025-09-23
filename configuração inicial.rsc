# Configurar identidade do sistema
/system identity set name="MT-Router-001"

# Configurar senha do admin
/user set admin password="SuaSenhaSegura123!"

# Configurar timezone
/system clock set time-zone-name=America/Sao_Paulo

# Configurar NTP
/system ntp client set enabled=yes
/system ntp client servers add address=a.ntp.br
/system ntp client servers add address=b.ntp.br

# Desabilitar serviços desnecessários
/ip service disable telnet,ftp,www,api,api-ssl

# Manter apenas SSH e Winbox
/ip service set ssh port=2222
/ip service set winbox port=8291

# Configurar DNS
/ip dns set servers=8.8.8.8,1.1.1.1 allow-remote-requests=no

# Configurar DHCP Client na WAN
/ip dhcp-client add disabled=no interface=ether1 add-default-route=yes use-peer-dns=yes

# Log da configuração
:log info "Configuração básica aplicada com sucesso"