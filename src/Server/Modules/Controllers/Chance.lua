-- Chance
-- MrAsync
-- February 20, 2020


--[[

    Uses weighed probability of Chance Values to calculate a weighted result

]]



local Chance = {}


--//Creates a ChanceTable using MetaData
--//Assumes @param originalTable is a MetaData table
function Chance:ChooseBlock(depthTable)
    local totalWeight = 0;
    
    for blockId, weight in pairs(depthTable) do
        totalWeight = totalWeight + weight
    end

    local random = math.random() * totalWeight
    
    for blockId, weight in pairs(depthTable) do
        if (random < weight) then
            return blockId
        else
            random = random - weight
        end
    end
end


return Chance