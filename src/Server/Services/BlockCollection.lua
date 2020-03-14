-- Block Collection
-- MrAsync
-- March 14, 2020

--[[

    

]]


local BlockCollection = {Client = {}}


--//Api

--//Services
local PlayerService

--//Controllers

--//Classes

--//Data

--//Locals
local PlayerCollecting
local PlayerFinishedCollecting


--Connect client invocation to server endpoint
function BlockCollection.Client:PlayerCollectionPatch(player, block)
    return PlayerCollecting:Fire(player, block)
end


function BlockCollection:Start()
    self.PlayerCollecting:Connect(function(player, block)
        print(player.Name .. " is trying to collect block: " .. block.Name)
    end)

end


function BlockCollection:Init()
    --//Api

    --//Services
    PlayerService = self.Services.PlayerService

    --//Controllers

    --//Classes

    --//Data

    --//Locals
    PlayerCollecting = Instance.new("BindableEvent")


    --Expose BindableEvent.Event property
    self.PlayerCollecting = PlayerCollecting.Event
end


return BlockCollection