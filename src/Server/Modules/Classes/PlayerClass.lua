-- Player Class
-- MrAsync
-- February 12, 2020


--[[

	Objects contain methods for setting and getting various data, nodes and mechanics

]]


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
local constant = 100
local experienceScale = 10


--//Constructor
function PlayerClass.new(topPlayer)
	local self = setmetatable({

		Player = topPlayer;
		Data = {}

	}, PlayerClass)

	--Clone copy of default data
	self.DefaultData = TableUtils.Copy(PlayerData.MetaData)

	--Add DataStore for each DataNode to self
	for key, defaultValue in pairs(PlayerData.MetaData) do
		self.Data[key] = DataStore2(key, topPlayer)
	end

	return self
end

--[[

	Data Mutation

]]
--//Returns data but passes defaultValue
function PlayerClass:Get(key)
	return self.Data[key]:Get(PlayerData.MetaData[key])
end


function PlayerClass:Set(key, value)
	return self.Data[key]:Set(value)
end


--//Returns the callback of OnUpdate
function PlayerClass:OnUpdate(key, callback)
	return self.Data[key]:OnUpdate(callback)
end


--[[

	Level and Exp

]]
function PlayerClass:AddExp(amount)
	local currentExperience = self:Get("Exp")
	local Level = self:Get("Level")

	if (currentExperience+amount) > getNextLevelExp(Level) then
        --Step 0: Since we overflowed calculate the exp leftover
        local LeftOverExp = (currentExperience+amount) - getNextLevelExp(Level)
        --Step 1: increment the level
        Level = Level + 1
        --Step 2: Since we overflowed, set the exp to 0 and recurse
        currentExperience = 0
        self:AddExp(LeftOverExp)
    elseif (currentExperience+amount) == getNextLevelExp(Level) then
        --Step 1: increment the level
        Level = Level + 1
        --Step 2: reset experience
        currentExperience = 0
    else
        currentExperience = currentExperience + amount
   end
end


--Calculates the required exp for the next level
function getNextLevelExp(level)
	return constant + (level * experienceScale)
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