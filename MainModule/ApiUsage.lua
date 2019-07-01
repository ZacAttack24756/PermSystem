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

    "CheckPermGroup"            :   Checks if a group has a specific permission
    ->      "<GroupName>"           :   The Name of the Group to check
    ->      "<Permission>"          :   The Permission to check on the player (See ConfigDocumentation for information on proper Permission Formats)
    RETURNS ->  <Variant>               :   If the Player has that specific permission (true/false); Or a string if there is any errors

    "CheckGroup"                :   Checks if a player is in a specific group
    ->      <PlayerObject>          :   The Physical Player Object (i.e.   game.Players.Bob   )
    ->      "<GroupName>"           :   The Name of the Group to Check
    RETURNS ->  <Variant>               :   If the Player has that specific group (true/false); Or if the Group does not exist ("GroupEqualsNil")

    Addon Functions:
    "Cards_Create"              :   Creates a fully valided card
    ->      "<Type>"                :   The type of Card to refer to ("UserCard" for when the Card Refers to a User's Permissions, "GroupCard" when a Card Refers to a Group's Permissions)
    ->      "<Target>"              :   Whatever User or Group the Card is referring to, see above
    ->      {
                Color1 = <Color>,       :   The BrickColor of the Main Part of the Card
                Color2 = <Color>,       :   The BrickColor of the Text Part of the Card
                Mat1 = "<Material>",    :   The Material of the Main Part of the Card
                Mat2 = "<Material>",    :   The Matieral of the Text Part of the Card
                Font = "<FontName>",    :   The Name of the Font to use
                Text = "<Text>",        :   What Text that would be on the Card
                Name = "<Name>",        :   The Name of the Card's Tool
                TextColor = <Color3>    :   The Color3 of the Text
            }                       :   Settings about the Card's Asthetics (Supports Variables)
    RETURNS ->  <Variant>               :   The Final Card Tool, Completely made and registered
]]--
local Result = PermSystem:Invoke("<Function>", ...<Arguments>...)
