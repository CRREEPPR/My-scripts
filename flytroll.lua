-- Fly Troll by CREEPER - V2.0
local player = game.Players.LocalPlayer
local flying = false
local locked = false
local speed = 50
local lockedDirection = Vector3.new(0, 0, 0)
local customAnimEnabled = false

-- Animation IDs
local CUSTOM_WALK_ID = "rbxassetid://2510197257"
local DEFAULT_WALK_ID = "http://www.roblox.com/asset/?id=507777826" 

local function updateWalkAnimation()
    local char = player.Character
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    if animate then
        local targetID = customAnimEnabled and CUSTOM_WALK_ID or DEFAULT_WALK_ID
        if animate:FindFirstChild("walk") then
            animate.walk.WalkAnim.AnimationId = targetID
        end
        if animate:FindFirstChild("run") then
            animate.run.RunAnim.AnimationId = targetID
        end
        
        -- Reset to apply changes
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum:UnequipTools() end
    end
end

local function createGUI()
    local screenGui = Instance.new("ScreenGui", game.CoreGui)
    screenGui.Name = "FlyTrollGUI"
    
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 180, 0, 230)
    frame.Position = UDim2.new(0.1, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    
    -- Add Modern Dragging
    Instance.new("UIDragDetector", frame)
    
    -- Rainbow Effect
    task.spawn(function()
        while frame and frame.Parent do
            for i = 0, 1, 0.01 do
                if frame then frame.BorderColor3 = Color3.fromHSV(i, 1, 1) end
                task.wait(0.05)
            end
        end
    end)

    -- Buttons
    local function createBtn(text, pos)
        local btn = Instance.new("TextButton", frame)
        btn.Text = text
        btn.Position = pos
        btn.Size = UDim2.new(1, 0, 0, 30)
        return btn
    end

    local toggleBtn = createBtn("Toggle Fly", UDim2.new(0, 0, 0.15, 0))
    local lockBtn = createBtn("Lock Fly: OFF", UDim2.new(0, 0, 0.3, 0))
    local animBtn = createBtn("Walk Anim: OFF", UDim2.new(0, 0, 0.45, 0))
    
    local speedBox = Instance.new("TextBox", frame)
    speedBox.PlaceholderText = "Speed (1-100)"
    speedBox.Position = UDim2.new(0, 0, 0.6, 0)
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
            lockBtn.Text = locked and "Lock Fly: ON" or "Lock Fly: OFF"
            lockedDirection = workspace.CurrentCamera.CFrame.LookVector
        end
    end)

    animBtn.MouseButton1Click:Connect(function()
        customAnimEnabled = not customAnimEnabled
        animBtn.Text = customAnimEnabled and "Walk Anim: ON" or "Walk Anim: OFF"
        updateWalkAnimation()
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
    if game.CoreGui:FindFirstChild("FlyTrollGUI") then game.CoreGui.FlyTrollGUI:Destroy() end
    createGUI()
end)

createGUI()
