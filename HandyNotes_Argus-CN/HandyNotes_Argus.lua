-- Thanks to all who provide usable code
local ADDON_MSG_PREFIX = "HNA";
local VERSION = "0.20.0";

local _G = getfenv(0)
-- Libraries
local string = _G.string;
local format = string.format
local gsub = string.gsub
local next = next
local wipe = wipe
local GetItemInfo = _G["GetItemInfo"];
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
	eye = "Interface\\Icons\\INV_Misc_Eye_02.blp",
	portalGreen = {
		icon = objAtlas,
		tCoordLeft = 219/512, tCoordRight = 243/512, tCoordTop = 108/512, tCoordBottom = 129/512,
	},
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
	skullWhite = {
		icon = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\skulls.blp",
		tCoordLeft = 0/256, tCoordRight = 40/256, tCoordTop = 0/256, tCoordBottom = 40/256,
	},
	skullWhiteRedGlow = {
		icon = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\skulls.blp",
		tCoordLeft = 40/256, tCoordRight = 80/256, tCoordTop = 0/256, tCoordBottom = 40/256,
	},
	skullWhiteGreenGlow = {
		icon = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\skulls.blp",
		tCoordLeft = 80/256, tCoordRight = 120/256, tCoordTop = 0/256, tCoordBottom = 40/256,
	},
	skullBlue = {
		icon = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\skulls.blp",
		tCoordLeft = 0/256, tCoordRight = 40/256, tCoordTop = 40/256, tCoordBottom = 80/256,
	},
	skullBlueRedGlow = {
		icon = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\skulls.blp",
		tCoordLeft = 40/256, tCoordRight = 80/256, tCoordTop = 40/256, tCoordBottom = 80/256,
	},
	skullBlueGreenGlow = {
		icon = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\skulls.blp",
		tCoordLeft = 80/256, tCoordRight = 120/256, tCoordTop = 40/256, tCoordBottom = 80/256,
	},
}
local itemTypeMisc = 0;
local itemTypePet = 1;
local itemTypeMount = 2;
local itemTypeToy = 3;
local itemTypeTransmog = 4;

local allLanguages = {
	deDE = true,
	enGB = true,
	enUS = true,
	esES = true,
	esMX = true,
	frFR = true,
	itIT = true,
	koKR = true,
	ptBR = true,
	ruRU = true,
	zhCN = true,
	zhTW = true,
}

Argus.nodes = { }

local nodes = Argus.nodes
local isTomTomloaded = false
local isCanIMogItloaded = false

-- [XXXXYYYY] = { questId, icon, group, label, loot, note, search },
-- /run local find="Cross Gazer"; for i,mid in ipairs(C_MountJournal.GetMountIDs()) do local n,_,_,_,_,_,_,_,_,_,c,j=C_MountJournal.GetMountInfoByID(mid); if ( n:match(find)  then print(j .. " " .. n); end end
-- /run local find="Cross"; for i=0,2200 do local n=C_PetJournal.GetPetInfoBySpeciesID(i); if ( n and string.find(n,find) ) then print(i .. " " .. n); end end
-- { 152903, itemTypeMount, 981 } Biletooth Gnasher any rare??
-- Antoran Wastes
nodes["ArgusCore"] = {
	{ coord = 52702950, npcId = 127291, questId = 48822, icon = "skull_grey", group = "rare_aw", label = _L["Watcher Aival"], search = { "艾瓦" }, loot = nil, note = _L["Watcher Aival_note"] },
	{ coord = 63902090, npcId = 126040, questId = 48809, icon = "skull_grey", group = "rare_aw", label = _L["Puscilla"], search = { "普希拉" }, loot = { { 152903, itemTypeMount, 981 } }, note = _L["Puscilla_note"] },
	{ coord = 53103580, npcId = 126199, questId = 48810, icon = "skull_grey", group = "rare_aw", label = _L["Vrax'thul"], search = { "弗拉克苏尔" }, loot = { { 152903, itemTypeMount, 981 } }, note = _L["Vrax'thul_note"] },
	{ coord = 63225754, npcId = 126115, questId = 48811, icon = "skull_grey", group = "rare_aw", label = _L["Ven'orn"], search = { "维农" }, loot = nil, note = _L["Ven'orn_note"] },
	{ coord = 64304820, npcId = 126208, questId = 48812, icon = "skull_grey", group = "rare_aw", label = _L["Varga"], search = { "瓦加" }, loot = { { 153190, itemTypeMisc }, { 153054, itemTypePet, 2118 }, { 153055, itemTypePet, 2119 }, { 152841, itemTypeMount, 975 }, { 152843, itemTypeMount, 906 }, { 152842, itemTypeMount, 974 }, { 152840, itemTypeMount, 976 } }, note = _L["Varga_note"] },
	{ coord = 62405380, npcId = 126254, questId = 48813, icon = "skull_grey", group = "rare_aw", label = _L["Lieutenant Xakaar"], search = { "中尉" }, loot = nil, note = _L["Lieutenant Xakaar_note"] },
	{ coord = 61906430, npcId = 126338, questId = 48814, icon = "skull_grey", group = "rare_aw", label = _L["Wrath-Lord Yarez"], search = { "愤怒领主" }, loot = { { 153126, itemTypeToy } }, note = _L["Wrath-Lord Yarez_note"] },
	{ coord = 60674831, npcId = 126946, questId = 48815, icon = "skull_grey", group = "rare_aw", label = _L["Inquisitor Vethroz"], search = { "审判官" }, loot = { { 151543, itemTypeMisc } }, note = _L["Inquisitor Vethroz_note"] },
	{ coord = 80206230, npcId = nil, questId = 48816, icon = "portalGreen", group = "portal_aw", label = _L["Portal to Commander Texlaz"], loot = nil, note = _L["Portal to Commander Texlaz_note"] },
	{ coord = 82006600, npcId = 127084, questId = 48816, icon = "skull_grey", group = "rare_aw", label = _L["Commander Texlaz"], search = { "泰克拉兹" }, loot = nil, note = _L["Commander Texlaz_note"] },
	{ coord = 73207080, npcId = 127090, questId = 48817, icon = "skull_grey", group = "rare_aw", label = _L["Admiral Rel'var"], search = { "将军" }, loot = { { 153324, itemTypeTransmog, "盾牌" }, { 152886, itemTypeTransmog, "布甲" }, { 152888, itemTypeTransmog, "布甲" }, { 152884, itemTypeTransmog, "布甲" }, { 152889, itemTypeTransmog, "布甲" }, { 152885, itemTypeTransmog, "布甲" }, { 152881, itemTypeTransmog, "布甲" }, { 152887, itemTypeTransmog, "布甲" }, { 152883, itemTypeTransmog, "布甲" } }, note = _L["Admiral Rel'var_note"] },
	{ coord = 76155614, npcId = 127096, questId = 48818, icon = "skull_grey", group = "rare_aw", label = _L["All-Seer Xanarian"], search = { "全知者" }, loot = nil, note = _L["All-Seer Xanarian_note"] },
	{ coord = 50905530, npcId = 127118, questId = 48820, icon = "skull_grey", group = "rare_aw", label = _L["Worldsplitter Skuul"], search = { "裂世者" }, loot = { { 153312, itemTypeTransmog, "双手剑" }, { 152886, itemTypeTransmog, "布甲" }, { 152888, itemTypeTransmog, "布甲" }, { 152884, itemTypeTransmog, "布甲" }, { 152889, itemTypeTransmog, "布甲" }, { 152885, itemTypeTransmog, "布甲" }, { 152881, itemTypeTransmog, "布甲" }, { 152887, itemTypeTransmog, "布甲" }, { 152883, itemTypeTransmog, "布甲" } }, note = _L["Worldsplitter Skuul_note"] },
	{ coord = 63042455, npcId = 127288, questId = 48821, icon = "skull_grey", group = "rare_aw", label = _L["Houndmaster Kerrax"], search = { "驯犬大师" }, loot = { { 152790, itemTypeMount, 955 } }, note = _L["Houndmaster Kerrax_note"] },
	{ coord = 55702190, npcId = 127300, questId = 48824, icon = "skull_grey", group = "rare_aw", label = _L["Void Warden Valsuran"], search = { "虚空守望者" }, loot = { { 153319, itemTypeTransmog, "双手锤" }, { 152886, itemTypeTransmog, "布甲" }, { 152888, itemTypeTransmog, "布甲" }, { 152884, itemTypeTransmog, "布甲" }, { 152889, itemTypeTransmog, "布甲" }, { 152885, itemTypeTransmog, "布甲" }, { 152881, itemTypeTransmog, "布甲" }, { 152887, itemTypeTransmog, "布甲" }, { 152883, itemTypeTransmog, "布甲" } }, note = _L["Void Warden Valsuran_note"] },
	{ coord = 61392095, npcId = 127376, questId = 48865, icon = "skull_grey", group = "rare_aw", label = _L["Chief Alchemist Munculus"], search = { "首席炼金师" }, note = _L["Chief Alchemist Munculus_note"] },
	{ coord = 54003800, npcId = 127581, questId = 48966, icon = "skull_grey", group = "rare_aw", label = _L["The Many-Faced Devourer"], search = { "千面" }, loot = { { 153195, itemTypePet, 2136 } }, note = _L["The Many-Faced Devourer_note"] },
	{ coord = 77177319, npcId = nil, questId = 48967, icon = "portalGreen", group = "portal_aw", label = _L["Portal to Squadron Commander Vishax"], loot = nil, note = _L["Portal to Squadron Commander Vishax_note"] },
	{ coord = 84368118, npcId = 127700, questId = 48967, icon = "skull_grey", group = "rare_aw", label = _L["Squadron Commander Vishax"], search = { "中队指挥官" }, loot = { { 153253, itemTypeToy } }, note = _L["Squadron Commander Vishax_note"] },
	{ coord = 58001200, npcId = 127703, questId = 48968, icon = "skull_grey", group = "rare_aw", label = _L["Doomcaster Suprax"], search = { "末日法师" }, loot = { { 153194, itemTypeToy } }, note = _L["Doomcaster Suprax_note" },
	{ coord = 66981777, npcId = 127705, questId = 48970, icon = "skull_grey", group = "rare_aw", label = _L["Mother Rosula"], search = { "主母" }, loot = { { 153252, itemTypePet, 2135 } }, note = _L["Mother Rosula_note"] },
	{ coord = 64948290, npcId = 127706, questId = 48971, icon = "skull_grey", group = "rare_aw", label = _L["Rezira the Seer"], search = { "先知" }, loot = { { 153293, itemTypeToy } }, note = _L["Rezira the Seer_note"] },
	{ coord = 61703720, npcId = 122958, questId = 49183, icon = "skull_grey", group = "rare_aw", label = _L["Blistermaw"], search = { "疱喉" }, loot = { { 152905, itemTypeMount, 979 } }, note = _L["Blistermaw_note"] },
	{ coord = 57403290, npcId = 122947, questId = 49240, icon = "skull_grey", group = "rare_aw", label = _L["Mistress Il'thendra"], search = { "伊森黛拉" }, loot = { { 153327, itemTypeTransmog, "匕首" }, { 152946, itemTypeTransmog, "板甲" }, { 152944, itemTypeTransmog, "板甲" }, { 152949, itemTypeTransmog, "板甲" }, { 152942, itemTypeTransmog, "板甲" }, { 152947, itemTypeTransmog, "板甲" }, { 152943, itemTypeTransmog, "板甲" }, { 152945, itemTypeTransmog, "板甲" }, { 152948, itemTypeTransmog, "板甲" } }, note = _L["Mistress Il'thendra_note"] },
	{ coord = 56204550, npcId = 122999, questId = 49241, icon = "skull_grey", group = "rare_aw", label = _L["Gar'zoth"], search = { "加尔佐斯" }, loot = nil, _L["Gar'zoth_note"] },


	{ coord = 59804030, npcId = 128024, questId = 0, icon = "battle_pet", group = "pet_aw", label = _L["One-of-Many"], loot = nil, note = _L["One-of-Many_note"] },
	{ coord = 76707390, npcId = 128023, questId = 0, icon = "battle_pet", group = "pet_aw", label = _L["Minixis"], loot = nil, note = _L["Minixis_note"] },
	{ coord = 51604140, npcId = 128019, questId = 0, icon = "battle_pet", group = "pet_aw", label = _L["Watcher"], loot = nil, note = _L["Watcher_note"] },
	{ coord = 56605420, npcId = 128020, questId = 0, icon = "battle_pet", group = "pet_aw", label = _L["Bloat"], loot = nil, note = _L["Bloat_note"] },
	{ coord = 56102870, npcId = 128021, questId = 0, icon = "battle_pet", group = "pet_aw", label = _L["Earseeker"], loot = nil, note = _L["Earseeker_note"] },
	{ coord = 64106600, npcId = 128022, questId = 0, icon = "battle_pet", group = "pet_aw", label = _L["Pilfer"], loot = nil, note = _L["Pilfer_note"] },
	
	{ coord = 60214557, npcId = 128134, questId = 0, icon = "eye", group = "npc_aw", label = _L["Orix the All-Seer"], loot = { { 153204, itemTypeToy }, { 153026, itemTypePet, 2115 } }, note = _L["Orix the All-Seer_note"] },

	-- Shoot First, Loot Later
	-- Requires 48201 Reinforce Light's Purchase
	-- and 48202 -> followed by 47473 and/or 48929
	{ coord = 58765894, objId = 277204, questId = 49017, icon = "starChestBlue", group = "sfll_aw", label = _L["Forgotten Legion Supplies"], loot = nil, note = _L["Forgotten Legion Supplies_note"] },
	{ coord = 65973977, objId = 277205, questId = 49018, icon = "starChestYellow", group = "sfll_aw", label = _L["Ancient Legion War Cache"], loot = { { 153308, itemTypeTransmog, "单手锤" } }, note = _L["Ancient Legion War Cache_note"] },
	{ coord = 52192708, objId = 277206, questId = 49019, icon = "starChestYellow", group = "sfll_aw", label = _L["Fel-Bound Chest"], loot = nil, note = _L["Fel-Bound Chest_note"] },
	{ coord = 49145940, objId = 277207, questId = 49020, icon = "starChestBlank", group = "sfll_aw", label = _L["Legion Treasure Hoard"], loot = { { 153291, itemTypeTransmog, "法杖" } }, note = _L["Legion Treasure Hoard_note"] },
	{ coord = 75595267, objId = 277208, questId = 49021, icon = "starChestBlank", group = "sfll_aw", label = _L["Timeworn Fel Chest"], loot = nil, note = _L["Timeworn Fel Chest_note"] },
	-- no loot on wowhead yet
	{ coord = 57426366, objId = 277346, questId = 49159, icon = "starChestPurple", group = "sfll_aw", label = _L["Missing Augari Chest"], loot = nil, note = _L["Missing Augari Chest_note"] },

	-- 48382
	{ coord = 67546980, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = _L["48382_67546980_note"] },
	{ coord = 67466226, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = _L["48382_67466226_note"] },
	{ coord = 71326946, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = _L["48382_71326946_note"] },
	{ coord = 58066806, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = _L["48382_58066806_note"] },
	{ coord = 68026624, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = _L["48382_68026624_note"] },
	{ coord = 64506868, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = _L["48382_64506868_note"] },
	-- 48383
	{ coord = 56903570, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_56903570_note"] },
	{ coord = 57633179, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_57633179_note"] },
	{ coord = 52182918, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_52182918_note"] },
	{ coord = 58174021, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_58174021_note"] },
	{ coord = 51863409, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_51863409_note"] },
	{ coord = 55133930, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_55133930_note"] },
	{ coord = 58413097, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_58413097_note"] },
	{ coord = 53753556, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_53753556_note"] },
	{ coord = 51703529, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_51703529_note"] },
	{ coord = 59853583, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_59853583_note"] },
	-- 48384
	{ coord = 60872900, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = _L["48384_60872900_note"] },
	{ coord = 61332054, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = _L["48384_61332054_note"] },
	{ coord = 59081942, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = _L["48384_59081942_note"] },
	{ coord = 64152305, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = _L["48384_64152305_note"] },
	{ coord = 66621709, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = _L["48384_66621709_note"] },
	{ coord = 63682571, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = _L["48384_63682571_note"] },
	{ coord = 61862236, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = _L["48384_61862236_note"] },
	{ coord = 64132738, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = _L["48384_64132738_note"] },
	-- 48385
	{ coord = 50605720, questId = 48385, icon = "treasure", group = "treasure_aw", label = "48385", loot = nil, note = _L["48385_50605720_note"] },
	{ coord = 55544743, questId = 48385, icon = "treasure", group = "treasure_aw", label = "48385", loot = nil, note = _L["48385_55544743_note"] },
	{ coord = 57135124, questId = 48385, icon = "treasure", group = "treasure_aw", label = "48385", loot = nil, note = _L["48385_57135124_note"] },
	{ coord = 55915425, questId = 48385, icon = "treasure", group = "treasure_aw", label = "48385", loot = nil, note = _L["48385_55915425_note"] },
	{ coord = 48195451, questId = 48385, icon = "treasure", group = "treasure_aw", label = "48385", loot = nil, note = _L["48385_48195451_note"] },
	-- 48387
	{ coord = 69403965, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = _L["48387_69403965_note"] },
	{ coord = 66643654, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = _L["48387_66643654_note"] },
	{ coord = 68983342, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = _L["48387_68983342_note"] },
	{ coord = 65522831, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = _L["48387_65522831_note"] },
	{ coord = 63613643, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = _L["48387_63613643_note"] },
	{ coord = 73404669, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = _L["48387_73404669_note"] },
	{ coord = 67954006, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = _L["48387_67954006_note"] },
	-- 48388
	{ coord = 51502610, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = _L["48388_51502610_note"] },
	{ coord = 59261743, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = _L["48388_59261743_note"] },
	{ coord = 55921387, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = _L["48388_55921387_note"] },
	{ coord = 55841722, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = _L["48388_55841722_note"] },
	{ coord = 55622042, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = _L["48388_55622042_note"] },
	{ coord = 59661398, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = _L["48388_59661398_note"] },
	{ coord = 54102803, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = _L["48388_54102803_note"] },
	-- 48389
	{ coord = 64305040, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = _L["48389_64305040_note"] },
	{ coord = 60254351, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = _L["48389_60254351_note"] },
	{ coord = 65514081, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = _L["48389_65514081_note"] },
	{ coord = 60304675, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = _L["48389_60304675_note"] },
	{ coord = 65345192, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = _L["48389_65345192_note"] },
	{ coord = 64114242, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = _L["48389_64114242_note"] },
	{ coord = 58734323, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = _L["48389_58734323_note"] },
	-- 48390
	{ coord = 81306860, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_81306860_note"] },
	{ coord = 80406152, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_80406152_note"] },
	{ coord = 82566503, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_82566503_note"] },
	{ coord = 73316858, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_73316858_note"] },
	{ coord = 77127529, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_77127529_note"] },
	{ coord = 72527293, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_72527293_note"] },
	{ coord = 77255876, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_77255876_note"] },
	{ coord = 72215680, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_72215680_note"] },
	{ coord = 73277299, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_73277299_note"] },
	-- 48391
	{ coord = 64135867, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_64135867_note"] },
	{ coord = 67404790, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_67404790_note"] },
	{ coord = 63615622, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_63615622_note"] },
	{ coord = 65005049, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_65005049_note"] },
	{ coord = 63035762, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_63035762_note"] },
	{ coord = 65185507, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_65185507_note"] },
	{ coord = 68095075, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_68095075_note"] },
	{ coord = 69815522, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_69815522_note"] },
	{ coord = 71205441, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_71205441_note"] },
	{ coord = 66544668, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_66544668_note"] },

}

-- Krokuun
nodes["ArgusSurface"] = {
	{ coord = 44390734, npcId = 125824, questId = 48561, icon = "skull_grey", group = "rare_kr", label = _L["Khazaduum"], search = { "卡扎杜姆" }, loot = { { 153316, itemTypeTransmog, "双手剑" }, { 152946, itemTypeTransmog, "板甲" }, { 152944, itemTypeTransmog, "板甲" }, { 152949, itemTypeTransmog, "板甲" }, { 152942, itemTypeTransmog, "板甲" }, { 152947, itemTypeTransmog, "板甲" }, { 152943, itemTypeTransmog, "板甲" }, { 152945, itemTypeTransmog, "板甲" }, { 152948, itemTypeTransmog, "板甲" } }, note = _L["Khazaduum_note"] },
	{ coord = 33007600, npcId = 122912, questId = 48562, icon = "skull_grey", group = "rare_kr", label = _L["Commander Sathrenael"], search = { "萨森纳尔" }, loot = nil, note = _L["Commander Sathrenael_note"] },
	{ coord = 44505870, npcId = 124775, questId = 48564, icon = "skull_grey", group = "rare_kr", label = _L["Commander Endaxis"], search = { "安达西斯" }, loot = { { 153255, itemTypeTransmog, "单手锤" }, { 152946, itemTypeTransmog, "板甲" }, { 152944, itemTypeTransmog, "板甲" }, { 152949, itemTypeTransmog, "板甲" }, { 152942, itemTypeTransmog, "板甲" }, { 152947, itemTypeTransmog, "板甲" }, { 152943, itemTypeTransmog, "板甲" }, { 152945, itemTypeTransmog, "板甲" }, { 152948, itemTypeTransmog, "板甲" } }, note = _L["Commander Endaxis_note"] },
	{ coord = 53403090, npcId = 123464, questId = 48565, icon = "skull_grey", group = "rare_kr", label = _L["Sister Subversia"], search = { "姐妹" }, loot = { { 153124, itemTypeToy } }, note = _L["Sister Subversia_note"] },
	{ coord = 58007480, npcId = 120393, questId = 48627, icon = "skull_grey", group = "rare_kr", label = _L["Siegemaster Voraan"], search = { "攻城大师" }, loot = nil, note = _L["Siegemaster Voraan_note"] },
	{ coord = 54688126, npcId = 123689, questId = 48628, icon = "skull_grey", group = "rare_kr", label = _L["Talestra the Vile"], search = { "恶毒者" }, loot = { { 153329, itemTypeTransmog, "匕首" }, { 152946, itemTypeTransmog, "板甲" }, { 152944, itemTypeTransmog, "板甲" }, { 152949, itemTypeTransmog, "板甲" }, { 152942, itemTypeTransmog, "板甲" }, { 152947, itemTypeTransmog, "板甲" }, { 152943, itemTypeTransmog, "板甲" }, { 152945, itemTypeTransmog, "板甲" }, { 152948, itemTypeTransmog, "板甲" } }, note = _L["Talestra the Vile_note"] },
	{ coord = 38145920, npcId = 122911, questId = 48563, icon = "skull_grey", group = "rare_kr", label = _L["Commander Vecaya"], search = { "维卡娅" }, loot = { { 153299, itemTypeTransmog, "单手剑" }, { 152946, itemTypeTransmog, "板甲" }, { 152944, itemTypeTransmog, "板甲" }, { 152949, itemTypeTransmog, "板甲" }, { 152942, itemTypeTransmog, "板甲" }, { 152947, itemTypeTransmog, "板甲" }, { 152943, itemTypeTransmog, "板甲" }, { 152945, itemTypeTransmog, "板甲" }, { 152948, itemTypeTransmog, "板甲" } }, note = _L["Commander Vecaya_note"] },
	{ coord = 60802080, npcId = 125388, questId = 48629, icon = "skull_grey", group = "rare_kr", label = _L["Vagath the Betrayed"], search = { "背弃者" }, loot = { { 153114, itemTypeMisc } }, note = _L["Vagath the Betrayed_note"] },
	{ coord = 69605750, npcId = 124804, questId = 48664, icon = "skull_grey", group = "rare_kr", label = _L["Tereck the Selector"], search = { "分选者" }, loot = { { 153263, itemTypeTransmog, "单手斧" }, { 152946, itemTypeTransmog, "板甲" }, { 152944, itemTypeTransmog, "板甲" }, { 152949, itemTypeTransmog, "板甲" }, { 152942, itemTypeTransmog, "板甲" }, { 152947, itemTypeTransmog, "板甲" }, { 152943, itemTypeTransmog, "板甲" }, { 152945, itemTypeTransmog, "板甲" }, { 152948, itemTypeTransmog, "板甲" } }, note = _L["Tereck the Selector_note"] },
	{ coord = 69708050, npcId = 125479, questId = 48665, icon = "skull_grey", group = "rare_kr", label = _L["Tar Spitter"], search = { "焦油" }, loot = nil, note = _L["Tar Spitter_note"] },
	{ coord = 41707020, npcId = 125820, questId = 48666, icon = "skull_grey", group = "rare_kr", label = _L["Imp Mother Laglath"], search = { "鬼母" }, loot = nil, note = _L["Imp Mother Laglath_note"] },
	{ coord = 71063274, npcId = 126419, questId = 48667, icon = "skull_grey", group = "rare_kr", label = _L["Naroua"], search = { "纳罗瓦" }, loot = { { 153190, itemTypeMisc }, { 153054, itemTypePet, 2118 }, { 153055, itemTypePet, 2119 }, { 152841, itemTypeMount, 975 }, { 152843, itemTypeMount, 906 }, { 152842, itemTypeMount, 974 }, { 152840, itemTypeMount, 976 } }, note = _L["Naroua_note"] },

	{ coord = 43005200, npcId = 128009, questId = 0, icon = "battle_pet", group = "pet_kr", label = _L["Baneglow"], loot = nil, note = _L["Baneglow_note"] },
	{ coord = 51506380, npcId = 128008, questId = 0, icon = "battle_pet", group = "pet_kr", label = _L["Foulclaw"], loot = nil, note = _L["Foulclaw_note"] },
	{ coord = 66847263, npcId = 128007, questId = 0, icon = "battle_pet", group = "pet_kr", label = _L["Ruinhoof"], loot = nil, note = _L["Ruinhoof_note"] },
	{ coord = 29605790, npcId = 128011, questId = 0, icon = "battle_pet", group = "pet_kr", label = _L["Deathscreech"], loot = nil, note = _L["Deathscreech_note"] },
	{ coord = 39606650, npcId = 128012, questId = 0, icon = "battle_pet", group = "pet_kr", label = _L["Gnasher"], loot = nil, note = _L["Gnasher_note"] },
	{ coord = 58302970, npcId = 128010, questId = 0, icon = "battle_pet", group = "pet_kr", label = _L["Retch"], loot = nil, note = _L["Retch_note"] },

	-- Shoot First, Loot Later
	{ coord = 51407622, objId = 276490, questId = 48884, icon = "starChestBlue", group = "sfll_kr", label = _L["Krokul Emergency Cache"], loot = { { 153304, itemTypeTransmog, "单手斧" } }, note = _L["Krokul Emergency Cache_note"] },
	{ coord = 62783753, objId = 276489, questId = 48885, icon = "starChestYellow", group = "sfll_kr", label = _L["Legion Tower Chest"], loot = nil, note = _L["Legion Tower Chest_note"] },
	{ coord = 48555894, objId = 276491, questId = 48886, icon = "starChestYellow", group = "sfll_kr", label = _L["Lost Krokul Chest"], loot = nil, note = _L["Lost Krokul Chest_note"] },
	{ coord = 75176975, objId = 277343, questId = 49154, icon = "starChestPurple", group = "sfll_kr", label = _L["Long-Lost Augari Treasure"], loot = nil, note = _L["Long-Lost Augari Treasure_note"] },
	{ coord = 55937428, objId = 277344, questId = 49156, icon = "starChestPurple", group = "sfll_kr", label = _L["Precious Augari Keepsakes"], loot = nil, note = _L["Precious Augari Keepsakes_note"] },

	-- 47752
	{ coord = 55555863, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = _L["47752_55555863_note"] },
	{ coord = 52185431, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = _L["47752_52185431_note"] },
	{ coord = 50405122, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = _L["47752_50405122_note"] },
	{ coord = 53265096, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = _L["47752_53265096_note"] },
	{ coord = 57005472, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = _L["47752_57005472_note"] },
	{ coord = 59695196, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = _L["47752_59695196_note"] },
	{ coord = 51425958, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = _L["47752_51425958_note"] },
	-- 47753
	{ coord = 53137304, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = _L["47753_53137304_note"] },
	{ coord = 55228114, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = _L["47753_55228114_note"] },
	{ coord = 59267341, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = _L["47753_59267341_note"] },
	{ coord = 56118037, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = _L["47753_56118037_note"] },
	{ coord = 58597958, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = _L["47753_58597958_note"] },
	{ coord = 58197157, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = _L["47753_58197157_note"] },
	{ coord = 52737591, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = _L["47753_52737591_note"] },
	{ coord = 58048036, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = _L["47753_58048036_note"] },
	-- 47997
	{ coord = 45876777, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_45876777_note"] },
	{ coord = 45797753, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_45797753_note"] },
	{ coord = 43858139, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_43858139_note"] },
	{ coord = 43816689, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_43816689_note"] },
	{ coord = 40687531, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_40687531_note"] },
	{ coord = 46996831, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_46996831_note"] },
	{ coord = 41438003, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_41438003_note"] },
	{ coord = 41548379, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_41548379_note"] },
	{ coord = 46458665, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_46458665_note"] },
	{ coord = 40357414, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_40357414_note"] },
	-- 47999
	{ coord = 62592581, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_62592581_note"] },
	{ coord = 59763951, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_59763951_note"] },
	{ coord = 59071884, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_59071884_note"] },
	{ coord = 61643520, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_61643520_note"] },
	{ coord = 61463580, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_61463580_note"] },
	{ coord = 59603052, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_59603052_note"] },
	{ coord = 60891852, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_60891852_note"] },
	{ coord = 49063350, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_49063350_note"] },
	{ coord = 65992286, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_65992286_note"] },
	{ coord = 64632319, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_64632319_note"] },
	{ coord = 51533583, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_51533583_note"] },
	{ coord = 60422354, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_60422354_note"] },
	-- 48000
	{ coord = 70907370, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_70907370_note"] },
	{ coord = 74136790, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_74136790_note"] },
	{ coord = 75166435, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_75166435_note"] },
	{ coord = 69605772, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_69605772_note"] },
	{ coord = 69787836, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_69787836_note"] },
	{ coord = 68566054, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_68566054_note"] },
	{ coord = 72896482, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_72896482_note"] },
	{ coord = 71827536, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_71827536_note"] },
	{ coord = 73577146, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_73577146_note"] },
	{ coord = 71846166, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_71846166_note"] },
	{ coord = 67886231, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_67886231_note"] },
	{ coord = 74996922, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_74996922_note"] },
	-- 48336
	{ coord = 33575511, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_33575511_note"] },
	{ coord = 32047441, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_32047441_note"] },
	{ coord = 27196668, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_27196668_note"] },
	{ coord = 31936750, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_31936750_note"] },
	{ coord = 35415637, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_35415637_note"] },
	{ coord = 29645761, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_29645761_note"] },
	{ coord = 40526067, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_40526067_note"] },
	{ coord = 36205543, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_36205543_note"] },
	{ coord = 25996814, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_25996814_note"] },
	{ coord = 37176401, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_37176401_note"] },
	{ coord = 28247134, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_28247134_note"] },
	{ coord = 30276403, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_30276403_note"] },
	-- 48339
	{ coord = 68533891, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_68533891_note"] },
	{ coord = 63054240, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_63054240_note"] },
	{ coord = 64964156, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_64964156_note"] },
	{ coord = 73393438, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_73393438_note"] },
	{ coord = 72213234, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_72213234_note"] },
	{ coord = 65983499, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_65983499_note"] },
	{ coord = 64934217, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_64934217_note"] },
	{ coord = 67713454, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_67713454_note"] },
	{ coord = 72493605, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_72493605_note"] },

}

nodes["ArgusCitadelSpire"] = {
	{ coord = 38954032, npcId = 125824, questId = 48561, icon = "skull_grey", group = "rare_kr", label = _L["Khazaduum"], search = { "卡扎杜姆" }, loot = { { 153316, itemTypeTransmog, "双手剑" }, { 152946, itemTypeTransmog, "板甲" }, { 152944, itemTypeTransmog, "板甲" }, { 152949, itemTypeTransmog, "板甲" }, { 152942, itemTypeTransmog, "板甲" }, { 152947, itemTypeTransmog, "板甲" }, { 152943, itemTypeTransmog, "板甲" }, { 152945, itemTypeTransmog, "板甲" }, { 152948, itemTypeTransmog, "板甲" } }, note = _L["Khazaduum_note"] },
}

-- Mac'Aree
nodes["ArgusMacAree"] = {
	{ coord = 44607160, npcId = 122838, questId = 48692, icon = "skull_grey", group = "rare_ma", label = _L["Shadowcaster Voruun"], search = { "暗影法师" }, loot = { { 153296, itemTypeTransmog, "单手剑" } }, note = _L["Shadowcaster Voruun_note"] },
	{ coord = 52976684, npcId = 126815, questId = 48693, icon = "skull_grey", group = "rare_ma", label = _L["Soultwisted Monstrosity"], search = { "畸体" }, loot = nil, note = _L["Soultwisted Monstrosity_note"] },
	{ coord = 55536016, npcId = 126852, questId = 48695, icon = "skull_grey", group = "rare_ma", label = _L["Wrangler Kravos"], search = { "牧羊人" }, loot = { { 153269, itemTypeTransmog, "单手斧" }, { 152814, itemTypeMount, 970 } }, note = _L["Wrangler Kravos_note"] },
	{ coord = 38705580, npcId = 126860, questId = 48697, icon = "skull_grey", group = "rare_ma", label = _L["Kaara the Pale"], search = { "苍白" }, loot = { { 153190, itemTypeMisc }, { 153054, itemTypePet, 2118 }, { 153055, itemTypePet, 2119 }, { 152841, itemTypeMount, 975 }, { 152843, itemTypeMount, 906 }, { 152842, itemTypeMount, 974 }, { 152840, itemTypeMount, 976 } }, note = _L["Kaara the Pale_note"] },
	-- { coord = 38705580, npcId = 126860, questId = 48697, icon = "skull_grey", group = "rare_ma", label = _L["Kaara the Pale"], search = { "苍白" }, loot = nil, note = _L["Kaara the Pale_note"] },
	{ coord = 41121149, npcId = 126864, questId = 48702, icon = "skull_grey", group = "rare_ma", label = _L["Feasel the Muffin Thief"], search = { "大盗" }, loot = { { 152998, itemTypeMisc } }, note = _L["Feasel the Muffin Thief_note"] },
	{ coord = 36682383, npcId = 126865, questId = 48703, icon = "skull_grey", group = "rare_ma", label = _L["Vigilant Thanos"], search = { "泰诺斯" }, loot = { { 153322, itemTypeTransmog, "盾牌" } }, note = _L["Vigilant Thanos_note"] },
	{ coord = 63806460, npcId = 126866, questId = 48704, icon = "skull_grey", group = "rare_ma", label = _L["Vigilant Kuro"], search = { "库洛" }, loot = { { 153323, itemTypeTransmog, "盾牌" }, { 153183, itemTypeToy } }, note = _L["Vigilant Kuro_note"] },
	{ coord = 33654801, npcId = 126867, questId = 48705, icon = "skull_grey", group = "rare_ma", label = _L["Venomtail Skyfin"], search = { "毒尾" }, loot = { { 152844, itemTypeMount, 973 } }, note = _L["Venomtail Skyfin_note"] },
	{ coord = 38226435, npcId = 126868, questId = 48706, icon = "skull_grey", group = "rare_ma", label = _L["Turek the Lucid"], search = { "清醒者" }, loot = { { 153306, itemTypeTransmog, "单手斧" } }, note = _L["Turek the Lucid_note"] },
	{ coord = 27192995, npcId = 126869, questId = 48707, icon = "skull_grey", group = "rare_ma", label = _L["Captain Faruq"], search = { "法鲁克" }, loot = nil, note = _L["Captain Faruq_note"] },
	{ coord = 34943711, npcId = 126885, questId = 48708, icon = "skull_grey", group = "rare_ma", label = _L["Umbraliss"], search = { "乌伯拉利斯" }, loot = nil, note = _L["Umbraliss_note"] },
	{ coord = 70294598, npcId = 126889, questId = 48710, icon = "skull_grey", group = "rare_ma", label = _L["Sorolis the Ill-Fated"], search = { "厄运者" }, loot = { { 153292, itemTypeTransmog, "法杖" } }, note = _L["Sorolis the Ill-Fated_note"] },
	{ coord = 35965897, npcId = 126896, questId = 48711, icon = "skull_grey", group = "rare_ma", label = _L["Herald of Chaos"], search = { "先驱" }, loot = nil,  note = _L["Herald of Chaos_note"] },
	{ coord = 44204980, npcId = 126898, questId = 48712, icon = "skull_grey", group = "rare_ma", label = _L["Sabuul"], search = { "沙布尔" }, loot = { { 153190, itemTypeMisc }, { 153054, itemTypePet, 2118 }, { 153055, itemTypePet, 2119 }, { 152841, itemTypeMount, 975 }, { 152843, itemTypeMount, 906 }, { 152842, itemTypeMount, 974 }, { 152840, itemTypeMount, 976 } }, note = _L["Sabuul_note"] },
	{ coord = 48504090, npcId = 126899, questId = 48713, icon = "skull_grey", group = "rare_ma", label = _L["Jed'hin Champion Vorusk"], search = { "杰德尼勇士" }, loot = { { 153302, itemTypeTransmog, "单手剑" } }, note = _L["Jed'hin Champion Vorusk_note"] },
	{ coord = 58783762, npcId = 124440, questId = 48714, icon = "skull_grey", group = "rare_ma", label = _L["Overseer Y'Beda"], search = { "伊比达" }, loot = { { 153315, itemTypeTransmog, "双手剑" } }, note = _L["Overseer Y'Beda_note"] },
	{ coord = 58003090, npcId = 125497, questId = 48716, icon = "skull_grey", group = "rare_ma", label = _L["Overseer Y'Sorna"], search = { "伊索纳" }, loot = { { 153268, itemTypeTransmog, "单手斧" } }, note = _L["Overseer Y'Sorna_note"] },
	{ coord = 60982982, npcId = 125498, questId = 48717, icon = "skull_grey", group = "rare_ma", label = _L["Overseer Y'Morna"], search = { "伊莫拉" }, loot = { { 153257, itemTypeTransmog, "单手锤" } }, note = _L["Overseer Y'Morna_note"] },
	{ coord = 61575035, npcId = 126900, questId = 48718, icon = "skull_grey", group = "rare_ma", label = _L["Instructor Tarahna"], search = { "导师" }, loot = { { 153309, itemTypeTransmog, "单手锤" }, { 153179, itemTypeToy }, { 153180, itemTypeToy }, { 153181, itemTypeToy } }, note = _L["Instructor Tarahna_note"] },
	{ coord = 66742845, npcId = 126908, questId = 48719, icon = "skull_grey", group = "rare_ma", label = _L["Zul'tan the Numerous"], search = { "万千之主" }, loot = nil, note = _L["Zul'tan the Numerous_note"] },
	{ coord = 56801450, npcId = 126910, questId = 48720, icon = "skull_grey", group = "rare_ma", label = _L["Commander Xethgar"], search = { "泽斯加尔" }, loot = nil, note = _L["Commander Xethgar_note"] },
	{ coord = 49870953, npcId = 126912, questId = 48721, icon = "skull_grey", group = "rare_ma", label = _L["Skreeg the Devourer"], search = { "斯克里格" }, loot = { { 152904, itemTypeMount, 980 } }, note = _L["Skreeg the Devourer_note"] },
	{ coord = 43846065, npcId = 126862, questId = 48700, icon = "skull_grey", group = "rare_ma", label = _L["Baruut the Bloodthirsty"], search = { "巴鲁特" }, loot = { { 153193, itemTypeToy } }, note = _L["Baruut the Bloodthirsty_note"] },
	{ coord = 30124019, npcId = 126887, questId = 48709, icon = "skull_grey", group = "rare_ma", label = _L["Ataxon"], search = { "阿塔克松" }, loot = { { 153056, itemTypePet, 2120 } }, note = _L["Ataxon_note"] },
	-----------------
	{ coord = 49505280, npcId = 126913, questId = 48935, icon = "skull_grey", group = "rare_ma", label = _L["Slithon the Last"], search = { "希里索恩" }, loot = { { 153203, itemTypeMisc } }, note = _L["Slithon the Last_note"] },

	{ coord = 60007110, npcId = 128015, questId = 0, icon = "battle_pet", group = "pet_ma", label = _L["Gloamwing"], loot = nil, note = _L["Gloamwing_note"] },
	{ coord = 67604390, npcId = 128013, questId = 0, icon = "battle_pet", group = "pet_ma", label = _L["Bucky"], loot = nil, note = _L["Bucky_note"] },
	{ coord = 74703620, npcId = 128018, questId = 0, icon = "battle_pet", group = "pet_ma", label = _L["Mar'cuus"], loot = nil, note = _L["Mar'cuus_note"] },
	{ coord = 69705190, npcId = 128014, questId = 0, icon = "battle_pet", group = "pet_ma", label = _L["Snozz"], loot = nil, note = _L["Snozz_note"] },
	{ coord = 31903120, npcId = 128017, questId = 0, icon = "battle_pet", group = "pet_ma", label = _L["Corrupted Blood of Argus"], loot = nil, note = _L["Corrupted Blood of Argus_note"] },
	{ coord = 36005410, npcId = 128016, questId = 0, icon = "battle_pet", group = "pet_ma", label = _L["Shadeflicker"], loot = nil, note = _L["Shadeflicker_note"] },
	
	-- Shoot First, Loot Later
	{ coord = 42900549, objId = 276223, questId = 48743, icon = "starChestBlue", group = "sfll_ma", label = _L["Eredar Treasure Cache"], loot = nil, note = _L["Eredar Treasure Cache_note"] },
	{ coord = 50583838, objId = 276224, questId = 48744, icon = "starChestYellow", group = "sfll_ma", label = _L["Chest of Ill-Gotten Gains"], loot = nil, note = _L["Chest of Ill-Gotten Gains_note"] },
	{ coord = 61127256, objId = 276225, questId = 48745, icon = "starChestYellow", group = "sfll_ma", label = _L["Student's Surprising Surplus"], loot = nil, note = _L["Student's Surprising Surplus_note"] },
	{ coord = 40275146, objId = 276226, questId = 48747, icon = "starChestBlue", group = "sfll_ma", label = _L["Void-Tinged Chest"], loot = nil, note = _L["Void-Tinged Chest_note"] },
	{ coord = 70305974, objId = 276227, questId = 48748, icon = "starChestBlank", group = "sfll_ma", label = _L["Augari Secret Stash"], loot = nil, note = _L["Augari Secret Stash_note"] },
	{ coord = 57047684, objId = 276228, questId = 48749, icon = "starChestBlank", group = "sfll_ma", label = _L["Desperate Eredar's Cache"], loot = { { 153267, itemTypeTransmog, "单手斧" } }, note = _L["Desperate Eredar's Cache_note"] },
	{ coord = 27274014, objId = 276229, questId = 48750, icon = "starChestBlank", group = "sfll_ma", label = _L["Shattered House Chest"], loot = nil, note = _L["Shattered House Chest_note"] },
	{ coord = 43345447, objId = 276230, questId = 48751, icon = "starChestBlank", group = "sfll_ma", label = _L["Doomseeker's Treasure"], loot = { { 153313, itemTypeTransmog, "双手剑" } }, note = _L["Doomseeker's Treasure_note"] },
	{ coord = 70632744, objId = 277327, questId = 49129, icon = "starChestPurple", group = "sfll_ma", label = _L["Augari-Runed Chest"], loot = nil, note = _L["Augari-Runed Chest_note"] },
	{ coord = 62132247, objId = 277340, questId = 49151, icon = "starChestPurple", group = "sfll_ma", label = _L["Secret Augari Chest"], loot = nil, note = _L["Secret Augari Chest_note"] },
	{ coord = 40856975, objId = 277342, questId = 49153, icon = "starChestPurple", group = "sfll_ma", label = _L["Augari Goods"], loot = nil, note = _L["Augari Goods_note"] },

	-- Ancient Eredar Cache
	-- 48346
	{ coord = 55167766, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = _L["48346_55167766_note"] },
	{ coord = 59386372, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = _L["48346_59386372_note"] },
	{ coord = 57486159, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = _L["48346_57486159_note"] },
	{ coord = 50836729, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = _L["48346_50836729_note"] },
	-- 48350
	{ coord = 59622088, questId = 48350, icon = "treasure", group = "treasure_ma", label = "48350", loot = nil, note = _L["48350_59622088_note"] },
	{ coord = 60493338, questId = 48350, icon = "treasure", group = "treasure_ma", label = "48350", loot = nil, note = _L["48350_60493338_note"] },
	{ coord = 53912335, questId = 48350, icon = "treasure", group = "treasure_ma", label = "48350", loot = nil, note = _L["48350_53912335_note"] },
	{ coord = 55063508, questId = 48350, icon = "treasure", group = "treasure_ma", label = "48350", loot = nil, note = _L["48350_55063508_note"] },
	{ coord = 62202636, questId = 48350, icon = "treasure", group = "treasure_ma", label = "48350", loot = nil, note = _L["48350_62202636_note"] },
	-- 48351
	{ coord = 43637134, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_43637134_note"] },
	{ coord = 34205929, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_34205929_note"] },
	{ coord = 43955630, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_43955630_note"] },
	{ coord = 46917346, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_46917346_note"] },
	{ coord = 36296646, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_36296646_note"] },
	{ coord = 42645361, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_42645361_note"] },
	-- 48357
	{ coord = 49412387, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_49412387_note"] },
	{ coord = 47672180, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_47672180_note"] },
	{ coord = 48482115, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_48482115_note"] },
	{ coord = 57881053, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_57881053_note"] },
	{ coord = 52871676, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_52871676_note"] },
	{ coord = 47841956, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_47841956_note"] },
	-- 48371
	{ coord = 48604971, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = _L["48371_48604971_note"] },
	{ coord = 49865494, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = _L["48371_49865494_note"] },
	{ coord = 47023655, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = _L["48371_47023655_note"] },
	{ coord = 49623585, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = _L["48371_49623585_note"] },
	{ coord = 51094790, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = _L["48371_51094790_note"] },
	{ coord = 35535718, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = _L["48371_35535718_note"] },
	-- 48362
	{ coord = 66682786, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_66682786_note"] },
	{ coord = 62134077, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_62134077_note"] },
	{ coord = 67254608, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_67254608_note"] },
	{ coord = 68355322, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_68355322_note"] },
	{ coord = 65966017, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_65966017_note"] },
	{ coord = 62053268, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_62053268_note"] },
	-- Void-Seeped Cache / Treasure Chest
	-- 49264
	{ coord = 38143985, questId = 49264, icon = "treasure", group = "treasure_ma", label = "49264", loot = nil, note = _L["49264_38143985_note"] },
	{ coord = 37613608, questId = 49264, icon = "treasure", group = "treasure_ma", label = "49264", loot = nil, note = _L["49264_37613608_note"] },
	{ coord = 37812344, questId = 49264, icon = "treasure", group = "treasure_ma", label = "49264", loot = nil, note = _L["49264_37812344_note"] },
	{ coord = 33972078, questId = 49264, icon = "treasure", group = "treasure_ma", label = "49264", loot = nil, note = _L["49264_33972078_note"] },
	-- 48361
	{ coord = 37664221, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = _L["48361_37664221_note"] },
	{ coord = 25824471, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = _L["48361_25824471_note"] },
	{ coord = 20674033, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = _L["48361_20674033_note"] },
	{ coord = 29503999, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = _L["48361_29503999_note"] },
	{ coord = 29455043, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = _L["48361_29455043_note"] },
	{ coord = 18794171, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = _L["48361_18794171_note"] },

}

local function prepareNodesData()
	numSearches = 0;
	for mapId,mapFile in pairs( nodes ) do
		local numNodes = #nodes[mapId];
		nodes[mapId][1]["lookup"] = {};
		local lookup = nodes[mapId][1]["lookup"];
		for i = 1,numNodes do
			local node = nodes[mapId][i];
			if ( node["group"]:find( "rare" ) ) then
				node["lfgGroups"] = {};
				node["numLfgGroups"] = 0;
				node["ratioLfgGroups"] = 0.0;
				node["confUp"] = 0.0;
				node["up"] = false;
			end
			if ( i < numNodes ) then
				node["nextNode"] = nodes[mapId][i+1];
			else
				node["nextNode"] = nil;
			end
			lookup[node["coord"]] = node;
		end
	end
end

-- lazy and inefficient as fuck, i know
local function GetNodeByCoord( mapFile, coord )
	if ( nodes[mapFile] ) then
		for i,node in ipairs(nodes[mapFile]) do
			if ( node["coord"] == coord ) then
				return node;
			end
		end
	end
	return nil
end

--
--
--	Globals
--
--

local clickedMapFile = nil
local clickedCoord = nil
local numSearches = 0;

--
--
--	Helpers
--
--

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

--
--
--	Tooltip
--
--

local npc_tooltip = CreateFrame("GameTooltip", "HandyNotesArgus_npcToolTip", UIParent, "GameTooltipTemplate")
local tooltip_label

local function getCreatureNamebyID(id)
	npc_tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	npc_tooltip:SetHyperlink(("unit:Creature-0-0-0-0-%d"):format(id))
	tooltip_label = _G["HandyNotesArgus_npcToolTipTextLeft1"]:GetText()
end

function Argus:OnEnter(mapFile, coord)
	local node = GetNodeByCoord( mapFile, coord );
	local itemDataMissing = false;
    if ( not node ) then return end
    
    local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip

    if ( self:GetCenter() > UIParent:GetCenter() ) then
        tooltip:SetOwner(self, "ANCHOR_LEFT")
    else
        tooltip:SetOwner(self, "ANCHOR_RIGHT")
    end
	
	local label = "";
	if ( node["npcId"] ) then
		tooltip_label = nil;
		getCreatureNamebyID( node["npcId"] );
		if ( tooltip_label ) then
			if ( node["ratioLfgGroups"] ) then
				label = tooltip_label .. " (" .. string.format("%.2f", node["ratioLfgGroups"] ) .. ")";
			else
				label = tooltip_label
			end
		end
	else
		label = node["label"];
	end
	tooltip:SetText( label );
	if ( Argus.db.profile.show_notes == true and node["note"] and node["note"] ~= nil ) then
		-- note
		tooltip:AddLine(("" .. node["note"]), nil, nil, nil, true)
	end
    if (	( Argus.db.profile.show_loot == true ) and
			( node["loot"] ~= nil ) and
			( type(node["loot"]) == "table" ) ) then
		local ii;
		local loot = node["loot"];
		for ii = 1, #loot do
			local _, itemLink, _, _, _, _, _, _, _, _ = GetItemInfo( loot[ii][1] );
			if ( not itemLink ) then
				itemLink = "Retrieving data ...";
				itemDataMissing = true;
			end
			-- loot
			if ( loot[ii][2] == itemTypeMount ) then
				-- check mount known
				local n,_,_,_,_,_,_,_,_,_,c,j=C_MountJournal.GetMountInfoByID( loot[ii][3] );
				if ( c == true ) then
					tooltip:AddLine( itemLink .. " " .. _L["(Mount known)"], nil, nil, nil, true)
				else
					tooltip:AddLine( itemLink .. " " .. _L["(Mount missing)"], nil, nil, nil, true)
				end
			elseif ( loot[ii][2] == itemTypePet ) then
				-- check pet quantity
				local n,m = C_PetJournal.GetNumCollectedInfo( loot[ii][3] );
				tooltip:AddLine( itemLink .. " (宠物 " .. n .. "/" .. m .. ")", nil, nil, nil, true)
			elseif ( loot[ii][2] == itemTypeToy ) then
				-- check toy known
				if ( PlayerHasToy( loot[ii][1] ) == true ) then
					tooltip:AddLine( itemLink .. " " .. _L["(Toy known)"], nil, nil, nil, true)
				else
					tooltip:AddLine( itemLink .. " " .. _L["(Toy missing)"], nil, nil, nil, true)
				end
			elseif ( isCanIMogItloaded == true and loot[ii][2] == itemTypeTransmog ) then
				-- check transmog known with canimogit
				-- local _,itemLink = GetItemInfo( loot[ii][1] );
				if ( itemLink ~= _L["Retrieving data ..."] ) then
					if ( CanIMogIt:PlayerKnowsTransmog( itemLink ) ) then
						tooltip:AddLine( itemLink .. " " .. string.format( _L["(itemLinkGreen)"], loot[ii][3] ), nil, nil, nil, true)
					else
						tooltip:AddLine( itemLink .. " " .. string.format( _L["(itemLinkRed)"], loot[ii][3] ), nil, nil, nil, true)
					end
				else
					tooltip:AddLine( itemLink .. " (" .. loot[ii][3] .. ")", nil, nil, nil, true)
				end
			elseif ( loot[ii][2] == itemTypeTransmog ) then
				-- show transmog without check
				tooltip:AddLine( itemLink .. " (" .. loot[ii][3] .. ")", nil, nil, nil, true)
			else
				-- default show itemLink
				tooltip:AddLine( itemLink, nil, nil, nil, true)
			end
		end
    end

    tooltip:Show()
	if ( itemDataMissing == true ) then
		-- try refreshing if itemlinks are missing
		C_Timer.After( 1, function()
			Argus:Refresh();
		end );
	end
end

local function hideNode(button, mapFile, coord)
	local node = GetNodeByCoord( mapFile, coord );
    if ( node and node["questId"] ~= nil) then
        Argus.db.char[mapFile .. "_" .. coord .. "_" .. node["questId"]] = true;
    end

    Argus:Refresh()
end

local function ResetDB()
    table.wipe(Argus.db.char)
    Argus:Refresh()
end

local function addtoTomTom(button, mapFile, coord)
	local node = GetNodeByCoord( mapFile, coord );
	if ( node and isTomTomloaded == true ) then
		local mapId = HandyNotes:GetMapFiletoMapID(mapFile)
		local x, y = HandyNotes:getXY(coord)
		local desc = node["label"];

		TomTom:AddMFWaypoint(mapId, nil, x, y, {
			title = desc,
			persistent = nil,
			minimap = true,
			world = true
		});
	end
end


--
--
--	Group finder shit
--
--

local groupBrowserMenuFrame = CreateFrame( "Frame", "groupBrowserMenuFrame", UIParent, "UIDropDownMenuTemplate");

local function resetNPCGroupCounts()
	numSearches = 0;
	for mapId,mapFile in pairs( nodes ) do
		for i,node in ipairs( nodes[mapId] ) do
			if ( node["group"]:find( "rare" ) ) then
				node["lfgGroups"] = {};
				node["numLfgGroups"] = 0;
				node["ratioLfgGroups"] = 0.0;
				node["confUp"] = 0.0;
				node["up"] = false;
			end
		end
	end
end

local function updateNPCGroupCount( gName, gLeader )
	gName = gName:lower();
	if ( not gLeader ) then
		gLeader = "none";
	end
	for mapId,mapFile in pairs( nodes ) do
		for i,node in ipairs( nodes[mapId] ) do
			if ( node["group"]:find( "rare" ) ) then
				for sIdx, search in ipairs( node["search"] ) do
					if ( gName:match( search ) ) then
						--print( "add " .. gName .. " to " .. node["label"] );
						node["lfgGroups"][gName.."-"..gLeader] = gName.."-"..gLeader;
					end
				end
			end
		end
	end
end

local function countTable( t )
	local c = 0;
	for k, v in pairs( t ) do
	   c = c + 1;
	end
	return c;
end

local function updateFoundRares()
	local sum = 0;
	local div = 0;
	-- calc the average first and reset up status
	for mapId,mapFile in pairs( nodes ) do
		for i,node in ipairs( nodes[mapId] ) do
			node["up"] = false;
			if ( node["group"]:find( "rare" ) ) then
				local c = countTable( node["lfgGroups"] );
				node["numLfgGroups"] = c;
				if ( c > 0 ) then
					sum = sum + c;
					div = div + 1;
					-- print( node["label"] .. " : " .. c );
					for k,v in pairs( node["lfgGroups"] ) do
						--print( k .. " : " .. v );
					end
				end
			end
		end
	end
	if ( div > 0 ) then
		local avg = sum / div;
		for mapId,mapFile in pairs( nodes ) do
			for i,node in ipairs( nodes[mapId] ) do
				if ( node["group"]:find( "rare" ) ) then
					node["ratioLfgGroups"] = node["numLfgGroups"] / avg;
					node["confUp"] = node["ratioLfgGroups"];
					if ( node["numLfgGroups"] > 5 or node["ratioLfgGroups"] > 0.6 ) then
						node["up"] = true;
					else
						node["up"] = false;
					end
				end
			end
		end
	end
end

local function genGroupBrowserOption( option )
	local text;
	if ( option.numMembers == 1 ) then
		text = string.format( _L["groupBrowserOptionOne"], option.name, option.numMembers, option.age );
	else
		text = string.format( _L["groupBrowserOptionMore"], option.name, option.numMembers, option.age );
	end
	local opt = {
		text = text,
		func = function()
			local tank, heal, dd = C_LFGList.GetAvailableRoles();
			C_LFGList.ApplyToGroup( option.id, "", tank, heal, dd )	;
		end
	};
	return opt;
end

local function LFGcreate( button, node )
	local c,zone,_,_,name = C_LFGList.GetActiveEntryInfo();
	if c == true and name ~= node["label"] then
		if ( UnitIsGroupLeader("player") ) then
			print( string.format( _L["chatmsg_old_group_delisted"], node["label"] ) );
			C_LFGList.RemoveListing();
		else
			print( _L["chatmsg_no_group_priv"] );
		end
	elseif ( c == false ) then
		print( string.format( _L["chatmsg_group_created"], node["label"] ) );
		-- 16 = custom
		local desc;
		if ( string.find( node["group"], "rare" ) ) then
			desc = string.format( _L["listing_desc_rare"], node["label"] ) .. " Created with HandyNotes_Argus ##rare:" .. node["npcId"] .. "#hna:" .. VERSION;
		elseif ( string.find( node["group"], "invasion" ) ) then
			desc = string.format( _L["listing_desc_invasion"], node["label"] ) .. " Created with HandyNotes_Argus ##invasion:" .. node["invasionId"] .. "#hna:" .. VERSION;
		end
		C_LFGList.CreateListing( 16, node["label"], 0, 0, "", desc, true)
	end
end

local function LFGbrowseMatches( matches, node )
	local menu;
	if ( #matches == 0 ) then
		menu = {
			{ text = _L["Sorry, no groups found!"], isTitle = true, notCheckable = true }
		};
	else
		menu = {
			{ text = _L["Groups found:"], isTitle = true, notCheckable = true },
		};
		for k,v in ipairs( matches ) do
			table.insert( menu, genGroupBrowserOption( v ) );
			-- print( v["name"] );
		end
	end
	table.insert( menu, { text = "", isTitle = true, notCheckable = true } );
	table.insert( menu, { text = _L["Create new group"], func = function() LFGcreate( nil, node ); end } );
	table.insert( menu, { text = "", isTitle = true, notCheckable = true } );
	table.insert( menu, { text = _L["Close"], notCheckable = true, func = function() CloseDropDownMenus() end } );
	EasyMenu( menu, groupBrowserMenuFrame, "cursor", 0 , 0, "MENU" );
end

local finderFrame = CreateFrame("Frame");
finderFrame:SetScript("OnEvent", function( self, event, ... )
	if ( event == "LFG_LIST_SEARCH_RESULTS_RECEIVED" ) then
		local numResults, resultIds = C_LFGList.GetSearchResults()
		numSearches = numSearches + 1;
		local matches = {};

		for _, resultId in ipairs( resultIds ) do

			local id, activityID, name, comment, voiceChat, iLvl, honorLevel, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, leaderName, numMembers, isAutoAccept = C_LFGList.GetSearchResultInfo( resultId );
			if ( age < 300 ) then
				-- dont count groups older than 5 minutes
				updateNPCGroupCount( name, leaderName );
			end

			if ( finderFrame.searchNode and isAutoAccept and numMembers ~= 5 ) then
				for sIdx, search in ipairs( finderFrame.searchNode["search"] ) do
					if ( name:lower():match( search ) ) then
						-- print( "found " .. name .. " ( " .. numMembers .. ")");
						table.insert( matches, { id = id, name = name, age = age, numMembers = numMembers } );
					end
				end
			end
		end
		updateFoundRares();
		Argus:Refresh();
		if ( finderFrame.searchNode ) then
			LFGbrowseMatches( matches, finderFrame.searchNode );
			finderFrame.searchNode = nil;
		end
	elseif ( event == "LFG_LIST_SEARCH_FAILED" ) then
		print( _L["chatmsg_search_failed"] );
	else
		-- print( event );
		-- print( ... );
	end
end );

local function LFGCheckRares( button, node )
	finderFrame.searchNode = nil;
	local languages = C_LFGList.GetLanguageSearchFilter();
	C_LFGList.Search( 6, LFGListSearchPanel_ParseSearchTerms (""), nil, nil, allLanguages );
end

local function LFGsearch( button, node )
	if ( node ~= nil ) then
		local c,zone,_,_,name = C_LFGList.GetActiveEntryInfo();
		if c == true and name ~= label then
			if ( UnitIsGroupLeader("player") ) then
				print( string.format( _L["chatmsg_old_group_delisted"], node["label"] ) );
				C_LFGList.RemoveListing();
			else
				print( _L["chatmsg_no_group_priv"] );
			end
		elseif ( c == false ) then
			finderFrame.searchNode = node;
			local languages = C_LFGList.GetLanguageSearchFilter();
			C_LFGList.Search( 6, LFGListSearchPanel_ParseSearchTerms (""), nil, nil, allLanguages );
		end
	end
end

--
--	Invasions
--

local updateInvasionPOI = CreateFrame("Frame");
updateInvasionPOI:SetScript("OnEvent", function( self, event, ... )
	local numPOI = GetNumMapLandmarks();
	for i = 1, numPOI do
		local landmarkType, name, description, textureIndex, x, y, maplinkID, showInBattleMap,_,_,poiId,_,something = C_WorldMap.GetMapLandmarkInfo( i );
		if ( -- val
			 poiId == 5360 or poiId == 5372	or
			 -- aurinor
			 poiId == 5367 or poiId == 5373 or
			 -- sangua
			 poiId == 5350 or poiId == 5369 or
			 -- naigtal
			 poiId == 5368 or poiId == 5374 or
			 -- bonich
			 poiId == 5366 or poiId == 5371 or
			 -- cen'gar
			 poiId == 5359 or poiId == 5370 or
			 -- alluradel
			 poiId == 5375
			) then
			-- print( description );
			local invasionPOI = _G["WorldMapFramePOI" .. i];
			if ( invasionPOI and not invasionPOI.handyNotesArgus ) then
				invasionPOI.handyNotesArgus = true;
				invasionPOI:RegisterForClicks("LeftButtonDown", "LeftButtonUp");
				invasionPOI:SetScript("OnMouseDown", function(self, button)
					local searchNeedle = "";
					if ( self.poiID == 5360 or self.poiID == 5372 ) then
						finderFrame.searchNode = { invasionId = self.poiID, group = "invasion", label = _L["Invasion Point: Val"], search = { _L["invasion_val_search_1"], _L["invasion_val_search_2"] } };
						searchNeedle = _L["invasion_val_search_needle"];
					elseif ( self.poiID == 5367 or self.poiID == 5373 ) then
						finderFrame.searchNode = { invasionId = self.poiID, group = "invasion", label = _L["Invasion Point: Aurinor"], search = { _L["invasion_aurinor_search"] } };
						searchNeedle = _L["invasion_aurinor_search_needle"];
					elseif ( self.poiID == 5369 or self.poiID == 5350 ) then
						finderFrame.searchNode = { invasionId = self.poiID, group = "invasion", label = _L["Invasion Point: Sangua"], search = { _L["invasion_sangua_search"] } };
						searchNeedle = _L["invasion_sangua_search_needle"];
					elseif ( self.poiID == 5368 or self.poiID == 5374 ) then
						finderFrame.searchNode = { invasionId = self.poiID, group = "invasion", label = _L["Invasion Point: Naigtal"], search = { _L["invasion_naigtal_search"] } };
						searchNeedle = _L["invasion_naigtal_search_needle"];
					elseif ( self.poiID == 5366 or self.poiID == 5371 ) then
						finderFrame.searchNode = { invasionId = self.poiID, group = "invasion", label = _L["Invasion Point: Bonich"], search = { _L["invasion_bonich_search"] } };
						searchNeedle = _L["invasion_bonich_search_needle"];
					elseif ( self.poiID == 5359 or self.poiID == 5370 ) then
						finderFrame.searchNode = { invasionId = self.poiID, group = "invasion", label = _L["Invasion Point: Cen'gar"], search = { _L["invasion_cengar_search"] } };
						searchNeedle = _L["invasion_cengar_search_needle"];
					elseif ( self.poiID == 5375 ) then
						finderFrame.searchNode = { invasionId = self.poiID, group = "invasion", label = _L["Greater Invasion Point: Mistress Alluradel"], search = { _L["invasion_alluradel_search"] } };
						searchNeedle = _L["invasion_alluradel_search_needle"];
					else
						return false;
					end
					
					local languages = C_LFGList.GetLanguageSearchFilter();
					C_LFGList.Search( 6, LFGListSearchPanel_ParseSearchTerms ( searchNeedle ), nil, nil, allLanguages );
					
				end );
			end
		end
	end
end );

--
--
--	Communicator
--
--

local communicator = CreateFrame("Frame");
communicator:SetScript("OnEvent", function( self, event, ... )
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		if ( IsInGuild() ) then
			SendAddonMessage( ADDON_MSG_PREFIX, "ver=" .. VERSION, "GUILD" );
		end
	elseif ( event == "GROUP_JOINED" or event == "GROUP_ROSTER_UPDATE" ) then
		SendAddonMessage( ADDON_MSG_PREFIX, "ver=" .. VERSION, "RAID" );
	end
end );

--
--
--	Context menu
--
--

local function generateMenu( button, level )

	local info = {}
    if ( not level ) then return end
	local node = GetNodeByCoord( clickedMapFile, clickedCoord );
	if ( not node ) then return end

    for k in pairs(info) do info[k] = nil end

    if (level == 1) then
        info.isTitle = 1
        info.text = _L["context_menu_title"]
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)
        
        info.disabled = nil
        info.isTitle = nil
        info.notCheckable = 1
		
		if ( (string.find(node["group"], "rare") ~= nil)) then

			info.disabled = 1
			info.notClickable = 1
			info.text = ""
			UIDropDownMenu_AddButton(info, level)
			info.disabled = nil
			info.notClickable = nil

			info.text = _L["context_menu_check_group_finder"]
			info.func = LFGCheckRares
			info.arg1 = node
			UIDropDownMenu_AddButton(info, level)

			info.text = _L["context_menu_reset_rare_counters"]
			info.func = function()
				resetNPCGroupCounts();
				Argus:Refresh();
			end
			UIDropDownMenu_AddButton(info, level)
			
		end

		info.disabled = 1
		info.notClickable = 1
        info.text = ""
        UIDropDownMenu_AddButton(info, level)
		info.disabled = nil
		info.notClickable = nil

        if isTomTomloaded == true and false then
            info.text = _L["context_menu_add_tomtom"]
            info.func = addtoTomTom
            info.arg1 = clickedMapFile
            info.arg2 = clickedCoord
            UIDropDownMenu_AddButton(info, level)
        end

        info.text = _L["context_menu_hide_node"]
        info.func = hideNode
        info.arg1 = clickedMapFile
        info.arg2 = clickedCoord
        UIDropDownMenu_AddButton(info, level)

        info.text = _L["context_menu_restore_hidden_nodes"]
        info.func = ResetDB
        info.arg1 = nil
        info.arg2 = nil
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)
        
		info.disabled = 1
		info.notClickable = 1
        info.text = ""
        UIDropDownMenu_AddButton(info, level)
		info.disabled = nil
		info.notClickable = nil

        info.text = CLOSE
        info.func = function() CloseDropDownMenus() end
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
	local node = GetNodeByCoord( mapFile, coord );
	if ( not node ) then return end
    if button == "RightButton" and down then
		-- context menu
        clickedMapFile = mapFile
        clickedCoord = coord
        ToggleDropDownMenu(1, nil, HandyNotes_ArgusDropdownMenu, self, 0, 0)
	elseif button == "MiddleButton" and down then
		-- create group
		if ( (string.find(node["group"], "rare") ~= nil)) then
			LFGcreate( nil, node );
		end
	elseif button == "LeftButton" and down then
		if ( (string.find(node["group"], "rare") ~= nil)) then
			-- find group
			LFGsearch( nil, node );
		end
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
    name = _L["Argus"],
    get = function(info) return Argus.db.profile[info.arg] end,
    set = function(info, v) Argus.db.profile[info.arg] = v; Argus:Refresh() end,
    args = {
        IconOptions = {
            type = "group",
            name = _L["options_icon_settings"],
            desc = _L["options_icon_settings_desc"],
			inline = true,
			order = 0,
            args = {
				groupIconTreasures = {
					type = "header",
					name = _L["options_icons_treasures"],
					desc = _L["options_icons_treasures_desc"],
					order = 0,
				},
				icon_scale_treasures = {
					type = "range",
					name = _L["options_scale"],
					desc = _L["options_scale_desc"],
					min = 0.25, max = 10, step = 0.01,
					arg = "icon_scale_treasures",
					order = 1,
				},
				icon_alpha_treasures = {
					type = "range",
					name = _L["options_opacity"],
					desc = _L["options_opacity_desc"],
					min = 0, max = 1, step = 0.01,
					arg = "icon_alpha_treasures",
					order = 2,
				},
				groupIconRares = {
					type = "header",
					name = _L["options_icons_rares"],
					desc = _L["options_icons_rares_desc"],
					order = 10,
				},
				icon_scale_rares = {
					type = "range",
					name = _L["options_scale"],
					desc = _L["options_scale_desc"],
					min = 0.25, max = 10, step = 0.01,
					arg = "icon_scale_rares",
					order = 11,
				},
				icon_alpha_rares = {
					type = "range",
					name = _L["options_opacity"],
					desc = _L["options_opacity_desc"],
					min = 0, max = 1, step = 0.01,
					arg = "icon_alpha_rares",
					order = 12,
				},
				groupIconPets = {
					type = "header",
					name = _L["options_icons_pet_battles"],
					desc = _L["options_icons_pet_battles_desc"],
					order = 20,
				},
				icon_scale_pets = {
					type = "range",
					name = _L["options_scale"],
					desc = _L["options_scale_desc"],
					min = 0.25, max = 10, step = 0.01,
					arg = "icon_scale_pets",
					order = 21,
				},
				icon_alpha_pets = {
					type = "range",
					name = _L["options_opacity"],
					desc = _L["options_opacity_desc"],
					min = 0, max = 1, step = 0.01,
					arg = "icon_alpha_pets",
					order = 22,
				},
				groupIconSfll = {
					type = "header",
					name = _L["options_icons_sfll"],
					desc = _L["options_icons_sfll_desc"],
					order = 30,
				},
				icon_scale_sfll = {
					type = "range",
					name = _L["options_scale"],
					desc = _L["options_scale_desc"],
					min = 0.25, max = 10, step = 0.01,
					arg = "icon_scale_sfll",
					order = 31,
				},
				icon_alpha_sfll = {
					type = "range",
					name = _L["options_opacity"],
					desc = _L["options_opacity_desc"],
					min = 0, max = 1, step = 0.01,
					arg = "icon_alpha_sfll",
					order = 32,
				},
			},
		},
		VisibilityGroup = {
			type = "group",
			order = 10,
			name = _L["options_visibility_settings"],
			desc = _L["options_visibility_settings_desc"],
			inline = true,
			args = {
				groupAW = {
					type = "header",
					name = _L["Antoran Wastes"],
					order = 0,
				},
				treasureAW = {
					type = "toggle",
					arg = "treasure_aw",
					name = _L["options_toggle_treasures"],
					order = 1,
					width = "normal",
				},
				rareAW = {
					type = "toggle",
					arg = "rare_aw",
					name = _L["options_toggle_rares"],
					order = 2,
					width = "normal",
				},
				petAW = {
					type = "toggle",
					arg = "pet_aw",
					name = _L["options_toggle_battle_pets"],
					order = 3,
					width = "normal",
				},
				sfllAW = {
					type = "toggle",
					arg = "sfll_aw",
					name = _L["options_toggle_sfll"],
					order = 4,
					width = "normal",
				},
				npcAW = {
					type = "toggle",
					arg = "npc_aw",
					name = _L["options_toggle_npcs"],
					order = 5,
					width = "normal",
				},
				portalAW = {
					type = "toggle",
					arg = "portal_aw",
					name = _L["options_toggle_portals"],
					order = 6,
					width = "normal",
				},
				groupKR = {
					type = "header",
					name = _L["Krokuun"],
					order = 10,
				},  
				treasureKR = {
					type = "toggle",
					arg = "treasure_kr",
					name = _L["options_toggle_treasures"],
					width = "normal",
					order = 11,
				},
				rareKR = {
					type = "toggle",
					arg = "rare_kr",
					name = _L["options_toggle_rares"],
					width = "normal",
					order = 12,
				},
				petKR = {
					type = "toggle",
					arg = "pet_kr",
					name = _L["options_toggle_battle_pets"],
					width = "normal",
					order = 13,
				},
				sfllKR = {
					type = "toggle",
					arg = "sfll_kr",
					name = _L["options_toggle_sfll"],
					order = 14,
					width = "normal",
				},
				groupMA = {
					type = "header",
					name = _L["Mac'Aree"],
					order = 20,
				},  
				treasureMA = {
					type = "toggle",
					arg = "treasure_ma",
					name = _L["options_toggle_treasures"],
					width = "normal",
					order = 21,
				},
				rareMA = {
					type = "toggle",
					arg = "rare_ma",
					name = _L["options_toggle_rares"],
					width = "normal",
					order = 22,
				},  
				petMA = {
					type = "toggle",
					arg = "pet_ma",
					name = _L["options_toggle_battle_pets"],
					width = "normal",
					order = 23,
				},  
				sfllMA = {
					type = "toggle",
					arg = "sfll_ma",
					name = _L["options_toggle_sfll"],
					order = 24,
					width = "normal",
				},
				groupGeneral = {
					type = "header",
					name = _L["options_general_settings"],
					desc = _L["options_general_settings_desc"],
					order = 30,
				},  
				alwaysshowrares = {
					type = "toggle",
					arg = "alwaysshowrares",
					name = _L["options_toggle_alreadylooted_rares"],
					desc = _L["options_toggle_alreadylooted_rares_desc"],
					order = 31,
					width = "full",
				},
				alwaysshowtreasures = {
					type = "toggle",
					arg = "alwaysshowtreasures",
					name = _L["options_toggle_alreadylooted_treasures"],
					desc = _L["options_toggle_alreadylooted_treasures_desc"],
					order = 32,
					width = "full",
				},
				alwaysshowsfll = {
					type = "toggle",
					arg = "alwaysshowsfll",
					name = _L["options_toggle_alreadylooted_sfll"],
					desc = _L["options_toggle_alreadylooted_sfll_desc"],
					order = 33,
					width = "full",
				},
			},
		},
		TooltipGroup = {
			type = "group",
			order = 20,
			name = _L["options_tooltip_settings"],
			desc = _L["options_tooltip_settings_desc"],
			inline = true,
			args = {
				show_loot = {
					type = "toggle",
					arg = "show_loot",
					name = _L["options_toggle_show_loot"],
					desc = _L["options_toggle_show_loot_desc"],
					order = 102,
				},
				show_notes = {
					type = "toggle",
					arg = "show_notes",
					name = _L["options_toggle_show_notes"],
					desc = _L["options_toggle_show_notes_desc"],
					order = 103,
				},
			},
		},
    },
}

-- iterate this until we have all items cache. max 10 iterations
local precacheIteration = 0;
local function cacheItems()
	--print ("grab items");
	precacheIteration = precacheIteration + 1;
	local failed = 0;
	local total = 0;
	for mapId,mapFile in pairs( nodes ) do
		for i,node in ipairs( nodes[mapId] ) do
			node["allLootKnown"] = true;
			if ((node["loot"] ~= nil) and (type(node["loot"]) == "table") ) then
				local ii;
				for ii = 1, #node["loot"] do
					total = total + 1;
					local _, itemLink = GetItemInfo( node["loot"][ii][1] );
					if ( not itemLink ) then failed = failed + 1 end
					if ( not playerHasLoot( node["loot"][ii] ) ) then
						node["allLootKnown"] = false;
					end
				end
			end
			-- preload localized npc names
			if ( node["npcId"] ~= nil ) then
				getCreatureNamebyID( node["npcId"] );
			end
		end
	end
	if ( failed > 0 and precacheIteration < 10 ) then 
		--print( "失败：" .. failed .. " / " .. total );
		C_Timer.After(3, function()
			cacheItems();
		end );
	else
		--print( "获取全部物品" );
	end
end

--
--
--	Main
--
--

function Argus:OnInitialize()
    local defaults = {
        profile = {
            icon_scale_treasures = 2.0,
            icon_scale_rares = 1.875,
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

    self.db = LibStub("AceDB-3.0"):New("HandyNotesArgusDB", defaults, "Default");
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "WorldEnter");
	updateInvasionPOI:RegisterEvent("WORLD_MAP_UPDATE");
	communicator:RegisterEvent("PLAYER_ENTERING_WORLD");
	communicator:RegisterEvent("GROUP_ROSTER_UPDATE");
	communicator:RegisterEvent("GROUP_JOINED");
	finderFrame:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED");
	finderFrame:RegisterEvent("LFG_LIST_SEARCH_FAILED");
	finderFrame:RegisterEvent("LFG_LIST_ENTRY_EXPIRED_TIMEOUT");
	finderFrame:RegisterEvent("LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS");
end

function Argus:WorldEnter()
	prepareNodesData();
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:ScheduleTimer("RegisterWithHandyNotes", 8)
	self:ScheduleTimer("LoadCheck", 6)
	C_Timer.After(10, function()
		cacheItems();
	end );
end

function Argus:RegisterWithHandyNotes()
    do
		local currentMapFile = "";
        local function iter(t, prestate)

		if not t then return nil end
			
			local node;
			if ( prestate ) then
				node = t[1]["lookup"][prestate]["nextNode"];
			else
				node = t[1]
			end

			while node do
                if (node["questId"] and self.db.profile[node["group"]] and not Argus:HasBeenLooted(currentMapFile,node)) then
					-- preload items
					-- local allLootKnown = true
                    --if ( false and (node["loot"] ~= nil) and (type(node["loot"]) == "table") ) then
					--	local ii
					--	for ii = 1, #node["loot"] do
					--		GetIcon(node["loot"][ii][1])
					--		if ( not playerHasLoot( node["loot"][ii] ) ) then
					--			allLootKnown = false
					--		end
					--	end
                    --end
					-- preload localized npc names
					if ( node["npcId"] ~= nil ) then
						--getCreatureNamebyID( node["npcId"] );
					end

					local iconScale = 1;
					local iconAlpha = 1;
					local iconPath = iconDefaults[node["icon"]];
					if ( (string.find(node["group"], "rare") ~= nil)) then
						iconScale = Argus.db.profile.icon_scale_rares;
						iconAlpha = Argus.db.profile.icon_alpha_rares;
						iconPath = iconDefaults["skullWhite"];
						if ( not node["allLootKnown"] and node["confUp"] > 0.75 ) then
							iconPath = iconDefaults["skullBlueGreenGlow"];
						elseif ( not node["allLootKnown"] and node["confUp"] > 0.2 ) then
							iconPath = iconDefaults["skullBlueRedGlow"];
						elseif ( not node["allLootKnown"] ) then
							iconPath = iconDefaults["skullBlue"];
						elseif ( node["allLootKnown"] and node["confUp"] > 0.75 ) then
							iconPath = iconDefaults["skullWhiteGreenGlow"];
						elseif ( node["allLootKnown"] and node["confUp"] > 0.2 ) then
							iconPath = iconDefaults["skullWhiteRedGlow"];
						elseif ( node["allLootKnown"] ) then
							iconPath = iconDefaults["skullWhite"];
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
                    return node["coord"], nil, iconPath, iconScale, iconAlpha
                end
				node = node["nextNode"];
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

function Argus:HasBeenLooted(mapFile,node)
    if (self.db.profile.alwaysshowtreasures and (string.find(node["group"], "treasure") ~= nil)) then return false end
    if (self.db.profile.alwaysshowrares and (string.find(node["group"], "rare") ~= nil)) then return false end
	if (self.db.profile.alwaysshowsfll and (string.find(node["group"], "sfll") ~= nil)) then return false end
    -- if (node["questId"] and node["questId"] == 0) then return false end
    if (Argus.db.char[mapFile .. "_" .. node["coord"] .. "_" .. node["questId"]] and self.db.profile.save) then return true end
    if (IsQuestFlaggedCompleted(node["questId"])) then
        return true
    end

    return false
end

function Argus:LoadCheck()

	if (IsAddOnLoaded("TomTom")) then 
		isTomTomloaded = true
	end

	if (IsAddOnLoaded("CanIMogIt")) then 
		isCanIMogItloaded = true
	end

end
