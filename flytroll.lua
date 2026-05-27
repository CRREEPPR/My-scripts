-- Fly Troll by Abd55_55 V5.32
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
    local title = Instance.new("TextLabel", frame); title.Text = "fly troll V5.32"; title.Size = UDim2.new(0.8, 0, 0, 30); title.TextColor3 = Color3.new(1,1,1); title.BackgroundTransparency = 1
    local minBtn = Instance.new("TextButton", frame); minBtn.Text = "v"; minBtn.Size = UDim2.new(0.2, 0, 0, 30); minBtn.Position = UDim2.new(0.8, 0, 0, 0); minBtn.BackgroundTransparency = 1; minBtn.TextColor3 = Color3.new(1,1,1)
    
    local container = Instance.new("ScrollingFrame", frame); container.Size = UDim2.new(1, 0, 1, -30); container.Position = UDim2.new(0, 0, 0, 30); container.BackgroundTransparency = 1; container.CanvasSize = UDim2.new(0,0,3,0); Instance.new("UIListLayout", container).Padding = UDim.new(0, 5)

    local function newBtn(name) local b = Instance.new("TextButton", container); b.Text = name; b.Size = UDim2.new(0.9, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(60,60,60); b.TextColor3 = Color3.new(1,1,1); b.Parent = container; return b end
    
    local flyBtn = newBtn("Fly"); local lockBtn = newBtn("Lock Fly: OFF"); local noclipBtn = newBtn("Noclip: OFF"); local freezeBtn = newBtn("Freeze: OFF"); local infBtn = newBtn("Inf Jump: OFF"); local settingsBtn = newBtn("Settings")
    
    -- Respawn/Death cleanup
    local function resetFly()
        flying = false; locked = false; flyBtn.Text = "Fly"; lockBtn.Text = "Lock Fly: OFF"
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            for _,v in pairs(player.Character.HumanoidRootPart:GetChildren()) do if v.Name=="FlyBV" or v.Name=="FlyBG" then v:Destroy() end end
        end
    end
    player.CharacterAdded:Connect(function(char) char:WaitForChild("Humanoid").Died:Connect(resetFly) end)

    -- Buttons
    minBtn.MouseButton1Click:Connect(function() minimized = not minimized; container.Visible = not minimized; frame.Size = minimized and UDim2.new(0, 180, 0, 30) or UDim2.new(0, 180, 0, 400); minBtn.Text = minimized and "^" or "v" end)
    flyBtn.MouseButton1Click:Connect(function() 
        flying = not flying; flyBtn.Text = flying and "Unfly" or "Fly" 
        if not flying then locked = false; lockBtn.Text = "Lock Fly: OFF" end
    end)
    lockBtn.MouseButton1Click:Connect(function() 
        if flying then 
            locked = not locked; lockBtn.Text = locked and "Lock: ON" or "Lock: OFF"
            if locked then lockedDirection = workspace.CurrentCamera.CFrame.LookVector end 
        end 
    end)
    noclipBtn.MouseButton1Click:Connect(function() noclip = not noclip; noclipBtn.Text = noclip and "Noclip: ON" or "Noclip: OFF"; if not noclip and player.Character then for _,p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end end)
    freezeBtn.MouseButton1Click:Connect(function() frozen = not frozen; freezeBtn.Text = frozen and "Freeze: ON" or "Freeze: OFF"; if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.Anchored = frozen end end)
    infBtn.MouseButton1Click:Connect(function() infJump = not infJump; infBtn.Text = infJump and "Inf Jump: ON" or "Inf Jump: OFF" end)
    settingsBtn.MouseButton1Click:Connect(function() --[[ Existing Settings/Color GUI Code Here ]] end)
    
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
