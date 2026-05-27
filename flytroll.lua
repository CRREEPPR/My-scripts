-- Fly Troll by Abd55_55 - V3.0
local player = game.Players.LocalPlayer
local flying, locked, minimized = false, false, false
local speed = 50
local lockedDirection = Vector3.new(0, 0, 0)
local SCRIPT_VERSION = "V3.0"
local currentRainbowTarget = nil -- nil, "Background", "Buttons"

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

    local colorGui = Instance.new("Frame", screenGui)
    colorGui.Size = UDim2.new(0, 160, 0, 210); colorGui.Position = UDim2.new(0.3, 0, 0.1, 0); colorGui.Visible = false; colorGui.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    Instance.new("UIDragDetector", colorGui); Instance.new("UICorner", colorGui).CornerRadius = UDim.new(0, 15)

    local xBtn = Instance.new("TextButton", colorGui); xBtn.Text = "X"; xBtn.Size = UDim2.new(0, 30, 0, 30); xBtn.Position = UDim2.new(1, -35, 0, 5); xBtn.BackgroundTransparency = 1; xBtn.TextColor3 = Color3.new(1,0,0); xBtn.TextSize = 25; xBtn.MouseButton1Click:Connect(function() colorGui.Visible = false end)
    
    local scroll = Instance.new("ScrollingFrame", colorGui); scroll.Size = UDim2.new(1, -20, 1, -40); scroll.Position = UDim2.new(0, 10, 0, 40); scroll.CanvasSize = UDim2.new(0, 0, 2, 0); scroll.BackgroundTransparency = 1
    local grid = Instance.new("UIGridLayout", scroll); grid.CellSize = UDim2.new(0, 40, 0, 40); grid.CellPadding = UDim2.new(0, 5, 0, 5); grid.FillDirectionMaxCells = 3

    local colorTarget = "Background"
    local colors = {Color3.new(1,1,1), Color3.new(0,0,1), Color3.fromRGB(255,165,0), Color3.new(1,1,0), Color3.new(1,0,0), Color3.new(0,1,0), Color3.new(1,1,1), Color3.new(0,0,0), Color3.fromRGB(0,255,255), Color3.fromRGB(255,105,180), Color3.fromRGB(128,0,128)}
    
    -- Rainbow Slot
    local rBtn = Instance.new("TextButton", scroll); rBtn.Text = "R"; rBtn.Size = UDim2.new(0,40,0,40); rBtn.MouseButton1Click:Connect(function() currentRainbowTarget = colorTarget; colorGui.Visible = false end)
    
    for _, col in pairs(colors) do
        local b = Instance.new("TextButton", scroll); b.Text = ""; b.BackgroundColor3 = col; b.MouseButton1Click:Connect(function() 
            if currentRainbowTarget == colorTarget then currentRainbowTarget = nil end
            if colorTarget == "Background" then frame.BackgroundColor3 = col else for _, c in pairs(container:GetChildren()) do if c:IsA("TextButton") or c:IsA("TextBox") then c.BackgroundColor3 = col end end end
            colorGui.Visible = false 
        end)
    end

    task.spawn(function()
        local h = 0
        while task.wait(0.05) do
            h = (h + 0.01) % 1
            local c = Color3.fromHSV(h, 1, 1)
            if currentRainbowTarget == "Background" then frame.BackgroundColor3 = c
            elseif currentRainbowTarget == "Buttons" then for _, o in pairs(container:GetChildren()) do if o:IsA("TextButton") or o:IsA("TextBox") then o.BackgroundColor3 = c end end end
        end
    end)

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
