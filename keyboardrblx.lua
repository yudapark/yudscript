-- Keyboard.lua - Fixed Mobile External Keyboard for Roblox Chat (Executor Script)
-- Bugfix: Bubble toggle now properly shows/hides keyboard with animations
-- Optimized for Android/Mobile. Paste into executor.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ExternalKeyboard"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Bubble Button (always visible when closed)
local bubbleFrame = Instance.new("Frame")
bubbleFrame.Name = "Bubble"
bubbleFrame.Size = UDim2.new(0, 80, 0, 80)
bubbleFrame.Position = UDim2.new(1, -100, 1, -100)
bubbleFrame.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
bubbleFrame.BorderSizePixel = 0
bubbleFrame.Parent = screenGui

local bubbleCorner = Instance.new("UICorner")
bubbleCorner.CornerRadius = UDim.new(1, 0)
bubbleCorner.Parent = bubbleFrame

local bubbleText = Instance.new("TextLabel")
bubbleText.Size = UDim2.new(1, 0, 1, 0)
bubbleText.BackgroundTransparency = 1
bubbleText.Text = "⌨"
bubbleText.TextColor3 = Color3.new(1, 1, 1)
bubbleText.TextScaled = true
bubbleText.Font = Enum.Font.GothamBold
bubbleText.Parent = bubbleFrame

-- Main Keyboard Frame (starts offscreen)
local keyboardFrame = Instance.new("Frame")
keyboardFrame.Name = "Keyboard"
keyboardFrame.Size = UDim2.new(1, 0, 0.6, 0)
keyboardFrame.Position = UDim2.new(0, 0, 1.1, 0)  -- Offscreen initially
keyboardFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
keyboardFrame.BorderSizePixel = 0
keyboardFrame.Visible = true  -- Visible but offscreen
keyboardFrame.Parent = screenGui

local keyboardCorner = Instance.new("UICorner")
keyboardCorner.CornerRadius = UDim.new(0, 12)
keyboardCorner.Parent = keyboardFrame

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0.08, 0, 0.15, 0)
minimizeBtn.Position = UDim2.new(0.92, 0, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = keyboardFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimizeBtn

-- Input Display
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0.9, 0, 0.15, 0)
inputBox.Position = UDim2.new(0.05, 0, 0, 0)
inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inputBox.BorderSizePixel = 0
inputBox.Text = ""
inputBox.PlaceholderText = "Type here (send to chat)"
inputBox.TextColor3 = Color3.new(1, 1, 1)
inputBox.TextScaled = true
inputBox.Font = Enum.Font.Gotham
inputBox.ClearTextOnFocus = false
inputBox.MultiLine = false
inputBox.Parent = keyboardFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = inputBox

local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(0.23, 0, 0.15, 0)
sendBtn.Position = UDim2.new(0.72, 0, 0, 0)
sendBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
sendBtn.BorderSizePixel = 0
sendBtn.Text = "Send"
sendBtn.TextColor3 = Color3.new(1, 1, 1)
sendBtn.TextScaled = true
sendBtn.Font = Enum.Font.GothamBold
sendBtn.Parent = keyboardFrame

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 8)
sendCorner.Parent = sendBtn

-- Keyboard Layout
local rows = {
    {"Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"},
    {"A", "S", "D", "F", "G", "H", "J", "K", "L"},
    {"Z", "X", "C", "V", "B", "N", "M", " ", "⌫", "↵"}
}

local keyY = 0.22
for _, row in ipairs(rows) do
    local rowFrame = Instance.new("Frame")
    rowFrame.Size = UDim2.new(1, -20, 0, 60)
    rowFrame.Position = UDim2.new(0, 10, keyY, 0)
    rowFrame.BackgroundTransparency = 1
    rowFrame.Parent = keyboardFrame
    
    local xPos = 0
    for _, key in ipairs(row) do
        local keyBtn = Instance.new("TextButton")
        keyBtn.Size = UDim2.new(0, 50, 1, 0)
        keyBtn.Position = UDim2.new(0, xPos, 0, 0)
        keyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        keyBtn.BorderSizePixel = 0
        keyBtn.Text = key
        keyBtn.TextColor3 = Color3.new(1, 1, 1)
        keyBtn.TextScaled = true
        keyBtn.Font = Enum.Font.GothamSemibold
        keyBtn.Parent = rowFrame

        local keyCorner = Instance.new("UICorner")
        keyCorner.CornerRadius = UDim.new(0, 6)
        keyCorner.Parent = keyBtn

        -- Visual feedback
        keyBtn.MouseButton1Down:Connect(function()
            keyBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
        end)
        keyBtn.MouseButton1Up:Connect(function()
            keyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end)

        -- Input logic
        keyBtn.Activated:Connect(function()
            local text = keyBtn.Text
            if text == "⌫" then
                inputBox.Text = inputBox.Text:sub(1, -2)
            elseif text == "↵" then
                if inputBox.Text ~= "" then
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents", 5).SayMessageRequest:FireServer(inputBox.Text, "All")
                    end)
                    inputBox.Text = ""
                end
            elseif text == " " then
                inputBox.Text = inputBox.Text .. " "
            else
                inputBox.Text = inputBox.Text .. text
            end
        end)
        
        xPos = xPos + 55
    end
    keyY = keyY + 0.18
end

-- Fixed Animations & Toggle
local showInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local hideInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)

local function openKeyboard()
    bubbleFrame.Visible = false
    local showTween = TweenService:Create(keyboardFrame, showInfo, {
        Position = UDim2.new(0, 0, 0.4, 0),
        Size = UDim2.new(1, 0, 0.6, 0)
    })
    showTween:Play()
    inputBox:CaptureFocus()
end

local function closeKeyboard()
    local hideTween = TweenService:Create(keyboardFrame, hideInfo, {
        Position = UDim2.new(0, 0, 1.1, 0),
        Size = UDim2.new(1, 0, 0.6, 0)
    })
    hideTween:Play()
    hideTween.Completed:Connect(function()
        bubbleFrame.Visible = true
    end)
end

-- Event connections
bubbleFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        openKeyboard()
    end
end)

minimizeBtn.Activated:Connect(closeKeyboard)

sendBtn.Activated:Connect(function()
    if inputBox.Text ~= "" then
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents", 5).SayMessageRequest:FireServer(inputBox.Text, "All")
        end)
        inputBox.Text = ""
    end
end)

print("Fixed External Mobile Keyboard loaded! Tap blue bubble to open.")
print("Bugfix: Proper toggle animations, no disappearing issues.")

-- Keep script running
game:GetService("RunService").Heartbeat:Wait()

