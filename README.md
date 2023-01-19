# Hackintosh for Thinkpad L460

## 💻 Hardware
- CPU: Intel Core i5-6300U
- GPU: Intel HD 520 (Spoofed as HD 620)
- RAM: 8GB
- Storage: 256GB SSD SATA (SSDSC2KF256H6L)
- Screen Resolution: 1920x1080
- Audio Codec: Realtek ALC3245/ALC293
- LAN: Intel i219
- WLAN/Bluetooth: Intel(R) Dual Band Wireless-AC 8260

## 🔧 Status

### ✔️ Working
- Acceleration
- Audio + Combo Jack (with [OpenALC](https://github.com/acidanthera/AppleALC))
- Sleep (Although it broke EC, specifically FN hotkeys, but sleep itselves working as intended)
- Spoof (Require GfxYTile to fix flickers and glitches)

### ⚠️ Partially Working
- WiFi (with [AirportItlwm](https://github.com/OpenIntelWireless/itlwm), location and wifi scan is currently broken, replace with Itlwm+HeliPort for workaround)
- Bluetooth (Caused "Volume Hash Mismatch" error after waking from sleep, reboot to fix)
- EC (Broken after sleep, FN hotkeys completely broken after sleep, reboot to fix)

### ❌ Not Working
- DRM (iGPU-only setup is completely broken, use third-party browsers to watch DRM videos)
- SD Card Reader (I don't see a point to support this, usually have really slow RW)

### ❓ Not Tested
- Wired Ethernet (with [Mausi](https://www.tonymacx86.com/resources/intelmausi.499/), was working on Catalina, broken on Monterey, not tested on Ventura)

## 📋 TODO
- [ ] Dump ACPI into this repo
- [ ] Reuse AirportItlwm once it become stable
