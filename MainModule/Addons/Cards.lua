--[[
    Allows Access to Built in Cards
]]--

local API_KEY = script.Parent.Parent:FindFirstChild("API_KEY")
local Utl = require(script.Parent.Parent.Services.Utils)
local CardTable = {
--  [<CardObject>] = {Type = "<UserCard/GroupCard>", DataName = "<Name>", Created = "<Time>"}
}

local AddonName = "Cards"
local Debug = false
local Rand = Random.new()

local CardBase = script:FindFirstChild("CardBase")

-- Tweaked from SimpleTitles
function LocateGroupAddonInfo(PlayerData, RankLadder)
    local RankLadderGroups = _G.PermSystem.Api(API_KEY.Value, "GetRankLadderGroups", RankLadder)

    if Debug==true then print("PlayerData")
                        print(PlayerData)
                        print("PlayerData.Groups")
                        for i, v in pairs(PlayerData.Groups) do print(i) print(v) end
                        print("RankLadder")
                        print(RankLadder)

                        print("RankLadderGroups")
                        for i, v in pairs(RankLadderGroups) do print(i) print(v) end
                        print("----------------")
                        print("PlayerData.Groups Start") end
    for _, v1 in pairs(PlayerData.Groups) do
        if Debug==true then print("PlayerGroup Check")
                            print(" ".. v1) end
        for _, v2 in pairs(RankLadderGroups) do
            if Debug== true then print("  ".. v2) end
            if v1 == v2 then
                if Debug==true then print("   Success! '".. v1 .."' and '".. v2 .."'") end
                local Info = _G.PermSystem.Api(API_KEY.Value, "GetGroupData", v1)
                if Debug==true then print("   GroupData")
                                    print(Info)
                                    print(Info.Addons)
                                    print(Info.Addons[AddonName]) end
                if type(Info) == "table" and type(Info.Addons) == "table" then
                    if type(Info.Addons[AddonName]) == "table" then
                        return Info.Addons[AddonName]
                    end
                end
            end
        end
    end
    return "No Matches"
end

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
    if type(Args[5]) == "string" then
        local Strip1 = CardClone:FindFirstChild("TopStrip")
        local Strip2 = CardClone:FindFirstChild("BottomStrip")
        Strip1.Material = Args[5]
        Strip2.Material = Args[5]
    end
    if type(Args[6]) == "string" then
        local Part = CardClone:FindFirstChild("TextPart")
        Part.Material = Args[6]
    end
    if type(Args[7]) == "string" then
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
        Data = Args[3]
    }

    return CardClone
end

return function(Config)
    if type(Config.Enabled) ~= "boolean" or Config.Enabled == false then return AddonName.. " not enabled!" end
    --[[if typeof(Config["Card:Color1"]) == "BrickColor" then
    elseif type(Config["Card:Color1"]) == "string" and (Config["Card:Color1"] == "TeamColor" or string.sub(Config["Card:Color1"], 1, 10) == "RankLadder:") then
    else Config["Card:Color1"] = BrickColor.new("Smokey grey") end]]

    _G.PermSystem.Api(API_KEY.Value, "RegisterFunction", AddonName .."_Create", function(...)
        local Args = {...}
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
            local Tab = Utl.CopyTable(Args[3])
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
        if type(Args[1]) ~= "userdata" or typeof(Args[1]) ~= "Tool" then return "Given Argument 1 is not a Card Object" end

        if type(CardTable[Args[1]]) ~= "table" then return "Invalid Card" end

        CardTable[Args[1]] = nil
        Args[1]:Destroy()

        return true
    end)
    _G.PermSystem.Api(API_KEY.Value, "RegisterFunction", AddonName .."_Check", function(...)
        local Args = {...}
        if type(Args[1]) ~= "userdata" or typeof(Args[1]) ~= "Tool" then return "Given Argument 1 is not a Card Object" end

        if type(CardTable[Args[1]]) ~= "table" then return "Invalid Card" end

        local CardData = CardTable[Args[1]]
        if CardData.Created > tick() then return "Unknown Time Error" end

        return {Result = true, Type = CardData.Type, DataValue = CardData.DataName, Data = CardData.Data}
    end)
end
