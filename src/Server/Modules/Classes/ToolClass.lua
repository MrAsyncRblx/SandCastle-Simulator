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


--//Constructor
function ToolClass.new(playerObject)
    local self = setmetatable({
        Player = playerObject.Player,

        Id = playerObject:Get("EquippedTool")
    }, ToolClass)


    --Clone new tool to PlayersBackpack
    self.Object = self:CloneTool(playerObject)

    --Re-Clone a new tool everytime the players Character is re-created
    playerObject.Player.CharacterAdded:Connect(function(newCharacter)
        self:CloneTool(playerObject)
    end)

    return self
end


--Clones a new tool into the players Character, equipping it instantly
function ToolClass:CloneTool(playerObject)
    local toolClone = serverStorage.Resources.Tools:FindFirstChild(self.Id):Clone()
    toolClone.Parent = (playerObject.Player.Character or playerObject.Player.CharacterAdded:Wait())

    return toolClone
end


--//Changes the players currentTool to a newOne
function ToolClass:ChangeTool(playerObject, newId)
    playerObject:Set("EquippedTool", newId)
    self.Id = newId

    --Destroy old tool whether it's in backpack or equipped
    local backpackObject = playerObject.Player.Backpack:FindFirstChildOfClass("Tool")
    local characterObject = (playerObject.Player.Character or playerObject.Player.CharacterAdded:Wait()).Backpack:FindFirstChildOfClass("Tool")

    if (backpackObject) then
        backpackObject:Destroy()
    elseif (characterObject) then
        characterObject:Destroy()
    end

    --Finally, clone the new tool into the players backpack
    self.Object = self:CloneTool(playerObject)
end


return ToolClass