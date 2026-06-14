-- TP Location GUI Script
-- Technical Implementation: This script creates a ScreenGui with a draggable frame,
-- an indicator button that toggles states, and a main action button.
-- User must execute this script within a local environment.

local player = game.Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local savedLocation = nil
local isSetMode = false

-- Draggable function
local function makeDraggable(frame)
    local dragToggle, dragStart, startPos
    frame.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = true; dragStart = input.Position; startPos = frame.Position end 
    end)
    UIS.InputChanged:Connect(function(input) 
        if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then 
            local delta = input.Position - dragStart; frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) 
        end 
    end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end end)
end

-- GUI Construction
local screenGui = Instance.new("ScreenGui", guiParent); screenGui.Name = "TPGui"
local frame = Instance.new("Frame", screenGui); frame.Size = UDim2.new(0, 200, 0, 100); frame.Position = UDim2.new(0.5, 0, 0.5, 0); frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0); makeDraggable(frame)
local indicator = Instance.new("TextButton", frame); indicator.Size = UDim2.new(0, 40, 0, 20); indicator.Position = UDim2.new(0.75, 0, 0.1, 0); indicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0); indicator.Text = ""
local actionBtn = Instance.new("TextButton", frame); actionBtn.Size = UDim2.new(0.8, 0, 0, 40); actionBtn.Position = UDim2.new(0.1, 0, 0.4, 0); actionBtn.Text = "set location"

-- Logic
indicator.MouseButton1Click:Connect(function()
    isSetMode = not isSetMode
    indicator.BackgroundColor3 = isSetMode and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    actionBtn.Text = isSetMode and "teleport" or "set location"
end)

actionBtn.MouseButton1Click:Connect(function()
    if not isSetMode then
        -- Set location mode
        savedLocation = player.Character.HumanoidRootPart.CFrame
        print("Location saved.")
    else
        -- Teleport mode
        if savedLocation then player.Character.HumanoidRootPart.CFrame = savedLocation end
    end
end)

-- Implementation Notes:
-- 1. This script generates a UI element based on the visual design in 1000034539.png.
-- 2. The code uses standard Roblox Instance creation for UI elements.
-- 3. CFrame manipulation is used for teleportation. Ensure the player's character is spawned before executing.
