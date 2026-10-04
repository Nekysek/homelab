# Poznámky a další vývoj

Při procházení konfigurací jsem si poznamenal věci, které bych dnes udělal jinak. Uvádím je otevřeně – je to snapshot
skutečné sítě, ne dokonalý návrh.

## Redundance

- **Obě instance dvojic DHCP, DNS, NTP, RADIUS, VPN i doménových řadičů běžely na stejném hypervisoru (`KVM1`).**
  Výpadek jednoho serveru služby ustál, výpadek hypervisoru ne. Lepší je rozložit dvojice na dva hypervisory.

## DNS

- **DNSSEC:** v logu jsou opakovaná varování `No DNSKEY RRSIGs found for '.'` – validace přes stávající forwardery nefunguje;
  je třeba buď vypnout `dnssec-validation`, nebo ověřit, že forwardery DNSSEC předávají.
- **Přípona `.local`** koliduje s mDNS (RFC 6762); pro produkční síť je vhodnější vlastní subdoména reálné domény.
- Na Cisco switchích je ještě jiné doménové jméno (`lab.intranet`) – sjednotit.

## Konzistence konfigurací

- **Pozůstatky po přečíslování VLAN na RT-SRV:** adresní seznam `VLAN96 backup` a `vlan-ids=…96…` (zálohy jsou dnes
  VLAN 98), pravidlo pro RADIUS s rozsahem `.201–.202` (servery jsou `.200` a `.201`). Vyčistit.
- VLAN 12 používá adresy `.1` a `.2` (routery), ostatní VLAN mají bránu `.254` – záměrně, ale stojí za poznámku.

## Bezpečnost

- **MAB → 802.1X s EAP‑TLS** nad interní CA (VLAN 31); FreeRADIUS má modul `eap` k dispozici.
- **SNMP:** přejít z výchozí komunity omezené na VLAN 98 na **SNMPv3**.
- **Sdílené klíče a hesla** spravovat mimo konfigurace (např. Ansible Vault – VLAN 15 je pro automatizaci připravená).
- `user.sh` (vytváření domovských adresářů) předává jméno uživatele skriptu bez uvozovek – ošetřit citací proměnných.

## Provoz

- Dokončit monitoring (Prometheus, Grafana, Stork), automatizaci (Ansible) a zálohování (dnes jen návrh).
  Zálohy by dávalo smysl postavit hlavně jako zálohování **konfigurací** síťových prvků.
- Popsat, jak vzniká generovaný soubor DHCP rezervací a RADIUS `users` (jeden zdroj pravdy → dvě konfigurace).
