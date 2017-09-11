-- Thanks to all who provide usable code
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
local isDBMloaded = false
local isCanIMogItloaded = false

-- [XXXXYYYY] = { questId, icon, group, label, loot, note, search },
-- /run local find="Acid Belcher"; for i,mid in ipairs(C_MountJournal.GetMountIDs()) do local n,_,_,_,_,_,_,_,_,_,c,j=C_MountJournal.GetMountInfoByID(mid); if ( n == find ) then print(j .. " " .. n); end end
-- /run local find="Grasping Manifestation"; for i=0,2500 do local n=C_PetJournal.GetPetInfoBySpeciesID(i); if ( n == find ) then print(i .. " " .. n); end end
-- { 152903, itemTypeMount, 981 } Biletooth Gnasher any rare??
-- Antoran Wastes
nodes["ArgusCore"] = {
	{ coord = 52702950, npcId = 127291, questId = 48822, icon = "skull_grey", group = "rare_aw", label = "Watcher Aival", search = { "aival" }, loot = nil, note = nil },
	{ coord = 63902090, npcId = 126040, questId = 48809, icon = "skull_grey", group = "rare_aw", label = "Puscilla", search = { "puscilla" }, loot = { { 152903, itemTypeMount, 981 } }, note = "Entrance to the cave is south east - use the eastern bridge to get there." },
	{ coord = 53103580, npcId = 126199, questId = 48810, icon = "skull_grey", group = "rare_aw", label = "Vrax'thul", search = { "vrax'thul", "vraxthul", "vrax thul" }, loot = { { 152903, itemTypeMount, 981 } }, note = nil },
	{ coord = 63225754, npcId = 126115, questId = 48811, icon = "skull_grey", group = "rare_aw", label = "Ven'orn", search = { "ven'orn", "venorn", "ven orn" }, loot = nil, note = "The entrance to the cave is north east from here in the spider area at 66, 54.1" },
	{ coord = 64304820, npcId = 126208, questId = 48812, icon = "skull_grey", group = "rare_aw", label = "Varga", search = { "varga" }, loot = { { 153190, itemTypeMisc }, { 153054, itemTypePet, 2118 }, { 153055, itemTypePet, 2119 }, { 152841, itemTypeMount, 975 }, { 152843, itemTypeMount, 906 }, { 152842, itemTypeMount, 974 }, { 152840, itemTypeMount, 976 } }, note = nil },
	{ coord = 62405380, npcId = 126254, questId = 48813, icon = "skull_grey", group = "rare_aw", label = "Lieutenant Xakaar", search = { "xakaar" }, loot = nil, note = nil },
	{ coord = 61906430, npcId = 126338, questId = 48814, icon = "skull_grey", group = "rare_aw", label = "Wrath-Lord Yarez", search = { "yarez" }, loot = { { 153126, itemTypeToy } }, note = nil },
	{ coord = 60674831, npcId = 126946, questId = 48815, icon = "skull_grey", group = "rare_aw", label = "Inquisitor Vethroz", search = { "vethroz" }, loot = { { 151543, itemTypeMisc } }, note = nil },
	{ coord = 80206230, npcId = nil, questId = 48816, icon = "portal", group = "portal_aw", label = "Portal to Commander Texlaz", loot = nil, note = nil },
	{ coord = 82006600, npcId = 127084, questId = 48816, icon = "skull_grey", group = "rare_aw", label = "Commander Texlaz", search = { "texlaz" }, loot = nil, note = "Use the portal at 80.2, 62.3 to get on the ship" },
	{ coord = 73207080, npcId = 127090, questId = 48817, icon = "skull_grey", group = "rare_aw", label = "Admiral Rel'var", search = { "rel'var", "relvar", "rel var" }, loot = { { 153324, itemTypeTransmog, "Shield" }, { 152886, itemTypeTransmog, "Cloth" }, { 152888, itemTypeTransmog, "Cloth" }, { 152884, itemTypeTransmog, "Cloth" }, { 152889, itemTypeTransmog, "Cloth" }, { 152885, itemTypeTransmog, "Cloth" }, { 152881, itemTypeTransmog, "Cloth" }, { 152887, itemTypeTransmog, "Cloth" }, { 152883, itemTypeTransmog, "Cloth" } }, note = nil },
	{ coord = 76155614, npcId = 127096, questId = 48818, icon = "skull_grey", group = "rare_aw", label = "All-Seer Xanarian", search = { "xanarian" }, loot = nil, note = nil },
	{ coord = 50905530, npcId = 127118, questId = 48820, icon = "skull_grey", group = "rare_aw", label = "Worldsplitter Skuul", search = { "skuul" }, loot = { { 153312, itemTypeTransmog, "2h Sword" }, { 152886, itemTypeTransmog, "Cloth" }, { 152888, itemTypeTransmog, "Cloth" }, { 152884, itemTypeTransmog, "Cloth" }, { 152889, itemTypeTransmog, "Cloth" }, { 152885, itemTypeTransmog, "Cloth" }, { 152881, itemTypeTransmog, "Cloth" }, { 152887, itemTypeTransmog, "Cloth" }, { 152883, itemTypeTransmog, "Cloth" } }, note = "May be flying around in circles. Will be near ground sometimes. Not on every round though." },
	{ coord = 63812199, npcId = 127288, questId = 48821, icon = "skull_grey", group = "rare_aw", label = "Houndmaster Kerrax", search = { "kerrax", "kerax" }, loot = { { 152790, itemTypeMount, 955 } }, note = nil },
	{ coord = 55702190, npcId = 127300, questId = 48824, icon = "skull_grey", group = "rare_aw", label = "Void Warden Valsuran", search = { "valsuran" }, loot = { { 153319, itemTypeTransmog, "2h Mace" }, { 152886, itemTypeTransmog, "Cloth" }, { 152888, itemTypeTransmog, "Cloth" }, { 152884, itemTypeTransmog, "Cloth" }, { 152889, itemTypeTransmog, "Cloth" }, { 152885, itemTypeTransmog, "Cloth" }, { 152881, itemTypeTransmog, "Cloth" }, { 152887, itemTypeTransmog, "Cloth" }, { 152883, itemTypeTransmog, "Cloth" } }, note = nil },
	{ coord = 61392095, npcId = 127376, questId = 48865, icon = "skull_grey", group = "rare_aw", label = "Chief Alchemist Munculus", search = { "munculus", "muculus" }, loot = nil, note = nil },
	{ coord = 54003800, npcId = 127581, questId = 48966, icon = "skull_grey", group = "rare_aw", label = "The Many-Faced Devourer", search = { "many.*face", "face.*devourer" }, loot = { { 153195, itemTypePet, 2136 } }, note = "Can always be summoned. However you need to find 'Call of the Devourer' from the enemies around there and then collect 3 more things and return tu the pile of bones to summon him." },
	{ coord = 77177319, npcId = nil, questId = 48967, icon = "portal", group = "portal_aw", label = "Portal to Squadron Commander Vishax", loot = nil, note = "First find a Smashed Portal Generator from Immortal Netherwalker. Then collect Conductive Sheath, Arc Circuit and Power Cell from Eredar War-Mind and Felsworn Myrmidon. Use the Smashed Portal Generator to unlock the portal to Vishax." },
	{ coord = 84368118, npcId = 127700, questId = 48967, icon = "skull_grey", group = "rare_aw", label = "Squadron Commander Vishax", search = { "vishax" }, loot = { { 153253, itemTypeToy } }, note = "Use portal at 77.2, 73.2 to get up on the ship" },
	{ coord = 58001200, npcId = 127703, questId = 48968, icon = "skull_grey", group = "rare_aw", label = "Doomcaster Suprax", search = { "suprax" }, loot = { { 153194, itemTypeToy } }, note = "Stand on all 3 runes to summon him." },
	{ coord = 66981777, npcId = 127705, questId = 48970, icon = "skull_grey", group = "rare_aw", label = "Mother Rosula", search = { "rosula" }, loot = { { 153252, itemTypePet, 2135 } }, note = "Inside cave. Use the eastern bridge. Collect 100 Imp Meat which drop from the imps inside the cave. Use it and place the Disgusting Feast into the green soup at the marked spot." },
	{ coord = 64948290, npcId = 127706, questId = 48971, icon = "skull_grey", group = "rare_aw", label = "Rezira the Seer", search = { "rezira" }, loot = { { 153293, itemTypeToy } }, note = "Use Observer's Locus Resonator to open a portal to him. Orix the All-Seer (60.2, 45.4) sells it for 500 Intact Demon Eyes." },
	{ coord = 61703720, npcId = 122958, questId = 49183, icon = "skull_grey", group = "rare_aw", label = "Blistermaw", search = { "blister" }, loot = { { 152905, itemTypeMount, 979 } }, note = nil },
	{ coord = 57403290, npcId = 122947, questId = 49240, icon = "skull_grey", group = "rare_aw", label = "Mistress Il'thendra", search = { "thendra" }, loot = { { 153327, itemTypeTransmog, "Dagger" }, { 152946, itemTypeTransmog, "Plate" }, { 152944, itemTypeTransmog, "Plate" }, { 152949, itemTypeTransmog, "Plate" }, { 152942, itemTypeTransmog, "Plate" }, { 152947, itemTypeTransmog, "Plate" }, { 152943, itemTypeTransmog, "Plate" }, { 152945, itemTypeTransmog, "Plate" }, { 152948, itemTypeTransmog, "Plate" } }, note = nil },
	{ coord = 56204550, npcId = 122999, questId = 49241, icon = "skull_grey", group = "rare_aw", label = "Gar'zoth", search = { "gar'zoth", "garzoth", "gar zoth" }, loot = nil, note = nil },


	{ coord = 59804030, npcId = 128024, questId = 0, icon = "battle_pet", group = "pet_aw", label = "One-of-Many", loot = nil, note = nil },
	{ coord = 76707390, npcId = 128023, questId = 0, icon = "battle_pet", group = "pet_aw", label = "Minixis", loot = nil, note = nil },
	{ coord = 51604140, npcId = 128019, questId = 0, icon = "battle_pet", group = "pet_aw", label = "Watcher", loot = nil, note = nil },
	{ coord = 56605420, npcId = 128020, questId = 0, icon = "battle_pet", group = "pet_aw", label = "Bloat", loot = nil, note = nil },
	{ coord = 56102870, npcId = 128021, questId = 0, icon = "battle_pet", group = "pet_aw", label = "Earseeker", loot = nil, note = nil },
	{ coord = 64106600, npcId = 128022, questId = 0, icon = "battle_pet", group = "pet_aw", label = "Pilfer", loot = nil, note = nil },

	-- Shoot First, Loot Later
	-- Requires 48201 Reinforce Light's Purchase
	-- and 48202 -> followed by 47473 and/or 48929
	{ coord = 58765894, objId = 277204, questId = 49017, icon = "starChestBlue", group = "sfll_aw", label = "Forgotten Legion Supplies", loot = nil, note = "Rocks block the way. Use Lightforged Warframe Jump to crush the boulders." },
	{ coord = 65973977, objId = 277205, questId = 49018, icon = "starChestYellow", group = "sfll_aw", label = "Ancient Legion War Cache", loot = { { 153308, itemTypeTransmog, "1h Mace" } }, note = "Carefully jump down to reach the little cave. Gilder helps a lot. Remove rocks with Lights's Judgment." },
	{ coord = 52192708, objId = 277206, questId = 49019, icon = "starChestYellow", group = "sfll_aw", label = "Fel-Bound Chest", loot = nil, note = "Start a little south east, at 53.7, 30.9. Jump over the rocks to reach the cave. Rocks block the way into the cave. Remove them with Lights's Judgment." },
	{ coord = 49145940, objId = 277207, questId = 49020, icon = "starChest", group = "sfll_aw", label = "Legion Treasure Hoard", loot = { { 153291, itemTypeTransmog, "Staff" } }, note = "Behind Fel Fall. Just pick it up." },
	{ coord = 75595267, objId = 277208, questId = 49021, icon = "starChestBlank", group = "sfll_aw", label = "Timeworn Fel Chest", loot = nil, note = "Start at All-Seer Xanarian. Run past his building on the left side. Hop down a few rocks to reach the chest surrounded by green ooze." },
	-- no loot on wowhead yet
	{ coord = 57426366, objId = 277346, questId = 49159, icon = "starChestPurple", group = "sfll_aw", label = "Missing Augari Chest", loot = nil, note = "Chest is down by the green ooze. Use Shroud of Arcane Echoes and then open the chest." },

	-- 48382
	{ coord = 67546980, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = "Inside building" },
	{ coord = 67466226, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = nil },
	{ coord = 71326946, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = "Next to Hadrox" },
	{ coord = 58066806, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = nil }, -- Doe
	{ coord = 68026624, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = "Inside legion structure" },
	{ coord = 64506868, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = "Outside" },
	-- 48383
	{ coord = 56903570, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = nil },
	{ coord = 57633179, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = nil },
	{ coord = 52182918, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = nil },
	{ coord = 58174021, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = nil },
	{ coord = 51863409, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = nil },
	{ coord = 55133930, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = nil },
	{ coord = 58413097, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = "Inside building, floor level" },
	{ coord = 53753556, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = nil },
	{ coord = 51703529, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = "High up on the cliffs" },
	-- 48384
	{ coord = 60872900, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = nil },
	{ coord = 61332054, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = "Inside Munculus building" },
	{ coord = 59081942, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = "Inside building" },
	{ coord = 64152305, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = "Inside Houndmaster Kerrax cave" },
	{ coord = 66621709, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = "Inside Imp cave, next to Mother Rosula" },
	{ coord = 63682571, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = "In front of Houndmaster Kerrax cave" },
	{ coord = 61862236, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = "Outside, next to Chief Alchemist Munculus" },
	{ coord = 64132738, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = nil }, -- Doe
	-- 48385
	{ coord = 50605720, questId = 48385, icon = "treasure", group = "treasure_aw", label = "48385", loot = nil, note = nil },
	{ coord = 55544743, questId = 48385, icon = "treasure", group = "treasure_aw", label = "48385", loot = nil, note = nil },
	{ coord = 57135124, questId = 48385, icon = "treasure", group = "treasure_aw", label = "48385", loot = nil, note = nil },
	{ coord = 55915425, questId = 48385, icon = "treasure", group = "treasure_aw", label = "48385", loot = nil, note = nil }, -- Doe
	{ coord = 48195451, questId = 48385, icon = "treasure", group = "treasure_aw", label = "48385", loot = nil, note = nil },
	-- 48387
	{ coord = 69403965, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = nil },
	{ coord = 66643654, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = nil },
	{ coord = 68983342, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = nil },
	{ coord = 65522831, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = "Under the bridge" },
	{ coord = 63613643, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = nil }, -- Doe
	{ coord = 73404669, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = "Jump over the ooze" },
	{ coord = 67954006, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = nil },
	-- 48388
	{ coord = 51502610, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = nil },
	{ coord = 59261743, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = nil },
	{ coord = 55921387, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = nil },
	{ coord = 55841722, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = nil },
	{ coord = 55622042, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = "Near Valsuran, jump up the rocky slope" },
	{ coord = 59661398, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = nil }, -- Doe
	{ coord = 54102803, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = "Near Aivals plattform" },
	-- 48389
	{ coord = 64305040, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = "In Vargas cave" },
	{ coord = 60254351, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = nil },
	{ coord = 65514081, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = nil },
	{ coord = 60304675, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = nil },
	{ coord = 65345192, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = "In cave behind Varga" },
	{ coord = 64114242, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = "Under rocks" },
	{ coord = 58734323, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = "On small piece of land within ooze" },
	-- 48390
	{ coord = 81306860, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = "On ship" },
	{ coord = 80406152, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = nil },
	{ coord = 82566503, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = "On ship" },
	{ coord = 73316858, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = "Top level next to Admiral Rel'var" },
	{ coord = 77127529, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = "Next to Vishax Portal" },
	{ coord = 72527293, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = "Behind Rel'var" },
	{ coord = 77255876, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = "Down the slope" },
	{ coord = 72215680, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = "Inside building" },
	-- 48391
	{ coord = 64135867, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = "In Ven'orn spider cave" },
	{ coord = 67404790, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = nil },
	{ coord = 63615622, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = "In Ven'orn spider cave" },
	{ coord = 65005049, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = "Outside in spider area" },
	{ coord = 63035762, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = "In Ven'orn spider cave" },
	{ coord = 65185507, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = "Upper entrance to spider area" },
	{ coord = 68095075, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = "Inside small cave in spider area" },
	{ coord = 69815522, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = "Outside in spider area" },
	{ coord = 71205441, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = "Outside in spider area" },
	{ coord = 66544668, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = "Exit the spider area north where the green zone is on the ground. Jump up the rocks." },

}

-- Krokuun
nodes["ArgusSurface"] = {
	{ coord = 44390734, npcId = 125824, questId = 48561, icon = "skull_grey", group = "rare_kr", label = "Khazaduum", search = { "khazadum", "khazaduum", "kazadum", "kazaduum" }, loot = { { 153316, itemTypeTransmog, "2h Sword" }, { 152946, itemTypeTransmog, "Plate" }, { 152944, itemTypeTransmog, "Plate" }, { 152949, itemTypeTransmog, "Plate" }, { 152942, itemTypeTransmog, "Plate" }, { 152947, itemTypeTransmog, "Plate" }, { 152943, itemTypeTransmog, "Plate" }, { 152945, itemTypeTransmog, "Plate" }, { 152948, itemTypeTransmog, "Plate" } }, note = "Entrance is south east at 50.3, 17.3" },
	{ coord = 33007600, npcId = 122912, questId = 48562, icon = "skull_grey", group = "rare_kr", label = "Commander Sathrenael", search = { "sathrenael" }, loot = nil, note = nil },
	{ coord = 44505870, npcId = 124775, questId = 48564, icon = "skull_grey", group = "rare_kr", label = "Commander Endaxis", search = { "endaxis" }, loot = { { 153255, itemTypeTransmog, "1h Mace" }, { 152946, itemTypeTransmog, "Plate" }, { 152944, itemTypeTransmog, "Plate" }, { 152949, itemTypeTransmog, "Plate" }, { 152942, itemTypeTransmog, "Plate" }, { 152947, itemTypeTransmog, "Plate" }, { 152943, itemTypeTransmog, "Plate" }, { 152945, itemTypeTransmog, "Plate" }, { 152948, itemTypeTransmog, "Plate" } }, note = nil },
	{ coord = 53403090, npcId = 123464, questId = 48565, icon = "skull_grey", group = "rare_kr", label = "Sister Subversia", search = { "subversia" }, loot = { { 153124, itemTypeToy } }, note = nil },
	{ coord = 58007480, npcId = 120393, questId = 48627, icon = "skull_grey", group = "rare_kr", label = "Siegemaster Voraan", search = { "voran", "voraan" }, loot = nil, note = nil },
	{ coord = 54688126, npcId = 123689, questId = 48628, icon = "skull_grey", group = "rare_kr", label = "Talestra the Vile", search = { "talestra" }, loot = { { 153329, itemTypeTransmog, "Dagger" }, { 152946, itemTypeTransmog, "Plate" }, { 152944, itemTypeTransmog, "Plate" }, { 152949, itemTypeTransmog, "Plate" }, { 152942, itemTypeTransmog, "Plate" }, { 152947, itemTypeTransmog, "Plate" }, { 152943, itemTypeTransmog, "Plate" }, { 152945, itemTypeTransmog, "Plate" }, { 152948, itemTypeTransmog, "Plate" } }, note = nil },
	{ coord = 38145920, npcId = 122911, questId = 48563, icon = "skull_grey", group = "rare_kr", label = "Commander Vecaya", search = { "vecaya" }, loot = { { 153299, itemTypeTransmog, "1h Sword" }, { 152946, itemTypeTransmog, "Plate" }, { 152944, itemTypeTransmog, "Plate" }, { 152949, itemTypeTransmog, "Plate" }, { 152942, itemTypeTransmog, "Plate" }, { 152947, itemTypeTransmog, "Plate" }, { 152943, itemTypeTransmog, "Plate" }, { 152945, itemTypeTransmog, "Plate" }, { 152948, itemTypeTransmog, "Plate" } }, note = "The path up to her starts east at 42, 57.1" },
	{ coord = 60802080, npcId = 125388, questId = 48629, icon = "skull_grey", group = "rare_kr", label = "Vagath the Betrayed", search = { "vagat" }, loot = { { 153114, itemTypeMisc } }, note = nil },
	{ coord = 69605750, npcId = 124804, questId = 48664, icon = "skull_grey", group = "rare_kr", label = "Tereck the Selector", search = { "tereck", "terek" }, loot = { { 153263, itemTypeTransmog, "1h Axe" }, { 152946, itemTypeTransmog, "Plate" }, { 152944, itemTypeTransmog, "Plate" }, { 152949, itemTypeTransmog, "Plate" }, { 152942, itemTypeTransmog, "Plate" }, { 152947, itemTypeTransmog, "Plate" }, { 152943, itemTypeTransmog, "Plate" }, { 152945, itemTypeTransmog, "Plate" }, { 152948, itemTypeTransmog, "Plate" } }, note = nil },
	{ coord = 69708050, npcId = 125479, questId = 48665, icon = "skull_grey", group = "rare_kr", label = "Tar Spitter", search = { "tar.*spitter" }, loot = nil, note = nil },
	{ coord = 41707020, npcId = 125820, questId = 48666, icon = "skull_grey", group = "rare_kr", label = "Imp Mother Laglath", search = { "laglat" }, loot = nil, note = nil },
	{ coord = 71063274, npcId = 126419, questId = 48667, icon = "skull_grey", group = "rare_kr", label = "Naroua", search = { "naroua" }, loot = { { 153190, itemTypeMisc }, { 153054, itemTypePet, 2118 }, { 153055, itemTypePet, 2119 }, { 152841, itemTypeMount, 975 }, { 152843, itemTypeMount, 906 }, { 152842, itemTypeMount, 974 }, { 152840, itemTypeMount, 976 } }, note = nil },

	{ coord = 43005200, npcId = 128009, questId = 0, icon = "battle_pet", group = "pet_kr", label = "Baneglow", loot = nil, note = nil },
	{ coord = 51506380, npcId = 128008, questId = 0, icon = "battle_pet", group = "pet_kr", label = "Foulclaw", loot = nil, note = nil },
	{ coord = 66847263, npcId = 128007, questId = 0, icon = "battle_pet", group = "pet_kr", label = "Ruinhoof", loot = nil, note = nil },
	{ coord = 29605790, npcId = 128011, questId = 0, icon = "battle_pet", group = "pet_kr", label = "Deathscreech", loot = nil, note = nil },
	{ coord = 39606650, npcId = 128012, questId = 0, icon = "battle_pet", group = "pet_kr", label = "Gnasher", loot = nil, note = nil },
	{ coord = 58302970, npcId = 128010, questId = 0, icon = "battle_pet", group = "pet_kr", label = "Retch", loot = nil, note = nil },

	-- Shoot First, Loot Later
	{ coord = 51407622, objId = 276490, questId = 48884, icon = "starChestBlue", group = "sfll_kr", label = "Krokul Emergency Cache", loot = { { 153304, itemTypeTransmog, "1h Axe" } }, note = "Cave is up on the cliffs. Rocks block the way. Use Lightforged Warframe's jump ability to shatter the rocks." },
	{ coord = 62783753, objId = 276489, questId = 48885, icon = "starChestYellow", group = "sfll_kr", label = "Legion Tower Chest", loot = nil, note = "On the path to Naroua there are boulders blocking the way to this chest. Remove them with Light's Judgement." },
	{ coord = 48555894, objId = 276491, questId = 48886, icon = "starChestYellow", group = "sfll_kr", label = "Lost Krokul Chest", loot = nil, note = "In little cave along the path. Use Light's Judgment to remove the boulders." },
	{ coord = 75176975, objId = 277343, questId = 49154, icon = "starChestPurple", group = "sfll_kr", label = "Long-Lost Augari Treasure", loot = nil, note = "Use Shroud of Arcane Echoes and then open the chest." },
	{ coord = 55937428, objId = 277344, questId = 49156, icon = "starChestPurple", group = "sfll_kr", label = "Precious Augari Keepsakes", loot = nil, note = "Use Shroud of Arcane Echoes and then open the chest." },

	-- 47752
	{ coord = 55555863, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = "Jump on the rocks, start slightly west" },
	{ coord = 52185431, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = "Run the path up to the top where you've first seen Alleria" },
	{ coord = 50405122, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = "Run the path up to the top where you've first seen Alleria" },
	{ coord = 53265096, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = "Run the path up to the top where you've first seen Alleria. On the other side of the green ooze. Fel hurts!" },
	{ coord = 57005472, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = "Under the rock outcropping, on the tiny lip of land" }, -- Doe
	{ coord = 59695196, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = "Near to Xeth'tal, behind the rocks." }, -- todo:verify
	{ coord = 51425958, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = nil },
	-- 47753
	{ coord = 53137304, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = nil },
	{ coord = 55228114, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = nil },
	{ coord = 59267341, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = nil },
	{ coord = 56118037, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = "Outside Talestra building" },
	{ coord = 58597958, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = "Behind demon spike" },
	{ coord = 58197157, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = nil }, -- Doe
	{ coord = 52737591, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = "Behind rocks" },
	{ coord = 58048036, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = nil },
	-- 47997
	{ coord = 45876777, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = "Under rock, next to bridge" },
	{ coord = 45797753, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = nil }, -- Doe
	{ coord = 43858139, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = "Path starts at 49.1, 69.3. Follow the ridge southwards till you reach the chest." },
	{ coord = 43816689, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = "Under rocks. Jump down from path near bridge." },
	{ coord = 40687531, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = nil }, -- Doe
	{ coord = 46996831, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = "On top of serpent skull" },
	{ coord = 41438003, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = "Climb up the rocks to the crashed legion ship" },
	{ coord = 41548379, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = nil }, -- Doe
	{ coord = 46458665, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = "Jump over the rocks to reach this chest." },
	{ coord = 40357414, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = nil },
	-- 47999
	{ coord = 62592581, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = nil },
	{ coord = 59763951, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = nil },
	{ coord = 59071884, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = "Up, behind rocks" },
	{ coord = 61643520, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = nil },
	{ coord = 61463580, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = "Inside building" },
	{ coord = 59603052, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = "Bridge level" },
	{ coord = 60891852, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = "Inside hut behind Vagath" },
	{ coord = 49063350, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = nil },
	{ coord = 65992286, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = nil },
	{ coord = 64632319, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = "Inside building" },
	{ coord = 51533583, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = "Outside building, over the litte ooze lake" },
	-- 48000
	{ coord = 70907370, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = nil },
	{ coord = 74136790, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = nil },
	{ coord = 75166435, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = "Back end of cave" },
	{ coord = 69605772, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = nil },
	{ coord = 69787836, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = "Jump up the slope next to it" },
	{ coord = 68566054, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = "In front of Tereck the Selector's cave" },
	{ coord = 72896482, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = nil },
	{ coord = 71827536, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = nil }, -- Doe
	{ coord = 73577146, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = nil }, -- Doe
	{ coord = 71846166, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = "Climb up the tipped pillar" },
	{ coord = 67886231, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = "Behind pillar" },
	{ coord = 74996922, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = nil },
	-- 48336
	{ coord = 33575511, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = "Xenadar upper level, outside" },
	{ coord = 32047441, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = nil },
	{ coord = 27196668, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = nil },
	{ coord = 31936750, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = nil },
	{ coord = 35415637, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = "Ground level, in front of bottom entrance to the Xenedar" },
	{ coord = 29645761, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = "Inside cave" },
	{ coord = 40526067, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = "Inside yellow hut" }, -- Doe
	{ coord = 36205543, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = "Inside the Xenadar, upper level" }, -- Doe
	{ coord = 25996814, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = nil },
	{ coord = 37176401, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = "Under debris" },
	{ coord = 28247134, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = nil },
	{ coord = 30276403, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = "Inside escape pod" },
	-- 48339
	{ coord = 68533891, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = nil },
	{ coord = 63054240, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = nil },
	{ coord = 64964156, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = nil },
	{ coord = 73393438, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = nil },
	{ coord = 72213234, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = "Behind the giant skull" }, -- Doe
	{ coord = 65983499, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = nil },
	{ coord = 64934217, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = "Inside tree trunk" },
	{ coord = 67713454, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = nil },
	{ coord = 72493605, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = nil },

}

nodes["ArgusCitadelSpire"] = {
	{ coord = 38954032, npcId = 125824, questId = 48561, icon = "skull_grey", group = "rare_kr", label = "Khazaduum", search = { "khazadum", "khazaduum", "kazadum", "kazaduum" }, loot = { { 153316, itemTypeTransmog, "2h Sword" }, { 152946, itemTypeTransmog, "Plate" }, { 152944, itemTypeTransmog, "Plate" }, { 152949, itemTypeTransmog, "Plate" }, { 152942, itemTypeTransmog, "Plate" }, { 152947, itemTypeTransmog, "Plate" }, { 152943, itemTypeTransmog, "Plate" }, { 152945, itemTypeTransmog, "Plate" }, { 152948, itemTypeTransmog, "Plate" } }, note = "Entrance is south east at 50.3, 17.3" },
}

-- Mac'Aree
nodes["ArgusMacAree"] = {
	{ coord = 52976684, npcId = 126815, questId = 48693, icon = "skull_grey", group = "rare_ma", label = "Soultwisted Monstrosity", search = { "monstro" }, loot = nil, note = nil },
	{ coord = 55536016, npcId = 126852, questId = 48695, icon = "skull_grey", group = "rare_ma", label = "Wrangler Kravos", search = { "kravos" }, loot = { { 153269, itemTypeTransmog, "1h Axe" }, { 152814, itemTypeMount, 970 } }, note = nil },
	-- { coord = 38705580, npcId = 126860, questId = 48697, icon = "skull_grey", group = "rare_ma", label = "Kaara the Pale", search = { "kaara" }, loot = { { 153190, itemTypeMisc }, { 153054, itemTypePet, 2118 }, { 153055, itemTypePet, 2119 }, { 152841, itemTypeMount, 975 }, { 152843, itemTypeMount, 906 }, { 152842, itemTypeMount, 974 }, { 152840, itemTypeMount, 976 } }, note = nil },
	{ coord = 38705580, npcId = 126860, questId = 48697, icon = "skull_grey", group = "rare_ma", label = "Kaara the Pale", search = { "kaara" }, loot = nil, note = nil },
	{ coord = 41121149, npcId = 126864, questId = 48702, icon = "skull_grey", group = "rare_ma", label = "Feasel the Muffin Thief", search = { "feasel" }, loot = { { 152998, itemTypeMisc } }, note = "Interrupt burrow" },
	{ coord = 36682383, npcId = 126865, questId = 48703, icon = "skull_grey", group = "rare_ma", label = "Vigilant Thanos", search = { "thanos" }, loot = { { 153322, itemTypeTransmog, "Shield" } }, note = nil },
	{ coord = 63806460, npcId = 126866, questId = 48704, icon = "skull_grey", group = "rare_ma", label = "Vigilant Kuro", search = { "kuro" }, loot = { { 153323, itemTypeTransmog, "Shield" }, { 153183, itemTypeToy } }, note = nil },
	{ coord = 33654801, npcId = 126867, questId = 48705, icon = "skull_grey", group = "rare_ma", label = "Venomtail Skyfin", search = { "venomtail", "skyfin" }, loot = { { 152844, itemTypeMount, 973 } }, note = nil },
	{ coord = 38226435, npcId = 126868, questId = 48706, icon = "skull_grey", group = "rare_ma", label = "Turek the Lucid", search = { "turek" }, loot = { { 153306, itemTypeTransmog, "1h Axe" } }, note = "Down the stairs into the building" },
	{ coord = 27192995, npcId = 126869, questId = 48707, icon = "skull_grey", group = "rare_ma", label = "Captain Faruq", search = { "faruq" }, loot = nil, note = nil },
	{ coord = 34943711, npcId = 126885, questId = 48708, icon = "skull_grey", group = "rare_ma", label = "Umbraliss", search = { "umbralis" }, loot = nil, note = nil },
	{ coord = 70294598, npcId = 126889, questId = 48710, icon = "skull_grey", group = "rare_ma", label = "Sorolis the Ill-Fated", search = { "sorolis" }, loot = { { 153292, itemTypeTransmog, "Staff" } }, note = nil },
	{ coord = 35965897, npcId = 126896, questId = 48711, icon = "skull_grey", group = "rare_ma", label = "Herald of Chaos", search = { "herald" }, loot = nil, note = "He's on the 2nd floor." },
	{ coord = 44204980, npcId = 126898, questId = 48712, icon = "skull_grey", group = "rare_ma", label = "Sabuul", search = { "sabuul", "sabul" }, loot = { { 153190, itemTypeMisc }, { 153054, itemTypePet, 2118 }, { 153055, itemTypePet, 2119 }, { 152841, itemTypeMount, 975 }, { 152843, itemTypeMount, 906 }, { 152842, itemTypeMount, 974 }, { 152840, itemTypeMount, 976 } }, note = nil },
	{ coord = 48504090, npcId = 126899, questId = 48713, icon = "skull_grey", group = "rare_ma", label = "Jed'hin Champion Vorusk", search = { "vorusk", "jed'hin", "jedhin" }, loot = { { 153302, itemTypeTransmog, "1h Sword" } }, note = nil },
	{ coord = 58783762, npcId = 124440, questId = 48714, icon = "skull_grey", group = "rare_ma", label = "Overseer Y'Beda", search = { "beda" }, loot = { { 153315, itemTypeTransmog, "2h Sword" } }, note = nil },
	{ coord = 58003090, npcId = 125497, questId = 48716, icon = "skull_grey", group = "rare_ma", label = "Overseer Y'Sorna", search = { "sorna" }, loot = { { 153268, itemTypeTransmog, "1h Axe" } }, note = nil },
	{ coord = 60982982, npcId = 125498, questId = 48717, icon = "skull_grey", group = "rare_ma", label = "Overseer Y'Morna", search = { "morna" }, loot = { { 153257, itemTypeTransmog, "1h Mace" } }, note = nil },
	{ coord = 61575035, npcId = 126900, questId = 48718, icon = "skull_grey", group = "rare_ma", label = "Instructor Tarahna", search = { "tarahna", "tarana" }, loot = { { 153309, itemTypeTransmog, "1h Mace" }, { 153179, itemTypeToy }, { 153180, itemTypeToy }, { 153181, itemTypeToy } }, note = nil },
	{ coord = 66742845, npcId = 126908, questId = 48719, icon = "skull_grey", group = "rare_ma", label = "Zul'tan the Numerous", search = { "zul tan", "zultan", "zul'tan" }, loot = nil, note = "Inside building" },
	{ coord = 56801450, npcId = 126910, questId = 48720, icon = "skull_grey", group = "rare_ma", label = "Commander Xethgar", search = { "xethgar" }, loot = nil, note = nil },
	{ coord = 49870953, npcId = 126912, questId = 48721, icon = "skull_grey", group = "rare_ma", label = "Skreeg the Devourer", search = { "skreeg", "skreg" }, loot = { { 152904, itemTypeMount, 980 } }, note = nil },
	{ coord = 43846065, npcId = 126862, questId = 48700, icon = "skull_grey", group = "rare_ma", label = "Baruut the Bloodthirsty", search = { "baruut", "barut" }, loot = { { 153193, itemTypeToy } }, note = nil },
	{ coord = 30124019, npcId = 126887, questId = 48709, icon = "skull_grey", group = "rare_ma", label = "Ataxon", search = { "ataxon" }, loot = { { 153056, itemTypePet, 2120 } }, note = nil },
	-----------------
	{ coord = 49505280, npcId = 126913, questId = 48935, icon = "skull_grey", group = "rare_ma", label = "Slithon the Last", search = { "slithon" }, loot = { { 153203, itemTypeMisc } }, note = nil },
	{ coord = 44607160, npcId = 122838, questId = 48692, icon = "skull_grey", group = "rare_ma", label = "Shadowcaster Voruun", search = { "voruun", "vorun" }, loot = nil, note = nil },

	{ coord = 60007110, npcId = 128015, questId = 0, icon = "battle_pet", group = "pet_ma", label = "Gloamwing", loot = nil, note = nil },
	{ coord = 67604390, npcId = 128013, questId = 0, icon = "battle_pet", group = "pet_ma", label = "Bucky", loot = nil, note = nil },
	{ coord = 74703620, npcId = 128018, questId = 0, icon = "battle_pet", group = "pet_ma", label = "Mar'cuus", loot = nil, note = nil },
	{ coord = 69705190, npcId = 128014, questId = 0, icon = "battle_pet", group = "pet_ma", label = "Snozz", loot = nil, note = nil },
	{ coord = 31903120, npcId = 128017, questId = 0, icon = "battle_pet", group = "pet_ma", label = "Corrupted Blood of Argus", loot = nil, note = nil },
	{ coord = 36005410, npcId = 128016, questId = 0, icon = "battle_pet", group = "pet_ma", label = "Shadeflicker", loot = nil, note = nil },
	
	-- Shoot First, Loot Later
	{ coord = 42900549, objId = 276223, questId = 48743, icon = "starChestBlue", group = "sfll_ma", label = "Eredar Treasure Cache", loot = nil, note = "In a litte cave. Use Lightforged Warframe's jump to remove the blocking boulders." },
	{ coord = 50583838, objId = 276224, questId = 48744, icon = "starChestYellow", group = "sfll_ma", label = "Chest of Ill-Gotten Gains", loot = nil, note = "Use Light's Judgment to shatter the rocks." },
	{ coord = 61127256, objId = 276225, questId = 48745, icon = "starChestYellow", group = "sfll_ma", label = "Student's Surprising Surplus", loot = nil, note = "Chest is inside a cave. Entrance is at 62.2, 72.2. Use Light's Judgment to shatter the rocks." },
	{ coord = 40275146, objId = 276226, questId = 48747, icon = "starChestBlue", group = "sfll_ma", label = "Void-Tinged Chest", loot = nil, note = "In underground area. Use Lightforged Warframe's jump to remove the blocking boulders." },
	{ coord = 70305974, objId = 276227, questId = 48748, icon = "starChestBlank", group = "sfll_ma", label = "Augari Secret Stash", loot = nil, note = "Go to 68.0, 56.9. From here you can see the stash. Mount up and jump towards the chest. Then immediately use a glider to reach the chest safely." },
	{ coord = 57047684, objId = 276228, questId = 48749, icon = "starChestBlank", group = "sfll_ma", label = "Desperate Eredar's Cache", loot = { { 153267, itemTypeTransmog, "1h Axe" } }, note = "Start at 57.1, 74.3 and jump up around that tower to the back side." },
	{ coord = 27274014, objId = 276229, questId = 48750, icon = "starChestBlank", group = "sfll_ma", label = "Shattered House Chest", loot = nil, note = "Go to 31.2, 44.9, a little south-east from here. Jump into the abyss and use a glider to reach the chest." },
	{ coord = 43345447, objId = 276230, questId = 48751, icon = "starChestBlank", group = "sfll_ma", label = "Doomseeker's Treasure", loot = { { 153313, itemTypeTransmog, "2h Sword" } }, note = "Treasure is underground. East of here is a deep hole where the water from the lake falls down. Jump into the hole and hope you hit it right. It is possible to make the jump just with a mount, but a goblin glider helps a lot to reach the small housing with the chest." },
	{ coord = 70632744, objId = 277327, questId = 49129, icon = "starChestPurple", group = "sfll_ma", label = "Augari-Runed Chest", loot = nil, note = "Chest sits under a tree. Use Shroud of Arcane Echoes and then open the chest." },
	{ coord = 62132247, objId = 277340, questId = 49151, icon = "starChestPurple", group = "sfll_ma", label = "Secret Augari Chest", loot = nil, note = "Inside small hut. Use Shroud of Arcane Echoes and then open the chest." },
	{ coord = 40856975, objId = 277342, questId = 49153, icon = "starChestPurple", group = "sfll_ma", label = "Augari Goods", loot = nil, note = "Chest is inside small house. Use Shroud of Arcane Echoes and then open the chest." },

	-- Ancient Eredar Cache
	-- 48346
	{ coord = 55167766, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = nil },
	{ coord = 59386372, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = "Inside transparent red tent"  },
	{ coord = 57486159, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = "Inside building next to Kravos"  },
	{ coord = 50836729, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = nil },
	-- 48350
	{ coord = 59622088, questId = 48350, icon = "treasure", group = "treasure_ma", label = "48350", loot = nil, note = "Inside building under staircase" },
	{ coord = 60493338, questId = 48350, icon = "treasure", group = "treasure_ma", label = "48350", loot = nil, note = "Inside building" },
	{ coord = 55063508, questId = 48350, icon = "treasure", group = "treasure_ma", label = "48350", loot = nil, note = nil },
	{ coord = 62202636, questId = 48350, icon = "treasure", group = "treasure_ma", label = "48350", loot = nil, note = "On the balcony. Go into the building and up the stairs to the right." },
	-- 48351
	{ coord = 43637134, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = nil },
	{ coord = 34205929, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = "On 2nd floor, where Herald of Chaos resides." },
	{ coord = 43955630, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = "Under tree" },
	{ coord = 46917346, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = "Hidden under tree" },
	{ coord = 36296646, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = nil },
	-- 48357
	{ coord = 49412387, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = nil },
	{ coord = 47672180, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = nil },
	{ coord = 48482115, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = nil },
	{ coord = 57881053, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = nil },
	{ coord = 52871676, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = "Up the stairs" },
	-- 48371
	{ coord = 48604971, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = nil },
	{ coord = 49865494, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = nil },
	{ coord = 47023655, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = "Up the stairs" },
	{ coord = 51094790, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = "Under tree" },
	-- 48362
	{ coord = 66682786, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = "Inside building, next to Zul'tan the Numerous" },
	{ coord = 62134077, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = "Inside building" },
	{ coord = 67254608, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = "Inside building" },
	{ coord = 68355322, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = "Inside building" },
	{ coord = 65966017, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = nil },
	-- Void-Seeped Cache / Treasure Chest
	-- 49264
	{ coord = 38143985, questId = 49264, icon = "treasure", group = "treasure_ma", label = "49264", loot = nil, note = nil },
	{ coord = 37613608, questId = 49264, icon = "treasure", group = "treasure_ma", label = "49264", loot = nil, note = nil },
	-- 48361
	{ coord = 37664221, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = "Behind pillar in cave thingy" },
	{ coord = 25824471, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = nil },
	{ coord = 20674033, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = nil },
	{ coord = 29455043, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = "Under tree" },
	{ coord = 18794171, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = "Outside, behind building" },

}

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

-- get npc name
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
			label = tooltip_label;
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
				tooltip:AddLine( itemLink .. " (Pet " .. n .. "/" .. m .. ")", nil, nil, nil, true)
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
				if ( itemLink ~= "Retrieving data ..." ) then
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

local function HideDBMArrow()
    DBM.Arrow:Hide(true)
end

local function DisableTreasure(button, mapFile, coord)
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

local function AddDBMArrow(button, mapFile, coord)
	local node = GetNodeByCoord( mapFile, coord );
	if ( node and isDBMloaded == true ) then
        local mapId = HandyNotes:GetMapFiletoMapID(mapFile)
        local x, y = HandyNotes:getXY(coord)
        local desc = node["label"];

        if not DBMArrow.Desc:IsShown() then
            DBMArrow.Desc:Show()
        end

        x = x*100
        y = y*100
        DBMArrow.Desc:SetText(desc)
        DBM.Arrow:ShowRunTo(x, y, nil, nil, true)
    end
end

-- check all search results for possible rare groups

local numSearches = 0;
local function resetNPCGroupCounts()
	numSearches = 0;
	for mapId,mapFile in pairs( nodes ) do
		for i,node in ipairs( nodes[mapId] ) do
			if ( node["group"]:find( "rare" ) ) then
				node["lfgGroups"] = {};
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
					if ( node["numLfgGroups"] > 0 ) then
						node["up"] = true;
					end
				end
			end
		end
	end
end

local menuFrame = CreateFrame("Frame", "ExampleMenuFrame", UIParent, "UIDropDownMenuTemplate")

local function genGroupBrowserOption( option )
	local opt = {
		text = option.name .. " - " .. option.numMembers .. " Member (" .. option.age.. "s)",
		func = function()
			local tank, heal, dd = C_LFGList.GetAvailableRoles();
			C_LFGList.ApplyToGroup( option.id, "", tank, heal, dd )	;
		end
	};
	return opt;
end

local function LFGcreate( button, label )
	local c,zone,_,_,name = C_LFGList.GetActiveEntryInfo();
	if c == true and name ~= label then
		if ( UnitIsGroupLeader("player") ) then
			print( "Old group delisted. Click again to search groups for " .. label .. "." );
			C_LFGList.RemoveListing();
		else
			print( "|cFFFF0000Insufficient rights. You are not the group leader." );
		end
	elseif ( c == false ) then
		print( "Created group for " .. label .. "." );
		-- 16 = custom
		C_LFGList.CreateListing(16,label,0,0,"","Created with HandyNotes_Argus",true)
	end
end

local function LFGbrowseMatches( matches, node )
	local menu;
	if ( #matches == 0 ) then
		menu = {
			{ text = "Sorry, no groups found!", isTitle = true, notCheckable = true },
			{ text = "Create new group", func = function() LFGcreate( nil, node["label"] ); end },
		};
	else
		menu = {
			{ text = "Groups found:", isTitle = true, notCheckable = true },
		};
		for k,v in ipairs( matches ) do
			table.insert( menu, genGroupBrowserOption( v ) );
			-- print( v["name"] );
		end
	end
	table.insert( menu, { text = "", isTitle = true, notCheckable = true } );
	table.insert( menu, { text = "Close", notCheckable = true, func = function() CloseDropDownMenus() end } );
	EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU");
end

local finderFrame = CreateFrame("Frame");
finderFrame:SetScript("OnEvent", function( self, event )
	self:UnregisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED");
    local numResults, resultIds = C_LFGList.GetSearchResults()
	numSearches = numSearches + 1;
	local matches = {};

	for _, resultId in ipairs( resultIds ) do

		local id, activityID, name, comment, voiceChat, iLvl, honorLevel, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, leaderName, numMembers, isAutoAccept = C_LFGList.GetSearchResultInfo( resultId );
		updateNPCGroupCount( name, leaderName );

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
	end
end );

local function LFGCheckRares( button, node )
	finderFrame.searchNode = nil;
	finderFrame:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED");
	local languages = C_LFGList.GetLanguageSearchFilter();
	C_LFGList.Search( 6, LFGListSearchPanel_ParseSearchTerms (""), nil, nil, allLanguages );
end

local function LFGsearch( button, node )
	if ( node ~= nil ) then
		local c,zone,_,_,name = C_LFGList.GetActiveEntryInfo();
		if c == true and name ~= label then
			if ( UnitIsGroupLeader("player") ) then
				print( "Old group delisted. Click again to search groups for " .. node["label"] .. "." );
				C_LFGList.RemoveListing();
			else
				print( "|cFFFF0000Insufficient rights. You are not the group leader." );
			end
		elseif ( c == false ) then
			finderFrame:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED");
			finderFrame.searchNode = node;
			local languages = C_LFGList.GetLanguageSearchFilter();
			C_LFGList.Search( 6, LFGListSearchPanel_ParseSearchTerms (""), nil, nil, allLanguages );
		end
	end
end

local function generateGroupBrowser()
	EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU");
end

local function generateMenuBrowseGroups()
	info.isTitle = 1
	info.text = "Argus."
	info.notCheckable = 1
	UIDropDownMenu_AddButton(info, level)
end

local function generateMenu(button, level)
    if ( not level ) then return end
	local node = GetNodeByCoord( clickedMapFile, clickedCoord );
	if ( not node ) then return end

    for k in pairs(info) do info[k] = nil end

    if (level == 1) then
        info.isTitle = 1
        info.text = "Argus"
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)
        
        info.disabled = nil
        info.isTitle = nil
        info.notCheckable = 1
		
		if ( (string.find(node["group"], "rare") ~= nil)) then
			if ( node["search"] ~= nil ) then
				info.text = "Find group"
				info.func = LFGsearch
				info.arg1 = node
				UIDropDownMenu_AddButton(info, level)

			end

			info.text = "Create group finder listing"
			info.func = LFGcreate
			info.arg1 = node["label"]
			UIDropDownMenu_AddButton(info, level)

			info.disabled = 1
			info.notClickable = 1
			info.text = ""
			UIDropDownMenu_AddButton(info, level)
			info.disabled = nil
			info.notClickable = nil

			info.text = "Check group finder"
			info.func = LFGCheckRares
			info.arg1 = node
			UIDropDownMenu_AddButton(info, level)

			info.text = "Reset Rare Group Counters"
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
            info.text = "Add this location to TomTom waypoints"
            info.func = addtoTomTom
            info.arg1 = clickedMapFile
            info.arg2 = clickedCoord
            UIDropDownMenu_AddButton(info, level)
        end

        if isDBMloaded == true and false then
            info.text = "Add this treasure as DBM Arrow"
            info.func = AddDBMArrow
            info.arg1 = clickedMapFile
            info.arg2 = clickedCoord
            UIDropDownMenu_AddButton(info, level)
            
            info.text = "Hide DBM Arrow"
            info.func = HideDBMArrow
            UIDropDownMenu_AddButton(info, level)
        end

        info.text = "Remove this Object from the Map"
        info.func = DisableTreasure
        info.arg1 = clickedMapFile
        info.arg2 = clickedCoord
        UIDropDownMenu_AddButton(info, level)

        info.text = "Restore Removed Objects"
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
			LFGcreate( nil, node["label"] );
		end
	elseif button == "LeftButton" and down then
		-- find group
		LFGsearch( nil, node );
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
    name = "Argus",
    desc = "Stuff on Argus",
    get = function(info) return Argus.db.profile[info.arg] end,
    set = function(info, v) Argus.db.profile[info.arg] = v; Argus:Refresh() end,
    args = {
        IconOptions = {
            type = "group",
            name = "Icon Settings",
            desc = "Icon Settings",
			inline = true,
			order = 0,
            args = {
				groupIconTreasures = {
					type = "header",
					name = "Treasure Chest Icons",
					desc = "Treasure Chest Icons",
					order = 0,
				},
				icon_scale_treasures = {
					type = "range",
					name = "Scale",
					desc = "1 = 100%",
					min = 0.25, max = 10, step = 0.01,
					arg = "icon_scale_treasures",
					order = 1,
				},
				icon_alpha_treasures = {
					type = "range",
					name = "Opacity",
					desc = "0 = transparent, 1 = opaque",
					min = 0, max = 1, step = 0.01,
					arg = "icon_alpha_treasures",
					order = 2,
				},
				groupIconRares = {
					type = "header",
					name = "Rares Icons",
					desc = "Rares Icons",
					order = 10,
				},
				icon_scale_rares = {
					type = "range",
					name = "Scale",
					desc = "1 = 100%",
					min = 0.25, max = 10, step = 0.01,
					arg = "icon_scale_rares",
					order = 11,
				},
				icon_alpha_rares = {
					type = "range",
					name = "Opacity",
					desc = "0 = transparent, 1 = opaque",
					min = 0, max = 1, step = 0.01,
					arg = "icon_alpha_rares",
					order = 12,
				},
				groupIconPets = {
					type = "header",
					name = "Pet Battle Icons",
					desc = "Pet Battle Icons",
					order = 20,
				},
				icon_scale_pets = {
					type = "range",
					name = "Scale",
					desc = "1 = 100%",
					min = 0.25, max = 10, step = 0.01,
					arg = "icon_scale_pets",
					order = 21,
				},
				icon_alpha_pets = {
					type = "range",
					name = "Opacity",
					desc = "0 = transparent, 1 = opaque",
					min = 0, max = 1, step = 0.01,
					arg = "icon_alpha_pets",
					order = 22,
				},
				groupIconSfll = {
					type = "header",
					name = "Shoot First, Loot Later",
					desc = "Shoot First, Loot Later",
					order = 30,
				},
				icon_scale_sfll = {
					type = "range",
					name = "Scale",
					desc = "1 = 100%",
					min = 0.25, max = 10, step = 0.01,
					arg = "icon_scale_sfll",
					order = 31,
				},
				icon_alpha_sfll = {
					type = "range",
					name = "Opacity",
					desc = "0 = transparent, 1 = opaque",
					min = 0, max = 1, step = 0.01,
					arg = "icon_alpha_sfll",
					order = 32,
				},
			},
		},
		VisibilityGroup = {
			type = "group",
			order = 10,
			name = "Toggle Visibility",
			inline = true,
			args = {
				groupAW = {
					type = "header",
					name = "Antoran Wastes",
					desc = "Antoran Wastes ",
					order = 0,
				},
				treasureAW = {
					type = "toggle",
					arg = "treasure_aw",
					name = "Treasures",
					desc = "Treasures that give various items",
					order = 1,
					width = "normal",
				},
				rareAW = {
					type = "toggle",
					arg = "rare_aw",
					name = "Rares",
					desc = "Rare spawns",
					order = 2,
					width = "normal",
				},
				petAW = {
					type = "toggle",
					arg = "pet_aw",
					name = "Battle Pets",
					order = 3,
					width = "normal",
				},
				sfllAW = {
					type = "toggle",
					arg = "sfll_aw",
					name = "Shoot First, Loot Later",
					order = 4,
					width = "normal",
				},
				groupKR = {
					type = "header",
					name = "Krokuun",
					desc = "Krokuun",
					order = 10,
				},  
				treasureKR = {
					type = "toggle",
					arg = "treasure_kr",
					name = "Treasures",
					desc = "Treasures that give various items",
					width = "normal",
					order = 11,
				},
				rareKR = {
					type = "toggle",
					arg = "rare_kr",
					name = "Rares",
					desc = "Rare spawns",
					width = "normal",
					order = 12,
				},
				petKR = {
					type = "toggle",
					arg = "pet_kr",
					name = "Battle Pets",
					width = "normal",
					order = 13,
				},
				sfllKR = {
					type = "toggle",
					arg = "sfll_kr",
					name = "Shoot First, Loot Later",
					order = 14,
					width = "normal",
				},
				groupMA = {
					type = "header",
					name = "Mac'Aree",
					desc = "Mac'Aree",
					order = 20,
				},  
				treasureMA = {
					type = "toggle",
					arg = "treasure_ma",
					name = "Treasures",
					desc = "Treasures that give various items",
					width = "normal",
					order = 21,
				},
				rareMA = {
					type = "toggle",
					arg = "rare_ma",
					name = "Rares",
					desc = "Rare spawns",
					width = "normal",
					order = 22,
				},  
				petMA = {
					type = "toggle",
					arg = "pet_ma",
					name = "Battle Pets",
					width = "normal",
					order = 23,
				},  
				sfllMA = {
					type = "toggle",
					arg = "sfll_ma",
					name = "Shoot First, Loot Later",
					order = 24,
					width = "normal",
				},
				groupGeneral = {
					type = "header",
					name = "General",
					desc = "General",
					order = 30,
				},  
				alwaysshowrares = {
					type = "toggle",
					arg = "alwaysshowrares",
					name = "Already looted Rares",
					desc = "Show every rare regardless of looted status",
					order = 31,
					width = "full",
				},
				alwaysshowtreasures = {
					type = "toggle",
					arg = "alwaysshowtreasures",
					name = "Already looted Treasures",
					desc = "Show every treasure regardless of looted status",
					order = 32,
					width = "full",
				},
				alwaysshowsfll = {
					type = "toggle",
					arg = "alwaysshowsfll",
					name = "Already looted 'Shoot First, Loot Later' Treasures",
					desc = "Show every achievement treasure regardless of looted status",
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
					name = "Show Loot",
					desc = "Add loot information to the tooltip",
					order = 102,
				},
				show_notes = {
					type = "toggle",
					arg = "show_notes",
					name = "Show Notes",
					desc = "Add helpful notes to the tooltip if available",
					order = 103,
				},
			},
		},
    },
}

local updateInvasionPOI = CreateFrame("Frame");
updateInvasionPOI:SetScript("OnEvent", function( self, event, ... )
	local numPOI = GetNumMapLandmarks();
	for i = 1, numPOI do
		local landmarkType, name, description, textureIndex, x, y, maplinkID, showInBattleMap,_,_,poiId,_,something = C_WorldMap.GetMapLandmarkInfo( i );
		if ( poiId == 5360 or poiId == 5367 or poiId == 5369 or poiId == 5374 ) then
			local invasionPOI = _G["WorldMapFramePOI" .. i];
			if ( invasionPOI and not invasionPOI.handyNotesArgus ) then
				invasionPOI.handyNotesArgus = true;
				invasionPOI:RegisterForClicks("LeftButtonDown", "LeftButtonUp");
				invasionPOI:SetScript("OnMouseDown", function(self, button)
					finderFrame:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED");
					local searchNeedle = "";
					if ( self.poiID == 5360 ) then
						finderFrame.searchNode = { label = "Invasion Point: Val", search = { "invasion.*val", "val.*invasion" } };
						searchNeedle = "val";
					elseif ( self.poiID == 5367 ) then
						finderFrame.searchNode = { label = "Invasion Point: Aurinor", search = { "invasion.*aurinor", "aurinor.*invasion" } };
						searchNeedle = "aurinor";
					elseif ( self.poiID == 5369 ) then
						finderFrame.searchNode = { label = "Invasion Point: Sangua", search = { "invasion.*sangua", "sangua.*invasion" } };
						searchNeedle = "sangua";
					elseif ( self.poiID == 5374 ) then
						finderFrame.searchNode = { label = "Invasion Point: Naigtal", search = { "invasion.*naigtal", "naigtal.*invasion" } };
						searchNeedle = "naigtal";
					end
					
					local languages = C_LFGList.GetLanguageSearchFilter();
					C_LFGList.Search( 6, LFGListSearchPanel_ParseSearchTerms ( searchNeedle ), nil, nil, allLanguages );
					
				end );
			end
		end
	end
end );

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
		--print( "Failed: " .. failed .. " / " .. total );
		C_Timer.After(3, function()
			cacheItems();
		end );
	else
		--print( "Got all items" );
	end
end

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
	resetNPCGroupCounts();
	updateInvasionPOI:RegisterEvent("WORLD_MAP_UPDATE");
end

function Argus:WorldEnter()
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
			
			-- find next index
			local nextIndex = nil
			local c,n
			if ( prestate ) then
				for c,n in ipairs(t) do
					if ( n["coord"] == prestate ) then
						nextIndex = c + 1;
					end
				end
			else
				nextIndex = 1;
			end

			for idx = nextIndex, #t do
				--if ( idx == 1 ) then print ( "iter" ) end
				node = t[idx];
                if (node["questId"] and self.db.profile[node["group"]] and not Argus:HasBeenLooted(currentMapFile,node)) then
					-- preload items
					-- local allLootKnown = true
                    if ((node["loot"] ~= nil) and (type(node["loot"]) == "table") and false) then
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
						--getCreatureNamebyID( node["npcId"] );
					end

					local iconScale = 1;
					local iconAlpha = 1;
					local iconPath = iconDefaults[node["icon"]];
					if ( (string.find(node["group"], "rare") ~= nil)) then
						iconScale = Argus.db.profile.icon_scale_rares;
						iconAlpha = Argus.db.profile.icon_alpha_rares;
						if ( not node["allLootKnown"] and node["up"] == true ) then
							iconPath = iconDefaults["skull_purple"];
						elseif ( not node["allLootKnown"] and not node["up"] ) then
							iconPath = iconDefaults["skull_blue"];
						elseif ( node["allLootKnown"] and node["up"] ) then
							iconPath = iconDefaults["skull_yellow"];
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
