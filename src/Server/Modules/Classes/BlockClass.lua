-- Sand Class
-- MrAsync
-- February 14, 2020



local BlockClass = {}
BlockClass.__index = BlockClass


--[[

    Virtually represents physical sand objects

]]


--//Services
local ServerStorage = game:GetService("ServerStorage")
local MetaDataService

--//Controllers

--//Classes

--//Data

--//Locals
local resources


--//Constructor
function BlockClass.new(blockId, worldPosition, mapPosition, beachContainer)
    local blockMetaData = MetaDataService:GetMetaData(blockId)

    local self = setmetatable({
        Id = blockId,

        CFrame = worldPosition,
        MapPosition = mapPosition,
        
        ParentBeach = beachContainer
    }, BlockClass)

    --Set hardness attribute
    self.CurrentHardness = blockMetaData.Hardness

    --Create the physical sandObject
    self:CreateBlockObject()

    return self
end

--//Creates the physical sandBlock 
function BlockClass:CreateBlockObject()

    --Clone sandBlock from Resources
    self.Block = resources.Blocks:FindFirstChild(self.Id):Clone()
    self.Block.Parent = self.ParentBeach.Blocks
    self.Block:SetPrimaryPartCFrame(self.CFrame)

    local mapPositionValue = Instance.new("Vector3Value")
    mapPositionValue.Name = "MapPosition"
    mapPositionValue.Value = self.MapPosition
    mapPositionValue.Parent = self.Block

end


function BlockClass:Init()
    --//Services
    MetaDataService = self.Services.MetaDataService
    
    --//Controllers
    
    --//Classes
    
    --//Data
    
    --//Locals
    resources = ServerStorage:WaitForChild("Resources")
    
end


return BlockClass