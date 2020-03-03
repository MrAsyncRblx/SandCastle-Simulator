-- Tool Service
-- MrAsync
-- February 16, 2020


--[[
    
    Handles client-server communication for sand farming

]]


local ToolService = {Client = {}}

--//Services
local PlayerLoaderService
local MetaDataService
local BeachService

--//Controllers

--//Classes

--//Data

--//Locals


--//Handles incoming request for blockFarming
function ToolService.Client:FarmBlock(player, beachContainer, blockModel)
    assert(blockModel:IsDescendantOf(workspace.Beaches), "Invalid blockModel")

    local playerObject = PlayerLoaderService:GetPlayerObject(player)
    local toolId = playerObject:Get("EquippedTool")

    local toolMetaData = MetaDataService:GetMetaData(toolId)
    
    local beachObject = BeachService:GetBeachObjectFromContainer(beachContainer)
    beachObject:FarmBlock(blockModel.MapPosition.Value)
end


function ToolService:Init()
    --//Services
    PlayerLoaderService = self.Services.PlayerLoader
    MetaDataService = self.Services.MetaDataService
    BeachService = self.Services.BeachService
    
    --//Controllers
    
    --//Classes
    
    --//Data
    
    --//Locals
    
end


return ToolService