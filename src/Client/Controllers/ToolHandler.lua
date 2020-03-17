-- Tool Handler
-- MrAsync
-- February 16, 2020

--[[

    Calls BlockSelection EndPoints to control client farming

]]
local ToolHandler = {}

--//Api
local ClientApiService
local BlockSelection

--//Services

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
        ClientApiService.PlayerStartedCollecting:Fire(currentBlock)
    end)

    BlockSelection.CollectionEnded:Connect(function(currentBlock)
        ClientApiService.PlayerStoppedCollecting:Fire(oldBlock)
    end)

end

function ToolHandler:Init()
    --//Api
    ClientApiService = self.Services.ClientApiService
    BlockSelection = self.Modules.Api.BlockSelection

    --//Services

    --//Controllers

    --//Classes

    --//Data

    --//Locals

end

return ToolHandler
