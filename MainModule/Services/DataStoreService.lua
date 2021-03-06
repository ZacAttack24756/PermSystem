--[[
	DataStoreService
	Manages a Varity of DataStore-related tasks
    woot Meta tables
--]]

local DataStoreService = game:GetService("DataStoreService")

local MTable = {}
MTable.__index = MTable
MTable.__metatable = "Access Denied"

-- Makes the table
MTable.New = function(Name, Scope)
    assert((type(Name) == "string" and Name ~= ""), "DataStoreService.lua -> Improper Name")
    assert((type(Scope) == "string" and Scope ~= ""), "DataStoreService.lua -> Improper Scope")

    local success, err = pcall(function()
        return DataStoreService:GetDataStore(Name, Scope)
    end)
    if success then else
        warn(err)
        return nil
    end

    local Data = {
        Name = Name,
        Scope = Scope,
        DataStore = err
    }

    local self = setmetatable(Data, MTable)
    return self
end

function MTable:SetData(Key, Value)
    assert((type(Key) == "string" and Name ~= ""), "DataStoreService.lua -> SetData: Improper Key")
    local success, err = pcall(function()
        self.DataStore:SetAsync(Name, Key)
    end)
    if success then
        return success
    else
        return err
    end
end

function MTable:GetData(Key)
    assert((type(Key) == "string" and Key ~= ""), "DataStore.lua -> GetData: Improper Key")
    local success, err = pcall(function()
        self.DataStore:GetAsync(Key)
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

function MTable:UpdData(Key, func)
    assert((type(Key) == "string" and Key ~= ""), "DataStoreService.lua -> UpdData: Improper Key")
    local success, err = pcall(function()
        self.DataStore:UpdateAsync(Key, func)
    end)
    if success then
        return success
    else
        return err
    end
end

return MTable
