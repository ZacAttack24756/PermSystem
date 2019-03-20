-- Required stuff
local ApiKey = script.Parent.Parent:FindFirstChild("API_KEY")
local Utl = require(script.Parent.Parent.Services.Utils)
local AddonName = script.Name

-- sample
local TeamServ = game:GetService("Teams")
local Settings = {}
local Cache = {Tools = {}, Groups = {}}
local CachePRefTime = 120 -- We really only need to refresh all the tools infrequently
local CacheGRefTime = 300 -- Groups Even less, as they usually only are created at the beginning

--------------------------------------------------------------------------------

function GiveTool(plr)
    local Name = plr.Name
    if TStorage and Cache.Tools[plr.Name] then
        local GivenTools = {}
        for _, v1 in pairs(Cache.Tools[Name]) do
            if Utl.ObjInArray(GivenTools, v1) == true and Settings.ADTools == true then
                for _, v2 in pairs(v1) do
                    local TargetTool = TStorage:FindFirstChild(v)
                    if plr.Backpack and TargetTool then
                        local Clone = TargetTool:Clone()
                        Clone.Parent = plr.Backpack
                    end
                    table.insert(GivenTools, v)
                end
            elseif Utl.ObjInArray(GivenTools, v1) == false then
                local TargetTool = TStorage:FindFirstChild(v)
                if plr.Backpack and TargetTool then
                    local Clone = TargetTool:Clone()
                    Clone.Parent = plr.Backpack
                end
                table.insert(GivenTools, v)
            end
        end
    end
end

--------------------------------------------------------------------------------

function RefreshCache(plr)
    Cache.Tools[plr.Name] = {}
    local ToolTable = {}
    wait()

    local BannedTools = {}
    if plr.Team and Settings.TBList[plr.Team] then
        local BLData = Settings.TBList[plr.Team]
        if type(BLData) == "string" and BLData == "ALL" then
            BannedTools = "ALL"
        elseif type(BLData) == "table" and BannedTools ~= "ALL" then
            for _, Tool in pairs(BLData) do
                table.insert(BannedTools, Tool)
            end
        end
    end

    local PlrData = _G.PermSystem.Api(API_KEY.Value, "GetPlrData", plr)
    if PlrData then
        for _, v in pairs(PlrData.Groups) do
            if Cache.Groups[v] then
                local GData = Cache.Groups[v]
                local BLData = GData.ToolBlackList
                local GvData = GData.ToolGiveList

                -- Individual Group Blacklist Data
                if type(BLData) == "string" and BLData == "ALL" then
                    BannedTools = "ALL"
                elseif type(BLData) == "table" and BannedTools ~= "ALL" then
                    for _, Tool in pairs(BLData) do
                        if type(Tool) == "string" then
                            table.insert(BannedTools, Tool)
                        end
                    end
                end

                -- Now to Group Give Data
                if BannedTools ~= "ALL" and type(GvData) == "table" then
                    for _, v in pairs(GvData) do
                        if type(v) == "string" and Utl.ObjInArray(BannedTools, v) == false then
                            table.insert(ToolTable, v)
                        end
                    end
                end
            end
        end
    end

    -- Now that we are done with blacklisted items, we can finally start compiling a list of tools to give

    if BannedTools ~= "ALL" then
        -- Global Tools
        for _, v in pairs(Settings.GTools) do
            if not Utl.ObjInArray(BannedTools, v) == false then
                table.insert(ToolTable, v)
            end
        end

        -- Team Giving
        if type(Settings.TeamGive) == "table" and plr.Team then
            if type(Settings.TeamGive[plr.Team]) == "table" then
                for _, v in pairs(Settings.TeamGive[plr.Team]) do
                    if type(v) == "string" and Utl.ObjInArray(BannedTools, v) == false then
                        table.insert(ToolTable, v)
                    end
                end
            end
        end
    end

    Cache.Tools[plr.Name] = ToolTable
end

--------------------------------------------------------------------------------

function LoopRefPCache(plr)
    local Name = plr.Name
    plr.CharacterAdded:Connect(function()
        GiveToolHook(plr)
    end
    while game:GetService("Players"):FindFirstChild(Name) ~= nil do
        RefreshCache(plr)
        wait(CachePRefTime)
    end
    Cache.Tools[Name] = nil
end

--------------------------------------------------------------------------------

function LoopRefGCache()
    while true do
        local AddonGroups = _G.PermSystem.ApiCall(API_KEY.Value, "GetAllAddonGroups", AddonName)

        for _, v in pairs(AddonGroups) do
            local GroupInfo = _G.PermSystem.ApiCall(API_KEY.Value, "GetGroupData", v)
            if GroupInfo then
                local AddonInfo = GroupInfo.Addons[AddonName]
                Cache.Groups[v.Name] = v
            end
        end
        wait(CacheGRefTime)
    end
end

--------------------------------------------------------------------------------

return function(Config)
    if type(Config.Enabled) ~= "boolean" or Config.Enabled == false then return AddonName.. " not enabled!" end

    Settings.ToolStorage = {}
    if type(Config.ToolStorage) == "userdata" and Config.ToolStorage:IsA("Tool") then
        Settings.ToolStorage = {Config.ToolStorage}
    elseif type(Config.ToolStorage) == "table" then
        for _, v in pairs(Config.ToolStorage) do
            if type(v) == "userdata" then
                table.insert(Settings.ToolStorage, v)
            end
        end
    end

    --[[Settings.GBList = {}
    if type(Config.GroupBlackList) == "table" then
        for i1, v1 in pairs(Config.GroupBlackList) do
            if type(i1) == "string" and type(v1) == "string" then
                if v1 == "ALL" then
                    Settings.GBList[i1] = "ALL"
                end
            elseif type(i1) == "string" and type(v1) == "table" then
                Settings.GBList[i1] = {}
                for _, v2 in pairs(v1) do
                    if type(v2) == "string" and v2 ~= "" and v2 ~= "ALL" then
                        table.insert(Settings.GBList[i1], v2)
                    end
                end
            end
        end
    end]]-- Archived Code

    Settings.TBList = {}
    if type(Config.TeamBlackList) == "table" then
        for i1, v1 in pairs(Config.TeamBlackList) do
            if type(i1) == "userdata" and i1:IsA("Team") and type(v1) == "string" then
                if v1 == "ALL" then
                    Settings.TBList[i1] = "ALL"
                end
            elseif type(i1) == "userdata" and i1:IsA("Team") and type(v1) == "table" then
                Settings.TBList[i1] = {}
                for _, v2 in pairs(v1) do
                    if type(v2) == "string" and v2 ~= "" and v2 ~= "ALL" then
                        table.insert(Settings.TBList[i1], v2)
                    end
                end
            end
        end
    end

    Settings.ADTools = false
    if type(Config.AllowDupeTools) == "boolean" then
        Settings.ADTools = Config.AllowDupeTools
    elseif type(Config.AllowDupeTools) == "table" then
        Settings.ADTools = {}
        for _, v in pairs(Config.AllowDupeTools) do
            if type(v) == "string" then
                table.insert(Settings.ADTools, v)
            end
        end
    end

    Settings.TeamGive = {}
    if type(Config.TeamGive) == "table" then
        for TeamObj, GivenTools in pairs(Config.TeamGive) do
            if type(TeamObj) == "userdata" and TeamObj:IsA("Team") and type(GivenTools) == "table" then
                local Format = {}
                for _, Tool in pairs(GivenTools) do
                    if type(Tool) == "string" then
                        table.insert(Format, Tool)
                    end
                end

                Config.AllowTeamGive[TeamName] = Format
            end
        end
    end

    Settings.GTools = {}
    if type(Config.GlobalToolGive) == "table" then
        for _, v in pairs(Config.GlobalToolGive) do
            if type(v) == "string" then
                table.insert(Settings.GTools, v)
            end
        end
    end

    spawn(LoopRefGCache)
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        LoopRefPCache(plr)
    end
    game:GetService("Players").PlayerAdded:Connect(LoopRefPCache)

    return true
end
