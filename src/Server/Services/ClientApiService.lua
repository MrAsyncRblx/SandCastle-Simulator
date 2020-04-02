-- Block Collection
-- MrAsync
-- March 14, 2020

--[[

    Client makes various calls to this API
    Server connects triggers to this API

]]


local ClientApiService = {Client = {}}


--//Api

--//Services
local PlayerService

--//Controllers

--//Classes

--//Data

--//Locals

local clientEvents = {
    "PlayerStartedCollecting",
    "PlayerFinishedCollecting",
    "PlayerStoppedCollecting",
}


--//Connect eventTriggers to bindableEvents
function ClientApiService:Start()
    for _, eventName in next, clientEvents do
        self:ConnectClientEvent(eventName, function(...)
            self.Events[eventName]:Fire(...)
        end)
    end
end


function ClientApiService:Init()
    --//Api

    --//Services
    PlayerService = self.Services.PlayerService

    --//Controllers

    --//Classes

    --//Data

    --//Locals
    self.Events = {}

    --Register clientEvents as Bindables
    for _, eventName in next, clientEvents do
        self:RegisterClientEvent(eventName)

        self.Events[eventName] = Instance.new("BindableEvent")
        self[eventName] = self.Events[eventName].Event
    end
end


return ClientApiService