--[[
    VarParse.lua
    -> A Parser for filling in variables such as {USERNAME} or {TEAMNAME}
    -> Might impliment this into other addons besides Cards in the future
]]--
local API_KEY = script.Parent.Parent:FindFirstChild("API_KEY")
local Utl = require(script.Parent.Utils)

local Return = {}

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
Return.LocateGroupAddonInfo = LocateGroupAddonInfo

function RegexSafe(String)
    String = string.gsub(String, "(\$)", "\$")
    String = string.gsub(String, "(\%)", "\%")
    String = string.gsub(String, "(\^)", "\^")
    String = string.gsub(String, "(\*)", "\*")
    String = string.gsub(String, "\\\(", "\(")
    String = string.gsub(String, "\\\)", "\)")
    String = string.gsub(String, "\\\.", "\.")
    String = string.gsub(String, "[\[]", "\[")
    String = string.gsub(String, "[\]]", "\]")
    String = string.gsub(String, "(\+)", "\+")
    String = string.gsub(String, "(\-)", "\-")
    String = string.gsub(String, "(\?)", "\?")
    return String
end

function RankLadderFunction(Setting, Data, LoopFunc)
    --print("RankLadder Lookup on '".. Setting .."' for function:")
    --print(LoopFunc)
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

    if type(PlayerData) == "table" then
        -- Get the Ladder and AddonInfo
        local RankLadder = string.sub(Setting, 13, (string.len(Setting) - 1))
        local AddonInfo = LocateGroupAddonInfo(Data.AddonName, PlayerData, RankLadder)
        if type(AddonInfo) == "table" then
            if type(AddonInfo[Data.Setting]) == "string" or typeof(AddonInfo[Data.Setting]) == "BrickColor" then
                local TheTable = Utl.ShallowCopyTable(Data)
                TheTable.Loop = true
                return LoopFunc(AddonInfo[Data.Setting], TheTable)
            end
        end
    end
end
Return.RankLadderFunction = RankLadderFunction

-- This will only Parse String Settings
function FunctionStr(String, Data)
--[[
    Data = {
        Player = <PlayerObject>,
        AddonName = "<NameOfAddon>",
        Setting = "<SettingName>",
        Loop = <true/false>
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
        --print("String is: '".. String .."'")
        for Part in string.gmatch(String, "((\{RBLXGROUPID\:)(%d*)\})") do
            --print("  RBLXGROUPID is: '".. Part .."'")
            local ID = string.match(Part, "%d+")
            --print("  ~ID is: '".. ID .."' (".. type(ID) .."), type(tonumber(\"".. ID .."\")) is: '".. type(tonumber(ID)) .."'")
            -- Only bother if this hasn't been translated before
            if Translate[Part] == nil then
                --print("   Translate['".. Part .."'] is nil")
                if type(tonumber(ID)) == "number" then
                    --print("    ID is: '".. ID .."'")
                    local ProperlyRan, PcallReturn = pcall(function()
                        return Data.Player:GetRoleInGroup(tonumber(ID))
                    end)
                    if ProperlyRan then
                        Translate[Part] = RegexSafe(PcallReturn)
                    else
                        warn("PermSystem VarPars GetRoleInGroup Error: ".. PcallReturn)
                    end
                end
            end
        end

        -- Now, we can convert everything we know
        for Target, ConvertTo in pairs(Translate) do
            --print("Target: '".. Target .."', converting to :'".. ConvertTo .."'.")
            String = string.gsub(String, Target, ConvertTo)
        end
    end

    -- {RANKLADDER:<Ladder>}
    if Data.Player and Data.AddonName and Data.Setting and type(Data.Loop) == "nil" then
        -- We need to get the player's data
        local PlayerData = _G.PermSystem.Api(API_KEY.Value, "GetPlrData", Data.Player)
        --print("PlayerData")
        --print(PlayerData)

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
            for Part in string.gmatch(String, "((\{RANKLADDER\:)(%w*)\})") do
                --print(Part)
                -- Its a good idea to have the name of the RankLadder
                local RankLadder = string.sub(Part, 13, (string.len(Part) - 1))
                -- Only bother if this hasn't been Translated Before
                if not Translate[Part] then
                    local AddonInfo = LocateGroupAddonInfo(Data.AddonName, PlayerData, RankLadder)

                    -- Only if we successfully get the AddonInfo
                    if type(AddonInfo) == "table" then
                        if type(AddonInfo[Data.Setting]) == "string" then
                            local TheTable = Utl.ShallowCopyTable(Data)
                            TheTable.Loop = true
                            Translate[Part] = FunctionStr(AddonInfo[Data.Setting], TheTable)
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
                --print("Target: '".. Target .."', converting to :'".. ConvertTo .."'.")
                String = string.gsub(String, Target, ConvertTo)
            end
        end
    end

    --print("ok")
    return String
end
Return.ParseStr = FunctionStr



-- This will only Parse BrickColor Settings
function FunctionBrickColor(Setting, Data)
--[[
    Data = {
        Player = <PlayerObject>,
        AddonName = "<AddonName>",
        Setting = "<SettingName>",
        Loop = <true/false>
    }
]]--
    if type(Setting) == "string" and Setting == "{DISABLED}" then
        return false
    end

    -- If the Setting itself is a BrickColor
    if type(Setting) == "userdata" and typeof(Setting) == "BrickColor" then
        return Setting
    end

    if type(Setting) == "string" and Data.Player then
        if Setting == "{TEAMCOLOR}" and Data.Player.Team then
            return Data.Player.TeamColor
        end
    end

    if type(Setting) == "string" and string.sub(Setting, 1, 12) == "{RANKLADDER:" and string.sub(Setting, string.len(Setting), string.len(Setting)) == "}" and Data.Player and Data.Setting and type(Data.Loop) == "nil" then
        return RankLadderFunction(Setting, Data, FunctionBrickColor)
    end

    return false
end
Return.ParseBrickColor = FunctionBrickColor


-- This will only Parse Font Settings
function FunctionFont(Setting, Data)
--[[
    Data = {
        Player = <PlayerObject>,
        AddonName = "<AddonName>",
        Setting = "<SettingName>",
        Loop = <true/false>
    }
]]--
    if type(Setting) == "string" and Setting == "{DISABLED}" then
        return false
    end

    if type(Setting) == "string" and Enum.Font[Setting] ~= nil then
        return Enum.Font[Setting]
    end

    if type(Setting) == "string" and string.sub(Setting, 1, 12) == "{RANKLADDER:" and string.sub(Setting, string.len(Setting), string.len(Setting)) == "}" and Data.Player and Data.Setting and type(Data.Loop) == "nil" then
        return RankLadderFunction(Setting, Data, FunctionFont)
    end
end
Return.ParseFont = FunctionFont


-- This will only Parse Material Settings
function FunctionMaterial(Setting, Data)
--[[
    Data = {
        Player = <PlayerObject>,
        AddonName = "<AddonName>",
        Setting = "<SettingName>",
        Loop = <true/false>
    }
]]--
    if type(Setting) == "string" and Setting == "{DISABLED}" then
        return false
    end

    if type(Setting) == "string" and Enum.Material[Setting] ~= nil then
        return Enum.Material[Setting]
    end

    if type(Setting) == "string" and string.sub(Setting, 1, 12) == "{RANKLADDER:" and string.sub(Setting, string.len(Setting), string.len(Setting)) == "}" and Data.Player and Data.Setting and type(Data.Loop) == "nil" then
        return RankLadderFunction(Setting, Data, FunctionMaterial)
    end
end
Return.ParseMaterial = FunctionMaterial


-- This will only Parse Color3 Settings
function FunctionColor3(Setting, Data)
--[[
    Data = {
        Player = <PlayerObject>,
        AddonName = "<AddonName>",
        Setting = "<SettingName>",
        Loop = <true/false>
    }
]]--
    if type(Setting) == "string" and Setting == "{DISABLED}" then
        return false
    end

    if type(Setting) == "userdata" and typeof(Setting) == "Color3" then
        return Setting
    end

    if type(Setting) == "string" and string.sub(Setting, 1, 12) == "{RANKLADDER:" and string.sub(Setting, string.len(Setting), string.len(Setting)) == "}" and Data.Player and Data.Setting and type(Data.Loop) == "nil" then
        return RankLadderFunction(Setting, Data, FunctionColor3)
    end
end
Return.ParseColor3 = FunctionColor3

return Return
