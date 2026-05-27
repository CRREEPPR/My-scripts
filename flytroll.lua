-- Fly Troll by Abd55_55 V5.0
local player = game.Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local flying, locked, minimized, flinging = false, false, false, false
local speed = 50
local lockedDirection = Vector3.new(0, 0, 0)

-- Drag Logic
local function makeDraggable(frame)
    local dragToggle = false
    frame.Active = true
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = true end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = false end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            frame.Position = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset + input.Delta.X, frame.Position.Y.Scale, frame.Position.Y.Offset + input.Delta.Y)
        end
    end)
end

-- GUI Setup
local function createGUI()
    if guiParent:FindFirstChild("FlyTrollGUI") then guiParent.FlyTrollGUI:Destroy() end
    local screenGui = Instance.new("ScreenGui", guiParent); screenGui.Name = "FlyTrollGUI"; screenGui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame", screenGui); frame.Size = UDim2.new(0, 180, 0, 350); frame.Position = UDim2.new(0.1, 0, 0.1, 0); frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); makeDraggable(frame)
    local title = Instance.new("TextLabel", frame); title.Text = "Fly troll V5.0"; title.Size = UDim2.new(0.8, 0, 0, 30); title.TextColor3 = Color3.new(1,1,1); title.BackgroundTransparency = 1
    local minBtn = Instance.new("TextButton", frame); minBtn.Text = "v"; minBtn.Size = UDim2.new(0.2, 0, 0, 30); minBtn.Position = UDim2.new(0.8, 0, 0, 0); minBtn.BackgroundTransparency = 1; minBtn.TextColor3 = Color3.new(1,1,1)
    
    local container = Instance.new("Frame", frame); container.Size = UDim2.new(1, 0, 1, -30); container.Position = UDim2.new(0, 0, 0, 30); container.BackgroundTransparency = 1
    local flyBtn = Instance.new("TextButton", container); flyBtn.Text = "Fly"; flyBtn.Size = UDim2.new(0.9, 0, 0, 40); flyBtn.Position = UDim2.new(0.05, 0, 0, 10)
    local lockBtn = Instance.new("TextButton", container); lockBtn.Text = "Lock Fly: OFF"; lockBtn.Size = UDim2.new(0.9, 0, 0, 40); lockBtn.Position = UDim2.new(0.05, 0, 0, 60)
    local flingBtn = Instance.new("TextButton", container); flingBtn.Text = "Fling: OFF"; flingBtn.Size = UDim2.new(0.9, 0, 0, 40); flingBtn.Position = UDim2.new(0.05, 0, 0, 110)
    local bgBtn = Instance.new("TextButton", container); bgBtn.Text = "Background Color"; bgBtn.Size = UDim2.new(0.9, 0, 0, 40); bgBtn.Position = UDim2.new(0.05, 0, 0, 160)
    local btnBtn = Instance.new("TextButton", container); btnBtn.Text = "Buttons Color"; btnBtn.Size = UDim2.new(0.9, 0, 0, 40); btnBtn.Position = UDim2.new(0.05, 0, 0, 210)
    local speedBox = Instance.new("TextBox", container); speedBox.Text = "50"; speedBox.PlaceholderText = "Speed (1-10000)"; speedBox.Size = UDim2.new(0.9, 0, 0, 40); speedBox.Position = UDim2.new(0.05, 0, 0, 260)

    -- Color Menu
    local colorGui = Instance.new("Frame", screenGui); colorGui.Size = UDim2.new(0, 160, 0, 240); colorGui.Position = UDim2.new(0.3, 0, 0.1, 0); colorGui.Visible = false; colorGui.BackgroundColor3 = Color3.fromRGB(150, 150, 150); makeDraggable(colorGui)
    local xBtn = Instance.new("TextButton", colorGui); xBtn.Text = "X"; xBtn.Size = UDim2.new(0, 30, 0, 30); xBtn.Position = UDim2.new(1, -35, 0, 5); xBtn.TextColor3 = Color3.new(1,0,0); xBtn.BackgroundTransparency = 1; xBtn.MouseButton1Click:Connect(function() colorGui.Visible = false end)
    local scroll = Instance.new("ScrollingFrame", colorGui); scroll.Size = UDim2.new(1, -20, 1, -50); scroll.Position = UDim2.new(0, 10, 0, 40); scroll.CanvasSize = UDim2.new(0, 0, 3.5, 0); scroll.BackgroundTransparency = 1
    Instance.new("UIGridLayout", scroll).CellSize = UDim2.new(0, 40, 0, 40)

    -- Color Logic
    local colorTarget = "Background"
    for _, col in pairs({Color3.new(1,1,1), Color3.new(0,0,0), Color3.new(1,0,0), Color3.new(0,1,0), Color3.new(0,0,1), Color3.new(1,1,0), Color3.new(1,0,1), Color3.new(0,1,1)}) do
        local b = Instance.new("TextButton", scroll); b.Text = ""; b.BackgroundColor3 = col; b.MouseButton1Click:Connect(function() 
            if colorTarget == "Background" then frame.BackgroundColor3 = col else for _, c in pairs(container:GetChildren()) do if c:IsA("TextButton") or c:IsA("TextBox") then c.BackgroundColor3 = col end end end
            colorGui.Visible = false 
        end)
    end

    -- Logic
    minBtn.MouseButton1Click:Connect(function() minimized = not minimized; container.Visible = not minimized; frame.Size = minimized and UDim2.new(0, 180, 0, 30) or UDim2.new(0, 180, 0, 350); minBtn.Text = minimized and "^" or "v" end)
    bgBtn.MouseButton1Click:Connect(function() colorTarget = "Background"; colorGui.Visible = true end)
    btnBtn.MouseButton1Click:Connect(function() colorTarget = "Buttons"; colorGui.Visible = true end)
    flyBtn.MouseButton1Click:Connect(function() flying = not flying; flyBtn.Text = flying and "Unfly" or "Fly"; if not flying then locked = false; lockBtn.Text = "Lock Fly: OFF" end end)
    lockBtn.MouseButton1Click:Connect(function() if flying then locked = not locked; lockBtn.Text = locked and "Lock Fly: ON" or "Lock Fly: OFF"; if locked then lockedDirection = workspace.CurrentCamera.CFrame.LookVector end end end)
    flingBtn.MouseButton1Click:Connect(function() flinging = not flinging; flingBtn.Text = flinging and "Fling: ON" or "Fling: OFF" end)
    speedBox.FocusLost:Connect(function() speed = math.clamp(tonumber(speedBox.Text) or 50, 1, 10000) end)
    player.CharacterAdded:Connect(function() flying = false; locked = false; flinging = false; flyBtn.Text = "Fly"; lockBtn.Text = "Lock Fly: OFF"; flingBtn.Text = "Fling: OFF" end)

    game:GetService("RunService").RenderStepped:Connect(function()
        -- Fly Logic
        if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local r = player.Character.HumanoidRootPart; if not r:FindFirstChild("FlyBV") then local b = Instance.new("BodyVelocity", r); b.Name="FlyBV"; b.MaxForce=Vector3.new(math.huge,math.huge,math.huge); local g = Instance.new("BodyGyro", r); g.Name="FlyBG"; g.MaxTorque=Vector3.new(math.huge,math.huge,math.huge); g.P=10000 end
            if locked then r.FlyBG.CFrame = CFrame.new(r.Position, r.Position + lockedDirection); r.FlyBV.Velocity = lockedDirection * speed
            else r.FlyBG.CFrame = workspace.CurrentCamera.CFrame; r.FlyBV.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed end
        elseif player.Character and player.Character:FindFirstChild("HumanoidRootPart") then for _,v in pairs(player.Character.HumanoidRootPart:GetChildren()) do if v.Name=="FlyBV" or v.Name=="FlyBG" then v:Destroy() end end end
        
        -- Fling Logic
        if flinging and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 5 then p.Character.HumanoidRootPart.Velocity = Vector3.new(math.random(-500,500), 500, math.random(-500,500)) end
                end
            end
        end
    end)
end
createGUI()
