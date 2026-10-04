# Řízení přístupu (RADIUS + MAC Authentication Bypass)

Přístup zařízení k síti řídí dva servery **FreeRADIUS** (`RADIUS1`, `RADIUS2`, identická konfigurace) ve VLAN 10.
Na síťových prvcích běží tři varianty ověřování, všechny proti stejné politice. RADIUS se používá **jen pro MAB**
(ověření podle MAC adresy), ne pro uživatelská jména a hesla.

| VLAN | Význam |
|---|---|
| 42 (trusted) | ověřená zařízení (MAC v tabulce) – po kabelu i po Wi‑Fi |
| 41 (images) | záložní VLAN pro **kabel** (`AA`): zařízení není v tabulce nebo RADIUS neodpovídá |
| 40 (host) | záložní VLAN pro **Wi‑Fi**: neznámé zařízení |

Rozdíl mezi kabelem a Wi‑Fi je záměrný: Cisco umí při zamítnutí i při chybějící odpovědi zařadit port do záložní VLAN
samo, kdežto MikroTik takové chování při nedostupném/neodpovídajícím RADIUS nemá. Proto se pro Wi‑Fi musí neznámé
zařízení **aktivně přijmout a zařadit do VLAN 40** přímo v politice RADIUS.

| Kde | Mechanismus | Když ověření selže |
|---|---|---|
| Cisco `AA` (porty) | `mab`, `authentication order mab`, `port-control auto` | port se přesune do VLAN 41 (`images`) – zamítnutí i nedostupný RADIUS řeší přímo switch (`authentication event fail` / `no-response`); zde se imagují nové počítače |
| MikroTik `AB` (ether1–4) | `interface dot1x server … auth-types=mac-auth` | dle politiky RADIUS |
| Wi‑Fi (CAPsMAN na RT-SRV) | `caps-man access-list … query-radius` | neznámé zařízení musí do VLAN 40 (host) zařadit sám RADIUS – viz níže |

## Politika na RADIUS serveru

Virtuální server [`lab-mab`](../configs/freeradius/sites-enabled/lab-mab) (auth 1812, acct 1813):

1. `preprocess` a **`mab_normalize`** ([`policy.d/mab`](../configs/freeradius/policy.d/mab)) převede MAC adresu na
   malá písmena bez oddělovačů (`aa-bb-cc-…` → `aabbcc…`).
2. `files` vyhledá MAC v souboru `users` ([vzor](../configs/freeradius/users.example)). Záznam vrací atributy
   `Tunnel-Type=VLAN`, `Tunnel-Medium-Type=IEEE-802`, `Tunnel-Private-Group-ID=<VLAN>` a pro MikroTik
   `Mikrotik-Wireless-VLANID` → **dynamické přiřazení VLAN**.
3. Pokud MAC **není** nalezen (`noop`):
   - požadavek přišel z Wi‑Fi (`NAS-Identifier == "RT-SRV"`) → přijmout a přiřadit **VLAN 40 (guest)**,
   - jinak → **`reject`**.
4. Klienti (NAS) jsou definováni v [`clients.conf`](../configs/freeradius/clients.conf.example); každý má vlastní
   32znakový sdílený klíč (ve vzoru nahrazen `CHANGE_ME`).

Aktuálně je v politice **21 zařízení**: 15 ve VLAN 42 (trusted), 4 ve VLAN 60 (tabulky), 1 ve VLAN 62 (IP telefony)
a 1 ve VLAN 99 (admin).

## Kombinace s DHCP

VLAN 42, 60, 62 a 99 mají na DHCP serverech `deny unknown-clients` – i kdyby se zařízení dostalo do VLAN, adresu
dostane jen s pevnou rezervací (viz [služby](05-services.md)). Druhá vrstva ochrany tedy nestojí na RADIUS samotném.

## Omezení

MAB je ověření podle **MAC adresy**, kterou lze podvrhnout – chrání proti náhodnému připojení, ne proti cílenému
útočníkovi. Přirozeným pokračováním je 802.1X s certifikáty (EAP‑TLS) nad interní CA ve VLAN 31 – viz
[poznámky](06-notes-and-next-steps.md).
