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
	[52702950] = { npcId=127291, questId=48822, icon="skull_grey", group="rare_aw", label="Watcher Aival", search="aival", loot=nil, note=nil },
	[63902090] = { npcId=126040, questId=48809, icon="skull_grey", group="rare_aw", label="Puscilla", search="puscilla", loot={ { 152903, itemTypeMount, 981 } }, note="Entrance to the cave is south east - use the eastern bridge to get there." },
	[53103580] = { npcId=126199, questId=48810, icon="skull_grey", group="rare_aw", label="Vrax'thul", search="vrax", loot={ { 152903, itemTypeMount, 981 } }, note=nil },
	[63225754] = { npcId=126115, questId=48811, icon="skull_grey", group="rare_aw", label="Ven'orn", search="ven", loot=nil, note="The entrance to the cave is north east from here in the spider area at 66, 54.1" },
	[64304820] = { npcId=126208, questId=48812, icon="skull_grey", group="rare_aw", label="Varga", search="varga", loot={ { 153190, itemTypeMisc }, { 153054, itemTypePet, 2118 }, { 153055, itemTypePet, 2119 }, { 152841, itemTypeMount, 975 }, { 152843, itemTypeMount, 906 }, { 152842, itemTypeMount, 974 }, { 152840, itemTypeMount, 976 } }, note=nil },
	[62405380] = { npcId=126254, questId=48813, icon="skull_grey", group="rare_aw", label="Lieutenant Xakaar", search="xakaar", loot=nil, note=nil },
	[61906430] = { npcId=126338, questId=48814, icon="skull_grey", group="rare_aw", label="Wrath-Lord Yarez", search="yarez", loot={ { 153126, itemTypeToy } }, note=nil },
	[60674831] = { npcId=126946, questId=48815, icon="skull_grey", group="rare_aw", label="Inquisitor Vethroz", search="vethroz", loot={ { 151543, itemTypeMisc } }, note=nil },
	[80206230] = { npcId=nil, questId=48816, icon="portal", group="rare_aw", label="Portal to Commander Texlaz", loot=nil, note=nil },
	[82006600] = { npcId=127084, questId=48816, icon="skull_grey", group="rare_aw", label="Commander Texlaz", search="texlaz", loot=nil, note="Use the portal at 80.2, 62.3 to get on the ship" },
	[73207080] = { npcId=127090, questId=48817, icon="skull_grey", group="rare_aw", label="Admiral Rel'var", search="rel", loot={ { 153324, itemTypeTransmog, "Shield" } }, note=nil },
	[76155614] = { npcId=127096, questId=48818, icon="skull_grey", group="rare_aw", label="All-Seer Xanarian", search="xana", loot=nil, note=nil },
	[50905530] = { npcId=127118, questId=48820, icon="skull_grey", group="rare_aw", label="Worldsplitter Skuul", search="skuul", loot={ { 153312, itemTypeTransmog, "2h Sword" } }, note="May be flying around in circles. Will be near ground sometimes. Not on every round though." },
	[63812199] = { npcId=127288, questId=48821, icon="skull_grey", group="rare_aw", label="Houndmaster Kerrax", search="kerrax", loot={ { 152790, itemTypeMount, 955 } }, note=nil },
	[55702190] = { npcId=127300, questId=48824, icon="skull_grey", group="rare_aw", label="Void Warden Valsuran", search="valsuran", loot={ { 153319, itemTypeTransmog, "2h Mace" } }, note=nil },
	[61392095] = { npcId=127376, questId=48865, icon="skull_grey", group="rare_aw", label="Chief Alchemist Munculus", search="munculus", loot=nil, note=nil },
	[54003800] = { npcId=127581, questId=48966, icon="skull_grey", group="rare_aw", label="The Many-Faced Devourer", search="face", loot={ { 153195, itemTypePet, 2136 } }, note=nil },
	[77177319] = { npcId=nil, questId=48967, icon="portal", group="rare_aw", label="Portal to Squadron Commander Vishax", loot=nil, note="First find a Smashed Portal Generator from Immortal Netherwalker. Then collect Conductive Sheath, Arc Circuit and Power Cell from Eredar War-Mind and Felsworn Myrmidon. Use the Smashed Portal Generator to unlock the portal to Vishax." },
	[84368118] = { npcId=127700, questId=48967, icon="skull_grey", group="rare_aw", label="Squadron Commander Vishax", search="vishax", loot={ { 153253, itemTypeToy } }, note="Use portal at 77.2, 73.2 to get up on the ship" },
	[58001200] = { npcId=127703, questId=48968, icon="skull_grey", group="rare_aw", label="Doomcaster Suprax", search="suprax", loot={ { 153194, itemTypeToy } }, note="Stand on all 3 runes to summon him." },
	[66981777] = { npcId=127705, questId=48970, icon="skull_grey", group="rare_aw", label="Mother Rosula", search="rosula", loot={ { 152903, itemTypeMount, 981 }, { 153252, itemTypePet, 2135 } }, note="Inside cave. Use the eastern bridge. Collect 100 Imp Meat which drop from the imps inside the cave. Use it and place the Disgusting Feast into the green soup at the marked spot." },
	[64948290] = { npcId=127706, questId=48971, icon="skull_grey", group="rare_aw", label="Rezira the Seer", search="rezira", loot={ { 153293, itemTypeToy } }, note="Use Observer's Locus Resonator to open a portal to him. Orix the All-Seer (60.2, 45.4) sells it for 500 Intact Demon Eyes." },
	[61703720] = { npcId=122958, questId=49183, icon="skull_grey", group="rare_aw", label="Blistermaw", search="blister", loot={ { 152905, itemTypeMount, 979 } }, note=nil },
	[57403290] = { npcId=122947, questId=49240, icon="skull_grey", group="rare_aw", label="Mistress Il'thendra", search="thendra", loot={ { 153327, itemTypeTransmog, "Dagger" } }, note=nil },
	[56204550] = { npcId=122999, questId=49241, icon="skull_grey", group="rare_aw", label="Gar'zoth", search="zoth", loot=nil, note=nil },


	[59804030] = { npcId=128024, questId=0, icon="battle_pet", group="pet_aw", label="One-of-Many", loot=nil, note=nil },
	[76707390] = { npcId=128023, questId=0, icon="battle_pet", group="pet_aw", label="Minixis", loot=nil, note=nil },
	[51604140] = { npcId=128019, questId=0, icon="battle_pet", group="pet_aw", label="Watcher", loot=nil, note=nil },
	[56605420] = { npcId=128020, questId=0, icon="battle_pet", group="pet_aw", label="Bloat", loot=nil, note=nil },
	[56102870] = { npcId=128021, questId=0, icon="battle_pet", group="pet_aw", label="Earseeker", loot=nil, note=nil },
	[64106600] = { npcId=128022, questId=0, icon="battle_pet", group="pet_aw", label="Pilfer", loot=nil, note=nil },

	-- 48382
	[67546980] = { questId=48382, icon="treasure", group="treasure_aw", label="48382", loot=nil, note="Inside building" },
	[67466226] = { questId=48382, icon="treasure", group="treasure_aw", label="48382", loot=nil, note=nil },
	[71326946] = { questId=48382, icon="treasure", group="treasure_aw", label="48382", loot=nil, note="Next to Hadrox" },
	[58066806] = { questId=48382, icon="treasure", group="treasure_aw", label="48382", loot=nil, note=nil }, -- Doe
	[68026624] = { questId=48382, icon="treasure", group="treasure_aw", label="48382", loot=nil, note="Inside legion structure" },
	-- 48383
	[56903570] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note=nil },
	[57633179] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note=nil },
	[52182918] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note=nil },
	[58174021] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note=nil },
	[51863409] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note=nil },
	[55133930] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note=nil },
	[58413097] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note="Inside building, floor level" },
	[53753556] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note=nil },
	[51703529] = { questId=48383, icon="treasure", group="treasure_aw", label="48383", loot=nil, note="High up on the cliffs" },
	-- 48384
	[60872900] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note=nil },
	[61332054] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note="Inside Munculus building" },
	[59081942] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note="Inside building" },
	[64152305] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note="Inside Houndmaster Kerrax cave" },
	[66621709] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note="Inside Imp cave, next to Mother Rosula" },
	[63682571] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note=nil },
	[61862236] = { questId=48384, icon="treasure", group="treasure_aw", label="48384", loot=nil, note="Outside, next to Chief Alchemist Munculus" },
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
	[65522831] = { questId=48387, icon="treasure", group="treasure_aw", label="48387", loot=nil, note="Under the bridge" },
	[63613643] = { questId=48387, icon="treasure", group="treasure_aw", label="48387", loot=nil, note=nil }, -- Doe
	[73404669] = { questId=48387, icon="treasure", group="treasure_aw", label="48387", loot=nil, note="Jump over the ooze" },
	[67954006] = { questId=48387, icon="treasure", group="treasure_aw", label="48387", loot=nil, note=nil },
	-- 48388
	[51502610] = { questId=48388, icon="treasure", group="treasure_aw", label="48388", loot=nil, note=nil },
	[59261743] = { questId=48388, icon="treasure", group="treasure_aw", label="48388", loot=nil, note=nil },
	[55921387] = { questId=48388, icon="treasure", group="treasure_aw", label="48388", loot=nil, note=nil },
	[55841722] = { questId=48388, icon="treasure", group="treasure_aw", label="48388", loot=nil, note=nil },
	[55622042] = { questId=48388, icon="treasure", group="treasure_aw", label="48388", loot=nil, note="Near Valsuran, jump up the rocky slope" },
	[59661398] = { questId=48388, icon="treasure", group="treasure_aw", label="48388", loot=nil, note=nil }, -- Doe
	[54102803] = { questId=48388, icon="treasure", group="treasure_aw", label="48388", loot=nil, note="Near Aivals plattform" },
	-- 48389
	[64305040] = { questId=48389, icon="treasure", group="treasure_aw", label="48389", loot=nil, note="In Vargas cave" },
	[60254351] = { questId=48389, icon="treasure", group="treasure_aw", label="48389", loot=nil, note=nil },
	[65514081] = { questId=48389, icon="treasure", group="treasure_aw", label="48389", loot=nil, note=nil },
	[60304675] = { questId=48389, icon="treasure", group="treasure_aw", label="48389", loot=nil, note=nil },
	[65345192] = { questId=48389, icon="treasure", group="treasure_aw", label="48389", loot=nil, note="In cave behind Varga" },
	[64114242] = { questId=48389, icon="treasure", group="treasure_aw", label="48389", loot=nil, note="Under rocks" },
	-- 48390
	[81306860] = { questId=48390, icon="treasure", group="treasure_aw", label="48390", loot=nil, note="On ship" },
	[80406152] = { questId=48390, icon="treasure", group="treasure_aw", label="48390", loot=nil, note=nil },
	[82566503] = { questId=48390, icon="treasure", group="treasure_aw", label="48390", loot=nil, note="On ship" },
	[73316858] = { questId=48390, icon="treasure", group="treasure_aw", label="48390", loot=nil, note="Top level next to Admiral Rel'var" },
	[77127529] = { questId=48390, icon="treasure", group="treasure_aw", label="48390", loot=nil, note="Next to Vishax Portal" },
	[72527293] = { questId=48390, icon="treasure", group="treasure_aw", label="48390", loot=nil, note="Behind Rel'var" },
	[77255876] = { questId=48390, icon="treasure", group="treasure_aw", label="48390", loot=nil, note="Down the slope" },
	-- 48391
	[64135867] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="In Ven'orn spider cave" },
	[67404790] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note=nil },
	[63615622] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="In Ven'orn spider cave" },
	[65005049] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="Outside in spider area" },
	[63035762] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="In Ven'orn spider cave" },
	[65185507] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="Upper entrance to spider area" },
	[68095075] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="Inside small cave in spider area" },
	[69815522] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="Outside in spider area" },
	[71205441] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="Outside in spider area" },
	[66544668] = { questId=48391, icon="treasure", group="treasure_aw", label="48391", loot=nil, note="Exit the spider area north where the green zone is on the ground. Jump up the rocks." },

	-- Shoot First, Loot Later
	-- Requires 48201 Reinforce Light's Purchase
	[58765894] = { objId=277204, questId=49017, icon="starChestBlue", group="sfll_aw", label="Forgotten Legion Supplies", loot=nil, note="Rocks block the way. Use Lightforged Warframe Jump to crush the boulders." },
	[65973977] = { objId=277205, questId=49018, icon="starChestYellow", group="sfll_aw", label="Ancient Legion War Cache", loot={ { 153308, itemTypeTransmog, "1h Mace" } }, note="Carefully jump down to reach the little cave. Gilder helps a lot. Remove rocks with Lights's Judgment." },
	[52192708] = { objId=277206, questId=49019, icon="starChestYellow", group="sfll_aw", label="Fel-Bound Chest", loot=nil, note="Start a little south east, at 53.7, 30.9. Jump over the rocks to reach the cave. Rocks block the way into the cave. Remove them with Lights's Judgment." },
	[64060610] = { objId=277207, questId=49020, icon="starChestBlue", group="sfll_aw", label="Legion Treasure Hoard", loot=nil, note="Use Jump suit. More info follows. Check YouTube frchqNRVR00 for more info." },
	[75595267] = { objId=277208, questId=49021, icon="starChestBlank", group="sfll_aw", label="Timeworn Fel Chest", loot=nil, note="Start at All-Seer Xanarian. Run past his building on the left side. Hop down a few rocks to reach the chest surrounded by green ooze." },
	[57426366] = { objId=277346, questId=49159, icon="starChestPurple", group="sfll_aw", label="Missing Augari Chest", loot=nil, note="Chest is down by the green ooze. Use Shroud of Arcane Echoes and then open the chest." },

}

-- Krokuun
nodes["ArgusSurface"] = {
	[44390734] = { npcId=125824, questId=48561, icon="skull_grey", group="rare_kr", label="Khazaduum", search="khaz", loot={ { 153316, itemTypeTransmog, "2h Sword" } }, note="Entrance is south east at 50.3, 17.3" },
	[33007600] = { npcId=122912, questId=48562, icon="skull_grey", group="rare_kr", label="Commander Sathrenael", search="sathr", loot=nil, note=nil },
	[44505870] = { npcId=124775, questId=48564, icon="skull_grey", group="rare_kr", label="Commander Endaxis", search="endax", loot={ { 153255, itemTypeTransmog, "1h Mace" } }, note=nil },
	[53403090] = { npcId=123464, questId=48565, icon="skull_grey", group="rare_kr", label="Sister Subversia", search="subv", loot={ { 153124, itemTypeToy } }, note=nil },
	[58007480] = { npcId=120393, questId=48627, icon="skull_grey", group="rare_kr", label="Siegemaster Voraan", search="vora", loot=nil, note=nil },
	[54688126] = { npcId=123689, questId=48628, icon="skull_grey", group="rare_kr", label="Talestra the Vile", search="talestra", loot={ { 153329, itemTypeTransmog, "Dagger" } }, note=nil },
	[38145920] = { npcId=122911, questId=48563, icon="skull_grey", group="rare_kr", label="Commander Vecaya", search="vecaya", loot={ { 153299, itemTypeTransmog, "1h Sword" } }, note="The path up to her starts east at 42, 57.1" },
	[60802080] = { npcId=125388, questId=48629, icon="skull_grey", group="rare_kr", label="Vagath the Betrayed", search="vagat", loot=nil, note=nil },
	[69605750] = { npcId=124804, questId=48664, icon="skull_grey", group="rare_kr", label="Tereck the Selector", search="tere", loot={ { 153263, itemTypeTransmog, "1h Axe" } }, note=nil },
	[69708050] = { npcId=125479, questId=48665, icon="skull_grey", group="rare_kr", label="Tar Spitter", search="tar", loot=nil, note=nil },
	[41707020] = { npcId=125820, questId=48666, icon="skull_grey", group="rare_kr", label="Imp Mother Laglath", search="lagla", loot=nil, note=nil },
	[70503370] = { npcId=126419, questId=48667, icon="skull_grey", group="rare_kr", label="Naroua", search="naroua", loot={ { 153190, itemTypeMisc }, { 153054, itemTypePet, 2118 }, { 153055, itemTypePet, 2119 }, { 152841, itemTypeMount, 975 }, { 152843, itemTypeMount, 906 }, { 152842, itemTypeMount, 974 }, { 152840, itemTypeMount, 976 } }, note=nil },

	[43005200] = { npcId=128009, questId=0, icon="battle_pet", group="pet_kr", label="Baneglow", loot=nil, note=nil },
	[51506380] = { npcId=128008, questId=0, icon="battle_pet", group="pet_kr", label="Foulclaw", loot=nil, note=nil },
	[66847263] = { npcId=128007, questId=0, icon="battle_pet", group="pet_kr", label="Ruinhoof", loot=nil, note=nil },
	[29605790] = { npcId=128011, questId=0, icon="battle_pet", group="pet_kr", label="Deathscreech", loot=nil, note=nil },
	[39606650] = { npcId=128012, questId=0, icon="battle_pet", group="pet_kr", label="Gnasher", loot=nil, note=nil },
	[58302970] = { npcId=128010, questId=0, icon="battle_pet", group="pet_kr", label="Retch", loot=nil, note=nil },

	-- 47752
	[55555863] = { questId=47752, icon="treasure", group="treasure_kr", label="47752", loot=nil, note="Jump on the rocks, start slightly west" },
	[52185431] = { questId=47752, icon="treasure", group="treasure_kr", label="47752", loot=nil, note="Run the path up to the top where you've first seen Alleria" },
	[50405122] = { questId=47752, icon="treasure", group="treasure_kr", label="47752", loot=nil, note="Run the path up to the top where you've first seen Alleria" },
	[53265096] = { questId=47752, icon="treasure", group="treasure_kr", label="47752", loot=nil, note="Run the path up to the top where you've first seen Alleria. On the other side of the green ooze. Fel hurts!" },
	[57005472] = { questId=47752, icon="treasure", group="treasure_kr", label="47752", loot=nil, note="Under the rock outcropping, on the tiny lip of land" }, -- Doe
	[59695196] = { questId=47752, icon="treasure", group="treasure_kr", label="47752", loot=nil, note="Near to Xeth'tal, behind the rocks." }, -- todo:verify
	[51425958] = { questId=47752, icon="treasure", group="treasure_kr", label="47752", loot=nil, note=nil },
	-- 47753
	[53137304] = { questId=47753, icon="treasure", group="treasure_kr", label="47753", loot=nil, note=nil },
	[55228114] = { questId=47753, icon="treasure", group="treasure_kr", label="47753", loot=nil, note=nil },
	[59267341] = { questId=47753, icon="treasure", group="treasure_kr", label="47753", loot=nil, note=nil },
	[56118037] = { questId=47753, icon="treasure", group="treasure_kr", label="47753", loot=nil, note="Outside Talestra building" },
	[58597958] = { questId=47753, icon="treasure", group="treasure_kr", label="47753", loot=nil, note="Behind demon spike" },
	[58197157] = { questId=47753, icon="treasure", group="treasure_kr", label="47753", loot=nil, note=nil }, -- Doe
	[52737591] = { questId=47753, icon="treasure", group="treasure_kr", label="47753", loot=nil, note="Behind rocks" },
	[58048036] = { questId=47753, icon="treasure", group="treasure_kr", label="47753", loot=nil, note=nil },
	-- 47997
	[45876777] = { questId=47997, icon="treasure", group="treasure_kr", label="47997", loot=nil, note="Under rock, next to bridge" },
	[45797753] = { questId=47997, icon="treasure", group="treasure_kr", label="47997", loot=nil, note=nil }, -- Doe
	[43858139] = { questId=47997, icon="treasure", group="treasure_kr", label="47997", loot=nil, note="Path starts at 49.1, 69.3. Follow the ridge southwards till you reach the chest." },
	[43816689] = { questId=47997, icon="treasure", group="treasure_kr", label="47997", loot=nil, note="Under rocks. Jump down from path near bridge." },
	[40687531] = { questId=47997, icon="treasure", group="treasure_kr", label="47997", loot=nil, note=nil }, -- Doe
	[46996831] = { questId=47997, icon="treasure", group="treasure_kr", label="47997", loot=nil, note="On top of serpent skull" },
	[41438003] = { questId=47997, icon="treasure", group="treasure_kr", label="47997", loot=nil, note="Climb up the rocks to the crashed legion ship" },
	[41548379] = { questId=47997, icon="treasure", group="treasure_kr", label="47997", loot=nil, note=nil }, -- Doe
	-- 47999
	[62592581] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note=nil },
	[59763951] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note=nil },
	[59071884] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note="Up, behind rocks" },
	[61643520] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note=nil },
	[61463580] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note="Inside building" },
	[59603052] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note="Bridge level" },
	[60891852] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note="Inside hut behind Vagath" },
	[49063350] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note=nil },
	[65992286] = { questId=47999, icon="treasure", group="treasure_kr", label="47999", loot=nil, note=nil },
	-- 48000
	[70907370] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note=nil },
	[74136790] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note=nil },
	[75166435] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note="Back end of cave" },
	[69605772] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note=nil },
	[69787836] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note="Jump up the slope next to it" },
	[68566054] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note="In front of Tereck the Selector's cave" },
	[72896482] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note=nil },
	[71827536] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note=nil }, -- Doe
	[73577146] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note=nil }, -- Doe
	[71846166] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note="Climb up the tipped pillar" },
	[67886231] = { questId=48000, icon="treasure", group="treasure_kr", label="48000", loot=nil, note="Behind pillar" },
	-- 48336
	[33515510] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note=nil },
	[32047441] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note=nil },
	[27196668] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note=nil },
	[31936750] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note=nil },
	[35415637] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note="Ground level, in front of bottom entrance to the Xenedar" },
	[29645761] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note="Inside cave" },
	[40526067] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note="Inside yellow hut" }, -- Doe
	[36205543] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note="Inside the Xenadar, upper level" }, -- Doe
	[25996814] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note=nil },
	[37176401] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note="Under debris" },
	[28247134] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note=nil },
	[30276403] = { questId=48336, icon="treasure", group="treasure_kr", label="48336", loot=nil, note="Inside escape pod" },
	-- 48339
	[68533891] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note=nil },
	[63054240] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note=nil },
	[64964156] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note=nil },
	[73393438] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note=nil },
	[72213234] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note="Behind the giant skull" }, -- Doe
	[65983499] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note=nil },
	[64934217] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note="Inside tree trunk" },
	[67713454] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note=nil },
	[72493605] = { questId=48339, icon="treasure", group="treasure_kr", label="48339", loot=nil, note=nil },

	-- Shoot First, Loot Later
	[51407622] = { objId=276490, questId=48884, icon="starChestBlue", group="sfll_kr", label="Krokul Emergency Cache", loot={ { 153304, itemTypeTransmog, "1h Axe" } }, note="Cave is up on the cliffs. Rocks block the way. Use Lightforged Warframe's jump ability to shatter the rocks." },
	[62783753] = { objId=276489, questId=48885, icon="starChestYellow", group="sfll_kr", label="Legion Tower Chest", loot=nil, note="On the path to Naroua there are boulders blocking the way to this chest. Remove them with Light's Judgement." },
	[48555894] = { objId=276491, questId=48886, icon="starChestYellow", group="sfll_kr", label="Lost Krokul Chest", loot=nil, note="In little cave along the path. Use Light's Judgment to remove the boulders." },
	[75176975] = { objId=277343, questId=49154, icon="starChestPurple", group="sfll_kr", label="Long-Lost Augari Treasure", loot=nil, note="Use Shroud of Arcane Echoes and then open the chest." },
	[55937428] = { objId=277344, questId=49156, icon="starChestPurple", group="sfll_kr", label="Precious Augari Keepsakes", loot=nil, note="Use Shroud of Arcane Echoes and then open the chest." },
}

nodes["ArgusCitadelSpire"] = {
	[38954032] = { npcId=125824, questId=48561, icon="skull_grey", group="rare_kr", label="Khazaduum", loot={ { 153316, itemTypeTransmog, "2h Sword" } }, note=nil },
}

-- Mac'Aree
nodes["ArgusMacAree"] = {
	[52976684] = { npcId=126815, questId=48693, icon="skull_grey", group="rare_ma", label="Soultwisted Monstrosity", search="monstro", loot=nil, note=nil },
	[55536016] = { npcId=126852, questId=48695, icon="skull_grey", group="rare_ma", label="Wrangler Kravos", search="kravos", loot=nil, note=nil },
	[38705580] = { npcId=126860, questId=48697, icon="skull_grey", group="rare_ma", label="Kaara the Pale", search="kaara", loot={ { 153190, itemTypeMisc }, { 153054, itemTypePet, 2118 }, { 153055, itemTypePet, 2119 }, { 152841, itemTypeMount, 975 }, { 152843, itemTypeMount, 906 }, { 152842, itemTypeMount, 974 }, { 152840, itemTypeMount, 976 } }, note=nil },
	[41121149] = { npcId=126864, questId=48702, icon="skull_grey", group="rare_ma", label="Feasel the Muffin Thief", search="feasel", loot=nil, note="Interrupt burrow" },
	[63806460] = { npcId=126866, questId=48704, icon="skull_grey", group="rare_ma", label="Vigilant Kuro", search="kuro", loot=nil, note=nil },
	[33654801] = { npcId=126867, questId=48705, icon="skull_grey", group="rare_ma", label="Venomtail Skyfin", search="venom", loot=nil, note=nil },
	[38226435] = { npcId=126868, questId=48706, icon="skull_grey", group="rare_ma", label="Turek the Lucid", search="turek", loot={ { 153306, itemTypeTransmog, "1h Axe" } }, note="Down the stairs into the building" },
	[27192995] = { npcId=126869, questId=48707, icon="skull_grey", group="rare_ma", label="Captain Faruq", search="faruq", loot=nil, note=nil },
	[35965897] = { npcId=126896, questId=48711, icon="skull_grey", group="rare_ma", label="Herald of Chaos", search="herald", loot=nil, note="He's on the 2nd floor." },
	[44204980] = { npcId=126898, questId=48712, icon="skull_grey", group="rare_ma", label="Sabuul", search="sabu", loot={ { 153190, itemTypeMisc }, { 153054, itemTypePet, 2118 }, { 153055, itemTypePet, 2119 }, { 152841, itemTypeMount, 975 }, { 152843, itemTypeMount, 906 }, { 152842, itemTypeMount, 974 }, { 152840, itemTypeMount, 976 } }, note=nil },
	[48504090] = { npcId=126899, questId=48713, icon="skull_grey", group="rare_ma", label="Jed'hin Champion Vorusk", search="vorusk", loot={ { 153302, itemTypeTransmog, "1h Sword" } }, note=nil },
	[58783762] = { npcId=124440, questId=48714, icon="skull_grey", group="rare_ma", label="Overseer Y'Beda", search="beda", loot=nil, note=nil },
	[58003090] = { npcId=125497, questId=48716, icon="skull_grey", group="rare_ma", label="Overseer Y'Sorna", search="sorna", loot=nil, note=nil },
	[60982982] = { npcId=125498, questId=48717, icon="skull_grey", group="rare_ma", label="Overseer Y'Morna", search="morna", loot={ { 153257, itemTypeTransmog, "1h Mace" } }, note=nil },
	[66742845] = { npcId=126908, questId=48719, icon="skull_grey", group="rare_ma", label="Zul'tan the Numerous", search="zul", loot=nil, note="Inside building" },
	[56801450] = { npcId=126910, questId=48720, icon="skull_grey", group="rare_ma", label="Commander Xethgar", search="xethgar", loot=nil, note=nil },
	[49870953] = { npcId=126912, questId=48721, icon="skull_grey", group="rare_ma", label="Skreeg the Devourer", search="skre", loot=nil, note=nil },
	[43846065] = { npcId=126862, questId=48700, icon="skull_grey", group="rare_ma", label="Baruut the Bloodthirsty", search="baru", loot={ { 153193, itemTypeToy } }, note=nil },
	[30124019] = { npcId=126887, questId=48709, icon="skull_grey", group="rare_ma", label="Ataxon", search="ataxon", loot=nil, note=nil },
	-----------------
	[36302360] = { npcId=126865, questId=48703, icon="skull_grey", group="rare_ma", label="Vigilant Thanos", search="thanos", loot=nil, note=nil },
	[61405020] = { npcId=126900, questId=48718, icon="skull_grey", group="rare_ma", label="Instructor Tarahna", search="tarahna", loot=nil, note=nil },
	[49505280] = { npcId=126913, questId=48936, icon="skull_grey", group="rare_ma", label="Slithon the Last", search="slithon", loot=nil, note=nil },
	[44607160] = { npcId=122838, questId=48692, icon="skull_grey", group="rare_ma", label="Shadowcaster Voruun", search="voruun", loot=nil, note=nil },
	[35203720] = { npcId=126885, questId=48708, icon="skull_grey", group="rare_ma", label="Umbraliss", search="umbra", loot=nil, note=nil },
	[70404670] = { npcId=126889, questId=48710, icon="skull_grey", group="rare_ma", label="Sorolis the Ill-Fated", search="sorolis", loot=nil, note=nil },

	[60007110] = { npcId=128015, questId=0, icon="battle_pet", group="pet_ma", label="Gloamwing", loot=nil, note=nil },
	[67604390] = { npcId=128013, questId=0, icon="battle_pet", group="pet_ma", label="Bucky", loot=nil, note=nil },
	[74703620] = { npcId=128018, questId=0, icon="battle_pet", group="pet_ma", label="Mar'cuus", loot=nil, note=nil },
	[69705190] = { npcId=128014, questId=0, icon="battle_pet", group="pet_ma", label="Snozz", loot=nil, note=nil },
	[31903120] = { npcId=128017, questId=0, icon="battle_pet", group="pet_ma", label="Corrupted Blood of Argus", loot=nil, note=nil },
	[36005410] = { npcId=128016, questId=0, icon="battle_pet", group="pet_ma", label="Shadeflicker", loot=nil, note=nil },
	
	-- Ancient Eredar Cache
	-- 48346
	[55167766] = { questId=48346, icon="treasure", group="treasure_ma", label="48346", loot=nil, note=nil },
	-- 48350
	[59622088] = { questId=48350, icon="treasure", group="treasure_ma", label="48350", loot=nil, note="Inside building under staircase" },
	[60493338] = { questId=48350, icon="treasure", group="treasure_ma", label="48350", loot=nil, note="Inside building" },
	-- 48351
	[43637134] = { questId=48351, icon="treasure", group="treasure_ma", label="48351", loot=nil, note=nil },
	[34205929] = { questId=48351, icon="treasure", group="treasure_ma", label="48351", loot=nil, note="On 2nd floor, where Herald of Chaos resides." },
	-- 48357
	[49372397] = { questId=48357, icon="treasure", group="treasure_ma", label="48357", loot=nil, note=nil },
	[48482115] = { questId=48357, icon="treasure", group="treasure_ma", label="48357", loot=nil, note=nil },
	-- 48371
	[48604971] = { questId=48371, icon="treasure", group="treasure_ma", label="48371", loot=nil, note=nil },
	-- 48362
	[66682786] = { questId=48362, icon="treasure", group="treasure_ma", label="48362", loot=nil, note="Inside building, next to Zul'tan the Numerous" },
	[62134077] = { questId=48362, icon="treasure", group="treasure_ma", label="48362", loot=nil, note="Inside building" },
	-- Void-Seeped Cache / Treasure Chest
	-- 49264
	[38143985] = { questId=49264, icon="treasure", group="treasure_ma", label="49264", loot=nil, note=nil },
	[37613608] = { questId=49264, icon="treasure", group="treasure_ma", label="49264", loot=nil, note=nil },
	-- 48361
	[37664221] = { questId=48361, icon="treasure", group="treasure_ma", label="48361", loot=nil, note="Behind pillar in cave thingy" },
	[25824471] = { questId=48361, icon="treasure", group="treasure_ma", label="48361", loot=nil, note="" },

	-- Shoot First, Loot Later
	[42900549] = { objId=276223, questId=48743, icon="starChestBlue", group="sfll_ma", label="Eredar Treasure Cache", loot=nil, note="In a litte cave. Use Lightforged Warframe's jump to remove the blocking boulders." },
	[50583838] = { objId=276224, questId=48744, icon="starChestYellow", group="sfll_ma", label="Chest of Ill-Gotten Gains", loot=nil, note="Use Light's Judgment to shatter the rocks." },
	[61127256] = { objId=276225, questId=48745, icon="starChestYellow", group="sfll_ma", label="Student's Surprising Surplus", loot=nil, note="Chest is inside a cave. Entrance is at 62.2, 72.2. Use Light's Judgment to shatter the rocks." },
	[40275146] = { objId=276226, questId=48747, icon="starChestBlue", group="sfll_ma", label="Void-Tinged Chest", loot=nil, note="In underground area. Use Lightforged Warframe's jump to remove the blocking boulders." },
	[70305974] = { objId=276227, questId=48748, icon="starChestBlank", group="sfll_ma", label="Augari Secret Stash", loot=nil, note="Go to 68.0, 56.9. From here you can see the stash. Mount up and jump towards the chest. Then immediately use a glider to reach the chest safely." },
	[57047684] = { objId=276228, questId=48749, icon="starChestBlank", group="sfll_ma", label="Desperate Eredar's Cache", loot={ { 153267, itemTypeTransmog, "1h Axe" } }, note="Start at 57.1, 74.3 and jump up around that tower to the back side." },
	[27274014] = { objId=276229, questId=48750, icon="starChestBlank", group="sfll_ma", label="Shattered House Chest", loot=nil, note="Go to 31.2, 44.9, a little south-east from here. Jump into the abyss and use a glider to reach the chest." },
	[43345447] = { objId=276230, questId=48751, icon="starChestBlank", group="sfll_ma", label="Doomseeker's Treasure", loot={ { 153313, itemTypeTransmog, "2h Sword" } }, note="Treasure is underground. East of here is a deep hole where the water from the lake falls down. Jump into the hole and hope you hit it right. It is possible to make the jump just with a mount, but a goblin glider helps a lot to reach the small housing with the chest." },
	[70632744] = { objId=277327, questId=49129, icon="starChestPurple", group="sfll_ma", label="Augari-Runed Chest", loot=nil, note="Chest sits under a tree. Use Shroud of Arcane Echoes and then open the chest." },
	[62132247] = { objId=277340, questId=49151, icon="starChestPurple", group="sfll_ma", label="Secret Augari Chest", loot=nil, note="Inside small hut. Use Shroud of Arcane Echoes and then open the chest." },
	[40856975] = { objId=277342, questId=49153, icon="starChestPurple", group="sfll_ma", label="Augari Goods", loot=nil, note="Chest is inside small house. Use Shroud of Arcane Echoes and then open the chest." },
}


local function GetItem(ID)
    if (ID == "1220" or ID == "1508") then
        local currency, _, _ = GetCurrencyInfo(ID)

        if (currency ~= nil) then
            return currency
        else
            return "Error loading CurrencyID"
        end
    else
        local _, item, _, _, _, _, _, _, _, _ = GetItemInfo(ID)

        if (item ~= nil) then
            return item
        else
            return "Error loading ItemID"
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
				tooltip:AddLine( GetItem(loot[ii][1]) .. " (Pet " .. n .. "/" .. m .. ")", nil, nil, nil, true)
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
				print( "Old group delisted. Click again to search groups for " .. label .. "." );
				C_LFGList.RemoveListing();
			else
				print( "Insufficient rights. You are not the group leader." );
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
			print( "Old group delisted. Click again to search groups for " .. label .. "." );
			C_LFGList.RemoveListing();
		else
			print( "Insufficient rights. You are not the group leader." );
		end
	elseif ( c == false ) then
		print( "Created group for " .. label .. "." );
		-- 16 = custom
		C_LFGList.CreateListing(16,label,0,0,"","Created with HandyNotes_Argus",true)
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
			info.text = "Find group"
			if ( nodes[clickedMapFile][clickedCoord]["search"] ~= nil ) then
				info.func = LRTLFRsearch
				info.arg1 = nodes[clickedMapFile][clickedCoord]["search"]
				info.arg2 = nodes[clickedMapFile][clickedCoord]["label"]
				UIDropDownMenu_AddButton(info, level)
			end

			info.text = "Create group finder listing"
			info.func = LRTLFRcreate
			info.arg1 = nodes[clickedMapFile][clickedCoord]["label"]
			UIDropDownMenu_AddButton(info, level)
		end

        info.text = "Remove this Object from the Map"
        info.func = LRTDisableTreasure
        info.arg1 = clickedMapFile
        info.arg2 = clickedCoord
        UIDropDownMenu_AddButton(info, level)
        
        if isTomTomloaded == true and false then
            info.text = "Add this location to TomTom waypoints"
            info.func = LRTaddtoTomTom
            info.arg1 = clickedMapFile
            info.arg2 = clickedCoord
            UIDropDownMenu_AddButton(info, level)
        end

        if isDBMloaded == true and false then
            info.text = "Add this treasure as DBM Arrow"
            info.func = LRTAddDBMArrow
            info.arg1 = clickedMapFile
            info.arg2 = clickedCoord
            UIDropDownMenu_AddButton(info, level)
            
            info.text = "Hide DBM Arrow"
            info.func = LRTHideDBMArrow
            UIDropDownMenu_AddButton(info, level)
        end

        info.text = CLOSE
        info.func = function() CloseDropDownMenus() end
        info.arg1 = nil
        info.arg2 = nil
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)

        info.text = "Restore Removed Objects"
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
					name = "Transparency",
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
					name = "Transparency",
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
					name = "Transparency",
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
					name = "Transparency",
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
