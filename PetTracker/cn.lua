local _, Addon = ...
local L = Addon.Locals
if GetLocale() ~= 'zhCN' then return end

L.AddWaypoint = '添加路径点'
L.BattlePets = '战斗宠物'
L.CapturedPets = '已捕获宠物'
L.CommonSearches = '通用搜索'
L.FilterPets = '过滤宠物'
L.ShowJournal = '在日志中显示'
L.Maximized = '最大'
L.ShowPets = '显示战斗宠物'
L.ShowStables = '显示管理员'
L.StableTip = '|cffffd200到此治疗|n宠物，些许花费。|r'
L.UpgradeAlert = '野生宠物出现！'
L.ZoneTracker = '区域追踪'

L.Tutorial1 =
[[欢迎！现在使用的是 |cffffd200PetTracker|r，由 |cffffd200Jaliborc|r 制作，|cffffd200Adavak - CN 斯坦索姆|r简体中文汉化。

这个小教程帮助你快速了解此插件，这样就可以知道什么是真正需要去做的：把……他们……一网打尽！]]

L.Tutorial2 =
[[PetTracker 将帮助监视当前区域的进度。

|cffffd200区域追踪|r显示缺失的宠物及捕获宠物的稀有度。]]

L.Tutorial3 =
[[如要隐藏区域追踪，|cffffd200右击|r物品列表表头。然后，禁用|cffffd200显示战斗宠物|r。

也可禁用|cffffd200显示已捕获宠物|r来只显示缺失的宠物。]]

L.Tutorial4 = '现在将在世界地图上看看 PetTracker 可以做什么。请|cffffd200打开|r来开始。'
L.Tutorial5 =
[[PetTracker 在世界地图上显示所有宠物的可能来源，从捕获位置到供应商。

如要隐藏位置，打开|cffffd200地图选项|r下拉列表并禁用|cffffd200显示战斗宠物|r。]]

L.Tutorial6 =
[[还可以过滤高亮显示的搜索框中输入的宠物。举例说明：

• |cffffd200猫（Cat）|r代表猫种类。
• |cffffd200缺失（Missing）|r代表你并未拥有。
• |cffffd200水栖（Aquatic）|r代表水栖类。
• |cffffd200任务（Quest）|r代表从任务获取的宠物。
• |cffffd200森林（Forest）|r代表栖息在森林。]]

L.Tutorial7 =
[[可以进一步搜索更精确的结果相结合：

• |cffffd200水栖（Aquatic） 猫（Cat）|r代表……对了，水栖猫类！
• |cffffd200非（Not） 猫（Cat）|r代表非猫类宠物。
• |cffffd200> 常见（Common）|r代表有一种或更好类的的宠物。
• |cffffd200森林（Forest） | 水栖（Aquatic）|r代表森林和水栖类型。|r]]

L.Tutorial8 = [[这只是个调用！未来版本中，可以在|cffffd200插件|r类别的|cffffd200插件选项|r里在观看教程。]]