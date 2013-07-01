local _, Addon = ...
local L = Addon.Locals
if GetLocale() ~= 'zhTW' then return end

L.AddWaypoint = '添加路徑點'
L.BattlePets = '戰鬥寵物'
L.CapturedPets = '已捕獲寵物'
L.CommonSearches = '通用搜索'
L.FilterPets = '過濾寵物'
L.ShowJournal = '在日誌中顯示'
L.Maximized = '最大'
L.ShowStables = '顯示管理員'
L.StableTip = '|cffffd200到此治療|n寵物，些許花費。 |r'
L.UpgradeAlert = '野生寵物出現！ '
L.ZoneTracker = '區域追踪'

L.Tutorial1 =
[[歡迎！現在使用的是 |cffffd200PetTracker|r，由 |cffffd200Jaliborc|r 製作，|cffffd200Adavak - CN 斯坦索姆|r繁體中文漢化。

這個小教程幫助你快速了解此插件，這樣就可以知道什麼是真正需要去做的：把……他們……一網打盡！]]

L.Tutorial2 =
[[PetTracker 將幫助監視當前區域的進度。

|cffffd200區域追踪|r顯示缺失的寵物及捕獲寵物的稀有度。]]

L.Tutorial3 =
[[如要隱藏區域追踪，|cffffd200右擊|r物品列表表頭。然後，禁用|cffffd200顯示戰鬥寵物|r。

也可禁用|cffffd200顯示已捕獲寵物|r來只顯示缺失的寵物。]]

L.Tutorial4 = '現在將在世界地圖上看看 PetTracker 可以做什麼。請|cffffd200打開|r來開始。'
L.Tutorial5 =
[[PetTracker 在世界地圖上顯示所有寵物的可能來源，從捕獲位置到供應商。

如要隱藏位置，打開|cffffd200地圖選項|r下拉列表並禁用|cffffd200顯示戰鬥寵物|r。 ]]

L.Tutorial6 =
[[還可以過濾高亮顯示的搜索框中輸入的寵物。舉例說明：

• |cffffd200貓（Cat）|r代表貓種類。
• |cffffd200缺失（Missing）|r代表你並未擁有。
• |cffffd200水棲（Aquatic）|r代表水棲類。
• |cffffd200任務（Quest）|r代表從任務獲取的寵物。
• |cffffd200森林（Forest）|r代表棲息在森林。]]

L.Tutorial7 =
[[可以進一步搜索更精確的結果相結合：

• |cffffd200水棲（Aquatic） 貓（Cat）|r代表……對了，水棲貓類！
• |cffffd200非（Not） 貓（Cat）|r代表非貓類寵物。
• |cffffd200> 常見（Common）|r代表有一種或更好類的的寵物。
• |cffffd200森林（Forest） | 水棲（Aquatic）|r代表森林和水棲類型。|r]]

L.Tutorial8 = [[這只是個調用！未來版本中，可以在|cffffd200插件|r類別的|cffffd200插件選項|r裡在觀看教程。]]