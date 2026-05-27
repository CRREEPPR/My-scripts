-- Fly Troll V3.2 (Universal Compatibility)
local player = game.Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
local flying, locked, minimized = false, false, false
local speed = 50
local lockedDirection = Vector3.new(0, 0, 0)
local currentRainbowTarget = nil 

local function makeDraggable(frame)
    local dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragStart = nil end end)
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragStart then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function createGUI()
    local screenGui = Instance.new("ScreenGui", guiParent)
    screenGui.Name = "FlyTrollGUI"
    
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 180, 0, 270); frame.Position = UDim2.new(0.1, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); makeDraggable(frame)

    local container = Instance.new("Frame", frame); container.Size = UDim2.new(1, 0, 1, -30); container.Position = UDim2.new(0, 0, 0, 30); container.BackgroundTransparency = 1

    local colorGui = Instance.new("Frame", screenGui); colorGui.Size = UDim2.new(0, 160, 0, 210); colorGui.Position = UDim2.new(0.3, 0, 0.1, 0); colorGui.Visible = false; colorGui.BackgroundColor3 = Color3.fromRGB(150, 150, 150); makeDraggable(colorGui)
    
    local scroll = Instance.new("ScrollingFrame", colorGui); scroll.Size = UDim2.new(1, -20, 1, -40); scroll.Position = UDim2.new(0, 10, 0, 40); scroll.CanvasSize = UDim2.new(0, 0, 2, 0); scroll.BackgroundTransparency = 1
    local grid = Instance.new("UIGridLayout", scroll); grid.CellSize = UDim2.new(0, 40, 0, 40); grid.CellPadding = UDim2.new(0, 5, 0, 5); grid.FillDirectionMaxCells = 3

    local colorTarget = "Background"
    local colors = {Color3.new(1,1,1), Color3.new(0,0,1), Color3.fromRGB(255,165,0), Color3.new(1,1,0), Color3.new(1,0,0), Color3.new(0,1,0), Color3.new(0,0,0), Color3.fromRGB(0,255,255), Color3.fromRGB(255,105,180), Color3.fromRGB(128,0,128)}
    
    local rBtn = Instance.new("TextButton", scroll); rBtn.Text = "R"; rBtn.Size = UDim2.new(0,40,0,40); rBtn.BackgroundColor3 = Color3.new(1,1,1); rBtn.MouseButton1Click:Connect(function() currentRainbowTarget = colorTarget; colorGui.Visible = false end)
    
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

    local flyBtn = Instance.new("TextButton", container); flyBtn.Text = "Fly"; flyBtn.Size = UDim2.new(1, 0, 0, 30)
    local lockBtn = Instance.new("TextButton", container); lockBtn.Text = "Lock Fly: OFF"; lockBtn.Size = UDim2.new(1, 0, 0, 30); lockBtn.Position = UDim2.new(0,0,0.15,0)
    local bgBtn = Instance.new("TextButton", container); bgBtn.Text = "Background Color"; bgBtn.Size = UDim2.new(1, 0, 0, 30); bgBtn.Position = UDim2.new(0,0,0.3,0)
    local btnBtn = Instance.new("TextButton", container); btnBtn.Text = "Button Color"; btnBtn.Size = UDim2.new(1, 0, 0, 30); btnBtn.Position = UDim2.new(0,0,0.45,0)
    local speedBox = Instance.new("TextBox", container); speedBox.PlaceholderText = "Speed (1-1000)"; speedBox.Size = UDim2.new(1, 0, 0, 30); speedBox.Position = UDim2.new(0,0,0.6,0)

    bgBtn.MouseButton1Click:Connect(function() colorTarget = "Background"; colorGui.Visible = true end)
    btnBtn.MouseButton1Click:Connect(function() colorTarget = "Buttons"; colorGui.Visible = true end)
    lockBtn.MouseButton1Click:Connect(function() locked = not locked; lockBtn.Text = locked and "Lock Fly: ON" or "Lock Fly: OFF"; if locked then lockedDirection = workspace.CurrentCamera.CFrame.LookVector end end)
    speedBox.FocusLost:Connect(function() speed = tonumber(speedBox.Text) or 50 end)

    flyBtn.MouseButton1Click:Connect(function()
        flying = not flying; flyBtn.Text = flying and "Unfly" or "Fly"
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if flying and root then
            local bv = Instance.new("BodyVelocity", root); bv.Name = "FlyBV"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            local bg = Instance.new("BodyGyro", root); bg.Name = "FlyBG"; bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); bg.P = 10000
        else
            if root then for _,v in pairs(root:GetChildren()) do if v.Name == "FlyBV" or v.Name == "FlyBG" then v:Destroy() end end end
            locked = false; lockBtn.Text = "Lock Fly: OFF"
        end
    end)

    game:GetService("RunService").RenderStepped:Connect(function()
        if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if locked then player.Character.HumanoidRootPart.FlyBV.Velocity = lockedDirection * speed
            else player.Character.HumanoidRootPart.FlyBG.CFrame = workspace.CurrentCamera.CFrame; player.Character.HumanoidRootPart.FlyBV.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed end
        end
    end)
end
createGUI()
