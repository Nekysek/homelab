# 2026-06-21 22:47:11 by RouterOS 7.23.1
#
# model = CRS328-24P-4S+
/interface bridge
add name=LAN vlan-filtering=yes
/interface ethernet
set [ find default-name=ether5 ] disabled=yes
set [ find default-name=ether7 ] disabled=yes
set [ find default-name=ether8 ] disabled=yes
set [ find default-name=ether9 ] disabled=yes
set [ find default-name=ether10 ] disabled=yes
set [ find default-name=ether11 ] disabled=yes
set [ find default-name=ether12 ] disabled=yes
set [ find default-name=ether13 ] disabled=yes
set [ find default-name=ether14 ] disabled=yes
set [ find default-name=ether15 ] disabled=yes
set [ find default-name=ether16 ] disabled=yes
set [ find default-name=ether17 ] disabled=yes
set [ find default-name=ether18 ] disabled=yes
set [ find default-name=ether19 ] disabled=yes
set [ find default-name=ether20 ] disabled=yes
set [ find default-name=ether21 ] disabled=yes
set [ find default-name=ether22 ] disabled=yes
set [ find default-name=ether23 ] disabled=yes
set [ find default-name=ether24 ] disabled=yes
/interface vlan
add interface=LAN name=VLAN10 vlan-id=10
/interface list
add name=MNDP
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/snmp community
set [ find default=yes ] addresses=172.22.98.0/24
/interface bridge port
add bridge=LAN interface=ether6 pvid=11
add bridge=LAN interface=sfp-sfpplus4
add bridge=LAN interface=ether1
add bridge=LAN interface=ether2
add bridge=LAN interface=ether3
add bridge=LAN interface=ether4
/ip neighbor discovery-settings
set discover-interface-list=MNDP
/interface bridge vlan
add bridge=LAN tagged=LAN,sfp-sfpplus4 untagged=ether6 vlan-ids=11
add bridge=LAN tagged=LAN,sfp-sfpplus4 vlan-ids=10
add bridge=LAN tagged=sfp-sfpplus4,LAN vlan-ids=60
/interface dot1x server
add auth-types=mac-auth interface=ether1
add auth-types=mac-auth interface=ether2
add auth-types=mac-auth interface=ether3
add auth-types=mac-auth interface=ether4
/interface list member
add interface=VLAN10 list=MNDP
/ip address
add address=172.22.10.2/24 interface=VLAN10 network=172.22.10.0
/ip dns
set servers=172.22.21.1,172.22.21.2
/ip firewall address-list
add address=172.22.30.1-172.22.30.3 list=mgmt
add address=172.22.99.0/24 list=mgmt
/ip firewall filter
add action=fasttrack-connection chain=forward connection-state=\
    established,related
add action=accept chain=forward comment="ESTABLISHED; RELATED" connection-state=\
    established,related
add action=accept chain=input connection-state=established,related
add action=accept chain=output connection-state=established,related
add action=accept chain=input comment=MGMT dst-address=172.22.10.2 dst-port=\
    22,80,8291 in-interface=VLAN10 protocol=tcp src-address-list=mgmt
add action=accept chain=output comment=INTERNET out-interface=VLAN10
add action=accept chain=input comment=PING dst-address=172.22.10.2 protocol=icmp \
    src-address=172.22.98.2
add action=accept chain=input comment=SNMP dst-port=161 protocol=udp \
    src-address=172.22.98.0/24
add action=log chain=forward comment=DEBUG disabled=yes
add action=log chain=input disabled=yes
add action=log chain=output disabled=yes
add action=drop chain=forward comment=DROP
add action=drop chain=input
add action=drop chain=output
/ip route
add disabled=no dst-address=0.0.0.0/0 gateway=172.22.10.254 routing-table=main \
    suppress-hw-offload=no
/radius
add address=172.22.10.200 service=dot1x src-address=172.22.10.2 timeout=3s
add address=172.22.10.201 service=dot1x src-address=172.22.10.2 timeout=3s
/snmp
set contact=homelab enabled=yes location=homelab
/system clock
set time-zone-name=Europe/Prague
/system identity
set name=AB
/system ntp client
set enabled=yes
/system ntp client servers
add address=172.22.22.1
add address=172.22.22.2