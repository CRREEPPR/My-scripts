-- Fly Troll by Abd55_55 - V2.1
local player = game.Players.LocalPlayer
local flying = false
local locked = false
local speed = 50
local lockedDirection = Vector3.new(0, 0, 0)
local SCRIPT_VERSION = "V2.1"
local minimized = false

-- Color Settings
local hue = 0
local colorMode = "Rainbow"

local function createGUI()
    local screenGui = Instance.new("ScreenGui", game.CoreGui)
    screenGui.Name = "FlyTrollGUI"
    
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 180, 0, 240)
    frame.Position = UDim2.new(0.1, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    
    Instance.new("UIDragDetector", frame)
    
    -- Color Updater
    task.spawn(function()
        while frame and frame.Parent do
            if colorMode == "Rainbow" then
                hue = (hue + 0.01) % 1
                frame.BorderColor3 = Color3.fromHSV(hue, 1, 1)
            elseif colorMode == "Red" then frame.BorderColor3 = Color3.new(1, 0, 0)
            elseif colorMode == "Blue" then frame.BorderColor3 = Color3.new(0, 0, 1)
            elseif colorMode == "Green" then frame.BorderColor3 = Color3.new(0, 1, 0)
            end
            task.wait(0.05)
        end
    end)

    local title = Instance.new("TextLabel", frame)
    title.Text = "Fly Troll by Abd55_55 " .. SCRIPT_VERSION
    title.Size = UDim2.new(0.8, 0, 0, 30)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1

    -- Minimize Button
    local minBtn = Instance.new("TextButton", frame)
    minBtn.Text = "v"
    minBtn.Position = UDim2.new(0.8, 0, 0, 0)
    minBtn.Size = UDim2.new(0.2, 0, 0, 30)
    minBtn.BackgroundTransparency = 1
    minBtn.TextColor3 = Color3.new(1, 1, 1)

    -- Container for other buttons (to hide them when minimized)
    local container = Instance.new("Frame", frame)
    container.Size = UDim2.new(1, 0, 1, -30)
    container.Position = UDim2.new(0, 0, 0, 30)
    container.BackgroundTransparency = 1

    local toggleBtn = Instance.new("TextButton", container)
    toggleBtn.Text = "Toggle Fly"
    toggleBtn.Position = UDim2.new(0, 0, 0, 0)
    toggleBtn.Size = UDim2.new(1, 0, 0, 30)

    local lockBtn = Instance.new("TextButton", container)
    lockBtn.Text = "Lock Fly: OFF"
    lockBtn.Position = UDim2.new(0, 0, 0.2, 0)
    lockBtn.Size = UDim2.new(1, 0, 0, 30)

    local colorBtn = Instance.new("TextButton", container)
    colorBtn.Text = "Color: Rainbow"
    colorBtn.Position = UDim2.new(0, 0, 0.4, 0)
    colorBtn.Size = UDim2.new(1, 0, 0, 30)
    
    local speedBox = Instance.new("TextBox", container)
    speedBox.PlaceholderText = "Speed (1-1000)"
    speedBox.Position = UDim2.new(0, 0, 0.6, 0)
    speedBox.Size = UDim2.new(1, 0, 0, 30)

    -- Logic
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        container.Visible = not minimized
        frame.Size = minimized and UDim2.new(0, 180, 0, 30) or UDim2.new(0, 180, 0, 240)
        minBtn.Text = minimized and "^" or "v"
    end)

    -- (Keep all your existing toggle, lock, color, and speed logic here...)
    -- ... [Toggle, Lock, Color, Speed logic remains same as previous] ...
    
    -- ADDING THE LOGIC BACK IN FOR FUNCTIONALITY:
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

    colorBtn.MouseButton1Click:Connect(function()
        if colorMode == "Rainbow" then colorMode = "Red"
        elseif colorMode == "Red" then colorMode = "Blue"
        elseif colorMode == "Blue" then colorMode = "Green"
        else colorMode = "Rainbow" end
        colorBtn.Text = "Color: " .. colorMode
    end)

    speedBox.FocusLost:Connect(function()
        speed = math.clamp(tonumber(speedBox.Text) or 50, 1, 1000)
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
