local AddonName, Addon = ...

if (GetLocale() == "enUS") then
    Addon.Loc = {
        Title = "Rare Share",
        Died = "gestorben",
        AlreadyAnnounced = "wurde eben schon angekündigt",
        RareFound = "Rare gefunden! Wird im Chat angekündigt.",
        Enabled = "Eingeschaltet",
        Disabled = "Ausgeschaltet",
        Config = {
            RareAnnounce = {
                "Chat-Ankündigungen aktivieren",
                "Schaltet die Ankündigung im Allgemein-Channel von seltenen Gegnern, die ins Ziel genommen wurden, ein bzw. aus.",
            },
            Sound = {
                "Hinweiston aktivieren",
                "Schaltet den Ton, wenn ein seltener Gegner von einem anderen Spieler zum ersten Mal ins Ziel genommen wurde ein bzw. aus.",
            },
            TomTom = {
                "Tom-Tom Wegpunkte aktivieren",
                "Schaltet die automatische Erstellung von Tom-Tom Wegpunkten an bzw. aus.",
            },
            OnDeath = {
                "Ankündigung Rare-Tod aktivieren (Benutzung auf eigene Gefahr!)",
                "Schaltet die Ankündigung über den gerade stattgefundenen Tod des seltenen Gegners ein bzw. aus.",
            },
            Duplicates = {
                "Enable Notifications For Already Completed Rares",
                "Enables/Disables reacting to rares that have already been completed today",
            },
        }
    }
end