-- Keyboard.lua - Mobile External Keyboard for Roblox Chat (Executor Script)
-- Optimized for Android/Mobile, GUI-based keyboard with bubble toggle, maximize/minimize
-- Paste into executor and run. Works in most games with chat enabled.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ExternalKeyboard"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Bubble Button (minimized state)
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

-- Main Keyboard Frame (maximized)
local keyboardFrame = Instance.new("Frame")
keyboardFrame.Name = "Keyboard"
keyboardFrame.Size = UDim2.new(1, 0, 0.6, 0)
keyboardFrame.Position = UDim2.new(0, 0, 0.4, 0)
keyboardFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
keyboardFrame.BorderSizePixel = 0
keyboardFrame.Visible = false
keyboardFrame.Parent = screenGui

local keyboardCorner = Instance.new("UICorner")
keyboardCorner.CornerRadius = UDim.new(0, 12)
keyboardCorner.Parent = keyboardFrame

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "Minimize"
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

-- Input Display (simulates chat input)
local inputBox = Instance.new("TextBox")
inputBox.Name = "InputBox"
inputBox.Size = UDim2.new(0.9, 0, 0.15, 0)
inputBox.Position = UDim2.new(0.05, 0, 0, 0)
inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inputBox.BorderSizePixel = 0
inputBox.Text = ""
inputBox.PlaceholderText = "Type here (sends to chat on Enter)"
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
sendBtn.Name = "Send"
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

-- Keyboard Layout (QWERTY for mobile - 3 rows simplified)
local rows = {
    {"Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"},
    {"A", "S", "D", "F", "G", "H", "J", "K", "L"},
    {"Z", "X", "C", "V", "B", "N", "M", " ", "⌫", "↵"}
}

local keyY = 0.22
for rowIdx, row in ipairs(rows) do
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
        
        -- Key press tween
        keyBtn.MouseButton1Click:Connect(function()
            keyBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
            wait(0.1)
            keyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end)
        
        -- Handle key input
        keyBtn.MouseButton1Down:Connect(function()
            local text = keyBtn.Text
            if text == "⌫" then
                inputBox.Text = string.sub(inputBox.Text, 1, -2)
            elseif text == "↵" or text == "Enter" then
                -- Send to chat (simulate chat send)
                if inputBox.Text ~= "" then
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(inputBox.Text, "All")
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

-- Animations
local showTween = TweenService:Create(keyboardFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = UDim2.new(0, 0, 0.4, 0), Size = UDim2.new(1, 0, 0.6, 0)})
local hideTween = TweenService:Create(keyboardFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = UDim2.new(0, 0, 1.1, 0), Size = UDim2.new(1, 0, 0, 0)})

-- Toggle functions
local isOpen = false
local function toggleKeyboard()
    isOpen = not isOpen
    bubbleFrame.Visible = not isOpen
    
    if isOpen then
        showTween:Play()
    else
        hideTween:Play()
    end
end

bubbleFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleKeyboard()
    end
end)

minimizeBtn.MouseButton1Click:Connect(toggleKeyboard)

sendBtn.MouseButton1Click:Connect(function()
    if inputBox.Text ~= "" then
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(inputBox.Text, "All")
        inputBox.Text = ""
    end
end)

-- Mobile touch optimization
UserInputService.TouchEnabled = true

-- Auto-focus on open (optional)
keyboardFrame:GetPropertyChangedSignal("Visible"):Connect(function()
    if keyboardFrame.Visible then
        inputBox:CaptureFocus()
    end
end)

print("External Mobile Keyboard loaded! Tap blue bubble to open.")

-- Keep alive
while wait(1) do end

