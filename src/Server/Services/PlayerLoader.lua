-- Player Loader
-- MrAsync
-- February 12, 2020



local PlayerLoader = {}
local self = PlayerLoader

--//Services

--//Controllers

--//Classes
local PlayerClass

--//Data


function PlayerLoader:Start()


    game.Players.PlayerAdded:Connect(function(newPlayer)
        print(newPlayer.Name .. " has joined " .. game.Name)

        local playerObject = PlayerClass.new(newPlayer)
        print(playerObjet.Data.Cash:Get(10))

    end)


    game.Players.PlayerRemoving:Connect(function(oldPlayer)
        print(oldPlayer.Name .. " has left " .. game.Name)

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