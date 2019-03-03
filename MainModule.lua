local children = script:GetChildren()
script = Instance.new("ModuleScript")
for _, child in pairs(children) do
    child.Parent = script
end

print("PermSystem has loaded")

--[[
    MainModule
    Script which contians runtime
    match Permission Pattern : "[\.%P|\*]*"
    gmatch Permission Pattern : "(\.[%P]*)"
]]--

-- Script Vars
local Services = script.Services
local Functions = script.Functions
local AddonFolder = script.Addons
local CreatePermGroup = require(Functions.CreatePermGroup)
local RefreshUser = require(Functions.RefreshUser)
local CheckUserPerm = require(Functions.CheckUserPerm)

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Changable Script Vars
local Groups = {}
local AddonTab = {}
local PlayerTable = {}
local BFunc = nil
local ApiKey = nil
local ApiKeyRand = Random.new()
_G.PermSystem = {}

---- Main Functions ----
local function kill()
    script:Destroy()
end
-- Event Function
function GetEvent(...)
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
    --[[elseif Args[1] == "AddGroup" then
        local GroupSettings = Args[2]

        local Result = CreatePermGroup(GroupSettings)
        return Result]]--   Yeah no lets not do that just yet -mystery
    end
end
function GetEventI(...)
    local Args = {...}
    if type(Args[2]) ~= "string" or Args[1] == "" then return "Inappropriate Descriptor (Argument #1)" end

    if Args[2] == "GetGroupData" then
        local GroupName = Args[3]

        if type(GroupName) ~= "string" or GroupName == "" then return "Given Group Argument is not a string" end

        for _, GroupObj in pairs(Groups) do
            if GroupObj.Name == GroupName then
                return GroupObj
            end
        end
        return "Group not Found"
    elseif Args[2] == "GetPlrData" then
        local PlayerObj = Args[3]

        if type(PlayerObj) ~= "userdata" or PlayerObj:IsA("Player") == false then return "Invalid Player Object" end

        print(PlayerTable[PlayerObj])
        return PlayerTable[PlayerObj]
    elseif Args[2] == "GetRankLadderGroups" then
        local Ladder = Args[3]

        if type(Ladder) ~= "string" or Ladder == "" then return "Given RankLadder Argument is not a string" end

        local Found = {}
        for _, GroupInfo in pairs(Groups) do
            if GroupInfo.RankLadder == Ladder then
                table.insert(Found, GroupInfo.Name)
            end
        end

        return Found
    end
end
-- Keep it in it's own function, just incase
function MakeFunc()
    BFunc = Instance.new("BindableFunction")
    BFunc.Name = "PermSystem"
    -- Connect the event, and move it
    BFunc.OnInvoke = GetEvent
    if ReplicatedStorage:FindFirstChild("PermSystem") then
        ReplicatedStorage.PermSystem:Destroy()
    end
    BFunc.Parent = ReplicatedStorage

    -- We gotta secure it from anyone trying to get it
    ApiKey = Instance.new("NumberValue")
    ApiKey.Name = "API_KEY"
    ApiKey.Value = ApiKeyRand:NextNumber()
    ApiKey.Parent = script

    _G.PermSystem.Api = function(...)
        local Args = {...}

        if type(Args[1]) ~= "number" then return "API Key Missing" end
        if Args[1] ~= ApiKey.Value then return nil end

        return GetEventI(...)
    end
end

Players.PlayerAdded:Connect(function(plr)
    PlayerTable[plr] = RefreshUser(Groups, plr)
end)
Players.PlayerRemoving:Connect(function(plr)
    RefreshUser(Groups, plr)
    PlayerTable[plr] = nil
end)

return function(Settings)
    -- Minor Error Checking
    if type(Settings) ~= "table" then kill() return "Settings is not a table!" end
    if type(Settings.Groups) ~= "table" then kill() return "Settings.Groups does not exist/cannot be found!" end
    if type(Settings.Options) ~= "table" then kill() return "Settings.Options does not exist/cannot be found!" end
    if type(Settings.Options.Enabled) ~= "boolean" then kill() return "Settings.Optins.Enabled does not exist/cannot be found!" end
    if Settings.Options.Enabled == false then kill() return "Script is not enabled in settings!" end

    local CheckRate = 30
    if type(Settings.Options.CheckRate) == "number" and Settings.Options.CheckRate >= 1 and Settings.Options.CheckRate <= 600 then
        CheckRate = Settings.Options.CheckRate
    end
    local CP = Instance.new("BoolValue")
    CP.Name = "CreatorPrivileges"
    CP.Value = false
    if type(Settings.Options.CreatorPrivileges) == "boolean" then
        CP.Value = Settings.Options.CreatorPrivileges
    end
    CP.Parent = script

    -- Compiles the groups
    for i, v in pairs(Settings.Groups) do
        local Return = CreatePermGroup(v, i, Groups)
        if type(Return) == "string" then
            print("PermSystem Group Error: ".. Return)
        elseif type(Return) == "table" then
            Groups[Return.Name] = Return
        end
    end

    -- Halt for a sec
    wait()

    -- Creates the event & Adds a function to refresh the ApiKey
    MakeFunc()
    spawn(function()
        while true do
            wait(30)
            ApiKey.Value = ApiKeyRand:NextNumber()
        end
    end)
    
    for _, v in pairs(Players:GetPlayers()) do
        PlayerTable[v] = RefreshUser(Groups, v)
    end

    -- Refreshes all Users every 30 seconds
    local Loop = true
    spawn(function()
        while Loop do
            print("Refreshing All Users")

            for _, v in pairs(Players:GetPlayers()) do
                PlayerTable[v] = RefreshUser(Groups, v)
            end
            wait(CheckRate)
        end
    end)

    -- Load In Addons
    if type(Settings.Addons) == "table" then
        for i, v in pairs(Settings.Addons) do
            if type(i) == "string" and AddonFolder:FindFirstChild(i) ~= nil then
                local Return = require(AddonFolder:FindFirstChild(i))(v)
                if type(Return) == "string" then
                    print(i.. " Addon Error: ".. Return)
                elseif type(Return) == "boolean" and Return == false then
                    print(i.. " Addon Error: Error Unknown")
                elseif type(Return) == "boolean" and Return == true then
                    print(i.. " Addon loaded and executed successfully")
                end
            end
        end
    end
end
