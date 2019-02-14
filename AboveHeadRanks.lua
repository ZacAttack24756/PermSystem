local NewParent = Instance.new("Folder")
script.Parent = NewParent

function InArray(Table, value)
	for i, v in pairs(Table) do
		if v == value then
			return true
		end
	end
	return false
end

function CreateGUI(GUIDistance, TopText, MiddleText, BottomText, Color, Font)
	-- Main GUI
	local GUI = Instance.new("BillboardGui")
	GUI.Name = "AboveHeadRank"
	GUI.Size = UDim2.new(4, 0, 2, 0)
	GUI.StudsOffset = Vector3.new(0, 3, 0)
	if type(GUIDistance) == "number" then
		GUI.MaxDistance = GUIDistance
	end
	
	-- Name Label
	local Top = Instance.new("TextLabel")
	Top.Name = "Top"
	Top.BackgroundTransparency = 1
	Top.Size = UDim2.new(1, 0, 0.25, 0)
	Top.TextScaled = true
	if type(TopText) == "string" then
		Top.Text = TopText
	end
	Top.Parent = GUI
	
	-- Rank Label
	local Middle = Instance.new("TextLabel")
	Middle.Name = "Middle"
	Middle.BackgroundTransparency = 1
	Middle.Size = UDim2.new(1, 0, 0.20, 0)
	Middle.Position = UDim2.new(0, 0, 0.25, 0)
	Middle.TextScaled = true
	if type(MiddleText) == "string" then
		Middle.Text = MiddleText
	end
	Middle.Parent = GUI
	
	-- Bottom Label
	local Bottom = Instance.new("TextLabel")
	Bottom.Name = "Bottom"
	Bottom.BackgroundTransparency = 1
	Bottom.Size = UDim2.new(1, 0, 0.10, 0)
	Bottom.Position = UDim2.new(0, 0, 0.45, 0)
	Bottom.TextScaled = true
	if type(BottomText) == "string" then
		Bottom.Text = BottomText
	end
	Bottom.Parent = GUI
	
	-- Colors
	if Color then
		Top.TextColor3 = Color
		Middle.TextColor3 = Color
		Bottom.TextColor3 = Color
	else
		Top.TextColor3 = Color3.fromRGB(163, 162, 165)
		Middle.TextColor3 = Color3.fromRGB(163, 162, 165)
		Bottom.TextColor3 = Color3.fromRGB(163, 162, 165)
	end
	
	-- Font
	if Font then
		Top.Font = Font
		Middle.Font = Font
		Bottom.Font = Font
	else
		Top.Font = Enum.Font.SourceSans
		Middle.Font = Enum.Font.SourceSans
		Bottom.Font = Enum.Font.SourceSans
	end
	
	-- Finally, returns the finished GUI	
	return GUI
end

function Run(Settings, player, character)
	local Rank = player:GetRankInGroup(Settings.GroupID)
	local Role = player:GetRoleInGroup(Settings.GroupID)
	local UserName = player.Name
	local Team = ""
	for i, v in pairs(Settings.GroupTeamsTable) do
		if type(i) == "string" and player.Team and i == player.Team.Name and type(v) == "number" then
			Team = player:GetRoleInGroup(v)
		end
	end
	
	-- Redacted
	for _, v in pairs(Settings.RedactedTeams) do
		print(v)
		print(player.Team.Name)
		print(v == player.Team.Name)
		if v and player.Team and v == player.Team.Name then
			UserName = "[REDACTED]"
			Role = ""
			Team = ""
		end
	end
	if InArray(Settings.RedactedRanks, Rank) then
		UserName = "[REDACTED]"
		Role = ""
		Team = ""
	end
	
	-- Data Expunged
	for _, v in pairs(Settings.DataExpungedTeams) do
		if v and v == player.Team.Name then
			UserName = "[DATA EXPUNGED]"
			Role = ""
			Team = ""
		end
	end
	if InArray(Settings.DataExpungedRanks, Rank) then
		UserName = "[DATA EXPUNGED]"
		Role = ""
		Team = ""
	end
	
	-- Color
	local Color = Settings.TextColor
	if Settings.TeamColorsEnabled == true then
		if player.Team ~= nil then
			Color = player.TeamColor.Color
		else
			Color = Color3.fromRGB(163, 162, 165)
		end
	end
	
	-- Distance
	local Distance = 100
	if type(Settings.MaxDistance) == "number" and Settings.MaxDistance > 0 then
		Distance = Settings.MaxDistance
	end
	
	-- Creates the GUI
	local GUI = CreateGUI(Distance, UserName, Team, Role, Color, Settings.Font)
	if GUI then
		GUI.Parent = character:FindFirstChild("Head")
		local Humanoid = character:FindFirstChildOfClass("Humanoid")
		if Humanoid then
			Humanoid.NameDisplayDistance = 0
		end
	end
end

local GSettings = {}

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(Character)
		if GSettings ~= {} then
			Run(GSettings, player, Character)
		end
	end)
end)

return function(Settings)
	if type(Settings.GroupID) ~= "number" or Settings.GroupID == 0 then
		error("Provided GroupID not a number, and/or equal to 0.")
	end
	if type(Settings.RedactedRanks) ~= "table" or type(Settings.DataExpungedRanks) ~= "table" or type(Settings.RedactedTeams) ~= "table" or type(Settings.DataExpungedTeams) ~= "table" then
		error("One of the provided 'RedactedRanks', 'DataExpungedRanks', 'RedactedTeams', 'DataExpungedTeams' is not a table.")
	end
	if type(Settings.GroupTeamsTable) ~= "table" then
		error("'GroupTeamsTable' either missing or not a table.")
	end
	GSettings = Settings
end