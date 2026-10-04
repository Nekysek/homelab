# Návrh sítě

## Pojmenování a rozmístění

- **Switche:** první písmeno je role (**A** = access, **B** = distribuce/core), druhé je pořadí (**A** = první, **B** = druhý).
  Tedy `AA`, `AB` (přístupové) a `BA` (distribuční/core).
- **Serverovna:** `RT-SRV`, `BA`, `AP-SRV`, hypervisory `KVM1`/`KVM2`, `DATA` a správcovská stanice `ADM01`.
- **Uživatelská místnost (dole):** `RT-USR`, `AA`, `AB`, `AP-USR`.

## L2 a L3

- **Jediný L3 bod je RT-SRV.** Každá VLAN (kromě routerové VLAN 12, kde má RT-SRV adresu `.2`) má na RT-SRV adresu `.254`, která slouží jako výchozí brána. Cisco switche
  (`AA`, `BA`) a MikroTik `AB` jsou v management VLAN 10 a pracují jen jako L2 (mají výchozí bránu `172.22.10.254`).
- **`BA`** (Cisco 2960S) je distribuční/core vrstva. 10G trunk `UPLINK-RT-SRV` nese VLAN 10, 11, 13–16, 20–22, 30, 31,
  50, 60, 61, 63, 98, 99. Hypervisory jsou připojené přes LACP port‑channel (`Po1`, VLAN 10, 13, 20–22, 30, 31, 50, 60, 63, 98),
  souborový server `DATA` přes `Po2` (access VLAN 50) a herní hypervisor `KVM2` přes `Po3` (VLAN 13, 61).
- **`AA`** (Cisco 2960S) a **`AB`** (MikroTik CRS328) jsou přístupové switche v uživatelské místnosti (spolu s `RT-USR`).
  Spojení se serverovnou zajišťuje **EoIP tunel** mezi RT-USR a RT-SRV (MTU 1400) vedený přes cizí L3 síť.
- Na hypervisorech je **LACP bond** (`802.3ad`) se sub‑rozhraními `bond0.<VLAN>`, každé zapojené do mostu `br<VLAN>`,
  takže virtuální stroje se připojují přímo do libovolné VLAN (viz [`configs/kvm`](../configs/kvm)).

## Firewall na RT-SRV

Politika `forward`, `input` i `output` končí **`drop`**. Povolené jsou jen tyto toky:

| Tok | Pravidlo |
|---|---|
| Navázané spojení | `established,related` + fasttrack |
| Správa | adresní seznam `mgmt` (VPN `172.22.30.1–3` + VLAN 99) má plný přístup |
| Internet | jen zdroje v seznamu `internet` (vybrané VLAN a servery) |
| DNS | ven smí jen resolvery v seznamu `dns` – ostatním se port 53 na WAN blokuje |
| Interní DNS / NTP | z celé `172.22.0.0/16` na servery `.21.1–2` a `.22.1–2` |
| `trusted` → `tabulky` | VLAN 42 → VLAN 60 |
| `trusted` → `DATA` | VLAN 42 → `172.22.50.3:445` (SMB) |
| `images` → `DATA` | VLAN 41 → `172.22.50.3:445` (SMB) |
| SNMP | jen ze zálohovací/monitorovací VLAN 98 |
| RADIUS | RT-SRV → RADIUS servery, UDP 1812 |

Ostatní zařízení mají stejnou filozofii: `input` povolen jen ze správcovských adres, zbytek `drop`.
Lokální management port (`ether8`, `172.22.100.0/24`) slouží jako záložní vstup mimo produkční VLAN.

## DHCP relay

RT-SRV předává DHCP dotazy z VLAN 40, 41, 42, 60, 62, 99 oběma DHCP serverům (`172.22.20.1`, `172.22.20.2`).
VLAN 61 a 63 DHCP z relaye nepoužívají.

## Wi‑Fi (CAPsMAN)

- Řídí RT-SRV (CAPsMAN manager na rozhraní VLAN 11), přístupové body `AP-USR` a `AP-SRV` se připojují jako CAP. Oba mají
  téměř shodnou konfiguraci (liší se jen jménem a IP adresou), proto je v repozitáři jen [`AP-SRV.rsc`](../configs/routeros/AP-SRV.rsc).
- Dvě konfigurace, 2,4 GHz (kanál 1) a 5 GHz (kanál 48), WPA2‑PSK (AES‑CCM), `vlan-mode=use-tag`.
- Přístup klientů rozhoduje **RADIUS** (`caps-man access-list … action=query-radius`) – viz
  [autentizace](04-authentication.md). Klient dostane VLAN podle záznamu, neznámé Wi‑Fi zařízení skončí ve VLAN 40 (host), neznámé kabelové ve VLAN 41 (images).

## IPv6

IPv6 se v síti nepoužívalo (v konfiguracích RouterOS není žádná IPv6 část).
