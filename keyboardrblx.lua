-- KEYBOARD ROBLOX FINAL PRO (FLOATING + ANGKA)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "KeyboardUI"

-- MAIN KEYBOARD
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(1,0,0,280)
main.Position = UDim2.new(0,0,1,0)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0

-- TOP BAR
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1,0,0,50)
topBar.BackgroundColor3 = Color3.fromRGB(30,30,30)

-- INPUT TEXT
local textBox = Instance.new("TextLabel", topBar)
textBox.Size = UDim2.new(0.65, -10, 1, -10)
textBox.Position = UDim2.new(0,10,0,5)
textBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
textBox.TextColor3 = Color3.new(1,1,1)
textBox.TextScaled = true
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.Text = ""

-- SEND BUTTON
local sendBtn = Instance.new("TextButton", topBar)
sendBtn.Size = UDim2.new(0.2, -5, 1, -10)
sendBtn.Position = UDim2.new(0.65,5,0,5)
sendBtn.Text = "KIRIM"
sendBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
sendBtn.TextColor3 = Color3.new(1,1,1)
sendBtn.TextScaled = true

-- MINIMIZE BUTTON
local minimize = Instance.new("TextButton", topBar)
minimize.Size = UDim2.new(0.15, -5, 1, -10)
minimize.Position = UDim2.new(0.85,5,0,5)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(200,80,80)
minimize.TextScaled = true

-- KEYBOARD AREA
local keyboard = Instance.new("Frame", main)
keyboard.Size = UDim2.new(1,0,1,-50)
keyboard.Position = UDim2.new(0,0,0,50)
keyboard.BackgroundTransparency = 1

local grid = Instance.new("UIGridLayout", keyboard)
grid.CellSize = UDim2.new(0.1, -5, 0.2, -5)
grid.CellPadding = UDim2.new(0,5,0,5)

-- FLOATING BUBBLE
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0,60,0,60)
bubble.Position = UDim2.new(0,50,0.5,0)
bubble.Text = "⌨"
bubble.BackgroundColor3 = Color3.fromRGB(0,170,255)
bubble.TextScaled = true

-- DRAG FIX (SUPPORT TOUCH + MOUSE)

local dragging = false
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    bubble.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

bubble.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        
        dragging = true
        dragStart = input.Position
        startPos = bubble.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

bubble.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        update(input)
    end
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

-- KEY FUNCTION
local function key(label, func)
    local btn = Instance.new("TextButton")
    btn.Text = label
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Parent = keyboard

    btn.MouseButton1Click:Connect(func)
end

-- ANGKA
for i=1,9 do
    key(tostring(i), function()
        currentText = currentText .. i
        updateText()
    end)
end
key("0", function()
    currentText = currentText .. "0"
    updateText()
end)

-- HURUF
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

-- SPECIAL
key("SPACE", function()
    currentText = currentText .. " "
    updateText()
end)

key("DEL", function()
    currentText = currentText:sub(1,-2)
    updateText()
end)

key("CLEAR", function()
    currentText = ""
    updateText()
end)

-- BUTTON EVENTS
sendBtn.MouseButton1Click:Connect(function()
    sendMessage(currentText)
    currentText = ""
    updateText()
end)

bubble.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.3), {
        Position = UDim2.new(0,0,1,-280)
    }):Play()
end)

minimize.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.3), {
        Position = UDim2.new(0,0,1,0)
    }):Play()
end)
