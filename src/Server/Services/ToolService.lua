-- Tool Service
-- MrAsync
-- February 16, 2020


--[[
    
    Handles client-server communication for sand farming

]]


local ToolService = {Client = {}}

--//Services
local BeachService

--//Controllers

--//Classes

--//Data

--//Locals


--//Handles incoming request for blockFarming
function ToolService.Client:FarmBlock(player, blockPart)
    assert(blockPart:IsDescendantOf(workspace.Beaches), "Invalid block part")

    --Too jank fix this ASAP
    local blockModel = blockPart.Parent
    local beachContainer = blockModel.Parent.Parent
    local beachObject = BeachService:GetBeachObjectFromContainer(beachContainer)
    beachObject:FarmBlock(blockModel.MapPosition.Value)
end


function ToolService:Start()

end


function ToolService:Init()
    --//Services
    BeachService = self.Services.BeachService
    
    --//Controllers
    
    --//Classes
    
    --//Data
    
    --//Locals
    
end


return ToolService