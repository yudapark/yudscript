-- KEYBOARD ROBLOX UI BAGUS + TOMBOL KIRIM

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "KeyboardUI"

-- MAIN CONTAINER
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(1,0,0,260)
main.Position = UDim2.new(0,0,1,0)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0

-- INPUT BAR
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1,0,0,50)
topBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
topBar.BorderSizePixel = 0

local textBox = Instance.new("TextLabel", topBar)
textBox.Size = UDim2.new(0.75, -10, 1, -10)
textBox.Position = UDim2.new(0,10,0,5)
textBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
textBox.TextColor3 = Color3.new(1,1,1)
textBox.TextScaled = true
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.Text = ""
textBox.BorderSizePixel = 0

-- SEND BUTTON
local sendBtn = Instance.new("TextButton", topBar)
sendBtn.Size = UDim2.new(0.25, -10, 1, -10)
sendBtn.Position = UDim2.new(0.75,5,0,5)
sendBtn.Text = "KIRIM"
sendBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
sendBtn.TextColor3 = Color3.new(1,1,1)
sendBtn.TextScaled = true
sendBtn.BorderSizePixel = 0

-- KEYBOARD AREA
local keyboard = Instance.new("Frame", main)
keyboard.Size = UDim2.new(1,0,1,-50)
keyboard.Position = UDim2.new(0,0,0,50)
keyboard.BackgroundTransparency = 1

local grid = Instance.new("UIGridLayout", keyboard)
grid.CellSize = UDim2.new(0.1, -5, 0.22, -5)
grid.CellPadding = UDim2.new(0,5,0,5)

-- TOGGLE BUTTON
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0,50,0,50)
toggle.Position = UDim2.new(0,10,1,-300)
toggle.Text = "⌨"
toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)

local opened = false

toggle.MouseButton1Click:Connect(function()
    opened = not opened
    local pos = opened and UDim2.new(0,0,1,-260) or UDim2.new(0,0,1,0)
    TweenService:Create(main, TweenInfo.new(0.3), {Position = pos}):Play()
end)

-- TEXT
local currentText = ""

local function updateText()
    textBox.Text = currentText
end

-- SEND CHAT
local function sendMessage(msg)
    if msg == "" then return end

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

-- BUTTON CREATE
local function key(label, func)
    local btn = Instance.new("TextButton")
    btn.Text = label
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.BorderSizePixel = 0
    btn.Parent = keyboard

    btn.MouseButton1Click:Connect(func)
end

-- LETTERS
local letters = {
"Q","W","E","R","T","Y","U","I","O","P",
"A","S","D","F","G","H","J","K","L",
"Z","X","C","V","B","N","M"
}

for _,k in ipairs(letters) do
    key(k, function()
        currentText = currentText .. k
        updateText()
    end)
end

-- SPACE
key("SPACE", function()
    currentText = currentText .. " "
    updateText()
end)

-- DELETE
key("DEL", function()
    currentText = currentText:sub(1,-2)
    updateText()
end)

-- CLEAR
key("CLEAR", function()
    currentText = ""
    updateText()
end)

-- SEND BUTTON FUNCTION
sendBtn.MouseButton1Click:Connect(function()
    sendMessage(currentText)
    currentText = ""
    updateText()
end)
