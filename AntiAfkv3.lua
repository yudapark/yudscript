-- Anti-AFK and Anti-Disconnect Script with GUI
-- This script creates a GUI that can be minimized to a draggable bubble and closed.
-- The anti-AFK feature prevents disconnection due to inactivity by simulating player actions.
-- Note: This is a client-side script. For anti-disconnect on network issues, Roblox doesn't provide direct API,
-- but this focuses on anti-AFK. Run this in a LocalScript inside StarterGui or via an executor.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "AntiAFKGUI"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "Anti-AFK Tool"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = title

-- Minimize Button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -60, 0, 0)
minBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Parent = title

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
toggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
toggleBtn.Text = "Enable Anti-AFK"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.SourceSans
toggleBtn.TextSize = 16
toggleBtn.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.8, 0, 0, 30)
statusLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Disabled"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 14
statusLabel.Parent = frame

-- Bubble (Minimized state)
local bubble = Instance.new("ImageButton")
bubble.Size = UDim2.new(0, 50, 0, 50)
bubble.Position = UDim2.new(0.9, -25, 0.9, -25)
bubble.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
bubble.Image = "rbxassetid://0" -- You can set a bubble image ID here
bubble.Visible = false
bubble.Parent = gui
bubble.BorderSizePixel = 0
bubble.BackgroundTransparency = 0.2
bubble.AutoButtonColor = false

-- Make frame draggable
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateInput(input)
    end
end)

-- Make bubble draggable
local bubbleDragging
local bubbleDragInput
local bubbleDragStart
local bubbleStartPos

local function updateBubbleInput(input)
    local delta = input.Position - bubbleDragStart
    bubble.Position = UDim2.new(bubbleStartPos.X.Scale, bubbleStartPos.X.Offset + delta.X, bubbleStartPos.Y.Scale, bubbleStartPos.Y.Offset + delta.Y)
end

bubble.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        bubbleDragging = true
        bubbleDragStart = input.Position
        bubbleStartPos = bubble.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                bubbleDragging = false
            end
        end)
    end
end)

bubble.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        bubbleDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if bubbleDragging and input == bubbleDragInput then
        updateBubbleInput(input)
    end
end)

-- Anti-AFK Logic
local isEnabled = false
local afkThread

local function startAntiAFK()
    if afkThread then return end
    afkThread = coroutine.create(function()
        while isEnabled do
            -- Simulate activity: Jump or rotate camera to prevent AFK kick
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
            -- VirtualUser for more simulation if needed, but basic jump works
            wait(5) -- Every 5 second, adjust as needed (Roblox AFK is ~20 min)
        end
    end)
    coroutine.resume(afkThread)
end

local function stopAntiAFK()
    if afkThread then
        coroutine.close(afkThread)
        afkThread = nil
    end
end

-- Toggle Functionality
toggleBtn.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    if isEnabled then
        toggleBtn.Text = "Disable Anti-AFK"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        statusLabel.Text = "Status: Enabled"
        startAntiAFK()
    else
        toggleBtn.Text = "Enable Anti-AFK"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        statusLabel.Text = "Status: Disabled"
        stopAntiAFK()
    end
end)

-- Minimize
minBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    bubble.Visible = true
    -- Tween for smooth minimize
    local tween = TweenService:Create(bubble, TweenInfo.new(0.3), {Size = UDim2.new(0, 50, 0, 50)})
    tween:Play()
end)

-- Restore from bubble
bubble.MouseButton1Click:Connect(function()
    bubble.Visible = false
    frame.Visible = true
end)

-- Close
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
    stopAntiAFK()
end)

-- Note: For anti-network disconnect, this script can't fully prevent it as it's client-side.
-- It mainly handles AFK. For full reconnect, you might need external tools or server-side logic.
