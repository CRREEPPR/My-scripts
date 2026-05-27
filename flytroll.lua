-- Fly Troll by Abd55_55 V5.31
local player = game.Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local flying, locked, minimized, frozen, noclip, infJump = false, false, false, false, false, false
local flySpeed, walkSpeed, jumpPower = 50, 16, 50
local lockedDirection = Vector3.new(0, 0, 0)
local colorTarget = ""

-- Helper: Draggable UI
local function makeDraggable(frame)
    local dragToggle, dragStart, startPos
    frame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = true; dragStart = input.Position; startPos = frame.Position end end)
    UIS.InputChanged:Connect(function(input) if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = false end end)
end

-- Inf Jump Logic
UIS.JumpRequest:Connect(function()
    if infJump and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local function createGUI()
    if guiParent:FindFirstChild("FlyTrollGUI") then guiParent.FlyTrollGUI:Destroy() end
    local screenGui = Instance.new("ScreenGui", guiParent); screenGui.Name = "FlyTrollGUI"; screenGui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame", screenGui); frame.Size = UDim2.new(0, 180, 0, 400); frame.Position = UDim2.new(0.1, 0, 0.1, 0); frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40); makeDraggable(frame)
    local title = Instance.new("TextLabel", frame); title.Text = "fly troll V5.31"; title.Size = UDim2.new(0.8, 0, 0, 30); title.TextColor3 = Color3.new(1,1,1); title.BackgroundTransparency = 1
    local minBtn = Instance.new("TextButton", frame); minBtn.Text = "v"; minBtn.Size = UDim2.new(0.2, 0, 0, 30); minBtn.Position = UDim2.new(0.8, 0, 0, 0); minBtn.BackgroundTransparency = 1; minBtn.TextColor3 = Color3.new(1,1,1)
    
    local container = Instance.new("ScrollingFrame", frame); container.Size = UDim2.new(1, 0, 1, -30); container.Position = UDim2.new(0, 0, 0, 30); container.BackgroundTransparency = 1; container.CanvasSize = UDim2.new(0,0,3,0); Instance.new("UIListLayout", container).Padding = UDim.new(0, 5)

    local function newBtn(name) local b = Instance.new("TextButton", container); b.Text = name; b.Size = UDim2.new(0.9, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(60,60,60); b.TextColor3 = Color3.new(1,1,1); b.Parent = container; return b end
    
    local flyBtn = newBtn("Fly"); local lockBtn = newBtn("Lock Fly: OFF"); local noclipBtn = newBtn("Noclip: OFF"); local freezeBtn = newBtn("Freeze: OFF"); local infBtn = newBtn("Inf Jump: OFF"); local settingsBtn = newBtn("Settings")
    
    -- Settings UI
    local sGui = Instance.new("Frame", screenGui); sGui.Size = UDim2.new(0, 250, 0, 350); sGui.Visible = false; sGui.BackgroundColor3 = Color3.fromRGB(80,80,80); makeDraggable(sGui)
    local sX = Instance.new("TextButton", sGui); sX.Text = "X"; sX.Size = UDim2.new(0.2, 0, 0, 30); sX.Position = UDim2.new(0.8, 0, 0, 0); sX.MouseButton1Click:Connect(function() sGui.Visible = false end)
    local sScroll = Instance.new("ScrollingFrame", sGui); sScroll.Size = UDim2.new(1,0,1,-30); sScroll.Position = UDim2.new(0,0,0,30); sScroll.CanvasSize = UDim2.new(0,0,2,0); Instance.new("UIListLayout", sScroll).Padding = UDim.new(0, 5)
    
    local function addSet(n, d, c) local h = Instance.new("Frame", sScroll); h.Size = UDim2.new(1,0,0,30); h.BackgroundTransparency = 1; local l = Instance.new("TextLabel", h); l.Text = n; l.Size = UDim2.new(0.5,0,1,0); local b = Instance.new("TextBox", h); b.Text = tostring(d); b.Size = UDim2.new(0.4,0,1,0); b.Position = UDim2.new(0.55,0,0,0); b.FocusLost:Connect(function() c(math.clamp(tonumber(b.Text) or d, 1, 10000)) end); return b end
    addSet("Fly Spd", 50, function(v) flySpeed = v end); addSet("Walk Spd", 16, function(v) walkSpeed = v; if player.Character then player.Character.Humanoid.WalkSpeed = v end end); addSet("Jump Pwr", 50, function(v) jumpPower = v; if player.Character then player.Character.Humanoid.JumpPower = v end end)
    
    local bgBtn = newBtn("BG Color"); bgBtn.Parent = sScroll; local btnBtn = newBtn("Btn Color"); btnBtn.Parent = sScroll; local txtBtn = newBtn("Text Color"); txtBtn.Parent = sScroll

    -- Color UI
    local colorGui = Instance.new("Frame", screenGui); colorGui.Size = UDim2.new(0, 250, 0, 300); colorGui.Visible = false; colorGui.BackgroundColor3 = Color3.fromRGB(80,80,80); makeDraggable(colorGui)
    local cX = Instance.new("TextButton", colorGui); cX.Text = "X"; cX.Size = UDim2.new(0.2, 0, 0, 30); cX.Position = UDim2.new(0.8, 0, 0, 0); cX.MouseButton1Click:Connect(function() colorGui.Visible = false end)
    local cScroll = Instance.new("ScrollingFrame", colorGui); cScroll.Size = UDim2.new(1, 0, 1, -30); cScroll.Position = UDim2.new(0, 0, 0, 30); cScroll.CanvasSize = UDim2.new(0,0,5,0); Instance.new("UIGridLayout", cScroll).CellSize = UDim2.new(0, 35, 0, 35)
    
    -- Color Logic (Same as before)
    local colors = {Color3.new(1,0,0), Color3.new(0,1,0), Color3.new(0,0,1), Color3.new(1,1,0), Color3.new(1,0,1), Color3.new(0,1,1)}
    for i=0, 255, 5 do table.insert(colors, Color3.fromRGB(i, i, i)) end
    for i=1, 100 do table.insert(colors, Color3.fromHSV(math.random(), 0.8, 0.8)) end
    for _, col in pairs(colors) do
        local b = Instance.new("TextButton", cScroll); b.Text = ""; b.BackgroundColor3 = col
        b.MouseButton1Click:Connect(function()
            if colorTarget == "BG" then frame.BackgroundColor3 = col; sGui.BackgroundColor3 = col; colorGui.BackgroundColor3 = col
            elseif colorTarget == "Btn" then for _,c in pairs(container:GetChildren()) do if c:IsA("TextButton") then c.BackgroundColor3 = col end end
            else for _,o in pairs(frame:GetDescendants()) do if o:IsA("TextLabel") or o:IsA("TextButton") then o.TextColor3 = col end end end
        end)
    end
    
    -- Buttons
    minBtn.MouseButton1Click:Connect(function() minimized = not minimized; container.Visible = not minimized; frame.Size = minimized and UDim2.new(0, 180, 0, 30) or UDim2.new(0, 180, 0, 400); minBtn.Text = minimized and "^" or "v" end)
    flyBtn.MouseButton1Click:Connect(function() flying = not flying; flyBtn.Text = flying and "Unfly" or "Fly" end)
    lockBtn.MouseButton1Click:Connect(function() if flying then locked = not locked; lockBtn.Text = locked and "Lock: ON" or "Lock: OFF"; if locked then lockedDirection = workspace.CurrentCamera.CFrame.LookVector end end end)
    noclipBtn.MouseButton1Click:Connect(function() noclip = not noclip; noclipBtn.Text = noclip and "Noclip: ON" or "Noclip: OFF"; if not noclip and player.Character then for _,p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end end)
    freezeBtn.MouseButton1Click:Connect(function() frozen = not frozen; freezeBtn.Text = frozen and "Freeze: ON" or "Freeze: OFF"; if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.Anchored = frozen end end)
    infBtn.MouseButton1Click:Connect(function() infJump = not infJump; infBtn.Text = infJump and "Inf Jump: ON" or "Inf Jump: OFF" end)
    settingsBtn.MouseButton1Click:Connect(function() sGui.Visible = true end)
    bgBtn.MouseButton1Click:Connect(function() colorTarget = "BG"; colorGui.Visible = true end)
    btnBtn.MouseButton1Click:Connect(function() colorTarget = "Btn"; colorGui.Visible = true end)
    txtBtn.MouseButton1Click:Connect(function() colorTarget = "Text"; colorGui.Visible = true end)
    
    -- Loop
    RS.RenderStepped:Connect(function()
        if noclip and player.Character then for _,p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local r = player.Character.HumanoidRootPart
            if not r:FindFirstChild("FlyBV") then local b = Instance.new("BodyVelocity", r); b.Name="FlyBV"; b.MaxForce=Vector3.new(9e9,9e9,9e9); local g = Instance.new("BodyGyro", r); g.Name="FlyBG"; g.MaxTorque=Vector3.new(9e9,9e9,9e9); g.P = 50000 end
            r.FlyBG.CFrame = locked and CFrame.new(r.Position, r.Position + lockedDirection) or workspace.CurrentCamera.CFrame
            r.FlyBV.Velocity = (locked and lockedDirection or workspace.CurrentCamera.CFrame.LookVector) * flySpeed
        elseif player.Character and player.Character:FindFirstChild("HumanoidRootPart") then for _,v in pairs(player.Character.HumanoidRootPart:GetChildren()) do if v.Name=="FlyBV" or v.Name=="FlyBG" then v:Destroy() end end end
    end)
end
createGUI()
