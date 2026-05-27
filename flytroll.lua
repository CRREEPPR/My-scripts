-- Fly Troll by Abd55_55 - V2.9
local player = game.Players.LocalPlayer
local flying, locked, minimized = false, false, false
local speed = 50
local lockedDirection = Vector3.new(0, 0, 0)
local SCRIPT_VERSION = "V2.9"
local rainbowTarget = nil -- "Background" or "Buttons"

local function createGUI()
    local screenGui = Instance.new("ScreenGui", game.CoreGui)
    screenGui.Name = "FlyTrollGUI"
    
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 180, 0, 270)
    frame.Position = UDim2.new(0.1, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UIDragDetector", frame)

    local container = Instance.new("Frame", frame)
    container.Size = UDim2.new(1, 0, 1, -30); container.Position = UDim2.new(0, 0, 0, 30); container.BackgroundTransparency = 1

    -- Color Menu (Scrollable)
    local colorGui = Instance.new("Frame", screenGui)
    colorGui.Size = UDim2.new(0, 150, 0, 200); colorGui.Position = UDim2.new(0.3, 0, 0.1, 0); colorGui.Visible = false; colorGui.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UIDragDetector", colorGui)
    
    local scrollingFrame = Instance.new("ScrollingFrame", colorGui)
    scrollingFrame.Size = UDim2.new(1, 0, 1, -30); scrollingFrame.Position = UDim2.new(0,0,0,30); scrollingFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
    
    local colorTarget = "Background"
    local xBtn = Instance.new("TextButton", colorGui); xBtn.Text = "X"; xBtn.Size = UDim2.new(0, 30, 0, 30); xBtn.Position = UDim2.new(1, -30, 0, 0); xBtn.MouseButton1Click:Connect(function() colorGui.Visible = false end)

    local function applyColor(color, isRainbow)
        if isRainbow then rainbowTarget = colorTarget
        else 
            if rainbowTarget == colorTarget then rainbowTarget = nil end
            if colorTarget == "Background" then frame.BackgroundColor3 = color
            else for _, c in pairs(container:GetChildren()) do if c:IsA("TextButton") or c:IsA("TextBox") then c.BackgroundColor3 = color end end end
        end
    end

    local colors = {{"Rainbow", Color3.new(1,1,1), true}, {"Blue", Color3.new(0,0,1)}, {"Orange", Color3.fromRGB(255,165,0)}, {"Yellow", Color3.new(1,1,0)}, {"Red", Color3.new(1,0,0)}, {"Green", Color3.new(0,1,0)}, {"White", Color3.new(1,1,1)}, {"Black", Color3.new(0,0,0)}, {"Cyan", Color3.fromRGB(0,255,255)}, {"Pink", Color3.fromRGB(255,105,180)}, {"Purple", Color3.fromRGB(128,0,128)}}
    for i, v in pairs(colors) do
        local btn = Instance.new("TextButton", scrollingFrame); btn.Text = ""; btn.Size = UDim2.new(1, -10, 0, 30); btn.Position = UDim2.new(0, 5, 0, (i-1)*35); btn.BackgroundColor3 = v[2]
        btn.MouseButton1Click:Connect(function() applyColor(v[2], v[3]) end)
    end

    -- Rainbow Loop
    task.spawn(function()
        local hue = 0
        while true do
            hue = (hue + 0.005) % 1
            local rainbow = Color3.fromHSV(hue, 1, 1)
            if rainbowTarget == "Background" or rainbowTarget == "Both" then frame.BackgroundColor3 = rainbow end
            if rainbowTarget == "Buttons" or rainbowTarget == "Both" then for _, c in pairs(container:GetChildren()) do if c:IsA("TextButton") or c:IsA("TextBox") then c.BackgroundColor3 = rainbow end end end
            task.wait(0.05)
        end
    end)

    -- Controls
    local title = Instance.new("TextLabel", frame); title.Text = "Fly Troll " .. SCRIPT_VERSION; title.Size = UDim2.new(0.8, 0, 0, 30); title.BackgroundTransparency = 1; title.TextColor3 = Color3.new(1,1,1)
    local minBtn = Instance.new("TextButton", frame); minBtn.Text = "v"; minBtn.Position = UDim2.new(0.8, 0, 0, 0); minBtn.Size = UDim2.new(0.2, 0, 0, 30); minBtn.BackgroundTransparency = 1; minBtn.TextColor3 = Color3.new(1,1,1)
    local flyBtn = Instance.new("TextButton", container); flyBtn.Text = "Fly"; flyBtn.Size = UDim2.new(1, 0, 0, 30)
    local lockBtn = Instance.new("TextButton", container); lockBtn.Text = "Lock Fly: OFF"; lockBtn.Size = UDim2.new(1, 0, 0, 30); lockBtn.Position = UDim2.new(0,0,0.15,0)
    local bgBtn = Instance.new("TextButton", container); bgBtn.Text = "Background Color"; bgBtn.Size = UDim2.new(1, 0, 0, 30); bgBtn.Position = UDim2.new(0,0,0.3,0)
    local btnBtn = Instance.new("TextButton", container); btnBtn.Text = "Button Color"; btnBtn.Size = UDim2.new(1, 0, 0, 30); btnBtn.Position = UDim2.new(0,0,0.45,0)
    local speedBox = Instance.new("TextBox", container); speedBox.PlaceholderText = "Speed (1-1000)"; speedBox.Size = UDim2.new(1, 0, 0, 30); speedBox.Position = UDim2.new(0,0,0.6,0)

    minBtn.MouseButton1Click:Connect(function() minimized = not minimized; container.Visible = not minimized; frame.Size = minimized and UDim2.new(0, 180, 0, 30) or UDim2.new(0, 180, 0, 270); minBtn.Text = minimized and "^" or "v" end)
    bgBtn.MouseButton1Click:Connect(function() colorTarget = "Background"; colorGui.Visible = true end)
    btnBtn.MouseButton1Click:Connect(function() colorTarget = "Buttons"; colorGui.Visible = true end)
    lockBtn.MouseButton1Click:Connect(function() locked = not locked; lockBtn.Text = locked and "Lock Fly: ON" or "Lock Fly: OFF"; if locked then lockedDirection = workspace.CurrentCamera.CFrame.LookVector end end)
    speedBox.FocusLost:Connect(function() speed = tonumber(speedBox.Text) or 50 end)

    local bv, bg
    flyBtn.MouseButton1Click:Connect(function()
        flying = not flying; flyBtn.Text = flying and "Unfly" or "Fly"
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if flying and root then
            bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bg = Instance.new("BodyGyro", root); bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); bg.P = 10000
        else
            if bv then bv:Destroy() end if bg then bg:Destroy() end
            locked = false; lockBtn.Text = "Lock Fly: OFF"
        end
    end)

    game:GetService("RunService").RenderStepped:Connect(function()
        if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if locked then bv.Velocity = lockedDirection * speed
            else bg.CFrame = workspace.CurrentCamera.CFrame; bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed end
        end
    end)
end
createGUI()
