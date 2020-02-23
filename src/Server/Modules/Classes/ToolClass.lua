-- Tool Class
-- MrAsync
-- February 22, 2020


--[[

    Handles the equipping and unequipping of tools

]]


local ToolClass = {}
ToolClass.__index = ToolClass

--//Services
local serverStorage = game:GetService("ServerStorage")

--//Controllers

--//Classes

--//Locals


function ToolClass.new(playerObject)
    local self = setmetatable({
        Player = playerObject.Player,

        Id = playerObject:Get("EquippedTool")
    }, ToolClass)

    print( playerObject:Get("EquippedTool"))

    local newTool = serverStorage.Resources.Tools:FindFirstChild(self.Id):Clone()
    newTool.Parent = (playerObject.Player.Character or playerObject.Player.CharacterAdded:Wait()).Backpack

    return self
end


function ToolClass:ChangeTool(playerObject, newId)
    playerObject:Set("EquippedTool", newId)
    self.Id = newId

end


return ToolClass