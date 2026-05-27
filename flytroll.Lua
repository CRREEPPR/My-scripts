-- Fly Troll by Abd55_55 V3.5
local player = game.Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local flying, locked, minimized = false, false, false
local speed = 50
local lockedDirection = Vector3.new(0, 0, 0)

-- Function for dragging frames
local function makeDraggable(frame)
    local dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStart = input.Position; startPos = frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragStart then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function createGUI()
    if guiParent:FindFirstChild("FlyTrollGUI") then guiParent.FlyTrollGUI:Destroy() end
    local screenGui = Instance.new("ScreenGui", guiParent); screenGui.Name = "FlyTrollGUI"; screenGui.ResetOnSpawn = false
    
    -- Main Window
    local frame = Instance.new("Frame", screenGui); frame.Size = UDim2.new(0, 180, 0, 300); frame.Position = UDim2.new(0.1, 0, 0.1, 0); frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); makeDraggable(frame)
    local title = Instance.new("TextLabel", frame); title.Text = "Fly troll by abd55_55 V3.5"; title.Size = UDim2.new(1, 0, 0, 30); title.TextColor3 = Color3.new(1,1,1); title.BackgroundTransparency = 1
    
    -- Main Controls
    local container = Instance.new("Frame", frame); container.Size = UDim2.new(1, 0, 1, -30); container.Position = UDim2.new(0, 0, 0, 30); container.BackgroundTransparency = 1
    local flyBtn = Instance.new("TextButton", container); flyBtn.Text = "Fly"; flyBtn.Size = UDim2.new(0.9, 0, 0, 40); flyBtn.Position = UDim2.new(0.05, 0, 0, 10)
    local lockBtn = Instance.new("TextButton", container); lockBtn.Text = "Lock Fly: OFF"; lockBtn.Size = UDim2.new(0.9, 0, 0, 40); lockBtn.Position = UDim2.new(0.05, 0, 0, 60)
    local bgBtn = Instance.new("TextButton", container); bgBtn.Text = "Background Color"; bgBtn.Size = UDim2.new(0.9, 0, 0, 40); bgBtn.Position = UDim2.new(0.05, 0, 0, 110)
    local btnBtn = Instance.new("TextButton", container); btnBtn.Text = "Button Color"; btnBtn.Size = UDim2.new(0.9, 0, 0, 40); btnBtn.Position = UDim2.new(0.05, 0, 0, 160)
    local speedBox = Instance.new("TextBox", container); speedBox.PlaceholderText = "Speed (Default: 50)"; speedBox.Size = UDim2.new(0.9, 0, 0, 40); speedBox.Position = UDim2.new(0.05, 0, 0, 210)

    -- Color Changer Menu
    local colorGui = Instance.new("Frame", screenGui); colorGui.Size = UDim2.new(0, 160, 0, 240); colorGui.Position = UDim2.new(0.3, 0, 0.1, 0); colorGui.Visible = false; colorGui.BackgroundColor3 = Color3.fromRGB(150, 150, 150); makeDraggable(colorGui)
    local colorTitle = Instance.new("TextLabel", colorGui); colorTitle.Text = "color changer"; colorTitle.Size = UDim2.new(0.7, 0, 0, 30); colorTitle.Position = UDim2.new(0, 5, 0, 5); colorTitle.BackgroundColor3 = Color3.fromRGB(100,100,100)
    local xBtn = Instance.new("TextButton", colorGui); xBtn.Text = "X"; xBtn.Size = UDim2.new(0, 30, 0, 30); xBtn.Position = UDim2.new(1, -35, 0, 5); xBtn.TextColor3 = Color3.new(1,0,0); xBtn.BackgroundTransparency = 1; xBtn.MouseButton1Click:Connect(function() colorGui.Visible = false end)
    
    local scroll = Instance.new("ScrollingFrame", colorGui); scroll.Size = UDim2.new(1, -20, 1, -50); scroll.Position = UDim2.new(0, 10, 0, 40); scroll.CanvasSize = UDim2.new(0, 0, 2, 0); scroll.BackgroundTransparency = 1
    local grid = Instance.new("UIGridLayout", scroll); grid.CellSize = UDim2.new(0, 40, 0, 40); grid.CellPadding = UDim2.new(0, 5, 0, 5); grid.FillDirectionMaxCells = 3

    local colorTarget = "Background"
    local colors = {Color3.new(1,1,1), Color3.new(0,0,1), Color3.fromRGB(255,165,0), Color3.new(1,1,0), Color3.new(1,0,0), Color3.new(0,1,0), Color3.new(0,0,0), Color3.fromRGB(0,255,255), Color3.fromRGB(255,105,180), Color3.fromRGB(128,0,128)}
    for _, col in pairs(colors) do
        local b = Instance.new("TextButton", scroll); b.Text = ""; b.BackgroundColor3 = col; b.MouseButton1Click:Connect(function() 
            if colorTarget == "Background" then frame.BackgroundColor3 = col else for _, c in pairs(container:GetChildren()) do if c:IsA("TextButton") or c:IsA("TextBox") then c.BackgroundColor3 = col end end end
            colorGui.Visible = false 
        end)
    end

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
        end
    end)

    game:GetService("RunService").RenderStepped:Connect(function()
        if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            if locked then root.FlyBV.Velocity = lockedDirection * speed
            else root.FlyBG.CFrame = workspace.CurrentCamera.CFrame; root.FlyBV.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed end
        end
    end)
end
createGUI()
