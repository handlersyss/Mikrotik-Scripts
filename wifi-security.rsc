# Configuração segura de WiFi
# Implementa WPA3 e configurações de segurança

# Configurar perfil de segurança WPA3
/interface wireless security-profiles add name=wifi-security mode=dynamic-keys authentication-types=wpa2-psk,wpa3-psk wpa2-pre-shared-key="SuaSenhaWiFi123!" group-ciphers=aes-ccm unicast-ciphers=aes-ccm

# Configurar interface wireless
/interface wireless set wlan1 band=2ghz-g/n channel-width=20/40mhz-XX frequency=auto mode=ap-bridge ssid="MeuWiFi-Seguro" security-profile=wifi-security

# Habilitar interface
/interface wireless enable wlan1

# Adicionar ao bridge LAN
/interface bridge port add bridge=bridge-lan interface=wlan1

:log info "WiFi seguro configurado"