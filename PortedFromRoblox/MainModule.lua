local children = script:GetChildren()
script = Instance.new("ModuleScript")
for _, child in pairs(children) do
    child.Parent = script
end

local Services = script.Services

--local Http = require(  [[ Http Script ]]  )
local CreatePermGroup = require(script.CreatePermGroup)
local RefreshUser = require(script.RefreshUser)
local UserHasPermission = require(script.UserHasPermission)

local Groups = {}

function GetEvent(...)
    local Args = {...}
    if type(Args[1]) ~= "string" or Args[1] == "" then return end

    if Args[1] == "CheckPerm" then
        local Player = Args[2]
        local Permission = Args[3]

        if type(Args[2]) ~= "userdata" or Args[2]:IsA("Player") == false then return end
        if type(Args[3]) ~= "string" or Args[3] == "" then return end

        local Found = string.match(Permission, "[\.%w|\*]*")

        if type(Found) == "string" and Found ~= "" then
            UserHasPermission(Groups, Player, Permission)
        end
    end
end

return function(Settings)
	-- Minor Checking
	if type(Settings) ~= "table" then return end
	if type(Settings.Groups) ~= "table" then return end

	-- Makes the groups
	for _, v in pairs(Settings.Groups) do
		local Return = CreatePermGroup(v)
		if type(Return) == "string" then
			print("Mystery Permissions Group Error: -> ".. Return)
		elseif type(Return) == "table" then
			table.insert(Groups, Return)
		end
	end

    -- Make the Event
    local BEvent = Instance.new("BindableEvent")
    BEvent.Name = "MysteryPermissions"
    BEvent.Parent = game:GetService("ReplicatedStorage")
	-- Connect the Event
    BEvent.Event:Connect(GetEvent)

	-- Refresh all Users every 30 seconds
	local Loop = true
	while Loop do
		wait(30)

		local Players = game:GetService("Players"):GetPlayers()
		for _, v in pairs(Players) do
			RefreshUser(Groups, v)
		end
	end
end
