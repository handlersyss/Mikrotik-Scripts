# Configuração de Interfaces
# Define configurações padrão para interfaces

# Renomear interfaces
/interface ethernet set [ find default-name=ether1 ] name=WAN
/interface ethernet set [ find default-name=ether2 ] name=LAN1
/interface ethernet set [ find default-name=ether3 ] name=LAN2
/interface ethernet set [ find default-name=ether4 ] name=LAN3

# Criar bridge para LAN
/interface bridge add name=bridge-lan protocol-mode=rstp

# Adicionar portas LAN ao bridge
/interface bridge port add bridge=bridge-lan interface=LAN1
/interface bridge port add bridge=bridge-lan interface=LAN2
/interface bridge port add bridge=bridge-lan interface=LAN3

# Configurar IP da LAN
/ip address add address=192.168.1.1/24 interface=bridge-lan

:log info "Interfaces configuradas"