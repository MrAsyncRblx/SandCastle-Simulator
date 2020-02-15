-- Beach Service
-- MrAsync
-- February 13, 2020


--[[

    Controls the initialization, configuration and management of the beaches

]]


local BeachService = {Client = {}}

--//Services

--//Controllers

--//Classes
local BeachClass

--//Data

--//Locals
local beaches


--//Constructs beachObjects and calls beachObject:Setup() to initialize the first layer of sand
function BeachService:Start()
    
    --Iterate through all beaches
    for _, beachContainer in pairs(beaches) do
        
        --Construct a new BeachObject and initialize the first layer
        local beachObject = BeachClass.new(tonumber(beachContainer.Name), beachContainer)
        beachObject:Setup()
        
    end
end


function BeachService:Init()
	--//Services
    
    --//Controllers
    
    --//Classes
    BeachClass = self.Modules.Classes.BeachClass
    
    --//Data
    
    --//Locals
    beaches = workspace.Beaches:GetChildren()
    
end


return BeachService