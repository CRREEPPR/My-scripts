-- Fly Troll by Abd55_55 - V2.2
local player = game.Players.LocalPlayer
local flying, locked, minimized = false, false, false
local speed = 50
local lockedDirection = Vector3.new(0, 0, 0)
local SCRIPT_VERSION = "V2.2"

local function createGUI()
    local screenGui = Instance.new("ScreenGui", game.CoreGui)
    screenGui.Name = "FlyTrollGUI"
    
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 180, 0, 240)
    frame.Position = UDim2.new(0.1, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Instance.new("UIDragDetector", frame)

    -- Color Settings GUI
    local colorGui = Instance.new("Frame", screenGui)
    colorGui.Size = UDim2.new(0, 150, 0, 200)
    colorGui.Position = UDim2.new(0.3, 0, 0.1, 0)
    colorGui.Visible = false
    colorGui.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    
    local colorTarget = "Background" -- "Background" or "Buttons"

    local function createColorBtn(name, color, pos)
        local btn = Instance.new("TextButton", colorGui)
        btn.Text = name; btn.Position = pos; btn.Size = UDim2.new(1, 0, 0, 25)
        btn.MouseButton1Click:Connect(function()
            if colorTarget == "Background" then frame.BackgroundColor3 = color
            else for _, child in pairs(frame:GetChildren()) do if child:IsA("TextButton") or child:IsA("TextBox") then child.BackgroundColor3 = color end end
            end
        end)
    end

    createColorBtn("Cyan", Color3.fromRGB(0, 255, 255), UDim2.new(0,0,0,0))
    createColorBtn("Pink", Color3.fromRGB(255, 105, 180), UDim2.new(0,0,0,30))
    createColorBtn("White", Color3.fromRGB(255, 255, 255), UDim2.new(0,0,0,60))
    createColorBtn("Black", Color3.fromRGB(0, 0, 0), UDim2.new(0,0,0,90))

    -- Main UI Controls
    local title = Instance.new("TextLabel", frame)
    title.Text = "Fly Troll " .. SCRIPT_VERSION
    title.Size = UDim2.new(0.8, 0, 0, 30); title.BackgroundTransparency = 1; title.TextColor3 = Color3.new(1,1,1)

    local minBtn = Instance.new("TextButton", frame)
    minBtn.Text = "v"; minBtn.Position = UDim2.new(0.8, 0, 0, 0); minBtn.Size = UDim2.new(0.2, 0, 0, 30); minBtn.BackgroundTransparency = 1; minBtn.TextColor3 = Color3.new(1,1,1)

    local container = Instance.new("Frame", frame)
    container.Size = UDim2.new(1, 0, 1, -30); container.Position = UDim2.new(0, 0, 0, 30); container.BackgroundTransparency = 1

    local toggleBtn = Instance.new("TextButton", container); toggleBtn.Text = "Toggle Fly"; toggleBtn.Size = UDim2.new(1, 0, 0, 30)
    local bgBtn = Instance.new("TextButton", container); bgBtn.Text = "Change Background"; bgBtn.Position = UDim2.new(0, 0, 0.2, 0); bgBtn.Size = UDim2.new(1, 0, 0, 30)
    local btnBtn = Instance.new("TextButton", container); btnBtn.Text = "Change Buttons"; btnBtn.Position = UDim2.new(0, 0, 0.4, 0); btnBtn.Size = UDim2.new(1, 0, 0, 30)

    -- Toggle Logic
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        container.Visible = not minimized
        frame.Size = minimized and UDim2.new(0, 180, 0, 30) or UDim2.new(0, 180, 0, 240)
        minBtn.Text = minimized and "^" or "v"
    end)

    bgBtn.MouseButton1Click:Connect(function() colorTarget = "Background"; colorGui.Visible = true end)
    btnBtn.MouseButton1Click:Connect(function() colorTarget = "Buttons"; colorGui.Visible = true end)

    toggleBtn.MouseButton1Click:Connect(function()
        flying = not flying
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if flying and root then
            local bv = Instance.new("BodyVelocity", root); bv.Name = "FlyBV"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            local bg = Instance.new("BodyGyro", root); bg.Name = "FlyBG"; bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); bg.P = 10000
        else
            if root then if root:FindFirstChild("FlyBV") then root.FlyBV:Destroy() end if root:FindFirstChild("FlyBG") then root.FlyBG:Destroy() end end
        end
    end)
end

createGUI()
