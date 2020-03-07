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

function ToolService.Client:ButtonDown(player)
    local playerObject = PlayerLoaderService:GetPlayerObject(player)
    local invokeTime = os.time()

    if (not playerObject:Get("IsFarming")) then
        playerObject:Set("IsFarming", true)

        --Start coroutine

        return {
            true
        }
    end

    return false
end

function ToolService.Client:ButtonUp(player)
    local playerObject = PlayerLoaderService:GetPlayerObject(player)

    if (playerObject:Get("IsFarming")) then
        playerObject:Set("IsFarming", false)

    --Kill coroutine
    end
end

function ToolService.Client:CalculateFarmTime(player, beachObject, blockModel)
    local invokeTime = os.time()

    local playerObject = PlayerLoaderService:GetPlayerObject(player)

    return
end

function ToolService.Client:FarmBlock(player, beachContainer, blockModel)
    assert(blockModel:IsDescendantOf(workspace.Beaches), "Invalid blockModel")

    --Get playerObject and lastFarmInfo
    local playerObject = PlayerLoaderService:GetPlayerObject(player)

    --Get tool information
    local toolId = playerObject:Get("EquippedTool")
    local toolMetaData = MetaDataService:GetMetaData(toolId)

    --Get blockObject and blockMetaData using Function Calls from GetBeachObjectFromContainer
    local beachObject = BeachService:GetBeachObjectFromContainer(beachContainer)
    local blockObject = beachObject:GetBlockAtPosition(blockModel.MapPosition.Value)
    local blockMetaData = MetaDataService:GetMetaData(blockObject.Id)

    -- --Calculate time, in seconds, the tool needs to farm the block
    -- local farmTimeNeeded = blockMetaData.Hardness / toolMetaData.Strength
    -- local targetFarmTime = invokeTime + farmTimeNeeded

    -- while (os.time() < targetFarmTime) do
    --     wait()
    -- end

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
