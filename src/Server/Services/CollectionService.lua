-- Collection Service
-- MrAsync
-- March 15, 2020

--[[

    Connects to ClientApiService triggers to handle incoming collection requests

]]



local CollectionService = {Client = {}}

--//Api
local ClientApiService

--//Services

--//Controllers

--//Classes

--//Locals



function CollectionService:Start()

    ClientApiService.PlayerStartedCollecting:Connect(function(player, selectedBlock, isInBounds)
        print(player.Name .. " has started collecting!")
    end)


    ClientApiService.PlayerFinishedCollecting:Connect(function(player)
    
    end)

    ClientApiService.PlayerStoppedCollecting:Connect(function(player)
        print(player.Name .. " has stopped collecting!")
    end)
end

function CollectionService:Init()
    --//Api
    ClientApiService = self.Services.ClientApiService

    --//Services

    --//Controllers

    --//Classes

    --//Locals

end


return CollectionService