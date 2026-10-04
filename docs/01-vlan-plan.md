# Plán VLAN a adresace

Všechny VLAN používají schéma **`172.22.<VLAN ID>.0/24`** – třetí oktet odpovídá číslu VLAN, takže se dá adresa i VLAN poznat z druhé. Výchozí brána sítí je `.254` na routeru **RT-SRV**; výjimkou je routerová VLAN 12, kde má RT-SRV adresu `.2`.

Celkem **23 VLAN**.

| VLAN | Síť | Role | Skupina | Brána | Hosté (počet) |
|---|---|---|---|---|---|
| 10 | `172.22.10.0/24` | mgmt - sw + radius | Správa | `172.22.10.254` | 5 |
| 11 | `172.22.11.0/24` | mgmt - ap | Správa | `172.22.11.254` | 2 |
| 12 | `172.22.12.0/24` | mgmt - rt + fw | Správa | – (RT-SRV = `.2`) | 2 |
| 13 | `172.22.13.0/24` | mgmt - hyper | Správa | `172.22.13.254` | 2 |
| 14 | `172.22.14.0/24` | mgmt - mon | Správa | `172.22.14.254` | 4 |
| 15 | `172.22.15.0/24` | mgmt - auto | Správa | `172.22.15.254` | 1 |
| 16 | `172.22.16.0/24` | mgmt - srv | Správa | `172.22.16.254` | 1 |
| 20 | `172.22.20.0/24` | dhcp | Síťové služby | `172.22.20.254` | 2 |
| 21 | `172.22.21.0/24` | dns | Síťové služby | `172.22.21.254` | 2 |
| 22 | `172.22.22.0/24` | ntp | Síťové služby | `172.22.22.254` | 2 |
| 30 | `172.22.30.0/24` | vpn | VPN a PKI | `172.22.30.254` | 3 |
| 31 | `172.22.31.0/24` | ca | VPN a PKI | `172.22.31.254` | 1 |
| 32 | `172.22.32.0/24` | audio | Ostatní služby | `172.22.32.254` | 1 |
| 40 | `172.22.40.0/24` | wifi guest | Klienti | `172.22.40.254` | pool |
| 41 | `172.22.41.0/24` | images | Klienti | `172.22.41.254` | pool |
| 42 | `172.22.42.0/24` | trusted | Klienti | `172.22.42.254` | pool |
| 50 | `172.22.50.0/24` | ad | Adresářové služby | `172.22.50.254` | 3 |
| 60 | `172.22.60.0/24` | tabulky | Ostatní služby | `172.22.60.254` | 2 |
| 61 | `172.22.61.0/24` | games vm | Ostatní služby | `172.22.61.254` | pool |
| 62 | `172.22.62.0/24` | ip telefony | Ostatní služby | `172.22.62.254` | pool |
| 63 | `172.22.63.0/24` | lab | Ostatní služby | `172.22.63.254` | pool |
| 98 | `172.22.98.0/24` | backup | Zálohy a administrace | `172.22.98.254` | 2 |
| 99 | `172.22.99.0/24` | admin | Zálohy a administrace | `172.22.99.254` | 1 |

## Poznámky k adresaci

- Dvojice redundantních služeb používají adresy `.1` a `.2` (RADIUS `.200/.201` ve VLAN 10 je výjimka).
- VLAN 12 (routery): RT-USR = `172.22.12.1`, RT-SRV = `172.22.12.2` – zde RT-SRV nemá `.254`. *TODO: ověřit, jestli je to záměr.*
- VLAN 40, 41, 42, 61, 62, 63 jsou určené pro klienty/pooly bez pevných serverů (rozsah 1–253).
- VLAN 60 má klientský DHCP pool `172.22.60.10–253` pro e-ink tabulky.

## Účel vybraných VLAN

- **VLAN 32 (audio):** jeden Linux počítač s reproduktory připojenými přes jack a s Bluetooth (`bluez` + PulseAudio).
  Lidé v kanceláři se k němu připojili přes Bluetooth a přehrávali hudbu.
- **VLAN 41 (images):** záložní VLAN pro **kabelová** zařízení na přístupových portech `AA`. Zařízení, které není
  v tabulce RADIUS, skončí zde, vidí souborový server `DATA` (sdílení `images`) a lze z něj imagovat počítače.
- **VLAN 61 (games):** herní VM na `KVM2`, povolený je jen přístup na internet.
- **VLAN 40 (host):** záložní VLAN pro neznámá **Wi‑Fi** zařízení.
- **VLAN 42 (trusted):** ověřená zařízení (MAC v tabulce RADIUS) – po kabelu i po Wi‑Fi.

## Přidělování adres: DHCP a statické

| Kde | Jak | Poznámka |
|---|---|---|
| VLAN 10–16, 20–22, 30–32, 50, 98 | **statické** | síťové prvky, hypervisory, všechny servery a VM (včetně samotných DHCP serverů) |
| VLAN 61 (games), 63 (lab) | **statické** | na RT-SRV pro ně není DHCP relay |
| VLAN 40 (host Wi‑Fi) | **DHCP – pool** | ISC DHCP failover, lease 1 h |
| VLAN 41 (images) | **DHCP – pool** | ISC DHCP failover, lease 8 h |
| VLAN 42, 60, 62, 99 | **DHCP – jen rezervace** | `deny unknown-clients`, lease 24 h; cizí zařízení adresu nedostane |
| lokální management port RT-SRV (`172.22.100.0/24`) | DHCP server na RouterOS | záložní vstup mimo produkční VLAN |
| WAN RT-SRV / RT-USR | DHCP klient | adresa od uplinku |

DHCP relay na RT-SRV předává dotazy z VLAN 40, 41, 42, 60, 62 a 99 oběma DHCP serverům (`172.22.20.1–2`).

