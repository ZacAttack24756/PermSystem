-- This is an Example Configuration for Toximay's SCPF: https://www.roblox.com/groups/3519516
-- #NoticeMeTox
local Settings = {
    Groups = {
        ["Default"] = {
            Rank = 0
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
        }
    }
}

-- The script hasn't been published to roblox yet, so this is the stand-in
require("The_Script_Location")(Settings)
