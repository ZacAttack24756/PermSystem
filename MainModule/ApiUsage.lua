--[[
    How to use this script with your own scripts

    You can use this script by searching for a BindableFunction, In ReplicatedStorage.
]]--
local PermSystem = game:GetService("ReplicatedStorage"):WaitForChild("PermSystem")
--[[
    The Paramaters for the event are as follows:
    :Invoke("<Function>", ...<Arguments>...)

    Avalible Functions:

    "CheckPerm"                 :   Checks if a player has a specific permission
    ->      <PlayerObject>          :   The Physical Player Object (i.e.   game.Players.Bob   )
    ->      "<Permission>"          :   The Permission to check on the player (See ConfigDocumentation for information on proper Permission Formats)
    RETURNS ->  <Bool>                  :   If the Player has that specific permission

    "CheckGroup"                :   Checks if a player is in a specific group
    ->      <PlayerObject>          :   The Physical Player Object (i.e.   game.Players.Bob   )
    ->      "<GroupName>"           :   The Name of the Group to Check
    RETURNS ->  <Variant>               :   If the Player has that specific group (true/false); Or if the Group does not exist ("GroupEqualsNil")
]]--
local Result = PermSystem:Invoke("<Function>", ...<Arguments>...)
