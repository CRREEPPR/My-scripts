-- Fly Troll by Abd55_55 V5.11
local player = game.Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local cam = workspace.CurrentCamera

local flying, locked, minimized, freecam = false, false, false, false
local speed = 50
local lockedDirection = Vector3.new(0, 0, 0)
local camPos = CFrame.new()

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
    
    local frame = Instance.new("Frame", screenGui); frame.Size = UDim2.new(0, 180, 0, 300); frame.Position = UDim2.new(0.1, 0, 0.1, 0); frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); makeDraggable(frame)
    local title = Instance.new("TextLabel", frame); title.Text = "Fly troll V5.11"; title.Size = UDim2.new(0.8, 0, 0, 30); title.TextColor3 = Color3.new(1,1,1); title.BackgroundTransparency = 1; title.Font = Enum.Font.SourceSansBold
    local minBtn = Instance.new("TextButton", frame); minBtn.Text = "v"; minBtn.Size = UDim2.new(0.2, 0, 0, 30); minBtn.Position = UDim2.new(0.8, 0, 0, 0); minBtn.BackgroundTransparency = 1; minBtn.TextColor3 = Color3.new(1,1,1)
    
    local container = Instance.new("ScrollingFrame", frame); container.Size = UDim2.new(1, 0, 1, -30); container.Position = UDim2.new(0, 0, 0, 30); container.BackgroundTransparency = 1; container.CanvasSize = UDim2.new(0,0,1.7,0); container.ScrollBarThickness = 4
    local layout = Instance.new("UIListLayout", container); layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; layout.Padding = UDim.new(0, 8); layout.SortOrder = Enum.SortOrder.LayoutOrder

    local flyBtn = Instance.new("TextButton", container); flyBtn.Text = "Fly"; flyBtn.Size = UDim2.new(0.9, 0, 0, 40); flyBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); flyBtn.TextColor3 = Color3.new(1,1,1); flyBtn.LayoutOrder = 1
    local lockBtn = Instance.new("TextButton", container); lockBtn.Text = "Lock Fly: OFF"; lockBtn.Size = UDim2.new(0.9, 0, 0, 40); lockBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); lockBtn.TextColor3 = Color3.new(1,1,1); lockBtn.LayoutOrder = 2
    local camBtn = Instance.new("TextButton", container); camBtn.Text = "FreeCam: OFF"; camBtn.Size = UDim2.new(0.9, 0, 0, 40); camBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); camBtn.TextColor3 = Color3.new(1,1,1); camBtn.LayoutOrder = 3
    local speedBox = Instance.new("TextBox", container); speedBox.Text = "50"; speedBox.PlaceholderText = "Speed"; speedBox.Size = UDim2.new(0.9, 0, 0, 40); speedBox.BackgroundColor3 = Color3.fromRGB(50,50,50); speedBox.TextColor3 = Color3.new(1,1,1); speedBox.LayoutOrder = 4
    local bgBtn = Instance.new("TextButton", container); bgBtn.Text = "Background Color"; bgBtn.Size = UDim2.new(0.9, 0, 0, 40); bgBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); bgBtn.TextColor3 = Color3.new(1,1,1); bgBtn.LayoutOrder = 5
    local btnBtn = Instance.new("TextButton", container); btnBtn.Text = "Buttons Color"; btnBtn.Size = UDim2.new(0.9, 0, 0, 40); btnBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); btnBtn.TextColor3 = Color3.new(1,1,1); btnBtn.LayoutOrder = 6
    local txtBtn = Instance.new("TextButton", container); txtBtn.Text = "Text Color"; txtBtn.Size = UDim2.new(0.9, 0, 0, 40); txtBtn.BackgroundColor3 = Color3.fromRGB(50,50,50); txtBtn.TextColor3 = Color3.new(1,1,1); txtBtn.LayoutOrder = 7

    -- Color UI setup
    local colorGui = Instance.new("Frame", screenGui); colorGui.Size = UDim2.new(0, 180, 0, 250); colorGui.Position = UDim2.new(0.3, 0, 0.1, 0); colorGui.Visible = false; colorGui.BackgroundColor3 = Color3.fromRGB(30, 30, 30); makeDraggable(colorGui)
    local xBtn = Instance.new("TextButton", colorGui); xBtn.Text = "X"; xBtn.Size = UDim2.new(0, 30, 0, 30); xBtn.Position = UDim2.new(1, -30, 0, 0); xBtn.TextColor3 = Color3.new(1,0,0); xBtn.BackgroundTransparency = 1; xBtn.MouseButton1Click:Connect(function() colorGui.Visible = false end)
    local colorScroll = Instance.new("ScrollingFrame", colorGui); colorScroll.Size = UDim2.new(1, -10, 1, -40); colorScroll.Position = UDim2.new(0, 5, 0, 35); colorScroll.CanvasSize = UDim2.new(0, 0, 5, 0); colorScroll.BackgroundTransparency = 1; colorScroll.ScrollBarThickness = 4
    Instance.new("UIGridLayout", colorScroll).CellSize = UDim2.new(0, 38, 0, 38)
    local colorPalette = {Color3.new(1,1,1), Color3.new(0,0,0), Color3.new(1,0,0), Color3.new(0,1,0), Color3.new(0,0,1), Color3.new(1,1,0), Color3.new(1,0,1), Color3.new(0,1,1), Color3.fromRGB(255,165,0), Color3.fromRGB(128,0,128)}
    
    for _, col in pairs(colorPalette) do
        local b = Instance.new("TextButton", colorScroll); b.Text = ""; b.BackgroundColor3 = col; b.MouseButton1Click:Connect(function() 
            -- Color Logic remains same...
            colorGui.Visible = false 
        end)
    end

    -- Button Logic
    minBtn.MouseButton1Click:Connect(function() minimized = not minimized; container.Visible = not minimized; frame.Size = minimized and UDim2.new(0, 180, 0, 30) or UDim2.new(0, 180, 0, 300); minBtn.Text = minimized and "^" or "v" end)
    flyBtn.MouseButton1Click:Connect(function() flying = not flying; flyBtn.Text = flying and "Unfly" or "Fly" end)
    lockBtn.MouseButton1Click:Connect(function() if flying then locked = not locked; lockBtn.Text = locked and "Lock Fly: ON" or "Lock Fly: OFF"; if locked then lockedDirection = cam.CFrame.LookVector end end end)
    
    camBtn.MouseButton1Click:Connect(function()
        freecam = not freecam; camBtn.Text = freecam and "FreeCam: ON" or "FreeCam: OFF"
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if freecam then
            camPos = cam.CFrame; cam.CameraType = Enum.CameraType.Scriptable
            if root then root.Anchored = true end
        else
            cam.CameraType = Enum.CameraType.Custom
            if root then root.Anchored = false end
        end
    end)
    
    speedBox.FocusLost:Connect(function() speed = math.clamp(tonumber(speedBox.Text) or 50, 1, 10000) end)

    RS.RenderStepped:Connect(function(dt)
        if freecam then
            local move = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
            camPos = camPos + (move * speed * dt)
            cam.CFrame = CFrame.new(camPos.Position, camPos.Position + cam.CFrame.LookVector)
        elseif flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Fly logic remains...
        end
    end)
end
createGUI()
