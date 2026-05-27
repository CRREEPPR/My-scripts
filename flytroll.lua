-- Fly Troll by Abd55_55 - V2.7
local player = game.Players.LocalPlayer
local flying, locked, minimized = false, false, false
local speed = 50
local lockedDirection = Vector3.new(0, 0, 0)
local SCRIPT_VERSION = "V2.7"

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

    -- Color Menu
    local colorGui = Instance.new("Frame", screenGui)
    colorGui.Size = UDim2.new(0, 150, 0, 310); colorGui.Position = UDim2.new(0.3, 0, 0.1, 0); colorGui.Visible = false; colorGui.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    local colorTarget = "Background"

    -- Close Button (X)
    local xBtn = Instance.new("TextButton", colorGui); xBtn.Text = "X"; xBtn.Size = UDim2.new(0, 20, 0, 20); xBtn.Position = UDim2.new(1, -25, 0, 5); xBtn.MouseButton1Click:Connect(function() colorGui.Visible = false end)

    local function applyColor(color)
        if colorTarget == "Background" then frame.BackgroundColor3 = color
        else for _, c in pairs(container:GetChildren()) do if c:IsA("TextButton") or c:IsA("TextBox") then c.BackgroundColor3 = color end end end
        colorGui.Visible = false
    end

    local colorList = {{"Rainbow", "Rainbow"}, {"Blue", Color3.new(0,0,1)}, {"Yellow", Color3.new(1,1,0)}, {"Red", Color3.new(1,0,0)}, {"Green", Color3.new(0,1,0)}, {"White", Color3.new(1,1,1)}, {"Black", Color3.new(0,0,0)}, {"Cyan", Color3.fromRGB(0,255,255)}, {"Pink", Color3.fromRGB(255,105,180)}, {"Purple", Color3.fromRGB(128,0,128)}}
    for i, v in pairs(colorList) do
        local btn = Instance.new("TextButton", colorGui); btn.Text = v[1]; btn.Size = UDim2.new(1, 0, 0, 28); btn.Position = UDim2.new(0, 0, 0, 30 + (i-1)*28); 
        btn.MouseButton1Click:Connect(function() 
            if v[1] == "Rainbow" then
                task.spawn(function()
                    while colorGui.Visible do for hue=0,1,0.01 do if colorTarget == "Background" then frame.BackgroundColor3 = Color3.fromHSV(hue,1,1) else for _,c in pairs(container:GetChildren()) do if c:IsA("TextButton") or c:IsA("TextBox") then c.BackgroundColor3 = Color3.fromHSV(hue,1,1) end end end task.wait(0.05) end end
                end)
            else applyColor(v[2]) end 
        end)
    end

    -- Controls
    local title = Instance.new("TextLabel", frame); title.Text = "Fly Troll " .. SCRIPT_VERSION; title.Size = UDim2.new(0.8, 0, 0, 30); title.BackgroundTransparency = 1; title.TextColor3 = Color3.new(1,1,1)
    local minBtn = Instance.new("TextButton", frame); minBtn.Text = "v"; minBtn.Position = UDim2.new(0.8, 0, 0, 0); minBtn.Size = UDim2.new(0.2, 0, 0, 30); minBtn.BackgroundTransparency = 1; minBtn.TextColor3 = Color3.new(1,1,1)
    local flyBtn = Instance.new("TextButton", container); flyBtn.Text = "Fly"; flyBtn.Size = UDim2.new(1, 0, 0, 30)
    local lockBtn = Instance.new("TextButton", container); lockBtn.Text = "Lock Fly: OFF"; lockBtn.Size = UDim2.new(1, 0, 0, 30); lockBtn.Position = UDim2.new(0,0,0.15,0)
    local bgBtn = Instance.new("TextButton", container); bgBtn.Text = "Change Background"; bgBtn.Size = UDim2.new(1, 0, 0, 30); bgBtn.Position = UDim2.new(0,0,0.3,0)
    local btnBtn = Instance.new("TextButton", container); btnBtn.Text = "Change Buttons"; btnBtn.Size = UDim2.new(1, 0, 0, 30); btnBtn.Position = UDim2.new(0,0,0.45,0)
    local speedBox = Instance.new("TextBox", container); speedBox.PlaceholderText = "Speed (1-1000)"; speedBox.Size = UDim2.new(1, 0, 0, 30); speedBox.Position = UDim2.new(0,0,0.6,0)

    minBtn.MouseButton1Click:Connect(function() minimized = not minimized; container.Visible = not minimized; frame.Size = minimized and UDim2.new(0, 180, 0, 30) or UDim2.new(0, 180, 0, 270); minBtn.Text = minimized and "^" or "v" end)
    bgBtn.MouseButton1Click:Connect(function() colorTarget = "Background"; colorGui.Visible = true end)
    btnBtn.MouseButton1Click:Connect(function() colorTarget = "Buttons"; colorGui.Visible = true end)
    
    lockBtn.MouseButton1Click:Connect(function() 
        locked = not locked; lockBtn.Text = locked and "Lock Fly: ON" or "Lock Fly: OFF"
        if locked then lockedDirection = workspace.CurrentCamera.CFrame.LookVector end 
    end)
    
    speedBox.FocusLost:Connect(function() speed = tonumber(speedBox.Text) or 50 end)

    local bv, bg
    flyBtn.MouseButton1Click:Connect(function()
        flying = not flying
        flyBtn.Text = flying and "Unfly" or "Fly"
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
