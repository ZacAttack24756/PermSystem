local ApiKey = script.Parent.Parent:FindFirstChild("API_KEY")
local TS = game:GetService("Teams")
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
    Box2.Name = "Box2"
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
	Box3.Name = "Box3"
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
	Box4.Name = "Box4"
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
    local RankLadderGroups = _G.PermSystem.Api(ApiKey.Value, "GetRankLadderGroups", RankLadder)

    print("RankLadderGroups")
    print(RankLadderGroups)
    if type(RankLadderGroups) == "table" then
        for _, v1 in pairs(PlayerData.Groups) do
            print(v1)
            for _, v2 in pairs(RankLadderGroups) do
                print(v2)
                if v1 == v2 then
                    local Info = _G.PermSystem.Api(ApiKey.Value, "GetGroupInfo", v1)
                    print("Info")
                    print(Info)
                    if type(Info) == "table" and type(Info.Addons) == "table" then
                        if type(Info.Addons["SimpleTitles"]) == "table" then
                            return Info.Addons["SimpleTitles"]
                        end
                    end
                end
            end
        end
    end

    return nil
end

function BoxText(Player, Data, Set)
    local Return = nil
    print("BoxText Call on '".. Set .."'")
    if type(Set) == "string" then
        if Set == "Disabled" then
            Return = ""
        elseif Set == "Username" then
            Return = Player.Name
        elseif string.sub(Set, 1, 8) == "SetText:" then
            Return = string.sub(Set, 9)
        elseif string.sub(Set, 1, 4) == "Set:" then
            Return = string.sub(Set, 5)
        elseif string.sub(Set, 1, 1) == ":" then
            Return = string.sub(Set, 2)
        elseif Set == "TeamName" then
            if Player.Team then
                Return = Player.Team.Name
            else
                Return = ""
            end
        elseif string.sub(Set, 1, 12) == "RblxGroupID:" then
            local ID = tonumber(string.sub(Set, 13))
            if type(ID) == "number" then
                local ProperlyRan, PcallReturn = pcall(function()
                    return Player:GetRoleInGroup(ID)
                end)
                if ProperlyRan then
                    Return = PcallReturn
                else
                    warn("PermSystem SimpleTitles Addon GetRoleInGroup Error: ".. PcallReturn)
                end
            end
        elseif string.sub(Set, 1, 11) == "RankLadder:" then
            local Ladder = string.sub(Set, 12)
            if Ladder == "" then Ladder = "Default" end
            local AddonInfo = LocateGroupAddonInfo(Player, Data, Ladder)
            print("AddonInfo")
            print(AddonInfo)

            if type(AddonInfo) == "table" then
                if type(AddonInfo["Box1:Text"]) then
                    local Set1234 = AddonInfo["Box1:Text"]
                    print(Set1234)
                    if Set1234 == "Disabled" then
                        Return = ""
                    elseif Set1234 == "Username" then
                        Return = Player.Name
                    elseif string.sub(Set1234, 1, 8) == "SetText:" then
                        Return = string.sub(Set, 9)
                    end
                end
            end
        end
    end

    if type(Return) == "string" then
        print("BoxText '".. Set .."'; Returning '".. Return .."'")
    end

    return Return
end

function Run(Player, Character)
    local Username = Player.Name
    local Team = Player.Team
    local Data = _G.PermSystem.Api(ApiKey.Value, "GetPlrData", Player)

    if type(Data) == "string" then
        warn("SimpleTitles GetPlrData Error for ".. Username ..", :".. Data)
    end

    local Color = Color3.fromRGB(163, 162, 165)
    --print(Settings.Color)
    if type(Settings.Color) == "string" then
        if Settings.Color == "TeamColor" and Player.Team ~= nil then
            Color = Player.TeamColor.Color
            --print(Player.Team)
            --print(Player.TeamColor)
        elseif string.sub(Settings.Color, 1, 11) == "RankLadder:" and type(Data) == "table" then
            local Ladder = string.sub(Settings.Color, 12)
            if Ladder == "" then Ladder = "Default" end
            local AddonInfo = LocateGroupAddonInfo(Player, Data, Ladder)

            if type(AddonInfo) == "table" then
                if type(AddonInfo["Color"]) == "userdata" then
                    Color = AddonInfo["Color"]
                elseif type(AddonInfo["Color"]) == "string" then
                    Color = BrickColor.new(AddonInfo["Color"]).Color
                end
            end
        end
    end
    -- All that work just to get the color, not including functions and exterior functions;
    -- this is going to take a while
    print("Settings Box1:Text")
    local Box1Text = Player.Name
    if type(Settings["Box1:Text"]) == "string" then
        print(Settings["Box1:Text"])
        local Box1Return = BoxText(Player, Data, Settings["Box1:Text"])
        if Box1Return then
            Box1Text = Box1Return
        end
    elseif type(Settings["Box1:Text"]) == "table" then
        local Default = true
        for i, v in pairs(Settings["Box1:Text"]) do
            if type(i) == "string" and TS:FindFirstChild(i) and type(v) == "string" then
                print(Player.Team.Name)
                if i == Player.Team.Name then
                    print(v)
                    local Box1Return = BoxText(Player, Data, v)
                    if Box1Return then
                        Box1Text = Box1Return
                        Default = false
                    end
                end
            end
        end
        if Default == true then
            if type(Settings["Box1:Text"]["Default"]) == "string" then
                local Box1Return = BoxText(Player, Data, Settings["Box1:Text"]["Default"])
                if Box1Return then
                    Box1Text = Box1Return
                end
            end
        end
    end

    local Box2Text = ""
    print("Settings Box2:Text")
    if type(Settings["Box2:Text"]) == "string" then
        print(Settings["Box2:Text"])
        local Box1Return = BoxText(Player, Data, Settings["Box2:Text"])
        if Box1Return then
            Box1Text = Box1Return
        end
    elseif type(Settings["Box2:Text"]) == "table" then
        local Default = true
        for i, v in pairs(Settings["Box2:Text"]) do
            if type(i) == "string" and TS:FindFirstChild(i) and type(v) == "string" then
                print(Player.Team.Name)
                if i == Player.Team.Name then
                    print(v)
                    local Box2Return = BoxText(Player, Data, v)
                    if Box2Return then
                        Box2Text = Box2Return
                        Default = false
                    end
                end
            end
        end
        if Default == true then
            if type(Settings["Box2:Text"]["Default"]) == "string" then
                local Box2Return = BoxText(Player, Data, Settings["Box2:Text"]["Default"])
                if Box2Return then
                    Box2Text = Box2Return
                end
            end
        end
    end

    local Box3Text = ""
    print("Settings Box3:Text")
    if type(Settings["Box3:Text"]) == "string" then
        print(Settings["Box3:Text"])
        local Box1Return = BoxText(Player, Data, Settings["Box3:Text"])
        if Box1Return then
            Box1Text = Box1Return
        end
    elseif type(Settings["Box3:Text"]) == "table" then
        local Default = true
        for i, v in pairs(Settings["Box3:Text"]) do
            if type(i) == "string" and TS:FindFirstChild(i) and type(v) == "string" then
                print(Player.Team.Name)
                if i == Player.Team.Name then
                    print(v)
                    local Box3Return = BoxText(Player, Data, v)
                    if Box3Return then
                        Box3Text = Box3Return
                        Default = false
                    end
                end
            end
        end
        if Default == true then
            if type(Settings["Box3:Text"]["Default"]) == "string" then
                local Box3Return = BoxText(Player, Data, Settings["Box3:Text"]["Default"])
                if Box3Return then
                    Box3Text = Box3Return
                end
            end
        end
    end

    local Box4Text = ""
    if type(Settings["Box4:Text"]) == "string" then
        local Box1Return = BoxText(Player, Data, Settings["Box4:Text"])
        if Box1Return then
            Box1Text = Box1Return
        end
    elseif type(Settings["Box4:Text"]) == "table" then
        local Default = true
        for i, v in pairs(Settings["Box4:Text"]) do
            if type(i) == "string" and TS:FindFirstChild(i) and type(v) == "string" then
                print(Player.Team.Name)
                if i == Player.Team.Name then
                    local Box4Return = BoxText(Player, Data, v)
                    if Box4Return then
                        Box4Text = Box4Return
                        Default = false
                    end
                end
            end
        end
        if Default == true then
            if type(Settings["Box4:Text"]["Default"]) == "string" then
                local Box4Return = BoxText(Player, Data, Settings["Box4:Text"]["Default"])
                if Box4Return then
                    Box4Text = Box4Return
                end
            end
        end
    end

    print("~ Final ~")

    print(Box1Text)
    print(Box2Text)
    print(Box3Text)
    print(Box4Text)

    if Settings["FillEmptyBoxes"] == true then
        if Box1Text == "" then
            Box1Text = Box2Text
            Box2Text = Box3Text
            Box3Text = Box4Text
            Box4Text = ""
        end
        if Box2Text == "" then
            Box2Text = Box3Text
            Box3Text = Box4Text
            Box4Text = ""
        end
        if Box3Text == "" then
            Box3Text = Box4Text
            Box4Text = ""
        end
    end

    local DidItWork, Result = pcall(function()
        return CreateGui(Box1Text, Box2Text, Box3Text, Box4Text, Color)
    end)
    if DidItWork then
        Result.Parent = Character:FindFirstChild("Head")
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		if Humanoid then
			Humanoid.NameDisplayDistance = 0
		end
    else
        warn("PermSystem SimpleTitles GUI Error: ".. Result)
    end
end

return function(Config)
    if type(Config.Enabled) ~= "boolean" or Config.Enabled == false then return "SimpleTitles not enabled!" end

    -- Get on with the configuration!
    Settings.GuiViewDistance = 100
    if type(Config.GuiViewDistance) == "number" and Config.GuiViewDistance > 0 and Config.GuiViewDistance < 100000 then
        Settings.GuiViewDistance = Config.GuiViewDistance
    end

    Settings.FillEmptyBoxes = true
    if type(Config.FillEmptyBoxes) == "boolean" then
        Settings.FillEmptyBoxes = Config.FillEmptyBoxes
    end

    Settings.Font = Enum.Font.SourceSans
    if type(Config["Global:Font"]) == "string" then
        if Enum.Font[Config["Global:Font"]] ~= nil then
            Settings.Font = Enum.Font[Config["Global:Font"]]
        end
    end

    Settings.Color = ""
    if type(Config["Global:Color"]) == "string" then
        if Config["Global:Color"] == "TeamColor" or string.sub(Config["Global:Color"], 1, 11) == "RankLadder:" then
            Settings.Color = Config["Global:Color"]
        end
    end

    Settings["Box1:Text"] = "Username"
    if type(Config["Box1:Text"]) == "string" then
        local B1T = Config["Box1:Text"]
        if B1T == "Disabled" or B1T == "Username" or string.sub(B1T, 1, 8) == "SetText:" or string.sub(B1T, 1, 11) == "RankLadder:" then
            Settings["Box1:Text"] = B1T
        end
    elseif type(Config["Box1:Text"]) == "table" then
        local Tab = {}
        for Team, B1T in pairs(Config["Box1:Text"]) do
            if type(Team) == "string" and TS:FindFirstChild(Team) and type(B1T) == "string" and (B1T == "Disabled" or B1T == "Username" or string.sub(B1T, 1, 8) == "SetText:" or string.sub(B1T, 1, 11) == "RankLadder:") then
                Tab[Team] = B1T
            end
        end
        Settings["Box1:Text"] = Tab
    end

    Settings["Box2:Text"] = ""
    if type(Config["Box2:Text"]) == "string" then
        local B1T = Config["Box2:Text"]
        if B1T == "Disabled" or B1T == "Username" or string.sub(B1T, 1, 8) == "SetText:" or string.sub(B1T, 1, 11) == "RankLadder:" then
            Settings["Box2:Text"] = B1T
        end
    elseif type(Config["Box2:Text"]) == "table" then
        local Tab = {}
        for Team, B1T in pairs(Config["Box2:Text"]) do
            if type(Team) == "string" and TS:FindFirstChild(Team) and type(B1T) == "string" and (B1T == "Disabled" or B1T == "Username" or string.sub(B1T, 1, 8) == "SetText:" or string.sub(B1T, 1, 11) == "RankLadder:") then
                Tab[Team] = B1T
            end
        end
        Settings["Box2:Text"] = Tab
    end

    Settings["Box3:Text"] = ""
    if type(Config["Box3:Text"]) == "string" then
        local B1T = Config["Box3:Text"]
        if B1T == "Disabled" or B1T == "Username" or string.sub(B1T, 1, 8) == "SetText:" or string.sub(B1T, 1, 11) == "RankLadder:" then
            Settings["Box3:Text"] = B1T
        end
    elseif type(Config["Box3:Text"]) == "table" then
        local Tab = {}
        for Team, B1T in pairs(Config["Box3:Text"]) do
            if type(Team) == "string" and TS:FindFirstChild(Team) and type(B1T) == "string" and (B1T == "Disabled" or B1T == "Username" or string.sub(B1T, 1, 8) == "SetText:" or string.sub(B1T, 1, 11) == "RankLadder:") then
                Tab[Team] = B1T
            end
        end
        Settings["Box3:Text"] = Tab
    end

    Settings["Box4:Text"] = ""
    if type(Config["Box4:Text"]) == "string" then
        local B1T = Config["Box4:Text"]
        if B1T == "Disabled" or B1T == "Username" or string.sub(B1T, 1, 8) == "SetText:" or string.sub(B1T, 1, 11) == "RankLadder:" then
            Settings["Box4:Text"] = B1T
        end
    elseif type(Config["Box4:Text"]) == "table" then
        local Tab = {}
        for Team, B1T in pairs(Config["Box4:Text"]) do
            if type(Team) == "string" and TS:FindFirstChild(Team) and type(B1T) == "string" and (B1T == "Disabled" or B1T == "Username" or string.sub(B1T, 1, 8) == "SetText:" or string.sub(B1T, 1, 11) == "RankLadder:") then
                Tab[Team] = B1T
            end
        end
        Settings["Box4:Text"] = Tab
    end

    -- Add some sort of hook here
    wait(0.5) -- Wait for half a second for all the player datas to work
    for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
        plr.CharacterAdded:Connect(function(char)
            Run(plr, char)
        end)
    end
    game.Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function(char)
            Run(plr, char)
        end)
    end)

    -- Addon has loaded sucessfully
    return true
end
