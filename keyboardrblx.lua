-- KEYBOARD ROBLOX FULL (1 FILE)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "KeyboardUI"

-- TEXT DISPLAY
local textLabel = Instance.new("TextLabel", gui)
textLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
textLabel.Position = UDim2.new(0.1, 0, 0.7, 0)
textLabel.BackgroundColor3 = Color3.fromRGB(30,30,30)
textLabel.TextColor3 = Color3.new(1,1,1)
textLabel.TextScaled = true
textLabel.Text = ""

-- KEYBOARD FRAME
local keyboard = Instance.new("Frame", gui)
keyboard.Size = UDim2.new(1,0,0.3,0)
keyboard.Position = UDim2.new(0,0,1,0)
keyboard.BackgroundColor3 = Color3.fromRGB(20,20,20)

-- TOGGLE BUTTON
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0,50,0,50)
toggle.Position = UDim2.new(0,10,0.6,0)
toggle.Text = "⌨"

local opened = false

toggle.MouseButton1Click:Connect(function()
    opened = not opened
    local pos = opened and UDim2.new(0,0,0.7,0) or UDim2.new(0,0,1,0)
    TweenService:Create(keyboard, TweenInfo.new(0.3), {Position = pos}):Play()
end)

-- TEXT STORAGE
local currentText = ""

local function updateText()
    textLabel.Text = currentText
end

-- SEND CHAT
local function sendMessage(msg)
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if channel then
            channel:SendAsync(msg)
        end
    else
        game:GetService("ReplicatedStorage")
        :WaitForChild("DefaultChatSystemChatEvents")
        .SayMessageRequest:FireServer(msg, "All")
    end
end

-- CREATE BUTTON
local function createKey(text, x, y)
    local btn = Instance.new("TextButton", keyboard)
    btn.Size = UDim2.new(0,40,0,40)
    btn.Position = UDim2.new(0,x,0,y)
    btn.Text = text

    btn.MouseButton1Click:Connect(function()
        currentText = currentText .. text
        updateText()
    end)
end

-- ROW 1
local keys = {"Q","W","E","R","T","Y","U","I","O","P"}
for i,v in pairs(keys) do
    createKey(v, (i-1)*42, 10)
end

-- ROW 2
keys = {"A","S","D","F","G","H","J","K","L"}
for i,v in pairs(keys) do
    createKey(v, (i-1)*42+20, 60)
end

-- ROW 3
keys = {"Z","X","C","V","B","N","M"}
for i,v in pairs(keys) do
    createKey(v, (i-1)*42+60, 110)
end

-- SPACE
local space = Instance.new("TextButton", keyboard)
space.Size = UDim2.new(0,200,0,40)
space.Position = UDim2.new(0,100,0,160)
space.Text = "SPACE"
space.MouseButton1Click:Connect(function()
    currentText = currentText .. " "
    updateText()
end)

-- BACKSPACE
local back = Instance.new("TextButton", keyboard)
back.Size = UDim2.new(0,80,0,40)
back.Position = UDim2.new(0,320,0,160)
back.Text = "DEL"
back.MouseButton1Click:Connect(function()
    currentText = currentText:sub(1, -2)
    updateText()
end)

-- ENTER
local enter = Instance.new("TextButton", keyboard)
enter.Size = UDim2.new(0,80,0,40)
enter.Position = UDim2.new(0,10,0,160)
enter.Text = "ENTER"
enter.MouseButton1Click:Connect(function()
    sendMessage(currentText)
    currentText = ""
    updateText()
end)
