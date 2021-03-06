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
local ToolClass

--//Locals
local playerObjectIndex


function PlayerLoader:Start()
    
    game.Players.PlayerAdded:Connect(function(newPlayer)
        print(newPlayer.Name .. " is joining " .. game.Name)

        --Construct a new PlayerObject
        local playerObject = PlayerClass.new(newPlayer)
        local toolObject = ToolClass.new(playerObject)

        --Leaderstats
        local leaderstats = Instance.new("Folder")
        leaderstats.Name = "leaderstats"
        leaderstats.Parent = newPlayer

        local cashValue = Instance.new("NumberValue")
        cashValue.Name = "Cash"
        cashValue.Value = playerObject:Get("Cash")
        cashValue.Parent = leaderstats

        playerObject:OnUpdate("Cash", function(newValue)
            cashValue.Value = newValue
        end)

        local sandValue = Instance.new("NumberValue")
        sandValue.Name = "Sand"
        sandValue.Value = playerObject:Get("Sand")
        sandValue.Parent = leaderstats

        playerObjectIndex[newPlayer] = playerObject
    end)

    game.Players.PlayerRemoving:Connect(function(oldPlayer)
        print(oldPlayer.Name .. " is leaving " .. game.Name)

        playerObjectIndex[oldPlayer] = nil
    end)
end


--//Returns the playerObject of the given player
function PlayerLoader:GetPlayerObject(player)
    return playerObjectIndex[player]
end


function PlayerLoader:Init()
    --//Services

    --//Controllers

    --//Classes
    PlayerClass = self.Modules.Classes.PlayerClass
    ToolClass = self.Modules.Classes.ToolClass

    --//Locals
    playerObjectIndex = {}

end


return PlayerLoader