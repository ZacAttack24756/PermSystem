-- Required stuff
local API_KEY = script.Parent.Parent:FindFirstChild("API_KEY")
local Utl = require(script.Parent.Parent.Services.Utils)
local MarketplaceService = game:GetService("MarketplaceService")

-- Settings
local AddonName = "ToolGiver"
local Debug = false

-- sample
local TeamServ = game:GetService("Teams")
local Settings = {}
local Cache = {Tools = {}, Groups = {}}
local CachePRefTime = 120 -- We really only need to refresh all the tools infrequently
local CacheGRefTime = 300 -- Groups Even less, as they usually only are created at the beginning

--------------------------------------------------------------------------------

function GiveActualTool(plr, Tool)
    local Given = false
    if plr.Backpack then
        for _, v1 in pairs(Settings.ToolStorage) do
            if Given == true then break end
            for _, v2 in pairs(v1:GetChildren()) do
                if v2.Name == Tool and v2:IsA("Tool") then
                    if plr.Backpack and v2 then
                        local Clone = v2:Clone()
                        Clone.Parent = plr.Backpack
                        Given = true
                        break
                    end
                end
            end
        end
    end
end
function ProcessTools(plr)
    if Settings.ToolStorage and Cache.Tools[plr.Name] then
        local GivenTools = {}
        for _, v1 in pairs(Cache.Tools[plr.Name]) do
            --------------------------------------------------------------------
            if Utl.ObjInArray(GivenTools, v1) == true and Settings.ADTools == true then
                GiveActualTool(plr, v1)
                table.insert(GivenTools, v1)
            --------------------------------------------------------------------
            elseif Utl.ObjInArray(GivenTools, v1) == false then
                GiveActualTool(plr, v1)
                table.insert(GivenTools, v1)
            end
            --------------------------------------------------------------------
        end
    end
end

--------------------------------------------------------------------------------

function RefreshCache(plr)
    Cache.Tools[plr.Name] = {}
    local ToolTable = {}
    local PlrId = plr.UserId
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
                        if type(v) == "string" and (Utl.ObjInArray(BannedTools, v, Debug) == false) then
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
            if (Utl.ObjInArray(BannedTools, v, Debug) == false) then
                table.insert(ToolTable, v)
            end
        end

        -- Team Giving
        if type(Settings.TeamGive) == "table" and plr.Team then
            if type(Settings.TeamGive[plr.Team]) == "table" then
                for _, v in pairs(Settings.TeamGive[plr.Team]) do
                    if type(v) == "string" and (Utl.ObjInArray(BannedTools, v, Debug) == false) then
                        table.insert(ToolTable, v)
                    end
                end
            end
        end

        -- Gamepass Giving
        if type(Settings.Gamepasses) == "table" then
            for _, v in pairs(Settings.Gamepasses) do
                local Passed, Return = pcall(function()
                    return MarketplaceService:UserOwnsGamePassAsync(PlrId, v)
                end)
                if Passed then
                    if Return == true then
                    end
                end
            end
        end
    end

    if Debug == true then
        print("Banned Tools type: '".. type(BannedTools) .."'")
        if type(BannedTools) == "table" then
            for _, v in pairs(BannedTools) do
                print("BannedTool: '".. v .."'")
            end
        end
        for _, v in pairs(ToolTable) do
            print("Tool '".. v .."'")
        end
    end

    Cache.Tools[plr.Name] = ToolTable
end

--------------------------------------------------------------------------------

function LoopRefPCache(plr)
    local Name = plr.Name
    plr.CharacterAdded:Connect(function()
        RefreshCache(plr)
        ProcessTools(plr)
    end)
    while game:GetService("Players"):FindFirstChild(Name) ~= nil do
        RefreshCache(plr)
        wait(CachePRefTime)
    end
    Cache.Tools[Name] = nil
end

--------------------------------------------------------------------------------

function LoopRefGCache()
    while true do
        local AddonGroups = _G.PermSystem.Api(API_KEY.Value, "GetAllAddonGroups", AddonName)

        for _, v in pairs(AddonGroups) do
            local GroupInfo = _G.PermSystem.Api(API_KEY.Value, "GetGroupData", v)
            if GroupInfo then
                local AddonInfo = GroupInfo.Addons[AddonName]
                Cache.Groups[v] = AddonInfo
            end
        end
        wait(CacheGRefTime)
    end
end

--------------------------------------------------------------------------------

return function(Config)
    if type(Config.Enabled) ~= "boolean" or Config.Enabled == false then return AddonName.. " not enabled!" end

    Settings.ToolStorage = {}
    if type(Config.ToolStorage) == "userdata" then
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

                Settings.TeamGive[TeamObj] = Format
            end
        end
    end

    Settings.Gamepasses = {}
    if type(Config.GamepassGive) == "number" then
        if 0 < Config.GamepassGive and Config.GamepassGive < math.huge then
            Settings.Gamepasses = {Config.GamepassGive}
        end
    elseif type(Config.GamepassGive) == "table" then
        for _, v in pairs(Config.GamepassGive) do
            if type(v) == "number" and 0 < v and v < math.huge then
                table.insert(Settings.Gamepasses, v)
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
    for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
        LoopRefPCache(plr)
    end
    game:GetService("Players").PlayerAdded:Connect(LoopRefPCache)
    wait()

    return true
end
