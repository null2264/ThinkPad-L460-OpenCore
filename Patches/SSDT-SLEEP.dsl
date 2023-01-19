/* vim: ts=4 sw=4 et
 *
 * A L460 port for BenBender's SSDT-Sleep which is made for X1C6. Created to replace PTWK
 *
 * Ref: https://github.com/tylernguyen/x1c6-hackintosh/blob/main/patches/SSDT-Sleep.dsl
 */
DefinitionBlock ("", "SSDT", 2, "ZIRO", "SLEEP", 0x00000000)
{
    // Common utils from SSDT-Darwin.dsl
    External (OSDW, MethodObj) // 0 Arguments

    // Sleep config from BIOS
    External (S0ID, FieldUnitObj) // BIOS-S0 enabled, "Windows Modern Standby", not used by L460

    Name (DIEN, Zero) // DeepIdle (ACPI-S0) enabled
    Name (INIB, One) // Initial BootUp

    If (OSDW ())
    {
        Debug = "SLEEP: Enabling comprehensive S3-patching..."

        // Disable S0 for now
        S0ID = Zero
    }

    Name (SLTP, Zero)

    // Save sleep-state in SLTP on transition. Like a genuine Mac.
    Method (_TTS, 1, NotSerialized)  // _TTS: Transition To State
    {
        Debug = Concatenate ("SLEEP:_TTS() called with Arg0 = ", Arg0)

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
            Debug = "SLEEP:SPTS"

            If (\LIDS != \_SB.PCI0.LPC.EC.HPLD)
            {
                Debug = "SLEEP:SPTS - lid-state unsync."

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
                Debug = "SLEEP:SWAK - lid-state unsync."

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
                Debug = Concatenate ("SLEEP:_PTS called - Arg0 = ", Arg0)

                // On sleep
                If (OSDW () && (Arg0 < 0x05))
                {
                    SPTS ()
                }

                ZPTS (Arg0)

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
            Method (_WAK, 1, Serialized)
            {
                Debug = Concatenate ("SLEEP:_WAK - called Arg0: ", Arg0)

                // On Wake
                If (OSDW () && (Arg0 < 0x05))
                {
                    SWAK ()
                }

                Local0 = ZWAK(Arg0)

                Return (Local0)
            }
        }
    }


    // Handles sleep/wake on ACPI-S0-DeepIdle
    Scope (_SB.PCI0.LPC)
    {
        Method (_PS0, 0, Serialized)
        {
            If (OSDW () && DIEN == One && INIB == Zero)
            {
                \SWAK ()
            }

            If (INIB == One)
            {
                INIB = Zero
            }
        }

        Method (_PS3, 0, Serialized)
        {
            If (OSDW () && DIEN == One)
            {
                \SPTS ()
            }
        }
    }


    Scope (_SB)
    {
        // Enable ACPI-S0-DeepIdle
        Method (LPS0, 0, NotSerialized)
        {
            If (DIEN == One)
            {
                Debug = "SLEEP: Enable S0-Sleep / DeepSleep"
            }

            // If S0ID is enabled, enable deep-sleep in OSX. Can be set above.
            // Return (S0ID)
            Return (DIEN)
        }
    }
}
