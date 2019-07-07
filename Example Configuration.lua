-- This is an Example Configuration for Toximay's SCPF: https://www.roblox.com/groups/3519516
-- #NoticeMeTox
local Teams = game:GetService("Teams")
local Settings = {
    Groups = {
        ["Default"] = {
            Rank = 0,
            Perms = {},
            Default = true,
            Addons = {
                ["SimpleTitles"] = {
                    ["Box3:Text"] = "SetText:Guest",
                },
                ["Cards"] = {
                    ["Card:Text"] = "None"
                }
            }
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
                },
                ["Cards"] = {
                    ["Card:Color1"] = BrickColor.new("CGA brown"),
                    ["Card:Text"] = "Class D Access"
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
                },
                ["Cards"] = {
                    ["Card:Color1"] = BrickColor.new("Reddish brown"),
                    ["Card:Text"] = "Class E Access"
                }
            },
        },
        --------------------
        ["ClassA"] = {
            Rank = 4,
            Perms = {},
            Inheritance = "Level2", -- ClassA deserve, at-most, Level 1
            RobloxGroup = {{
                ID = 3519516,
                Cond = "==",
                Rank = 4,
            }},
            Addons = {
                ["SimpleTitles"] = {
                    ["Box3:Text"] = "SetText:Class A"
                },
                ["Cards"] = {
                    ["Card:Color1"] = BrickColor.new("Royal purple"),
                    ["Card:Text"] = "Access Level 2"
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
                },
                ["Cards"] = {
                    ["Card:Color1"] = BrickColor.new("Mint"),
                    ["Card:Text"] = "Access Level 0"
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
                },
                ["Cards"] = {
                    ["Card:Color1"] = BrickColor.new("New Yeller"),
                    ["Card:Text"] = "Access Level 1"
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
                },
                ["Cards"] = {
                    ["Card:Color1"] = BrickColor.new("Bright yellow"),
                    ["Card:Text"] = "Access Level 2"
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
                },
                ["Cards"] = {
                    ["Card:Color1"] = BrickColor.new("Deep orange"),
                    ["Card:Text"] = "Access Level 3"
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
                },
                ["Cards"] = {
                    ["Card:Color1"] = BrickColor.new("Neon orange"),
                    ["Card:Text"] = "Access Level 4"
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
                    ["Box3:Text"] = "SetText:Site Director",
                    ["Card:Text"] = "Access Level 4.5"
                },
                ["Cards"] = {
                    ["Card:Color1"] = BrickColor.new("")
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
                },
                ["Cards"] = {
                    ["Card:Color1"] = BrickColor.new("Really red"),
                    ["Card:Text"] = "Access Level 5"
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
                },
                ["Cards"] = {
                    ["Card:Color1"] = BrickColor.new("Really black"),
                    ["Card:Text"] = "Access Level 5"
                }
            },
        },
        ["Admini"] = {
            Rank = 255,
            Perms = {},
            Inheritance = "O5X",
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
                },
                ["Cards"] = {
                    ["Card:Color1"] = BrickColor.new("Really black"),
                    ["Card:Material2"] = "Neon",
                    ["Card:Text"] = "Access Level 6"
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
            ["Card:Color1"] = "{RANKLADDER:Default}",
            ["Card:Color2"] = BrickColor.new("Institutional white"),
            ["Card:Material1"] = "SmoothPlastic",
            ["Card:Material2"] = "{RANKLADDER:Default}",
            ["Card:Font"] = "SciFi",
            ["Card:Text"] = "{USERNAME}\'s Card\n{RANKLADDER:Default}",
            ["Card:Name"] = "{RBLXGROUPID:3519516}",
            ["Card:TextColor"] = Color3.new(15, 15, 15),
            ["GlobalCardGive"] = true
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
