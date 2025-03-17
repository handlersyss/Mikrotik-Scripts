/interface bridge
add name=Bridge-VLAN-TRUNKS

/interface pppoe-client
add disabled=no interface=ether1 name=pppoe-out1 user=ppp1
add disabled=no interface=ether2 name=pppoe-out2 user=ppp2

/interface vlan
add interface=Bridge-VLAN-TRUNKS name=vlan10 vlan-id=10
add interface=Bridge-VLAN-TRUNKS name=vlan20 vlan-id=20

/interface list
add name=Bridge-LAN

/ip pool
add name=dhcp_pool1 ranges=10.10.10.2-10.10.10.254
add name=dhcp_pool2 ranges=10.20.20.2-10.20.20.254

/ip dhcp-server
add address-pool=dhcp_pool1 interface=vlan10 lease-time=1d name=dhcp2
add address-pool=dhcp_pool2 interface=vlan20 lease-time=1d name=dhcp3

/port
set 0 name=serial0

/routing table
add disabled=no fib name=via-ISP1
add disabled=no fib name=via-ISP2

/interface bridge port
add bridge=Bridge-VLAN-TRUNKS interface=ether5

/interface list member
add interface=Bridge-VLAN-TRUNKS list=Bridge-LAN
add interface=vlan10 list=Bridge-LAN
add interface=vlan20 list=Bridge-LAN

/ip address
add address=10.10.10.1/24 interface=vlan10 network=10.10.10.0
add address=10.20.20.1/24 interface=vlan20 network=10.20.20.0

/ip dhcp-server network
add address=10.10.10.0/24 dns-server=10.10.10.1 gateway=10.10.10.1
add address=10.20.20.0/24 dns-server=10.20.20.1 gateway=10.20.20.1

/ip dns
set allow-remote-requests=yes servers=1.1.1.1,1.0.0.1

/ip firewall address-list
add address=10.10.10.0/24 list=LAN
add address=10.20.20.0/24 list=LAN

/ip firewall mangle
add action=accept chain=prerouting in-interface=pppoe-out1
add action=accept chain=prerouting in-interface=pppoe-out2
add action=accept chain=prerouting dst-address-list=LAN
add action=mark-connection chain=prerouting in-interface-list=Bridge-LAN new-connection-mark=ISP1_Conn passthrough=yes per-connection-classifier=both-addresses:2/0
add action=mark-routing chain=prerouting connection-mark=ISP1_Conn in-interface-list=Bridge-LAN new-routing-mark=via-ISP1 passthrough=no
add action=mark-connection chain=prerouting in-interface-list=Bridge-LAN new-connection-mark=ISP2_Conn passthrough=yes per-connection-classifier=both-addresses:2/1
add action=mark-routing chain=prerouting connection-mark=ISP2_Conn in-interface-list=Bridge-LAN new-routing-mark=via-ISP2 passthrough=no
add action=mark-connection chain=prerouting in-interface=pppoe-out1 new-connection-mark=ISP1_Conn passthrough=yes
add action=mark-routing chain=output connection-mark=ISP1_Conn new-routing-mark=via-ISP1 passthrough=no
add action=mark-connection chain=prerouting in-interface=pppoe-out2 new-connection-mark=ISP2_Conn passthrough=yes
add action=mark-routing chain=output connection-mark=ISP2_Conn new-routing-mark=via-ISP2 passthrough=no

/ip firewall nat
add action=masquerade chain=srcnat out-interface=pppoe-out1
add action=masquerade chain=srcnat out-interface=pppoe-out2

/ip firewall filter
# Proteger o roteador
add action=accept chain=input connection-state=established,related
add action=accept chain=input in-interface-list=Bridge-LAN
add action=drop chain=input comment="Drop all other input traffic"
# Permitir tráfego das LANs para WAN
add action=accept chain=forward in-interface-list=Bridge-LAN out-interface-list=!Bridge-LAN
# Bloquear tráfego entre VLANs (opcional, remova se não desejado)
add action=drop chain=forward in-interface=vlan10 out-interface=vlan20
add action=drop chain=forward in-interface=vlan20 out-interface=vlan10
# Permitir tráfego estabelecido/relacionado
add action=accept chain=forward connection-state=established,related
add action=drop chain=forward comment="Drop all other forward traffic"

/ip route
add comment="via-ISP1_To_ISP1" disabled=no distance=1 dst-address=0.0.0.0/0 gateway=pppoe-out1 routing-table=via-ISP1 scope=30 target-scope=10
add comment="via-ISP2_To_ISP2" disabled=no distance=1 dst-address=0.0.0.0/0 gateway=pppoe-out2 routing-table=via-ISP2 scope=30 target-scope=10
add comment="Redirect via-ISP1 To ISP2" disabled=no distance=2 dst-address=0.0.0.0/0 gateway=pppoe-out2 routing-table=via-ISP1 scope=30 target-scope=10
add comment="Redirect via-ISP2 To ISP1" disabled=no distance=2 dst-address=0.0.0.0/0 gateway=pppoe-out1 routing-table=via-ISP2 scope=30 target-scope=10
add comment="To-ISP1" disabled=no distance=1 dst-address=0.0.0.0/0 gateway=pppoe-out1 routing-table=main scope=30 target-scope=10
add comment="To-ISP2" disabled=no distance=2 dst-address=0.0.0.0/0 gateway=pppoe-out2 routing-table=main scope=30 target-scope=10
add comment="Netwatch ISP1 (Quad9 DNS)" disabled=no distance=1 dst-address=9.9.9.9/32 gateway=pppoe-out1 routing-table=main scope=30 target-scope=10
add comment="Netwatch ISP2 (Google DNS)" disabled=no distance=1 dst-address=8.8.8.8/32 gateway=pppoe-out2 routing-table=main scope=30 target-scope=10

/system identity
set name=R1

/tool netwatch
add comment=ISP1 disabled=no down-script="/ip route disable [find comment=\"To-ISP1\"]\r\n/ip route disable [find comment=\"via-ISP1_To_ISP1\"]\r\n:log warning \"ISP1 is down\"" host=9.9.9.9 interval=10s timeout=800ms type=simple up-script="/ip route enable [find comment=\"To-ISP1\"]\r\n/ip route enable [find comment=\"via-ISP1_To_ISP1\"]\r\n:log warning \"ISP1 is up\""
add comment=ISP2 disabled=no down-script="/ip route disable [find comment=\"To-ISP2\"]\r\n/ip route disable [find comment=\"via-ISP2_To_ISP2\"]\r\n:log warning \"ISP2 is down\"" host=8.8.8.8 interval=10s timeout=800ms type=simple up-script="/ip route enable [find comment=\"To-ISP2\"]\r\n/ip route enable [find comment=\"via-ISP2_To_ISP2\"]\r\n:log warning \"ISP2 is up\""