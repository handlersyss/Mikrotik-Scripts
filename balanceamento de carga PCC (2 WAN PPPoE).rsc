/interface bridge
add name=Bridge-VLAN-TRUNKS

/interface pppoe-client
add disabled=no interface=ether1 name=pppoe-out1 user=ppp1 password=senha1
add disabled=no interface=ether2 name=pppoe-out2 user=ppp2 password=senha2

/interface vlan
add interface=Bridge-VLAN-TRUNKS name=vlan10 vlan-id=10
add interface=Bridge-VLAN-TRUNKS name=vlan20 vlan-id=20

/interface list
add name=LAN

/interface bridge port
add bridge=Bridge-VLAN-TRUNKS interface=ether5

/interface list member
add interface=vlan10 list=LAN
add interface=vlan20 list=LAN

/ip pool
add name=dhcp_pool1 ranges=10.10.10.2-10.10.10.254
add name=dhcp_pool2 ranges=10.20.20.2-10.20.20.254

/ip dhcp-server
add address-pool=dhcp_pool1 interface=vlan10 lease-time=1d name=dhcp1
add address-pool=dhcp_pool2 interface=vlan20 lease-time=1d name=dhcp2

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

/routing table
add name=via-ISP1 fib=yes
add name=via-ISP2 fib=yes

/ip firewall mangle
add action=accept chain=prerouting dst-address-list=LAN src-address-list=LAN
add action=mark-routing chain=prerouting dst-address-list=!LAN new-routing-mark=via-ISP1 passthrough=yes per-connection-classifier=both-addresses-and-ports:2/0 src-address-list=LAN
add action=mark-routing chain=prerouting dst-address-list=!LAN new-routing-mark=via-ISP2 passthrough=yes per-connection-classifier=both-addresses-and-ports:2/1 src-address-list=LAN

/ip firewall nat
add action=masquerade chain=srcnat out-interface=pppoe-out1
add action=masquerade chain=srcnat out-interface=pppoe-out2

/ip firewall filter
add action=accept chain=input connection-state=established,related
add action=accept chain=input in-interface-list=LAN
add action=drop chain=input comment="Drop all other input traffic"
add action=accept chain=forward in-interface-list=LAN out-interface-list=!LAN
add action=drop chain=forward in-interface=vlan10 out-interface=vlan20 comment="Block VLAN10 to VLAN20 (optional)"
add action=drop chain=forward in-interface=vlan20 out-interface=vlan10 comment="Block VLAN20 to VLAN10 (optional)"
add action=accept chain=forward connection-state=established,related
add action=drop chain=forward comment="Drop all other forward traffic"

/ip route
add distance=1 dst-address=0.0.0.0/0 gateway=pppoe-out1 routing-table=via-ISP1
add distance=1 dst-address=0.0.0.0/0 gateway=pppoe-out2 routing-table=via-ISP2
add distance=1 dst-address=0.0.0.0/0 gateway=pppoe-out1 routing-table=main
add distance=2 dst-address=0.0.0.0/0 gateway=pppoe-out2 routing-table=main

/system identity
set name=Router-PCC