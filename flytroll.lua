-- Fly Troll by Abd55_55 V5.22
local player = game.Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local flying, locked, minimized, frozen, noclip = false, false, false, false, false
local speed = 50
local lockedDirection = Vector3.new(0, 0, 0)

-- Drag Logic
local function makeDraggable(frame)
    local dragToggle, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = true; dragStart = input.Position; startPos = frame.Position end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = false end end)
end

-- GUI Setup
local function createGUI()
    if guiParent:FindFirstChild("FlyTrollGUI") then guiParent.FlyTrollGUI:Destroy() end
    local screenGui = Instance.new("ScreenGui", guiParent); screenGui.Name = "FlyTrollGUI"; screenGui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame", screenGui); frame.Size = UDim2.new(0, 180, 0, 320); frame.Position = UDim2.new(0.1, 0, 0.1, 0); frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40); makeDraggable(frame)
    local title = Instance.new("TextLabel", frame); title.Text = "fly troll by abd55_55 V5.22"; title.Size = UDim2.new(0.8, 0, 0, 30); title.TextColor3 = Color3.new(1,1,1); title.BackgroundTransparency = 1; title.Font = Enum.Font.SourceSansBold
    local minBtn = Instance.new("TextButton", frame); minBtn.Text = "v"; minBtn.Size = UDim2.new(0.2, 0, 0, 30); minBtn.Position = UDim2.new(0.8, 0, 0, 0); minBtn.BackgroundTransparency = 1; minBtn.TextColor3 = Color3.new(1,1,1)
    
    local container = Instance.new("ScrollingFrame", frame); container.Size = UDim2.new(1, 0, 1, -30); container.Position = UDim2.new(0, 0, 0, 30); container.BackgroundTransparency = 1; container.CanvasSize = UDim2.new(0,0,2.0,0); container.ScrollBarThickness = 4
    local layout = Instance.new("UIListLayout", container); layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; layout.Padding = UDim.new(0, 5)

    local function newBtn(name) local b = Instance.new("TextButton", container); b.Text = name; b.Size = UDim2.new(0.9, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(60,60,60); b.TextColor3 = Color3.new(1,1,1); return b end
    
    local flyBtn = newBtn("Fly"); local lockBtn = newBtn("Lock Fly: OFF"); local freezeBtn = newBtn("Freeze: OFF"); local noclipBtn = newBtn("Noclip: OFF")
    local speedBox = Instance.new("TextBox", container); speedBox.Text = "50"; speedBox.PlaceholderText = "Fly Speed"; speedBox.Size = UDim2.new(0.9, 0, 0, 35); speedBox.BackgroundColor3 = Color3.fromRGB(60,60,60); speedBox.TextColor3 = Color3.new(1,1,1)
    local bgBtn = newBtn("Background Color"); local btnBtn = newBtn("Buttons Color"); local txtBtn = newBtn("Text Color")

    local colorGui = Instance.new("Frame", screenGui); colorGui.Size = UDim2.new(0, 200, 0, 200); colorGui.Position = UDim2.new(0.3, 0, 0.1, 0); colorGui.Visible = false; colorGui.BackgroundColor3 = Color3.fromRGB(40, 40, 40); makeDraggable(colorGui)
    local xBtn = Instance.new("TextButton", colorGui); xBtn.Text = "X"; xBtn.Size = UDim2.new(0, 30, 0, 30); xBtn.Position = UDim2.new(1, -30, 0, 0); xBtn.BackgroundTransparency = 1; xBtn.TextColor3 = Color3.new(1,0,0); xBtn.MouseButton1Click:Connect(function() colorGui.Visible = false end)
    local colorScroll = Instance.new("ScrollingFrame", colorGui); colorScroll.Size = UDim2.new(1, 0, 1, -30); colorScroll.Position = UDim2.new(0, 0, 0, 30); colorScroll.BackgroundTransparency = 1; Instance.new("UIGridLayout", colorScroll).CellSize = UDim2.new(0, 35, 0, 35)
    
    local colorPalette = {Color3.fromRGB(20,20,20), Color3.fromRGB(40,40,40), Color3.fromRGB(60,60,60), Color3.fromRGB(80,80,80), Color3.fromRGB(100,100,100), Color3.fromRGB(120,120,120), Color3.fromRGB(140,140,140), Color3.fromRGB(160,160,160), Color3.fromRGB(180,180,180), Color3.fromRGB(200,200,200), Color3.new(1,0,0), Color3.new(0,1,0), Color3.new(0,0,1), Color3.new(1,1,0), Color3.new(1,0,1), Color3.new(0,1,1), Color3.new(1,1,1), Color3.new(0,0,0), Color3.fromRGB(255,165,0), Color3.fromRGB(128,0,128), Color3.fromRGB(255,20,147), Color3.fromRGB(0,255,127), Color3.fromRGB(135,206,235), Color3.fromRGB(255,69,0), Color3.fromRGB(75,0,130), Color3.fromRGB(240,230,140), Color3.fromRGB(46,139,87), Color3.fromRGB(220,20,60), Color3.fromRGB(255,215,0), Color3.fromRGB(0,191,255), Color3.fromRGB(154,205,50), Color3.fromRGB(218,112,214), Color3.fromRGB(255,127,80), Color3.fromRGB(0,0,139), Color3.fromRGB(139,0,0), Color3.fromRGB(0,100,0), Color3.fromRGB(255,250,205), Color3.fromRGB(230,230,250), Color3.fromRGB(255,0,255), Color3.fromRGB(192,192,192)}
    
    for _, col in pairs(colorPalette) do
        local b = Instance.new("TextButton", colorScroll); b.Text = ""; b.BackgroundColor3 = col; b.MouseButton1Click:Connect(function()
            if colorTarget == "Background" then frame.BackgroundColor3 = col; colorGui.BackgroundColor3 = col
            elseif colorTarget == "Buttons" then for _,c in pairs(container:GetChildren()) do if c:IsA("TextButton") or c:IsA("TextBox") then c.BackgroundColor3 = col end end
            else for _,o in pairs(frame:GetDescendants()) do if o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") then o.TextColor3 = col end end end
        end)
    end

    minBtn.MouseButton1Click:Connect(function() minimized = not minimized; container.Visible = not minimized; frame.Size = minimized and UDim2.new(0, 180, 0, 30) or UDim2.new(0, 180, 0, 320); minBtn.Text = minimized and "^" or "v" end)
    bgBtn.MouseButton1Click:Connect(function() colorTarget = "Background"; colorGui.Visible = true end)
    btnBtn.MouseButton1Click:Connect(function() colorTarget = "Buttons"; colorGui.Visible = true end)
    txtBtn.MouseButton1Click:Connect(function() colorTarget = "Text"; colorGui.Visible = true end)
    
    flyBtn.MouseButton1Click:Connect(function() flying = not flying; flyBtn.Text = flying and "Unfly" or "Fly" end)
    lockBtn.MouseButton1Click:Connect(function() locked = not locked; lockBtn.Text = locked and "Lock: ON" or "Lock: OFF"; if locked then lockedDirection = workspace.CurrentCamera.CFrame.LookVector end end)
    freezeBtn.MouseButton1Click:Connect(function() frozen = not frozen; freezeBtn.Text = frozen and "Freeze: ON" or "Freeze: OFF"; if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.Anchored = frozen end end)
    noclipBtn.MouseButton1Click:Connect(function() 
        noclip = not noclip; noclipBtn.Text = noclip and "Noclip: ON" or "Noclip: OFF"
        if not noclip and player.Character then 
            for _,p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end 
        end
    end)
    
    speedBox.FocusLost:Connect(function() speed = tonumber(speedBox.Text) or 50 end)
    
    RS.RenderStepped:Connect(function()
        if noclip and player.Character then for _,p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        if flying and not frozen and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local r = player.Character.HumanoidRootPart
            if not r:FindFirstChild("FlyBV") then local b = Instance.new("BodyVelocity", r); b.Name="FlyBV"; b.MaxForce=Vector3.new(9e9,9e9,9e9); local g = Instance.new("BodyGyro", r); g.Name="FlyBG"; g.MaxTorque=Vector3.new(9e9,9e9,9e9) end
            local cam = workspace.CurrentCamera.CFrame
            r.FlyBG.CFrame = locked and CFrame.new(r.Position, r.Position + lockedDirection) or cam
            r.FlyBV.Velocity = (locked and lockedDirection or cam.LookVector) * speed
        elseif player.Character and player.Character:FindFirstChild("HumanoidRootPart") then for _,v in pairs(player.Character.HumanoidRootPart:GetChildren()) do if v.Name=="FlyBV" or v.Name=="FlyBG" then v:Destroy() end end end
    end)
end
createGUI()
