-- Thanks to all who provides usable code
local _G = getfenv(0)
-- Libraries
local string = _G.string;
local format = string.format
local gsub = string.gsub
local next = next
local wipe = wipe
local GameTooltip = GameTooltip
local WorldMapTooltip = WorldMapTooltip
-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...

local Argus = LibStub("AceAddon-3.0"):NewAddon("ArgusRaresTreasures", "AceBucket-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes", true)
local _L = LibStub("AceLocale-3.0"):GetLocale("HandyNotes_Argus");
if not HandyNotes then return end

local objAtlas = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\ObjectIconsAtlas.blp";
local iconDefaults = {
    skull_grey = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\RareWhite.blp",
    skull_purple = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\RarePurple.blp",
    skull_blue = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\RareBlue.blp",
    skull_yellow = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\RareYellow.blp",
    battle_pet = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\BattlePet.blp",
	treasure = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\Treasure.blp",
	portal = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\Portal.blp",
	default = "Interface\\Icons\\TRADE_ARCHAEOLOGY_CHESTOFTINYGLASSANIMALS",
	starChest = {
		icon = objAtlas,
		tCoordLeft = 351/512, tCoordRight = 383/512, tCoordTop = 408/512, tCoordBottom = 440/512,
	},
	starChestBlue = {
		icon = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\shootboxes.blp",
		tCoordLeft = 6/256, tCoordRight = 58/256, tCoordTop = 6/64, tCoordBottom = 58/64,
	},
	starChestPurple = {
		icon = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\shootboxes.blp",
		tCoordLeft = (64+6)/256, tCoordRight = (64+58)/256, tCoordTop = 6/64, tCoordBottom = 58/64,
	},
	starChestYellow = {
		icon = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\shootboxes.blp",
		tCoordLeft = (128+6)/256, tCoordRight = (128+58)/256, tCoordTop = 6/64, tCoordBottom = 58/64,
	},
	starChestBlank = {
		icon = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\shootboxes.blp",
		tCoordLeft = (192+6)/256, tCoordRight = (192+58)/256, tCoordTop = 6/64, tCoordBottom = 58/64,
	},
}
local itemTypeMisc = 0;
local itemTypePet = 1;
local itemTypeMount = 2;
local itemTypeToy = 3;
local itemTypeTransmog = 4;

Argus.nodes = { }

local nodes = Argus.nodes
local isTomTomloaded = false
local isDBMloaded = false
local isCanIMogItloaded = false

-- [XXXXYYYY] = { questId, icon, group, label, loot, note, search },
-- /run local find="Crimson Slavermaw"; for i,mid in ipairs(C_MountJournal.GetMountIDs()) do local n,_,_,_,_,_,_,_,_,_,c,j=C_MountJournal.GetMountInfoByID(mid); if ( n == find ) then print(j .. " " .. n); end end
-- /run local find="Fel-Afflicted Skyfin"; for i=0,2500 do local n=C_PetJournal.GetPetInfoBySpeciesID(i); if ( n == find ) then print(i .. " " .. n); end end

-- Antoran Wastes
nodes["ArgusCore"] = {
	[52702950] = { npcId=127291, questId=48822, icon="skull_grey", group="rare_aw", label="监视者艾瓦", search="监视者", loot=nil, note=nil },
	[63902090] = { npcId=126040, questId=48809, icon="skull_grey", group="rare_aw", label="普希拉", search="普希拉", loot={ { 152903, itemTypeMount, 981 } }, note="洞穴入口在东南方 - 从东面的桥到达那里。" },
	[53103580] = { npcId=126199, questId=48810, icon="skull_grey", group="rare_aw", label="弗拉克苏尔", search="弗拉克苏尔", loot={ { 152903, itemTypeMount, 981 } }, note=nil },
	[63225754] = { npcId=126115, questId=48811, icon="skull_grey", group="rare_aw", label="维农", search="维农", loot=nil, note="洞穴入口在东北方，从蜘蛛区域 66, 54.1" },
	[64304820] = { npcId=126208, questId=48812, icon="skull_grey", group="rare_aw", label="瓦加", search="瓦加", loot={ { 153190, itemTypeMisc }, { 153054, itemTypePet, 2118 }, { 153055, itemTypePet, 2119 }, { 152841, itemTypeMount, 975 }, { 152843, itemTypeMount, 906 }, { 152842, itemTypeMount, 974 }, { 152840, itemTypeMount, 976 } }, note=nil },
	[62405380] = { npcId=126254, questId=48813, icon="skull_grey", group="rare_aw", label="萨卡尔中尉", search="中尉", loot=nil, note=nil },
	[61906430] = { npcId=126338, questId=48814, icon="skull_grey", group="rare_aw", label="愤怒领主亚雷兹", search="愤怒领主", loot={ { 153126, itemTypeToy } }, note=nil },
	[60674831] = { npcId=126946, questId=48815, icon="skull_grey", group="rare_aw", label="审判官维斯洛兹", search="审判官", loot={ { 151543, itemTypeMisc } }, note=nil },
	[80206230] = { npcId=nil, questId=48816, icon="portal", group="rare_aw", label="传送到指挥官泰克拉兹", loot=nil, note=nil },
	[82006600] = { npcId=127084, questId=48816, icon="skull_grey", group="rare_aw", label="指挥官泰克拉兹", search="指挥官", loot=nil, note="使用偏西的传送门位于 80.2, 62.3 到达船上" },
	[73207080] = { npcId=127090, questId=48817, icon="skull_grey", group="rare_aw", label="雷尔瓦将军", search="将军", loot={ { 153324, itemTypeTransmog, "盾牌" } }, note=nil },
	[76155614] = { npcId=127096, questId=48818, icon="skull_grey", group="rare_aw", label="全知者萨纳里安", search="全知者", loot=nil, note=nil },
	[50905530] = { npcId=127118, questId=48820, icon="skull_grey", group="rare_aw", label="裂世者斯库尔", search="裂世者", loot={ { 153312, itemTypeTransmog, "双手剑" } }, note="会在天上盘旋。偶尔也会降落。不是每次盘旋都这样。" },
	[63812199] = { npcId=127288, questId=48821, icon="skull_grey", group="rare_aw", label="驯犬大师克拉克斯", search="驯犬大师", loot={ { 152790, itemTypeMount, 955 } }, note=nil },
	[55702190] = { npcId=127300, questId=48824, icon="skull_grey", group="rare_aw", label="虚空守望者瓦苏拉", search="虚空守望者", loot={ { 153319, itemTypeTransmog, "双手锤" } }, note=nil },
	[61392095] = { npcId=127376, questId=48865, icon="skull_grey", group="rare_aw", label="首席炼金师蒙库鲁斯", search="首席炼金师", loot=nil, note=nil },
	[54003800] = { npcId=127581, questId=48966, icon="skull_grey", group="rare_aw", label="千面吞噬者", search="千面", loot={ { 153195, itemTypePet, 2136 } }, note=nil },
	[77177319] = { npcId=nil, questId=48967, icon="portal", group="rare_aw", label="传送到中队指挥官维沙克斯", loot=nil, note="第一步先从不朽虚无行者身上找到碎裂的传送门发生器。然后从艾瑞达战术顾问、魔誓侍从身上收集导电护套，弧光电路，能量电池，使用碎裂的传送门发生器把它们组合起来打开去往维沙克斯的传送门。" },
	[84368118] = { npcId=127700, questId=48967, icon="skull_grey", group="rare_aw", label="中队指挥官维沙克斯", search="中队指挥官", loot={ { 153253, itemTypeToy } }, note="使用传送门位于 77.2, 73.2 上船" },
	[58001200] = { npcId=127703, questId=48968, icon="skull_grey", group="rare_aw", label="末日法师苏帕克斯", search="末日法师", loot={ { 153194, itemTypeToy } }, note=nil },
	[66981777] = { npcId=127705, questId=48970, icon="skull_grey", group="rare_aw", label="主母罗苏拉", search="主母", loot={ { 152903, itemTypeMount, 981 }, { 153252, itemTypePet, 2135 } }, note="洞穴入口在东南方 - 从东面的桥到达那里。收集洞里小鬼掉的100个小鬼的肉。使用它做一份黑暗料理扔进绿池子里召唤主母。" },
	[64948290] = { npcId=127706, questId=48971, icon="skull_grey", group="rare_aw", label="先知雷兹拉", search="先知", loot={ { 153293, itemTypeToy } }, note="使用观察者之地共鸣器打开传送门。收集500个恶魔之眼把它交给位于 60.2, 45.4 的全视者奥利克斯换取。" },
	[61703720] = { npcId=122958, questId=49183, icon="skull_grey", group="rare_aw", label="疱喉", search="疱喉", loot={ { 152905, itemTypeMount, 979 } }, note=nil },
	[57403290] = { npcId=122947, questId=49240, icon="skull_grey", group="rare_aw", label="妖女伊森黛拉", search="妖女", loot={ { 153327, itemTypeTransmog, "匕首" } }, note=nil },
	[56204550] = { npcId=122999, questId=49241, icon="skull_grey", group="rare_aw", label="加尔佐斯", search="加尔佐斯", loot=nil, note=nil },


	[59804030] = { npcId=128024, questId=0, icon="battle_pet", group="pet_aw", label="小乌祖", loot=nil, note=nil },
	[76707390] = { npcId=128023, questId=0, icon="battle_pet", group="pet_aw", label="小型克西斯号", loot=nil, note=nil },
	[51604140] = { npcId=128019, questId=0, icon="battle_pet", group="pet_aw", label="凝视者", loot=nil, note=nil },
	[56605420] = { npcId=128020, questId=0, icon="battle_pet", group="pet_aw", label="小胖", loot=nil, note=nil },
	[56102870] = { npcId=128021, questId=0, icon="battle_pet", group="pet_aw", label="啮耳者", loot=nil, note=nil },
	[64106600] = { npcId=128022, questId=0, icon="battle_pet", group="pet_aw", label="小贼", loot=nil, note=nil },

	-- 48382
	[67546980] = { questId=48382, icon="treasure", group="treasure_aw", label="48382", loot=nil, note="建筑物内" },
	[67466226] = { questId=48382, icon="treasure", group="treasure_aw", label="48382", loot=nil, note=nil },
	[71326946] = { questId=48382, icon="treasure", group="treasure_aw", label="48382", loot=nil, note="在哈多克斯边上" },
	[58066806] = { questId=48382, icon="treasure", group="treasure_aw", label="48382", loot=nil, note=nil }, -- Doe
	[68026624] = { questId=48382, icon="treasure", group="treasure_aw", label="48382", loot=nil, note="军团建筑物内" },
	-- 48383
	[56903570] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note=nil },
	[57633179] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note=nil },
	[52182918] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note=nil },
	[58174021] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note=nil },
	[51863409] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note=nil },
	[55133930] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note=nil },
	[58413097] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note="建筑物内，第一层" },
	[53753556] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note=nil },
	[51703529] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note="悬崖的高处" },
	-- 48384
	[60872900] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note=nil },
	[61332054] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note="首席炼金师蒙库鲁斯建筑物内" },
	[59081942] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note="建筑物内" },
	[64152305] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note="驯犬大师克拉克斯洞穴内" },
	[66621709] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note="小鬼洞穴内，主母罗苏拉旁边" },
	[63682571] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note=nil },
	[61862236] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note="外面，首席炼金师蒙库鲁斯旁边" },
	[64132738] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note=nil }, -- Doe
	-- 48385
	[50605720] = { questId=48385, icon="treasure", group="treasure_aw", label="48385", loot=nil, note=nil },
	[50655715] = { questId=48385, icon="treasure", group="treasure_aw", label="48385", loot=nil, note=nil },
	[55544743] = { questId=48385, icon="treasure", group="treasure_aw", label="48385", loot=nil, note=nil },
	[57135124] = { questId=48385, icon="treasure", group="treasure_aw", label="48385", loot=nil, note=nil },
	[55915425] = { questId=48385, icon="treasure", group="treasure_aw", label="48385", loot=nil, note=nil }, -- Doe
	-- 48387
	[69403965] = { questId=48387, icon="treasure", group="treasure_aw", label="48387", loot=nil, note=nil },
	[66643654] = { questId=48387, icon="treasure", group="treasure_aw", label="48387", loot=nil, note=nil },
	[68983342] = { questId=48387, icon="treasure", group="treasure_aw", label="48387", loot=nil, note=nil },
	[65522831] = { questId=48387, icon="treasure", group="treasure_aw", label="48387", loot=nil, note="桥下" },
	[63613643] = { questId=48387, icon="treasure", group="treasure_aw", label="48387", loot=nil, note=nil }, -- Doe
	[73404669] = { questId=48387, icon="treasure", group="treasure_aw", label="48387", loot=nil, note="跳过软泥" },
	[67954006] = { questId=48387, icon="treasure", group="treasure_aw", label="48387", loot=nil, note=nil },
	-- 48388
	[51502610] = { questId=48388, icon="treasure", group="treasure_aw", label="48388", loot=nil, note=nil },
	[59261743] = { questId=48388, icon="treasure", group="treasure_aw", label="48388", loot=nil, note=nil },
	[55921387] = { questId=48388, icon="treasure", group="treasure_aw", label="48388", loot=nil, note=nil },
	[55841722] = { questId=48388, icon="treasure", group="treasure_aw", label="48388", loot=nil, note=nil },
	[55622042] = { questId=48388, icon="treasure", group="treasure_aw", label="48388", loot=nil, note="虚空守望者瓦苏拉边上，条上岩石斜坡" },
	[59661398] = { questId=48388, icon="treasure", group="treasure_aw", label="48388", loot=nil, note=nil }, -- Doe
	[54102803] = { questId=48388, icon="treasure", group="treasure_aw", label="48388", loot=nil, note="艾瓦平台旁边" },
	-- 48389
	[64305040] = { questId=48389, icon="treasure", group="treasure_aw", label="48389", loot=nil, note="瓦加洞穴内" },
	[60254351] = { questId=48389, icon="treasure", group="treasure_aw", label="48389", loot=nil, note=nil },
	[65514081] = { questId=48389, icon="treasure", group="treasure_aw", label="48389", loot=nil, note=nil },
	[60304675] = { questId=48389, icon="treasure", group="treasure_aw", label="48389", loot=nil, note=nil },
	[65345192] = { questId=48389, icon="treasure", group="treasure_aw", label="48389", loot=nil, note="瓦加后面的洞穴内" },
	[64114242] = { questId=48389, icon="treasure", group="treasure_aw", label="48389", loot=nil, note="岩石下" },
	-- 48390
	[81306860] = { questId=48390, icon="treasure", group="treasure_aw", label="48390", loot=nil, note="在船上" },
	[80406152] = { questId=48390, icon="treasure", group="treasure_aw", label="48390", loot=nil, note=nil },
	[82566503] = { questId=48390, icon="treasure", group="treasure_aw", label="48390", loot=nil, note="在船上" },
	[73316858] = { questId=48390, icon="treasure", group="treasure_aw", label="48390", loot=nil, note="雷尔瓦将军顶层边上" },
	[77127529] = { questId=48390, icon="treasure", group="treasure_aw", label="48390", loot=nil, note="维沙克斯传送门旁边" },
	[72527293] = { questId=48390, icon="treasure", group="treasure_aw", label="48390", loot=nil, note="雷尔瓦将军后面" },
	[77255876] = { questId=48390, icon="treasure", group="treasure_aw", label="48390", loot=nil, note="斜坡下" },
	-- 48391
	[64135867] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="在维农的巢穴内" },
	[67404790] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note=nil },
	[63615622] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="在维农的巢穴内" },
	[65005049] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="蜘蛛区域外" },
	[63035762] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="在维农的巢穴内" },
	[65185507] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="上面入口到蜘蛛区域" },
	[68095075] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="蜘蛛区域小洞穴内" },
	[69815522] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="蜘蛛区域外" },
	[71205441] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="蜘蛛区域外" },
	[66544668] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="出了蜘蛛区域北面有绿软泥区域。跳上岩石。" },

	-- Shoot First, Loot Later
	-- Requires 48201 Reinforce Light's Purchase
	[58765894] = { objId=277204, questId=49017, icon="starChestBlue", group="sfll_aw", label="被遗忘的军团补给", loot=nil, note="岩石挡住了道路。使用破裂的拉迪纳克斯控制宝石通过。（当光铸战争机甲可用时使用。）" },
	[65973977] = { objId=277205, questId=49018, icon="starChestYellow", group="sfll_aw", label="古老的军团战争储物箱", loot={ { 153308, itemTypeTransmog, "单手锤" } }, note="小心跳下到小洞穴。滑翔会很有帮助。使用圣光裁决者移除岩石。" },
	[52192708] = { objId=277206, questId=49019, icon="starChestYellow", group="sfll_aw", label="邪能缠绕的宝箱", loot=nil, note="开始点在东南方一点位于 53.7, 30.9。跳上岩石到达洞穴。岩石挡住了洞穴。使用圣光裁决者移除岩石。" },
	[64060610] = { objId=277207, questId=49020, icon="starChestBlue", group="sfll_aw", label="军团财宝", loot=nil, note="使用跳跃装置。更多信息，请查看优酷。链接 http://v.youku.com/v_show/id_XMzAxMjI0MDk2MA==.html（或搜索：打砸抢 - 军团财宝 全职业）获取更多信息。" },
	[75595267] = { objId=277208, questId=49021, icon="starChestBlank", group="sfll_aw", label="历时久远的邪能宝箱", loot=nil, note="起点位于全知者萨纳里安。从左侧穿过他的建筑物。沿着几块岩石跳下到达被绿色软泥围绕的宝箱。" },
	[57426366] = { objId=277346, questId=49159, icon="starChestPurple", group="sfll_aw", label="丢失的奥古雷宝箱", loot=nil, note="宝箱在下面绿软区域。使用奥术回响遮罩后打开宝箱。" },

}

-- Krokuun
nodes["ArgusSurface"] = {
	[44390734] = { npcId=125824, questId=48561, icon="skull_grey", group="rare_kr", label="卡扎杜姆", search="卡扎杜姆", loot={ { 153316, itemTypeTransmog, "双手剑" } }, note="入口在东南位于 50.3, 17.3" },
	[33007600] = { npcId=122912, questId=48562, icon="skull_grey", group="rare_kr", label="指挥官萨森纳尔", search="萨森纳尔", loot=nil, note=nil },
	[44505870] = { npcId=124775, questId=48564, icon="skull_grey", group="rare_kr", label="指挥官安达西斯", search="安达西斯", loot={ { 153255, itemTypeTransmog, "单手锤" } }, note=nil },
	[53403090] = { npcId=123464, questId=48565, icon="skull_grey", group="rare_kr", label="苏薇西娅姐妹", search="姐妹", loot={ { 153124, itemTypeToy } }, note=nil },
	[58007480] = { npcId=120393, questId=48627, icon="skull_grey", group="rare_kr", label="攻城大师沃兰", search="攻城大师", loot=nil, note=nil },
	[54688126] = { npcId=123689, questId=48628, icon="skull_grey", group="rare_kr", label="恶毒者泰勒斯塔", search="恶毒者", loot={ { 153329, itemTypeTransmog, "匕首" } }, note=nil },
	[38145920] = { npcId=122911, questId=48563, icon="skull_grey", group="rare_kr", label="指挥官维卡娅", search="维卡娅", loot={ { 153299, itemTypeTransmog, "单手剑" } }, note="路径起始点在东，位于 42, 57.1" },
	[60802080] = { npcId=125388, questId=48629, icon="skull_grey", group="rare_kr", label="背弃者瓦加斯", search="背弃者", loot=nil, note=nil },
	[69605750] = { npcId=124804, questId=48664, icon="skull_grey", group="rare_kr", label="分选者泰瑞克", search="分选者", loot={ { 153263, itemTypeTransmog, "单手斧" } }, note=nil },
	[69708050] = { npcId=125479, questId=48665, icon="skull_grey", group="rare_kr", label="焦油喷吐者", search="焦油", loot=nil, note=nil },
	[41707020] = { npcId=125820, questId=48666, icon="skull_grey", group="rare_kr", label="鬼母拉格拉丝", search="鬼母", loot=nil, note=nil },
	[70503370] = { npcId=126419, questId=48667, icon="skull_grey", group="rare_kr", label="纳罗瓦", search="纳罗瓦", loot={ { 153190, itemTypeMisc }, { 153054, itemTypePet, 2118 }, { 153055, itemTypePet, 2119 }, { 152841, itemTypeMount, 975 }, { 152843, itemTypeMount, 906 }, { 152842, itemTypeMount, 974 }, { 152840, itemTypeMount, 976 } }, note=nil },

	[43005200] = { npcId=128009, questId=0, icon="battle_pet", group="pet_kr", label="梦魇之焰", loot=nil, note=nil },
	[51506380] = { npcId=128008, questId=0, icon="battle_pet", group="pet_kr", label="污染之爪", loot=nil, note=nil },
	[66847263] = { npcId=128007, questId=0, icon="battle_pet", group="pet_kr", label="毁灭之蹄", loot=nil, note=nil },
	[29605790] = { npcId=128011, questId=0, icon="battle_pet", group="pet_kr", label="死亡之啸", loot=nil, note=nil },
	[39606650] = { npcId=128012, questId=0, icon="battle_pet", group="pet_kr", label="小牙", loot=nil, note=nil },
	[58302970] = { npcId=128010, questId=0, icon="battle_pet", group="pet_kr", label="小脏", loot=nil, note=nil },

	-- 47752
	[55555863] = { questId=47752, icon="treasure", group="treasure_kr", label="47752", loot=nil, note="跳上岩石，起点偏西" },
	[52185431] = { questId=47752, icon="treasure", group="treasure_kr", label="47752", loot=nil, note="位于第一次看到奥蕾莉亚的上面" },
	[50405122] = { questId=47752, icon="treasure", group="treasure_kr", label="47752", loot=nil, note="位于第一次看到奥蕾莉亚的上面" },
	[53265096] = { questId=47752, icon="treasure", group="treasure_kr", label="47752", loot=nil, note="位于第一次看到奥蕾莉亚的上面。在绿色软泥的另一边。邪能很疼！" },
	[57005472] = { questId=47752, icon="treasure", group="treasure_kr", label="47752", loot=nil, note="岩层下面，窄小地面上" }, -- Doe
	[59695196] = { questId=47752, icon="treasure", group="treasure_kr", label="47752", loot=nil, note="泽斯塔尔旁边，岩石后面。" }, -- todo:verify
	[51425958] = { questId=47752, icon="treasure", group="treasure_kr", label="47752", loot=nil, note=nil },
	-- 47753
	[53137304] = { questId=47753, icon="treasure", group="treasure_kr", label="47753", loot=nil, note=nil },
	[55228114] = { questId=47753, icon="treasure", group="treasure_kr", label="47753", loot=nil, note=nil },
	[59267341] = { questId=47753, icon="treasure", group="treasure_kr", label="47753", loot=nil, note=nil },
	[56118037] = { questId=47753, icon="treasure", group="treasure_kr", label="47753", loot=nil, note="恶毒者泰勒斯塔建筑物外" },
	[58597958] = { questId=47753, icon="treasure", group="treasure_kr", label="47753", loot=nil, note="恶魔尖塔后面" },
	[58197157] = { questId=47753, icon="treasure", group="treasure_kr", label="47753", loot=nil, note=nil }, -- Doe
	[52737591] = { questId=47753, icon="treasure", group="treasure_kr", label="47753", loot=nil, note="岩石后面" },
	[58048036] = { questId=47753, icon="treasure", group="treasure_kr", label="47753", loot=nil, note=nil },
	-- 47997
	[45876777] = { questId=47997, icon="treasure", group="treasure_kr", label="47997", loot=nil, note="岩石下，桥旁边" },
	[45797753] = { questId=47997, icon="treasure", group="treasure_kr", label="47997", loot=nil, note=nil }, -- Doe
	[43858139] = { questId=47997, icon="treasure", group="treasure_kr", label="47997", loot=nil, note="起点位于 49.1, 69.3。沿着向南方的山脊到达宝箱。" },
	[43816689] = { questId=47997, icon="treasure", group="treasure_kr", label="47997", loot=nil, note="岩石下。桥旁边跳下。" },
	[40687531] = { questId=47997, icon="treasure", group="treasure_kr", label="47997", loot=nil, note=nil }, -- Doe
	[46996831] = { questId=47997, icon="treasure", group="treasure_kr", label="47997", loot=nil, note="在龙头骨上" },
	[41438003] = { questId=47997, icon="treasure", group="treasure_kr", label="47997", loot=nil, note="爬上岩石到达被摧毁的军团战舰" },
	[41548379] = { questId=47997, icon="treasure", group="treasure_kr", label="47997", loot=nil, note=nil }, -- Doe
	-- 47999
	[62592581] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note=nil },
	[59763951] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note=nil },
	[59071884] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note="上面，岩石后面" },
	[61643520] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note=nil },
	[61463580] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note="建筑物内" },
	[59603052] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note="桥面上" },
	[60891852] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note="背弃者瓦加斯后面小屋内" },
	[49063350] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note=nil },
	[65992286] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note=nil },
	-- 48000
	[70907370] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note=nil },
	[74136790] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note=nil },
	[75166435] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note="洞穴尽头" },
	[69605772] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note=nil },
	[69787836] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note="跳上斜坡到达" },
	[68566054] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note="分选者泰瑞克洞穴前面" },
	[72896482] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note=nil },
	[71827536] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note=nil }, -- Doe
	[73577146] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note=nil }, -- Doe
	[71846166] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note="爬上斜状柱子" },
	[67886231] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note="柱子后面" },
	-- 48336
	[33515510] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note=nil },
	[32047441] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note=nil },
	[27196668] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note=nil },
	[31936750] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note=nil },
	[35415637] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note="地面，在去往泽尼达尔入口下面的前方" },
	[29645761] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note="洞穴内" },
	[40526067] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note="黄色小屋内" }, -- Doe
	[36205543] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note="泽尼达尔内，上层" }, -- Doe
	[25996814] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note=nil },
	[37176401] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note="残骸下面" },
	[28247134] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note=nil },
	[30276403] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note="位于逃生平台" },
	-- 48339
	[68533891] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note=nil },
	[63054240] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note=nil },
	[64964156] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note=nil },
	[73393438] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note=nil },
	[72213234] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note="巨大头骨后面" }, -- Doe
	[65983499] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note=nil },
	[64934217] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note="在树干内" },
	[67713454] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note=nil },
	[72493605] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note=nil },

	-- Shoot First, Loot Later
	[51407622] = { objId=276490, questId=48884, icon="starChestBlue", group="sfll_kr", label="克罗库紧急储物箱", loot={ { 153304, itemTypeTransmog, "单手斧" } }, note="洞穴在悬崖上。岩石挡住了道路。使用破裂的拉迪纳克斯控制宝石通过。（当光铸战争机甲可用时使用。）" },
	[62783753] = { objId=276489, questId=48885, icon="starChestYellow", group="sfll_kr", label="军团塔楼宝箱", loot=nil, note="在通往纳罗瓦的路上有被巨石挡住的宝箱。使用圣光裁决者移除岩石。" },
	[48555894] = { objId=276491, questId=48886, icon="starChestYellow", group="sfll_kr", label="丢失的克罗库宝箱", loot=nil, note="道路延伸到小洞穴。使用圣光裁决者移除岩石。" },
	[75176975] = { objId=277343, questId=49154, icon="starChestPurple", group="sfll_kr", label="失落已久的奥古雷宝藏", loot=nil, note="使用奥术回响遮罩后打开宝箱" },
	[55937428] = { objId=277344, questId=49156, icon="starChestPurple", group="sfll_kr", label="珍贵的奥古雷信物", loot=nil, note="使用奥术回响遮罩后打开宝箱" },
}

nodes["ArgusCitadelSpire"] = {
	[38954032] = { npcId=125824, questId=48561, icon="skull_grey", group="rare_kr", label="卡扎杜姆", loot={ { 153316, itemTypeTransmog, "双手剑" } }, note=nil },
}

-- Mac'Aree
nodes["ArgusMacAree"] = {
	[52976684] = { npcId=126815, questId=48693, icon="skull_grey", group="rare_ma", label="灵魂扭曲的畸体", search="畸体", loot=nil, note=nil },
	[55536016] = { npcId=126852, questId=48695, icon="skull_grey", group="rare_ma", label="牧羊人卡沃斯", search="牧羊人", loot=nil, note=nil },
	[38705580] = { npcId=126860, questId=48697, icon="skull_grey", group="rare_ma", label="苍白的卡拉", search="苍白", loot={ { 153190, itemTypeMisc }, { 153054, itemTypePet, 2118 }, { 153055, itemTypePet, 2119 }, { 152841, itemTypeMount, 975 }, { 152843, itemTypeMount, 906 }, { 152842, itemTypeMount, 974 }, { 152840, itemTypeMount, 976 } }, note=nil },
	[41121149] = { npcId=126864, questId=48702, icon="skull_grey", group="rare_ma", label="麦芬大盗费舍尔", search="大盗", loot=nil, note="打断钻地" },
	[63806460] = { npcId=126866, questId=48704, icon="skull_grey", group="rare_ma", label="警卫库洛", search="库洛", loot=nil, note=nil },
	[33654801] = { npcId=126867, questId=48705, icon="skull_grey", group="rare_ma", label="毒尾天鳍鳐", search="毒尾", loot=nil, note=nil },
	[38226435] = { npcId=126868, questId=48706, icon="skull_grey", group="rare_ma", label="清醒者图瑞克", search="清醒者", loot=nil, note="下楼进入建筑物" },
	[27192995] = { npcId=126869, questId=48707, icon="skull_grey", group="rare_ma", label="法鲁克队长", search="队长", loot=nil, note=nil },
	[35965897] = { npcId=126896, questId=48711, icon="skull_grey", group="rare_ma", label="混沌先驱", search="先驱", loot=nil, note="位于第二层。" },
	[44204980] = { npcId=126898, questId=48712, icon="skull_grey", group="rare_ma", label="沙布尔", search="沙布尔", loot={ { 153190, itemTypeMisc }, { 153054, itemTypePet, 2118 }, { 153055, itemTypePet, 2119 }, { 152841, itemTypeMount, 975 }, { 152843, itemTypeMount, 906 }, { 152842, itemTypeMount, 974 }, { 152840, itemTypeMount, 976 } }, note=nil },
	[48504090] = { npcId=126899, questId=48713, icon="skull_grey", group="rare_ma", label="杰德尼勇士沃鲁斯克", search="杰德尼勇士", loot={ { 153302, itemTypeTransmog, "单手剑" } }, note=nil },
	[58783762] = { npcId=124440, questId=48714, icon="skull_grey", group="rare_ma", label="监视者伊比达", search="伊比达", loot=nil, note=nil },
	[58003090] = { npcId=125497, questId=48716, icon="skull_grey", group="rare_ma", label="监视者伊索纳", search="伊索纳", loot=nil, note=nil },
	[60982982] = { npcId=125498, questId=48717, icon="skull_grey", group="rare_ma", label="监视者伊莫拉", search="伊莫拉", loot={ { 153257, itemTypeTransmog, "单手锤" } }, note=nil },
	[66742845] = { npcId=126908, questId=48719, icon="skull_grey", group="rare_ma", label="万千之主祖尔坦", search="万千之主", loot=nil, note="建筑物内" },
	[56801450] = { npcId=126910, questId=48720, icon="skull_grey", group="rare_ma", label="指挥官泽斯加尔", search="指挥官", loot=nil, note=nil },
	[49870953] = { npcId=126912, questId=48721, icon="skull_grey", group="rare_ma", label="吞噬者斯克里格", search="吞噬者", loot=nil, note=nil },
	[43846065] = { npcId=126862, questId=48700, icon="skull_grey", group="rare_ma", label="嗜血的巴鲁特", search="巴鲁特", loot={ { 153193, itemTypeToy } }, note=nil },
	[30124019] = { npcId=126887, questId=48709, icon="skull_grey", group="rare_ma", label="阿塔克松", search="阿塔克松", loot=nil, note=nil },
	-----------------
	[36302360] = { npcId=126865, questId=48703, icon="skull_grey", group="rare_ma", label="警卫泰诺斯", search="泰诺斯", loot=nil, note=nil },
	[61405020] = { npcId=126900, questId=48718, icon="skull_grey", group="rare_ma", label="导师塔拉娜", search="导师", loot=nil, note=nil },
	[49505280] = { npcId=126913, questId=48936, icon="skull_grey", group="rare_ma", label="最后的希里索恩", search="最后", loot=nil, note=nil },
	[44607160] = { npcId=122838, questId=48692, icon="skull_grey", group="rare_ma", label="暗影法师沃伦", search="暗影法师", loot=nil, note=nil },
	[35203720] = { npcId=126885, questId=48708, icon="skull_grey", group="rare_ma", label="乌伯拉利斯", search="乌伯拉利斯", loot=nil, note=nil },
	[70404670] = { npcId=126889, questId=48710, icon="skull_grey", group="rare_ma", label="S厄运者索洛里斯", search="厄运者", loot=nil, note=nil },

	[60007110] = { npcId=128015, questId=0, icon="battle_pet", group="pet_ma", label="烁光之翼", loot=nil, note=nil },
	[67604390] = { npcId=128013, questId=0, icon="battle_pet", group="pet_ma", label="巴基", loot=nil, note=nil },
	[74703620] = { npcId=128018, questId=0, icon="battle_pet", group="pet_ma", label="马库斯", loot=nil, note=nil },
	[69705190] = { npcId=128014, questId=0, icon="battle_pet", group="pet_ma", label="鼠鼠", loot=nil, note=nil },
	[31903120] = { npcId=128017, questId=0, icon="battle_pet", group="pet_ma", label="阿古斯的腐化之血", loot=nil, note=nil },
	[36005410] = { npcId=128016, questId=0, icon="battle_pet", group="pet_ma", label="曳影兽", loot=nil, note=nil },
	
	-- Ancient Eredar Cache
	-- 48346
	[55167766] = { questId=48346, icon="treasure", group="treasure_ma", label="48346", loot=nil, note=nil },
	-- 48350
	[59622088] = { questId=48350, icon="treasure", group="treasure_ma", label="48350", loot=nil, note="建筑物内楼梯下" },
	[60493338] = { questId=48350, icon="treasure", group="treasure_ma", label="48350", loot=nil, note="建筑物内" },
	-- 48351
	[43637134] = { questId=48351, icon="treasure", group="treasure_ma", label="48351", loot=nil, note=nil },
	[34205929] = { questId=48351, icon="treasure", group="treasure_ma", label="48351", loot=nil, note="在第二层，混沌先驱旁边。" },
	-- 48357
	[49372397] = { questId=48357, icon="treasure", group="treasure_ma", label="48357", loot=nil, note=nil },
	[48482115] = { questId=48357, icon="treasure", group="treasure_ma", label="48357", loot=nil, note=nil },
	-- 48371
	[48604971] = { questId=48371, icon="treasure", group="treasure_ma", label="48371", loot=nil, note=nil },
	-- 48362
	[66682786] = { questId=48362, icon="treasure", group="treasure_ma", label="48362", loot=nil, note="建筑物内，万千之主祖尔坦旁边" },
	[62134077] = { questId=48362, icon="treasure", group="treasure_ma", label="48362", loot=nil, note="建筑物内" },
	-- Void-Seeped Cache / Treasure Chest
	-- 49264
	[38143985] = { questId=49264, icon="treasure", group="treasure_ma", label="49264", loot=nil, note=nil },
	[37613608] = { questId=49264, icon="treasure", group="treasure_ma", label="49264", loot=nil, note=nil },
	-- 48361
	[37664221] = { questId=48361, icon="treasure", group="treasure_ma", label="48361", loot=nil, note="洞里柱子后面" },
	[25824471] = { questId=48361, icon="treasure", group="treasure_ma", label="48361", loot=nil, note="" },

	-- Shoot First, Loot Later
	[42900549] = { objId=276223, questId=48743, icon="starChestBlue", group="sfll_ma", label="艾瑞达宝箱", loot=nil, note="在小洞穴内。使用光铸战争机甲跳上并移除岩石" },
	[50583838] = { objId=276224, questId=48744, icon="starChestYellow", group="sfll_ma", label="来路不明的箱子", loot=nil, note="使用圣光裁决者移除岩石。" },
	[61127256] = { objId=276225, questId=48745, icon="starChestYellow", group="sfll_ma", label="学徒的惊喜留念", loot=nil, note="宝箱在山洞内。入口在 62.2, 72.2。使用圣光裁决者移除岩石。" },
	[40275146] = { objId=276226, questId=48747, icon="starChestBlue", group="sfll_ma", label="虚空回荡的宝箱", loot=nil, note="在地下区域。使用光铸战争机甲跳上并移除岩石。" },
	[70305974] = { objId=276227, questId=48748, icon="starChestBlank", group="sfll_ma", label="奥古雷隐秘存储箱", loot=nil, note="到 68.0, 56.9。到这里可以看到宝箱。上坐骑跳跃过去。立刻使用滑翔装备到宝箱会更安全些。" },
	[57047684] = { objId=276228, questId=48749, icon="starChestBlank", group="sfll_ma", label="绝望的艾瑞达的储物箱", loot={ { 153267, itemTypeTransmog, "单手斧" } }, note="起点在 57.1, 74.3，接着跳到塔上后到后面。" },
	[27274014] = { objId=276229, questId=48750, icon="starChestBlank", group="sfll_ma", label="房屋废墟宝箱", loot=nil, note="到 to 31.2, 44.9，这里东南一点。跳下深渊并使用滑翔装备到达宝箱。" },
	[43345447] = { objId=276230, questId=48751, icon="starChestBlank", group="sfll_ma", label="末日追寻者的宝藏", loot={ { 153313, itemTypeTransmog, "双手剑" } }, note="宝箱在地下。东面是一个流水瀑布深洞。跳下深洞运气好能到达。可以使用坐骑跳跃，但是滑翔设备会帮你更多到达有宝箱的小屋。" },
	[70632744] = { objId=277327, questId=49129, icon="starChestPurple", group="sfll_ma", label="奥古雷符文宝箱", loot=nil, note="宝箱在树下。使用奥术回响遮罩后打开宝箱。" },
	[62132247] = { objId=277340, questId=49151, icon="starChestPurple", group="sfll_ma", label="隐秘奥古雷宝箱", loot=nil, note="小屋内。使用奥术回响遮罩后打开宝箱。" },
	[40856975] = { objId=277342, questId=49153, icon="starChestPurple", group="sfll_ma", label="奥古雷货物", loot=nil, note="宝箱在小屋内。使用奥术回响遮罩后打开宝箱。" },
}


local function GetItem(ID)
    if (ID == "1220" or ID == "1508") then
        local currency, _, _ = GetCurrencyInfo(ID)

        if (currency ~= nil) then
            return currency
        else
            return "错误加载货币 ID"
        end
    else
        local _, item, _, _, _, _, _, _, _, _ = GetItemInfo(ID)

        if (item ~= nil) then
            return item
        else
            return "错误加载物品 ID"
        end
    end
end 

local function GetIcon(ID)
    if (ID == "1220") then
        local _, _, icon = GetCurrencyInfo(ID)

        if (icon ~= nil) then
            return icon
        else
            return "Interface\\Icons\\inv_misc_questionmark"
        end
    else
		local _, _, _, _, icon = GetItemInfoInstant(ID)
        --local _, _, _, _, _, _, _, _, _, icon = GetItemInfo(ID)

        if (icon ~= nil) then
            return icon
        else
            return "Interface\\Icons\\inv_misc_questionmark"
        end
    end
end

-- get npc name
local npc_tooltip = CreateFrame("GameTooltip", "HandyNotesArgus_npcToolTip", UIParent, "GameTooltipTemplate")
local tooltip_label

local function getCreatureNamebyID(id)
	npc_tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	npc_tooltip:SetHyperlink(("unit:Creature-0-0-0-0-%d"):format(id))
	tooltip_label = _G["HandyNotesArgus_npcToolTipTextLeft1"]:GetText()
end

function Argus:OnEnter(mapFile, coord)
    if (not nodes[mapFile][coord]) then return end
    
    local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip

    if ( self:GetCenter() > UIParent:GetCenter() ) then
        tooltip:SetOwner(self, "ANCHOR_LEFT")
    else
        tooltip:SetOwner(self, "ANCHOR_RIGHT")
    end

	local label = "";
	if ( nodes[mapFile][coord]["npcId"] ) then
		tooltip_label = nil;
		getCreatureNamebyID( nodes[mapFile][coord]["npcId"] );
		if ( tooltip_label ) then
			label = tooltip_label;
		end
	else
		label = nodes[mapFile][coord]["label"];
	end
	tooltip:SetText( label );
	if ( Argus.db.profile.show_notes == true and nodes[mapFile][coord]["note"] and nodes[mapFile][coord]["note"] ~= nil ) then
		-- note
		tooltip:AddLine(("" .. nodes[mapFile][coord]["note"]), nil, nil, nil, true)
	end
    if (	( Argus.db.profile.show_loot == true ) and
			( nodes[mapFile][coord]["loot"] ~= nil ) and
			( type(nodes[mapFile][coord]["loot"]) == "table" ) ) then
		local ii;
		local loot = nodes[mapFile][coord]["loot"];
		for ii = 1, #loot do
			-- loot
			if ( loot[ii][2] == itemTypeMount ) then
				-- check mount known
				local n,_,_,_,_,_,_,_,_,_,c,j=C_MountJournal.GetMountInfoByID( loot[ii][3] );
				if ( c == true ) then
					tooltip:AddLine( GetItem(loot[ii][1]) .. " " .. _L["(Mount known)"], nil, nil, nil, true)
				else
					tooltip:AddLine( GetItem(loot[ii][1]) .. " " .. _L["(Mount missing)"], nil, nil, nil, true)
				end
			elseif ( loot[ii][2] == itemTypePet ) then
				-- check pet quantity
				local n,m = C_PetJournal.GetNumCollectedInfo( loot[ii][3] );
				tooltip:AddLine( GetItem(loot[ii][1]) .. " (宠物 " .. n .. "/" .. m .. ")", nil, nil, nil, true)
			elseif ( loot[ii][2] == itemTypeToy ) then
				-- check toy known
				if ( PlayerHasToy( loot[ii][1] ) == true ) then
					tooltip:AddLine( GetItem(loot[ii][1]) .. " " .. _L["(Toy known)"], nil, nil, nil, true)
				else
					tooltip:AddLine( GetItem(loot[ii][1]) .. " " .. _L["(Toy missing)"], nil, nil, nil, true)
				end
			elseif ( isCanIMogItloaded == true and loot[ii][2] == itemTypeTransmog ) then
				-- check transmog known with canimogit
				local _,itemLink = GetItemInfo( loot[ii][1] );
				if ( itemLink ~= nil ) then
					if ( CanIMogIt:PlayerKnowsTransmog( itemLink ) ) then
						tooltip:AddLine( GetItem(loot[ii][1]) .. " " .. string.format( _L["(itemLinkGreen)"], loot[ii][3] ), nil, nil, nil, true)
					else
						tooltip:AddLine( GetItem(loot[ii][1]) .. " " .. string.format( _L["(itemLinkRed)"], loot[ii][3] ), nil, nil, nil, true)
					end
				else
					tooltip:AddLine( GetItem(loot[ii][1]) .. " (" .. loot[ii][3] .. ")", nil, nil, nil, true)
				end
			elseif ( loot[ii][2] == itemTypeTransmog ) then
				-- show transmog without check
				tooltip:AddLine( GetItem(loot[ii][1]) .. " (" .. loot[ii][3] .. ")", nil, nil, nil, true)
			else
				-- default show itemLink
				tooltip:AddLine( GetItem(loot[ii][1]), nil, nil, nil, true)
			end
		end
    end

    tooltip:Show()
end

local function playerHasLoot( loot )
	if ( loot == nil ) then
		-- no loot no need
		return true
	elseif ( loot[2] == itemTypeMount ) then
		-- check mount known
		local n,_,_,_,_,_,_,_,_,_,hasMount,j=C_MountJournal.GetMountInfoByID( loot[3] );
		return hasMount;
	elseif ( loot[2] == itemTypePet ) then
		-- check pet quantity
		local n,m = C_PetJournal.GetNumCollectedInfo( loot[3] );
		return n >= 1;
	elseif ( loot[2] == itemTypeToy ) then
		-- check toy known
		return PlayerHasToy( loot[1] );
	elseif ( isCanIMogItloaded == true and loot[2] == itemTypeTransmog ) then
		-- check transmog known with canimogit
		local _,itemLink = GetItemInfo( loot[1] );
		if ( itemLink ~= nil ) then
			if ( CanIMogIt:PlayerKnowsTransmog( itemLink ) or not CanIMogIt:CharacterCanLearnTransmog( itemLink ) ) then
				return true;
			else
				return false;
			end
		else
			return true
		end
	else
		-- default assume not needed
		return true;
	end
end

local isMoving = false
local info = {}
local clickedMapFile = nil
local clickedCoord = nil

local function LRTHideDBMArrow()
    DBM.Arrow:Hide(true)
end

local function LRTDisableTreasure(button, mapFile, coord)
    if (nodes[mapFile][coord]["questId"] ~= nil) then
        Argus.db.char[mapFile .. coord .. nodes[mapFile][coord]["questId"]] = true;
    end

    Argus:Refresh()
end

local function LRTResetDB()
    table.wipe(Argus.db.char)
    Argus:Refresh()
end

local function LRTaddtoTomTom(button, mapFile, coord)
    if isTomTomloaded == true then
        local mapId = HandyNotes:GetMapFiletoMapID(mapFile)
        local x, y = HandyNotes:getXY(coord)
        local desc = nodes[mapFile][coord]["label"];

        TomTom:AddMFWaypoint(mapId, nil, x, y, {
            title = desc,
            persistent = nil,
            minimap = true,
            world = true
        })
    end
end

local function LRTAddDBMArrow(button, mapFile, coord)
    if isDBMloaded == true then
        local mapId = HandyNotes:GetMapFiletoMapID(mapFile)
        local x, y = HandyNotes:getXY(coord)
        local desc = nodes[mapFile][coord][2];

        if not DBMArrow.Desc:IsShown() then
            DBMArrow.Desc:Show()
        end

        x = x*100
        y = y*100
        DBMArrow.Desc:SetText(desc)
        DBM.Arrow:ShowRunTo(x, y, nil, nil, true)
    end
end

local finderFrame = CreateFrame("Frame");
finderFrame:SetScript("OnEvent", function( self, event )
	self:UnregisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED");
	-- LFGListFrame.SearchPanel.SearchBox:SetText(self.search);
end );

local function LRTLFRsearch( button, search, label )
	if ( search ~= nil ) then
		finderFrame.search = search;
		local c,zone,_,_,name = C_LFGList.GetActiveEntryInfo();
		if c == true then
			if ( UnitIsGroupLeader("player") ) then
				print( "旧队伍失效。再次点击查找队伍 " .. label .. "." );
				C_LFGList.RemoveListing();
			else
				print( "权限不足。你不是队长。" );
			end
		else
			if not GroupFinderFrame:IsVisible() then
				PVEFrame_ShowFrame("GroupFinderFrame");
			end
			GroupFinderFrameGroupButton4:Click();
			LFGListFrame.SearchPanel.SearchBox:SetText( search );
			LFGListCategorySelection_SelectCategory( LFGListFrame.CategorySelection, 6, 0 );
			LFGListFrame.SearchPanel.SearchBox:SetText( search );
			LFGListCategorySelectionFindGroupButton_OnClick( LFGListFrame.CategorySelection.FindGroupButton );			
			LFGListFrame.SearchPanel.SearchBox:SetText( search );
			--LFGListFrame.SearchPanel.SearchBox:SetFocus();
			
			finderFrame:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
		end
	end
end

local function LRTLFRcreate( button, label )
	local c,zone,_,_,name = C_LFGList.GetActiveEntryInfo();
	if c == true and name ~= label then
		if ( UnitIsGroupLeader("player") ) then
			print( "旧队伍失效。再次点击查找队伍 " .. label .. "." );
			C_LFGList.RemoveListing();
		else
			print( "权限不足。你不是队长。" );
		end
	elseif ( c == false ) then
		print( "创建队伍 " .. label .. "." );
		-- 16 = custom
		C_LFGList.CreateListing(16,label,0,0,"","由 HandyNotes_Argus 创建",true)
	end
end

local function generateMenu(button, level)
    if (not level) then return end

    for k in pairs(info) do info[k] = nil end

    if (level == 1) then
        info.isTitle = 1
        info.text = "Argus"
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)
        
        info.disabled = nil
        info.isTitle = nil
        info.notCheckable = nil

		if ( (string.find(nodes[clickedMapFile][clickedCoord]["group"], "rare") ~= nil)) then
		info.text = "查找队伍"
			if ( nodes[clickedMapFile][clickedCoord]["search"] ~= nil ) then
				info.func = LRTLFRsearch
				info.arg1 = nodes[clickedMapFile][clickedCoord]["search"]
				info.arg2 = nodes[clickedMapFile][clickedCoord]["label"]
				UIDropDownMenu_AddButton(info, level)
			end

			info.text = "创建查找队伍正在列出"
			info.func = LRTLFRcreate
			info.arg1 = nodes[clickedMapFile][clickedCoord]["label"]
			UIDropDownMenu_AddButton(info, level)
		end

        info.text = "从地图移除此物件"
        info.func = LRTDisableTreasure
        info.arg1 = clickedMapFile
        info.arg2 = clickedCoord
        UIDropDownMenu_AddButton(info, level)
        
        if isTomTomloaded == true then
            info.text = "在 TomTom 添加此路径点位置"
            info.func = LRTaddtoTomTom
            info.arg1 = clickedMapFile
            info.arg2 = clickedCoord
            UIDropDownMenu_AddButton(info, level)
        end

        if isDBMloaded == true then
            info.text = "在 DBM 中添加此财宝箭头"
            info.func = LRTAddDBMArrow
            info.arg1 = clickedMapFile
            info.arg2 = clickedCoord
            UIDropDownMenu_AddButton(info, level)
            
            info.text = "隐藏 DBM 箭头"
            info.func = LRTHideDBMArrow
            UIDropDownMenu_AddButton(info, level)
        end

        info.text = CLOSE
        info.func = function() CloseDropDownMenus() end
        info.arg1 = nil
        info.arg2 = nil
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)

        info.text = "恢复已移除物件"
        info.func = LRTResetDB
        info.arg1 = nil
        info.arg2 = nil
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)
        
    end
end

local HandyNotes_ArgusDropdownMenu = CreateFrame("Frame", "HandyNotes_ArgusDropdownMenu")
HandyNotes_ArgusDropdownMenu.displayMode = "MENU"
HandyNotes_ArgusDropdownMenu.initialize = generateMenu

function Argus:OnClick(button, down, mapFile, coord)
    if button == "RightButton" and down then
		-- context menu
        clickedMapFile = mapFile
        clickedCoord = coord
        ToggleDropDownMenu(1, nil, HandyNotes_ArgusDropdownMenu, self, 0, 0)
	elseif button == "MiddleButton" and down then
		-- create group
		if ( (string.find(nodes[mapFile][coord]["group"], "rare") ~= nil)) then
			LRTLFRcreate( nil, nodes[mapFile][coord]["label"] );
		end
	elseif button == "LeftButton" and down then
		-- find group
		LRTLFRsearch( nil, nodes[mapFile][coord]["search"], nodes[mapFile][coord]["label"] );
    end
end

function Argus:OnLeave(mapFile, coord)
    if self:GetParent() == WorldMapButton then
        WorldMapTooltip:Hide()
    else
        GameTooltip:Hide()
    end
end

local options = {
    type = "group",
    name = "阿古斯",
    desc = "阿古斯稀有和财宝",
    get = function(info) return Argus.db.profile[info.arg] end,
    set = function(info, v) Argus.db.profile[info.arg] = v; Argus:Refresh() end,
    args = {
        IconOptions = {
            type = "group",
            name = "图标设置",
            desc = "图标设置",
			inline = true,
			order = 0,
            args = {
				groupIconTreasures = {
					type = "header",
					name = "宝箱图标",
					desc = "宝箱图标",
					order = 0,
				},
				icon_scale_treasures = {
					type = "range",
					name = "大小",
					desc = "1 = 100%",
					min = 0.25, max = 10, step = 0.01,
					arg = "icon_scale_treasures",
					order = 1,
				},
				icon_alpha_treasures = {
					type = "range",
					name = "透明度",
					desc = "0 = 透明, 1 = 不透明",
					min = 0, max = 1, step = 0.01,
					arg = "icon_alpha_treasures",
					order = 2,
				},
				groupIconRares = {
					type = "header",
					name = "稀有图标",
					desc = "稀有图标",
					order = 10,
				},
				icon_scale_rares = {
					type = "range",
					name = "大小",
					desc = "1 = 100%",
					min = 0.25, max = 10, step = 0.01,
					arg = "icon_scale_rares",
					order = 11,
				},
				icon_alpha_rares = {
					type = "range",
					name = "透明度",
					desc = "0 = 透明, 1 = 不透明",
					min = 0, max = 1, step = 0.01,
					arg = "icon_alpha_rares",
					order = 12,
				},
				groupIconPets = {
					type = "header",
					name = "战斗宠物图标",
					desc = "战斗宠物图标",
					order = 20,
				},
				icon_scale_pets = {
					type = "range",
					name = "大小",
					desc = "1 = 100%",
					min = 0.25, max = 10, step = 0.01,
					arg = "icon_scale_pets",
					order = 21,
				},
				icon_alpha_pets = {
					type = "range",
					name = "透明度",
					desc = "0 = 透明, 1 = 不透明",
					min = 0, max = 1, step = 0.01,
					arg = "icon_alpha_pets",
					order = 22,
				},
				groupIconSfll = {
					type = "header",
					name = "打砸抢",
					desc = "打砸抢",
					order = 30,
				},
				icon_scale_sfll = {
					type = "range",
					name = "大小",
					desc = "1 = 100%",
					min = 0.25, max = 10, step = 0.01,
					arg = "icon_scale_sfll",
					order = 31,
				},
				icon_alpha_sfll = {
					type = "range",
					name = "透明度",
					desc = "0 = 透明, 1 = 不透明",
					min = 0, max = 1, step = 0.01,
					arg = "icon_alpha_sfll",
					order = 32,
				},
			},
		},
		VisibilityGroup = {
			type = "group",
			order = 10,
			name = "选择哪些区域要显示什么：",
			inline = true,
			args = {
				groupAW = {
					type = "header",
					name = "安托兰废土",
					desc = "安托兰废土",
					order = 0,
				},
				treasureAW = {
					type = "toggle",
					arg = "treasure_aw",
					name = "财宝",
					desc = "财宝会提供很多物品",
					order = 1,
					width = "normal",
				},
				rareAW = {
					type = "toggle",
					arg = "rare_aw",
					name = "稀有",
					desc = "稀有刷新",
					order = 2,
					width = "normal",
				},
				petAW = {
					type = "toggle",
					arg = "pet_aw",
					name = "战斗宠物",
					order = 3,
					width = "normal",
				},
				sfllAW = {
					type = "toggle",
					arg = "sfll_aw",
					name = "打砸抢",
					order = 4,
					width = "normal",
				},
				groupKR = {
					type = "header",
					name = "克罗库恩",
					desc = "克罗库恩",
					order = 10,
				},  
				treasureKR = {
					type = "toggle",
					arg = "treasure_kr",
					name = "财宝",
					desc = "财宝会提供很多物品",
					width = "normal",
					order = 11,
				},
				rareKR = {
					type = "toggle",
					arg = "rare_kr",
					name = "稀有",
					desc = "稀有刷新",
					width = "normal",
					order = 12,
				},
				petKR = {
					type = "toggle",
					arg = "pet_kr",
					name = "战斗宠物",
					width = "normal",
					order = 13,
				},
				sfllKR = {
					type = "toggle",
					arg = "sfll_kr",
					name = "打砸抢",
					order = 14,
					width = "normal",
				},
				groupMA = {
					type = "header",
					name = "玛凯雷",
					desc = "玛凯雷",
					order = 20,
				},  
				treasureMA = {
					type = "toggle",
					arg = "treasure_ma",
					name = "财宝",
					desc = "财宝会提供很多物品",
					width = "normal",
					order = 21,
				},
				rareMA = {
					type = "toggle",
					arg = "rare_ma",
					name = "稀有",
					desc = "稀有刷新",
					width = "normal",
					order = 22,
				},  
				petMA = {
					type = "toggle",
					arg = "pet_ma",
					name = "战斗宠物",
					width = "normal",
					order = 23,
				},  
				sfllMA = {
					type = "toggle",
					arg = "sfll_ma",
					name = "打砸抢",
					order = 24,
					width = "normal",
				},
				groupGeneral = {
					type = "header",
					name = "通用",
					desc = "通用",
					order = 30,
				},  
				alwaysshowrares = {
					type = "toggle",
					arg = "alwaysshowrares",
					name = "总是显示已拾取的稀有",
					desc = "显示每个稀有无论是否已拾取状态",
					order = 31,
					width = "full",
				},
				alwaysshowtreasures = {
					type = "toggle",
					arg = "alwaysshowtreasures",
					name = "总是显示已拾取的财宝",
					desc = "显示每个财宝无论是否已拾取状态",
					order = 32,
					width = "full",
				},
				alwaysshowsfll = {
					type = "toggle",
					arg = "alwaysshowsfll",
					name = "已拾取“打砸抢”宝箱",
					desc = "显示每个成就宝箱忽略已拾取状态",
					order = 33,
					width = "full",
				},
			},
		},
		TooltipGroup = {
			type = "group",
			order = 20,
			name = "Tooltip",
			inline = true,
			args = {
				show_loot = {
					type = "toggle",
					arg = "show_loot",
					name = "显示掉落",
					desc = "显示每个财宝/稀有的掉落",
					order = 102,
				},
				show_notes = {
					type = "toggle",
					arg = "show_notes",
					name = "显示注释",
					desc = "当可用时显示每个财宝/稀有的注释",
					order = 103,
				},
			},
		},
    },
}

function Argus:OnInitialize()
    local defaults = {
        profile = {
            icon_scale_treasures = 2,
            icon_scale_rares = 1.5,
            icon_scale_pets = 1.5,
			icon_scale_sfll = 3.25,
            icon_alpha_treasures = 0.5,
			icon_alpha_rares = 0.75,
			icon_alpha_pets = 1.0,
			icon_alpha_sfll = 1.0,
            alwaysshowrares = false,
            alwaysshowtreasures = false,
			alwaysshowsfll = false,
            save = true,
            treasure_aw = true,
            treasure_kr = true,
            treasure_ma = true,
            rare_aw = true,
            rare_kr = true,
            rare_ma = true,
			pet_aw = true,
			pet_kr = true,
			pet_ma = true,
			sfll_aw = true,
			sfll_kr = true,
			sfll_ma = true,
            show_loot = true,
            show_notes = true,
        },
    }

    self.db = LibStub("AceDB-3.0"):New("HandyNotesArgusDB", defaults, "Default")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "WorldEnter")
end

function Argus:WorldEnter()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:ScheduleTimer("RegisterWithHandyNotes", 8)
	self:ScheduleTimer("LoadCheck", 6)
end

function Argus:RegisterWithHandyNotes()
    do
		local currentMapFile = "";
        local function iter(t, prestate)
            if not t then return nil end

            local coord, node = next(t, prestate)

            while coord do
                if (node["questId"] and self.db.profile[node["group"]] and not Argus:HasBeenLooted(currentMapFile,coord,node)) then
					-- preload items
					local allLootKnown = true
                    if ((node["loot"] ~= nil) and (type(node["loot"]) == "table")) then
						local ii
						for ii = 1, #node["loot"] do
							GetIcon(node["loot"][ii][1])
							if ( not playerHasLoot( node["loot"][ii] ) ) then
								allLootKnown = false
							end
						end
                    end
					-- preload localized npc names
					if ( node["npcId"] ~= nil ) then
						getCreatureNamebyID( node["npcId"] );
					end

					local iconScale = 1;
					local iconAlpha = 1;
					local iconPath = iconDefaults[node["icon"]];
					if ( (string.find(node["group"], "rare") ~= nil)) then
						iconScale = Argus.db.profile.icon_scale_rares;
						iconAlpha = Argus.db.profile.icon_alpha_rares;
						if ( not allLootKnown ) then
							iconPath = iconDefaults["skull_blue"];
						end
					elseif ( (string.find(node["group"], "treasure") ~= nil)) then
						iconScale = Argus.db.profile.icon_scale_treasures;
						iconAlpha = Argus.db.profile.icon_alpha_treasures;
					elseif ( (string.find(node["group"], "pet") ~= nil)) then
						iconScale = Argus.db.profile.icon_scale_pets;
						iconAlpha = Argus.db.profile.icon_alpha_pets;
					elseif ( (string.find(node["group"], "sfll") ~= nil)) then
						iconScale = Argus.db.profile.icon_scale_sfll;
						iconAlpha = Argus.db.profile.icon_alpha_sfll;
					end
                    return coord, nil, iconPath, iconScale, iconAlpha
                end

                coord, node = next(t, coord)
            end
        end

        function Argus:GetNodes(mapFile, isMinimapUpdate, dungeonLevel)
			currentMapFile = mapFile;
            return iter, nodes[mapFile], nil
        end
    end

    HandyNotes:RegisterPluginDB("HandyNotesArgus", self, options)
    self:RegisterBucketEvent({ "LOOT_CLOSED" }, 2, "Refresh")
    self:Refresh()
end
 
function Argus:Refresh()
    self:SendMessage("HandyNotes_NotifyUpdate", "HandyNotesArgus")
end

function Argus:HasBeenLooted(mapFile,coord,node)
    if (self.db.profile.alwaysshowtreasures and (string.find(node["group"], "treasure") ~= nil)) then return false end
    if (self.db.profile.alwaysshowrares and (string.find(node["group"], "rare") ~= nil)) then return false end
	if (self.db.profile.alwaysshowsfll and (string.find(node["group"], "sfll") ~= nil)) then return false end
    -- if (node["questId"] and node["questId"] == 0) then return false end
    if (Argus.db.char[mapFile .. coord .. node["questId"]] and self.db.profile.save) then return true end
    if (IsQuestFlaggedCompleted(node["questId"])) then
        return true
    end

    return false
end

function Argus:LoadCheck()
	if (IsAddOnLoaded("TomTom")) then 
		isTomTomloaded = true
	end

	if (IsAddOnLoaded("DBM-Core")) then 
		isDBMloaded = true
	end

	if (IsAddOnLoaded("CanIMogIt")) then 
		isCanIMogItloaded = true
	end

	if isDBMloaded == true then
		local ArrowDesc = DBMArrow:CreateFontString(nil, "OVERLAY", "GameTooltipText")
		ArrowDesc:SetWidth(400)
		ArrowDesc:SetHeight(100)
		ArrowDesc:SetPoint("CENTER", DBMArrow, "CENTER", 0, -35)
		ArrowDesc:SetTextColor(1, 1, 1, 1)
		ArrowDesc:SetJustifyH("CENTER")
		DBMArrow.Desc = ArrowDesc
	end
end
