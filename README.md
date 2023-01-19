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
- GPU (Require GfxYTile to fix flickers and glitches, but acceleration working as intended)
- Audio + Combo Jack (using [OpenALC](https://github.com/acidanthera/AppleALC))
- Sleep (Although it broke EC, specifically FN hotkeys, but sleep itselves working as intended)

### ⚠️ Partially Working
- WiFi (using [AirportItlwm](https://github.com/OpenIntelWireless/itlwm), location and wifi scan is currently broken, replace with Itlwm+HeliPort for workaround)
- Bluetooth (Caused "Volume Hash Mismatch" error after waking from sleep, reboot to fix)
- EC (Broken after sleep, FN hotkeys completely broken after sleep, reboot to fix)

### ❌ Not Working
- DRM (iGPU-only setup is completely broken, use third-party browsers to watch DRM videos)  
  Some iGPU-only Laptop user reported that `unfairgva=4` fixed it, but that doesn't seems to be working on my Laptop.
- SD Card Reader (I don't see a point to support this, usually have really slow RW)

### ❓ Not Tested
- Wired Ethernet (using [Mausi](https://www.tonymacx86.com/resources/intelmausi.499/), was working on Catalina, broken on Monterey, not tested on Ventura)

## 📋 TODO
- [ ] Dump ACPI into this repo
- [ ] Reuse AirportItlwm once it become stable

## Other Repositories
- ThinkPad X1C6:
  - [benbender/x1c6-hackintosh](https://github.com/benbender/x1c6-hackintosh)
  - [tylernguyen/x1c6-hackintosh](https://github.com/tylernguyen/x1c6-hackintosh)
- ThinkPad T460s:
  - [simprecicchiani/ThinkPad-T460s-macOS-OpenCore](https://github.com/simprecicchiani/ThinkPad-T460s-macOS-OpenCore)

## Credits
- [@acidanthera](https://github.com/acidanthera) for maintaining and developing a lot of amazing Kexts
- [@benbender](https://github.com/benbender) for SSDT-Sleep that I adapted to work with L460
- [@corpnewt](https://github.com/corpnewt) for [gibMacOS](https://github.com/corpnewt/gibMacOS) and [MountEFI](https://github.com/corpnewt/MountEFI).
- [@dortania](https://github.com/dortania) for their amazing guide
- [@zhen-zen](https://github.com/zhen-zen) for YogaSMC
- [@zxystd](https://github.com/zxystd) for [itlwm](https://github.com/OpenIntelWireless/itlwm)
