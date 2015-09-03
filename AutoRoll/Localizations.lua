
local _,AR=...;

local L = setmetatable({}, {
	__index = function(t, k)
		local v=tostring(k);
		rawset(t, k, v);
		return v;
	end
});

AR.L=L;

if LOCALE_deDE then
	L["Add an item by name is possible but it works not any time. Reason unknown."] = "Es ist möglich, einen Gegenstand durch seinen Namen hinzuzufügen, doch leider funktioniert das nicht immer. Grund unbekannt.";
	L["Add new Item"] = "Neuen Gegenstand hinzufügen";
	L["Add new item:"] = "Neuen Gegenstand hinzufügen:";
	L["Adding an item by its item id."] = "Füge einen neuen Gegenstand mit Hilfe der GegenstandsID hinzu.";
	L["Addon"] = "Addon";
	L["Addon loaded..."] = "Addon geladen...";
	--- L["AutoConfirm all"] = "";
	--- L["AutoRoll all"] = "";
	L["AutoRoll's functionality"] = "AutoRoll's Funktionalität";
	L["Automaticly confirm all"] = "Automatisch alles bestätigen";
	L["Automaticly confirm all group roll requests"] = "Bestätigt automatisch alle Gruppenwürfel Rückfragen";
	L["Automaticly roll on all"] = "Automatisch auf alles Würfel";
	L["Automaticly roll on all group roll items"] = "Automatisch würfeln auf alle Gruppenwürfelgegenstände";
	L["Changed mode for itemId %d (%s) to %s"] = "Modus gewechselt für GegenstandsID %d (%s) zu %s";
	L["Chat command list for /ar & /autoroll"] = "Chat Befehlsliste für /ar und /autoroll";
	L["Credit: Azial for initial idea and first piece of code in german WoW forum."] = "Ehrung: Azial für ursprüngliche Idee und ersten Teil des Codes im deutschen WoW Forum.";
	L["Current item list"] = "Aktuelle Gegenstandsliste";
	-- L["DebugMode"] = "";
	L["Default:"] = "Standard:";
	L["Do nothing"] = "Tue nichts";
	L["Enable AutoRoll"] = "Aktivere AutoRoll";
	L["Enable/Disable automatic rolling on listed items."] = "Aktiviere/Deaktiviere automatisches Würfeln auf gelistete Gegenstände.";
	L["Id %d not found in item list."] = "Id %d nicht in Gegenstandliste gefunden.";
	L["Id: %d (%s), Mode: %s"] = "Id: %d (%s), Modus: %s";
	-- L["Info message"] = "";
	L["Item list resetted..."] = "Gegenstandsliste zurückgesetzt...";
	L["ItemID %d (%s) removed from AutoRoll's item list"] = "Gegenstand %d (%s) von AutoRoll's Gegenstandsliste entfernt";
	L["ItemID %d found... %s added to AutoRoll's item list. Mode: %s"] = "GegenstandsID %d gefunden... %s zu AutoRoll's Gegenstandsliste hinzugefügt. Modus: %s";
	L["ItemID %d unknown/invalid... please check the given numbers."] = "GegenstandsID %d unbekannt/ungültig... Bitte prüfen sie die Angaben.";
	L["ItemId %d not found in item list."] = "GegenstandsID nicht in Gegenstandsliste gefunden.";
	L["Left-click"] = "Links-Klick";
	L["Not recommented"] = "Nicht Empfehlenswert";
	L["Open option menu"] = "Öffne Optionsmenü";
	L["Open option panel"] = "Öffne OptionPanel";
	L["Page %d"] = "Seite %d";
	L["Pages %d-%d"] = "Seiten %d-%d";
	L["Press enter or push the Add-Button to add the item to the item list"] = "Drücke die Eingabe-Taste oder betätige den Hinzufügen-Knopf um den Gegenstand der Gegenstandsliste hinzuzufügen";
	--- L["Print info message on any executed loot roll in chat window."] = "";
	--- L["Print info messages"] = "";
	L["Right-click"] = "Rechts-Klick";
	-- L["Status"] = "";
	L["This function use the item list below. For all over items will be roll on greed."] = "Diese function benutzt die Gegenstandsliste unten. Für alle andern Gegenstände wird auf Gier gewürfelt.";
	L["Version: %s / Author: %s"] = "Version: %s / Autor: %s";
	L["add <itemId> - add an item to the item list"] = "add <GegenstandsID> - Fügt den Gegenstand der Liste hinzu";
	L["autoconfirmall - enable/disable AutoConfirm on all items."] = "autoconfirmall - aktiviere/deaktiviere AutoConfirm auf alle Gegenstände.";
	--- L["autorollall - enable/disable AutoRoll on all items (using item list or greed)."] = "";
	--- L["debugmode - enable/disable debug messages in chat window"] = "";
	L["del <itemId> - delete an item from the item list"] = "del <GegenstandsID> - Entfernt den Gegenstand von der Liste";
	L["disabled"] = "deaktiviert";
	L["enabled"] = "aktiviert";
	--- L["infomessage - enable/disable info message for any executed loot roll in chat window"] = "";
	L["list - list items"] = "list - Listet die Gegenstände auf";
	L["mode <itemId> - change need/greed/disenchant/pass/do nothing mode for a single item"] = "mode <GegenstandsID> - Wechselt zwischen Bedarf/Gier/Entzaubern/Passen/Tue nichts-Modus bei einem Gegenstand";
	L["reset - reset the item list to default"] = "reset - Setzt die Gegenstandsliste auf Standard zurück";
	L["toggle - enable/disable AutoRoll's functionality"] = "toggle - Aktivitiere/Deaktivere AutoRoll's Funktionalität";
end

-- if LOCALE_esES or LOCALE_esMX then end
-- if LOCALE_frFR then end
-- if LOCALE_itIT then end
-- if LOCALE_koKR then end
-- if LOCALE_ptBR then end
-- if LOCALE_ruRU then end

if LOCALE_zhCN then
	L["Add an item by name is possible but it works not any time. Reason unknown."] = "添加一个物品使用它的名称并不是每次都管用。原因未知。";
	L["Add new Item"] = "添加新物品";
	L["Add new item:"] = "添加新物品：";
	L["Adding an item by its item id."] = "添加一个物品使用它的物品 ID。";
	L["Addon"] = "插件";
	L["Addon loaded..."] = "插件已加载…";
	-- L["AutoConfirm all"] = "";
	-- L["AutoRoll all"] = "";
	L["AutoRoll's functionality"] = "AutoRoll 的功能";
	L["Automaticly confirm all"] = "全部自动确认";
	L["Automaticly confirm all group roll requests"] = "自动确认全部投点需求";
	-- L["Automaticly roll on all"] = "";
	-- L["Automaticly roll on all group roll items"] = "";
	L["Changed mode for itemId %d (%s) to %s"] = "更改物品 ID %d（%s）到%s";
	L["Chat command list for /ar & /autoroll"] = "聊天命令行 /ar 或 /autoroll";
	L["Credit: Azial for initial idea and first piece of code in german WoW forum."] = "鸣谢：Azial 在德文 WoW 论坛提供最初创意和初始代码。";
	L["Current item list"] = "当前物品列表";
	-- L["DebugMode"] = "";
	L["Default:"] = "默认：";
	L["Do nothing"] = "什么都不做";
	L["Enable AutoRoll"] = "启用 AutoRoll";
	L["Enable/Disable automatic rolling on listed items."] = "启用/禁用已列表物品的自动投点。";
	L["Id %d not found in item list."] = "ID %d 未在物品列表中。";
	L["Id: %d (%s), Mode: %s"] = "ID: %d（%s），模式：%s";
	-- L["Info message"] = "";
	L["Item list resetted..."] = "物品列表已重置…";
	L["ItemID %d (%s) removed from AutoRoll's item list"] = "物品 ID %d（%s）已从 AutoRoll 的物品列表中移除";
	L["ItemID %d found... %s added to AutoRoll's item list. Mode: %s"] = "找到物品 ID %d…%s已添加到 AutoRoll 的物品列表。模式：%s";
	L["ItemID %d unknown/invalid... please check the given numbers."] = "未知/无效物品 ID %d…请检查所写数字。";
	L["ItemId %d not found in item list."] = "物品 ID %d 未在物品列表中。";
	-- L["Left-click"] = "";
	L["Not recommented"] = "不建议";
	-- L["Open option menu"] = "";
	-- L["Open option panel"] = "";
	-- L["Page %d"] = "";
	-- L["Pages %d-%d"] = "";
	L["Press enter or push the Add-Button to add the item to the item list"] = "回车或点击插件按钮添加物品到物品列表";
	-- L["Print info message on any executed loot roll in chat window."] = "";
	-- L["Print info messages"] = "";
	-- L["Right-click"] = "";
	-- L["Status"] = "";
	-- L["This function use the item list below. For all over items will be roll on greed."] = "";
	-- L["Version: %s / Author: %s"] = "";
	L["add <itemId> - add an item to the item list"] = "add <物品 ID> - 添加一个物品到物品列表";
	-- L["autoconfirmall - enable/disable AutoConfirm on all items."] = "";
	-- L["autorollall - enable/disable AutoRoll on all items (using item list or greed)."] = "";
	-- L["debugmode - enable/disable debug messages in chat window"] = "";
	L["del <itemId> - delete an item from the item list"] = "del <物品 ID> - 从物品列表中删除一个物品";
	L["disabled"] = "已禁用";
	L["enabled"] = "已启用";
	-- L["infomessage - enable/disable info message for any executed loot roll in chat window"] = "";
	L["list - list items"] = "list - 物品列表";
	-- L["mode <itemId> - change need/greed/disenchant/pass/do nothing mode for a single item"] = "";
	L["reset - reset the item list to default"] = "reset - 重置物品列表为默认";
	L["toggle - enable/disable AutoRoll's functionality"] = "toggle - 启用/禁用 AutoRoll 的功能";
end

if LOCALE_zhTW then
	L["Add an item by name is possible but it works not any time. Reason unknown."] = "添加一個物品使用它的名稱並不是每次都管用。原因未知。";
	L["Add new Item"] = "添加新物品";
	L["Add new item:"] = "添加新物品：";
	L["Adding an item by its item id."] = "添加一個物品使用它的物品 ID。";
	L["Addon"] = "插件";
	L["Addon loaded..."] = "插件已加載…";
	-- L["AutoConfirm all"] = "";
	-- L["AutoRoll all"] = "";
	L["AutoRoll's functionality"] = "AutoRoll 的功能";
	L["Automaticly confirm all"] = "全部自動確認";
	L["Automaticly confirm all group roll requests"] = "自動確認全部投點需求";
	-- L["Automaticly roll on all"] = "";
	-- L["Automaticly roll on all group roll items"] = "";
	L["Changed mode for itemId %d (%s) to %s"] = "更改物品 ID %d（%s）到%s";
	L["Chat command list for /ar & /autoroll"] = "聊天命令行 /ar 或 /autoroll";
	L["Credit: Azial for initial idea and first piece of code in german WoW forum."] = "鳴謝：Azial 在德 文WoW 論壇提供最初創意和初始代碼。";
	L["Current item list"] = "當前物品列表";
	-- L["DebugMode"] = "";
	L["Default:"] = "默認：";
	L["Do nothing"] = "什麼都不做";
	L["Enable AutoRoll"] = "啟用 AutoRoll";
	L["Enable/Disable automatic rolling on listed items."] = "啟用/禁用已列表物品的自動投點。";
	L["Id %d not found in item list."] = "ID %d 未在物品列表中。";
	L["Id: %d (%s), Mode: %s"] = "ID: %d（%s），模式：%s";
	-- L["Info message"] = "";
	L["Item list resetted..."] = "物品列表已重置…";
	L["ItemID %d (%s) removed from AutoRoll's item list"] = "物品 ID %d（%s）已從 AutoRoll 的物品列表中移除";
	L["ItemID %d found... %s added to AutoRoll's item list. Mode: %s"] = "找到物品 ID %d…%s已添加到 AutoRoll 的物品列表。模式：%s";
	L["ItemID %d unknown/invalid... please check the given numbers."] = "未知/無效物品 ID %d…請檢查所寫數字。";
	L["ItemId %d not found in item list."] = "物品 ID %d 未在物品列表中。";
	-- L["Left-click"] = "";
	L["Not recommented"] = "不建議";
	-- L["Open option menu"] = "";
	-- L["Open option panel"] = "";
	-- L["Page %d"] = "";
	-- L["Pages %d-%d"] = "";
	L["Press enter or push the Add-Button to add the item to the item list"] = "回車或點擊插件按鈕添加物品到物品列表";
	-- L["Print info message on any executed loot roll in chat window."] = "";
	-- L["Print info messages"] = "";
	-- L["Right-click"] = "";
	-- L["Status"] = "";
	-- L["This function use the item list below. For all over items will be roll on greed."] = "";
	-- L["Version: %s / Author: %s"] = "";
	L["add <itemId> - add an item to the item list"] = "add <物品 ID> - 添加一個物品到物品列表";
	-- L["autoconfirmall - enable/disable AutoConfirm on all items."] = "";
	-- L["autorollall - enable/disable AutoRoll on all items (using item list or greed)."] = "";
	-- L["debugmode - enable/disable debug messages in chat window"] = "";
	L["del <itemId> - delete an item from the item list"] = "del <物品 ID> - 從物品列表中刪除一個物品";
	L["disabled"] = "已禁用";
	L["enabled"] = "已啟用";
	-- L["infomessage - enable/disable info message for any executed loot roll in chat window"] = "";
	L["list - list items"] = "list - 物品列表";
	-- L["mode <itemId> - change need/greed/disenchant/pass/do nothing mode for a single item"] = "";
	L["reset - reset the item list to default"] = "reset - 重置物品列表為默認";
	L["toggle - enable/disable AutoRoll's functionality"] = "toggle - 啟用/禁用 AutoRoll 的功能";
end

--[[
if LOCALE_<countryCode> then
	L["add <itemId> - add an item to the item list"] = "";
	L["Add an item by name is possible but it works not any time. Reason unknown."] = "";
	L["Add new Item"] = "";
	L["Add new item:"] = "";
	L["Adding an item by its item id."] = "";
	L["Addon loaded..."] = "";
	L["Addon"] = "";
	L["AutoConfirm all"] = "";
	L["autoconfirmall - enable/disable AutoConfirm on all items."] = "";
	L["Automaticly confirm all group roll requests"] = "";
	L["Automaticly confirm all"] = "";
	L["Automaticly roll on all group roll items"] = "";
	L["Automaticly roll on all"] = "";
	L["AutoRoll all"] = "";
	L["AutoRoll's functionality"] = "";
	L["autorollall - enable/disable AutoRoll on all items (using item list or greed)."] = "";
	L["Changed mode for itemId %d (%s) to %s"] = "";
	L["Chat command list for /ar & /autoroll"] = "";
	L["Credit: Azial for initial idea and first piece of code in german WoW forum."] = "";
	L["Current item list"] = "";
	L["debugmode - enable/disable debug messages in chat window"] = "";
	L["DebugMode"] = "";
	L["Default:"] = "";
	L["del <itemId> - delete an item from the item list"] = "";
	L["disabled"] = "";
	L["Do nothing"] = "";
	L["Enable AutoRoll"] = "";
	L["Enable/Disable automatic rolling on listed items."] = "";
	L["enabled"] = "";
	L["Id %d not found in item list."] = "";
	L["Id: %d (%s), Mode: %s"] = "";
	L["Info message"] = "";
	L["infomessage - enable/disable info message for any executed loot roll in chat window"] = "";
	L["Item list resetted..."] = "";
	L["ItemID %d (%s) removed from AutoRoll's item list"] = "";
	L["ItemID %d found... %s added to AutoRoll's item list. Mode: %s"] = "";
	L["ItemId %d not found in item list."] = "";
	L["ItemID %d unknown/invalid... please check the given numbers."] = "";
	L["Left-click"] = "";
	L["list - list items"] = "";
	L["mode <itemId> - change need/greed/disenchant/pass/do nothing mode for a single item"] = "";
	L["Not recommented"] = "";
	L["Open option menu"] = "";
	L["Open option panel"] = "";
	L["Page %d"] = "";
	L["Pages %d-%d"] = "";
	L["Press enter or push the Add-Button to add the item to the item list"] = "";
	L["Print info message on any executed loot roll in chat window."] = "";
	L["Print info messages"] = "";
	L["reset - reset the item list to default"] = "";
	L["Right-click"] = "";
	L["Status"] = "";
	L["This function use the item list below. For all over items will be roll on greed."] = "";
	L["toggle - enable/disable AutoRoll's functionality"] = "";
	L["Version: %s / Author: %s"] = "";
end
]]