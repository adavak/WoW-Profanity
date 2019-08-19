local AddonName, Addon = ...
 
if (GetLocale() == "frFR") then
    Addon.Loc = {
        Title = "Rare Share",
        Died = "est mort",
        AlreadyAnnounced = "a déjà été annoncé récemment",
        RareFound = "Rare trouvé! Annonce au chat..",
        Enabled = "Activé",
        Disabled = "Désactivé",
        Config = {
            RareAnnounce = {
                "Enable Chat Announcements",
                "Enables/Disables announcing rares to general chat when targeted",
            },
            Sound = {
                "Enable Sounds",
                "Enables/Disables audible clues when rares are tagged",
            },
            TomTom = {
                "Enable TomTom Waypoints",
                "Enables/Disables automatic tomtom waypoints",
            },
            OnDeath = {
                "Enable On Death Announcements (Use at own risk)",
                "Enables/Disables announcing the death of rares to chat",
            },
            Duplicates = {
                "Enable Notifications For Already Completed Rares",
                "Enables/Disables reacting to rares that have already been completed today",
            }
        }
    }
end