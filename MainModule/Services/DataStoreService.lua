--[[
	DataStoreService
	Manages a Varity of DataStore-related tasks
--]]

local DataStoreService = game:GetService("DataStoreService")

local MTable = {}
MTable.__index = MTable
MTable.__metatable = "Access Denied"

-- Makes the table
MTable.New = function(Name, Scope)
    assert((type(Name) == "string" and Name ~= ""), "DataStoreService.lua -> Improper Name")
    assert((type(Scope) == "string" and Scope ~= ""), "DataStoreService.lua -> Improper Scope")

    local Store = DataStoreService:GetDataStore(Name, Scope)

    local Data = {
        Name = Name,
        Scope = Scope,
        DataStore = Store
    }

    local self = setmetatable(Data, MTable)
    return self
end

function MTable:SetData(Name, Value)
    assert((type(Name) == "string" and Name ~= ""), "DataStoreService.lua -> SetData: Improper Key")
    local success, err = pcall(function()
        self.DataStore:SetAsync(Name, Value)
    end)
    if success then
        return success
    else
        return err
    end
end

function MTable:GetData(Name)
    assert((type(Name) == "string" and Name ~= ""), "DataStore.lua -> GetData: Improper Key")
    local success, err = pcall(function()
        self.DataStore:GetAsync(Name)
    end)
    if success then
        return success
    else
        return err
    end
end

function MTable:DelData(Name)
    assert((type(Name) == "string" and Name ~= ""), "DataStoreService.lua -> DelData: Improper Key")
    local success, err = pcall(function()
        self.DataStore:RemoveAsync(Name)
    end)
    if success then
        return success
    else
        return err
    end
end

function MTable:UpdData(Name, func)
    assert((type(Name) == "string" and Name ~= ""), "DataStoreService.lua -> UpdData: Improper Key")
    local success, err = pcall(function()
        self.DataStore:UpdateAsync(Name, func)
    end)
    if success then
        return success
    else
        return err
    end
end

return MTable
