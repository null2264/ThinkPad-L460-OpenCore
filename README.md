# Hackintosh for Thinkpad L460

> [!WARNING]
> I am not responsible for any damages you may cause
>
> This repository's main goal is to document my hackintosh journey, in case
> something happened to my hackintosh stupid. It is **NOT** meant to provide an
> out-of-the-box experience on doing hackintosh! If you're new to Hackintosh
> please build your own EFI by following [Dortania
> guide](https://dortania.github.io/) instead!
>
> If you insist on using my EFI, use it with your own risk, please note that I
> will **NOT** provide any support

## 💻 Hardware
- CPU: [Intel Core i5-6300U](https://www.intel.com/content/www/us/en/products/sku/88190/intel-core-i56300u-processor-3m-cache-up-to-3-00-ghz/specifications.html?wapkw=6300U)
- GPU: Intel HD 520 (Spoofed as HD 620)
- RAM: 8GB
- Storage: 256GB SSD SATA (SSDSC2KF256H6L)
- Screen Resolution: 1920x1080
- Audio Codec: Realtek ALC3245/ALC293
- LAN: Intel i219
- WLAN/Bluetooth: Intel(R) Dual Band Wireless-AC 8260

## BIOS Config

| Menu     |                   |                                  | Setting     | Note        |
| -------- | ----------------- | -------------------------------- | ----------- | ----------- |
| Config   | USB               | UEFI BIOS Support                | `Enable`    |             |
|          |                   | Always On USB                    | `Enable`    |             |
|          |                   | - Charge in Battery Mode         | `Disable`   |             |
|          | Power             | Intel SpeedStep Technology       | `Enable`    |             |
|          |                   | CPU Power Management             | `Enable`    |             |
|          | CPU               | Intel Hyper-Threading Technology | `Enable`    |             |
| Security | Security Chip     |                                  | `Disable`   |             |
|          | Memory Protection | Execution Prevention             | `Enable`    |             |
|          | Virtualization    | Intel Virtualization Technology  | `Enable`    |             |
|          |                   | Intel VT-d Feature               | `Enable`    |             |
|          | I/O Port Access   | Memory Card Slot                 | `Disable`   |             |
|          | Anti-Theft        | Computrace                       | `Disable`   |             |
|          | Secure Boot       |                                  | `Disable`   | [Can be enabled after installation complete if you sign OpenCore](https://github.com/perez987/OpenCore-and-UEFI-Secure-Boot) |
|          | Intel SGX         |                                  | `Disable`   |             |
|          | Device Guard      |                                  | `Disable`   |             |
| Startup  | UEFI/Legacy Boot  |                                  | `UEFI Only` |             |
|          | CSM Support       |                                  | `No`        |             |
|          | Boot Mode         |                                  | `Quick`     |             |

## Setup

- Optional: Before doing anything, be sure to generate your own USB mapping using [USBToolBox](https://github.com/USBToolBox/tool) and store the Kext somewhere, just in case your laptop mapping different from mine
- Follow [Dortania guide](https://dortania.github.io/) to create macOS installer
- On "Setting up the EFI" part, drop the `EFI/` from this repo to your installer's EFI partition
- Rename `Config.public.plist` to `Config.plist`
  - Optional: follow [Dortania guide's PlatformInfo section](https://dortania.github.io/OpenCore-Install-Guide/config.plist/skylake.html#platforminfo) (Mainly for `MLB`, `SystemSerialNumber`, and `SystemUUID`, not really needed just yet)
  - Optiona: drop your `UTBMap.kext` into `EFI/OC/Kexts` directory
- Boot to USB and Install macOS
- Now you can try `Post-Install` section's config, all of them are optional but could be useful (especially if you want to Apple Services such as iMessage)

## Post-Install

Useful configuration you can do after you successfully installed macOS

### Enable Apple Services

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
9. Check the Serial Number validity. Repeat step 5 and choose different result (or generate new set of SMBIOS) until you find invalid Serial Number

### Disable S3/S4

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

### Bluetooth Workaround

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

### Ventura 13.x Reboot Into Recovery

Not sure what happened here, but ResetNVRAM seems to fix this issue, if it
seems like your hackintosh is stuck on Apple logo with progressbar, just wait
until it reboot itself.

### Reducing itlwm and/or IntelBluetoothFirmware Kext's filesize

- Go to either of these repo:
  - https://github.com/null2264/itlwm
  - https://github.com/null2264/IntelBluetoothFirmware
- Click "Use this template" and wait for your repo to be ready
- Make sure Actions is enabled on the repo
- Edit `.github/workflows/main.yml` file, find "Delete unused firmware"
- Replace `ibt-11-5` or `iwm-8000C` with your card
- To retrieve the Kext:
  - Go to `Releases` page (should be on the sidebar, or just append `/releases/` on your url bar)
  - If you did it correctly, the kext should appear there

### EFI "Not Enough Disk Space" error

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

### Undervolting

This EFI has [VoltageShiftSecure](https://github.com/xCuri0/VoltageShiftSecure)
installed, you can use this to undervolt your device, you may need to grab their
binary to configure it.

My current setup:

- CPU voltage offset: -80mv
- GPU voltage offset: -80mv
- CPU Cache voltage offset: -60mv

### Adding EFI to UEFI Boot Entry

There are cases where BIOS refuses to detect HDD as bootable drive, or maybe
you want to dual-boot in the future. The best way to fix it is by adding EFI to
UEFI Boot Entry manually:

#### From Outside of OpenCore (Recommended):
- Create a Linux live USB and boot directly to it (make sure it has `efibootmgr`, I recommend Linux Mint)
- Use `efibootmgr --create --disk /dev/<your bootable drive> --part <ESP Number> --loader \\EFI\\OC\\OpenCore.efi --label "OpenCore"`
- Now when you reboot you'll see OpenCore entry on your boot options

#### From OpenCore - UEFI Shell:
> [!CAUTION]
> This process is very sensitive, it's the not recommended way.
- Boot to OpenCore
- Press space before it auto boot you to macOS
- Select UEFI Shell
- Run `map` command and find where your EFI is located (in my case it's `FS0`)
- Run `FS0:\EFI\OC\Tools\OpenControl.efi disable`
- Run `bcfg boot add 0 FS0:\EFI\OC\OpenCore.efi "OpenCore"`
- Finally, run `reset` to reboot your system

#### From OpenCore - Config.plist:
> [!CAUTION]
> I don't recommend using this method if you're using USB to boot to OpenCore
- Open `EFI/OC/Config.plist` using your plist editor of choice (I recommend ProperTree)
- Go to `Misc` > `Boot` > `LauncherOption`, set it from `Disabled` to `Full`

### Enabling Secure Boot

#### Using shim

TODO - https://github.com/acidanthera/OpenCorePkg/blob/master/Utilities/ShimUtils/README.md

I haven't done it myself, but you can skip inserting your own signature if you
use Shim bootloader and chainload OpenCore from it, Shim itself is (usually)
signed using Microsoft cert, but of course Microsoft wouldn't want people to
use it to bypass Secure Boot, so Shim has a verification logic that check if
the MOK (iirc it can be either a hash or a signature) inside an image (e.g.
EFI) is in the MOK (Machine Owner Key) list. It'll also allow you to enroll the
MOK pretty easily, no need to use KeyTool and stuff, it'll just prompt you.

#### Automated

Please read
[#manual](https://github.com/null2264/ThinkPad-L460-OpenCore/tree/master?tab=readme-ov-file#manual)
for more information. If you're doing this in macOS, make sure to have
[Multipass](https://multipass.run/) installed.

I've made automation script to (semi) automate signing:
- `signing-bootstrap`: Only run this once, this script will setup the (almost)
  all necessery stuff for signing in this directory for you. Run this script
  first (if you haven't) before running the other scripts.
- `sign`: Find and sign `.efi` file(s). (Signed `.efi` files are stored in
  `Signed/` directory)
- `signed-opencore-downloader`: Download and signed OpenCorePkg (useful when
  updating OpenCore)
- `signing-common`: Not meant to be ran, meant to be imported to other script

#### Manual

If you for some reason need to enable Secure Boot, you can follow the
[guide](https://github.com/perez987/OpenCore-and-UEFI-Secure-Boot) made by
perez987. The guide is a bit confusing to navigate through, but the key points are:

- [OpenCore and UEFI Secure Boot with WSL](https://github.com/perez987/OpenCore-and-UEFI-Secure-Boot/blob/1.0.7/guide/WSL%20Ubuntu%20VM%20on%20Windows.md)  
  If you're using Linux, just skip the WSL part, the rest is pretty much just
  Linux. The gist is you need a way to access to a Linux system, use VM, Live
  USB, [Multipass](https://multipass.run/), or WSL.
- [Insert signature to the UEFI firmware](https://github.com/perez987/OpenCore-and-UEFI-Secure-Boot/blob/1.0.7/guide/Insert%20keys%20into%20the%20firmware.md)  
  How I do it:
  - Copy `KeyTool.efi` from `/usr/share/efitools/efi/` to my EFI partition
    - Or use the one in `Signed/` directory if you use `signing-bootstrap` script
  - Copy all `.auth` file to my EFI partition
  - Reboot my Hack to BIOS settings, go to Secure Boot, select "Reset to Setup Mode" to enter Setup Mode
  - Boot to OpenCore, select `UEFI Shell`
  - Run `FS0:\KeyTool.efi`
  - Go to Edit Keys
  - The Allowed Signature Database (db)
    - Select Replace Key(s)
    - Go to `EFI`
    - Select `db.auth`
  - The Key Exchange Keys Database (KEK)
    - Select Replace Key(s)
    - Go to `EFI`
    - Select `KEK.auth`
  - The Platform Key (PK)
    - Select Replace Key(s)
    - Go to `EFI`
    - Select `PK.auth`
  - Exit
  - Run `reset`
  - Reboot to BIOS settings, greeted "Configuration Changed"
  - Reboot to BIOS settings again, go to Secure Boot, enable it, reboot to OpenCore
  - Profit-

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
  - Current workaround:
    - Use Karabiner: `karabiner://karabiner/assets/complex_modifications/import?url=https://raw.githubusercontent.com/null2264/ThinkPad-L460-OpenCore/master/Include/karabiner.json`  
      This config map Ctrl+F<1-12> into the function of FN+F<1-12>:
      - CTRL+F1 = FN+F1 -> Mute toggle
      - CTRL+F2 = FN+F2 -> Volume down
      - CTRL+F3 = FN+F3 -> Volume up
      - CTRL+F4 = FN+F4 -> *No alternative*
      - CTRL+F5 = FN+F5 -> Brightness down
      - CTRL+F6 = FN+F6 -> Brightness up
      - CTRL+F7 = FN+F7 -> *No alternative*
      - CTRL+F8 = FN+F8 -> *No alternative*
      - CTRL+F9 = FN+F9 -> *No alternative*
      - CTRL+F10 = FN+F10 -> Open Alfred (FN use Spotlight)
      - CTRL+F11 = FN+F11 -> Open Mission Control
      - CTRL+F12 = FN+F12 -> Open Launchpad
- DRM
  - iGPU-only DRM is completely broken, use browser with Widevine DRM instead
  - Some iGPU-only Laptop users reported that `unfairgva=4` fixed it, you may test it on your device, but this workaround doesn't seems to be working on my Laptop

### ❌ Not Working
- SD Card Reader (Disabled on BIOS)
  - If you need SD Card Reader you can try adding [Sinetek-rtsx](https://github.com/cholonam/Sinetek-rtsx) or [RealtekCardReader](https://github.com/0xFireWolf/RealtekCardReader) to your EFI

### ❓ Not Tested
- MiniDP
  - Need MiniDP adapter since none of my devices use MiniDP

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
- [@corpnewt](https://github.com/corpnewt) for [gibMacOS](https://github.com/corpnewt/gibMacOS) and [MountEFI](https://github.com/corpnewt/MountEFI)
- [@dortania](https://github.com/dortania) for their amazing [guide](https://dortania.github.io)
- [@jwise](https://github.com/jwise) for [HoRNDIS](https://github.com/jwise/HoRNDIS)
- [@perez987](https://github.com/perez987) for their [secure boot guide](https://github.com/perez987/OpenCore-and-UEFI-Secure-Boot)
- [@zhen-zen](https://github.com/zhen-zen) for [YogaSMC](https://github.com/zhen-zen/YogaSMC)
- [@zxystd](https://github.com/zxystd) for [itlwm](https://github.com/OpenIntelWireless/itlwm) and [IntelBluetoothFirmware](https://github.com/OpenIntelWireless/IntelBluetoothFirmware)
- [r/hackintosh](https://www.reddit.com/r/hackintosh) community for helping me find solution to various issue I came across

## 🔗 External Links
- [LENOVO ThinkPad L460 Technical Specs PDF](https://psref.lenovo.com/syspool/Sys/PDF/ThinkPad/ThinkPad_L460/ThinkPad_L460_Spec.PDF)
