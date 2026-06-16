-- Fly Script Manager (V6.0)
-- Technical Implementation: Manages two UI states (Open/Closed) with persistence and state toggling.

local player = game.Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local flying = false

-- Draggable Helper
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

-- UI Construction
if guiParent:FindFirstChild("FlySystem") then guiParent.FlySystem:Destroy() end
local screenGui = Instance.new("ScreenGui", guiParent); screenGui.Name = "FlySystem"; screenGui.ResetOnSpawn = false

-- Main UI
local mainFrame = Instance.new("Frame", screenGui); mainFrame.Size = UDim2.new(0, 200, 0, 150); mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); makeDraggable(mainFrame)
local closeBtn = Instance.new("TextButton", mainFrame); closeBtn.Size = UDim2.new(0, 30, 0, 30); closeBtn.Text = "X"; closeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); closeBtn.TextColor3 = Color3.new(1,1,1)
local flyBtn = Instance.new("TextButton", mainFrame); flyBtn.Size = UDim2.new(0.8, 0, 0, 50); flyBtn.Position = UDim2.new(0.1, 0, 0.4, 0); flyBtn.Text = "fly (off)"

-- Closed State UI (Circle)
local closedFrame = Instance.new("Frame", screenGui); closedFrame.Size = UDim2.new(0, 60, 0, 60); closedFrame.Position = UDim2.new(0.1, 0, 0.1, 0); closedFrame.BackgroundColor3 = Color3.fromRGB(0,0,0); closedFrame.Visible = false; makeDraggable(closedFrame)
closedFrame.BackgroundTransparency = 1 -- Styling
local circleBtn = Instance.new("ImageButton", closedFrame); circleBtn.Size = UDim2.new(1,0,1,0); circleBtn.BackgroundColor3 = Color3.fromRGB(100,100,100); circleBtn.AutoButtonColor = false; circleBtn.Parent = closedFrame

-- Logic
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    closedFrame.Visible = true
end)

circleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    closedFrame.Visible = false
end)

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = flying and "fly (on)" or "fly (off)"
    -- Add your flight physics logic here
end)
