-- PlayerData Class
-- MrAsync
-- February 12, 2020



local PlayerClass = {}
PlayerClass.__index = PlayerClass


--//Services

--//Controllers
local DataStore2

--//Classes

--//Data
local PlayerData


--Constructor
function PlayerClass.new(topPlayer) 
    local self = setmetatable({

        Player = topPlayer,

        Data = {}

    }, PlayerClass)

    -- --Create hash containing DataStore2 Keys
    -- for key, defaultValue in pairs(PlayerData.MetaData) do
        
    --     Data[key] = DataStore2(topPlayer, key)

    -- end

    return self
end


function PlayerClass:Start()
    --Combines sub-keys of PlayerData
    DataStore2.Combine("PlayerData",
        --//Essentials
        "Cash",
        "Snow",

        --//Arrays
        "Inventory",
        "Buildings",
        "HasPlayed",

        --//Tracked stats
        "TimesPlayed",
        "TotalTimePlayed",
        "TotalSnowCollected",
        "TotalCoinsCollected",

        --//Framework
        "Exists"
    )
end


function PlayerClass:Init()
    --//Services

    --//Controllers
    DataStore2 = self.Modules.DataStore2

    --//Classes

    --//Data
    PlayerData = self.Modules.Data.Player

end


return PlayerData