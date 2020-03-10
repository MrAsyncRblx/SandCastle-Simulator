-- Beach Class
-- MrAsync
-- February 13, 2020


--[[

    Superclass handles the SandObjects
    Allows sand to be easily manipulated

]]


local BeachClass = {}
BeachClass.__index = BeachClass

--//Services
local MetaDataService

--//Controllers
local ChanceController

--//Classes
local BlockClass

--//Data

--//Locals
local blockSize


--//Constructor
function BeachClass.new(beachId, beachContainer)
    local self = setmetatable({
        Id = beachId;
        Container = beachContainer;
        SpawnPad = beachContainer:FindFirstChild("SpawnPad");
        CornerPosition;

        MetaData = MetaDataService:GetMetaData(beachId);

        BlockMap = {};
    }, BeachClass)

    return self
end


--[[

    Mutators

]]

--//Runs neccessary steps to farm the TargetBlock and spawn adjacentBlocks
function BeachClass:DestroyBlock(targetBlockPosition)
    --Wipe targetBlock like thanos
    local currentBlock = self:GetBlockAtPosition(targetBlockPosition)
    currentBlock.Block:Destroy()

    --Mark position as Collected
    self.BlockMap[targetBlockPosition.Y][targetBlockPosition.X][targetBlockPosition.Z] = "Collected"

    --//dear god help me find a cleaner way to do this
    --Calculate adjacentBlock positions
    local adjacentBlocks = {}
    adjacentBlocks.Bottom = targetBlockPosition + Vector3.new(0, 1, 0)
    adjacentBlocks.Right = targetBlockPosition + Vector3.new(1, 0, 0)
    adjacentBlocks.Left = targetBlockPosition + Vector3.new(-1, 0, 0)
    adjacentBlocks.Front = targetBlockPosition + Vector3.new(0, 0, 1)
    adjacentBlocks.Back = targetBlockPosition + Vector3.new(0, 0, -1)
    adjacentBlocks.Top = targetBlockPosition + Vector3.new(0, -1, 0)

    --Iterate through all adjacent blocks
    for key, mapPosition in pairs(adjacentBlocks) do
        --Don't overwrite another blockObject, only spawn block onTop of targetBlock if it's underneath the surface
        if (not self:GetBlockAtPosition(mapPosition) and self:GetBlockAtPosition(mapPosition) ~= "Collected") then
            --Calculate the worldPosition
            local worldPosition = self.CornerPosition + Vector3.new((mapPosition.X - 1) * blockSize.X, (mapPosition.Y - 1) * -blockSize.Y, (mapPosition.Z - 1) * blockSize.Z)

            --Construct a new blockObject
            local newBlock = BlockClass.new(self:CreateBlock(mapPosition), worldPosition, mapPosition, self.Container)
            self:SetBlockAtPosition(mapPosition, newBlock)
        end
    end
end


--//Inserts the blockObject at the mapPosition in the SandMap array
function BeachClass:SetBlockAtPosition(mapPosition, blockObject)
    local positionData = self:GetBlockAtPosition(mapPosition)

    --Don't overwrite another blockObject
    --Don't create block if block has already been farmed
    --Insert blockObject into proper position in SandMap
    if ((not positionData) and (positionData ~= "Collected")) then
        self.BlockMap[mapPosition.Y][mapPosition.X][mapPosition.Z] = blockObject

        return true
    end

    return false
end


--//Get depthHash according to targetPosition
--//Call ChanceController:ChooseBlock() to pick a random blockId
function BeachClass:CreateBlock(targetPosition)
    local depthHash

    --Iterate through all depthHashes
    for depthClamp, blockHash in pairs(self.MetaData.Blocks) do
        --Don't index default hashMap
        if (depthClamp == "Default") then
            continue
        end
        
        --Split depthClamp string
        depthClamp = string.split(depthClamp, ",")
        
        --If current height is between depthClamp, return
        if ((targetPosition.Y >= tonumber(depthClamp[1])) and (targetPosition.Y <= tonumber(depthClamp[2]))) then
            depthHash = blockHash

            break
        end
    end

    --If there's no depthHash available, use the default
    if (not depthHash) then
        depthHash = self.MetaData.Blocks["Default"]
    end

    --Call ChooseBlock to pick a weighted BlockId
    return ChanceController:ChooseBlock(depthHash)
end


--[[

    Getters

]]

--//Returns the BlockObject at a given MapPosition
--//Returns nil of BlockObject does not exist
function BeachClass:GetBlockAtPosition(mapPosition)
    mapPosition = Vector3.new(
        math.clamp(mapPosition.X, 1, self.maxRow),
        math.clamp(mapPosition.Y, 1, math.huge),
        math.clamp(mapPosition.Z, 1, self.maxCol)
    )

    --Get layerMap, if it doesn't exist, create
    local layerMap = (self.BlockMap[mapPosition.Y] or {})
    self.BlockMap[mapPosition.Y] = layerMap

    --Get rowMap, if it doesn't exist, create
    local rowMap = (layerMap[mapPosition.X] or {})
    self.BlockMap[mapPosition.Y][mapPosition.X] = rowMap

    return self.BlockMap[mapPosition.Y][mapPosition.X][mapPosition.Z]
end


--//Generates the initial layer of sand for the beach
function BeachClass:Setup()
    --Calculate sizes, cframes and rows / columns
    local padSize = self.SpawnPad.Size
    local padCFrame = self.SpawnPad.CFrame

    local totalRows = (padSize.X - (blockSize.X * 0.5)) * 0.25
    local totalCols = (padSize.Z - (blockSize.Z * 0.5)) * 0.25

    self.maxRow = math.floor(totalRows + 1)
    self.maxCol = math.floor(totalCols + 1)

    --Calculate startingPosition
    self.CornerPosition = padCFrame - (padSize * 0.5) + Vector3.new(blockSize.X / 2, padSize.Y - (blockSize.Y / 2), blockSize.Z / 2)

    --Iterate through all rows and cols
    for x = 0, totalRows do
        for z = 0, totalCols do
            --Construct position
            local position = self.CornerPosition + Vector3.new(x * blockSize.X, 0 , z * blockSize.Z)
            local mapPosition = Vector3.new(x + 1, 1, z + 1)

            self:SetBlockAtPosition(mapPosition, BlockClass.new(self:CreateBlock(position), position, mapPosition, self.Container))
        end
    end
end


function BeachClass:Start()

end


function BeachClass:Init()
    --//Services
    MetaDataService = self.Services.MetaDataService
    
    --//Controllers
    ChanceController = self.Modules.Controllers.Chance
    
    --//Classes
    BlockClass = self.Modules.Classes.BlockClass
    
    --//Data
    
    --//Locals
    blockSize = Vector3.new(4, 4, 4)
    
end


return BeachClass