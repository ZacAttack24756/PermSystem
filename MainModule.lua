local children = script:GetChildren()
script = Instance.new("ModuleScript")
for _, child in pairs(children) do
    child.Parent = script
end

--[[
    MainModule
    Script which contians runtime
    match Permission Pattern : "[\.%P|\*]*"
    gmatch Permission Pattern : "(\.[%P]*)"
]]--

-- Script Vars
local Services = script.Services
local Functions = script.Functions
local CreatePermGroup = require(Functions.CreatePermGroup)
local RefreshUser = require(Functions.RefreshUser)
local CheckUserPerm = require(Functions.CheckUserPerm)

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Changable Script Vars
local Groups = {}


---- Main Functions ----
local function kill()
    script:Destroy()
end
-- Event Function
local function GetEvent(...)
    local Args = {...}
    if type(Args[1]) ~= "string" or Args[1] == "" then return "Inappropriate Descriptor (Argument #1)" end

    if Args[1] == "CheckPerm" then
        local Player = Args[2]
        local Permission = Args[3]

        if type(Args[2]) ~= "userdata" or Args[2]:IsA("Player") == false then return end
        if type(Args[3]) ~= "string" or Args[3] == "" then return end

        local Found = string.match(Permission, "[\.%P|\*]*")

        if type(Found) == "string" and Found ~= "" then
            return CheckUserPerm(Groups, Player, Found)
        end
    end
end
-- Keep it in it's own function, just incase
local function MakeFunc()
    local BFunc = Instance.new("BindableFunction")
    BFunc.Name = "PermSystem"
    -- Connect the event, and move it
    BFunc.OnInvoke = GetEvent
    if ReplicatedStorage:FindFirstChild("PermSystem") then
        ReplicatedStorage.PermSystem:Destroy()
    end
    BFunc.Parent = ReplicatedStorage
    return BFunc
end

Players.PlayerAdded:Connect(function(plr)
    RefreshUser(Groups, plr)
end)
Players.PlayerRemoving:Connect(function(plr)
    RefreshUser(Groups, plr)
end)

return function(Settings)
    -- Minor Error Checking
    if type(Settings) ~= "table" then kill() return "Settings is not a table!" end
    if type(Settings.Groups) ~= "table" then kill() return "" end

    -- Compiles the groups
    for i, v in pairs(Settings.Groups) do
        local Return = CreatePermGroup(v, i)
        if type(Return) == "string" then
            print("PermSystem Group Error: -> ".. Return)
        elseif type(Return) == "table" then
            table.insert(Groups, Return)
        end
    end

    -- Creates the event
    local BFunc = MakeFunc()

    -- Refreshes all Users every 30 seconds
    local Loop = true
    while Loop do
        wait(30)

        local Plrs = Players:GetPlayers()
        for _, v in pairs(Plrs) do
            RefreshUser(Groups, v)
        end
    end
end
