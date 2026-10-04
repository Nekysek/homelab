# 2026-06-21 12:51:24 by RouterOS 7.22.3
#
# model = CCR1009-8G-1S-1S+
/interface bridge
add mtu=1500 name=LAN vlan-filtering=yes
add admin-mac=00:00:5e:00:53:01 auto-mac=no mtu=1500 name=WAN
/interface ethernet
set [ find default-name=ether4 ] disabled=yes
set [ find default-name=ether5 ] disabled=yes
set [ find default-name=ether6 ] disabled=yes
set [ find default-name=ether7 ] disabled=yes
set [ find default-name=sfp1 ] disabled=yes
/interface eoip
add allow-fast-path=no local-address=192.0.2.10 mac-address=00:00:5e:00:53:02 mtu=1400 name=EOIP remote-address=192.0.2.20 tunnel-id=1
/interface vlan
add interface=LAN name=VLAN10 vlan-id=10
add interface=LAN name=VLAN11 vlan-id=11
add interface=LAN name=VLAN12 vlan-id=12
add interface=LAN name=VLAN13 vlan-id=13
add interface=LAN name=VLAN14 vlan-id=14
add interface=LAN name=VLAN15 vlan-id=15
add interface=LAN name=VLAN16 vlan-id=16
add interface=LAN name=VLAN20 vlan-id=20
add interface=LAN name=VLAN21 vlan-id=21
add interface=LAN name=VLAN22 vlan-id=22
add interface=LAN name=VLAN30 vlan-id=30
add interface=LAN name=VLAN31 vlan-id=31
add interface=LAN name=VLAN32 vlan-id=32
add interface=LAN name=VLAN40 vlan-id=40
add interface=LAN name=VLAN41 vlan-id=41
add interface=LAN name=VLAN42 vlan-id=42
add interface=LAN name=VLAN50 vlan-id=50
add interface=LAN name=VLAN60 vlan-id=60
add interface=LAN name=VLAN61 vlan-id=61
add interface=LAN name=VLAN62 vlan-id=62
add interface=LAN name=VLAN63 vlan-id=63
add interface=LAN name=VLAN98 vlan-id=98
add interface=LAN name=VLAN99 vlan-id=99
/caps-man security
add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm name=default
/caps-man configuration
add channel.band=2ghz-b/g/n .frequency=2412 country="czech republic" datapath.bridge=LAN .vlan-mode=use-tag installation=indoor mode=ap name=2Ghz security=\
    default ssid=LAB
add channel.band=5ghz-a/n/ac .frequency=5240 country="czech republic" datapath.bridge=LAN .vlan-mode=use-tag installation=indoor mode=ap name=5Ghz security=\
    default ssid=LAB
/interface list
add name=MNDP
/interface wireless security-profiles
set [ find default=yes ] radius-mac-authentication=yes supplicant-identity=MikroTik
/ip pool
add name=POOL_MGMT ranges=172.22.100.1-172.22.100.253
/snmp community
set [ find default=yes ] addresses=172.22.98.0/24
/caps-man access-list
add action=query-radius disabled=no mac-address=00:00:00:00:00:00 mac-address-mask=00:00:00:00:00:00
/caps-man manager
set ca-certificate=auto certificate=auto enabled=yes
/caps-man manager interface
set [ find default=yes ] forbid=yes
add disabled=no interface=VLAN11
/caps-man provisioning
add action=create-dynamic-enabled hw-supported-modes=gn master-configuration=2Ghz name-format=prefix-identity name-prefix=2Ghz
add action=create-dynamic-enabled hw-supported-modes=ac master-configuration=5Ghz name-format=prefix-identity name-prefix=5Ghz
/interface bridge port
add bridge=WAN interface=ether1
add bridge=WAN interface=ether2
add bridge=WAN interface=ether3
add bridge=LAN interface=sfp-sfpplus1
add bridge=LAN interface=EOIP
/ip neighbor discovery-settings
set discover-interface-list=MNDP
/interface bridge vlan
add bridge=LAN tagged=LAN,sfp-sfpplus1 vlan-ids=13-16,20-22,30-31,50,61,63,96,98
add bridge=LAN tagged=LAN,EOIP vlan-ids=12,32,41-42,62
add bridge=LAN tagged=LAN,sfp-sfpplus1,EOIP vlan-ids=10-11,60,99
add bridge=LAN tagged=LAN vlan-ids=40
/interface list member
add interface=VLAN10 list=MNDP
add interface=EOIP list=MNDP
add interface=VLAN11 list=MNDP
add interface=VLAN12 list=MNDP
add interface=sfp-sfpplus1 list=MNDP
/ip address
add address=172.22.10.254/24 comment="MGMT - SW + RADIUS" interface=VLAN10 network=172.22.10.0
add address=172.22.11.254/24 comment="MGMT - AP" interface=VLAN11 network=172.22.11.0
add address=172.22.12.2/24 comment="MGMT - RT + FW" interface=VLAN12 network=172.22.12.0
add address=172.22.13.254/24 comment="MGMT - HYPER" interface=VLAN13 network=172.22.13.0
add address=172.22.20.254/24 comment=DHCP interface=VLAN20 network=172.22.20.0
add address=172.22.21.254/24 comment=DNS interface=VLAN21 network=172.22.21.0
add address=172.22.22.254/24 comment=NTP interface=VLAN22 network=172.22.22.0
add address=172.22.30.254/24 comment=VPN interface=VLAN30 network=172.22.30.0
add address=172.22.31.254/24 comment=CA interface=VLAN31 network=172.22.31.0
add address=172.22.32.254/24 comment=AUDIO interface=VLAN32 network=172.22.32.0
add address=172.22.40.254/24 comment="WIFI GUEST" interface=VLAN40 network=172.22.40.0
add address=172.22.41.254/24 comment=IMAGES interface=VLAN41 network=172.22.41.0
add address=172.22.42.254/24 comment=TRUSTED interface=VLAN42 network=172.22.42.0
add address=172.22.50.254/24 comment=AD interface=VLAN50 network=172.22.50.0
add address=172.22.60.254/24 comment=TABULKY interface=VLAN60 network=172.22.60.0
add address=172.22.61.254/24 comment="GAMES VM" interface=VLAN61 network=172.22.61.0
add address=172.22.62.254/24 comment="IP TELEFONY" interface=VLAN62 network=172.22.62.0
add address=172.22.63.254/24 comment=LAB interface=VLAN63 network=172.22.63.0
add address=172.22.99.254/24 comment=ADMIN interface=VLAN99 network=172.22.99.0
add address=172.22.98.254/24 comment=BACKUP interface=VLAN98 network=172.22.98.0
add address=172.22.100.254/24 comment="LOCAL MGMT" interface=ether8 network=172.22.100.0
add address=172.22.14.254/24 comment="MGMT - MON" interface=VLAN14 network=172.22.14.0
add address=172.22.15.254/24 comment="MGMT - AUTO" interface=VLAN15 network=172.22.15.0
add address=172.22.16.254/24 comment="MGMT - SRV" interface=VLAN16 network=172.22.16.0
/ip dhcp-client
add default-route-tables=main interface=WAN name=WAN
/ip dhcp-relay
add dhcp-server=172.22.20.1,172.22.20.2 disabled=no interface=VLAN40 local-address=172.22.40.254 name=RELAY-VLAN40
add dhcp-server=172.22.20.1,172.22.20.2 disabled=no interface=VLAN41 local-address=172.22.41.254 name=RELAY-VLAN41
add dhcp-server=172.22.20.1,172.22.20.2 disabled=no interface=VLAN42 local-address=172.22.42.254 name=RELAY-VLAN42
add dhcp-server=172.22.20.1,172.22.20.2 disabled=no interface=VLAN60 local-address=172.22.60.254 name=RELAY-VLAN60
add dhcp-server=172.22.20.1,172.22.20.2 disabled=no interface=VLAN62 local-address=172.22.62.254 name=RELAY-VLAN62
add dhcp-server=172.22.20.1,172.22.20.2 disabled=no interface=VLAN99 local-address=172.22.99.254 name=RELAY-VLAN99
/ip dhcp-server
# Interface not running
add address-pool=POOL_MGMT interface=ether8 name=DHCP_MGMT
/ip dhcp-server network
add address=172.22.100.0/24 dns-server=172.22.21.1,172.22.21.2 gateway=172.22.100.254
/ip dns
set servers=172.22.21.1,172.22.21.2
/ip firewall address-list
add address=172.22.30.1-172.22.30.3 comment=MGMT list=mgmt
add address=172.22.99.0/24 list=mgmt
add address=172.22.21.1-172.22.21.2 comment=DNS list=dns
add address=172.22.40.0/24 comment="VLAN40 guest wifi" list=internet
add address=172.22.41.0/24 comment="VLAN41 images" list=internet
add address=172.22.42.0/24 comment="VLAN42 trusted" list=internet
add address=172.22.61.0/24 comment="VLAN61 games" list=internet
add address=172.22.62.0/24 comment="VLAN62 ip phones" list=internet
add address=172.22.63.0/24 comment="VLAN63 lab" list=internet
add address=172.22.96.0/24 comment="VLAN96 backup" list=internet
add address=172.22.60.1 comment="tables server" list=internet
add address=172.22.10.2 comment=AB list=internet
add address=172.22.10.200/31 comment=RADIUS list=internet
add address=172.22.11.1-172.22.11.2 comment="AP-USR and AP-SRV" list=internet
add address=172.22.12.1 comment=RT-USR list=internet
add address=172.22.13.1-172.22.13.2 comment=KVM list=internet
add address=172.22.20.1-172.22.20.2 comment=DHCP list=internet
add address=172.22.21.1-172.22.21.2 comment=DNS list=internet
add address=172.22.22.1-172.22.22.2 comment=NTP list=internet
add address=172.22.31.1 comment=CA list=internet
add address=172.22.32.1 comment=audio list=internet
add address=172.22.50.1-172.22.50.3 comment=LAD list=internet
add address=172.22.14.1-172.22.14.2 comment=MON list=internet
add address=172.22.15.1 comment=AUTO list=internet
add address=172.22.16.1 comment=SRV list=internet
add address=172.22.100.0/24 list=internet
/ip firewall filter
add action=fasttrack-connection chain=forward connection-state=established,related
add action=accept chain=forward comment="ESTABLISHED; RELATED" connection-state=established,related
add action=accept chain=input connection-state=established,related
add action=accept chain=output connection-state=established,related
add action=accept chain=input comment="Connection RT-USR" dst-address=192.0.2.10 in-interface=WAN protocol=gre src-address=192.0.2.20
add action=accept chain=output dst-address=192.0.2.20 out-interface=WAN protocol=gre src-address=192.0.2.10
add action=accept chain=forward comment="ADMIN; VPN FULL ACCESS" src-address-list=mgmt
add action=accept chain=input src-address-list=mgmt
add action=accept chain=input comment="LOCAL MGMT" dst-address=172.22.100.254 dst-port=80,22,8291 in-interface=ether8 protocol=tcp src-address=172.22.100.0/24
add action=drop chain=forward comment="BLOCK DNS" dst-port=53 out-interface=WAN protocol=udp src-address-list=!dns
add action=accept chain=forward comment=INTERNET out-interface=WAN src-address-list=internet
add action=accept chain=output out-interface=WAN
add action=accept chain=input comment=PING in-interface=!WAN protocol=icmp
add action=accept chain=input comment=DHCP dst-port=67-68 protocol=udp
add action=accept chain=output dst-port=67-68 protocol=udp src-port=67-68
add action=accept chain=output comment=DNS dst-address-list=dns dst-port=53 protocol=udp
add action=accept chain=forward dst-address-list=dns dst-port=53 protocol=udp src-address=172.22.0.0/16
add action=accept chain=forward comment="TRUSTED TO TABLES" dst-address=172.22.60.0/24 src-address=172.22.42.0/24
add action=accept chain=output comment=RADIUS dst-address=172.22.10.201-172.22.10.202 dst-port=1812 out-interface=VLAN10 protocol=udp src-address=172.22.10.254
add action=accept chain=input comment=SNMP dst-port=161 protocol=udp src-address=172.22.98.0/24
add action=accept chain=forward comment=NTP dst-address=172.22.22.1-172.22.22.2 dst-port=123 protocol=udp src-address=172.22.0.0/16
add action=accept chain=forward comment="TRUSTED TO AD" dst-address=172.22.50.3 dst-port=445 protocol=tcp src-address=172.22.42.0/24
add chain=forward comment="IMAGES TO DATA" dst-address=172.22.50.3 dst-port=445 protocol=tcp src-address=172.22.41.0/24
add action=log chain=forward comment=DEBUG disabled=yes
add action=log chain=input disabled=yes
add action=log chain=output disabled=yes
add action=drop chain=forward comment=DROP
add action=drop chain=input
add action=drop chain=output
/ip firewall nat
add action=masquerade chain=srcnat comment=INTERNET out-interface=WAN
add action=dst-nat chain=dstnat dst-address=192.0.2.10 dst-port=22 protocol=tcp src-address=198.51.100.0/24 to-addresses=172.22.30.3 to-ports=22
/radius
add address=172.22.10.200 service=wireless src-address=172.22.10.254
add address=172.22.10.201 service=wireless src-address=172.22.10.254
/snmp
set contact=homelab enabled=yes location=homelab
/system clock
set time-zone-name=Europe/Prague
/system identity
set name=RT-SRV
/system ntp client
set enabled=yes
/system ntp client servers
add address=172.22.22.1
add address=172.22.22.2