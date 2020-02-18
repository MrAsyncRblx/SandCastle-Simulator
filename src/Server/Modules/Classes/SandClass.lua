-- Sand Class
-- MrAsync
-- February 14, 2020



local SandClass = {}
SandClass.__index = SandClass


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
function SandClass.new(sandId, worldPosition, mapPosition, beachContainer)
    local self = setmetatable({
        Id = sandId,

        CFrame = worldPosition,
        MapPosition = mapPosition,
        
        ParentBeach = beachContainer
    }, SandClass)

    self:CreateSand()

    return self
end


--//Creates the physical sandBlock 
function SandClass:CreateSand()

    --Clone sandBlock from Resources
    self.Sand = resources.Sand:FindFirstChild(self.Id):Clone()
    self.Sand.Parent = self.ParentBeach.Sand
    self.Sand:SetPrimaryPartCFrame(self.CFrame)

    local mapPositionValue = Instance.new("Vector3Value")
    mapPositionValue.Name = "MapPosition"
    mapPositionValue.Value = self.MapPosition
    mapPositionValue.Parent = self.Sand

end


function SandClass:Init()
    --//Services
    MetaDataService = self.Services.MetaDataService
    
    --//Controllers
    
    --//Classes
    
    --//Data
    
    --//Locals
    resources = ServerStorage:WaitForChild("Resources")
    
end


return SandClass