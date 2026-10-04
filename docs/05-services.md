# Služby

## DHCP – ISC DHCP s failoverem (VLAN 20)

- `DHCP1` (primary) a `DHCP2` (secondary) tvoří **failover peer** (port 647, `mclt 1800`, `split 128`, load balance).
  Konfigurace: [`dhcpd-primary.conf`](../configs/dhcp/dhcpd-primary.conf),
  [`dhcpd-secondary.conf`](../configs/dhcp/dhcpd-secondary.conf), [`subnets.conf`](../configs/dhcp/subnets.conf).
- Sítě s poolem: **VLAN 40** (host, lease 1 h) a **VLAN 41** (images, lease 8 h).
- Sítě jen s rezervacemi (`deny unknown-clients`, lease 24 h): **VLAN 42, 60, 62, 99**.
- Soubor s rezervacemi je **generovaný** (v hlavičce `NEUPRAVOVAT RUČNĚ`), vzor je v
  [`reservations.example.conf`](../configs/dhcp/reservations.example.conf).

## DNS – BIND (VLAN 21)

- `DNS1` je **master** a `DNS2` **secondary** pro zónu `lab.local` (přenos zóny AXFR + NOTIFY; v logu je vidět
  úspěšný přenos po změně sériového čísla). Zóna je DNS pro celou síť a obsahuje i další záznamy než jen AD
  ([`lab.local.zone`](../configs/dns/lab.local.zone)).
- **Doména AD `lab.lad` je oddělená** a slouží čistě pro Samba AD. Samba DC mají BIND servery jako `dns forwarder`.
- Externí jména překládají BIND servery přes **Cloudflare** (`1.1.1.1`, `1.0.0.1`) jako forwarder – viz
  [referenční konfiguraci](examples/named.conf.reference).
  RT-SRV zakazuje odchozí port 53 všem ostatním zdrojům, takže všichni klienti používají `DNS1`/`DNS2`.
- Klienti dostávají oba servery přes DHCP.

## NTP – Chrony (VLAN 22)

Dva servery synchronizované s `time.cloudflare.com` a `*.cz.pool.ntp.org`, vydávají čas celé síti `172.22.0.0/16`
(`local stratum 8` jako záloha při výpadku upstreamu). Všechna MikroTik zařízení mají za zdroj času oba servery
([`chrony.conf`](../configs/ntp/chrony.conf)).

## Adresářové služby – Samba AD (VLAN 50)

- Dva doménové řadiče `DC1`, `DC2` (role *active directory domain controller*, realm `LAB.LAD`) vytvořené standardním
  `samba-tool domain provision`; konfigurace [`dc1.smb.conf`](../configs/samba/dc1.smb.conf),
  [`dc2.smb.conf`](../configs/samba/dc2.smb.conf).
- Souborový server `DATA` je členem domény ([`data.smb.conf`](../configs/samba/data.smb.conf)): `security = ADS`,
  winbind s `idmap … rid`, `vfs objects = acl_xattr`, `access based share enum`, `ntlm auth = ntlmv2-only`.
  Sdílení `homes`, `data`, `images`. Domovské adresáře se vytvářejí při prvním přihlášení skriptem
  ([`data-create-home.sh`](../configs/samba/data-create-home.sh)) volaným přes `root preexec`, oprávnění hromadně
  sjednocuje [`data-fix-permissions.sh`](../configs/samba/data-fix-permissions.sh).
- K SMB na `DATA` se smí z jiných VLAN dostat jen `trusted` (42), `images` (41) a správcovské adresy (seznam `mgmt`).

## Virtualizace (VLAN 13)

Dva fyzické hypervisory na AlmaLinux 9.7 (KVM/QEMU, libvirt, Cockpit):

- **`KVM1`** hostoval infrastrukturní služby (15 VM níže).
- **`KVM2`** byl určený pro **herní servery** – ty byly ve své VLAN 61 a měly povolený **pouze přístup na internet**
  (VLAN 61 je na RT-SRV jen v seznamu `internet`, bez výjimek do vnitřní sítě).

Síť na hypervisorech: `bond0` (LACP `802.3ad`, dvě fyzická rozhraní) → sub‑rozhraní `bond0.<VLAN>` → most `br<VLAN>`
(VLAN 10, 13, 20–22, 30, 31, 50, 60, 63, 98). Ukázka v [`configs/kvm`](../configs/kvm).

### Virtuální stroje na KVM1

Všechny VM mají shodný profil: 2 vCPU, 2 GiB RAM, disk `qcow2` (úložiště `/data/vms`, ISO v `/data/iso`),
síťová karta `virtio` a CPU `host-passthrough`, konzole VNC. Definice vycházejí ze záloh libvirt.

| VM | Most (VLAN) | Služba |
|---|---|---|
| `radius1`, `radius2` | `br10` (10) | FreeRADIUS |
| `dhcp1`, `dhcp2` | `br20` (20) | ISC DHCP (failover) |
| `dns1`, `dns2` | `br21` (21) | BIND |
| `ntp1`, `ntp2` | `br22` (22) | Chrony |
| `vpn1`, `vpn2`, `vpn3` | `br30` (30) | Tailscale ×2, OpenVPN |
| `ca` | `br31` (31) | interní CA (OpenSSL) |
| `dc1`, `dc2` | `br50` (50) | Samba AD DC |
| `tables` | `br60` (60) | e‑ink tabulky |

Obě instance každé redundantní dvojice běžely na stejném hypervisoru (`KVM1`), redundance tedy byla na úrovni služeb,
nikoli hardwaru – viz [poznámky](06-notes-and-next-steps.md).

## VPN a PKI (VLAN 30, 31)

- `VPN1`, `VPN2`: **Tailscale** na osobním účtu; `VPN3`: **OpenVPN** nainstalovaný a spravovaný hotovým skriptem [`angristan/openvpn-install`](https://github.com/angristan/openvpn-install) (přidávání a rušení uživatelů); sloužil jen pro konzultanta, který se do sítě občas podíval. Adresy `172.22.30.1–3`
  mají na firewallu plný přístup do správy.
- Interní certifikační autorita (`CA`, OpenSSL) vznikla v první fázi projektu; později jsem ji dál nerozvíjel.

## Další

- **E‑ink tabulky** (VLAN 60): VM `tables` a skript [`tables.py`](../apps/e-ink-tables/tables.py) – vykreslí HTML
  rozvrh přes `wkhtmltoimage` do 1‑bitového obrázku 800×480 a odešle ho po TCP (port 10001) na displeje.
- **Navrženo, ale nedokončeno:** monitoring (VLAN 14: Prometheus, Grafana, ISC Stork), automatizace (VLAN 15: Ansible)
  a zálohování (VLAN 98: Bacula).
