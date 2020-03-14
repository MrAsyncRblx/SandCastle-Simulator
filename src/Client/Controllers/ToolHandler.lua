-- Tool Handler
-- MrAsync
-- February 16, 2020

--[[

    Calls BlockSelection EndPoints to control client farming

]]
local ToolHandler = {}

--//Api
local BlockSelection

--//Services
local ToolService

--//Controllers

--//Classes

--//Data

--//Locals

function ToolHandler:Start()

    BlockSelection.SelectionChanged:Connect(function(oldBlock, newBlock, isInBounds)
        print("Selection Changed!")
    end)

    BlockSelection.SelectionLost:Connect(function(oldBlock)
        print("Selection Lost")
    end)

    BlockSelection.CollectionBegan:Connect(function(currentBlock, isInBounds)
        print("Player is farming! isInBounds: " .. tostring(isInBounds))

        ToolService
    end)

    BlockSelection.CollectionEnded:Connect(function(oldBlock)
        print("Player stopped farming")
    end)

end

function ToolHandler:Init()
    --//Api
    BlockSelection = self.Modules.Api.BlockSelection

    --//Services
    ToolService = self.Services.ToolService

    --//Controllers

    --//Classes

    --//Data

    --//Locals

end

return ToolHandler
