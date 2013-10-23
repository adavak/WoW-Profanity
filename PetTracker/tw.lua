local _, Addon = ...
local L = Addon.Locals
if GetLocale() ~= 'zhTW' then return end

L.AddWaypoint = '添加路徑點'
L.AlertUpgrades = '升級提醒'
L.AlertUpgradesTip = '如禁用，戰鬥中野生寵物戰鬥升級提醒框將不再顯示，但升級將以一個標記顯示。位置：（|TInterface\\GossipFrame\\AvailableQuestIcon:0:0:-1:-2|t）。 '
L.AskForfeit = '沒有可供升級，退出戰鬥？ '
L.AvailableBreeds = '\n可用種屬：'
L.PromptForfeit = '提示損耗'
L.PromptForfeitTip = '如啟用，寵物戰鬥中將在沒有升級可用的情況下提示損耗。 '
L.BattlePets = '戰鬥寵物'
L.Breed = '種屬'
L.BreedExplanation = '確定每級上漲種屬統計情況。 '
L.CapturedPets = '已捕獲寵物'
L.CommonSearches = '通用搜索'
L.FilterPets = '過濾寵物'
L.ShowJournal = '在日誌中顯示'
L.Maximized = '最大'
L.NoneCollected = '未收集'
L.ShowPets = '顯示戰鬥寵物'
L.ShowStables = '顯示管理員'
L.StableTip = '|cffffd200到此治療|n寵物，些許花費。 |r'
L.UpgradeAlert = '野生寵物出現！ '
L.ZoneTracker = '區域追踪'

L.FAQ = {
	'應該怎樣使地圖只顯示特定的寵物？ ',
	'在世界地圖的右上角有一個過濾框。參見教程獲得更多的信息和常見的舉例。 ',

	'怎麼再次切換區域跟踪？ ',
	'右擊目標頭像和切換戰鬥寵物。或者，打開寵物日誌，並在右下角單擊區域跟踪。 ',

	'應該怎樣顯示已經在區域跟踪捕獲的寵物？ ',
	'右擊目標頭像並啟用缺失寵物。 ',

	'應該怎樣禁用的戰鬥升級提醒？ ',
	'到登陸界面並在插件列表中禁用 PetTracker Upgrades。 ',

	'如何才能再次看到教程？',
	'點擊按鈕右側。 '
}

L.Tutorial = {
[[歡迎！現在使用的是|cffffd200PetTracker|r，由|cffffd200Jaliborc|r 製作，|cffffd200Adavak - CN 斯坦索姆|r簡體中文漢化。

這個小教程幫助你快速了解此插件，這樣就可以知道什麼是真正需要去做的：把……他們……一網打盡！ ]],

[[PetTracker 將幫助監視當前區域的進度。

|cffffd200區域追踪|r顯示缺失的寵物及捕獲寵物的稀有度。 ]],

[[如要隱藏區域追踪，|cffffd200右擊|r物品列表表頭。然後，禁用|cffffd200顯示戰鬥寵物|r。

也可禁用|cffffd200顯示已捕獲寵物|r來只顯示缺失的寵物。 ]],

'現在將在世界地圖上看看PetTracker 可以做什麼。請|cffffd200打開|r來開始。 ',

[[PetTracker 在世界地圖上顯示所有寵物的可能來源，從捕獲位置到供應商。

如要隱藏位置，打開|cffffd200地圖選項|r下拉列表並禁用|cffffd200顯示戰鬥寵物|r。 ]],

[[還可以過濾高亮顯示的搜索框中輸入的寵物。舉例說明：

• |cffffd200貓（Cat）|r代表貓種類。
• |cffffd200缺失（Missing）|r代表你並未擁有。
• |cffffd200水棲（Aquatic）|r代表水棲類。
• |cffffd200任務（Quest）|r代表從任務獲取的寵物。
• |cffffd200森林（Forest）|r代表棲息在森林。 ]],

[[可以進一步搜索更精確的結果相結合：

• |cffffd200水棲（Aquatic） 貓（Cat）|r代表……對了，水棲貓類！
• |cffffd200非（Not） 貓（Cat）|r代表非貓類寵物。
• |cffffd200> 常見（Common）|r代表有一種或更好類的的寵物。
• |cffffd200森林（Forest） | 水棲（Aquatic）|r代表森林和水棲類型。 |r]],

[[這只是個調用！未來版本中，可以在|cffffd200插件|r類別的|cffffd200插件選項|r裡在觀看教程。 ]]
}