-- Meta Data Service
-- MrAsync
-- February 14, 2020

--[[

    Allows server and clients to easily retrieve MetaData

]]


local MetaDataService = {Client = {}}

--//Services
local ReplicatedFirst = game:GetService("ReplicatedFirst")

--//Controllers

--//Classes

--//Data
local MetaDataContainer

--//Locals
local DataNodes
local PlayerData


function MetaDataService.Client:GetMetaData(player, itemId)
    return self.Server:GetMetaData(itemId)
end


--//Retrives MetaData bound to passed itemId
--//Returns Array if find is successful
--//Returns 0 if Array is not found
function MetaDataService:GetMetaData(itemId)
    --Wait until DataNodes are loaded
    while (#DataNodes <= 0 ) do wait() end

    --Iterate through all dataNodes
    for _, dataNode in pairs(DataNodes) do
        local MetaData = dataNode.MetaData

        --Don't throw exception because MetaData does not contain any MetaData
        if (#MetaData == 0) then
            continue
        end

        --Get the minimum metaDataId and maximum metaDataId
        local minId = MetaData[1].Id
        local maxId = MetaData[#MetaData].Id

        --Compare id's
        if (itemId == minId) then
            return MetaData[1]
        elseif (itemId == maxId) then
            return MetaData[#MetaData]
        elseif ((itemId > minId) or (itemId < maxId)) then
            for index, metaData in pairs(MetaData) do
                if (metaData.Id == itemId) then
                    return metaData
                end
            end
        end
    end

    return 0
end


function MetaDataService:Start()
    DataNodes = MetaDataContainer:GetChildren()

    for index, rawNode in pairs(DataNodes) do
        DataNodes[index] = require(rawNode)
    end

end

function MetaDataService:Init()
    --//Services

    --//Controllers

    --//Classes

    --//Data
    MetaDataContainer = ReplicatedFirst:WaitForChild("MetaData")

    --//Locals
    DataNodes = {}

end

-- --//Unit Test
-- local NexusUnitTesting = require(game.ServerScriptService:WaitForChild("NexusUnitTesting"))
-- local UnitTest = NexusUnitTesting.UnitTest.new("MetaDataService")

-- function UnitTest:Setup()
--     MetaDataService:Init()
--     MetaDataService:Start()
-- end

-- function UnitTest:Run()
--     local metaData = MetaDataService:GetMetaData(100)
    
--     self:AssertEquals(type(metaData), "table", "MetaDataService not returning valid MetaData")
-- end

-- NexusUnitTesting:RegisterUnitTest(UnitTest)

return MetaDataService