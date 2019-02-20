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
            RobloxGroup = {
                ID = 3519516,
                Cond = "==",
                Rank = 1,
            },
        },
        ["ClassE"] = {
            Rank = 2,
            Perms = {},
            Inheritance = "ClassD",
            RobloxGroup = {
                ID = 3519516,
                Cond = "==",
                Rank = 2,
            },
        },
        --------------------
        ["ClassA"] = {
            Rank = 4,
            Perms = {},
            Inheritance = "Level1", -- ClassA deserve, at-most, Level 1
            RobloxGroup = {
                ID = 3519516,
                Cond = "==",
                Rank = 4,
            },
        },
        ["Level0"] = {
            Rank = 5,
            Perms = {},
            Inheritance = "ClassD",
            RobloxGroup = {
                ID = 3519516,
                Cond = "==",
                Rank = 5,
            },
        },
        ["Level1"] = {
            Rank = 6,
            Perms = {},
            Inheritance = "Level0",
            RobloxGroup = {
                ID = 3519516,
                Cond = "==",
                Rank = 6,
            },
        },
        ["Level2"] = {
            Rank = 7,
            Perms = {},
            Inheritance = "Level1",
            RobloxGroup = {
                ID = 3519516,
                Cond = "==",
                Rank = 7,
            },
        },
        ["Level3"] = {
            Rank = 8,
            Perms = {},
            Inheritance = "Level2",
            RobloxGroup = {
                ID = 3519516,
                Cond = "==",
                Rank = 8,
            },
        },
        --------------------
        ["Level4"] = {
            Rank = 10,
            Perms = {},
            Inheritance = "Level3",
            RobloxGroup = {
                ID = 3519516,
                Cond = "==",
                Rank = 10,
            },
        },
        ["SiteDirector"] = {
            Rank = 11,
            Perms = {},
            Inheritance = "Level4",
            RobloxGroup = {
                ID = 3519516,
                Cond = "==",
                Rank = 11,
            },
        },
        --------------------
        ["O5Council"] = {
            Rank = 13,
            Perms = {},
            Inheritance = "SiteDirector",
            RobloxGroup = {
                ID = 3519516,
                Cond = "==",
                Rank = 13,
            },
        },
        ["O5X"] = {
            Rank = 14,
            Perms = {},
            Inheritance = "O5Council",
            RobloxGroup = {
                ID = 3519516,
                Cond = "==",
                Rank = 14,
            },
        },
        ["Admini"] = {
            Rank = 255,
            Perms = {},
            Options = {
                Override = "Administrator"
            },
            RobloxGroup = {
                ID = 3519516,
                Cond = "==",
                Rank = 255,
            },
        },
        -------------------
        -- Sub Divisions --
        -------------------
        ["AD_Member"] = {
            Rank = 0,
            RankLadder = "AD",
            RobloxGroup = {
                ID = 3534520,
                Cond = ">=",
                Rank = 1,
            },
        },
        ["DEA_Member"] = {
            Rank = 0,
            RankLadder = "DEA",
            RobloxGroup = {
                ID = 3736895,
                Cond = ">=",
                Rank = 1,
            },
        },
        ["ISD_Member"] = {
            Rank = 0,
            RankLadder = "ISD",
            RobloxGroup = {
                ID = 3736895,
                Cond = ">=",
                Rank = 1,
            },
        },
        ["OOA_Member"] = {
            Rank = 0,
            RankLadder = "OOA",
            RobloxGroup = {
                ID = 3703115,
                Cond = ">=",
                Rank = 1,
            },
        },
        ["MaD_Member"] = {
            -- the mad boys
            Rank = 0,
            RankLadder = "MaD",
            Inheritance = "AD_Member",
            RobloxGroup = {
                ID = 3660200,
                Cond = ">=",
                Rank = 1,
            },
        },
        ["MD_Member"] = {
            Rank = 0,
            RankLadder = "MD",
            RobloxGroup = {
                ID = 3610184,
                Cond = ">=",
                Rank = 1,
            },
        },
        ["IA_Member"] = {
            Rank = 0,
            RankLadder = "IA",
            Inheritance = "AD_Member",
            RobloxGroup = {
                ID = 3602927,
                Cond = ">=",
                Rank = 1,
            },
        },
        ["SD_Member"] = {
            Rank = 0,
            RankLadder = "SD",
            RobloxGroup = {
                ID = 3545062,
                Cond = ">=",
                Rank = 1,
            },
        },
        ["ScD_Member"] = {
            Rank = 0,
            RankLadder = "ScD",
            RobloxGroup = {
                ID = 3540272,
                Cond = ">=",
                Rank = 1,
            },
        },
        ["EC_Member"] = {
            Rank = 0,
            RankLadder = "EC",
            RobloxGroup = {
                ID = 3540241,
                Cond = ">=",
                Rank = 1,
            },
        },
        ["MTF_Member"] = {
            Rank = 0,
            RankLadder = "MTF",
            RobloxGroup = {
                ID = 3534520,
                Cond = ">=",
                Rank = 1,
            },
        },
    },
    Addons = {
        ["SimpleTitles"] = {
            ["Enabled"] = true,
            ["Global:Color"] = "TeamColor",
            ["Box1:Text"] = "RankLadder:Default",
            ["Box2:Text"] = {
                [Teams["AD"]]  = "RblxGroup:3534520",-- AD
                [Teams["DEA"]] = "RblxGroup:3736895",-- DEA
                [Teams["OOA"]] = "RblxGroup:3703115",-- OOA
                [Teams["MaD"]] = "RblxGroup:3660200",-- MaD
                [Teams["MD"]]  = "RblxGroup:3610184",-- MD
                [Teams["IA"]]  = "RblxGroup:3602927",-- IA
                [Teams["SD"]]  = "RblxGroup:3545062",-- SD
                [Teams["ScD"]] = "RblxGroup:3540272",-- ScD
                [Teams["EC"]]  = "RblxGroup:3540241",-- EC
                [Teams["MTF"]] = "RblxGroup:3534520",-- MTF
            },
        }
    }
    Options = {
        Enabled = true,
        CreatorPrivileges = true,
    },
}

local Return = require(2600240923)(Settings)
if type(Return) == "string" then
	error(Return)
end
