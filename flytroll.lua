-- Fly Troll by CREEPER
local player = game.Players.LocalPlayer
local flying = false
local locked = false -- New variable
local speed = 50
local lockedDirection = Vector3.new(0, 0, 0) -- Stores the saved direction

local function createGUI()
    local screenGui = Instance.new("ScreenGui", game.CoreGui)
    screenGui.Name = "FlyTrollGUI"
    
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 180, 0, 160) -- Made slightly larger to fit button
    frame.Position = UDim2.new(0.1, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.Draggable = true
    
    spawn(function()
        while frame and frame.Parent do
            for i = 0, 1, 0.01 do
                frame.BorderColor3 = Color3.fromHSV(i, 1, 1)
                task.wait(0.05)
            end
        end
    end)

    local title = Instance.new("TextLabel", frame)
    title.Text = "Fly Troll by CREEPER"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1

    local toggleBtn = Instance.new("TextButton", frame)
    toggleBtn.Text = "Toggle Fly"
    toggleBtn.Position = UDim2.new(0, 0, 0.2, 0)
    toggleBtn.Size = UDim2.new(1, 0, 0, 30)

    local lockBtn = Instance.new("TextButton", frame)
    lockBtn.Text = "Lock Fly: OFF"
    lockBtn.Position = UDim2.new(0, 0, 0.4, 0)
    lockBtn.Size = UDim2.new(1, 0, 0, 30)

    local speedBox = Instance.new("TextBox", frame)
    speedBox.PlaceholderText = "Speed (1-100)"
    speedBox.Position = UDim2.new(0, 0, 0.65, 0)
    speedBox.Size = UDim2.new(1, 0, 0, 30)

    local bv, bg

    toggleBtn.MouseButton1Click:Connect(function()
        flying = not flying
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if flying and root then
            bv = Instance.new("BodyVelocity", root)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bg = Instance.new("BodyGyro", root)
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.P = 10000
        else
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
            locked = false
            lockBtn.Text = "Lock Fly: OFF"
        end
    end)

    lockBtn.MouseButton1Click:Connect(function()
        if flying then
            locked = not locked
            if locked then
                lockedDirection = workspace.CurrentCamera.CFrame.LookVector
                lockBtn.Text = "Lock Fly: ON"
            else
                lockBtn.Text = "Lock Fly: OFF"
            end
        end
    end)

    speedBox.FocusLost:Connect(function()
        speed = math.clamp(tonumber(speedBox.Text) or 50, 1, 100)
    end)

    game:GetService("RunService").RenderStepped:Connect(function()
        if flying then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root and bv and bg then
                if locked then
                    -- Use the saved direction instead of the current camera direction
                    bv.Velocity = lockedDirection * speed
                else
                    bg.CFrame = workspace.CurrentCamera.CFrame
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed
                end
            end
        end
    end)
end

player.CharacterAdded:Connect(function()
    task.wait(1)
    if game.CoreGui:FindFirstChild("FlyTrollGUI") then
        game.CoreGui.FlyTrollGUI:Destroy()
    end
    createGUI()
end)

createGUI()
