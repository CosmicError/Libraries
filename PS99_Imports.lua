--[[
            MODULES / SERVICES
]]
local replicatedStorage = game:GetService("ReplicatedStorage")
local player = game:GetService("Players").LocalPlayer
local clientLibrary = require(replicatedStorage.ClientLibrary)
    --[[
        .Network -> tbl
            .Invoke(string: remoteFunctionName, args...)
            .Fire(string: remoteEventName, args...)
    ]]
local masteryCmds = require(replicatedStorage.Library.Client.MasteryCmds)
    --[[
        .GetLevel(string: masteryName) -> int: masteryLevel
    ]]
local fruitCmds = require(replicatedStorage.Library.Client.FruitCmds)
    --[[
        .ComputeFruitQueueLimit() -> int (the max amount of fruits that can be active / queued at once)
        .GetFruitData(string: fruit) -> tbl (a table of all queued fruits of that type, get the length of the table to see how many are queued)
    ]]
local ultimateCmds = require(replicatedStorage.Library.Client.UltimateCmds)
    --[[
        .GetEquippedItem() -> tbl
            ._uid -> string: ultimateHash
            ._class -> string: ultimateClass
            ._data -> tbl
                .id -> string: ultimateId
        .IsCharged(string: ultimateId) -> bool
        .Activate(string: ultimateId) -> bool (activates the ultimate, and then returns if successful or not)
    ]]
local randomEventCmds = require(replicatedStorage.Library.Client.RandomEventCmds)
    --[[
        .GetActive() -> tbl
            k -> string: eventHash
            v -> tbl
                .id -> string: eventId
                .uid -> string: eventHash
                .parentID -> string: zoneId
                .hostPlayerID -> int: playerID (playerID of the person who summoned it)
    ]]
local zoneCmds = require(game:GetService("ReplicatedStorage").Library.Client.ZoneCmds)
    --[[
        .GetMaxOwnedZone() -> string: zoneName / zoneId
        .Own(string: zoneName / zoneId) -> bool
        .GetMaximumZone() -> tbl
            ._id -> string: zoneId
            .ZoneName -> string: zoneName
            .ZoneNumber -> int: zoneNumber
            .MaximumAvailableEgg -> int: maxEgg
    ]]
local zonesUtil = require(replicatedStorage.Library.Util.ZonesUtil)
    --[[
        .GetZoneFromNumber(int: ZoneNumber) -> string: zoneId
        .DetermineZone(object: ChildOfAZoneFolder) -> string: zoneId
        .GetFolder()
        .GetBreakableZones()
        .GetInteractFolder()
        .GetIDFromFolder()
        .GetPartsFolder()
    ]]
local mapCmds = require(replicatedStorage.Library.Client.MapCmds)
    --[[
        .GetCurrentZoneNoVerification() -> string: zoneName (localPlayer only)
        .IsInDottedBox() -> bool
        .GetPlayerZone(userdata: player) -> string: zoneName (defaults to localplayer if no arguments given)
        .GetCurrentZone() -> string: zoneName / zoneId
        .GetAllPlayerZones() -> tbl
            k -> string: playerName (NOT displayName)
            v -> string: zoneName
    ]]
--local message = require(replicatedStorage.Library.Client.Message) 
    --[[
        .New(string: message) -> void (Makes a popup window with the message)
        .Error(string: message) -> void (Makes a popup window with the message, but error styled)
    ]]
local zoneFlagCmds = require(replicatedStorage.Library.Client.ZoneFlagCmds)
    --[[
        .GetMaxPlace(string: flagID) -> int
        .HasActiveFlag(???) -> bool (kept saying false even when a flag was down)
        .ActivateFlag()
        .GetActiveFlag(string: zoneId) -> tbl (this is just a function that indexes .GetActiveFlags() ._.)
            .ZoneId -> string
            .EndTime -> float (.EndTime - os.time() will return the amount of time all the flags will last)
            .ZoneFlag -> tbl
                ._id -> string: flagID
        .DeactivateFlag(instance: parentOfObjectNamedModel) -> void (removes the object named "Model", not sure if its serverside or not)
        .GetActiveFlags() -> tbl
            k -> string: zoneId
            v -> tbl
                .ZoneId -> string
                .ZoneFlag -> tbl
                    ._id -> string: flagID
    ]]

--local eventGoalsUtil = require(replicatedStorage.Library.Util.EventGoalsUtil)
    --[[
        .IsEventActive(string: eventId) -> bool
            * Christmas2023 <- known event id
    ]]

local eggCmds = require(game:GetService("ReplicatedStorage").Library.Client.EggCmds)
    --[[
        .GetMaxHatch() -> int
        .GetHighestEggNumberAvailable() -> int
        .IsEggAvailable(?)
        .IsEggLocked(?)
        .GetPurchaseCount(?)
    ]]

local worldsUtil = require(game:GetService("ReplicatedStorage").Library.Util.WorldsUtil)
    --[[
        .GetWorld() -> tbl
            .WorldNumber -> int
            ._id -> string
            .WorldCurrency -> string
            .PlaceId -> int
            .MapName -> string
        .GetEggsModelName() -> string
    ]]

local eggsUtil = require(game:GetService("ReplicatedStorage").Library.Util.EggsUtil)
    --[[
        .GetIdByNumber(int: id) -> string: eggID
        .GetMaximumEggNumber(?) -> ?
        .GetByNumber(?) -> ?
    ]]
local gamepasses = require(game:GetService("ReplicatedStorage").Library.Client.Gamepasses)
    --[[
        .Owns(string: gamepassID) -> bool
        .GetById(?) -> ?
        .GetAll(?) -> ?
    ]]

local autoFarmCmds = require(game:GetService("ReplicatedStorage").Library.Client.AutoFarmCmds)

local hatchingCmds = require(game:GetService("ReplicatedStorage").Library.Client.HatchingCmds)
    --[[
        .SetupEgg(tbl: {_id=eggID}) -> void
        .IsHatching() -> bool
    ]]

local rankCmds = require(game:GetService("ReplicatedStorage").Library.Client.RankCmds)
    --[[
        .GetMaxRank() -> int: currentRank
        .GetTitle() -> string: currentRankTitle
        .UnlockedRank(int: anyRankNumber) -> bool
        .IsMaxRank() -> bool: playerIsGlobalMaxRank
    ]]

local ranksUtil = require(game:GetService("ReplicatedStorage").Library.Util.RanksUtil)
    --[[
        .GetArray() -> tbl
            k -> int: rankNumber
            v -> tbl
    ]]

local questCmds = require(game:GetService("ReplicatedStorage").Library.Client.QuestCmds)

local quests = require(game.ReplicatedStorage.Library.Types.Quests)
local save = require(game.ReplicatedStorage.Library.Client.Save)
	--[[
		.Get() -> tbl
	]]

--[[
			SCRIPTS
]]
local eggOpeningFrontendScript = getsenv(player.PlayerScripts.Scripts.Game["Egg Opening Frontend"])


--[[
            TABLES
]]

local rarities = {}
local tierToRarity = {}
for _, tbl in next, clientLibrary.Directory.Rarity do
	if tbl._id == "Exclusive" then
		continue
	end

	table.insert(rarities, tbl._id)
	tierToRarity[tbl.RarityNumber] = tbl._id
end

local books = {}
local bookMax = {}
for _, tbl in next, clientLibrary.Directory.Enchants do
	if tbl.MaxTier <= tbl.BaseTier then
		continue
	end

	bookMax[tbl._id] = tbl.MaxTier
	table.insert(books, tbl._id)
end

local potions = {}
local potionMax = {}
for _, tbl in next, clientLibrary.Directory.Potions do
	if tbl.BaseTier == tbl.MaxTier then
		continue
	end

	potionMax[tbl._id] = tbl.MaxTier
	table.insert(potions, tbl._id)
end

local giftBags = {}
local events = {}
local psuedoEvents = {
	-- these are under the boosts section with all the events but they themselves are not really events...
	-- since I can't really think of any good way to automatically tell them apart, we'll have to hard code some names here...
	"Breakable Sprinkler",
	"TNT Crate",
	"TNT",
	"Magic Coin Jar" -- same as giant coin jar but randomly spawn somewhere on the map when used (kinda gay)
}
for _, tbl in next, clientLibrary.Directory.MiscItems do
	if tbl.Category == "Gifts" then
		table.insert(giftBags, tbl._id)

	elseif tbl.Category == "Boosts" then
		if table.find(psuedoEvents, tbl._id) then
			continue
		end

		table.insert(events, tbl._id)

	end
end

local fruits = {}
for _, tbl in next, clientLibrary.Directory.Fruits do
	if type(tbl._id) ~= "string" then
		continue
	end

	table.insert(fruits, tbl._id)
end

local flags = {}
for _, tbl in next, clientLibrary.Directory.ZoneFlags do
	table.insert(flags, tbl._id)
end

-- preload the best egg module for the auto challenge script
local breakall = false
local bestEggModule

for _, release in next, replicatedStorage.__DIRECTORY.Eggs["Zone Eggs"]["World "..worldsUtil.GetWorldNumber()]:GetChildren() do 
	for _, module in next, release:GetChildren() do
		if not module.Name:find(162) then
			continue
		end

		bestEggModule = module

		breakall = true
		break
	end

	if breakall then
		break
	end
end
bestEggModule = require(bestEggModule)

local challengeEnumToNumber = {}
local challengeNumberToEnum = {}
for enum, val in next, quests.Goals do
	challengeEnumToNumber[enum] = val
	challengeNumberToEnum[val] = enum
end

local generalAreaChallenges = {
 	"COMET",
 	"BREAKABLE",
 	"LUCKYBLOCK",
 	"PINATA",
 	"COIN_JAR",
 	"COLLECT_LOOTBAG",
 	"MINI_CHEST",
 	"CURRENCY",
 	"DIAMOND_BREAKABLE",
 	"BLACK_LUCKYBLOCK",
 	"COLLECT_POTIONS",
 	"COLLECT_ENCHANT",
	"GET_CRITICAL",
}

-- goals in the best area where you MUST be in the dotted border
local bestAreaChallengesStay = {
	"BEST_LUCKYBLOCK",
	"BEST_PINATA",
	"BEST_COMET",
	--"BEST_MINI_CHEST",
	"BEST_COIN_JAR",

	"COMET",
	"PINATA",
	"COIN_JAR",
	"BLACK_LUCKYBLOCK",
} 

local bestAreaChallengesLeave = {
	"CURRENT_BREAKABLE",

	"BREAKABLE",
	"GET_CRITICAL",
	"MINI_CHEST",
	"CURRENCY",
	"DIAMOND_BREAKABLE",
	"BLACK_LUCKYBLOCK",
	"COLLECT_POTIONS",
	"COLLECT_ENCHANT",
	"COLLECT_LOOTBAG",

	"BEST_MINI_CHEST",
}

local vipAreaChallenges = {
	"DIAMOND_BREAKABLE",
	"CURRENCY",
}

local bestEggChallenges = {
	"BEST_EGG",
	"HATCH_RARE_PET",
	"EGG",
	"PET",
}

local superComputerChallenges = {
	"GOLD_PET",
	"RAINBOW_PETS",
	"FUSE_PETS",
	"BEST_GOLD_PET",
	"BEST_RAINBOW_PET",
	"UPGRADE_POTION",
	"UPGRADE_ENCHANT",
	"UPGRADE_FRUIT",
}

local inventoryChallenges = {
	"USE_POTION",
	"USE_FRUIT",
}

local bestAreaChallenges = {}
for _, tbl in next, {bestAreaChallengesStay, bestAreaChallengesLeave} do
	for _, enum in next, tbl do
		-- prevent duplicates
		if table.find(bestAreaChallenges, enum) then
			continue
		end

		table.insert(bestAreaChallenges, enum)
	end
end

--[[
            DEBUG
]]

local checkedTables = {}
local function stringifyTable(tbl, tabs)
	local t = ""
	tabs = tabs or 0
	if tabs > 0 then
		for _=1, tabs do
			t = t.."\t"
		end
	end

	if table.find(checkedTables, tbl) then
		return t.."*RECURSIVE*\n"
	end

	table.insert(checkedTables, tbl)
	local s = ""

	for k, v in next, tbl do
		s = s..t
		if type(v) ~= "table" then
			s ..= tostring(k).." = "..tostring(v).."\n"
			continue
		end

		local r = stringifyTable(v, tabs+1)
		if string.gsub(r, " ", "") == "" then
			continue
		end
		s ..= "["..tostring(k).."] {\n"..r..t.."}\n"
	end

	return s
end
