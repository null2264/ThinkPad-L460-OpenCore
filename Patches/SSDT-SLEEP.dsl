/* vim: ts=4 sw=4 et
 *
 * A L460 port for BenBender's SSDT-Sleep which is made for X1C6. Created to replace PTWK
 *
 * Ref: https://github.com/tylernguyen/x1c6-hackintosh/blob/main/patches/SSDT-Sleep.dsl
 *
 * Config.plist -> ACPI -> Patch
 * Comment: SLEEP: _PTS to ZPTS
 * Find:    5F 50 54 53 01
 * Replace: 5A 50 54 53 01
 *
 * Comment: SLEEP: _WAK to ZWAK
 * Find:    5F 57 41 4B 01
 * Replace: 5A 57 41 4B 01
 */

DefinitionBlock ("", "SSDT", 2, "ZIRO", "SLEEP", 0x00000000)
{
    // From SSDT-DARWIN.dsl
    External (OSDW, MethodObj) // 0 Arguments

    If (OSDW ())
    {
        Debug = "SLEEP: Enabling comprehensive S3-patching..."
    }

    Name (SLTP, Zero)

    // Save sleep-state in SLTP on transition. Like a genuine Mac.
    Method (_TTS, 1, NotSerialized)  // _TTS: Transition To State
    {
        Debug = Concatenate ("SLEEP: _TTS () called with Arg0 = ", Arg0)

        SLTP = Arg0
    }

    // @SEE https://github.com/tianocore/edk2-platforms/blob/master/Platform/Intel/KabylakeOpenBoardPkg/Acpi/BoardAcpiDxe/Dsdt/Gpe.asl
    // @SEE https://pikeralpha.wordpress.com/2017/01/12/debugging-sleep-issues/
    Scope (_GPE)
    {
        // This tells xnu to evaluate _GPE.Lxx methods on resume
        Method (LXEN, 0, NotSerialized)
        {
            Return (One)
        }
    }

    External (_SB.PCI0.LPC, DeviceObj)
    External (_SB.PCI0.LPC.EC, DeviceObj)
    External (_SB.LID, DeviceObj)

    External (_SB.PCI0.LPC.EC.AC._PSR, MethodObj) // 0 Arguments
    External (_SB.PCI0.LPC.EC.LED, MethodObj) // 2 Arguments
    External (ZPTS, MethodObj) // 1 Arguments
    External (ZWAK, MethodObj) // 1 Arguments

    External (_SB.PCI0.XHCI.PMEE, FieldUnitObj)
    External (_SB.SCGE, FieldUnitObj)

    External (_SB.PCI0.LPC.EC.HPLD, FieldUnitObj)
    External (_SB.PCI0.GFX0.CLID, FieldUnitObj)
    External (LIDS, FieldUnitObj) // (from SaSsdt)
    External (PWRS, FieldUnitObj)
    External (TBTS, FieldUnitObj)

    Scope (\)
    {
        // Fix sleep
        Method (SPTS, 0, NotSerialized)
        {
            Debug = "SLEEP: SPTS"

            If (\LIDS != \_SB.PCI0.LPC.EC.HPLD)
            {
                Debug = "SLEEP: SPTS - lid-state unsync."

                \LIDS = \_SB.PCI0.LPC.EC.HPLD
                \_SB.PCI0.GFX0.CLID = LIDS
            }

            // Force-update LEDs, mainly used in ACPI-S0
            \_SB.PCI0.LPC.EC.LED (0x07, 0xA0)
            \_SB.PCI0.LPC.EC.LED (0x00, 0xA0)
            \_SB.PCI0.LPC.EC.LED (0x0A, 0xA0)
        }

        // Fix wake
        Method (SWAK, 0, NotSerialized)
        {
            Debug = "SLEEP:SWAK"

            If (\LIDS != \_SB.PCI0.LPC.EC.HPLD)
            {
                Debug = "SLEEP: SWAK - lid-state unsync."

                \LIDS = \_SB.PCI0.LPC.EC.HPLD
                \_SB.PCI0.GFX0.CLID = LIDS
            }

            // Wake screen on wake
            Notify (\_SB.LID, 0x80)

            // Force-update LEDs, just to be sure ;)
            \_SB.PCI0.LPC.EC.LED (0x00, 0x80)
            \_SB.PCI0.LPC.EC.LED (0x0A, 0x80)
            \_SB.PCI0.LPC.EC.LED (0x07, 0x80)

            // Update ac-state
            \PWRS = \_SB.PCI0.LPC.EC.AC._PSR ()

            \_SB.SCGE = One
        }

        If (CondRefOf (\ZPTS))
        {
            Method (_PTS, 1, NotSerialized)  // _PTS: Prepare To Sleep
            {
                Debug = Concatenate ("SLEEP: _PTS () called with Arg0 = ", Arg0)

                // On sleep
                If (OSDW () && (Arg0 < 0x05))
                {
                    SPTS ()
                }

                \ZPTS (Arg0)

                // On shutdown
                If (OSDW () && (Arg0 == 0x05))
                {
                    If (CondRefOf (\_SB.PCI0.XHCI.PMEE))
                    {
                        \_SB.PCI0.XHCI.PMEE = Zero
                    }
                }
            }
        }

        If (CondRefOf (\ZWAK))
        {
            // Patch _WAK to fire missing LID-Open event and update AC-state
            Method (_WAK, 1, NotSerialized)
            {
                Debug = Concatenate ("SLEEP: _WAK () called with Arg0: ", Arg0)

                // On Wake
                If (OSDW () && (Arg0 < 0x05))
                {
                    SWAK ()
                }

                Debug = Concatenate ("SLEEP: ZWAK () called with Arg0: ", Arg0)

                Local0 = \ZWAK (Arg0)

                Debug = Concatenate ("SLEEP: ZWAK () called with result: ", Local0)

                Return (Local0)
            }
        }
    }
}
