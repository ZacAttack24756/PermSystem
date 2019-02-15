--[[
    Documentation for the Startup Configuration File

    ---- Main Settings ----

    Groups              [Array:Tab] :   The Main Group Startup Configuration (See "Group Making")
    Addons              [Tab]       :   Addons that come with this script (See "Addon Settings")
    Options             [Tab]       :   Different Options for the script
    {
        "Enabled"       [Bool]      :   If the script it'self is enabled or not
        ~~ Optional ~~
        "Prefix"        [String]    :   The 1 character that will be the prefix for most chat commands, Is Case Sensitive
        "CheckRate"     [Number]    :   The amount of seconds between the script refreshing all players' permissions/groups/etc. (Default: 30, Minimum: 1, Maximum 600)
        "CreatorPrivileges"  [Bool] :   If me (mystery3525), will automatically get Administrator in your game (  c:  )
    }

	----    Group Making    ----

	Text in '[""]' is the group's name
	--> NOTE: Any "Non-Optional" items missing would delete the group through error checking
    --> NOTE: If any part of the group is incorrectly made, the group would be voided.
	[""] = {
		"Rank"			[Num]		:	The Ranking Number of the group (Higher number means Higher Priority) (This number can't be lower than zero, or above 2^30)
        ~~ Optional ~~
		"Perms"			[Array/Str]	:	Core Permissions the group has (See "Permission Format" Below)
		"Default"		[Bool]		:	Specifies if the player gets this rank for Free
        "RankLadder"	[Str]		:	The Name for the Rank Ladder for the group (None equals "Default"). A player can only be in 1 Group per Ladder
		"Inheritance"	[Array/Str]	:	Group names this group 'inherits' permissions from. Specify "Rank" to inherit from any lower-ranking groups
        "Options"       [Table]     :   Options for this group
        {
            "SaveUsers"     [Bool]  :   Specify whether any users added to this group is saved. (Automatically set to false if "RobloxGroup" or "RobloxTeam" is enabled)
            "Override"      [Str]   :   Define a specific Permission Override (See "Permission Overrides")
        }
        "RobloxGroup"   [Array:Tab]	:	Array of Tables which specify what roblox group and rank can get this group. (Refer Below)
		{
			~ All Required ~
			"ID"         [Num]		:	Group ID which is being targeted
			"Cond"       [Str]		:	The LUA Condition for rank. Structured as follows: ( GroupRank __Cond__ ReqRank ) ; ( Ex: 30 >= 25 )
			"Rank"       [Num]		:	The Required Group Rank to recive this group
		}
		"RobloxTeam"	[Array:Obj]	:	An in-game team that would recive this Group ( Directly refer to the team, Ex: "game.Teams.Team1" (Without "") ). NOTE: The Roblox team needs to be in the game BEFORE this script is initialized
        "Addons"        [Tab]       :   Settings for specific addons
        {
            ...         [Tab]       :   Specific Addon Setting Table
            ...         [Tab]       :   Specific Addon Setting Table
            ...         [Tab]       :   Specific Addon Setting Table
        }
	}

    -- Permission Format
    Every permission is made up of layers. The more layers a permission has, the more specific it is implying.
    For Example, ".interact" has only 1 layer, while ".interact.house1.frontdoor" has 3, the final, most specific one being '.frontdoor'.
    Having one of the permission layers be ".*" means that that permission gives all permissions of that layer, plus any lower layers.
    For Example, ".interact.house1.*" would also give ".interact.house1.frontdoor" and ".interact.house1.backdoor".
    ".interact.*" would give all the permissions of house1 - houseinfinity, and their lower layers.
    A ".*" permission gives literally any permission possible, since it is on the highest layer.
    NOTE: Permissions CAN be negative, but this doesn't work when dealing with `.*`.

    -- Permission Overrides --
    From Lowest Rights to Highest Rights
    - NoAccess                      :   No Access; Removes any privilages/permissions from this Group, and Negates any Inheritaed ranks
    - Normal                        :   A Normal Group; Nothing to see here (Making it this literally does nothing)
    - Administrator                 :   Full Access; Automatically given every privilage/permission

    ----    Addon Settings    ----
    {
    -- SimpleTitles: A basic titling system for games (NOT ADDED YET)
    -- Has Moderate-High Configuration, Custom Team Assigns, Custon Group Assigns, Up to 4 scaled text boxes (0th: Username, 4th: Smallest Text Box)
    -- NOTE: Cannot have more than 1 (Rank Ladder or Team) assigned to one Text Box
    ["SimpleTitles"] = {
        "Enabled"           [Bool]  :   Wether or not the addon is enabled
        ~~ Optional ~~
        - Box1: Username Text Box
        "Box1:Text"         [Str]   :   The Rank Ladder to get Box1's Text (Cannot be based on Teams)
        "Box1:Color"        [Str]   :   Where to get the color for Box1 ("TeamColor", "RankLadder")
    },
    -- ToolGiver: A simple addon to configure tools to be given to groups
    -- Tools are configured on a Per-Team Basis
    }
--]]
