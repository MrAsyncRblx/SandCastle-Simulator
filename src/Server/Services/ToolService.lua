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


--//Handle the cleanup of a partial farm
--//Called when a Client stops clicking
function ToolService.Client:StopFarming(player)

end


--//Handle a new FarmRequest
function ToolService.Client:StartFarming(player, blockModel)
    local blockDestroyed, completedTime = self.Server:StartFarming(player, blockModel)
    return blockDestroyed, completedTime
end


function ToolService:StartFarming(player, blockModel)
    local playerObject = PlayerLoaderService:GetPlayerObject(player)

    -- Global Debounce
    if (playerObject:Get("IsFarming")) then return false end;
    playerObject:Set("IsFarming", true)

    local toolMetaData = MetaDataService:GetMetaData(playerObject:Get("EquippedTool"))

    --Get information about the blockModel
    local beachContainer = blockModel.Parent.Parent
    local beachObject = BeachService:GetBeachObjectFromContainer(beachContainer)
    local blockObject = beachObject:GetBlockAtPosition(blockModel.MapPosition.Value)
    local blockMetaData = MetaDataService:GetMetaData(blockObject.Id)

    local currentTime = os.time()
    local blockDestroyed = blockObject:Attack(toolMetaData)
    local completedTime = currentTime + (blockMetaData.Hardness / toolMetaData.Strength)
    print(blockMetaData.Hardness)
    print(toolMetaData.Strength)

    local farmThread = coroutine.create(function()
        while (os.time() < completedTime) do wait() end

        blockObject.Block:Destroy()
        blockObject = nil
    end)

    coroutine.resume(farmThread)

    return blockDestroyed, completedTime
end


function ToolService.Client:FarmBlock(player, beachContainer, blockModel)
    assert(blockModel:IsDescendantOf(workspace.Beaches), "Invalid blockModel")

    --Get playerObject and lastFarmInfo
    local playerObject = PlayerLoaderService:GetPlayerObject(player)

    --Get tool information
    local toolId = playerObject:Get("EquippedTool")
    local toolMetaData = MetaDataService:GetMetaData(toolId)

    --Get blockObject and blockMetaData using Function Calls from GetBeachObjectFromContainer


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
