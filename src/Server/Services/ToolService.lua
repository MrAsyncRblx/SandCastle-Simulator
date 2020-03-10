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


function ToolService:DamageBlock(playerObject, toolMetaData, blockModel, beachContainer)
    --Get blockObject
    local beachObject = BeachService:GetBeachObjectFromContainer(beachContainer)
    local blockObject = beachObject:GetBlockAtPosition(blockModel:FindFirstChild("MapPosition").Value)
    local hardnessAfterAttack = (blockObject.CurrentHardness - toolMetaData.Strength)

    --Damage the thing
    if (hardnessAfterAttack <= 0) then
        beachObject:DestroyBlock(blockObject.MapPosition)
    else
        blockObject.CurrentHardness = hardnessAfterAttack
    end
end


--//Handle the cleanup of a partial farm
--//Called when a Client stops clicking
function ToolService.Client:StopFarming(player)
    return self.Server:StopBreak(player)
end


--//Handle a new FarmRequest
--//Called when a Client starts clicking
function ToolService.Client:StartBreaking(player, blockModel, beachContainer)
    return self.Server:BreakBlock(player, blockModel, beachContainer)
end


--//Handles the killing of threads to stop a farm
function ToolService:StopBreak(player)
    local playerObject = PlayerLoaderService:GetPlayerObject(player)
    local breakThread = playerObject:Get("BreakThread")

    --Yield coroutine
    if (breakThread) then
        playerObject:Set("KillSwitch", true)

        return true
    end

    return false
end


--//Handles the breaking of blocks
function ToolService:BreakBlock(player, blockModel, beachContainer)
    --Localize
    local playerObject = PlayerLoaderService:GetPlayerObject(player)
    local toolId = playerObject:Get("EquippedTool")
    local blockId = tonumber(blockModel.Name)

    --Global debounce
    if (playerObject:Get("BreakThread")) then return false end

    --Grab metaData
    local toolMetaData = MetaDataService:GetMetaData(toolId)
    local blockMetaData = MetaDataService:GetMetaData(blockId)

    --Time completion for Client
    local invokeTime = os.time()
    local breakCompletion = invokeTime + (blockMetaData.Hardness / toolMetaData.Strength)

    --Create a new coroutine
    local breakThread = coroutine.create(function()
        --Wait until breakCompletion time reached
        while (os.time() < breakCompletion) do 
            --Check if a killSwitch has been activated
            if (playerObject:Get("KillSwitch")) then
                --Reset killSwitch, overwrite coroutine
                playerObject:Set("KillSwitch", false)
                playerObject:Set("BreakThread", false)

                --Yield coroutine
                coroutine.yield()
            end

            wait()
        end

        --Damage block and remove coroutine
        self:DamageBlock(playerObject, toolMetaData, blockModel, beachContainer)
        playerObject:Set("BreakThread", false)
    end)

    --Set coroutine globally
    playerObject:Set("BreakThread", breakThread)

    --Resume coroutine to begin breaking process
    coroutine.resume(breakThread)

    return breakCompletion
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
