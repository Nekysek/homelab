# 2026-06-22 11:15:10 by RouterOS 7.22.3
#
# model = RBcAPGi-5acD2nD
/interface wireless
# managed by CAPsMAN
# channel: 2412/20-Ce/gn(18dBm), SSID: LAB, CAPsMAN forwarding
set [ find default-name=wlan1 ] ssid=MikroTik
# managed by CAPsMAN
# channel: 5240/20-eeeC/ac/P(20dBm), SSID: LAB, CAPsMAN forwarding
set [ find default-name=wlan2 ] ssid=MikroTik
/interface list
add name=MNDP
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/snmp community
set [ find default=yes ] addresses=172.22.98.0/24
/ip neighbor discovery-settings
set discover-interface-list=MNDP
/interface list member
add interface=ether1 list=MNDP
/interface wireless cap
# 
set certificate=request discovery-interfaces=ether1 enabled=yes interfaces=\
    wlan1,wlan2 lock-to-caps-man=yes
/ip address
add address=172.22.11.2/24 interface=ether1 network=172.22.11.0
/ip dns
set servers=172.22.21.1,172.22.21.2
/ip route
add disabled=no distance=1 dst-address=0.0.0.0/0 gateway=172.22.11.254 \
    routing-table=main scope=30 target-scope=10
/snmp
set contact=homelab enabled=yes location=homelab
/system clock
set time-zone-name=Europe/Prague
/system identity
set name=AP-SRV
/system ntp client
set enabled=yes
/system ntp client servers
add address=172.22.22.1
add address=172.22.22.2