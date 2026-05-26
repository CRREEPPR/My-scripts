-- Fly GUI by Creeper
-- Creates a ScreenGui with Fly toggle and Speed adjustment

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50

-- UI Elements
local screenGui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 150, 0, 100)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Text = "Fly GUI by Creeper"
title.Size = UDim2.new(1, 0, 0, 30)
title.TextColor3 = Color3.new(1, 1, 1)

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Text = "Toggle Fly"
toggleBtn.Position = UDim2.new(0, 0, 0.3, 0)
toggleBtn.Size = UDim2.new(1, 0, 0, 30)

local speedBox = Instance.new("TextBox", frame)
speedBox.PlaceholderText = "Speed: 50"
speedBox.Position = UDim2.new(0, 0, 0.6, 0)
speedBox.Size = UDim2.new(1, 0, 0, 30)

-- Logic
local bv, bg

toggleBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 10000
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

speedBox.FocusLost:Connect(function()
    speed = tonumber(speedBox.Text) or 50
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if flying and bv and bg then
        bg.CFrame = workspace.CurrentCamera.CFrame
        bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed
    end
end)
