--[[
	RefUser
    Refreshes a User's Permissions
	Params:
        Groups      :   An Array of Valid Groups
		PlayerObj	:	The Player in question (The Object)
--]]

-- Required Stuff
local Utils = require(script.Parent.Parent.Services.Utils)
local DS = require(script.Parent.Parent.Services.DataStoreService)
local Http = game:GetService("HttpService")

--local Settings = DS.New("MysteryPermissions", "Settings")
local PlayerStore = DS.New("MysteryPermissions", "PlayerStore")

return function(Groups, PlayerObj)
    local PlayerId = PlayerObj.UserId

    local PlayerData = PlayerStore:GetData(tostring(PlayerId))
    if type(PlayerData) ~= "string" or PlayerData == "" then
        PlayerData = {Groups = {}, PrimaryGroup = ""}
    else
        PlayerData = Http:JSONDecode(PlayerData)
    end

    -- Adds/Removes Groups Based on Conditions
    for _, G in pairs(Groups) do
        if type(G) == "table" then
            local Result = G:PlayerBelongsInGroup(PlayerObj)
            if Result == false then
                local Index = Utils.GetArrayIndex(PlayerData.Groups, rawget(G, "Name"))
                if Index then table.remove(PlayerData.Groups, Index) end
            elseif Result == true then
                if Utils.ObjInArray(PlayerData.Groups, rawget(G, "Name")) == false then
                    table.insert(PlayerData.Groups, rawget(G, "Name"))
                end
            end
        end
    end

    wait(0.25)
    -- Removing Ranks that are not on the Ladder
    local RLadders = {}
    for _, v in pairs(PlayerData.Groups) do
        local G = Groups[v]
        if type(G) == "table" then -- Note to self, Check if metatables return as table <----------------------
            local Rank = rawget(G, "Rank")
            local Ladder = rawget(G, "RankLadder")
            if type(RLadders[Ladder]) ~= table then
                RLadders[Ladder] = {}
            end
            RLadders[Ladder][Rank] = rawget(G, "Name")
        end
    end
    for _, v1 in pairs(RLadders) do
        local max = 0
        if type(v1) == "table" then
            -- First Pass idendifies the largest in the ranking ladder
            for i2, v2 in pairs(v1) do
                if i2 > max then
                    max = i2
                end
            end
            -- Second Pass Flags any ones that isn't the maximum
            for i2, v2 in pairs(v1) do
                local TabIndex = Utils.GetArrayIndex(PlayerData)
                if i2 ~= max and type(TabIndex) == "number" then
                    table.remove(PlayerData.Groups, TabIndex)
                end
            end
        end
    end
    RLadders = nil -- A little clean up

    local Max = -1 * math.huge
    local MaxGroup = ""
    for _, v in pairs(PlayerData.Groups) do
        local TargetGroup = Groups[v]
        if TargetGroup.Options.Priority > Max then
            Max = TargetGroup.Options.Priority
            MaxGroup = v
        end
    end
    PlayerData.PrimaryGroup = MaxGroup

    -- Finally, Publish it
    local Encode = Http:JSONEncode(PlayerData)
    PlayerStore:SetData(tostring(PlayerId), Encode)

    return PlayerData
end
