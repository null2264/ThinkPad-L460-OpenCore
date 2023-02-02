# FN Key Journey

This is a log of my journey trying to fix FN Key on L460 so that I can look up
my previous findings more easily.

This issue was started when I succesfully installed Catalina to my L460
machine, it works great until I did S3/S4 sleep, for some reason after waking
up the touchpad become sluggish, FN hotkeys stop working, and sometimes apps
just suddenly freezed and crashed shortly after. I tried adding SBUS-MCHC
patch, but that didn't work, I tried to redo the PM patch, still happened.
After several failed attempts I decided to upgrade to Monterey, I wasn't
expecting much but somehow it fixed the app crashes and touchpad no longer
sluggish after sleep, but unfortnately the FN hotkeys still a problem. After a
lot of fails I decided to just disable sleep entirely.

After Ventura release reach RC stage, I decided to enable the sleep function
again and try to fix it for Ventura. I tried adding YogaSMC, while it does make
FN hotkeys experience a lot better, S3/S4 sleep still caused it to stop
working. At the end I give up and disable S3/S4 sleep again, but this time I
let it sleep up to S0.

Ventura soon released, and I decided to upgrade my hack to use Ventura.
Succesfully spoof the GPU to HD620 and fix the annoying flicker issue, I
decided to give another try on fixing the FN keys. This time I decided to look
deeper, since I finally understand a bit about SSDT and ACPI stuff, I decided
to add some tracing logs onto \_Qxx methods that I believe the one that
responsible on handling FN hotkeys. Because of this I finally know the main
issue, that is \_Qxx methods for whatever reason doesn't get invoked after
S3/S4 sleep. I try to find everywhere on DSDT to see if there is a way to reset
this, maybe it's in \_INI, maybe something is changed in \_PTS but never
restored in \_WAK. But all of it led to nothing.

After search around the internet I came across [a
repo](https://github.com/masksshow/Thinkpad-E14-15-AMD-Gen-2-FIX) that claim to
fix FN-keys for E14 on Linux, I thought it may work on macOS for L460, the "fix"
seems easy enough, all they did is set H8DR's value to One instead of Zero.
Unfortunately this still doesn't fix my issue, so I decided to look deeper and
found an attached link to [a
forum](https://forums.lenovo.com/t5/Other-Linux-Discussions/Linux-Fn-keys-not-working-Thinkpad-E14-AMD-Gen-2/m-p/5027791?page=8).
Sadly that also led to nothing, as the fix for E14 is a BIOS Update. I did try
updating my BIOS to the latest version, still doesn't fix it.

As I keep searching, I found out that this issue seems to be a common
unresolved issue for ThinkPad E-series and L-series. I found several forums on
E-series hackintosh about the issue, but the result is the same, either the OP
stop responding or forum staffs giving up the issue.

REF:
- https://github.com/zhen-zen/YogaSMC/issues/112
- https://www.tonymacx86.com/threads/fn-shortcuts-lid-sleep-not-working-after-waking-from-s3-sleep-thinkpad-e480.294343/
- https://www.tonymacx86.com/threads/lid-close-stop-working-after-sleep.279447/page-4

Currently, I still have no idea how to fix this, I've compared L460's DSDT with
a confirmed working ThinkPad model's DSDT but I couldn't find anything that
would caused this issue. For now the only "fix" I can do is to disable S3/S4
sleep and only use S0 for sleep, or disable sleep entirely.
