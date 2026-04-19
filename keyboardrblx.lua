-- KEYBOARD ROBLOX UI RAPI (FULL BAWAH)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "KeyboardUI"

-- TEXT DISPLAY
local textBox = Instance.new("TextLabel", gui)
textBox.Size = UDim2.new(1, -20, 0, 50)
textBox.Position = UDim2.new(0, 10, 1, -220)
textBox.BackgroundColor3 = Color3.fromRGB(25,25,25)
textBox.TextColor3 = Color3.new(1,1,1)
textBox.TextScaled = true
textBox.Text = ""
textBox.BorderSizePixel = 0

-- KEYBOARD CONTAINER
local keyboard = Instance.new("Frame", gui)
keyboard.Size = UDim2.new(1, 0, 0, 200)
keyboard.Position = UDim2.new(0, 0, 1, 0)
keyboard.BackgroundColor3 = Color3.fromRGB(15,15,15)
keyboard.BorderSizePixel = 0

-- GRID
local grid = Instance.new("UIGridLayout", keyboard)
grid.CellSize = UDim2.new(0.09, 0, 0.2, 0)
grid.CellPadding = UDim2.new(0.01, 0, 0.02, 0)
grid.SortOrder = Enum.SortOrder.LayoutOrder

-- TOGGLE BUTTON
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0,50,0,50)
toggle.Position = UDim2.new(0,10,1,-270)
toggle.Text = "⌨"
toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)

local opened = false

toggle.MouseButton1Click:Connect(function()
    opened = not opened
    local pos = opened and UDim2.new(0,0,1,-200) or UDim2.new(0,0,1,0)
    TweenService:Create(keyboard, TweenInfo.new(0.3), {Position = pos}):Play()
end)

-- TEXT STORAGE
local currentText = ""

local function updateText()
    textBox.Text = currentText
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

-- CREATE KEY FUNCTION
local function createKey(label, callback)
    local btn = Instance.new("TextButton")
    btn.Text = label
    btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = keyboard
    btn.BorderSizePixel = 0

    btn.MouseButton1Click:Connect(callback)
end

-- LETTER KEYS
local letters = {
    "Q","W","E","R","T","Y","U","I","O","P",
    "A","S","D","F","G","H","J","K","L",
    "Z","X","C","V","B","N","M"
}

for _, key in ipairs(letters) do
    createKey(key, function()
        currentText = currentText .. key
        updateText()
    end)
end

-- SPACE
createKey("SPACE", function()
    currentText = currentText .. " "
    updateText()
end)

-- BACKSPACE
createKey("DEL", function()
    currentText = currentText:sub(1, -2)
    updateText()
end)

-- ENTER
createKey("ENTER", function()
    sendMessage(currentText)
    currentText = ""
    updateText()
end)
