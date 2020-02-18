-- Tool Service
-- MrAsync
-- February 16, 2020


--[[
    
    Handles client-server communication for sand farming

]]


local ToolService = {Client = {}}

--//Services
local beachService

--//Controllers

--//Classes

--//Data

--//Locals


function ToolService.Client:FarmSand(player, sandPart)
    assert(sandPart:IsDescendantOf(workspace.Beaches), "Invalid sand part")

    local sandModel = sandPart.Parent
    local beachContainer = sandModel.Parent.Parent
    local beachObject = beachService:GetBeachObjectFromContainer(beachContainer)
    beachObject:FarmBlock(sandModel.MapPosition.Value)
end


function ToolService:Start()

end


function ToolService:Init()
    --//Services
    beachService = self.Services.BeachService
    
    --//Controllers
    
    --//Classes
    
    --//Data
    
    --//Locals
    
end


return ToolService