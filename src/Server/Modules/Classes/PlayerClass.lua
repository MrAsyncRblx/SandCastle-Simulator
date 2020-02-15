-- Player Class
-- MrAsync
-- February 12, 2020



local PlayerClass = {}
PlayerClass.__index = PlayerClass

--//Services
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local MetaDataService

--//Controllers
local DataStore2
local TableUtils

--//Classes

--//Data

--//Locals
local PlayerData


--//Constructor
function PlayerClass.new(topPlayer)
	local self = setmetatable({

		Player = topPlayer;

	}, PlayerClass)

	--Clone copy of default data
	self.DefaultData = TableUtils.Copy(PlayerData.MetaData)

	--Add DataStore for each DataNode to self
	for key, defaultValue in pairs(PlayerData.MetaData) do
		self[key] = DataStore2(key, topPlayer)
	end

	return self
end


function PlayerClass:Start()

	--Combine all keys to master DataStore
	for key, defaultValue in pairs(PlayerData.MetaData) do
		DataStore2.Combine("PlayerData", key)
	end

end


function PlayerClass:Init()
	--//Services
	MetaDataService = self.Services.MetaDataService

	--//Controllers
	DataStore2 = require(ServerScriptService:WaitForChild("DataStore2"))
	TableUtils = self.Shared.TableUtil

	--//Classes

	--//Data

	--//Locals
	PlayerData = require(ReplicatedFirst.MetaData:FindFirstChild("Player"))

end


return PlayerClass