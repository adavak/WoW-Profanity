-- Rare Share Mechagon module v0.6.1 based on v0.6.1 core module

local AddonName, Addon = ... 

RareShare:LoadModule({
    ID           = 1462,
    Title        = Addon.Loc.Title--[[ "Mechagon" ]],
    Colour       = "|cffffd700",
    Events       = {
        CHAT_MSG_MONSTER_EMOTE = function(self, text, ...)
            if (RareShareDB_Mechagon["Config"]["Drills"]) then
                local Module = RareShare:GetModule(1462)
                local Msg = Addon.Loc.Drills.Prefix .. " "--[[ "Drill active at " ]]
                local x, y;
                local Rare;
                local drill;
                for word in string.gmatch(text, "%S+") do
                    drill = word;
                    if (word == Addon.Loc.Drills[1]--[[ "DR-TR28" ]]) then
                        x, y = 56.25, 36.25;
                        Rare = Module.Rares[153206][1];
                        break;
                    elseif (word == Addon.Loc.Drills[2]--[[ "DR-TR35" ]]) then
                        x, y = 63, 25.75
                        Rare = Module.Rares[150342][1]
                        break;
                    elseif (word == Addon.Loc.Drills[3]--[[ "DR-CC61" ]]) then
                        x, y = 72.71, 53.93;
                        Rare = Module.Rares[154701][1];
                        break;
                    elseif (word == Addon.Loc.Drills[4]--[[ "DR-CC73" ]]) then
                        x, y = 66.50, 58.85;
                        Rare = Module.Rares[154739][1];
                        break;
                    elseif (word == Addon.Loc.Drills[5]--[[ "DR-CC88" ]]) then
                        x, y = 68.40, 48;
                        Rare = Module.Rares[152113][1];
                        break;
                    elseif (word == Addon.Loc.Drills[6]--[[ "DR-JD41" ]]) then
                        x, y = 51.25, 50.20;
                        Rare = Module.Rares[153200][1];
                        break;
                    elseif (word == Addon.Loc.Drills[7]--[[ "DR-JD99" ]]) then
                        x, y = 59.75, 67.25;
                        Rare = Module.Rares[153205][1];
                        break;
                    end
                end
                if Rare == nil then return end
                local Msg = Msg .. x .. ", " .. y .. " (".. Rare ..")"
                RareShare:Log(Msg, 3, 1462)
                if (RareShareDB["Config"]["Sound"]["Master"] == true) and (RareShareDB_Mechagon["Config"]["Sound"]["Drills"] == true) then
                    RareShare:PlaySound()
                end
                if (RareShare.TomTom == true) and (RareShareDB["Config"]["TomTom"]["Master"] == true) and (RareShareDB_Mechagon["Config"]["TomTom"]["Drills"] == true) then
                    RareShare:CreateTomTomWaypoint(x/100, y/100, (drill .. ": " .. Rare))
                end
            end
        end,
        UPDATE_MOUSEOVER_UNIT = function(self, ...)
            local TooltipItemName = GameTooltip:GetUnit()
            if (TooltipItemName == nil) then return else
                local ItemName = GetItemInfo(169868)
                if (TooltipItemName == ItemName and RareShareDB_Mechagon["LastAnnounce"]["Armory"] <= time() - 300 and RareShareDB_Mechagon["Config"]["Armories"] == true) then
                    RareShareDB_Mechagon["LastAnnounce"]["Armory"] = time();
                    local x, y = RareShare:GetReadablePlayerPosition(1462);
                    local Msg = --[[ Armory found at ]]Addon.Loc.Armories.." ~("..x..", "..y..")";
                    SendChatMessage(Msg , "CHANNEL", nil, RareShareDB["Config"]["CChannel"]["CID"]);
                end
            end
        end,
    },
    Rares        = {
        [151934] = {Addon.Loc.Rares[151934]--[[ "Arachnoid Harvester" ]],              1, false, false, 55512}, --[[ Valid ]]
        [150394] = {Addon.Loc.Rares[150394]--[[ "Armored Vaultbot" ]],                 1, false, false, 55546}, --[[ Valid ]]
        [153200] = {Addon.Loc.Rares[153200]--[[ "Boilburn" ]],                         1, false, false, 55857}, --[[ Valid ]]
        [151308] = {Addon.Loc.Rares[151308]--[[ "Boggac Skullbash" ]],                 1, false, false, 55539}, 
        [152001] = {Addon.Loc.Rares[152001]--[[ "Bonepicker" ]],                       1, false, false, 55537}, --[[ Valid ]]
        [154739] = {Addon.Loc.Rares[154739]--[[ "Caustic Mechaslime" ]],               1, false, false, 56368}, 
        [151569] = {Addon.Loc.Rares[151569]--[[ "Deepwater Maw" ]],                    1, false, false, 55514}, --[[ Valid ]]
        [150342] = {Addon.Loc.Rares[150342]--[[ "Earthbreaker Gulroc" ]],              1, false, false, 55814}, --[[ Valid ]]
        [154153] = {Addon.Loc.Rares[154153]--[[ "Enforcer KX-T57" ]],                  1, false, false, 56207}, --[[ Valid ]]
        [151202] = {Addon.Loc.Rares[151202]--[[ "Foul Manifestation" ]],               1, false, false, 55513}, --[[ Valid ]]
        [151884] = {Addon.Loc.Rares[151884]--[[ "Fungarian Furor" ]],                  1, false, false, 55367}, --[[ Valid ]]
        [135497] = {Addon.Loc.Rares[135497]--[[ "Fungarian Furor" ]],                  1, false, false, 55367}, --[[ Valid ]]
        [153228] = {Addon.Loc.Rares[153228]--[[ "Gear Checker Cogstar" ]],             1, false, false, 55852}, --[[ Valid ]]
        [153205] = {Addon.Loc.Rares[153205]--[[ "Gemicide" ]],                         1, false, false, 55855}, 
        [154701] = {Addon.Loc.Rares[154701]--[[ "Gorged Gear-Cruncher" ]],             1, false, false, 56367}, --[[ Valid ]]
        [151684] = {Addon.Loc.Rares[151684]--[[ "Jawbreaker" ]],                       1, false, false, 55399}, --[[ Valid ]]
        [152007] = {Addon.Loc.Rares[152007]--[[ "Killsaw" ]],                          1, false, false, 55369}, 
        [151933] = {Addon.Loc.Rares[151933]--[[ "Malfunctioning Beastbot" ]],          1, false, false, 55544}, --[[ Valid ]]
        [151124] = {Addon.Loc.Rares[151124]--[[ "Mechagonian Nullifier" ]],            1, false, false, 55207}, --[[ Valid ]]
        [151672] = {Addon.Loc.Rares[151672]--[[ "Mecharantula" ]],                     1, false, false, 55386}, --[[ Valid ]]
        [151627] = {Addon.Loc.Rares[151627]--[[ "Mr. Fixthis" ]],                      1, false, false, 55859}, --[[ Valid ]]
        [151296] = {Addon.Loc.Rares[151296]--[[ "OOX-Avenger/MG" ]],                   1, false, false, 55515}, 
        [153206] = {Addon.Loc.Rares[153206]--[[ "Ol' Big Tusk" ]],                     1, false, false, 55853}, 
        [152764] = {Addon.Loc.Rares[152764]--[[ "Oxidized Leachbeast" ]],              1, false, false, 55856}, --[[ Valid ]]
        [151702] = {Addon.Loc.Rares[151702]--[[ "Paol Pondwader" ]],                   1, false, false, 55405}, --[[ Valid ]]
        [150575] = {Addon.Loc.Rares[150575]--[[ "Rumblerocks" ]],                      1, false, false, 55368}, --[[ Valid ]]
        [152182] = {Addon.Loc.Rares[152182]--[[ "Rustfeather" ]],                      1, false, false, 55811}, --[[ Valid ]]
        [155583] = {Addon.Loc.Rares[155583]--[[ "Scrapclaw" ]],                        1, false, false, 56737}, --[[ Valid ]]
        [150937] = {Addon.Loc.Rares[150937]--[[ "Seaspit" ]],                          1, false, false, 55545}, --[[ Valid ]]
        [153000] = {Addon.Loc.Rares[153000]--[[ "Sparkqueen P'Emp" ]],                 1, false, false, 55810}, 
        [153226] = {Addon.Loc.Rares[153226]--[[ "Steel Singer Freza" ]],               1, false, false, 55854}, --[[ Valid ]]
        [155060] = {Addon.Loc.Rares[155060]--[[ "The Doppel Gang" ]],                  1, false, false, 56419}, --[[ Valid ]]
        [152113] = {Addon.Loc.Rares[152113]--[[ "The Kleptoboss" ]],                   1, false, false, 55858},
        [151940] = {Addon.Loc.Rares[151940]--[[ "Uncle T'Rogg" ]],                     1, false, false, 55538}, --[[ Valid ]]
        [151625] = {Addon.Loc.Rares[151625]--[[ "The Scrap King" ]],                   1, false, false, 55364}, --[[ Valid ]]
        [151623] = {Addon.Loc.Rares[151623]--[[ "The Scrap King (Mounted)" ]],         1, false, false, 55364}, --[[ Valid ]]
        [154342] = {Addon.Loc.Rares[154342]--[[ "Arachnoid Harvester (Alt Time)" ]],   1, false, false, 55512}, --[[ Valid ]]
        [154225] = {Addon.Loc.Rares[154225]--[[ "The Rusty Prince (Alt Time)" ]],      1, false, false, 56182}, --[[ Valid ]]
        [154968] = {Addon.Loc.Rares[154968]--[[ "Armored Vaultbot (Alt Time)" ]],      1, false, false, 55546}, --[[ Valid ]]
        [152569] = {Addon.Loc.Rares[152569]--[[ "Crazed Trogg (Green)" ]],             1, false, false, 55812}, --[[ Valid ]]
        [152570] = {Addon.Loc.Rares[152570]--[[ "Crazed Trogg (Blue)" ]],              1, false, false, 55812}, --[[ Valid ]]
        [149847] = {Addon.Loc.Rares[149847]--[[ "Crazed Trogg (Orange)" ]],            1, false, false, 55812}, --[[ Valid ]]
    },
    -- Functions    = {
    Config = function(self)
        if RareShareDB_Mechagon                               == nil then RareShareDB_Mechagon                               = {}    end
        if RareShareDB_Mechagon["Config"]                     == nil then RareShareDB_Mechagon["Config"]                     = {}    end

        if RareShareDB_Mechagon["Config"]["Drills"]           == nil then RareShareDB_Mechagon["Config"]["Drills"]           = true  end

        if RareShareDB_Mechagon["Config"]["Sound"]            == nil then RareShareDB_Mechagon["Config"]["Sound"]            = {}    end
        if RareShareDB_Mechagon["Config"]["Sound"]["Drills"]  == nil then RareShareDB_Mechagon["Config"]["Sound"]["Drills"]  = true  end

        if RareShareDB_Mechagon["Config"]["TomTom"]           == nil then RareShareDB_Mechagon["Config"]["TomTom"]           = {}    end
        if RareShareDB_Mechagon["Config"]["TomTom"]["Drills"] == nil then RareShareDB_Mechagon["Config"]["TomTom"]["Drills"] = true  end

        if RareShareDB_Mechagon["Config"]["Armories"]         == nil then RareShareDB_Mechagon["Config"]["Armories"]         = false end

        if RareShareDB_Mechagon["LastAnnounce"]              == nil then RareShareDB_Mechagon["LastAnnounce"]                = {}    end
        if RareShareDB_Mechagon["LastAnnounce"]["Armory"]    == nil then RareShareDB_Mechagon["LastAnnounce"]["Armory"]      = 1     end
    end,
    Duplicates = function(self, ID)
        local Module = RareShare:GetModule(self.ID)
        if (ID == 151625) or (ID == 151623) then
            Module.Rares[151623][2] = time()
            Module.Rares[151625][2] = time()
            Module.Rares[151623][3] = true
            Module.Rares[151625][3] = true
        elseif (ID == 152569) or (ID == 152570) or (ID == 149847) then
            Module.Rares[152569][2] = time()
            Module.Rares[152570][2] = time()
            Module.Rares[149847][2] = time()
            Module.Rares[152569][3] = true
            Module.Rares[152570][3] = true
            Module.Rares[149847][3] = true
        elseif (ID == 151884) or (ID == 135497) then
            Module.Rares[151884][2] = time()
            Module.Rares[135497][2] = time()
            Module.Rares[151884][3] = true
            Module.Rares[135497][3] = true
        end
    end,
    InitUI = function(self)
        local ConfigFrame = CreateFrame("Frame")
        ConfigFrame.name = self.Title
        ConfigFrame.parent = RareShare.Title        
        local X, Y = 20, -20
        local CheckBoxes = RareShare.CheckBoxes
        
        CheckBoxes.Armories = RareShare:CreateCheckBox({
            ["Parent"]      = ConfigFrame,
            ["DisplayText"] = Addon.Loc.Config.Armory[1]--[[ "Enable Armory Announcements" ]],
            ["X"]           = X,
            ["Y"]           = Y,
            ["Tooltip"]     = Addon.Loc.Config.Armory[2]--[[ "Enables/Disables announcing armories to general chat" ]],
            ["Default"]     = true,
            ["Value"]       = RareShareDB_Mechagon["Config"]["Armories"],
            ["OldValue"]    = RareShareDB_Mechagon["Config"]["Armories"],
            ["Setting"]     = "RareShareDB_Mechagon[\"Config\"][\"Armories\"] = ",
        })
        Y = Y - 40
        
        CheckBoxes.Drills = RareShare:CreateCheckBox({
            ["Parent"]      = ConfigFrame,
            ["DisplayText"] = Addon.Loc.Config.Drills[1]--[[ "Enable Drill Announcements" ]],
            ["X"]           = X,
            ["Y"]           = Y,
            ["Tooltip"]     = Addon.Loc.Config.Drills[2]--[[ "Enables/Disables notifying of newly spawned Drills" ]],
            ["Default"]     = true,
            ["Value"]       = RareShareDB_Mechagon["Config"]["Drills"],
            ["OldValue"]    = RareShareDB_Mechagon["Config"]["Drills"],
            ["Setting"]     = "RareShareDB_Mechagon[\"Config\"][\"Drills\"] = ",
        })
        Y = Y - 40
        
        CheckBoxes.DrillSounds = RareShare:CreateCheckBox({
            ["Parent"]      = ConfigFrame,
            ["DisplayText"] = Addon.Loc.Config.DrillSounds[1]--[[ "Enable Drill Sounds" ]],
            ["X"]           = X + 20,
            ["Y"]           = Y,
            ["Tooltip"]     = Addon.Loc.Config.DrillSounds[2]--[[ "Enables/Disables sounds for newly spawned drills" ]],
            ["Default"]     = true,
            ["Value"]       = RareShareDB_Mechagon["Config"]["Sound"]["Drills"],
            ["OldValue"]    = RareShareDB_Mechagon["Config"]["Sound"]["Drills"],
            ["Setting"]     = "RareShareDB_Mechagon[\"Config\"][\"Sound\"][\"Drills\"] = ",
        })
        Y = Y - 40
        
        if RareShare.TomTom then 
            CheckBoxes.DrillWaypoints = RareShare:CreateCheckBox({
                ["Parent"]      = ConfigFrame,
                ["DisplayText"] = Addon.Loc.Config.DrillWaypoints[1]--[[ "Enable Drill Waypoints" ]],
                ["X"]           = X + 20,
                ["Y"]           = Y,
                ["Tooltip"]     = Addon.Loc.Config.DrillWaypoints[2]--[[ "Enables/Disables automatic waypoints to newly spawned drills" ]],
                ["Default"]     = true,
                ["Value"]       = RareShareDB_Mechagon["Config"]["TomTom"]["Drills"],
                ["OldValue"]    = RareShareDB_Mechagon["Config"]["TomTom"]["Drills"],
                ["Setting"]     = "RareShareDB_Mechagon[\"Config\"][\"TomTom\"][\"Drills\"] = ",
            })
            Y = Y - 40    
        end
    
        function ConfigFrame.refresh()
            for i,v in pairs(CheckBoxes) do
                v:CheckChecked()
            end
        end

        function ConfigFrame.default()
            for i,v in pairs(CheckBoxes) do
                v.value = v.defaultValue
            end
        end

        InterfaceOptions_AddCategory(ConfigFrame)
    end,
})