local children = script:GetChildren()
script = Instance.new("ModuleScript")
for _, child in pairs(children) do
    child.Parent = script
end
script = nil

--[[
    MainModule
    Script which contians runtime
    The Permission Pattern: "[%.(%w*|%*)]*"
]]--

local Services = script.Services
local Functions = script.Functions

local Groups = {}

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

        local Found = string.match(Permission, "[%.(%w*|%*)]*")
    end
end

-- Keep it in it's own function, just incase
local function MakeFunc()
    local BFunc = Instance.new("BindableFunction")
    BFunc.Name = "PermSystem"
    -- Connect the event, and move it
    BEvent.OnInvoke = GetEvent
    BFunc.Parent = game:GetService("ReplicatedStorage")
end

return function(Settings)
    -- Minor Error Checking
    if type(Settings) ~= "table" then kill() return end
    if type(Settings.Groups) ~= "table" then kill() return end

    -- Compiles the groups
    for _, v in pairs(Settings.Groups) do
        local Return = CreatePermGroup(v)
        if type(Return) == "string" then
            print("PermSystem Group Error: -> ".. Return)
        elseif type(Return) == "table" then
            table.insert(Groups, Return)
        end
    end

    -- Creates the event
