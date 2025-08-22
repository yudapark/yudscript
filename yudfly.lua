-- GUI untuk Movement Enhancements Script
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MovementEnhancementsGUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Corner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Movement Enhancements"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = TopBar

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 16
MinimizeButton.Parent = TopBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = TopBar

-- Content Frame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 5
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
ContentFrame.Parent = MainFrame

-- UIListLayout for Content
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ContentFrame

-- Minimized Frame
local MinimizedFrame = Instance.new("Frame")
MinimizedFrame.Name = "MinimizedFrame"
MinimizedFrame.Size = UDim2.new(0, 150, 0, 30)
MinimizedFrame.Position = UDim2.new(0, 10, 1, -40)
MinimizedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MinimizedFrame.BorderSizePixel = 0
MinimizedFrame.Visible = false
MinimizedFrame.Parent = ScreenGui

local MinimizedCorner = Instance.new("UICorner")
MinimizedCorner.CornerRadius = UDim.new(0, 8)
MinimizedCorner.Parent = MinimizedFrame

local MinimizedTitle = Instance.new("TextLabel")
MinimizedTitle.Name = "MinimizedTitle"
MinimizedTitle.Size = UDim2.new(0, 100, 1, 0)
MinimizedTitle.Position = UDim2.new(0, 10, 0, 0)
MinimizedTitle.BackgroundTransparency = 1
MinimizedTitle.Text = "Movement Enhancer"
MinimizedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedTitle.TextXAlignment = Enum.TextXAlignment.Left
MinimizedTitle.Font = Enum.Font.GothamBold
MinimizedTitle.TextSize = 12
MinimizedTitle.Parent = MinimizedFrame

local MaximizeButton = Instance.new("TextButton")
MaximizeButton.Name = "MaximizeButton"
MaximizeButton.Size = UDim2.new(0, 30, 1, 0)
MaximizeButton.Position = UDim2.new(1, -30, 0, 0)
MaximizeButton.BackgroundTransparency = 1
MaximizeButton.Text = "+"
MaximizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MaximizeButton.Font = Enum.Font.GothamBold
MaximizeButton.TextSize = 16
MaximizeButton.Parent = MinimizedFrame

-- Function to create toggle buttons
local function createToggleButton(text, key, initialState, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = text .. "ToggleFrame"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = ContentFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = text .. "Toggle"
    ToggleButton.Size = UDim2.new(0, 120, 1, 0)
    ToggleButton.Position = UDim2.new(0, 0, 0, 0)
    ToggleButton.BackgroundColor3 = initialState and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(180, 80, 80)
    ToggleButton.Text = text .. ": " .. (initialState and "ON" or "OFF")
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Font = Enum.Font.Gotham
    ToggleButton.TextSize = 12
    ToggleButton.Parent = ToggleFrame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = ToggleButton
    
    local KeyBindLabel = Instance.new("TextLabel")
    KeyBindLabel.Name = "KeyBindLabel"
    KeyBindLabel.Size = UDim2.new(0, 50, 1, 0)
    KeyBindLabel.Position = UDim2.new(1, -50, 0, 0)
    KeyBindLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    KeyBindLabel.Text = "[" .. key .. "]"
    KeyBindLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    KeyBindLabel.Font = Enum.Font.Gotham
    KeyBindLabel.TextSize = 12
    KeyBindLabel.Parent = ToggleFrame
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 4)
    UICorner2.Parent = KeyBindLabel
    
    ToggleButton.MouseButton1Click:Connect(function()
        local newState = not callback()
        ToggleButton.BackgroundColor3 = newState and Color3.fromRGB(80, 180, 80) or Color3.fromRGB(180, 80, 80)
        ToggleButton.Text = text .. ": " .. (newState and "ON" or "OFF")
    end)
    
    return ToggleButton
end

-- Function to create slider
local function createSlider(text, minValue, maxValue, currentValue, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = text .. "SliderFrame"
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = ContentFrame
    
    local SliderTitle = Instance.new("TextLabel")
    SliderTitle.Name = "SliderTitle"
    SliderTitle.Size = UDim2.new(1, 0, 0, 20)
    SliderTitle.Position = UDim2.new(0, 0, 0, 0)
    SliderTitle.BackgroundTransparency = 1
    SliderTitle.Text = text .. ": " .. currentValue
    SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderTitle.Font = Enum.Font.Gotham
    SliderTitle.TextSize = 12
    SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
    SliderTitle.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Name = "SliderBar"
    SliderBar.Size = UDim2.new(1, 0, 0, 10)
    SliderBar.Position = UDim2.new(0, 0, 0, 30)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    SliderBar.Parent = SliderFrame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "SliderFill"
    SliderFill.Size = UDim2.new((currentValue - minValue) / (maxValue - minValue), 0, 1, 0)
    SliderFill.Position = UDim2.new(0, 0, 0, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    SliderFill.Parent = SliderBar
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 5)
    UICorner2.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Name = "SliderButton"
    SliderButton.Size = UDim2.new(0, 20, 0, 20)
    SliderButton.Position = UDim2.new((currentValue - minValue) / (maxValue - minValue), -10, 0, -5)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Text = ""
    SliderButton.Parent = SliderBar
    
    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(0, 10)
    UICorner3.Parent = SliderButton
    
    local dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local xPos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local value = math.floor(minValue + (maxValue - minValue) * xPos)
            
            SliderFill.Size = UDim2.new(xPos, 0, 1, 0)
            SliderButton.Position = UDim2.new(xPos, -10, 0, -5)
            SliderTitle.Text = text .. ": " .. value
            
            callback(value)
        end
    end)
end

-- Create toggle buttons for each feature
local noclipToggle = createToggleButton("Noclip", "B", NOCLIP_ENABLED, function()
    NOCLIP_ENABLED = not NOCLIP_ENABLED
    print("Noclip: " .. (NOCLIP_ENABLED and "ON" or "OFF"))
    return NOCLIP_ENABLED
end)

local flyToggle = createToggleButton("Fly", "F", FLY_ENABLED, function()
    FLY_ENABLED = not FLY_ENABLED
    print("Fly: " .. (FLY_ENABLED and "ON" or "OFF"))
    if FLY_ENABLED then
        enableFly()
    else
        disableFly()
    end
    return FLY_ENABLED
end)

local speedToggle = createToggleButton("Speed Hack", "G", SPEED_HACK_ENABLED, function()
    SPEED_HACK_ENABLED = not SPEED_HACK_ENABLED
    print("Speed Hack: " .. (SPEED_HACK_ENABLED and "ON" or "OFF"))
    if SPEED_HACK_ENABLED then
        enableSpeedHack()
    else
        disableSpeedHack()
    end
    return SPEED_HACK_ENABLED
end)

local jumpToggle = createToggleButton("Infinite Jump", "H", INFINITE_JUMP_ENABLED, function()
    INFINITE_JUMP_ENABLED = not INFINITE_JUMP_ENABLED
    print("Infinite Jump: " .. (INFINITE_JUMP_ENABLED and "ON" or "OFF"))
    return INFINITE_JUMP_ENABLED
end)

local jumpHeightToggle = createToggleButton("Jump Height", "J", JUMP_HEIGHT_ENABLED, function()
    JUMP_HEIGHT_ENABLED = not JUMP_HEIGHT_ENABLED
    print("Jump Height: " .. (JUMP_HEIGHT_ENABLED and "ON" or "OFF"))
    if JUMP_HEIGHT_ENABLED then
        enableJumpHeight()
    else
        disableJumpHeight()
    end
    return JUMP_HEIGHT_ENABLED
end)

local spinbotToggle = createToggleButton("Spinbot", "K", SPINBOT_ENABLED, function()
    SPINBOT_ENABLED = not SPINBOT_ENABLED
    print("Spinbot: " .. (SPINBOT_ENABLED and "ON" or "OFF"))
    return SPINBOT_ENABLED
end)

-- Create sliders for adjustable settings
createSlider("Fly Speed", 10, 100, FLY_SPEED, function(value)
    FLY_SPEED = value
end)

createSlider("Speed Multiplier", 1, 10, SPEED_MULTIPLIER, function(value)
    SPEED_MULTIPLIER = value
    if SPEED_HACK_ENABLED then
        disableSpeedHack()
        enableSpeedHack()
    end
end)

createSlider("Jump Height", 10, 200, JUMP_HEIGHT, function(value)
    JUMP_HEIGHT = value
    if JUMP_HEIGHT_ENABLED then
        disableJumpHeight()
        enableJumpHeight()
    end
end)

createSlider("Spinbot Speed", 1, 50, SPINBOT_SPEED, function(value)
    SPINBOT_SPEED = value
end)

-- Teleport buttons
local TeleportFrame = Instance.new("Frame")
TeleportFrame.Name = "TeleportFrame"
TeleportFrame.Size = UDim2.new(1, 0, 0, 40)
TeleportFrame.BackgroundTransparency = 1
TeleportFrame.Parent = ContentFrame

local TeleportTitle = Instance.new("TextLabel")
TeleportTitle.Name = "TeleportTitle"
TeleportTitle.Size = UDim2.new(1, 0, 0, 20)
TeleportTitle.Position = UDim2.new(0, 0, 0, 0)
TeleportTitle.BackgroundTransparency = 1
TeleportTitle.Text = "Teleport:"
TeleportTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportTitle.Font = Enum.Font.Gotham
TeleportTitle.TextSize = 12
TeleportTitle.TextXAlignment = Enum.TextXAlignment.Left
TeleportTitle.Parent = TeleportFrame

local ForwardButton = Instance.new("TextButton")
ForwardButton.Name = "ForwardButton"
ForwardButton.Size = UDim2.new(0, 120, 0, 20)
ForwardButton.Position = UDim2.new(0, 0, 0, 20)
ForwardButton.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
ForwardButton.Text = "Forward [↑]"
ForwardButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ForwardButton.Font = Enum.Font.Gotham
ForwardButton.TextSize = 12
ForwardButton.Parent = TeleportFrame

local UICorner4 = Instance.new("UICorner")
UICorner4.CornerRadius = UDim.new(0, 4)
UICorner4.Parent = ForwardButton

local BackwardButton = Instance.new("TextButton")
BackwardButton.Name = "BackwardButton"
BackwardButton.Size = UDim2.new(0, 120, 0, 20)
BackwardButton.Position = UDim2.new(0, 130, 0, 20)
BackwardButton.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
BackwardButton.Text = "Backward [↓]"
BackwardButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BackwardButton.Font = Enum.Font.Gotham
BackwardButton.TextSize = 12
BackwardButton.Parent = TeleportFrame

local UICorner5 = Instance.new("UICorner")
UICorner5.CornerRadius = UDim.new(0, 4)
UICorner5.Parent = BackwardButton

ForwardButton.MouseButton1Click:Connect(function()
    teleportForward(15)
end)

BackwardButton.MouseButton1Click:Connect(function()
    teleportBackward(15)
end)

-- Button functionality
MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedFrame.Visible = true
end)

MaximizeButton.MouseButton1Click:Connect(function()
    MinimizedFrame.Visible = false
    MainFrame.Visible = true
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    cleanup()
end)

-- Dragging functionality
local dragging = false
local dragInput, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("🎮 GUI Loaded! Use the interface to control movement enhancements.")
