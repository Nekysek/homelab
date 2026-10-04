import socket
import subprocess
from PIL import Image
import os
import time
DISPLAYS = {
    "172.22.60.11": "/tables/schedules/01.html",
    "172.22.60.12": "/tables/schedules/02.html",
    "172.22.60.13": "/tables/schedules/03.html",
    "172.22.60.14": "/tables/schedules/04.html"
}
PORT = 10001
TEMP_IMG = "/tables/render.png"
def create_payload(html_file):
    if not os.path.exists(html_file):
        print(f"  [!] {html_file} nenalezen")
        return None
    env = os.environ.copy()
    env["DISPLAY"] = ":99"
    try:
        subprocess.run([
            "/usr/local/bin/wkhtmltoimage",
            "--width", "800",
            "--height", "480",
            "--disable-smart-width",
            "--enable-local-file-access",
            "--quiet",
            html_file,
            TEMP_IMG
        ], check=True, env=env, timeout=20)
    except Exception as e:
        print(f"  [!] Render error: {e}")
        return None
    try:
        with Image.open(TEMP_IMG) as img:
            img = img.convert("RGB").resize((800, 480))
            pixels = img.load()
            payload = bytearray(b"{sd}")
            for y in range(480):
                for x in range(0, 800, 8):
                    byte = 0
                    for bit in range(8):
                        r, g, b = pixels[x + bit, y]
                        bw = 0 if (r == 255 and g == 255 and b == 255) else 1
                        byte |= (bw << (7 - bit))
                    payload.append(byte)
            payload.extend(b"{rd}")
            return payload
    except Exception as e:
        print(f"  [!] Image error: {e}")
        return None
def send_to_display(ip, data):
    print(f"  [>] {ip}...", end=" ", flush=True)
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(10)
            s.connect((ip, PORT))
            for i in range(0, len(data), 128):
                s.sendall(data[i:i+128])
            print("OK")
    except Exception as e:
        print(f"CHYBA: {e}")
def main():
    print(f"\n--- {time.strftime('%H:%M:%S')} ---")
    for ip, html in DISPLAYS.items():
        payload = create_payload(html)
        if payload:
            send_to_display(ip, payload)
        time.sleep(0.2)
    print("--- Hotovo ---\n")
if __name__ == "__main__":
    main()