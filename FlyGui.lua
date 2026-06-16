-- Fly Script Manager (V6.1)
-- Technical Implementation: Added physics components (BodyVelocity/BodyGyro), reduced UI scale, and refined drag logic.

local player = game.Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local flying = false
local speed = 50

-- Physics setup
local function startFlying()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local bv = Instance.new("BodyVelocity", hrp); bv.Name = "FlyBV"
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Velocity = Vector3.new(0, 0, 0)
    local bg = Instance.new("BodyGyro", hrp); bg.Name = "FlyBG"
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.P = 10000; bg.CFrame = hrp.CFrame
end

local function stopFlying()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        for _, v in pairs(char.HumanoidRootPart:GetChildren()) do
            if v.Name == "FlyBV" or v.Name == "FlyBG" then v:Destroy() end
        end
    end
end

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
local mainFrame = Instance.new("Frame", screenGui); mainFrame.Size = UDim2.new(0, 150, 0, 100); mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); makeDraggable(mainFrame)
local closeBtn = Instance.new("TextButton", mainFrame); closeBtn.Size = UDim2.new(0, 25, 0, 25); closeBtn.Text = "X"; closeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); closeBtn.TextColor3 = Color3.new(1,1,1)
local flyBtn = Instance.new("TextButton", mainFrame); flyBtn.Size = UDim2.new(0.8, 0, 0, 40); flyBtn.Position = UDim2.new(0.1, 0, 0.4, 0); flyBtn.Text = "fly (off)"

-- Closed State UI
local closedFrame = Instance.new("Frame", screenGui); closedFrame.Size = UDim2.new(0, 50, 0, 50); closedFrame.Position = UDim2.new(0.1, 0, 0.1, 0); closedFrame.BackgroundColor3 = Color3.fromRGB(0,0,0); closedFrame.Visible = false; makeDraggable(closedFrame)
local circleBtn = Instance.new("TextButton", closedFrame); circleBtn.Size = UDim2.new(1,0,1,0); circleBtn.Text = "O"; circleBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)

-- Logic
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false; closedFrame.Visible = true end)
circleBtn.MouseButton1Click:Connect(function() mainFrame.Visible = true; closedFrame.Visible = false end)

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = flying and "fly (on)" or "fly (off)"
    if flying then startFlying() else stopFlying() end
end)

RS.RenderStepped:Connect(function()
    if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        hrp.FlyBG.CFrame = workspace.CurrentCamera.CFrame
        hrp.FlyBV.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed
    end
end)
