# Configuração de servidor L2TP/IPSec
# Para acesso remoto seguro

# Habilitar L2TP server
/interface l2tp-server server set enabled=yes default-profile=default-encryption

# Configurar pool de IPs para VPN
/ip pool add name=vpn-pool ranges=192.168.100.10-192.168.100.50

# Criar perfil VPN
/ppp profile add name=vpn-profile local-address=192.168.100.1 remote-address=vpn-pool dns-server=192.168.1.1

# Criar usuário VPN
/ppp secret add name=vpnuser password=VpnPass123 profile=vpn-profile

# Configurar IPSec
/ip ipsec policy add src-address=192.168.100.0/24 dst-address=192.168.1.0/24 action=none

# Firewall para VPN
/ip firewall filter add chain=input action=accept protocol=udp dst-port=500,4500
/ip firewall filter add chain=input action=accept protocol=ipsec-esp

:log info "Servidor L2TP/IPSec configurado"