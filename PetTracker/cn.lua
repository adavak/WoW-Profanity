local _, Addon = ...
local L = Addon.Locals
if GetLocale() ~= 'zhCN' then return end

L.AddWaypoint = '添加路径点'
L.AlertUpgrades = '升级提醒'
L.AlertUpgradesTip = '如禁用，战斗中野生宠物战斗升级提醒框将不再显示，但升级将以一个标记显示。位置：（|TInterface\\GossipFrame\\AvailableQuestIcon:0:0:-1:-2|t）。'
L.AskForfeit = '没有可供升级，退出战斗？'
L.AvailableBreeds = '\n可用种属：'
L.PromptForfeit = '提示损耗'
L.PromptForfeitTip = '如启用，宠物战斗中将在没有升级可用的情况下提示损耗。'
L.BattlePets = '战斗宠物'
L.Breed = '种属'
L.BreedExplanation = '确定每级上涨种属属性情况。'
L.CapturedPets = '已捕获宠物'
L.CommonSearches = '通用搜索'
L.FilterPets = '过滤宠物'
L.ShowJournal = '在日志中显示'
L.Maximized = '最大'
L.NoneCollected = '未收集'
L.ShowPets = '显示战斗宠物'
L.ShowStables = '显示管理员'
L.StableTip = '|cffffd200到此治疗|n宠物，些许花费。|r'
L.UpgradeAlert = '野生宠物出现！'
L.ZoneTracker = '区域追踪'

L.FAQ = {
	'应该怎样使地图只显示特定的宠物？',
	'在世界地图的右上角有一个过滤框。参见教程获得更多的信息和常见的举例。',

	'怎么再次切换区域跟踪？',
	'右击目标头像和切换战斗宠物。或者，打开宠物日志，并在右下角单击区域跟踪。',

	'应该怎样显示已经在区域跟踪捕获的宠物？',
	'右击目标头像并启用缺失宠物。',

	'应该怎样禁用的战斗升级提醒？',
	'到登陆界面并在插件列表中禁用 PetTracker Upgrades。',

	'如何才能再次看到教程？',
	'点击按钮右侧。'
}

L.Tutorial = {
[[欢迎！现在使用的是 |cffffd200PetTracker|r，由 |cffffd200Jaliborc|r 制作，|cffffd200Adavak - CN 斯坦索姆|r简体中文汉化。

这个小教程帮助你快速了解此插件，这样就可以知道什么是真正需要去做的：把……他们……一网打尽！]],

[[PetTracker 将帮助监视当前区域的进度。

|cffffd200区域追踪|r显示缺失的宠物及捕获宠物的稀有度。]],

[[如要隐藏区域追踪，|cffffd200右击|r物品列表表头。然后，禁用|cffffd200显示战斗宠物|r。

也可禁用|cffffd200显示已捕获宠物|r来只显示缺失的宠物。]],

'现在将在世界地图上看看 PetTracker 可以做什么。请|cffffd200打开|r来开始。',

[[PetTracker 在世界地图上显示所有宠物的可能来源，从捕获位置到供应商。

如要隐藏位置，打开|cffffd200地图选项|r下拉列表并禁用|cffffd200显示战斗宠物|r。]],

[[还可以过滤高亮显示的搜索框中输入的宠物。举例说明：

• |cffffd200猫（Cat）|r代表猫种类。
• |cffffd200缺失（Missing）|r代表你并未拥有。
• |cffffd200水栖（Aquatic）|r代表水栖类。
• |cffffd200任务（Quest）|r代表从任务获取的宠物。
• |cffffd200森林（Forest）|r代表栖息在森林。]],

[[可以进一步搜索更精确的结果相结合：

• |cffffd200水栖（Aquatic） 猫（Cat）|r代表……对了，水栖猫类！
• |cffffd200非（Not） 猫（Cat）|r代表非猫类宠物。
• |cffffd200> 常见（Common）|r代表有一种或更好类的的宠物。
• |cffffd200森林（Forest） | 水栖（Aquatic）|r代表森林和水栖类型。|r]],

[[这只是个调用！未来版本中，可以在|cffffd200插件|r类别的|cffffd200插件选项|r里在观看教程。]]
}