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

--//Classes
local SandClass

--//Data

--//Locals


--//Constructor
function BeachClass.new(beachId, beachContainer)
    local self = setmetatable({
        Id = beachId;
        Container = beachContainer;
        SpawnPad = beachContainer:FindFirstChild("SpawnPad");
        CornerPosition;

        MetaData = MetaDataService:GetMetaData(beachId);

        SandMap = {};
    }, BeachClass)

    return self
end


--[[

    Mutators

]]

--//Runs neccessary steps to farm the TargetBlock and spawn adjacentBlocks
function BeachClass:FarmBlock(targetBlockPosition)
    --Wipe targetBlock
    local currentBlock = self:GetBlockAtPosition(targetBlockPosition)
    currentBlock.Sand:Destroy()
    self.SandMap[targetBlockPosition.Y][targetBlockPosition.X][targetBlockPosition.Z] = "Collected"

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
            local worldPosition = self.CornerPosition + Vector3.new((mapPosition.X - 1) * 3, (mapPosition.Y - 1) * -3, (mapPosition.Z - 1) * 3)

            --Construct a new blockObject
            local newBlock = SandClass.new(self.MetaData.Sand[1], worldPosition, mapPosition, self.Container)
            self:SetBlockAtPosition(mapPosition, newBlock)
        end
    end
end


--//Inserts the blockObject at the mapPosition in the SandMap array
function BeachClass:SetBlockAtPosition(mapPosition, blockObject)
    local preBlockObject = self:GetBlockAtPosition(mapPosition)

    --Don't overwrite another blockObject
    --Insert blockObject into proper position in SandMap
    if (not preBlockObject) then
        self.SandMap[mapPosition.Y][mapPosition.X][mapPosition.Z] = blockObject

        return true
    end

    return false
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
    local layerMap = (self.SandMap[mapPosition.Y] or {})
    self.SandMap[mapPosition.Y] = layerMap

    --Get rowMap, if it doesn't exist, create
    local rowMap = (layerMap[mapPosition.X] or {})
    self.SandMap[mapPosition.Y][mapPosition.X] = rowMap

    --Get block at mapPosition.Z. 
    local foundBlock = self.SandMap[mapPosition.Y][mapPosition.X][mapPosition.Z]

    return foundBlock
end


--//Generates the initial layer of sand for the beach
function BeachClass:Setup()
    --Calculate sizes, cframes and rows / columns
    local sandSize = Vector3.new(3, 3, 3)

    local padSize = self.SpawnPad.Size
    local padCFrame = self.SpawnPad.CFrame

    local totalRows = (padSize.X - (sandSize.X * 0.5)) / 3
    local totalCols = (padSize.Z - (sandSize.Z * 0.5)) / 3

    self.maxRow = totalRows + 1
    self.maxCol = totalCols + 1


    --Calculate startingPosition
    self.CornerPosition = padCFrame - (padSize * 0.5) + (sandSize * 0.5)

    --Iterate through all rows and cols
    for x = 0, totalRows do
        for z = 0, totalCols do
            --Construct position
            local position = self.CornerPosition + Vector3.new(x * 3, 0 , z * 3)
            local mapPosition = Vector3.new(x + 1, 1, z + 1)

            self:SetBlockAtPosition(mapPosition, SandClass.new(self.MetaData.Sand[1], position, mapPosition, self.Container))
        end
    end
end


function BeachClass:Start()

end


function BeachClass:Init()
    --//Services
    MetaDataService = self.Services.MetaDataService
    
    --//Controllers
    
    --//Classes
    SandClass = self.Modules.Classes.SandClass
    
    --//Data
    
    --//Locals
    
end


return BeachClass