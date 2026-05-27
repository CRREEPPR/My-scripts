-- Fly Troll by Abd55_55 V5.26
local player = game.Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local flying, locked, minimized, frozen, noclip, infJump = false, false, false, false, false, false
local flySpeed, walkSpeed, jumpPower = 50, 16, 50
local lockedDirection = Vector3.new(0, 0, 0)

-- Drag Logic
local function makeDraggable(frame)
    local dragToggle, dragStart, startPos
    frame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = true; dragStart = input.Position; startPos = frame.Position end end)
    UIS.InputChanged:Connect(function(input) if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = false end end)
end

-- GUI Setup
local function createGUI()
    if guiParent:FindFirstChild("FlyTrollGUI") then guiParent.FlyTrollGUI:Destroy() end
    local screenGui = Instance.new("ScreenGui", guiParent); screenGui.Name = "FlyTrollGUI"; screenGui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame", screenGui); frame.Size = UDim2.new(0, 180, 0, 360); frame.Position = UDim2.new(0.1, 0, 0.1, 0); frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40); makeDraggable(frame)
    local title = Instance.new("TextLabel", frame); title.Text = "fly troll V5.26"; title.Size = UDim2.new(1, 0, 0, 30); title.TextColor3 = Color3.new(1,1,1); title.BackgroundTransparency = 1
    
    local container = Instance.new("ScrollingFrame", frame); container.Size = UDim2.new(1, 0, 1, -30); container.Position = UDim2.new(0, 0, 0, 30); container.BackgroundTransparency = 1; container.CanvasSize = UDim2.new(0,0,2,0); Instance.new("UIListLayout", container).Padding = UDim.new(0, 5)

    local function newBtn(name) local b = Instance.new("TextButton", container); b.Text = name; b.Size = UDim2.new(0.9, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(60,60,60); b.TextColor3 = Color3.new(1,1,1); b.Parent = container; return b end
    
    local flyBtn = newBtn("Fly"); local lockBtn = newBtn("Lock Fly: OFF"); local infBtn = newBtn("Inf Jump: OFF"); local settingsBtn = newBtn("Settings")
    
    -- Settings GUI (as in 1000031835.png)
    local sGui = Instance.new("Frame", screenGui); sGui.Size = UDim2.new(0, 250, 0, 300); sGui.Visible = false; sGui.BackgroundColor3 = Color3.fromRGB(80,80,80); makeDraggable(sGui)
    local sScroll = Instance.new("ScrollingFrame", sGui); sScroll.Size = UDim2.new(1,0,1,-30); sScroll.Position = UDim2.new(0,0,0,30); sScroll.CanvasSize = UDim2.new(0,0,1.5,0); Instance.new("UIListLayout", sScroll)
    local closeS = Instance.new("TextButton", sGui); closeS.Text = "X"; closeS.Size = UDim2.new(0,30,0,30); closeS.Position = UDim2.new(1,-30,0,0); closeS.TextColor3 = Color3.new(1,0,0); closeS.MouseButton1Click:Connect(function() sGui.Visible = false end)

    local function addSetting(name, default, callback)
        local h = Instance.new("Frame", sScroll); h.Size = UDim2.new(1,0,0,40); h.BackgroundTransparency = 1
        local lbl = Instance.new("TextLabel", h); lbl.Text = name; lbl.Size = UDim2.new(0.5,0,1,0); lbl.BackgroundTransparency = 1
        local box = Instance.new("TextBox", h); box.Text = tostring(default); box.Size = UDim2.new(0.4,0,1,0); box.Position = UDim2.new(0.6,0,0,0); box.FocusLost:Connect(function() callback(tonumber(box.Text) or default) end)
        return box
    end
    
    addSetting("Fly Speed", 50, function(v) flySpeed = v end)
    
    local walkBox = addSetting("Walk Speed", 16, function(v) walkSpeed = v; if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.WalkSpeed = v end end)
    local resW = Instance.new("TextButton", sScroll); resW.Text = "Reset Walk"; resW.Size = UDim2.new(0.9,0,0,30); resW.MouseButton1Click:Connect(function() walkSpeed = 16; walkBox.Text = "16"; if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.WalkSpeed = 16 end end)
    
    local jumpBox = addSetting("Jump Power", 50, function(v) jumpPower = v; if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.JumpPower = v end end)
    local resJ = Instance.new("TextButton", sScroll); resJ.Text = "Reset Jump"; resJ.Size = UDim2.new(0.9,0,0,30); resJ.MouseButton1Click:Connect(function() jumpPower = 50; jumpBox.Text = "50"; if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.JumpPower = 50 end end)

    -- Logic
    flyBtn.MouseButton1Click:Connect(function() flying = not flying; flyBtn.Text = flying and "Unfly" or "Fly" end)
    infBtn.MouseButton1Click:Connect(function() infJump = not infJump; infBtn.Text = infJump and "Inf Jump: ON" or "Inf Jump: OFF" end)
    settingsBtn.MouseButton1Click:Connect(function() sGui.Visible = true end)
    
    UIS.JumpRequest:Connect(function() if infJump and player.Character then player.Character:FindFirstChild("Humanoid"):ChangeState("Jumping") end end)

    RS.RenderStepped:Connect(function()
        if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local r = player.Character.HumanoidRootPart
            if not r:FindFirstChild("FlyBV") then local b = Instance.new("BodyVelocity", r); b.Name="FlyBV"; b.MaxForce=Vector3.new(9e9,9e9,9e9); local g = Instance.new("BodyGyro", r); g.Name="FlyBG"; g.MaxTorque=Vector3.new(9e9,9e9,9e9); g.P = 50000 end
            r.FlyBV.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
        elseif player.Character and player.Character:FindFirstChild("HumanoidRootPart") then for _,v in pairs(player.Character.HumanoidRootPart:GetChildren()) do if v.Name=="FlyBV" or v.Name=="FlyBG" then v:Destroy() end end end
    end)
end
createGUI()
