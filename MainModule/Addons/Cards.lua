--[[
    Allows Access to Built in Cards
]]--

local API_KEY = script.Parent.Parent:FindFirstChild("API_KEY")
--local Utl = require(script.Parent.Parent.Services.Utils)
local CardTable = {
--  [<CardObject>] = {Type = "<UserCard/GroupCard>", DataName = "<Name>", Created = "<Time>"}
}

local AddonName = "Cards"
local Debug = false
local Rand = Random.new()

-- Tweaked from SimpleTitles
function LocateGroupAddonInfo(PlayerData, RankLadder)
    local RankLadderGroups = _G.PermSystem.Api(ApiKey.Value, "GetRankLadderGroups", RankLadder)

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
                local Info = _G.PermSystem.Api(ApiKey.Value, "GetGroupData", v1)
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
function CreateCard(...)
    local Args = {...}

    local Card = Instance.new("Tool")
    Card.Name = "Card"

    local Handle = Instance.new("Part")
    Handle.Name = "Handle"
    Handle.Parent = Card

    local CardInfo = Instance.new("Configuration")
    CardInfo.Name = "CardInfo"
    CardInfo.Parent = Card

    local CType = Instance.new("StringValue")
    CType.Name = "CardType"
    CType.Parent = CardInfo
    CType.Value = Args[1]

    local CData = Instance.new("StringValue")
    CData.Name = "CardData"
    CData.Parent = CardInfo
    CData.Value = Args[2]

    CardTable[Card] = {
        Type = Args[1],
        DataName = Args[2],
        Created = tick(),
        RanString = tostring(Rand:NextNumber())
        Data = {}
    }
end

return function()
    if type(Config.Enabled) ~= "boolean" or Config.Enabled == false then return AddonName.. " not enabled!" end

    _G.PermSystem.Api(ApiKey.Value, "RegisterFunction", AddonName .."_Create", function(...)
        local Args = {...}
        if type(Args[1]) ~= "string" or Args[1] == "" then return "Argument 1 is not a string!" end

        if Args[1] == "UserCard" then
            if type(Args[2]) ~= "string" or type(game.Players[Args[2]]) ~= "userdata" then return "Function 'UserCard' error: Argument 2 is not a string nor a Name of a connected Player." end

            return CreateCard("UserCard", Args[2])
        elseif Args[1] == "GroupCard" then
            if type(Args[2]) ~= "string" or type(_G.ApiKey.Value, "GetGroupData", Args[2]) ~= "table" then return "Group Invalid/Doesn't Exist" end

            return CreateCard("GroupCard", Args[2])
        end

        return nil
    end)
    _G.PermSystem.Api(ApiKey.Value, "RegisterFunction", AddonName .."_Remove", function(...)
        local Args = {...}
        if type(Args[1]) ~= "userdata" or typeof(Args[1]) ~= "Tool" then return "Given Argument 1 is not a Card Object" end

        if type(CardTable[Args[1]]) ~= "table" then return "Invalid Card" end

        CardData[Args[1]] = nil
        Args[1]:Destroy()

        return true
    end)
    _G.PermSystem.Api(ApiKey.Value, "RegisterFunction", AddonName .."_Check", function(...)
        local Args = {...}
        if type(Args[1]) ~= "userdata" or typeof(Args[1]) ~= "Tool" then return "Given Argument 1 is not a Card Object" end

        if type(CardTable[Args[1]]) ~= "table" then return "Invalid Card" end

        local CardData = CardTable[Args[1]]
        if CardData.Created > tick() then return "Unknown Time Error" end

        return {Result = true, Type = CardData.Type, DataValue = CardData.DataName}
    end)
end
