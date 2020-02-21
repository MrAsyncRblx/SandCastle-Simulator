-- Tool Handler
-- MrAsync
-- February 16, 2020



--[[

    Opens various connections to allow user to farm sand
    Communicates to server

]]



local ToolHandler = {}

--//Services
local runService = game:GetService("RunService")

local toolService

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
function ToolHandler:FarmSand()
    local target = mouse.Target

    if ((target) and (target:IsDescendantOf(workspace.Beaches))) then

        toolService:FarmSand(target)

    end
end


--Opens various connections to allow user to farm 
function ToolHandler:BindCharacter()
    --Open connection to allow user to farm sand
    character.ChildAdded:Connect(function(newChild)
        if (newChild:IsA("Tool")) then

            --When tool is activated, call method to farmSand
            activationConnection = newChild.Activated:Connect(function()
                self:FarmSand()
            end)

            --Move selectionBox
            adorneeConnection = runService.RenderStepped:Connect(function()
                local mouseTarget = mouse.Target

                --If mouseTarget exists
                if (mouseTarget) then

                    --If mouseTarget isADescendantOf
                    if (mouseTarget:IsDescendantOf(workspace.Beaches)) then
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
    toolService = self.Services.ToolService
    
    --//Controllers
    
    --//Classes
    
    --//Data
    
    --//Locals
    mouse = self.Player:GetMouse()
end


return ToolHandler