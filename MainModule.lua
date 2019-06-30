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
local CheckPermModule = require(Functions.CheckPerm)

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Changable Script Vars
local Groups = {}
local FunctionSave = {}
local PlayerTable = {}
local BFunc = nil
local ApiKey = nil
local ApiKeyRand = Random.new()
_G.PermSystem = {}

---- Main Functions ----
local function kill()
    script:Destroy()
end
-- Event Function --------------------------------------------------------------
function GetEvent(...)
    local Args = {...}
    if type(Args[1]) ~= "string" or Args[1] == "" then return "Inappropriate Descriptor (Argument #1)" end

    if Args[1] == "CheckPerm" then
        if typeof(Args[2]) ~= "Instance" or Args[2]:IsA("Player") == false then return end
        if type(Args[3]) ~= "string" or Args[3] == "" then return end

        local Player = Args[2]
        local Permission = Args[3]

        local Found = string.match(Permission, "[\.%P|\*]*")

        if type(Found) == "string" and Found ~= "" then
            return CheckPermModule(Groups, "User", Player, Found)
        end
        return
    elseif Args[1] == "CheckPermGroup" then
        if type(Args[2]) ~= "string" or Args[3] == "" then return "Argument 2 is not a string!" end
        if type(Args[3]) ~= "string" or Args[3] == "" then return "Argument 3 is not a string!" end

        local TargetGroup = Args[2]
        local Permission = Args[3]

        local GroupExists = false
        for _, v in pairs(Groups) do
            if v.Name == TargetGroup then
                GroupExists = true
            end
        end
        if GroupExists == false then return "Group does not Exist!" end
        GroupExists = nil

        local Found = string.match(Permission, "[\.%P|\*]*")

        if type(Found) == "string" and Found ~= "" then
            return CheckPermModule(Groups, "Group", TargetGroup, Found)
        else
            return "Misformed Permission String!"
        end
        return "Unknown Error"
    elseif Args[1] == "CheckGroup" then
        if typeof(Args[2]) ~= "Instance" or Args[2]:IsA("Player") == false then return end
        if type(Args[3]) ~= "string" or Args[3] == "" then return end

        local Player = Args[2]
        local TargetGroup = Args[3]

        local GroupExists = false
        for _, v in pairs(Groups) do
            if v.Name == TargetGroup then
                GroupExists = true
            end
        end
        if GroupExists == false then
            return "GroupEqualsNil"
        end

        if PlayerTable[Player] then
            local PlrInfo = PlayerTable[Player]
            if PlrInfo.Groups then
                for _, GroupName in pairs(PlrInfo.Groups) do
                    if TargetGroup == GroupName then
                        return true
                    end
                end
                return false
            end
        end

        return
    elseif type(FunctionSave[Args[1]]) == "function" then
        return FunctionSave[Args[1]]
    end

    return nil
end
-- Internal Api ----------------------------------------------------------------
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

        if typeof(PlayerObj) ~= "Instance" or PlayerObj:IsA("Player") == false then return "Invalid Player Object" end

        --print(PlayerTable[PlayerObj])
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
    elseif Args[2] == "GetAllAddonGroups" then
        local TargetAddon = Args[3]
        if type(TargetAddon) ~= "string" or script.Addons:FindFirstChild(TargetAddon) == nil then return "Invalid Addon" end

        local Found = {}
        for _, v in pairs(Groups) do
            local Name = v.Name
            local vAddons = v.Addons

            if vAddons[TargetAddon] then
                table.insert(Found, Name)
            end
        end

        return Found
    elseif Args[2] == "CreateGroup" then
        local SettingsObject = Args[3]
        if type(SettingsObject) ~= "table" then return "Settings Object not a table!" end
        if type(SettingsObject.Name) ~= "string" or type(Groups[SettingsObject.Name]) == "table" then return "Name inside the SettingsObject not a string, or is already in use!" end

        local Return = CreatePermGroup(SettingsObject, SettingsObject.Name, Groups)
        if type(Return) == "string" then
            print("PermSystem Internal Group Creation Error: ".. Return)
        elseif type(Return) == "table" then
            Groups[Return.Name] = Return
            return true
        end
        return false
    elseif Args[2] == "RegisterFunction" then
        local Name = Args[3]
        if type(Name) ~= "string" or type(FunctionSave[Name]) ~= "nil" or Name == "CheckPerm" or Name == "CheckGroup" then return "Function Name Already Exists" end

        FunctionSave[Name] = Args[4]
        return true
    end

    return GetEvent(...)
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

    -- Make all Player's stuff
    for _, v in pairs(Players:GetPlayers()) do
        PlayerTable[v] = RefreshUser(Groups, v)
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

    -- Stars the refresh loop
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
    spawn(function()
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
    end)

    -- We have to respawn all the players, to ensure that all the addons are properly loaded in
    delay(1.5, function()
        for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
            local Char = plr.Character
            if Char and Char:FindFirstChild("Humanoid") then
                local Hum = Char:FindFirstChild("Humanoid")
                if Hum:IsA("Humanoid") then
                    Hum.Health = 0
                    plr:LoadCharacter()
                end
            end
        end
    end)
end
