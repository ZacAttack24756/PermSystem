--[[
	CheckPerm
    Checks if a user has a certian permission
	Params:
        Groups      :   A Table containing all the current groups
        Type        :   The Type of Object to check (Users or Groups)
        Target  	:	The Player(Object)/Group in question
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
            if TargetGroup:GroupHasPerm(Permission) then
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

return function(Groups, Type, ...)
    if Type == "User" then
        local Args = {...}

        local PlayerObj = Args[1]
        local PermStr = Args[2]
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
        if type(Found) ~= "string" or Found == "" then return "No Permission String Found" end

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
    elseif Type == "Group" then
        local Args = {...}

        local TargetGroup = Args[1]
        local PermStr = Args[2]

        -- Type Checks
        if type(TargetGroup) ~= "string" or TargetGroup == "" then return "Given Group is not a string!" end
        if type(PermStr) ~= "string" or PermStr == "" then return "Given Permission String is not a string!" end

        -- Checks the Permission with the Standard Pattern
        local Found = string.match(PermStr, "[\.%P|\*]*")
        if type(Found) ~= "string" or Found == "" then return "Misformed Permission String!" end

        local Result = false
        Result = CheckDescendantsForPerm(Groups, TargetGroup, PermStr)
        return Result
    end
end
