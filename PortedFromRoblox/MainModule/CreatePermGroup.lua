--[[
	CreatePermGroup
	Params:
		Name		:	The Name for the group
		Data		:	The Data for the group (in a table)
--]]

local MTable = {}
MTable.__index = MTable
-- Insert Meta things here

MTable:PlayerBelongsInGroup = function(PlayerObj)
	local Pass = false

	if self.Default == true then
		Pass = true
	end

	for _, v in pairs(self.RblxGroup) do
		local GroupRank = PlayerObj:GetRankInGroup(v.ID)
		if     v.Cond == ">=" and GroupRank >= v.Rank then
			Pass = true
		elseif v.Cond == "<=" and GroupRank <= v.Rank then
			Pass = true
		elseif v.Cond == "==" and GroupRank == v.Rank then
			Pass = true
		elseif v.Cond == "~=" and GroupRank ~= v.Rank then
			Pass = true
		end
	end

	for _, v in pairs(G.RblxTeams) do
		if PlayerObj.Neutral == false and type(PlayerObj.Team) == "userdata" and type(v) == "userdata" and PlayerObj.Team = v then
			Pass = true
		end
	end

	return Pass
end
MTable:GroupHasPerm = function(Perm)
	for i1, v1 in pairs(self.Perms) do
		if v1 == Perm then
			return true
		elseif string.match(v1, Perm) == Perm then
			return true
		end

		-- Split each into it's components
		local VComp = {}
		for v2 in string.gmatch(v1  , "(\.[%w]*)") do
			table.insert(VComp, v2)
		end
		local PComp = {}
		for v2 in string.gmatch(Perm, "(\.[%w]*)") do
			table.insert(PComp, v2)
		end
		-- Compare them Side by Side
		for i2, v2 in pairs(PComp) do
			if VComp[v2] == PComp[v2] then
				if table.getn(VComp) == i2 then
					return true
				end
				-- continue
			elseif VComp[v2] == ".*" then
				return true -- Return true because the guy has all the permissions
			else
				return false
			end
		end

		return false
	end
end

return function(Data)
	-- Checks the main Table, and The required things
	if type(Data) ~= "table" then return "Data is not a Table!" end
	if type(Data.Name) ~= "string" or Data.Name == "" then return "Name is not a string!" end
	if type(Data.Rank) ~= "number" then return "Data.Rank is not a number!" end
	if type(Data.Perms) ~= "table" then return "Data.Perms is not a table!" end

	----    Required Error Checking Done    ----

	-- Main Meta Tabling
	local Content = {}
	Content.Name = Name

	-- Permission Filtering (Every permission has to have ".<blabla>.<blabla>" etc)
	Content.Perms = {}
	for _, value in pairs(Data.Perms) do
		local Pattern = "[\.%w|\*]*"
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

	Content.Default = false
	if type(Data.Default) == "bool" then
		Content.Default = Data.Default
	end

	Content.RankLadder = "Default"
	if type(Data.RankLadder) == "string" then
		Content.RankLadder = Data.RankLadder
	end

	Contet.Inheritance = {}
	if type(Data.Inheritance) == "string" then
		Content.Inheritance = {Data.Inheritance}
	elseif type(Data.Inheritance) == "table" then
		for _, v in pairs(Data.Inheritance) do
			if type(v) == "string" then
				table.insert(Content.Inheritance, v)
			end
		end
	end

	Content.RblxGroup = {}
	if type(Data.RobloxGroup) == "table" then
		for _, v in pairs(Data.RobloxGroup) do
			if type(v) == "table" then
				if type(v.ID) == "number" then
					if type(v.Cond) == "string" and (v.Cond == ">=" or v.Cond == "<=" or v.Cond == "==" or v.Cond == "~=") then
						if type(v.Rank) == "number" and v.Rank >= 0 and v.Rank <= 0 then
							-- Make the Obj
							local Tab = {}
							Tab.ID = v.ID
							Tab.Cond = v.Cond
							Tab.Rank = v.Rank

							table.insert(Content.RblxGroup, Tab)
						end
					end
				end
			end
		end
	end

	Content.RblxTeams = {}
	if type(Data.RobloxTeam) == "table"	then
		for _, v in pairs(Data.RobloxTeam) do
			if type(v) == "userdata" then
				if v:IsA("Team") and v.Parent = game:GetService("Teams") then
					table.insert(Content.RblxTeams, tostring(v.Name))
				end
			end
		end
	end

	-- Creates Table, and returns it
	local self = setmetatable(Content, MTable)
	return self
end
