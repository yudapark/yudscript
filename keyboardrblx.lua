local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "KeyboardUI"

-- MAIN
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(1,0,0,300)
main.Position = UDim2.new(0,0,1,0)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)

-- TOP BAR
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1,0,0,50)
topBar.BackgroundColor3 = Color3.fromRGB(30,30,30)

-- TEXT
local textBox = Instance.new("TextLabel", topBar)
textBox.Size = UDim2.new(0.6,-10,1,-10)
textBox.Position = UDim2.new(0,10,0,5)
textBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
textBox.TextColor3 = Color3.new(1,1,1)
textBox.TextScaled = true
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.Text = ""

-- SEND
local sendBtn = Instance.new("TextButton", topBar)
sendBtn.Size = UDim2.new(0.2,-5,1,-10)
sendBtn.Position = UDim2.new(0.6,5,0,5)
sendBtn.Text = "KIRIM"
sendBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
sendBtn.TextScaled = true

-- MINIMIZE
local minimize = Instance.new("TextButton", topBar)
minimize.Size = UDim2.new(0.2,-5,1,-10)
minimize.Position = UDim2.new(0.8,5,0,5)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(200,80,80)
minimize.TextScaled = true

-- KEYBOARD
local keyboard = Instance.new("Frame", main)
keyboard.Size = UDim2.new(1,0,1,-50)
keyboard.Position = UDim2.new(0,0,0,50)
keyboard.BackgroundTransparency = 1

local grid = Instance.new("UIGridLayout", keyboard)
grid.CellSize = UDim2.new(0.1,-5,0.18,-5)
grid.CellPadding = UDim2.new(0,5,0,5)

-- FLOATING BUBBLE
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0,60,0,60)
bubble.Position = UDim2.new(0,50,0.5,0)
bubble.Text = "⌨"
bubble.BackgroundColor3 = Color3.fromRGB(0,170,255)
bubble.TextScaled = true
bubble.Active = true
bubble.ZIndex = 999

-- DRAG FIX
local dragging = false
local dragStart
local startPos

bubble.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch 
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        
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
    if dragging then
        local delta = input.Position - dragStart
        bubble.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- TEXT LOGIC
local currentText = ""
local isCaps = false
local isSymbol = false

local function updateText()
    textBox.Text = currentText
end

local function formatKey(k)
    if isSymbol then return k end
    return isCaps and k:upper() or k:lower()
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
local function key(label, func, size)
    local btn = Instance.new("TextButton")
    btn.Size = size or UDim2.new(0.1,-5,0.18,-5)
    btn.Text = label
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Parent = keyboard
    btn.MouseButton1Click:Connect(func)
end

-- NUM / SYMBOL
local numbers = {"1","2","3","4","5","6","7","8","9","0"}
local symbols = {"!","@","#","$","%","^","&","*","(",")"}

for i=1,10 do
    key(numbers[i], function()
        local val = isSymbol and symbols[i] or numbers[i]
        currentText = currentText .. val
        updateText()
    end)
end

-- LETTERS
local letters = {
"q","w","e","r","t","y","u","i","o","p",
"a","s","d","f","g","h","j","k","l",
"z","x","c","v","b","n","m"
}

for _,k in ipairs(letters) do
    key(k, function()
        currentText = currentText .. formatKey(k)
        updateText()
    end)
end

-- SPECIAL KEYS
key("CAPS", function()
    isCaps = not isCaps
end)

key("?123", function()
    isSymbol = not isSymbol
end)

key("DEL", function()
    currentText = currentText:sub(1,-2)
    updateText()
end)

key("CLEAR", function()
    currentText = ""
    updateText()
end)

-- SPACE PANJANG
local space = Instance.new("TextButton")
space.Size = UDim2.new(0.5,-5,0.18,-5)
space.Text = "SPACE"
space.BackgroundColor3 = Color3.fromRGB(70,70,70)
space.TextColor3 = Color3.new(1,1,1)
space.TextScaled = true
space.Parent = keyboard

space.MouseButton1Click:Connect(function()
    currentText = currentText .. " "
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
        Position = UDim2.new(0,0,1,-300)
    }):Play()
end)

minimize.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.3), {
        Position = UDim2.new(0,0,1,0)
    }):Play()
end)
