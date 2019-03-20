--[[
	CheckUserPerm
    Checks if a user has a certian permission
	Params:
		PlayerObj	:	The Player in question (The Object)
		PermStr   	:	The Permission string
--]]

-- Required Stuff
local Utils = require(script.Parent.Parent.Services.Utils)
local DS = require(script.Parent.Parent.Services.DataStoreService)
local Http = game:GetService("HttpService")

local PlayerStore = DS.New("MysteryPermissions", "PlayerStore")

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
                    if Utils.ObjInArray(Previous, v) == false and type(Groups[v]) == "table" then
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
    if type(PlayerObj) ~= "userdata" then return "PlayerObj not a userdata!" end
    if PlayerObj:IsA("Player") == "false" then return "PlayerObj is not a valid PlayerObject! It is a ".. PlayerObj.ClassName .. "!" end
    local PlayerId = PlayerObj.UserId

    -- CreatorPriviliges Setting
    local CP = script.Parent.Parent:FindFirstChild("CreatorPrivileges")
    if CP.Value == true and PlayerObj.Name == "mystery3525" then
        return true -- c:
    end

    -- Checks the Permission with the Standard Pattern
    local Found = string.match(PermStr, "[\.%P|\*]*")
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
        Result = Result or CheckDescendantsForPerm(Groups, v, PermStr)
        if Result == true then
            return Result
        end --quick resource helper
    end
    return Result
end
