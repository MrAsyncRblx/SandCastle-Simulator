-- Sand Class
-- MrAsync
-- February 14, 2020



local SandClass = {}
SandClass.__index = SandClass


--//Services
local ServerStorage = game:GetService("ServerStorage")
local MetaDataService

--//Controllers

--//Classes

--//Data

--//Locals
local resources


--//Constructor
function SandClass.new(sandId, worldPosition, listPosition)
    local self = setmetatable({
        Id = sandId,

        CFrame = worldPosition,
        ListPosition = listPosition

    }, SandClass)

    self:CreateSand()

    return self
end


--//Creates the physical sandBlock 
function SandClass:CreateSand()

    --Clone sandBlock from Resources
    self.Sand = resources.Sand:FindFirstChild(self.Id):Clone()
    self.Sand.Parent = workspace
    self.Sand:SetPrimaryPartCFrame(self.CFrame)
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