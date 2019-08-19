local AddonName, Addon = ...

if (GetLocale() == "zhCN") then
    Addon.Loc = {
    Title = "稀有共享",
    Died = "已死",
    AlreadyAnnounced = "最近已经通告",
    RareFound = "发现稀有！通告到聊天…",
    Enabled = "已启用",
    Disabled = "已禁用",
    Config = {
        RareAnnounce = {
            "启用聊天通告",
            "启用/禁用目标为稀有时通告到常用聊天",
        },
        Sound = {
            "启用音效",
            "启用/禁用目标为稀有时音效提示",
        },
        TomTom = {
            "启用 TomTom 路径点",
            "启用/禁用自动 TomTom 路径点",
        },
        OnDeath = {
            "启用死亡通告（风险自负）",
            "启用/禁用稀有死亡时的聊天通告",
        },
        Duplicates = {
            "启用已完成稀有稀有提示",
            "启用/禁用当日已完成稀有提示",
        }
    }
}
end