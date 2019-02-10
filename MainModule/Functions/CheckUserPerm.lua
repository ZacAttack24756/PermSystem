--[[
	CheckUserPerm
    Checks if a user has a certian permission
	Params:
		PlayerObj	:	The Player in question (The Object)
		PermStr   	:	The Permission string
--]]

local DS = require(script.Parent.Parent.Services.DataStore)
local Http = game:GetService("HttpService")

local PlayerStore = DS.New("MysteryPermissions", "PlayerStore")

function ObjInArray(Array, Obj)
    for _, v in pairs(Array) do
        if v == Obj then
            return true
        end
    end
    return false
end
function CheckDescendantsForPerm(Groups, GroupName, Permission)
    local Previous = {}
    local function Loop(GN, P)
        local TargetGroup = Groups[GN]
        if type(TargetGroup) == "table" then
            local CheckThis = TargetGroup:GroupHasPerm(Permission)
            if CheckThis == true then
                return true
            else
                local Result = false
                for _, v in pairs(rawget(TargetGroup, "Inheritance")) do
                    if ObjInArray(Previous, v) == false and type(Groups[v]) == "table" then
                        table.insert(Previous, v)
                        Result = Result or Loop()
                    end
                end
                return Result
            end
        end
    end

    return Loop(GroupName, Permission)
end

return function(Groups, PlayerObj, PermStr)
    -- Checks the Player
    if type(PlayerObj) ~= "userdata" then return nil end
    if PlayerObj:IsA("Player") == "false" then return nil end
    local PlayerId = PlayerObj.UserId

    -- Checks the Permission with the Standard Pattern
    local Found = string.match(PermStr, "[%.(%w*|%*)]*")
    if type(Found) ~= "string" or Found == "" then return nil end

    -- Gets Player Data
    local PlayerData = PlayerStore:GetData(tostring(PlayerId))
    if type(PlayerData) ~= "string" or PlayerData == "" then
        PlayerData = {Groups = {}}
    else
        PlayerData = Http:JSONDecode(PlayerData)
    end

    -- Finally, Checks all the Groups and it's Decendants
    local Result = false
    for _, v in pairs(PlayerData.Groups) do
        Result = Result or CheckDescendantsForPerm(Groups, v, Found)
    end
    return Result
end
