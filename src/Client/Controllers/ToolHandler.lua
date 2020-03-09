-- Tool Handler
-- MrAsync
-- February 16, 2020

--[[

    Opens various connections to allow user to farm sand
    Communicates to server
    Handles client animations

]]
local ToolHandler = {}

--//Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local MetaDataService
local ToolService
local PlayerGui

--//Controllers

--//Classes

--//Data

--//Locals
local mouse
local character
local lastBlock
local miningHudGui
local selectionBox
local currentBlock
local adorneeConnection

local toolRange = 25

--Method finds target sand, checks debounce and calls server method
function ToolHandler:FarmBlock()
    local target = mouse.Target

    --Validate is target is a valid SandBlock
    if ((target) and (target:IsDescendantOf(workspace.Beaches)) and ((character.PrimaryPart.Position - target.Position).magnitude <= toolRange)) then
        --Get blockModel and beachContainer
        local blockModel = target:FindFirstAncestorOfClass("Model")
        local beachContainer = blockModel:FindFirstAncestorOfClass("Folder").Parent

        if (blockModel and beachContainer) then
            ToolService:FarmBlock(beachContainer, blockModel)
        end
    end
end

--Opens various connections to allow user to farm
function ToolHandler:BindCharacter()

    --Open connection to childAdded
    --Handles the Block adornee and BlockInfoHUD
    character.ChildAdded:Connect(function(newChild)

        --Only continue if child isA tool
        if (newChild:IsA("Tool")) then
            adorneeConnection = RunService.RenderStepped:Connect(function()
                local mouseTarget = mouse.Target

                --Only continue if mouseTarget exists, mouseTarget is a SandObject
                if ((mouseTarget) and (mouseTarget:IsDescendantOf(workspace.Beaches))) then
                    local blockId = tonumber(mouseTarget:FindFirstAncestorOfClass("Model").Name)
                    local blockMetaData = MetaDataService:GetMetaData(blockId)

                    --SandObject has not already been processed
                    if (mouseTarget ~= lastBlock) then
                        currentBlock = mouseTarget:FindFirstAncestorOfClass("Model")

                        --Change selectionBox lineColor
                        if ((character.PrimaryPart.Position - mouseTarget.Position).magnitude > toolRange) then
                            selectionBox.SurfaceColor3 = Color3.fromRGB(192, 57, 43)
                            selectionBox.Color3 = Color3.fromRGB(192, 57, 43)
                        else
                            selectionBox.SurfaceColor3 = Color3.fromRGB(39, 174, 96)
                            selectionBox.Color3 = Color3.fromRGB(39, 174, 96)
                        end

                        --LastTarget and Adornee
                        lastBlock = mouseTarget
                        selectionBox.Adornee = mouseTarget

                        --Edit HUD Text
                        miningHudGui.Container.BlockName.Text = blockMetaData.Name

                        --Show HUD
                        if (not miningHudGui.Container.Visible) then
                            miningHudGui.Container.Visible = true
                        end
                    end
                else
                    currentBlock = nil
                    selectionBox.Adornee = nil
                    miningHudGui.Container.Visible = false
                end
            end)
        end
    end)

    --Close open connections when tool is removed
    character.ChildRemoved:Connect(function(oldChild)
        if (oldChild:IsA("Tool")) then
            selectionBox.Adornee = nil

            --Close activationConnection
            if (activationConnection) then
                activationConnection:Disconnect()
            end

            --CLose adorneeConnection
            if (adorneeConnection) then
                adorneeConnection:Disconnect()
            end
        end
    end)
end

function ToolHandler:Start()
    --Initially setup character
    character = self.Player.Character or self.Player.CharacterAdded:Wait()
    self:BindCharacter()

    --Setup character when player resets character
    self.Player.CharacterAdded:Connect(function(newCharacter)
        character = newCharacter

        self:BindCharacter()
    end)

    --Setup selectionBox
    selectionBox = Instance.new("SelectionBox")
    selectionBox.Parent = workspace.CurrentCamera

    mouse.Button1Down:Connect(function()
        if (currentBlock) then
            local targetTime = ToolService:StartBreaking(currentBlock)
        end
    end)

    mouse.Button1Up:Connect(function()
        ToolService:StopFarming()
    end)
end

function ToolHandler:Init()
    --//Services
    MetaDataService = self.Services.MetaDataService
    ToolService = self.Services.ToolService
    PlayerGui = self.Player:WaitForChild("PlayerGui")

    --//Controllers

    --//Classes

    --//Data

    --//Locals
    miningHudGui = PlayerGui:WaitForChild("MiningHUD")
    mouse = self.Player:GetMouse()
end

return ToolHandler
