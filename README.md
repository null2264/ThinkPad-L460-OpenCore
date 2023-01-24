# Hackintosh for Thinkpad L460

> **Warning**
>
> I am not responsible for any damages you may cause
>
> This repository's main goal is to document my accomplishment, issues, and solutions I found when making this EFI. It is not meant to provide a out-of-the-box experience on doing hackintosh! If you're new to Hackintosh please make your own EFI by following [Dortania's Guide](https://dortania.github.io/) instead
>
> If you insist on using my EFI, use it with your own risk, you may report issues related to patches that you came across, but I won't give any support on installation issues

## 💻 Hardware
- CPU: Intel Core i5-6300U
- GPU: Intel HD 520 (Spoofed as HD 620)
- RAM: 8GB
- Storage: 256GB SSD SATA (SSDSC2KF256H6L)
- Screen Resolution: 1920x1080
- Audio Codec: Realtek ALC3245/ALC293
- LAN: Intel i219
- WLAN/Bluetooth: Intel(R) Dual Band Wireless-AC 8260

### BIOS Config

TODO

### Post-Install Setup

#### Enable Apple Services

> **Note**
>
> If you (still) can't login to iMessage you may need to contact Apple Support to unblacklist your AppleID (You can try opening the Message app from terminal to check the log to see if you're getting a Customer Code error, which is an indication that your AppleID got blacklisted. [See more info here](https://dortania.github.io/OpenCore-Post-Install/universal/iservices.html#customer-code-error))

1. Download (or clone) [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS) and run it in terminal
2. Type `3` to generate SMBIOS, then press <kbd>Enter</kbd>
3. Type `MacBookPro14,1 5`, then press <kbd>Enter</kbd>
4. Open `EFI/Config.plist` (I highly recommend using [ProperTree](https://github.com/corpnewt/ProperTree)) and navigate to `PlatformInfo -> Generic`
5. Add one of the script's result to `MLB`, `SystemSerialNumber`, and `SystemUUID`
7. Replace `ROM` with your MAC Address (`System Preferences -> Network -> Ethernet -> Advanced -> Hardware -> MAC Address`, then remove all the colons `:`). Or you can also try using a real Apple MAC Address
8. Save and Reboot
9. Check the Serial Number validity. Repeat step 5 and choose different result (or generate new set of SMBIOS) if you saw `Valid Purchase Date`

## 🔧 Status

> **Note**
>
> Your experience may vary

### ✔️ Working
- GPU (Require GfxYTile to fix flickers and glitches, but acceleration working as intended)  
  Glitches still sometimes happened under certain circumstances such as:
  - Using HiDPI
  - Connect to an external monitor with (native) resolution under 1080 (This need to be tested further as glitches seems to only happened when I use BetterDisplay)
- Audio + Combo Jack (using [OpenALC](https://github.com/acidanthera/AppleALC))
- Sleep (Although it broke EC, specifically FN hotkeys, but sleep itselves working as intended)
- VGA (is HDMI internally, so it's natively supported)
- Wired Ethernet (using [Mausi](https://www.tonymacx86.com/resources/intelmausi.499/))
  - If your connection keep disconnecting, you may need to connect your Ethernet cable before turning on your laptop atleast once. After that it should work perfectly fine even after unplugging and plugging the cable in again

### ⚠️ Partially Working
- WiFi (using [AirportItlwm/itlwm](https://github.com/OpenIntelWireless/itlwm) or [AirPortOpenBSD](https://github.com/a565109863/AirPortOpenBSD))  
  - You can't join hidden networks with AirportItlwm or AirPortOpenBSD. While itlwm+HeliPort can join hidden networks, you can't auto-join them
  - Location and WiFi scan is currently broken. You may be able to fix it temporarily by running `sudo pkill airportd` in a terminal
  - Replace AirportItlwm with itlwm+HeliPort for WiFi scan workaround
  - You may also try [AirPortOpenBSD](https://github.com/a565109863/AirPortOpenBSD). It still have Location and WiFi scan problem, but it atleast loaded much sooner than AirportItlwm for me. But all known network will be detected as hidden network (Incase you cares about cosmetic things)
  - WiFi sometimes doesn't show up, this could be caused by WLAN channel overlaps. When this happened try changing your Access Point's WLAN Channel to something else
- Bluetooth  
  - Caused "Volume Hash Mismatch" error after waking from sleep, reboot to fix
  - Some Intel Bluetooth users reported that `sudo pkill bluetoothd` may fix this issue temporarily, but this doesn't work on my laptop. Bluetooth devices refuses to connect entirely
- EC (Broken after sleep)
  - FN hotkeys completely broken after sleep, reboot to fix  
    \_Qxx won't fires at all after sleep causes FN hotkeys to not working
  - Battery status is delayed after sleep (could be because battery status update is handled by \_Qxx but because it never fires it instead relies on battery capacity update)

### ❌ Not Working
- DRM
  - iGPU-only setup is completely broken, use third-party browsers to watch DRM videos
  - Some iGPU-only Laptop users reported that `unfairgva=4` fixed it, you may test it on your device, but this workaround doesn't seems to be working on my Laptop
- SD Card Reader
  - I don't see a point to support SD Card Reader since it's usually have a really slow RW

### ❓ Not Tested
- MiniDP
  - Need MiniDP adapter since none of my devices use MiniDP

## 📋 TODO
- [ ] Dump ACPI into this repo

## 📂 Other Repositories
- ThinkPad X1C6:
  - [benbender/x1c6-hackintosh](https://github.com/benbender/x1c6-hackintosh)
  - [tylernguyen/x1c6-hackintosh](https://github.com/tylernguyen/x1c6-hackintosh)
- ThinkPad T460s:
  - [simprecicchiani/ThinkPad-T460s-macOS-OpenCore](https://github.com/simprecicchiani/ThinkPad-T460s-macOS-OpenCore)

## ℹ️ Credits
- [@acidanthera](https://github.com/acidanthera) for maintaining and developing a lot of amazing Kexts
- [@benbender](https://github.com/benbender) for SSDT-Sleep that I adapted to work with L460
- [@corpnewt](https://github.com/corpnewt) for [gibMacOS](https://github.com/corpnewt/gibMacOS) and [MountEFI](https://github.com/corpnewt/MountEFI).
- [@dortania](https://github.com/dortania) for their amazing [guide](https://dortania.github.io)
- [@zhen-zen](https://github.com/zhen-zen) for [YogaSMC](https://github.com/zhen-zen/YogaSMC)
- [@zxystd](https://github.com/zxystd) for [itlwm](https://github.com/OpenIntelWireless/itlwm)
- [r/hackintosh](https://www.reddit.com/r/hackintosh) community for helping me find solution to various issue I came across
