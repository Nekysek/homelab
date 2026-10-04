# Seznam zařízení a služeb

Přehled podle VLAN podle návrhové tabulky; sloupec *Typ* doplňuje, co bylo fyzické zařízení a co virtuální stroj.

## VLAN 10 – mgmt - sw + radius

| Hostname | IP | OS | Software | Typ | Poznámka |
|---|---|---|---|---|---|
| AA | 172.22.10.1 | cisco ios | – | síťové zařízení | access |
| AB | 172.22.10.2 | mikrotik routeros | – | síťové zařízení | access |
| BA | 172.22.10.100 | cisco ios | – | síťové zařízení | distribution + core |
| RADIUS1 | 172.22.10.200 | almalinux 9.7 | freeradius | VM (KVM1) | – |
| RADIUS2 | 172.22.10.201 | almalinux 9.7 | freeradius | VM (KVM1) | – |

## VLAN 11 – mgmt - ap

| Hostname | IP | OS | Software | Typ | Poznámka |
|---|---|---|---|---|---|
| AP-USR | 172.22.11.1 | mikrotik routeros | – | síťové zařízení | – |
| AP-SRV | 172.22.11.2 | mikrotik routeros | – | síťové zařízení | – |

## VLAN 12 – mgmt - rt + fw

| Hostname | IP | OS | Software | Typ | Poznámka |
|---|---|---|---|---|---|
| RT-USR | 172.22.12.1/24 | mikrotik routeros | – | síťové zařízení | eoip rozšíření lan do kanceláře |
| RT-SRV | 172.22.12.2/24 | mikrotik routeros | – | síťové zařízení | routing + fw + capsmann + eoip endpoint |

## VLAN 13 – mgmt - hyper

| Hostname | IP | OS | Software | Typ | Poznámka |
|---|---|---|---|---|---|
| KVM1 | 172.22.13.1 | almalinux 9.7 | kvm + qemu + libvirt + cockpit | fyzický server | – |
| KVM2 | 172.22.13.2 | almalinux 9.7 | kvm + qemu + libvirt + cockpit | fyzický server | – |

## VLAN 14 – mgmt - mon

> Stav: navrženo v plánu adres, **nedokončeno** (nenasazeno).

| Hostname | IP | OS | Software | Typ | Poznámka |
|---|---|---|---|---|---|
| PROMETHEUS | 172.22.14.1 | almalinux 9.7 | prometheus | návrh (nenasazeno) | – |
| GRAFANA | 172.22.14.2 | almalinux 9.7 | grafana | návrh (nenasazeno) | – |
| – | 172.22.14.3 | almalinux 9.7 | isc stork | návrh (nenasazeno) | – |
| – | 172.22.14.4 | almalinux 9.7 | – | návrh (nenasazeno) | – |

## VLAN 15 – mgmt - auto

> Stav: navrženo v plánu adres, **nedokončeno** (nenasazeno).

| Hostname | IP | OS | Software | Typ | Poznámka |
|---|---|---|---|---|---|
| AUTO | 172.22.15.1 | almalinux 9.7 | ansible | návrh (nenasazeno) | – |

## VLAN 16 – mgmt - srv

| Hostname | IP | OS | Software | Typ | Poznámka |
|---|---|---|---|---|---|
| KVM-SW | 172.22.16.1 | CS1716i | V2.2.215 | fyzické zařízení | – |

## VLAN 20 – dhcp

| Hostname | IP | OS | Software | Typ | Poznámka |
|---|---|---|---|---|---|
| DHCP1 | 172.22.20.1 | almalinux 9.7 | isc dhcp | VM (KVM1) | – |
| DHCP2 | 172.22.20.2 | almalinux 9.7 | isc dhcp | VM (KVM1) | – |

## VLAN 21 – dns

| Hostname | IP | OS | Software | Typ | Poznámka |
|---|---|---|---|---|---|
| DNS1 | 172.22.21.1 | almalinux 9.7 | bind | VM (KVM1) | – |
| DNS2 | 172.22.21.2 | almalinux 9.7 | bind | VM (KVM1) | – |

## VLAN 22 – ntp

| Hostname | IP | OS | Software | Typ | Poznámka |
|---|---|---|---|---|---|
| NTP1 | 172.22.22.1 | almalinux 9.7 | chrony | VM (KVM1) | – |
| NTP2 | 172.22.22.2 | almalinux 9.7 | chrony | VM (KVM1) | – |

## VLAN 30 – vpn

| Hostname | IP | OS | Software | Typ | Poznámka |
|---|---|---|---|---|---|
| VPN1 | 172.22.30.1 | almalinux 9.7 | tailscale | VM (KVM1) | – |
| VPN2 | 172.22.30.2 | almalinux 9.7 | tailscale | VM (KVM1) | – |
| VPN3 | 172.22.30.3 | almalinux 9.7 | openvpn | VM (KVM1) | – |

## VLAN 31 – ca

| Hostname | IP | OS | Software | Typ | Poznámka |
|---|---|---|---|---|---|
| CA | 172.22.31.1 | almalinux 9.7 | openssl | VM (KVM1) | – |

## VLAN 32 – audio

| Hostname | IP | OS | Software | Typ | Poznámka |
|---|---|---|---|---|---|
| AUDIO | 172.22.32.1 | almalinux 9.7 | pulseaudio + bluez | fyzický počítač | reproduktory + Bluetooth |

## VLAN 40 – wifi guest

- Pool: **pool hosti wifi** (1-253)
- Pool: **RT-SRV** (172.22.40.254/24)

## VLAN 41 – images

- Pool: **pool images** (1-253)
- Pool: **RT-SRV** (172.22.41.254/24)

## VLAN 42 – trusted

- Pool: **pool trusted** (1-253)
- Pool: **RT-SRV** (172.22.42.254/24)

## VLAN 50 – ad

| Hostname | IP | OS | Software | Typ | Poznámka |
|---|---|---|---|---|---|
| DC1 | 172.22.50.1 | almalinux 9.7 | samba | VM (KVM1) | – |
| DC2 | 172.22.50.2 | almalinux 9.7 | samba | VM (KVM1) | – |
| DATA | 172.22.50.3 | almalinux 9.7 | samba | fyzický server | – |

## VLAN 60 – tabulky

| Hostname | IP | OS | Software | Typ | Poznámka |
|---|---|---|---|---|---|
| tables | 172.22.60.1 | almalinux 9.7 | wine | VM (KVM1) | – |
| dhcp pool klienti | 172.22.60.10-253 | – | e-ink tabulky | – | – |

## VLAN 61 – games vm

- Pool: **herní vm** (1-253)
- Pool: **RT-SRV** (172.22.61.254/24)

## VLAN 62 – ip telefony

- Pool: **pool ip telefony** (1-253)
- Pool: **RT-SRV** (172.22.62.254/24)

## VLAN 63 – lab

- Pool: **lab** (1-253)
- Pool: **RT-SRV** (172.22.63.254/24)

## VLAN 98 – backup

> Stav: navrženo v plánu adres, **nedokončeno** (nenasazeno).

| Hostname | IP | OS | Software | Typ | Poznámka |
|---|---|---|---|---|---|
| BACKUP | 172.22.98.1 | almalinux 9.7 | bacula | návrh (nenasazeno) | – |
| – | předělat asi na zálohování konfigurací | – | – | návrh (nenasazeno) | – |

## VLAN 99 – admin

| Hostname | IP | OS | Software | Typ | Poznámka |
|---|---|---|---|---|---|
| ADM01 | 172.22.99.9 | windows 10 pro | rsat + winbox | fyzická stanice | – |

