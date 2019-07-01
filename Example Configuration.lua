-- This is an Example Configuration for Toximay's SCPF: https://www.roblox.com/groups/3519516
-- #NoticeMeTox
local Teams = game:GetService("Teams")
local Settings = {
    Groups = {
        ["Default"] = {
            Rank = 0,
            Perms = {},
            Default = true,
        },
        ["ClassD"] = {
            Rank = 1,
            Perms = {},
            Inheritance = "Default",
            RobloxGroup = {{
                ID = 3519516,
                Cond = "==",
                Rank = 1,
            }},
            Addons = {
                ["SimpleTitles"] = {
                    ["Box3:Text"] = "SetText:Class D"
                }
            },
        },
        ["ClassE"] = {
            Rank = 2,
            Perms = {},
            Inheritance = "ClassD",
            RobloxGroup = {{
                ID = 3519516,
                Cond = "==",
                Rank = 2,
            }},
            Addons = {
                ["SimpleTitles"] = {
                    ["Box3:Text"] = "SetText:Class E"
                }
            },
        },
        --------------------
        ["ClassA"] = {
            Rank = 4,
            Perms = {},
            Inheritance = "Level1", -- ClassA deserve, at-most, Level 1
            RobloxGroup = {{
                ID = 3519516,
                Cond = "==",
                Rank = 4,
            }},
            Addons = {
                ["SimpleTitles"] = {
                    ["Box3:Text"] = "SetText:Class A"
                }
            },
        },
        ["Level0"] = {
            Rank = 5,
            Perms = {},
            Inheritance = "ClassD",
            RobloxGroup = {{
                ID = 3519516,
                Cond = "==",
                Rank = 5,
            }},
            Addons = {
                ["SimpleTitles"] = {
                    ["Box3:Text"] = "SetText:Level 0"
                }
            },
        },
        ["Level1"] = {
            Rank = 6,
            Perms = {},
            Inheritance = "Level0",
            RobloxGroup = {{
                ID = 3519516,
                Cond = "==",
                Rank = 6,
            }},
            Addons = {
                ["SimpleTitles"] = {
                    ["Box3:Text"] = "SetText:Level 1"
                }
            },
        },
        ["Level2"] = {
            Rank = 7,
            Perms = {},
            Inheritance = "Level1",
            RobloxGroup = {{
                ID = 3519516,
                Cond = "==",
                Rank = 7,
            }},
            Addons = {
                ["SimpleTitles"] = {
                    ["Box3:Text"] = "SetText:Level 2"
                }
            },
        },
        ["Level3"] = {
            Rank = 8,
            Perms = {},
            Inheritance = "Level2",
            RobloxGroup = {{
                ID = 3519516,
                Cond = "==",
                Rank = 8,
            }},
            Addons = {
                ["SimpleTitles"] = {
                    ["Box3:Text"] = "SetText:Level 3"
                },
                ["ToolGiver"] = {
                    ToolBlackList = {"Pistol"},
                    ToolGiveList = {"[SCP] Card-L5"}
                }
            },
        },
        --------------------
        ["Level4"] = {
            Rank = 10,
            Perms = {},
            Inheritance = "Level3",
            RobloxGroup = {{
                ID = 3519516,
                Cond = "==",
                Rank = 10,
            }},
            Addons = {
                ["SimpleTitles"] = {
                    ["Box3:Text"] = "SetText:Level 4"
                }
            },
        },
        ["SiteDirector"] = {
            Rank = 11,
            Perms = {},
            Inheritance = "Level4",
            RobloxGroup = {{
                ID = 3519516,
                Cond = "==",
                Rank = 11,
            }},
            Addons = {
                ["SimpleTitles"] = {
                    ["Box3:Text"] = "SetText:Site Director"
                }
            },
        },
        --------------------
        ["O5Council"] = {
            Rank = 13,
            Perms = {".*"}, -- For testing purposes only
            Inheritance = "SiteDirector",
            RobloxGroup = {{
                ID = 3519516,
                Cond = "==",
                Rank = 13,
            }},
            Addons = {
                ["SimpleTitles"] = {
                    ["Box3:Text"] = "SetText:[REDACTED]"
                }
            },
        },
        ["O5X"] = {
            Rank = 14,
            Perms = {},
            Inheritance = "O5Council",
            RobloxGroup = {{
                ID = 3519516,
                Cond = "==",
                Rank = 14,
            }},
            Addons = {
                ["SimpleTitles"] = {
                    ["Box3:Text"] = "SetText:[REDACTED]"
                }
            },
        },
        ["Admini"] = {
            Rank = 255,
            Perms = {},
            Options = {
                Override = "Administrator"
            },
            RobloxGroup = {{
                ID = 3519516,
                Cond = "==",
                Rank = 255,
            }},
            Addons = {
                ["SimpleTitles"] = {
                    ["Box3:Text"] = "SetText:The Administrator"
                }
            },
        },
        -------------------
        -- Sub Divisions --
        -------------------
        ["AD_Member"] = {
            Rank = 0,
            RankLadder = "AD",
            RobloxGroup = {{
                ID = 3534520,
                Cond = ">=",
                Rank = 1,
            }},
        },
        ["DEA_Member"] = {
            Rank = 0,
            RankLadder = "DEA",
            RobloxGroup = {{
                ID = 3736895,
                Cond = ">=",
                Rank = 1,
            }},
        },
        ["ISD_Member"] = {
            Rank = 0,
            RankLadder = "ISD",
            RobloxGroup = {{
                ID = 3736895,
                Cond = ">=",
                Rank = 1,
            }},
        },
        ["OOA_Member"] = {
            Rank = 0,
            RankLadder = "OOA",
            RobloxGroup = {{
                ID = 3703115,
                Cond = ">=",
                Rank = 1,
            }},
        },
        ["MaD_Member"] = {
            -- the mad boys
            Rank = 0,
            RankLadder = "MaD",
            Inheritance = "AD_Member",
            RobloxGroup = {{
                ID = 3660200,
                Cond = ">=",
                Rank = 1,
            }},
        },
        ["MD_Member"] = {
            Rank = 0,
            RankLadder = "MD",
            RobloxGroup = {{
                ID = 3610184,
                Cond = ">=",
                Rank = 1,
            }},
        },
        ["IA_Member"] = {
            Rank = 0,
            RankLadder = "IA",
            Inheritance = "AD_Member",
            RobloxGroup = {{
                ID = 3602927,
                Cond = ">=",
                Rank = 1,
            }},
        },
        ["SD_Member"] = {
            Rank = 0,
            RankLadder = "SD",
            RobloxGroup = {{
                ID = 3545062,
                Cond = ">=",
                Rank = 1,
            }},
        },
        ["ScD_Member"] = {
            Rank = 0,
            RankLadder = "ScD",
            RobloxGroup = {{
                ID = 3540272,
                Cond = ">=",
                Rank = 1,
            }},
        },
        ["EC_Member"] = {
            Rank = 0,
            RankLadder = "EC",
            RobloxGroup = {{
                ID = 3540241,
                Cond = ">=",
                Rank = 1,
            }},
        },
        ["MTF_Member"] = {
            Rank = 0,
            RankLadder = "MTF",
            RobloxGroup = {{
                ID = 3534520,
                Cond = ">=",
                Rank = 1,
            }},
        },
    },
    Addons = {
        ["SimpleTitles"] = {
            Enabled = true,
            ["Global:Font"] = "Highway",
            ["Global:Color"] = "TeamColor",
            ["Box1:Text"] = {
                ["IA"] = "SetText:[REDACTED]",
                ["Default"] = "Username",
            },
            ["Box2:Text"] = {
                ["AD"]  = "SetText:Sample Text",-- AD
                ["DEA"] = "RblxGroupID:3736895",-- DEA
                ["OOA"] = "RblxGroupID:3703115",-- OOA
                ["MaD"] = "RblxGroupID:3660200",-- MaD
                ["MD"]  = "RblxGroupID:3610184",-- MD
                ["IA"]  = "RblxGroupID:3602927",-- IA
                ["SD"]  = "RblxGroupID:3545062",-- SD
                ["ScD"] = "RblxGroupID:3540272",-- ScD
                ["EC"]  = "RblxGroupID:3540241",-- EC
                ["MTF"] = "RblxGroupID:3534520",-- MTF
                ["FP"]  = "Disabled" -- Do nothing
            },
            ["Box3:Text"] = "RankLadder:Default",
        },
        ["ToolGiver"] = {
            Enabled = true,
            -- (For this example, I used free modeled tools. You can use your own)
            ToolStorage = game:GetService("ServerStorage").ToolStorage,
            AllowDupeTools = false, -- nobody likes having 10 of the same tool
            TeamGive = {
                [game.Teams.FP] = {"BlueKatana",},
                [game.Teams.IA] = {"RocketLauncher",},
            },
            GlobalToolGive = {},
        },
        ["Cards"] = {
            Enabled = true,
        }
    },
    Options = {
        Enabled = true,
        CreatorPrivileges = true,
        CheckRate = 300,
    },
}

local Return = require(2892139643)(Settings) --Don't use in regular games!
if type(Return) == "string" then
	error(Return)
end
wait(2)

local PermFunc = game:GetService("ReplicatedStorage"):FindFirstChild("PermSystem")
local function PlayerStuff(plr)
    plr.CharacterAdded:Connect(function(char)
        wait(2.5)
        local Cards = {
            PermFunc:Invoke("Cards_Create", "GroupCard", "O5Council", {
                Color1 = BrickColor.new("Really black"),
                Color2 = BrickColor.new("Institutional white"),
                Text = "O5 Council Access Card",
                Name = "O5 Keycard",
            }),
            PermFunc:Invoke("Cards_Create", "GroupCard", "SiteDirector", {
                Color1 = BrickColor.new("Really red"),
                Color2 = BrickColor.new("Institutional white"),
                Text = "Facility Manager Access Card",
                Name = "Facility Manager Keycard",
            }),
            PermFunc:Invoke("Cards_Create", "GroupCard", "SiteDirector", {
                Color1 = BrickColor.new("Navy blue"),
                Color2 = BrickColor.new("Institutional white"),
                Text = "Zone Manager Access Card",
                Name = "Zone Manager Keycard",
            }),
        }
        for _, Card in pairs(Cards) do
            if typeof(Card) == "Instance" and Card:IsA("Tool") then
                Card.Parent = plr.Backpack
                Card.Run.Disabled = false
            end
        end
    end)
end
for _, v in pairs(game.Players:GetChildren()) do
    PlayerStuff(v)
end
game.Players.PlayerAdded:Connect(PlayerStuff)
