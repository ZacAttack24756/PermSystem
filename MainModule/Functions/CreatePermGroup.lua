--[[
	CreatePermGroup
	Params:
		Name		:	The Name for the group
		Data		:	The Data for the group (in a table)
--]]

local MTable = {}
MTable.__index = MTable
-- Insert Meta things here
local Debug = false

function MTable:PlayerBelongsInGroup(PlayerObj)
	local Pass = false
	local PlrId = PlayerObj.UserId

	if self.Options.SubGroup == true then
		return false
	end

	if self.Default == true then
		return true
	end

	for _, v in pairs(self.AccessList) do
		if string.sub(v, 1, 7) == "UserId:" then
			local Num = tonumber(string.sub(v, 8))
			if type(Num) == "number" then
				if PlayerObj.UserId == Num then
					Pass = true
					break
				end
			end
		elseif string.sub(v, 1, 9) == "Username:" then
			local Name = string.sub(v, 10)
			if type(Name) == "string" then
				if PlayerObj.Name == Name then
					Pass = true
					break
				end
			end
		end
	end

	for _, v in pairs(self.RblxGroup) do
		local GroupRank = PlayerObj:GetRankInGroup(v.ID)
		if     v.Cond == ">=" and GroupRank >= v.Rank then
			Pass = true
			break
		elseif v.Cond == "<=" and GroupRank <= v.Rank then
			Pass = true
			break
		elseif v.Cond == "==" and GroupRank == v.Rank then
			Pass = true
			break
		elseif v.Cond == "~=" and GroupRank ~= v.Rank then
			Pass = true
			break
		end
	end

	for _, v in pairs(self.Gamepasses) do
		if type(v) == "number" then
			local Passed, Return = pcall(function()
				return MarketPlaceService:UserOwnsGamePassAsync(PlrId, v)
			end)
			if Passed then
				if Return == true then
					Pass = true
					break
				end
			end
		end
	end

	for _, v in pairs(self.RblxTeams) do
		if PlayerObj.Neutral == false and type(PlayerObj.Team) == "userdata" and type(v) == "userdata" and PlayerObj.Team == v then
			Pass = true
			break
		end
	end

	return Pass
end
function MTable:GroupHasPerm(Perm)
	if self.Options.Override == "Administrator" then
		return true
	elseif self.Options.Override == "NoAccess" then
		return false
	end

	for i1, v1 in pairs(self.Perms) do
		-- Logic Dealing with basic S
		if v1 == Perm then
			return true
		elseif string.match(v1, Perm) == Perm then
			if string.sub(v1, 1, 1) == "-" then
				return false
			else
				return true
			end
		end

		-- Split each into it's components
		local VComp = {}
		if string.sub(v1, 1, 1) == "-" then
			table.insert(VComp, "-")
		end
		for v2 in string.gmatch(v1  , "(\.[%P]*)") do
			table.insert(VComp, string.sub(v2, 2))
		end
		local PComp = {}
		for v2 in string.gmatch(Perm, "(\.[%P]*)") do
			table.insert(PComp, string.sub(v2, 2))
		end
		-- Compare them Side by Side
		for i2, v2 in pairs(PComp) do
			if VComp[v2] == PComp[v2] then
				if table.getn(VComp) == i2 then
					if VComp[1] ~= "-" then
						return true
					else
						return false
					end
				end
				-- continue
			elseif VComp[v2] == "*" then
				-- Person has a ALL PERMISSIONS qualifier
				if VComp[1] == "-" then
					return false
				else
					return true -- Return true because the guy has all the permissions
				end
			else
				return false
			end
		end

		return false
	end
end

return function(Data, Name, Groups)
	-- Checks the main Table, and The required things
	if type(Data) ~= "table" then return "Data is not a Table!" end
	if type(Name) ~= "string" or Name == "" then return "Name is not a string!" end

	if type(Data.Rank) ~= "number" then return "Data.Rank is not a number!" end
	if (Data.Rank < 0) or (Data.Rank == math.huge) then return "Data.Rank is smaller than 0, or as large as math.huge!" end

	----    Required Error Checking Done    ----

	-- Main Meta Tabling
	local Content = {}
	Content.Name = Name
	Content.Rank = Data.Rank

	-- Permission Filtering (Every permission has to have ".<blabla>.<blabla>" etc)
	Content.Perms = {}
	if type(Data.Perms) == "table" then
		for _, value in pairs(Data.Perms) do
			local Pattern = "[\.%P|\*]*"
			local Found = string.match(value, Pattern)

			-- If theres a match
			if type(Found) == "string" and Found ~= "" then
				-- Passes a "-" along
				if string.sub(value, 1, 1) == "-" then
					Found = "-" .. Found
				end

				table.insert(Content.Perms, Found)
			end
		end
	end

	Content.Default = false
	if type(Data.Default) == "bool" then
		Content.Default = Data.Default
	end

	Content.RankLadder = "Default"
	if type(Data.RankLadder) == "string" then
		Content.RankLadder = Data.RankLadder
	end
	for i, v in pairs(Groups) do
		if i == Name then
			return "Group Name Already taken!"
		end
		if v.Rank == Data.Rank and v.RankLadder == Data.RankLadder then
			return "Group Rank Already taken! Taken by: '".. i .."' with a rank of '".. v.Rank .."'."
		end
	end

	Content.Inheritance = {}
	if type(Data.Inheritance) == "string" then
		Content.Inheritance = {Data.Inheritance}
	elseif type(Data.Inheritance) == "table" then
		for _, v in pairs(Data.Inheritance) do
			if type(v) == "string" then
				table.insert(Content.Inheritance, v)
			end
		end
	end

	Content.Options = {}
	Content.Options.SaveUsers = false
	Content.Options.Override = "Normal"
	Content.Options.SubGroup = false
	Content.Options.Priority = 0
	if type(Data.Options) == "table" then
		if type(Data.Options.SaveUsers) == "boolean" then
			Content.Options.SaveUsers = Data.Options.SaveUsers
		end

		if type(Data.Options.Override) == "string" then
			local Override = Data.Options.Override
			if (Override == "NoAccess" or Override == "Normal" or Override == "Administrator") then
				Content.Options.Override = Override
			end
		end

		if type(Data.Options.SubGroup) == "boolean" then
			Content.Options.SubGroup = Data.Options.SubGroup
		end

		if type(Data.Options.Priority) == "number" and (-1 * math.huge <= Data.Options.Priority) and (Data.Options.Priority <= math.huge) then
			Content.Options.Priority = Data.Options.Priority
		end
	end

	Content.AccessList = {}
	if type(Data.AccessList) == "table" then
		for _, v in pairs(Data.AccessList) do
			if type(v) == "string" and (string.sub(v, 1, 7) == "UserId:" or string.sub(v, 1, 9) == "Username:") then
				table.insert(Content.AccessList, v)
			end
		end
	end

	Content.RblxGroup = {}
	if type(Data.RobloxGroup) == "table" then
		for _, v in pairs(Data.RobloxGroup) do
			if type(v) == "table" then
				if type(v.ID) == "number" then
					if type(v.Cond) == "string" and (v.Cond == ">=" or v.Cond == "<=" or v.Cond == "==" or v.Cond == "~=") then
						if type(v.Rank) == "number" and (v.Rank >= 0 and v.Rank < 10^30) then
							-- Make the Obj
							local Tab = {}
							Tab.ID = v.ID
							Tab.Cond = v.Cond
							Tab.Rank = v.Rank

							table.insert(Content.RblxGroup, Tab)
							Content.Options.SaveUsers = false
							if Debug==true then print("Successful Group Make Name: '".. Content.Name .."', ID: '".. v.ID .."', Cond: '".. v.Cond .."', Rank: '".. v.Rank .."'") end
						else
							print("Can't Make RblxGroup '".. Content.Name .."', Rank: '".. type(v.Rank))
						end
					else
						print("Can't Make RblxGroup '".. Content.Name .."', Cond: '".. type(v.Cond))
					end
				else
					print("Can't Make RblxGroup '".. Content.Name .."', ID: '".. type(v.ID))
				end
			end
		end
	end

	Content.RblxTeams = {}
	if type(Data.RobloxTeam) == "table"	then
		for _, v in pairs(Data.RobloxTeam) do
			if type(v) == "userdata" then
				if v:IsA("Team") and v.Parent == game:GetService("Teams") then
					table.insert(Content.RblxTeams, tostring(v.Name))
					Content.Options.SaveUsers = false
				end
			end
		end
	elseif type(Data.RobloxTeam) == "userdata" then
		if Data.RobloxTeam:IsA("Team") and Data.RobloxTeam.Parent == game:GetService("Teams") then
			table.insert(Content.RblxTeams, tostring(Data.RobloxTeam.Name))
			Content.Options.SaveUsers = false
		end
	end

	Content.Gamepasses = {}
	if type(Data.RobloxGamepass) == "number" and 0 < Data.Gamepasses and Data.Gamepasses < math.huge then
		Content.Gamepasses = {Data.RobloxGamepass}
	elseif type(Data.RobloxGamepass) == "table" then
		for _, v in pairs(Data.RobloxGamepass) do
			if type(v) == "number" and 0 < v and v < math.huge then
				table.insert(Content.Gamepasses, v)
			end
		end
	end

	Content.Addons = {}
	if type(Data.Addons) == "table" then
		for i, v in pairs(Data.Addons) do
			if type(i) == "string" and type(v) == "table" then
				Content.Addons[i] = v
			end
		end
	end

	-- Creates Table, and returns it
	local self = setmetatable(Content, MTable)
	return self
end
