-- Fly Troll by Abd55_55 V3.4
local player = game.Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
local minimized = false -- Changed to false so buttons show up immediately

local function createGUI()
    if guiParent:FindFirstChild("FlyTrollGUI") then guiParent.FlyTrollGUI:Destroy() end
    
    local screenGui = Instance.new("ScreenGui", guiParent)
    screenGui.Name = "FlyTrollGUI"
    screenGui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 180, 0, 270) -- Set to full size
    frame.Position = UDim2.new(0.1, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UIDragDetector", frame)

    local container = Instance.new("Frame", frame)
    container.Name = "ButtonContainer"
    container.Size = UDim2.new(1, 0, 1, -30)
    container.Position = UDim2.new(0, 0, 0, 30)
    container.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", frame)
    title.Text = "fly troll by abd55_55 V3.3"
    title.Size = UDim2.new(0.8, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1, 1, 1)

    local minBtn = Instance.new("TextButton", frame)
    minBtn.Text = "^"
    minBtn.Position = UDim2.new(0.8, 0, 0, 0)
    minBtn.Size = UDim2.new(0.2, 0, 0, 30)
    minBtn.BackgroundTransparency = 1
    minBtn.TextColor3 = Color3.new(1, 1, 1)

    -- Added Buttons
    local flyBtn = Instance.new("TextButton", container)
    flyBtn.Text = "Fly"
    flyBtn.Size = UDim2.new(1, 0, 0, 40)
    flyBtn.Position = UDim2.new(0, 0, 0, 10)

    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        container.Visible = not minimized
        frame.Size = minimized and UDim2.new(0, 180, 0, 30) or UDim2.new(0, 180, 0, 270)
        minBtn.Text = minimized and "v" or "^"
    end)
end

createGUI()
