# Hackintosh for Thinkpad L460

> [!WARNING]
> I am not responsible for any damages you may cause
>
> This repository's main goal is to document my hackintosh journey. It is not meant to provide an out-of-the-box experience on doing hackintosh! If you're new to Hackintosh please make your own EFI by following [Dortania guide](https://dortania.github.io/) instead
>
> If you insist on using my EFI, use it with your own risk, please note that I will **NOT** provide any support
>
> I am not responsible for any damages you may cause

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

| Menu     |                   |                                 | Setting     |
| -------- | ----------------- | ------------------------------- | ----------- |
| Config   | USB               | UEFI BIOS Support               | `Enable`    |
|          | Power             | Intel SpeedStep Technology      | `Enable`    |
|          |                   | CPU Power Management            | `Enable`    |
| Security | Security Chip     |                                 | `Disable`   |
|          | Memory Protection | Execution Prevention            | `Enable`    |
|          | Virtualization    | Intel Virtualization Technology | `Enable`    |
|          |                   | Intel VT-d Feature              | `Enable`    |
|          | Anti-Theft        | Computrace                      | `Disable`   |
|          | Secure Boot       |                                 | `Disable`   |
|          | Intel SGX         |                                 | `Disable`   |
|          | Device Guard      |                                 | `Disable`   |
| Startup  | UEFI/Legacy Boot  |                                 | `UEFI Only` |
|          | CSM Support       |                                 | `No`        |

### Setup

- Follow [Dortania guide](https://dortania.github.io/) to create macOS installer
- On "Setting up the EFI" part, drop the `EFI/` from this repo to your installer's EFI partition
- Rename `Config.public.plist` to `Config.plist`
  - Optional: follow [Dortania guide's PlatformInfo section](https://dortania.github.io/OpenCore-Install-Guide/config.plist/skylake.html#platforminfo) (Mainly for `MLB`, `SystemSerialNumber`, and `SystemUUID`, not really needed just yet)
- Boot to USB and Install macOS
- Now you can try `Post-Install` section's config, all of them are optional but could be useful (especially if you want to Apple Services such as iMessage)

### Post-Install

Useful configuration you can do after you successfully installed macOS

#### Enable Apple Services

Config to allow you to use Apple Services (such as iMessage)

> [!NOTE]
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

#### Disable S3/S4

This is the stupid simple way to fix sleep related issues, simply disable S3/S4:

```zsh
sudo pmset -a hibernatemode 0
sudo pmset -a proximitywake 0
sudo pmset -a standbydelayhigh 0
sudo pmset -a ttyskeepawake 0
sudo pmset -a gpuswitch 0
sudo pmset -a halfdim 0
sudo pmset -a womp 0
sudo pmset -a acwake 0
sudo pmset -a networkoversleep 0
sudo pmset -a tcpkeepalive 0
```

I personally don't do this since it's no fun but also doesn't actually fix the issue, just disabling some problematic features

#### Bluetooth Workaround

1. Get your Bluetooth Controller's MAC Address,
   - Method 1:  
     Run this command in a terminal and copy the result:
     ```zsh
     system_profiler SPBluetoothDataType | grep "Address:" | head -1 | sed "s/ *Address: \(.*\)/\1/g"
     ```
   - Method 2:
      1. Click the Apple logo at the top-left corner then click About This Mac
      2. Go to System Report,
         - On Monterey or older, just click System Report
         - On Ventura or newer, click More Info, scroll all the way down then click System Report
      3. Navigate to Bluetooth menu (Hardware > Bluetooth)
      4. Under Bluetooth Controller copy the MAC Address
2. Add this line to the `/etc/zshenv` (or `/etc/bashrc`) file:
   ```zsh
   export BT_DEVICE_ADDRESS="PASTE:YOUR:MAC:ADDRESS:HERE"
   ```
3. Reboot to apply the changes
4. Get into S3/S4 sleep then try connecting to a device via Bluetooth

#### Ventura 13.x Reboot Into Recovery

Not sure what happened here, but ResetNVRAM seems to fix this issue, if it
seems like your hackintosh is stuck on Apple logo with progressbar, just wait
until it reboot itself.

#### Reducing itlwm and/or IntelBluetoothFirmware Kext's filesize

- Go to either of these repo:
  - https://github.com/null2264/itlwm
  - https://github.com/null2264/IntelBluetoothFirmware
- Click "Use this template" and wait for your repo to be ready
- Make sure Actions is enabled on the repo
- Edit `.github/workflows/main.yml` file, find "Delete unused firmware"
- Replace `ibt-11-5` or `iwm-8000C` with your card
- To retrieve the Kext:
  - IntelBluetoothFirmware:
    - Go to `Actions` tab
    - Find latest workflow (make sure it's completed, indicated by a checkmark), click it
    - You'll see your kext in "Artifacts" section
  - Itlwm:
    - Go to `Releases` page (should be on the sidebar, or just append `/releases/` on your url bar)
    - If you did it correctly, the kext should appear there

#### EFI "Not Enough Disk Space" error

- Empty your Trash Bin
- Profit-

If that didn't work:

> [!CAUTION]
> This process is essentially formatting your EFI partition, please make sure
> to backup your EFI partition and have a working bootable USB ready in case of
> emergency!

- Backup your EFI
- Run `diskutil list`, then grab your EFI partition's IDENTIFIER (e.g. `disk0s1`)
- Run `newfs_msdos -v EFI -F 32 /dev/<IDENTIFIER>`, e.g. (`newfs_msdos -v EFI -F 32 /dev/disk0s1`)
  - This command requires `sudo`!
- Copy your backed up EFI into the newly formatted EFI partition
- Now you can restart and pray that you didn't mess up :^)

Not entirely sure why EFI partition is filling up like that but I recommend:
- To delete a file (for example when you're updating a kext) before replacing it
- Empty your Trash Bin before ejecting the EFI partition (or restarting your macOS)

## 🔧 Status

> [!NOTE]
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
    - Using resolution higher or lower than the internal monitor native resolution
  - KabyLake's color-banding issue, the only fixes related to this require spoofing GPU to SkyLake (My external monitor doesn't have this issue, so maybe it's hardware)
    - Some says injecting fake EDID could fix this issue, but it doesn't work for me
- Restart + S3/S4 Sleep + Shutdown
- Audio + Combo Jack (using [OpenALC](https://github.com/acidanthera/AppleALC))
- Brightness (and brightness control hotkeys)
- Trackpad + Trackpoint + Clickpad
- Wired Ethernet (using [Mausi](https://www.tonymacx86.com/resources/intelmausi.499/))  
  **Note**: If your connection keep disconnecting, you may need to connect your Ethernet cable before turning on your laptop atleast once. After that it should work perfectly fine even after unplugging and plugging the cable in again
- Bluetooth (Try [Bluetooth Workaround](#bluetooth-workaround) if you get "Volume Hash Mismatch" error after waking from sleep, if it doesn't work you can always reboot to fix it)
- USB Ports
  - USB Tethering via [HoRNDIS](https://github.com/jwise/HoRNDIS)
- VGA (is DP internally, so it's natively supported)
- WiFi (using [AirPortOpenBSD](https://github.com/a565109863/AirPortOpenBSD) or [AirportItlwm/itlwm](https://github.com/OpenIntelWireless/itlwm))
  - Can't connect to WiFi with hidden SSID
    - Use AirPortOpenBSD
       - Sometimes it doesn't want to connect, I recommend not using hidden SSID at all when you don't actuallly need it
    - Use itlwm+HeliPort instead to fix this
  - (**AirPortOpenBSD**) WiFi sometimes doesn't show up, this could be caused by WLAN channel overlaps
    - Try changing your Access Point's WLAN Channel to something else to fix it
    - (Only for **AirPortOpenBSD - v2.3.0 or newer**) You try turning on and off the wifi connection on macOS
    - (Only for **AirPortOpenBSD - v2.3.0 or newer**) You can also try clicking "other" and manually connect to the WiFi
      - If it says "network couldn't be found", try turning off and on again the WiFi (your device's wifi connect and/or your access point), then try again

### ⚠️ Partially Working
- \_Qxx EC Query not firing after sleep, caused FN Hotkeys and some battery update functions to stop working, reboot is required to fix it. A common issue on E-Series and L-series ThinkPad
  - After some testing, this seems to be a firmware issue
- DRM
  - iGPU-only DRM is completely broken, use browser with Widevine DRM instead
  - Some iGPU-only Laptop users reported that `unfairgva=4` fixed it, you may test it on your device, but this workaround doesn't seems to be working on my Laptop

### ❌ Not Working
- SD Card Reader (Disabled on BIOS)
  - If you need SD Card Reader you can try adding [Sinetek-rtsx](https://github.com/cholonam/Sinetek-rtsx) or [RealtekCardReader](https://github.com/0xFireWolf/RealtekCardReader) to your EFI

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
