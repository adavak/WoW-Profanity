local AddonName, Addon = ...

if (GetLocale() == "ruRU") then
    Addon.Loc = {
        Title = "Rare Share",
        Died = "мёртв",
        AlreadyAnnounced = "- о нём уже недавно сообщали",
        RareFound = "Найдено редкое существо! Сообщаю в чат..",
        Enabled = "Включен",
        Disabled = "Отключен",
        Config = {
            RareAnnounce = {
                "Включить оповещения в чат",
                "Включить/выключить оповещения в общий чат о редких существах при взятии их в цель",
            },
            Sound = {
                "Включить звуковые оповещения",
                "Включить/выключить звуковые оповещения о замеченных редких существах",
            },
            TomTom = {
                "Включить навигацию TomTom",
                "Включить/выключить навигацию TomTom",
            },
            OnDeath = {
                "Включить оповещения о смерти (используйте на свой страх и риск)",
                "Включить/выключить оповещения о смерти редких существ в чат",
            },
            Duplicates = {
                "Enable Notifications For Already Completed Rares",
                "Enables/Disables reacting to rares that have already been completed today",
            },
        }
    }
end