-- Fly Script Manager (V7.6 - Complete Integrated Version)
-- This script contains all features: Gravity/Infinite Jump, UI Navigation, Fly Physics, and Settings.

local player = game.Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local cam = workspace.CurrentCamera

-- Global Physics Adjustments
workspace.Gravity = 30
UIS.JumpRequest:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local flying = false
local speed = 50
local bv, bg

-- Helper: Draggable
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

-- 1. Selection Frame
local selectFrame = Instance.new("Frame", screenGui); selectFrame.Size = UDim2.new(0, 150, 0, 120); selectFrame.Position = UDim2.new(0.5, 0, 0.5, 0); selectFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); makeDraggable(selectFrame)
local btnFly = Instance.new("TextButton", selectFrame); btnFly.Size = UDim2.new(0.9, 0, 0, 40); btnFly.Position = UDim2.new(0.05, 0, 0.1, 0); btnFly.Text = "Fly Script"; btnFly.Parent = selectFrame
local btnSettings = Instance.new("TextButton", selectFrame); btnSettings.Size = UDim2.new(0.9, 0, 0, 40); btnSettings.Position = UDim2.new(0.05, 0, 0.6, 0); btnSettings.Text = "Settings"; btnSettings.Parent = selectFrame

-- 2. Fly Frame
local flyFrame = Instance.new("Frame", screenGui); flyFrame.Size = UDim2.new(0, 120, 0, 80); flyFrame.Position = UDim2.new(0.5, 0, 0.5, 0); flyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); flyFrame.Visible = false; makeDraggable(flyFrame)
local closeFly = Instance.new("TextButton", flyFrame); closeFly.Size = UDim2.new(0, 20, 0, 20); closeFly.Text = "X"; closeFly.BackgroundColor3 = Color3.fromRGB(50,50,50); closeFly.Parent = flyFrame
local toggleFly = Instance.new("TextButton", flyFrame); toggleFly.Size = UDim2.new(0.8, 0, 0, 30); toggleFly.Position = UDim2.new(0.1, 0, 0.4, 0); toggleFly.Text = "fly (off)"; toggleFly.Parent = flyFrame

-- 3. Settings Frame
local setFrame = Instance.new("Frame", screenGui); setFrame.Size = UDim2.new(0, 150, 0, 120); setFrame.Position = UDim2.new(0.5, 0, 0.5, 0); setFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); setFrame.Visible = false; makeDraggable(setFrame)
local closeSet = Instance.new("TextButton", setFrame); closeSet.Size = UDim2.new(0, 20, 0, 20); closeSet.Text = "X"; closeSet.BackgroundColor3 = Color3.fromRGB(50,50,50); closeSet.Parent = setFrame
local speedInput = Instance.new("TextBox", setFrame); speedInput.Size = UDim2.new(0.8, 0, 0, 30); speedInput.Position = UDim2.new(0.1, 0, 0.5, 0); speedInput.PlaceholderText = "Speed (1-10000)"; speedInput.Text = tostring(speed); speedInput.Parent = setFrame

-- 4. Closed Button
local circleBtn = Instance.new("TextButton", screenGui); circleBtn.Size = UDim2.new(0, 40, 0, 40); circleBtn.Position = UDim2.new(0.1, 0, 0.1, 0); circleBtn.Text = "O"; circleBtn.BackgroundColor3 = Color3.fromRGB(100,100,100); circleBtn.Visible = false; makeDraggable(circleBtn)

-- Navigation Logic
circleBtn.MouseButton1Click:Connect(function() selectFrame.Visible = true; circleBtn.Visible = false end)
closeFly.MouseButton1Click:Connect(function() flyFrame.Visible = false; circleBtn.Visible = true end)
closeSet.MouseButton1Click:Connect(function() setFrame.Visible = false; circleBtn.Visible = true end)
btnFly.MouseButton1Click:Connect(function() selectFrame.Visible = false; flyFrame.Visible = true end)
btnSettings.MouseButton1Click:Connect(function() selectFrame.Visible = false; setFrame.Visible = true end)

-- Fly Physics
toggleFly.MouseButton1Click:Connect(function()
    flying = not flying
    toggleFly.Text = flying and "fly (on)" or "fly (off)"
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if flying and hrp then
        bv = Instance.new("BodyVelocity", hrp); bv.MaxForce = Vector3.new(1,1,1)*9e9
        bg = Instance.new("BodyGyro", hrp); bg.MaxTorque = Vector3.new(1,1,1)*9e9; bg.P = 10000
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

speedInput.FocusLost:Connect(function() speed = math.clamp(tonumber(speedInput.Text) or 50, 1, 10000) end)

RS.RenderStepped:Connect(function()
    if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        bv.Velocity = cam.CFrame.LookVector * speed
        bg.CFrame = cam.CFrame
    end
end)
