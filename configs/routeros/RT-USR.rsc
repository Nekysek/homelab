# 2026-06-22 11:12:08 by RouterOS 7.22.3
#
# model = CCR1009-8G-1S-1S+
/interface bridge
add mtu=1500 name=LAN vlan-filtering=yes
/interface ethernet
set [ find default-name=ether2 ] disabled=yes
set [ find default-name=ether3 ] disabled=yes
set [ find default-name=ether4 ] disabled=yes
set [ find default-name=ether5 ] disabled=yes
set [ find default-name=ether6 ] disabled=yes
set [ find default-name=ether7 ] disabled=yes
set [ find default-name=sfp1 ] disabled=yes
/interface eoip
add allow-fast-path=no local-address=192.0.2.20 mac-address=00:00:5e:00:53:03 mtu=1400 name=EOIP remote-address=192.0.2.10 tunnel-id=1
/interface vlan
add interface=LAN name=VLAN10 vlan-id=10
add interface=LAN name=VLAN11 vlan-id=11
add interface=LAN name=VLAN12 vlan-id=12
add interface=LAN name=VLAN32 vlan-id=32
add interface=LAN name=VLAN41 vlan-id=41
add interface=LAN name=VLAN42 vlan-id=42
add interface=LAN name=VLAN62 vlan-id=62
add interface=LAN name=VLAN99 vlan-id=99
/interface list
add name=MNDP
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=POOL_MGMT ranges=172.22.100.1-172.22.100.253
/snmp community
set [ find default=yes ] addresses=172.22.98.0/24
/interface bridge port
add bridge=LAN interface=EOIP
add bridge=LAN interface=sfp-sfpplus1
/ip neighbor discovery-settings
set discover-interface-list=MNDP
/interface bridge vlan
add bridge=LAN tagged=LAN,EOIP vlan-ids=12
add bridge=LAN tagged=LAN,EOIP,sfp-sfpplus1 vlan-ids=10-11,32,41-42,60,62,99
/interface list member
add interface=VLAN12 list=MNDP
/ip address
add address=172.22.12.1/24 comment=ROUTERS interface=VLAN12 network=172.22.12.0
add address=172.22.100.254/24 comment="LOCAL MGMT" interface=ether8 network=172.22.100.0
/ip dhcp-client
add default-route-tables=main interface=ether1 name=DHCP_WAN
/ip dhcp-server
# Interface not running
add address-pool=POOL_MGMT interface=ether8 name=DHCP_MGMT
/ip dhcp-server network
add address=172.22.100.0/24 dns-server=1.1.1.1 gateway=172.22.100.254
/ip dns
set servers=172.22.21.1,172.22.21.2
/ip firewall address-list
add address=172.22.30.1-172.22.30.3 list=mgmt
add address=172.22.99.0/24 list=mgmt
/ip firewall filter
add action=fasttrack-connection chain=forward connection-state=established,related
add action=accept chain=forward comment="ESTABLISHED; RELATED" connection-state=established,related
add action=accept chain=input connection-state=established,related
add action=accept chain=output connection-state=established,related
add action=accept chain=input comment="Connection RT-SRV" dst-address=192.0.2.20 in-interface=ether1 protocol=gre src-address=192.0.2.10
add action=accept chain=output dst-address=192.0.2.10 out-interface=ether1 protocol=gre src-address=192.0.2.20
add action=accept chain=input comment=MGMT dst-address=172.22.12.1 dst-port=80,22,8291 in-interface=VLAN12 protocol=tcp src-address-list=mgmt
add action=accept chain=input dst-address=172.22.100.254 dst-port=80,22,8291 in-interface=ether8 protocol=tcp src-address=172.22.100.0/24
add action=accept chain=forward comment=INTERNET out-interface=ether1 src-address=172.22.100.0/24
add action=accept chain=output out-interface=ether1
add action=accept chain=input comment=SNMP dst-port=161 protocol=udp src-address=172.22.98.0/24
add action=accept chain=output comment=NTP dst-address=172.22.22.0/24 dst-port=123 protocol=udp
add action=accept chain=input comment=PING dst-address=172.22.12.1 protocol=icmp src-address=172.22.98.2
add action=log chain=forward comment=DEBUG disabled=yes
add action=log chain=input disabled=yes
add action=log chain=output disabled=yes
add action=drop chain=forward comment=DROP
add action=drop chain=input
add action=drop chain=output
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1 src-address=172.22.100.0/24
/ip route
add disabled=no dst-address=172.22.0.0/16 gateway=172.22.12.2 routing-table=main
/lcd
set enabled=no
/snmp
set contact=homelab enabled=yes location=homelab
/system clock
set time-zone-name=Europe/Prague
/system identity
set name=RT-USR
/system ntp client
set enabled=yes
/system ntp client servers
add address=172.22.22.1
add address=172.22.22.2