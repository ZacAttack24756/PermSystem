-- Utils
local Utils = require(script.Parent.Parent.Services.Utils)

-- sample
local Teams = game:GetService("Teams")
local Settings = {}
local Cache = {}
local CacheRefreshTime = 120

function RefreshCache(plr)

end

function LoopRefCache(plr)
    local Name = plr.Name
    while game:GetService("Players"):FindFirstChild(Name) ~= nil do
        RefreshCache(plr)
        for _, v in pairs()
        wait(CacheRefreshTime)
    end
    Cache[Name] = nil
end

return function(Config)
    if type(Config.Enabled) ~= "boolean" or Config.Enabled == false then return "ToolGiver not enabled!" end

    Settings.ToolStorage = {}
    if type(Config.ToolStorage) == "userdata" then
        table.insert(Settings.ToolStorage, Config.ToolStorage)
    elseif type(Config.ToolStorage) == "table" then
        for _, v in pairs(Config.ToolStorage) do
            if type(v) == "userdata" then
                table.insert(Settings.ToolStorage, v)
            end
        end
    end

    Settings.GBList = {}
    if type(Config.GroupBlackList) == "string" then
        table.insert(Settings.GBList, Config.GroupBlackList)
    elseif type(Config.GroupBlackList) == "table" then
        for _, v in pairs(Config.GroupBlackList) do
            if type(v) == "string" then
                table.insert(Settings.GBList, v)
            end
        end
    end

    Settings.TBList = {}
    if type(Config.TeamBlackList) == "string" then
        table.insert(Settings.TBList, Config.TeamBlackList)
    elseif type(Config.TeamBlackList) == "table" then
        for _, v in pairs(Config.TeamBlackList) do
            if type(v) == "string" then
                table.insert(Settings.TBList, v)
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

    Settings.TeamGive = false
    if type(Config.AllowTeamGive) == "boolean" then
        Settings.TeamGive = Config.AllowTeamGive
    elseif type(Config.AllowTeamGive) == "table" then
        Settings.TeamGive = {}
        for TeamName, AllowedTools in pairs(Config.AllowTeamGive) do
            if type(TeamName) == "string" and Teams:FindFirstChild(TeamName) and type(AllowedTools) == "table" then
                local Format = {}
                for _, Tool in pairs(AllowedTools) do
                    if type(Tool) == "string" then
                        table.insert(Format, Tool)
                    end
                end

                Config.AllowTeamGive[TeamName] = Format
            end
        end
    end

    Settings.GlobalGive = {}
    if type(Config.GlobalToolGive) == "table" then
        for _, v in pairs(Config.GlobalToolGive) do
            if type(v) == "string" then
                table.insert(Settings.GlobalGive, v)
            end
        end
    end

    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        LoopRefCache(plr)
    end
    game:GetService("Players").PlayerAdded:Connect(function(plr)
        LoopRefCache(plr)
    end)

    return true
end
