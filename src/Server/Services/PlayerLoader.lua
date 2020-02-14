-- Player Loader
-- MrAsync
-- February 12, 2020

--[[

    Constructs PlayerObject
    Creates leaderstats[pppp]

]]


local PlayerLoader = {Client = {}}
self = PlayerLoader

--//Services

--//Controllers

--//Classes
local PlayerClass

--//Data


function PlayerLoader:Start()
    
    game.Players.PlayerAdded:Connect(function(newPlayer)
        print(newPlayer.Name .. " is joining " .. game.Name)

        --Construct a new PlayerObject
        local playerObject = PlayerClass.new(newPlayer)

        --Leaderstats
        local leaderstats = Instance.new("Folder")
        leaderstats.Name = "leaderstats"
        leaderstats.Parent = newPlayer

        local cashValue = Instance.new("NumberValue")
        cashValue.Name = "Cash"
        cashValue.Value = playerObject.Cash:Get(playerObject.DefaultData.Cash)
        cashValue.Parent = leaderstats

        playerObject.Cash:OnUpdate(function(newValue)
            cashValue.Value = newValue
        end)

        local sandValue = Instance.new("NumberValue")
        sandValue.Name = "Sand"
        sandValue.Value = playerObject.Sand:Get(playerObject.DefaultData.Sand)
        sandValue.Parent = leaderstats

    end)

    game.Players.PlayerRemoving:Connect(function(oldPlayer)
        print(oldPlayer.Name .. " is leaving " .. game.Name)

    end)
end


function PlayerLoader:Init()
    --//Services

    --//Controllers

    --//Classes
    PlayerClass = self.Modules.Classes.PlayerClass

    --//Data	

end


return PlayerLoader