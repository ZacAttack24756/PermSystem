--[[
	AboveHeadRanks
	Made by: mystery3525
	Description: Shows a GUI above your head showing your username and rank in the specified group
--]]
local Settings = {
	GroupID = 3519516, -- Your group ID
	
	DataExpungedRanks = {255}, -- Ranks that show up as '[DATA EXPUNGED]' in game if you have it. Overrides 'RedactedRanks'. Example: {255, 254, 253}
	RedactedRanks = {13}, -- Ranks that show up as '[REDACTED]' in game if you have it. Can be overriden with 'DataExpungedRanks'. Example: {255, 254, 253}
	
	DataExpungedTeams = {}, -- Ranks that show up as '[DATA EXPUNGED]' in game if you are it. Overrides 'RedactedRanks'. Eample: '{"Raiders", "Owner"}'
	RedactedTeams = {"Intelligence Agency"}, -- Teams that show up as '[REDACTED]' in game if you are in it. Can be overriden by 'DataExpungedRanks'. Example: '{"Raiders", "Owner"}"
	
	TeamColorsEnabled = true, -- If the GUI takes the color of your team as the text color.
	TextColor = Color3.fromRGB(255, 255, 255), -- The RGB Color everyone's Text looks like. Only works if 'TeamColorsEnabled' is false.
	
	Font = Enum.Font.Highway, -- The Font in which the gui displays ; Complete Font Listing: http://wiki.roblox.com/index.php?title=API:Enum/Font
	MaxDistance = 100, -- The maximum distance (In Studs) that the GUI will show.
	
	GroupTeamsTable = {
		["Administrative Department"] = 3532703,
		["Ethics Committee"] = 3540241,
		["Mobile Task Force"] = 3534520,
		["Scientific Department"] = 3540272,
		["Security Department"] = 3545062,
		["Medical Department"] = 3610184,
		["DEA"] = 3736895,
		["TSH"] = 3984375,
	}, -- The group ID that corresponds to the team name. (Team Name is in the [""] , Group ID is after the = and before the , )
	-- Note: If the Team Name is not in this table, if the player is in the team, it will not show their group role.
}

local success, err = pcall(function()
	require(1457357349)(Settings)
end)
if success then
	print("AboveHeadRanks loaded successfully.")
else
	print("AboveHeadRanks experienced error while loading:")
	print(err)
end

wait(5)

script:Destroy()