#!/bin/bash
echo "[>] Runned at: $(date '+%Y-%m-%d %H:%M:%S')"

echo "==== HOMES ===="

cd /data/users
for d in *; do
    if [ -d "$d" ]; then
        chown -R "$d":"domain admins" "$d"
        chmod -R 2770 "$d"
    fi
done
echo "[>] HOTOVO"

echo "==== DATA ===="

chown -R root:"data" /data/data
chmod -R 2770 /data/data
echo "[>] HOTOVO"

echo "==== IMAGES ===="

chown -R root:"images" /data/images
chmod -R 2770 /data/images
echo "[>] HOTOVO"

exit 0
