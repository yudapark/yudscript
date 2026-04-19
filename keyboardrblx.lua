-- KEYBOARD FINAL QWERTY + SIZE RAPI

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

-- MAIN
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(1,0,0,280)
main.Position = UDim2.new(0,0,1,0)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)

-- TOP BAR
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1,0,0,45)
topBar.BackgroundColor3 = Color3.fromRGB(30,30,30)

local textBox = Instance.new("TextLabel", topBar)
textBox.Size = UDim2.new(0.6,-10,1,-10)
textBox.Position = UDim2.new(0,10,0,5)
textBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
textBox.TextColor3 = Color3.new(1,1,1)
textBox.TextScaled = true
textBox.TextXAlignment = Enum.TextXAlignment.Left

local sendBtn = Instance.new("TextButton", topBar)
sendBtn.Size = UDim2.new(0.2,-5,1,-10)
sendBtn.Position = UDim2.new(0.6,5,0,5)
sendBtn.Text = "KIRIM"
sendBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)

local minimize = Instance.new("TextButton", topBar)
minimize.Size = UDim2.new(0.2,-5,1,-10)
minimize.Position = UDim2.new(0.8,5,0,5)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(200,80,80)

-- KEYBOARD
local keyboard = Instance.new("Frame", main)
keyboard.Size = UDim2.new(1,0,1,-45)
keyboard.Position = UDim2.new(0,0,0,45)

-- BUBBLE
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0,55,0,55)
bubble.Position = UDim2.new(0,50,0.5,0)
bubble.Text = "⌨"
bubble.BackgroundColor3 = Color3.fromRGB(0,170,255)
bubble.Active = true

-- DRAG
local dragging = false
local dragStart, startPos

bubble.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = bubble.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

bubble.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        bubble.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- LOGIC
local currentText = ""
local isCaps = false
local isSymbol = false
local letterButtons = {}
local numberButtons = {}

local function updateText()
    textBox.Text = currentText
end

local function updateLetters()
    for _,btn in pairs(letterButtons) do
        btn.Text = isCaps and btn.Name:upper() or btn.Name:lower()
    end
end

local function updateNumbers()
    local nums = {"1","2","3","4","5","6","7","8","9","0"}
    local syms = {"!","@","#","$","%","^","&","*","(",")"}
    for i,btn in ipairs(numberButtons) do
        btn.Text = isSymbol and syms[i] or nums[i]
    end
end

local function sendMessage(msg)
    if msg == "" then return end
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local ch = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if ch then ch:SendAsync(msg) end
    else
        game:GetService("ReplicatedStorage")
        :WaitForChild("DefaultChatSystemChatEvents")
        .SayMessageRequest:FireServer(msg,"All")
    end
end

-- ROW
local function createRow(y)
    local row = Instance.new("Frame", keyboard)
    row.Size = UDim2.new(1,0,0.2,0)
    row.Position = UDim2.new(0,0,y,0)

    local layout = Instance.new("UIListLayout", row)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Padding = UDim.new(0,3)

    return row
end

-- KEY
local function createKey(parent, text, width, func, saveLetter, saveNumber)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(width,0,1,0)
    btn.Text = text
    btn.Name = text
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Parent = parent

    if saveLetter then table.insert(letterButtons, btn) end
    if saveNumber then table.insert(numberButtons, btn) end

    btn.MouseButton1Click:Connect(func)
end

-- ROWS
local row1 = createRow(0)
local row2 = createRow(0.2)
local row3 = createRow(0.4)
local row4 = createRow(0.6)
local row5 = createRow(0.8)

-- ANGKA
local nums = {"1","2","3","4","5","6","7","8","9","0"}
for i,v in ipairs(nums) do
    createKey(row1, v, 0.07, function()
        currentText = currentText .. numberButtons[i].Text
        updateText()
    end, false, true)
end

createKey(row1, "DEL", 0.12, function()
    currentText = currentText:sub(1,-2)
    updateText()
end)

-- QWERTY
for _,k in ipairs({"q","w","e","r","t","y","u","i","o","p"}) do
    createKey(row2, k, 0.075, function()
        currentText = currentText .. (isCaps and k:upper() or k)
        updateText()
    end, true)
end

for _,k in ipairs({"a","s","d","f","g","h","j","k","l"}) do
    createKey(row3, k, 0.085, function()
        currentText = currentText .. (isCaps and k:upper() or k)
        updateText()
    end, true)
end

createKey(row4, "CAPS", 0.13, function()
    isCaps = not isCaps
    updateLetters()
end)

for _,k in ipairs({"z","x","c","v","b","n","m"}) do
    createKey(row4, k, 0.07, function()
        currentText = currentText .. (isCaps and k:upper() or k)
        updateText()
    end, true)
end

-- BAWAH
createKey(row5, "?123", 0.18, function()
    isSymbol = not isSymbol
    updateNumbers()
end)

createKey(row5, "SPACE", 0.55, function()
    currentText = currentText .. " "
    updateText()
end)

-- BUTTON
sendBtn.MouseButton1Click:Connect(function()
    sendMessage(currentText)
    currentText = ""
    updateText()
end)

bubble.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.3), {Position = UDim2.new(0,0,1,-280)}):Play()
end)

minimize.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.3), {Position = UDim2.new(0,0,1,0)}):Play()
end)
