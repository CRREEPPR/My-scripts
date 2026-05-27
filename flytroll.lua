-- Fly Troll by Abd55_55 - V2.9.1
local player = game.Players.LocalPlayer
local flying, locked, minimized = false, false, false
local speed = 50
local lockedDirection = Vector3.new(0, 0, 0)
local SCRIPT_VERSION = "V2.9.1"
local rainbowTarget = nil

local function createGUI()
    local screenGui = Instance.new("ScreenGui", game.CoreGui)
    screenGui.Name = "FlyTrollGUI"
    
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 180, 0, 270)
    frame.Position = UDim2.new(0.1, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UIDragDetector", frame)

    local container = Instance.new("Frame", frame)
    container.Size = UDim2.new(1, 0, 1, -30); container.Position = UDim2.new(0, 0, 0, 30); container.BackgroundTransparency = 1

    -- Color Menu (Redesigned per drawing)
    local colorGui = Instance.new("Frame", screenGui)
    colorGui.Size = UDim2.new(0, 160, 0, 210)
    colorGui.Position = UDim2.new(0.3, 0, 0.1, 0)
    colorGui.Visible = false
    colorGui.BackgroundColor3 = Color3.fromRGB(150, 150, 150) -- Light Grey
    colorGui.BorderSizePixel = 3
    colorGui.BorderColor3 = Color3.new(0, 0, 0) -- Thick Black Border
    Instance.new("UIDragDetector", colorGui)
    
    -- Curved top bar like drawing
    local curvedTop = Instance.new("UICorner", colorGui)
    curvedTop.CornerRadius = UDim.new(0, 15)

    -- Red X Close Button
    local xBtn = Instance.new("TextButton", colorGui)
    xBtn.Text = "X"
    xBtn.Size = UDim2.new(0, 30, 0, 30)
    xBtn.Position = UDim2.new(1, -35, 0, 5) -- Aligned top-right
    xBtn.BackgroundTransparency = 1
    xBtn.TextColor3 = Color3.new(1, 0, 0) -- Bright Red
    xBtn.TextSize = 25
    xBtn.MouseButton1Click:Connect(function() colorGui.Visible = false end)

    local titleBar = Instance.new("Frame", colorGui)
    titleBar.Size = UDim2.new(0.7, 0, 0, 30)
    titleBar.Position = UDim2.new(0, 10, 0, 5)
    titleBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    titleBar.BorderSizePixel = 0

    local curvedTitle = Instance.new("UICorner", titleBar)
    curvedTitle.CornerRadius = UDim.new(0, 8)

    local titleLabel = Instance.new("TextLabel", titleBar)
    titleLabel.Text = "color changer"
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.TextColor3 = Color3.new(0, 0, 0)
    titleLabel.BackgroundTransparency = 1

    -- Grid of Color Slots
    local scrollingFrame = Instance.new("ScrollingFrame", colorGui)
    scrollingFrame.Size = UDim2.new(1, -20, 1, -45)
    scrollingFrame.Position = UDim2.new(0, 10, 0, 40)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.ScrollBarThickness = 5

    -- Grid Layout for Slots
    local gridLayout = Instance.new("UIGridLayout", scrollingFrame)
    gridLayout.CellSize = UDim2.new(0, 40, 0, 40) -- Square slots
    gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
    gridLayout.FillDirectionMaxCells = 3 -- 3 Columns
    
    local colorTarget = "Background"

    local function applyColor(color, isRainbow)
        if isRainbow then rainbowTarget = colorTarget
        else 
            if rainbowTarget == colorTarget then rainbowTarget = nil end
            if colorTarget == "Background" then frame.BackgroundColor3 = color
            else for _, c in pairs(container:GetChildren()) do if c:IsA("TextButton") or c:IsA("TextBox") then c.BackgroundColor3 = color end end end
        end
        colorGui.Visible = false
    end

    local colors = {
        {"Rainbow", Color3.new(1,1,1), true}, -- Dummy Color
        {"Blue", Color3.new(0,0,1)}, {"Orange", Color3.fromRGB(255,165,0)}, 
        {"Yellow", Color3.new(1,1,0)}, {"Red", Color3.new(1,0,0)}, 
        {"Green", Color3.new(0,1,0)}, {"White", Color3.new(1,1,1)}, 
        {"Black", Color3.new(0,0,0)}, {"Cyan", Color3.fromRGB(0,255,255)}, 
        {"Pink", Color3.fromRGB(255,105,180)}, {"Purple", Color3.fromRGB(128,0,128)}
    }

    for i, v in pairs(colors) do
        local slot = Instance.new("TextButton", scrollingFrame)
        slot.Text = ""
        slot.Size = UDim2.new(0, 40, 0, 40)
        slot.BackgroundColor3 = v[2]
        slot.BorderSizePixel = 2
        slot.BorderColor3 = Color3.new(0, 0, 0) -- Clear borders
        if v[1] == "Rainbow" then
            local uistroke = Instance.new("UIStroke", slot) -- To make the rainbow slot stand out
            uistroke.Color = Color3.fromRGB(0,255,0); uistroke.Thickness=2; uistroke.Enabled=true
        end
        slot.MouseButton1Click:Connect(function() applyColor(v[2], v[3]) end)
    end

    -- Rainbow Loop
    task.spawn(function()
        local hue = 0
        while true do
            hue = (hue + 0.005) % 1
            local rainbow = Color3.fromHSV(hue, 1, 1)
            if rainbowTarget == "Background" or rainbowTarget == "Both" then frame.BackgroundColor3 = rainbow end
            if rainbowTarget == "Buttons" or rainbowTarget == "Both" then for _, c in pairs(container:GetChildren()) do if c:IsA("TextButton") or c:IsA("TextBox") then c.BackgroundColor3 = rainbow end end end
            task.wait(0.05)
        end
    end)

    -- Controls
    local title = Instance.new("TextLabel", frame); title.Text = "Fly Troll " .. SCRIPT_VERSION; title.Size = UDim2.new(0.8, 0, 0, 30); title.BackgroundTransparency = 1; title.TextColor3 = Color3.new(1,1,1)
    local minBtn = Instance.new("TextButton", frame); minBtn.Text = "v"; minBtn.Position = UDim2.new(0.8, 0, 0, 0); minBtn.Size = UDim2.new(0.2, 0, 0, 30); minBtn.BackgroundTransparency = 1; minBtn.TextColor3 = Color3.new(1,1,1)
    local flyBtn = Instance.new("TextButton", container); flyBtn.Text = "Fly"; flyBtn.Size = UDim2.new(1, 0, 0, 30)
    local lockBtn = Instance.new("TextButton", container); lockBtn.Text = "Lock Fly: OFF"; lockBtn.Size = UDim2.new(1, 0, 0, 30); lockBtn.Position = UDim2.new(0,0,0.15,0)
    local bgBtn = Instance.new("TextButton", container); bgBtn.Text = "Background Color"; bgBtn.Size = UDim2.new(1, 0, 0, 30); bgBtn.Position = UDim2.new(0,0,0.3,0)
    local btnBtn = Instance.new("TextButton", container); btnBtn.Text = "Button Color"; btnBtn.Size = UDim2.new(1, 0, 0, 30); btnBtn.Position = UDim2.new(0,0,0.45,0)
    local speedBox = Instance.new("TextBox", container); speedBox.PlaceholderText = "Speed (1-1000)"; speedBox.Size = UDim2.new(1, 0, 0, 30); speedBox.Position = UDim2.new(0,0,0.6,0)

    minBtn.MouseButton1Click:Connect
    