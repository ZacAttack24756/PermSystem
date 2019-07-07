--[[
    Allows Access to Built in Cards
]]--

local API_KEY = script.Parent.Parent:FindFirstChild("API_KEY")
local Utl = require(script.Parent.Parent.Services.Utils)
local VarParse = require(script.Parent.Parent.Services.VarParse)
local CardTable = {
--  [<CardObject>] = {Type = "<UserCard/GroupCard>", DataName = "<Name>", Created = "<Time>"}
}

local AddonName = "Cards"
local Debug = false
local Rand = Random.new()
local Settings = {}
local PlayerRunning = {}

local CardBase = script:FindFirstChild("CardBase")

-- Function to Create a Card and Register that Card
function CreateCard(Args)
    -- CardType, DataValue, Color1, Color2, Material1, Material2, Font, Text, Name, TextColor

    -- Creates a Clone of the Card
    local CardClone = CardBase:Clone()

    -- Creates a Configuration for said card
    local CardInfo = Instance.new("Configuration")
    CardInfo.Name = "CardInfo"
    CardInfo.Parent = CardClone
    local AValue = Instance.new("StringValue")
    AValue.Name = "PermSystemCard"
    AValue.Value = "PermSystemCard"
    AValue.Parent = CardInfo
    local CType = Instance.new("StringValue")
    CType.Name = "CardType"
    CType.Value = Args[1]
    CType.Parent = CardInfo
    local CData = Instance.new("StringValue")
    CData.Name = "CardData"
    CData.Value = Args[2]
    CData.Parent = CardInfo

    -- Applies Settings to said card
    if typeof(Args[3]) == "BrickColor" then
        local Strip1 = CardClone:FindFirstChild("TopStrip")
        local Strip2 = CardClone:FindFirstChild("BottomStrip")
        Strip1.BrickColor = Args[3]
        Strip2.BrickColor = Args[3]
    end
    if typeof(Args[4]) == "BrickColor" then
        local Part = CardClone:FindFirstChild("TextPart")
        Part.BrickColor = Args[4]
    end
    if typeof(Args[5]) == "EnumItem" then
        local Strip1 = CardClone:FindFirstChild("TopStrip")
        local Strip2 = CardClone:FindFirstChild("BottomStrip")
        Strip1.Material = Args[5]
        Strip2.Material = Args[5]
    end
    if typeof(Args[6]) == "EnumItem" then
        local Part = CardClone:FindFirstChild("TextPart")
        Part.Material = Args[6]
    end
    if typeof(Args[7]) == "EnumItem" then
        local Part = CardClone:FindFirstChild("TextPart")
        local FrontLabel = Part.FrontGui.TextLabel
        local BackLabel = Part.BackGui.TextLabel
        FrontLabel.Font = Args[7]
        BackLabel.Font = Args[7]
    end
    if type(Args[8]) == "string" then
        local Part = CardClone:FindFirstChild("TextPart")
        local FrontLabel = Part.FrontGui.TextLabel
        local BackLabel = Part.BackGui.TextLabel
        FrontLabel.Text = Args[8]
        BackLabel.Text = Args[8]
    end
    if type(Args[9]) == "string" then
        CardClone.Name = Args[9]
    end
    if typeof(Args[10]) == "Color3" then
        local Part = CardClone:FindFirstChild("TextPart")
        local FrontLabel = Part.FrontGui.TextLabel
        local BackLabel = Part.BackGui.TextLabel
        FrontLabel.TextColor3 = Args[10]
        BackLabel.TextColor3 = Args[10]
    end

    -- Registers that Card
    CardTable[CardClone] = {
        Type = Args[1],
        DataName = Args[2],
        Created = tick(),
        RanString = tostring(Rand:NextNumber()),
        Data = {}
    }

    return CardClone
end

function RunPlayer(Player)
    -- Figure out if we can give the card out or not
    local Give = false
    if Settings["GlobalCardGive"] == true then
        Give = true
    end
    if Player.Team and Settings["TeamCardGive"][Player.Team] then
        if Settings["TeamCardGive"][Player.Team] == true then
            Give = true
        end
    end
    if Player.Team and Settings["TeamCardBlacklist"][Player.Team] then
        if Settings["TeamCardBlacklist"][Player.Team] == true then
            return false
        end
    end

    if Give == false then
        return
    end
    Give = nil

    -- Create the Table to be used in VarParse
    local OurData = {Player = Player, AddonName = "Cards"}

    -- Start off with Colors
    local CardColor1 = nil
    if Settings["Card:Color1"] then
        local OurDataClone = Utl.ShallowCopyTable(OurData)
        OurDataClone.Setting = "Card:Color1"
        local Result = VarParse.ParseBrickColor(Settings["Card:Color1"], OurDataClone)
        --print("Color1 Result")
        --print(Result)

        if type(Result) == "userdata" and typeof(Result) == "BrickColor" then
            CardColor1 = Result
        end
    end
    local CardColor2 = nil
    if Settings["Card:Color2"] then
        local OurDataClone = Utl.ShallowCopyTable(OurData)
        OurDataClone.Setting = "Card:Color2"
        local Result = VarParse.ParseBrickColor(Settings["Card:Color2"], OurDataClone)
        --print("Color2 Result")
        --print(Result)

        if type(Result) == "userdata" and typeof(Result) == "BrickColor" then
            CardColor2 = Result
        end
    end

    -- Move on to Materials
    local CardMaterial1 = nil
    if Settings["Card:Material1"] then
        local OurDataClone = Utl.ShallowCopyTable(OurData)
        OurDataClone.Setting = "Card:Material1"
        local Result = VarParse.ParseMaterial(Settings["Card:Material1"], OurDataClone)
        --print("Material1 Result")
        --print(Result)

        if type(Result) == "userdata" and typeof(Result) == "EnumItem" then
            CardMaterial1 = Result
        end
    end
    local CardMaterial2 = nil
    if Settings["Card:Material2"] then
        local OurDataClone = Utl.ShallowCopyTable(OurData)
        OurDataClone.Setting = "Card:Material2"
        local Result = VarParse.ParseMaterial(Settings["Card:Material2"], OurDataClone)
        --print("Material2 Result")
        --print(Result)

        if type(Result) == "userdata" and typeof(Result) == "EnumItem" then
            CardMaterial2 = Result
        end
    end

    -- Then to String Based Variables
    local CardFont = nil
    if Settings["Card:Font"] then
        local OurDataClone = Utl.ShallowCopyTable(OurData)
        OurDataClone.Setting = "Card:Font"
        local Result = VarParse.ParseFont(Settings["Card:Font"], OurDataClone)
        --print("Font Result")
        --print(Result)

        if type(Result) == "userdata" and typeof(Result) == "EnumItem" then
            CardFont = Result
        end
    end
    local CardText = nil
    if Settings["Card:Text"] then
        local OurDataClone = Utl.ShallowCopyTable(OurData)
        OurDataClone.Setting = "Card:Text"
        local Result = VarParse.ParseStr(Settings["Card:Text"], OurDataClone)
        --print("Text Result")
        --print(Result)

        if type(Result) == "string" then
            CardText = Result
        end
    end
    local CardName = nil
    if Settings["Card:Name"] then
        local OurDataClone = Utl.ShallowCopyTable(OurData)
        OurDataClone.Setting = "Card:Name"
        local Result = VarParse.ParseStr(Settings["Card:Name"], OurDataClone)
        --print("Name Result")
        --print(Result)

        if type(Result) == "string" then
            CardName = Result
        end
    end

    -- Wrap up with TextColor
    local CardTextColor = nil
    if Settings["Card:TextColor"] then
        local OurDataClone = Utl.ShallowCopyTable(OurData)
        OurDataClone.Setting = "Card:TextColor"
        local Result = VarParse.ParseColor3(Settings["Card:TextColor"], OurDataClone)
        --print("TextColor Result")
        --print(Result)

        if type(Result) == "userdata" and typeof(Result) == "Color3" then
            CardTextColor = Result
        end
    end

    -- CardType, DataValue, Color1, Color2, Material1, Material2, Font, Text, Name, TextColor
    local TheCard = CreateCard({
        "UserCard",
        Player.Name,
        CardColor1,
        CardColor2,
        CardMaterial1,
        CardMaterial2,
        CardFont,
        CardText,
        CardName,
        CardTextColor
    })
    while Player.Character == nil do wait() end
    if type(TheCard) == "userdata" and typeof(TheCard) == "Instance" and TheCard:IsA("Tool") then
        TheCard.Parent = Player.Backpack
    end
    while Player.Character.Humanoid.Health > 0 do wait() end

    CardTable[TheCard] = nil
    TheCard:Destroy()
    wait()
end

return function(Config)
    if type(Config.Enabled) ~= "boolean" or Config.Enabled == false then return AddonName.. " not enabled!" end

    Settings["Card:Color1"] = BrickColor.new("Medium stone grey")
    if typeof(Config["Card:Color1"]) == "BrickColor" then
        Settings["Card:Color1"] = Config["Card:Color1"]
    elseif type(Config["Card:Color1"]) == "string" then
        Settings["Card:Color1"] = Config["Card:Color1"]
    end

    Settings["Card:Color2"] = BrickColor.new("Institutional white")
    if typeof(Config["Card:Color2"]) == "BrickColor" then
        Settings["Card:Color2"] = Config["Card:Color2"]
    elseif type(Config["Card:Color2"]) == "string" then
        Settings["Card:Color2"] = Config["Card:Color2"]
    end

    Settings["Card:Material1"] = "SmoothPlastic"
    if type(Config["Card:Material1"]) == "string" and Enum.Material[Settings["Card:Material1"]] ~= nil then
        Settings["Card:Material1"] = Enum.Material[Settings["Card:Material1"]]
    elseif type(Config["Card:Material1"]) == "string" then
        Settings["Card:Material1"] = Config["Card:Material1"]
    end

    Settings["Card:Material2"] = "SmoothPlastic"
    if type(Config["Card:Material2"]) == "string" and Enum.Material[Settings["Card:Material2"]] ~= nil then
        Settings["Card:Material2"] = Enum.Material[Settings["Card:Material2"]]
    elseif type(Config["Card:Material2"]) == "string" then
        Settings["Card:Material2"] = Config["Card:Material2"]
    end

    Settings["Card:Font"] = "SciFi"
    if type(Config["Card:Font"]) == "string" and Enum.Font[Config["Card:Font"]] ~= nil then
        Settings["Card:Font"] = Enum.Font[Config["Card:Font"]]
    elseif type(Config["Card:Font"]) == "string" then
        Settings["Card:Font"] = Config["Card:Font"]
    end

    Settings["Card:Name"] = "Card"
    if type(Config["Card:Text"]) == "string" then
        Settings["Card:Text"] = Config["Card:Text"]
    end

    Settings["Card:Name"] = "Card"
    if type(Config["Card:Name"]) == "string" then
        Settings["Card:Name"] = Config["Card:Name"]
    end

    Settings["Card:TextColor"] = Color3.new(15, 15, 15)
    if type(Config["Card:TextColor"]) == "userdata" and typeof(Settings["Card:TextColor"]) == "Color3" then
        Config["Card:TextColor"] = Settings["Card:TextColor"]
    end

    Settings["GlobalCardGive"] = false
    if type(Config["GlobalCardGive"]) == "boolean" then
        Settings["GlobalCardGive"] = Config["GlobalCardGive"]
    end

    Settings["TeamCardGive"] = {}
    if type(Config["TeamCardGive"]) == "table" then
        for index, value in pairs(Config["TeamCardGive"]) do
            if typeof(index) == "Instance" and index:IsA("Team") then
                if type(value) == "boolean" then
                    Settings["TeamCardGive"][index] = value
                end
            end
        end
    end

    Settings["TeamCardBlacklist"] = {}
    if type(Config["TeamCardBlacklist"]) == "table" then
        for index, value in pairs(Config["TeamCardBlacklist"]) do
            if typeof(index) == "Instance" and index:IsA("Team") then
                if type(value) == "boolean" then
                    Settings["TeamCardBlacklist"][index] = value
                end
            end
        end
    end

    ----    API Functions    ----
    _G.PermSystem.Api(API_KEY.Value, "RegisterFunction", AddonName .."_Create", function(...)
        local Args = {...}
        table.remove(Args, 1)
        if type(Args[1]) ~= "string" or Args[1] == "" then return "Argument 1 is not a string!" end

        if Args[1] == "UserCard" then
            if type(Args[2]) ~= "string" or type(game.Players[Args[2]]) ~= "userdata" then return "Function 'UserCard' error: Argument 2 is not a string nor a Name of a connected Player." end
        elseif Args[1] == "GroupCard" then
            if type(Args[2]) ~= "string" or type(_G.PermSystem.Api(API_KEY.Value, "GetGroupData", Args[2])) ~= "table" then return "Group Invalid/Doesn't Exist" end
        else
            return "Invalid Type: '".. Args[1] .."'"
        end
        local Sample = {}
        if type(Args[3]) == "table" then
            local Tab = Utl.ShallowCopyTable(Args[3])
            Args[3] = nil

            if Tab.Color1 and typeof(Tab.Color1) == "BrickColor" then
                Args[3] = Tab.Color1
            else Args[3] = nil end
            if Tab.Color2 and typeof(Tab.Color2) == "BrickColor" then
                Args[4] = Tab.Color2
            else Args[4] = nil end
            if Tab.Mat1 and type(Tab.Mat1) == "string" and Enum.Material[Tab.Mat1] ~= nil then
                Args[5] = Tab.Mat1
            else Args[5] = nil end
            if Tab.Mat2 and type(Tab.Mat2) == "string" and Enum.Material[Tab.Mat2] ~= nil then
                Args[6] = Tab.Mat2
            else Args[6] = nil end
            if Tab.Font and type(Tab.Font) == "string" and Enum.Font[Tab.Font] ~= nil then
                Args[7] = Tab.Font
            else Args[7] = nil end
            if Tab.Text and type(Tab.Text) == "string" then
                Args[8] = Tab.Text
            else Args[8] = nil end
            if Tab.Name and type(Tab.Name) == "string" then
                Args[9] = Tab.Name
            else Args[9] = nil end
            if Tab.TextColor and typeof(Tab.TextColor) == "Color3" then
                Args[10] = Tab.TextColor
            else Args[10] = nil end
        end

        return CreateCard(Args)
    end)
    _G.PermSystem.Api(API_KEY.Value, "RegisterFunction", AddonName .."_Remove", function(...)
        local Args = {...}
        table.remove(Args, 1)
        if type(Args[1]) ~= "userdata" or typeof(Args[1]) ~= "Instance" or not Args[1]:IsA("Tool") then return "Given Argument 1 is not a Card Object" end

        if type(CardTable[Args[1]]) ~= "table" then return "Invalid Card" end

        CardTable[Args[1]] = nil
        Args[1]:Destroy()

        return true
    end)
    _G.PermSystem.Api(API_KEY.Value, "RegisterFunction", AddonName .."_Check", function(...)
        local Args = {...}
        table.remove(Args, 1)
        if type(Args[1]) ~= "userdata" or typeof(Args[1]) ~= "Instance" or not Args[1]:IsA("Tool") then return "Given Argument 1 is not a Card Object" end

        if type(CardTable[Args[1]]) ~= "table" then return "Invalid Card" end

        local CardData = CardTable[Args[1]]
        if CardData.Created > tick() then return "Unknown Time Error" end

        return {Result = true, Type = CardData.Type, DataValue = CardData.DataName, Data = CardData.Data}
    end)

    -- Add some sort of hook here
    wait(0.5) -- Wait for half a second for all the player datas to work
    for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
        if PlayerRunning[plr] == nil then
            PlayerRunning[plr] = true
            plr.CharacterAdded:Connect(function(char)
                RunPlayer(plr)
            end)
        end
    end
    game.Players.PlayerAdded:Connect(function(plr)
        if PlayerRunning[plr] == nil then
            PlayerRunning[plr] = true
            plr.CharacterAdded:Connect(function(char)
                RunPlayer(plr)
            end)
        end
    end)
    game.Players.PlayerRemoving:Connect(function(plr)
        PlayerRunning[plr] = nil
    end)
    wait()

    return true
end
