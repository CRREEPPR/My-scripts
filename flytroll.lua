-- Fly Troll by Abd55_55 V5.16
local player = game.Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local flying, locked, minimized, frozen, noclip = false, false, false, false, false
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
    
    local frame = Instance.new("Frame", screenGui); frame.Size = UDim2.new(0, 180, 0, 420); frame.Position = UDim2.new(0.1, 0, 0.1, 0); frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); makeDraggable(frame)
    local title = Instance.new("TextLabel", frame); title.Text = "Fly troll V5.16"; title.Size = UDim2.new(0.8, 0, 0, 30); title.TextColor3 = Color3.new(1,1,1); title.BackgroundTransparency = 1; title.Font = Enum.Font.SourceSansBold
    local minBtn = Instance.new("TextButton", frame); minBtn.Text = "v"; minBtn.Size = UDim2.new(0.2, 0, 0, 30); minBtn.Position = UDim2.new(0.8, 0, 0, 0); minBtn.BackgroundTransparency = 1; minBtn.TextColor3 = Color3.new(1,1,1)
    
    local container = Instance.new("ScrollingFrame", frame); container.Size = UDim2.new(1, 0, 1, -30); container.Position = UDim2.new(0, 0, 0, 30); container.BackgroundTransparency = 1; container.CanvasSize = UDim2.new(0,0,2.3,0); container.ScrollBarThickness = 4
    local layout = Instance.new("UIListLayout", container); layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; layout.Padding = UDim.new(0, 8); layout.SortOrder = Enum.SortOrder.LayoutOrder

    local flyBtn = Instance.new("TextButton", container); flyBtn.Text = "Fly"; flyBtn.Size = UDim2.new(0.9, 0, 0, 40); flyBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); flyBtn.TextColor3 = Color3.new(1,1,1); flyBtn.LayoutOrder = 1
    local lockBtn = Instance.new("TextButton", container); lockBtn.Text = "Lock Fly: OFF"; lockBtn.Size = UDim2.new(0.9, 0, 0, 40); lockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); lockBtn.TextColor3 = Color3.new(1,1,1); lockBtn.LayoutOrder = 2
    local freezeBtn = Instance.new("TextButton", container); freezeBtn.Text = "Freeze: OFF"; freezeBtn.Size = UDim2.new(0.9, 0, 0, 40); freezeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); freezeBtn.TextColor3 = Color3.new(1,1,1); freezeBtn.LayoutOrder = 3
    local noclipBtn = Instance.new("TextButton", container); noclipBtn.Text = "Noclip: OFF"; noclipBtn.Size = UDim2.new(0.9, 0, 0, 40); noclipBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); noclipBtn.TextColor3 = Color3.new(1,1,1); noclipBtn.LayoutOrder = 4
    local flingBtn = Instance.new("TextButton", container); flingBtn.Text = "Fling"; flingBtn.Size = UDim2.new(0.9, 0, 0, 40); flingBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); flingBtn.TextColor3 = Color3.new(1,1,1); flingBtn.LayoutOrder = 5
    local speedBox = Instance.new("TextBox", container); speedBox.Text = "50"; speedBox.PlaceholderText = "Speed (1-10000)"; speedBox.Size = UDim2.new(0.9, 0, 0, 40); speedBox.BackgroundColor3 = Color3.fromRGB(50,50,50); speedBox.TextColor3 = Color3.new(1,1,1); speedBox.LayoutOrder = 6
    local bgBtn = Instance.new("TextButton", container); bgBtn.Text = "Background Color"; bgBtn.Size = UDim2.new(0.9, 0, 0, 40); bgBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); bgBtn.TextColor3 = Color3.new(1,1,1); bgBtn.LayoutOrder = 7
    local btnBtn = Instance.new("TextButton", container); btnBtn.Text = "Buttons Color"; btnBtn.Size = UDim2.new(0.9, 0, 0, 40); btnBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); btnBtn.TextColor3 = Color3.new(1,1,1); btnBtn.LayoutOrder = 8
    local txtBtn = Instance.new("TextButton", container); txtBtn.Text = "Text Color"; txtBtn.Size = UDim2.new(0.9, 0, 0, 40); txtBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); txtBtn.TextColor3 = Color3.new(1,1,1); txtBtn.LayoutOrder = 9

    -- Color GUI Setup
    local colorGui = Instance.new("Frame", screenGui); colorGui.Size = UDim2.new(0, 180, 0, 250); colorGui.Position = UDim2.new(0.3, 0, 0.1, 0); colorGui.Visible = false; colorGui.BackgroundColor3 = Color3.fromRGB(30, 30, 30); makeDraggable(colorGui)
    local xBtn = Instance.new("TextButton", colorGui); xBtn.Text = "X"; xBtn.Size = UDim2.new(0, 30, 0, 30); xBtn.Position = UDim2.new(1, -30, 0, 0); xBtn.TextColor3 = Color3.new(1,0,0); xBtn.BackgroundTransparency = 1; xBtn.MouseButton1Click:Connect(function() colorGui.Visible = false end)
    local colorScroll = Instance.new("ScrollingFrame", colorGui); colorScroll.Size = UDim2.new(1, -10, 1, -40); colorScroll.Position = UDim2.new(0, 5, 0, 35); colorScroll.CanvasSize = UDim2.new(0, 0, 5, 0); colorScroll.BackgroundTransparency = 1; colorScroll.ScrollBarThickness = 4
    Instance.new("UIGridLayout", colorScroll).CellSize = UDim2.new(0, 38, 0, 38)
    
    local colorPalette = {
        Color3.new(1,1,1), Color3.new(0,0,0), Color3.new(0.5,0.5,0.5), Color3.new(0.2,0.2,0.2), Color3.new(1,0,0), 
        Color3.new(0,1,0), Color3.new(0,0,1), Color3.new(1,1,0), Color3.new(1,0,1), Color3.new(0,1,1),
        Color3.fromRGB(255,165,0), Color3.fromRGB(128,0,128), Color3.fromRGB(255,105,180), Color3.fromRGB(0,255,127), Color3.fromRGB(135,206,235),
        Color3.fromRGB(255,69,0), Color3.fromRGB(75,0,130), Color3.fromRGB(240,230,140), Color3.fromRGB(46,139,87), Color3.fromRGB(220,20,60),
        Color3.fromRGB(255,215,0), Color3.fromRGB(0,191,255), Color3.fromRGB(154,205,50), Color3.fromRGB(218,112,214), Color3.fromRGB(255,127,80),
        Color3.fromRGB(0,0,139), Color3.fromRGB(139,0,0), Color3.fromRGB(0,100,0), Color3.fromRGB(255,255,240), Color3.fromRGB(250,235,215),
        Color3.fromRGB(173,216,230), Color3.fromRGB(255,182,193), Color3.fromRGB(144,238,144), Color3.fromRGB(255,250,205), Color3.fromRGB(230,230,250),
        Color3.fromRGB(255,0,255), Color3.fromRGB(0,255,0), Color3.fromRGB(0,255,255), Color3.fromRGB(255,255,0), Color3.fromRGB(192,192,192)
    }
    
    local function updateAllText(col)
        for _, obj in pairs(screenGui:GetDescendants()) do if (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) and obj ~= xBtn then obj.TextColor3 = col end end
    end

    for _, col in pairs(colorPalette) do
        local b = Instance.new("TextButton", colorScroll); b.Text = ""; b.BackgroundColor3 = col; b.MouseButton1Click:Connect(function() 
            if colorTarget == "Background" then frame.BackgroundColor3 = col; colorGui.BackgroundColor3 = col
            elseif colorTarget == "Buttons" then for _, c in pairs(container:GetChildren()) do if c:IsA("TextButton") or c:IsA("TextBox") then c.BackgroundColor3 = col end end
            elseif colorTarget == "Text" then updateAllText(col) end
            colorGui.Visible = false 
        end)
    end

    -- Button Logic
    minBtn.MouseButton1Click:Connect(function() minimized = not minimized; container.Visible = not minimized; frame.Size = minimized and UDim2.new(0, 180, 0, 30) or UDim2.new(0, 180, 0, 420); minBtn.Text = minimized and "^" or "v" end)
    bgBtn.MouseButton1Click:Connect(function() colorTarget = "Background"; colorGui.Visible = true end)
    btnBtn.MouseButton1Click:Connect(function() colorTarget = "Buttons"; colorGui.Visible = true end)
    txtBtn.MouseButton1Click:Connect(function() colorTarget = "Text"; colorGui.Visible = true end)
    
    flyBtn.MouseButton1Click:Connect(function() flying = not flying; flyBtn.Text = flying and "Unfly" or "Fly"; if not flying then locked = false; lockBtn.Text = "Lock Fly: OFF" end end)
    lockBtn.MouseButton1Click:Connect(function() if flying then locked = not locked; lockBtn.Text = locked and "Lock Fly: ON" or "Lock Fly: OFF"; if locked then lockedDirection = workspace.CurrentCamera.CFrame.LookVector end end end)
    freezeBtn.MouseButton1Click:Connect(function() frozen = not frozen; freezeBtn.Text = frozen and "Freeze: ON" or "Freeze: OFF"; if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.Anchored = frozen end end)
    noclipBtn.MouseButton1Click:Connect(function()
        noclip = not noclip; noclipBtn.Text = noclip and "Noclip: ON" or "Noclip: OFF"
        if not noclip and player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end
        end
    end)
    
    flingBtn.MouseButton1Click:Connect(function()
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if root and hum then
            hum.PlatformStand = true
            local bv = Instance.new("BodyVelocity", root)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            -- Weak fling values (100 to 500)
            bv.Velocity = Vector3.new(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500))
            task.wait(0.5)
            hum.PlatformStand = false
            bv:Destroy()
        end
    end)
    
    speedBox.FocusLost:Connect(function() speed = math.clamp(tonumber(speedBox.Text) or 50, 1, 10000) end)
    player.CharacterAdded:Connect(function() flying = false; locked = false; frozen = false; noclip = false; flyBtn.Text = "Fly"; lockBtn.Text = "Lock Fly: OFF"; freezeBtn.Text = "Freeze: OFF"; noclipBtn.Text = "Noclip: OFF" end)

    RS.RenderStepped:Connect(function()
        if noclip and player.Character then for _, part in pairs(player.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end end
        if flying and not frozen and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local r = player.Character.HumanoidRootPart; if not r:FindFirstChild("FlyBV") then local b = Instance.new("BodyVelocity", r); b.Name="FlyBV"; b.MaxForce=Vector3.new(math.huge,math.huge,math.huge); local g = Instance.new("BodyGyro", r); g.Name="FlyBG"; g.MaxTorque=Vector3.new(math.huge,math.huge,math.huge); g.P=10000 end
            if locked then r.FlyBG.CFrame = CFrame.new(r.Position, r.Position + lockedDirection); r.FlyBV.Velocity = lockedDirection * speed
            else r.FlyBG.CFrame = workspace.CurrentCamera.CFrame; r.FlyBV.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed end
        elseif player.Character and player.Character:FindFirstChild("HumanoidRootPart") then for _,v in pairs(player.Character.HumanoidRootPart:GetChildren()) do if v.Name=="FlyBV" or v.Name=="FlyBG" then v:Destroy() end end end
    end)
end
createGUI()
