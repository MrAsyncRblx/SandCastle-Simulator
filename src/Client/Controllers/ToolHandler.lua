-- Tool Handler
-- MrAsync
-- February 16, 2020



--[[

    Opens various connections to allow user to farm sand
    Communicates to server

]]



local ToolHandler = {}

--//Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ToolService

--//Controllers

--//Classes

--//Data

--//Locals
local mouse
local character
local lastTarget
local selectionBox
local adorneeConnection
local activationConnection

local toolRange = 25;


--Method finds target sand, checks debounce and calls server method
function ToolHandler:FarmBlock()
    local target = mouse.Target

    --Validate is target is a valid SandBlock
    if ((target) and (target:IsDescendantOf(workspace.Beaches)) and (((character.PrimaryPart.Position - target.Position).magnitude <= toolRange))) then
        --Call server to farmBlock
        ToolService:FarmBlock(target)
    end
end


--Opens various connections to allow user to farm 
function ToolHandler:BindCharacter()
    --Open connection to allow user to farm block
    character.ChildAdded:Connect(function(newChild)
        if (newChild:IsA("Tool")) then

            --Move selectionBox
            adorneeConnection = RunService.RenderStepped:Connect(function()
                local isClicking = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                local isTouching = false

                local mouseTarget = mouse.Target

                --SelectionBox Adornee
                if ((mouseTarget) and (mouseTarget:IsDescendantOf(workspace.Beaches))) then
                    if ((character.PrimaryPart.Position - mouseTarget.Position).magnitude > toolRange) then
                        selectionBox.SurfaceColor3 = Color3.fromRGB(192, 57, 43)
                        selectionBox.Color3 = Color3.fromRGB(192, 57, 43)
                    else
                        selectionBox.SurfaceColor3 = Color3.fromRGB(39, 174, 96)
                        selectionBox.Color3 = Color3.fromRGB(39, 174, 96)
                    end


                    --Only update if block has changed
                    if (mouseTarget ~= lastTarget) then
                        lastTarget = mouseTarget

                        selectionBox.Adornee = mouseTarget
                    end
                else
                    selectionBox.Adornee = nil
                end

                --Click detection
                if ((isClicking) and (UserInputService.MouseEnabled) or (isTouching and UserInputService.TouchEnabled)) then

                    --If mouseTarget exists
                    if (mouseTarget) then
                        self:FarmBlock(mouseTarget)
                    end
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
end


function ToolHandler:Init()
    --//Services
    ToolService = self.Services.ToolService
    
    --//Controllers
    
    --//Classes
    
    --//Data
    
    --//Locals
    mouse = self.Player:GetMouse()
end


return ToolHandler