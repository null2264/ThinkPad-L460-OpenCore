/* vim: ts=4 sw=4 et
 *
 * Helper SSDT, implements native Mac stuff
 */

DefinitionBlock ("", "SSDT", 2, "GWYD", "RMI", 0)
{
    External (_SB.PCI0.SBUS, DeviceObj)

    Scope (\_SB.PCI0.SBUS)
    {
        Name (RCFG, Package()
        {
            "TrackpointMultiplier", 3,
        })
    }
}