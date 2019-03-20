--[[
    Utils.lua
    -> An All-In-One-Place script for most helper functions, to help save space and make
         reading scripts less confusing
    -> Mostly is just iterators
]]

local Utils = {}

-- This Function is hella handy when dealing with advanced tables
Utils.ObjInArray = function(Array, Obj)
    for _, v in pairs(Array) do
        if v == Obj then
            return true
        end
    end
    return false
end
-- Useful for Arrays
Utils.GetArrayIndex = function(Array, Obj)
    for i, v in pairs(Array) do
        if v == Obj then
            return i
        end
    end
    return nil
end
-- Useless Table Merge Function
Utils.TableMerge = function(...)
    local Tables = {...}
    local MergedTable = {}

    for i1, v1 in pairs(Tables) do
        for i2, v2 in pairs(v1) do
            if type(i2) == "number" then
                table.insert(MergedTable, v2)
            else
                MergedTable[v1] = v2
            end
        end
    end

    return MergedTable
end

return Utils
