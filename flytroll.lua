-- Fly Troll by Abd55_55 V3.3
local player = game.Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
local minimized = true

local function createGUI()
    -- Ensure GUI persists through death
    local screenGui = Instance.new("ScreenGui", guiParent)
    screenGui.Name = "FlyTrollGUI"
    screenGui.ResetOnSpawn = false
    
    -- Main Minimized Bar
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 180, 0, 30)
    frame.Position = UDim2.new(0.1, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UIDragDetector", frame)

    local title = Instance.new("TextLabel", frame)
    title.Text = "fly troll by abd55_55 V3.3"
    title.Size = UDim2.new(0.8, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1, 1, 1)

    local minBtn = Instance.new("TextButton", frame)
    minBtn.Text = "v"
    minBtn.Position = UDim2.new(0.8, 0, 0, 0)
    minBtn.Size = UDim2.new(0.2, 0, 1, 0)
    minBtn.BackgroundTransparency = 1
    minBtn.TextColor3 = Color3.new(1, 1, 1)

    -- Color Changer GUI
    local colorGui = Instance.new("Frame", screenGui)
    colorGui.Size = UDim2.new(0, 150, 0, 200)
    colorGui.Position = UDim2.new(0.3, 0, 0.1, 0)
    colorGui.Visible = false
    colorGui.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UIDragDetector", colorGui)

    local colorTitle = Instance.new("TextLabel", colorGui)
    colorTitle.Text = "color changer"
    colorTitle.Size = UDim2.new(1, 0, 0, 30)
    colorTitle.TextColor3 = Color3.new(1, 1, 1)
    colorTitle.BackgroundTransparency = 1

    local xBtn = Instance.new("TextButton", colorGui)
    xBtn.Text = "X"
    xBtn.Position = UDim2.new(0.85, 0, 0, 0)
    xBtn.Size = UDim2.new(0.15, 0, 0, 30)
    xBtn.TextColor3 = Color3.new(1, 0, 0)
    xBtn.BackgroundTransparency = 1

    -- Logic
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        frame.Size = minimized and UDim2.new(0, 180, 0, 30) or UDim2.new(0, 180, 0, 200)
        minBtn.Text = minimized and "v" or "^"
    end)

    xBtn.MouseButton1Click:Connect(function() colorGui.Visible = false end)
end

-- Prevent duplicate GUIs if the script runs twice
if guiParent:FindFirstChild("FlyTrollGUI") then guiParent.FlyTrollGUI:Destroy() end
createGUI()
