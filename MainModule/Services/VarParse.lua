--[[
    VarParse.lua
    -> A Parser for filling in variables such as {USERNAME} or {TEAMNAME}
    -> Might impliment this into other addons besides Cards in the future
]]--
local API_KEY = script.Parent.Parent:FindFirstChild("API_KEY")
local Utl = require(script.Parent.Utils)

function LocateGroupAddonInfo(AddonName, PlayerData, RankLadder)
    -- We need to find out what groups are in the RankLadder
    local RankLadderGroups = _G.PermSystem.Api(API_KEY.Value, "GetRankLadderGroups", RankLadder)

    -- Now we need to find the group this player is in in that RankLadder
    for _, v1 in pairs(PlayerData.Groups) do
        for _, v2 in pairs(RankLadderGroups) do
            if v1 == v2 then
                -- If the player has a group in the RankLadder, Grab the info of that group
                local Info = _G.PermSystem.Api(API_KEY.Value, "GetGroupData", v1)
                -- If the group exists and has Addon Settings
                if type(Info) == "table" and type(Info.Addons) == "table" then
                    -- If the Group has Settings for this specific addon, return
                    if type(Info.Addons[AddonName]) then
                        return Info.Addons[AddonName]
                    end
                end
            end
        end
    end
    return nil
end

function ReturnFunction(String, Data)
--[[
    Data = {
        Player = <PlayerObject>,
        AddonName = "<NameOfAddon>",
        PlayerGroups = {<PlayerGroups>,...},
        Setting = "<SettingName>",
        Loop = <true/false>,
    }
]]--
    if string.find(String, "{DISABLED}") then
        return false -- The Item is disabled, return false
    end

    -- Player Based Variables (  {USERNAME} and {TEAMNAME}  )
    if Data.Player then
        String = string.gsub(String, "{USERNAME}", Data.Player.Name)

        if Data.Player.Team then
            String = string.gsub(String, "{TEAMNAME}", Data.Player.Team.Name)
        else
            String = string.gsub(String, "{TEAMNAME}", "")
        end
    else
        String = string.gsub(String, "{USERNAME}", "")
    end

    -- {RBLXGROUPID:<GroupId>}
    if Data.Player then
        local Translate = {}
        for Part in string.gmatch(String, "({RBLXGROUPID:)(.*)?\}") do
            local ID = string.sub(Part, 14, (string.len(String) - 1))
            -- Only bother if this hasn't been translated before
            if not Translate[Part] then
                if type(tonumber(ID)) == "number" then
                    local ProperlyRan, PcallReturn = pcall(function()
                        return Player:GetRoleInGroup(tonumber(ID))
                    end)
                    if ProperlyRan then
                        Translate[Part] = PcallReturn
                    else
                        warn("PermSystem VarPars GetRoleInGroup Error: ".. PcallReturn)
                    end
                end
            end
        end

        -- Now, we can convert everything we know
        for Target, ConvertTo in pairs(Translate) do
            String = string.gsub(String, Target, ConvertTo)
        end
    end

    -- {RANKLADDER:<Ladder>}
    if Data.Player and Data.AddonName and Data.Setting and Data.Loop ~= true then
        -- We need to get the player's data
        local PlayerData = _G.PermSystem.Api(API_KEY.Value, "GetPlrData", Data.Player)

        if type(PlayerData) == "string" then
            warn("VarParse #1 GetPlrData Error for ".. Data.Player.Name ..", :".. PlayerData)
        end
        if type(PlayerData) == "nil" then
            wait(0.5)
            PlayerData = _G.PermSystem.Api(API_KEY.Value, "GetPlrData", Data.Player)
        end
        if type(PlayerData) == "string" then
            warn("VarParse #2 GetPlrData Error for ".. Data.Player.Name ..", :".. PlayerData)
        end

        -- Only if we successfully get the player's Data then we can proceed
        if type(PlayerData) == "table" then
            local Translate = {}
            for Part in string.gmatch(String, "({RANKLADDER:)(.*)?\}") do
                -- Its a good idea to have the name of the RankLadder
                local RankLadder = string.sub(Part, 13, (string.len(Part) - 1))
                -- Only bother if this hasn't been Translated Before
                if not Translate[Part] then
                    local AddonInfo = LocateGroupAddonInfo(Data.AddonName, PlayerData, RankLadder)

                    -- Only if we successfully get the AddonInfo
                    if type(AddonInfo) == "table" then
                        if type(AddonInfo[Data.Setting]) == "string" then
                            local TheTable = Utl.deepCopy(Data)
                            TheTable.Loop = true
                            Translate[Part] = ReturnFunction(AddonInfo[Data.Setting], TheTable)
                            -- If the Addon Setting turns out to be false
                            if Translate[Part] == false then
                                return false
                            end
                        end
                    end
                end
            end

            -- Now we change it
            for Target, ConvertTo in pairs(Translate) do
                String = string.gsub(String, Target, ConvertTo)
            end
        end
    end

    --print("ok")
    return String
end

return ReturnFunction
