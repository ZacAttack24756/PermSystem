--[[
    Documentation for the Startup Configuration File

    ---- Main Settings ----

    Groups              [Array:Tab] :   The Main Group Startup Configuration (See "Group Making")
    Addons              [Tab]       :   Addons that come with this script (See "Addon Settings")
    Options             [Tab]       :   Different Options for the script
    {
        "Enabled"       [Bool]      :   If the script it'self iis enabled or not
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
        ~~ Optional Settings ~~
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
    -- If the Box is assigned to a RankLadder, and the user is not in any group in that RankLadder, the box will be empty
    ["SimpleTitles"] = {
        "Enabled"           [Bool]  :   Wether or not the addon is enabled
        ~~ Optional Settings ~~
        "GuiViewDistance"   [Num]   :   The Maximum Distance that this GUI can be view from
        "FillEmptyBoxes"    [Bool]  :   Should the script fill in boxes that are empty with the smaller ones, while keeping the size (True by default)

        -- Global: Applies to all boxes
        "Global:Font"       [Str]   :   The Global Font to be used in the script, (Found in Enum.Font) [Defaults to "SourceSans"]
        "Global:Color"      [Str]   :   Where to get the color for all the boxes ("TeamColor", "RankLadder:<RankLadder/Empty for Default>") [Defaults to being the TeamColor, if not then its set to ]

        -- Box1, Box2, Box3, Box4: Smaller Incrementing Box Sizes
        -- The Rank Ladder or Team or GroupRankName to base this text on
        -- (Example: "Disabled", "Username", "SetText:", "TeamName", "RblxGroupID:<GroupID>", "RankLadder:<RankLadder/Empty for Default>")
        -- [Note: For Groups, it takes what ever the player's rank's Name is (Also known as Role)]
        -- NOTE: You can also have it as a table, but the index has to be a Team, so that that setting would apply only if the player is in THAT team.
        "Box1:Text"      [Str/Tab]   :   See Above
        "Box2:Text"      [Str/Tab]   :   See Above
        "Box4:Text"      [Str/Tab]   :   See Above
        "Box3:Text"      [Str/Tab]   :   See Above
    },
    --- SimpleTitles Group Addon Setting Format ---
    {
        "Global:Color"   [Col3/Str] :   A Color3, OR a BrickColor name to set the color as
        "Box1:Text"         [Str]   :   Examples: "Disabled", "Username", "SetText:<Text>" (Box1 Cannot be based off TeamNames)
        "Box2:Text"         [Str]   :   Examples: "Disabled", "TeamName", "SetText:<Text>", "RblxGroupID:<GroupID>"
        "Box3:Text"         [Str]   :   Examples: "Disabled", "TeamName", "SetText:<Text>", "RblxGroupID:<GroupID>"
        "Box3:Text"         [Str]   :   Examples: "Disabled", "TeamName", "SetText:<Text>", "RblxGroupID:<GroupID>"
    }
    -- ToolGiver: A simple addon to configure tools to be given to groups
    -- Tools are configured on a Per-Team Basis
    {
        "Enabled            [Bool]  :   Wether or not the addon is enabled
        ~~ Optional Settings ~~
        "ToolStorage" [Obj/Arr:Obj] :   A location to get the tools from in Roblox, OR an array of Objects to get the tools from (Example "  = {game.ServerStorage.Tools, game.Workspace.Tools}")

        "GroupBlackList"  [Tab:Str] :   Groups that are blacklisted from reciving any tools
        "TeamBlackList"   [Tab:Obj] :   Teams that are blacklisted from reciving any tools

        "AllowMultipleTools" [Bool] :   Wether or not a player can get more than one of each tool (Disabled by default)
        "MultiToolTable"  [Arr:Str] :   An array of tool names that is allowed to give multiple of (All of them allowed if this table doesn't exist)

        "AllowTeamGive"     [Bool]  :   Wether or not TeamGiving is allowed (Tools inside the Teams)
        "TeamToolGive"    [Tab:Str] :   A Table with an index of teams, and a value of arrays which contains Tools (Example: "  [game.Teams.BlaBla] = {"Tool1", "Tool2", "Tool3"}  ")

        "GlobalToolGive"  [Arr:Str] :   An array of tools given to anyone
    }
    }
--]]
