-- Fly Script Manager (V8.7 - Fixed Speed & Auto-Aim)
-- Technical Implementation: Resolved speed variable synchronization and implemented continuous look-at logic for Aimbot.

local player = game.Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local cam = workspace.CurrentCamera

-- Global Physics
workspace.Gravity = 30
UIS.JumpRequest:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local flying, speed, bv, bg = false, 50, nil, nil
local crosshairEnabled, aimEnabled, targetPlayer = false, false, nil

-- UI Setup
if guiParent:FindFirstChild("FlySystem") then guiParent.FlySystem:Destroy() end
local screenGui = Instance.new("ScreenGui", guiParent); screenGui.Name = "FlySystem"; screenGui.ResetOnSpawn = false

-- Crosshair GUI
local crosshair = Instance.new("Frame", screenGui); crosshair.Size = UDim2.new(0, 20, 0, 2); crosshair.Position = UDim2.new(0.5, -10, 0.5, -1); crosshair.BackgroundColor3 = Color3.new(1,1,1); crosshair.Visible = false
local crosshairV = Instance.new("Frame", crosshair); crosshairV.Size = UDim2.new(0, 2, 0, 20); crosshairV.Position = UDim2.new(0.5, -1, 0.5, -10); crosshairV.BackgroundColor3 = Color3.new(1,1,1)

local function makeDraggable(frame)
    local dragToggle, dragStart, startPos
    frame.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            dragToggle = true; dragStart = input.Position; startPos = frame.Position 
        end 
    end)
    UIS.InputChanged:Connect(function(input) 
        if dragToggle then local delta = input.Position - dragStart; frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end 
    end)
    UIS.InputEnded:Connect(function() dragToggle = false end)
end

-- Frames
local selectFrame = Instance.new("Frame", screenGui); selectFrame.Size = UDim2.new(0, 150, 0, 120); selectFrame.Position = UDim2.new(0.5, 0, 0.5, 0); selectFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); makeDraggable(selectFrame)
local flyFrame = Instance.new("Frame", screenGui); flyFrame.Size = UDim2.new(0, 120, 0, 80); flyFrame.Position = UDim2.new(0.5, 0, 0.5, 0); flyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); flyFrame.Visible = false; makeDraggable(flyFrame)
local setFrame = Instance.new("Frame", screenGui); setFrame.Size = UDim2.new(0, 150, 0, 160); setFrame.Position = UDim2.new(0.5, 0, 0.5, 0); setFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); setFrame.Visible = false; makeDraggable(setFrame)
local circleBtn = Instance.new("TextButton", screenGui); circleBtn.Size = UDim2.new(0, 40, 0, 40); circleBtn.Position = UDim2.new(0.1, 0, 0.1, 0); circleBtn.Text = "O"; circleBtn.Visible = false; makeDraggable(circleBtn)

local aimFrame = Instance.new("Frame", screenGui); aimFrame.Size = UDim2.new(0, 100, 0, 70); aimFrame.Position = UDim2.new(0.7, 0, 0.5, 0); aimFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); aimFrame.Visible = false; makeDraggable(aimFrame)
local btnAim = Instance.new("TextButton", aimFrame); btnAim.Size = UDim2.new(0.9, 0, 0, 25); btnAim.Position = UDim2.new(0.05, 0, 0.1, 0); btnAim.Text = "aim (off)"; btnAim.Parent = aimFrame
local btnLock = Instance.new("TextButton", aimFrame); btnLock.Size = UDim2.new(0.9, 0, 0, 25); btnLock.Position = UDim2.new(0.05, 0, 0.6, 0); btnLock.Text = "change player"; btnLock.Parent = aimFrame

-- Navigation Buttons
local btnFly = Instance.new("TextButton", selectFrame); btnFly.Size = UDim2.new(0.9, 0, 0, 40); btnFly.Position = UDim2.new(0.05, 0, 0.1, 0); btnFly.Text = "Fly Script"; btnFly.Parent = selectFrame
local btnSettings = Instance.new("TextButton", selectFrame); btnSettings.Size = UDim2.new(0.9, 0, 0, 40); btnSettings.Position = UDim2.new(0.05, 0, 0.6, 0); btnSettings.Text = "Settings"; btnSettings.Parent = selectFrame

local closeFly = Instance.new("TextButton", flyFrame); closeFly.Size = UDim2.new(0, 20, 0, 20); closeFly.Text = "X"; closeFly.Parent = flyFrame
local toggleFly = Instance.new("TextButton", flyFrame); toggleFly.Size = UDim2.new(0.8, 0, 0, 30); toggleFly.Position = UDim2.new(0.1, 0, 0.4, 0); toggleFly.Text = "fly (off)"; toggleFly.Parent = flyFrame

local closeSet = Instance.new("TextButton", setFrame); closeSet.Size = UDim2.new(0, 20, 0, 20); closeSet.Text = "X"; closeSet.Parent = setFrame
local speedInput = Instance.new("TextBox", setFrame); speedInput.Size = UDim2.new(0.8, 0, 0, 30); speedInput.Position = UDim2.new(0.1, 0, 0.3, 0); speedInput.PlaceholderText = "Speed"; speedInput.Parent = setFrame
local btnCross = Instance.new("TextButton", setFrame); btnCross.Size = UDim2.new(0.8, 0, 0, 40); btnCross.Position = UDim2.new(0.1, 0, 0.6, 0); btnCross.Text = "crosshair (off)"; btnCross.Parent = setFrame

-- Logic
btnFly.MouseButton1Click:Connect(function() selectFrame.Visible = false; flyFrame.Visible = true end)
btnSettings.MouseButton1Click:Connect(function() selectFrame.Visible = false; setFrame.Visible = true end)
closeFly.MouseButton1Click:Connect(function() flyFrame.Visible = false; circleBtn.Visible = true end)
closeSet.MouseButton1Click:Connect(function() setFrame.Visible = false; circleBtn.Visible = true end)
circleBtn.MouseButton1Click:Connect(function() selectFrame.Visible = true; circleBtn.Visible = false end)

toggleFly.MouseButton1Click:Connect(function()
    flying = not flying; toggleFly.Text = flying and "fly (on)" or "fly (off)"
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if flying and hrp then
        bv = Instance.new("BodyVelocity", hrp); bv.MaxForce = Vector3.new(1,1,1)*9e9
        bg = Instance.new("BodyGyro", hrp); bg.MaxTorque = Vector3.new(1,1,1)*9e9; bg.P = 10000
    elseif bv then bv:Destroy(); bg:Destroy() end
end)

btnCross.MouseButton1Click:Connect(function()
    crosshairEnabled = not crosshairEnabled
    crosshair.Visible = crosshairEnabled; aimFrame.Visible = crosshairEnabled
    btnCross.Text = crosshairEnabled and "crosshair (on)" or "crosshair (off)"
    if not crosshairEnabled then aimEnabled = false; btnAim.Text = "aim (off)" end
end)

btnAim.MouseButton1Click:Connect(function() aimEnabled = not aimEnabled; btnAim.Text = aimEnabled and "aim (on)" or "aim (off)" end)
btnLock.MouseButton1Click:Connect(function()
    local closest, dist = nil, math.huge
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (p.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then closest = p.Character.HumanoidRootPart; dist = d end
        end
    end
    targetPlayer = closest
end)

speedInput.FocusLost:Connect(function() speed = tonumber(speedInput.Text) or 50 end)

RS.RenderStepped:Connect(function()
    if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        bv.Velocity = cam.CFrame.LookVector * speed
        bg.CFrame = cam.CFrame
    end
    if aimEnabled and targetPlayer and targetPlayer.Parent then
        cam.CFrame = CFrame.new(cam.CFrame.Position, targetPlayer.Position)
    end
end)
