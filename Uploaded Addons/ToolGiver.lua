local Cards = {
	DivisionCards = {"MTF Card", "SD Card", "IA Card", "AD Card"},
	LevelCards = {"Omni", "L5", "L4", "L3", "L2", "L1", "L0"},
}
local PlayerItems = {
	["HereComesDatBois"] = {"Crystal Key"},
}
local GroupId = 3519516
local Stolen_Glock_Gamepass = 1233401027
local GamePassService = game:GetService('GamePassService')
local Toximay = 255
local O5 = 13
local SiD = 11
local L4 = 10
local L3 = 8
local L2 = 7
local L1 = 6
local L0 = 5

function RemoveCards(player)
	for _, v in pairs(player.Backpack:GetChildren()) do
		for _, a in pairs(Cards.DivisionCards) do
			if v.Name == a then
				v:Destroy()
			end
		end
		for _, a in pairs(Cards.LevelCards) do
			if v.Name == a then
				v:Destroy()
			end
		end
	end
end
function GiveItem(plr, Item, ReName)
	local Clone = game.ServerStorage:FindFirstChild(Item)
	if Clone then
		if plr.Backpack:FindFirstChild(ReName or Item) then else
			Clone = Clone:Clone()
			if type(ReName) == "string" then
				Clone.Name = ReName
			end
			Clone.Parent = plr.Backpack
			return Clone
		end
	end
	return nil
end -- Gives the player an item from SS

function Run(plr)
	-- Group Level Givers
	if plr:GetRankInGroup(GroupId) == L0 then
		GiveItem(plr, "L0")
	end
	if plr:GetRankInGroup(GroupId) == L1 then
		GiveItem(plr, "L1")
	end
	if plr:GetRankInGroup(GroupId) == L2 then
		GiveItem(plr, "L2")
	end
	if plr:GetRankInGroup(GroupId) == L3 then
		GiveItem(plr, "L3")
	end
	if plr:GetRankInGroup(GroupId) == L4 then
		GiveItem(plr, "L4")
	end
	if plr:GetRankInGroup(GroupId) == SiD then
		GiveItem(plr, "L4")
	end
	if plr:GetRankInGroup(GroupId) == O5 then
		GiveItem(plr, "L5")
	end
	if plr:GetRankInGroup(GroupId) == Toximay then
		GiveItem(plr, "Omni")
	end
	
	-- Team Item Givers
	if plr.TeamColor == game.Teams["Foundation Personnel"].TeamColor then
		GiveItem(plr, "Mop")
		GiveItem(plr, "Radio")
	end
	if plr.TeamColor == game.Teams["Medical Department"].TeamColor then
		GiveItem(plr, "Medkit")
		GiveItem(plr, "Radio")
	end
	if plr.TeamColor == game.Teams["Scientific Department"].TeamColor then
		GiveItem(plr, "Radio")
	end
	if plr.TeamColor == game.Teams["DEA"].TeamColor then
		GiveItem(plr, "EC Card")
		GiveItem(plr, "Radio")
	end
	if plr.TeamColor == game.Teams["Ethics Committee"].TeamColor then
		GiveItem(plr, "EC Card")
		GiveItem(plr, "Radio")
	end
	if plr.TeamColor == game.Teams["Security Department"].TeamColor then
		GiveItem(plr, "SD Card")
		GiveItem(plr, "Radio")
		GiveItem(plr, "Radio", "Combative Radio")
		GiveItem(plr, "M416")
	end
	if plr.TeamColor == game.Teams["Mobile Task Force"].TeamColor then
		GiveItem(plr, "MTF Card")
		GiveItem(plr, "Radio")
		GiveItem(plr, "Radio", "Combative Radio")
		GiveItem(plr, "Scar CQC")
		GiveItem(plr, "Vector")
	end
	if plr.TeamColor == game.Teams["Intelligence Agency"].TeamColor then
		GiveItem(plr, "IA Card")
		GiveItem(plr, "Radio")
		GiveItem(plr, "Radio", "HR Radio")
		GiveItem(plr, "SGlock17")
		GiveItem(plr, "Remington")
		GiveItem(plr, "Spy")
	end
	if plr.TeamColor == game.Teams["Administrative Department"].TeamColor then
		GiveItem(plr, "AD Card")
		GiveItem(plr, "Radio")
		GiveItem(plr, "Radio", "HR Radio")
		GiveItem(plr, "Minigun")
		GiveItem(plr, "Glock17")
	end
	if plr.TeamColor == game.Teams["Class D"].TeamColor then
		RemoveCards(plr)
	end
	if plr.TeamColor == game.Teams["Chaos Insurgency"].TeamColor then
		RemoveCards(plr)
		GiveItem(plr, "Radio", "CI Radio")
		GiveItem(plr, "Vector")
		GiveItem(plr, "M416")
		GiveItem(plr, "Medkit")
	end
	
	-- Gamepass Givers
	if GamePassService:PlayerHasPass(plr, Stolen_Glock_Gamepass) then
		if plr.Backpack:FindFirstChild("Glock17") == nil then
			local Obj = GiveItem(plr, "Glock17", "Stolen Glock")
		end
	end
	
	for i, v in pairs(PlayerItems) do
		if i == plr.Name then
			for _, a in pairs(v) do
				GiveItem(plr, a)
			end
		end
	end
end

game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		Run(plr)
	end)
end)