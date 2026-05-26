-- Fly Troll by CREEPER
local player = game.Players.LocalPlayer
local flying = false
local locked = false
local speed = 50
local lockedDirection = Vector3.new(0, 0, 0)

-- Animation Settings
local CUSTOM_WALK_ID = "rbxassetid://2510197257"
local DEFAULT_WALK_ID = "http://www.roblox.com/asset/?id=507777826" -- Default R15 Walk
local customAnimEnabled = false

local function updateWalkAnimation()
    local char = player.Character
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    if animate and animate:FindFirstChild("walk") then
        local targetID = customAnimEnabled and CUSTOM_WALK_ID or DEFAULT_WALK_ID
        animate.walk.WalkAnim.AnimationId = targetID
        animate.run.RunAnim.AnimationId = targetID
        
        -- Force refresh
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then humanoid:UnequipTools() end
    end
end

local function createGUI()
    local screenGui = Instance.new("ScreenGui", game.CoreGui)
    screenGui.Name = "FlyTrollGUI"
    
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 180, 0, 230)
    frame.Position = UDim2.new(0.1, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    local dragDetector = Instance.new("UIDragDetector", frame)
    
    -- Rainbow Effect
    spawn(function()
        while frame and frame.Parent do
            for i = 0, 1, 0.01 do
                if frame then frame.BorderColor3 = Color3.fromHSV(i, 1, 1) end
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
    toggleBtn.Position = UDim2.new(0, 0, 0.15, 0)
    toggleBtn.Size = UDim2.new(1, 0, 0, 30)

    local lockBtn = Instance.new("TextButton", frame)
    lockBtn.Text = "Lock Fly: OFF"
    lockBtn.Position = UDim2.new(0, 0, 0.3, 0)
    lockBtn.Size = UDim2.new(1, 0, 0, 30)

    local animBtn = Instance.new("TextButton", frame)
    animBtn.Text = "Walk Anim: OFF"
    animBtn.Position = UDim2.new(0, 0, 0.45, 0)
    animBtn.Size = UDim2.new(1, 0, 0, 30)
    
    local speedBox = Instance.new("TextBox", frame)
    speedBox.PlaceholderText = "Speed (1-100)"
    speedBox.Position = UDim2.new(0, 0, 0.6, 0)
    speedBox.Size = UDim2.new(1, 0, 0, 30)

    -- Toggle Logic
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

    animBtn.MouseButton1Click:Connect(function()
        customAnimEnabled = not customAnimEnabled
        animBtn.Text = customAnimEnabled and "Walk Anim: ON" or "Walk Anim: OFF"
        updateWalkAnimation()
    end)

    -- [Rest of your existing lock and speed logic remains identical]
    -- ...
end
