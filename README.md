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

### Tips

> Useful configuration you can do after you successfully installed macOS

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

#### Bluetooth Workaround

1. Get your Bluetooth Controller's MAC Address,
   - Method 1:
      1. Click the Apple logo at the top-left corner then click About This Mac
      2. Go to System Report,
         - On Monterey or older, just click System Report
         - On Ventura or newer, click More Info, scroll all the way down then click System Report
      3. Navigate to Bluetooth menu (Hardware > Bluetooth)
      4. Under Bluetooth Controller copy the MAC Address
   - Method 2:  
     Run this command in a terminal and copy the result:
     ```zsh
     system_profiler SPBluetoothDataType | grep "Address:" | head -1 | sed "s/ *Address: \(.*\)/\1/g"
     ```
2. Add this to line to `/etc/zshenv` (or `/etc/bashrc`) file:
   ```zsh
   export BT_DEVICE_ADDRESS="PASTE:YOUR:MAC:ADDRESS:HERE"
   ```
3. Reboot to apply the changes
4. Get into S3/S4 sleep then try connecting to a device via Bluetooth

## 🔧 Status

> **Note**
>
> Your experience may vary
>
> - Working = Doesn't affecting workflow that much or straight up working out-of-the-box
> - Partially Working = Working but sometimes require reboot to fix
> - Not Working = Doesn't work at all or delibrately disabled by me
> - Not Tested = Can't be tested at the moment

### ✔️ Working
- CPU (Power Managament)
- GPU (Acceleration)
  - Glitches and Flickers, can be fixed by adding `AAPL,GfxYTile` property. It still sometimes happened under certain circumstances such as:
    - Using HiDPI
    - Connect to an external monitor (Maybe because my monitor's (native) resolution is under 1080, I don't have a 1080p monitor so I can't test it further)
  - KabyLake's color-banding issue, the only fixes related to this require spoofing GPU to SkyLake (My external monitor doesn't have this issue, so maybe it's hardware)
    - Some says injecting fake EDID could fix this issue, but it doesn't work for me
- Audio + Combo Jack (using [OpenALC](https://github.com/acidanthera/AppleALC))
- VGA (is DP internally, so it's natively supported)
- Wired Ethernet (using [Mausi](https://www.tonymacx86.com/resources/intelmausi.499/))  
  **Note**: If your connection keep disconnecting, you may need to connect your Ethernet cable before turning on your laptop atleast once. After that it should work perfectly fine even after unplugging and plugging the cable in again
- USB Tethering via [HoRNDIS](https://github.com/jwise/HoRNDIS)
- Bluetooth (Try [Bluetooth Workaround](#bluetooth-workaround) if you get "Volume Hash Mismatch" error after waking from sleep, if it doesn't work you can always reboot to fix it)

### ⚠️ Partially Working
- WiFi (using [AirportItlwm/itlwm](https://github.com/OpenIntelWireless/itlwm) or [AirPortOpenBSD](https://github.com/a565109863/AirPortOpenBSD))
  - You can't join hidden networks with AirportItlwm or AirPortOpenBSD. While itlwm+HeliPort can join hidden networks, you can't auto-join them
  - Location and WiFi scan is currently broken. You may be able to fix it temporarily by running `sudo pkill airportd` in a terminal
  - Replace AirportItlwm with itlwm+HeliPort for WiFi scan workaround
  - You may also try [AirPortOpenBSD](https://github.com/a565109863/AirPortOpenBSD). It still have Location and WiFi scan problem, but it loads much faster than AirportItlwm. But all known network will be detected as hidden network (Incase you cares about cosmetic things)
  - WiFi sometimes doesn't show up, this could be caused by WLAN channel overlaps. When this happened try changing your Access Point's WLAN Channel to something else
- Sleep (S3 and S4 confirmed to be working)
  - Broke \_Qxx EC Query events, a common ThinkPad E-series and L-series issue, reboot to fix

### ❌ Not Working
- DRM
  - iGPU-only setup is completely broken, use third-party browsers to watch DRM videos
  - Some iGPU-only Laptop users reported that `unfairgva=4` fixed it, you may test it on your device, but this workaround doesn't seems to be working on my Laptop
- SD Card Reader
  - I don't see a point to support SD Card Reader since it's usually have a really slow RW
  - If you need SD Card Reader you can try adding [Sinetek-rtsx](https://github.com/cholonam/Sinetek-rtsx) to your EFI

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
- [@a565109863](https://gitee.com/a565109863) for [AirPortOpenBSD](https://gitee.com/a565109863/AirPortOpenBSD)
- [@acidanthera](https://github.com/acidanthera) for maintaining and developing a lot of amazing Kexts
- [@benbender](https://github.com/benbender) for SSDT-Sleep that I adapted to work with L460
- [@corpnewt](https://github.com/corpnewt) for [gibMacOS](https://github.com/corpnewt/gibMacOS) and [MountEFI](https://github.com/corpnewt/MountEFI).
- [@dortania](https://github.com/dortania) for their amazing [guide](https://dortania.github.io)
- [@jwise](https://github.com/jwise) for [HoRNDIS](https://github.com/jwise/HoRNDIS)
- [@zhen-zen](https://github.com/zhen-zen) for [YogaSMC](https://github.com/zhen-zen/YogaSMC)
- [@zxystd](https://github.com/zxystd) for [itlwm](https://github.com/OpenIntelWireless/itlwm)
- [r/hackintosh](https://www.reddit.com/r/hackintosh) community for helping me find solution to various issue I came across

## 🔗 External Links
- [LENOVO ThinkPad L460 Technical Specs PDF](https://psref.lenovo.com/syspool/Sys/PDF/ThinkPad/ThinkPad_L460/ThinkPad_L460_Spec.PDF)
