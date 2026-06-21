## Konfigurasi jellyfin-mpv-shim

Lokasi File Konfigurasi

- Linux: `~/.config/jellyfin-mpv-shim/conf.json`
- Windows: `%APPDATA%\jellyfin-mpv-shim\conf.json`
- macOS: `~/Library/Application Support/jellyfin-mpv-shim/conf.json`

## Install Config (Windows)

Jalankan `install.bat` di folder ini untuk copy config ke lokasi Roaming.

```cmd
cd jellyfin-mpv-shim
install.bat
```

**Apa yang dilakukan script:**
- Copy `conf.json` → `%APPDATA%\jellyfin-mpv-shim\conf.json`
- Copy `script\auto_sub.lua` → `%APPDATA%\jellyfin-mpv-shim\scripts\auto_sub.lua`
- `client_uuid` otomatis terisi: pakai existing UUID dari config lama, atau generate baru kalau belum ada

**Note:** Jalankan sebagai user biasa (tidak perlu admin).