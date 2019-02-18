local InternalFunc = script.Parent.Parent:FindFirstChild("API_Call")
local Settings = {}

function CreateGui(Box1Text, Box2Text, Box3Text, Box4Text, Color)
    -- Main GUI
    local GUI = Instance.new("BillboardGui")
    GUI.Name = "SimpleTitles"
    GUI.Size = UDim2.new(4, 0, 2, 0)
    GUI.StudsOffset = Vector3.new(0, 3, 0)
    GUI.MaxDistance = Settings.GuiViewDistance

    -- Box1 Label (Username Box)
    local Box1 = Instance.new("TextLabel")
    Box1.Name = "Box1"
    Box1.BackgroundTransparency = 1
    Box1.Size = UDim2.new(1, 0, 0.25, 0)
    Box1.TextScaled = true
    if type(Box1Text) == "string" then
        Box1.Text = Box1Text
    end
    Box1.Parent = GUI

    -- Box2 Label
    local Box2 = Instance.new("TextLabel")
    Box2.Name = "Middle"
    Box2.BackgroundTransparency = 1
	Box2.Size = UDim2.new(1, 0, 0.20, 0)
	Box2.Position = UDim2.new(0, 0, 0.25, 0)
	Box2.TextScaled = true
    if type(Box2Text) == "string" then
        Box2.Text = Box2Text
    end
    Box2.Parent = GUI

    -- Box3 Label
	local Box3 = Instance.new("TextLabel")
	Box3.Name = "Bottom"
	Box3.BackgroundTransparency = 1
	Box3.Size = UDim2.new(1, 0, 0.10, 0)
	Box3.Position = UDim2.new(0, 0, 0.45, 0)
	Box3.TextScaled = true
	if type(Box3Text) == "string" then
		Box3.Text = Box3Text
	end
	Box3.Parent = GUI

    -- Box4 Label (Just a moved down Box3)
	local Box4 = Instance.new("TextLabel")
	Box4.Name = "Bottom"
	Box4.BackgroundTransparency = 1
	Box4.Size = UDim2.new(1, 0, 0.10, 0)
	Box4.Position = UDim2.new(0, 0, 0.55, 0)
	Box4.TextScaled = true
	if type(Box4Text) == "string" then
		Box4.Text = Box4Text
	end
	Box4.Parent = GUI

    -- Font
    if Settings.Font then
        Box1.Font = Settings.Font
        Box2.Font = Settings.Font
        Box3.Font = Settings.Font
        Box4.Font = Settings.Font
    else
        Box1.Font = Enum.Font.SourceSans
        Box2.Font = Enum.Font.SourceSans
        Box3.Font = Enum.Font.SourceSans
        Box4.Font = Enum.Font.SourceSans
    end

    -- Colors
    if Color then
        Box1.TextColor3 = Color
        Box2.TextColor3 = Color
        Box3.TextColor3 = Color
        Box4.TextColor3 = Color
    else
        Box1.TextColor3 = Color3.fromRGB(163, 162, 165)
        Box2.TextColor3 = Color3.fromRGB(163, 162, 165)
        Box3.TextColor3 = Color3.fromRGB(163, 162, 165)
        Box4.TextColor3 = Color3.fromRGB(163, 162, 165)
    end

    --- Return the finished GUI ---
    return GUI
end

-- Locates the Addon Configuration for a specific RankLadder
function LocateGroupAddonInfo(Player, PlayerData, RankLadder)
    local RankLadderGroups = InternalFunc:Invoke("GetRankLadderGroups", RankLadder)

    if type(Groups) == "table" then
        for _, v1 in pairs(PlayerData.Groups) do
            for _, v2 in pairs(RankLadderGroups) do
                if v1 == v2 then
                    local Info = InternalFunc:Invoke("GetGroupInfo", v1)
                    if type(Info) == "table" and type(Info.Addons) == "table" then
                        if type(Info.Addons["SimpleTitles"]) then
                            return Info.Addons["SimpleTitles"]
                        end
                    end
                end
            end
        end
    end

    return nil
end

function Run(Player, Character)
    local Username = Player.Name
    local Team = Player.Team
    local Data = InternalFunc:Invoke("GetPlrData", Player)

    if type(Data) == "string" then
        warn("SimpleTitles GetPlrData Error for ".. Username ..", :".. Data)
    end

    local Color = Color3.fromRGB(163, 162, 165)
    if Settings["Global:Color"] then
        if Settings["Global:Color"] == "TeamColor" then
            Color = Team.TeamColor.Color
        elseif string.sub(Settings["Global:Color"], 1, 11) == "RankLadder:" and type(Data) == "table" then
            local Ladder = string.sub(Settings["Global:Color"], 12)
            if Ladder == "" then Ladder = "Default" end
            local AddonInfo = LocateGroupAddonInfo(Player, Data, Ladder)

            if type(AddonInfo) == "table" then
                if type(AddonInfo["Color"]) == "userdata" then
                    Color = AddonInfo["Color"]
                end
            end
        end
    end
    -- All that work just to get the color, not including functions and exterior functions; wow
end

return function(Config)
    if type(Config.Enabled) ~= "string" or Config.Enabled == false then return "SimpleTitles not enabled!" end

    -- Get on with the configuration!
    Settings.GuiViewDistance = 100
    if type(Config.GuiViewDistance) == "number" and Config.GuiViewDistance > 0 and Config.GuiViewDistance < 100000 then
        Settings.GuiViewDistance = Config.GuiViewDistance
    end

    Settings.FillEmptyBoxes = true
    if type(Config.FillEmptyBoxes) == "boolean" then
        Settings.FillEmptyBoxes = Cofnig.FillEmptyBoxes
    end

    Settings.Font = Enum.Font.SourceSans
    if type(Config["Global:Font"]) == "string" then
        if Enum.Font[Config["Global:Font"]] ~= nil then
            Settings.Font = Enum.Font[Config["Global:Font"]]
        end
    end

    Settings.Color = Color3.fromRGB(163, 162, 165)
    if type(Config["Global:Color"]) == "string" then
        if Config["Global:Color"] == "TeamColor" or string.sub(Config["Global:Color"], 1, 11) == "RankLadder:" then
            Settings.Color = Config["Global:Color"]
        end
    end

    if type(Config["Box1:Enabled"]) == "boolean" then
        Settings["Box1:Enabled"] = Config["Box1:Enabled"]
    end
    Settings["Box1:Text"] = "Username"
    if type(Config["Box1:Text"]) == "string" then
        if string.sub(Config["Box1:Text"], 1, 11) == "RankLadder:" then
            Settings["Box1:Text"]
        end
    end
    if type(Config["Box2:Text"]) == "string" then
        if string.sub(Config["Box2:Text"], 1, 4) == "Team" or string.sub(Config["Box2:Text"], 1, 11) == "RankLadder:" or string.sub(Config["Box2:Text"], 1, 12) then
            Settings["Box2:Text"] = Config["Box2:Text"]
        end
    end
    if type(Config["Box3:Text"]) == "string" then
        if string.sub(Config["Box3:Text"], 1, 4) == "Team" or string.sub(Config["Box3:Text"], 1, 11) == "RankLadder:" or string.sub(Config["Box3:Text"], 1, 12) then
            Settings["Box3:Text"] = Config["Box3:Text"]
        end
    end
    if type(Config["Box4:Text"]) == "string" then
        if string.sub(Config["Box4:Text"], 1, 4) == "Team" or string.sub(Config["Box4:Text"], 1, 11) == "RankLadder:" or string.sub(Config["Box4:Text"], 1, 12) then
            Settings["Box4:Text"] = Config["Box4:Text"]
        end
    end

    -- Add some sort of hook here
    game.Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function(char)
            Run(plr, char)
        end)
    end)

    -- Addon has loaded sucessfully
    return true
end
