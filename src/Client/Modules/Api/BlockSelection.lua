-- Block Selection
-- MrAsync
-- March 14, 2020


--[[
    API Reference
 
    Events:
        SelectionChanged => Fired when client selects a new block
              Returns Instance oldSelection, Instance newSelection, boolean isInBounds

        SelectionLost => Fired when client stops selection a valid block
            Returns Instance oldSelection

        CollectionBegan => Fired when client begins click (invokes farm)
            Returns Instance currentSelection, boolean isInBounds

        CollectionEnded => Fired when client stops clicking
            Returns Instance oldSelection
]]


local BlockSelection = {}
local self = BlockSelection

--Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--Controllers

--Classes

--Data

--Locals
local mouse
local character

local isInBounds
local selectionBox
local selectedBlock

local DISTANCE_BOUND = 15

local ACCEPTED_INPUT_TYPES = {
    [Enum.UserInputType.MouseButton1] = true,
    [Enum.UserInputType.Touch] = true,
    [Enum.KeyCode.ButtonR2] = true
}

local SelectionChanged
local SelectionLost
local CollectionBegan
local CollectionEnded


--Fires a ray from players viewport to the players mouse position
--Updates selectedBlock var
--Updates visual selectionBox
function BlockSelection:FindTargetBlock()
    local unitRay = Ray.new(mouse.Origin.Position, (mouse.Hit.Position - mouse.Origin.Position).unit * 100)
    local block, blockWorldPosition = workspace:FindPartOnRayWithIgnoreList(unitRay, {character})
    
    --If block exists and block is a descendant of workspace, show adornee
    if (block and block:IsDescendantOf(workspace.Beaches)) then
        block = block:FindFirstAncestorOfClass("Model")

        --Only update if player is selecting a new block
        if (block ~= selectedBlock) then
            SelectionChanged:Fire(selectedBlock, block, isInBounds)

            selectedBlock = block
            selectionBox.Adornee = block

            --If the magnitude between the players character and blockWorldPosition is under DISTANCE_BOUND inclusive
            --Update blockInBounds local and update SelectionBox Color
            if ((character.PrimaryPart.Position - blockWorldPosition).magnitude <= DISTANCE_BOUND) then
                isInBounds = true

                selectionBox.Color3 = Color3.fromRGB(39, 174, 96)
            else
                isInBounds = false

                selectionBox.Color3 = Color3.fromRGB(192, 57, 43)
            end
        end
    else
        --Only trigger event once
        if (selectedBlock) then
            SelectionLost:Fire(selectedBlock)
        end

        --If no valid block exists, disable selectionBox
        selectionBox.Adornee = nil
        selectedBlock = nil
    end
end


--Opens connections to character.ChildAdded and character.ChildRemoving
--Binds self.FindTargetBlock to renderStepped when tool is equipped
function BlockSelection:BindCharacter()

    --If a child is added to character, check if it's a tool
    character.ChildAdded:Connect(function(newTool)
        
        if (newTool:IsA("Tool")) then

            RunService:BindToRenderStep("tempTargetFinder", 1, self.FindTargetBlock)
        end
    end)


    --If a child is removed from character, check if it's a tool
    character.ChildRemoved:Connect(function(oldTool)
        
        if (oldTool:IsA("Tool")) then
            --Only trigger event once
            if (selectedBlock) then
                SelectionLost:Fire(selectedBlock)
            end

            --If no valid block exists, disable selectionBox
            selectionBox.Adornee = nil
            selectedBlock = nil

            RunService:UnbindFromRenderStep("tempTargetFinder")
        end
    end)
end


function BlockSelection:Start()
    --Localize Character
    character = (self.Player.Character or self.Player.CharacterAdded:Wait())
    self:BindCharacter()

    --Update character evertime character is reloaded
    self.Player.CharacterAdded:Connect(function(newCharacter)
        character = newCharacter
        self:BindCharacter()
    end)

    --Create selectionBox
    selectionBox = Instance.new("SelectionBox")
    selectionBox.Parent = workspace.CurrentCamera

    --Fire PlayerClicked when playerClicks
    UserInputService.InputBegan:Connect(function(inputObject, gameProcessed)
        if (not gameProcessed) then
            if (ACCEPTED_INPUT_TYPES[inputObject.KeyCode] or ACCEPTED_INPUT_TYPES[inputObject.UserInputType]) then
                
                CollectionBegan:Fire(selectedBlock, isInBounds)
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(inputObject, gameProcessed)
        if (not gameProcessed) then
            if (ACCEPTED_INPUT_TYPES[inputObject.KeyCode] or ACCEPTED_INPUT_TYPES[inputObject.UserInputType]) then
                
                CollectionEnded:Fire(selectedBlock)
            end
        end
    end)
end


function BlockSelection:Init()
    --Services

    --Controllers

    --Classes

    --Data

    --Locals
    isInBounds = false

    mouse = self.Player:GetMouse()

    --Create bindableEvents
    SelectionChanged = Instance.new("BindableEvent")
    SelectionLost = Instance.new("BindableEvent")
    CollectionBegan = Instance.new("BindableEvent")
    CollectionEnded = Instance.new("BindableEvent")

    --Expose BindableEvent.Event property
    self.SelectionChanged = SelectionChanged.Event
    self.SelectionLost = SelectionLost.Event
    self.CollectionBegan = CollectionBegan.Event
    self.CollectionEnded = CollectionEnded.Event
end


return BlockSelection