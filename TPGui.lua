-- TP Location GUI Script (Updated V5.35)
-- Technical Implementation: Refined draggable logic, reduced frame size, and added minimization functionality.

local player = game.Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local savedLocation = nil
local isSetMode = false
local minimized = false

-- Draggable implementation
local function makeDraggable(frame)
    local dragToggle, dragStart, startPos
    frame.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            dragToggle = true; dragStart = input.Position; startPos = frame.Position 
        end 
    end)
    UIS.InputChanged:Connect(function(input) 
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then 
            local delta = input.Position - dragStart; frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) 
        end 
    end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = false end end)
end

-- GUI Construction
if guiParent:FindFirstChild("TPGui") then guiParent.TPGui:Destroy() end
local screenGui = Instance.new("ScreenGui", guiParent); screenGui.Name = "TPGui"
local frame = Instance.new("Frame", screenGui); frame.Size = UDim2.new(0, 160, 0, 80); frame.Position = UDim2.new(0.5, 0, 0.5, 0); frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0); makeDraggable(frame)
local minBtn = Instance.new("TextButton", frame); minBtn.Size = UDim2.new(0, 20, 0, 20); minBtn.Position = UDim2.new(0, 0, 0, 0); minBtn.Text = "v"; minBtn.TextColor3 = Color3.new(1,1,1); minBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
local indicator = Instance.new("TextButton", frame); indicator.Size = UDim2.new(0, 30, 0, 20); indicator.Position = UDim2.new(0.75, 0, 0.1, 0); indicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0); indicator.Text = ""
local actionBtn = Instance.new("TextButton", frame); actionBtn.Size = UDim2.new(0.8, 0, 0, 30); actionBtn.Position = UDim2.new(0.1, 0, 0.5, 0); actionBtn.Text = "set location"

-- Interaction Logic
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    frame.Size = minimized and UDim2.new(0, 160, 0, 20) or UDim2.new(0, 160, 0, 80)
    minBtn.Text = minimized and "^" or "v"
    indicator.Visible = not minimized
    actionBtn.Visible = not minimized
end)

indicator.MouseButton1Click:Connect(function()
    isSetMode = not isSetMode
    indicator.BackgroundColor3 = isSetMode and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    actionBtn.Text = isSetMode and "teleport" or "set location"
end)

actionBtn.MouseButton1Click:Connect(function()
    if not isSetMode then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            savedLocation = player.Character.HumanoidRootPart.CFrame
        end
    else
        if savedLocation and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = savedLocation
        end
    end
end)
