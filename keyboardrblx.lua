-- KEYBOARD ROBLOX (COMPACT + CENTER PERFECT)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "KeyboardUI"
gui.ResetOnSpawn = false

-- MAIN KEYBOARD (UKURAN KECIL)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 500, 0, 280)
main.Position = UDim2.new(0.5, -250, 1, -280)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.ClipsDescendants = true

-- TOP BAR
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
topBar.BorderSizePixel = 0

-- INPUT TEXT
local textBox = Instance.new("TextLabel", topBar)
textBox.Size = UDim2.new(0, 250, 0, 30)
textBox.Position = UDim2.new(0, 10, 0, 5)
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textBox.TextColor3 = Color3.new(1, 1, 1)
textBox.Text = ""
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 18
textBox.TextXAlignment = Enum.TextXAlignment.Left

-- CAPSLOCK INDICATOR
local capsLockLabel = Instance.new("TextLabel", topBar)
capsLockLabel.Size = UDim2.new(0, 40, 0, 25)
capsLockLabel.Position = UDim2.new(0, 270, 0, 8)
capsLockLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
capsLockLabel.TextColor3 = Color3.new(1, 1, 1)
capsLockLabel.Text = "abc"
capsLockLabel.TextSize = 14

-- SEND BUTTON
local sendBtn = Instance.new("TextButton", topBar)
sendBtn.Size = UDim2.new(0, 70, 0, 30)
sendBtn.Position = UDim2.new(0, 320, 0, 5)
sendBtn.Text = "Kirim"
sendBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sendBtn.TextColor3 = Color3.new(1, 1, 1)
sendBtn.TextSize = 16

-- MINIMIZE BUTTON
local minimize = Instance.new("TextButton", topBar)
minimize.Size = UDim2.new(0, 40, 0, 30)
minimize.Position = UDim2.new(0, 450, 0, 5)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.TextSize = 20

-- KEYBOARD CONTAINER
local keyboardArea = Instance.new("Frame", main)
keyboardArea.Size = UDim2.new(1, 0, 1, -40)
keyboardArea.Position = UDim2.new(0, 0, 0, 40)
keyboardArea.BackgroundTransparency = 1

-- ============ BARIS 1 (ANGKA) ============
local row1 = Instance.new("Frame", keyboardArea)
row1.Size = UDim2.new(1, -20, 0, 40)
row1.Position = UDim2.new(0, 10, 0, 5)
row1.BackgroundTransparency = 1

local function createRowButtons(parent, buttons, onClick, bgColor)
    local btnWidth = (parent.AbsoluteSize.X - (#buttons - 1) * 4) / #buttons
    for i, btnText in ipairs(buttons) do
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, btnWidth, 1, 0)
        btn.Position = UDim2.new(0, (btnWidth + 4) * (i-1), 0, 0)
        btn.Text = btnText
        btn.BackgroundColor3 = bgColor or Color3.fromRGB(55, 55, 55)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 18
        btn.BorderSizePixel = 0
        btn.MouseButton1Click:Connect(function()
            onClick(btnText)
        end)
    end
end

local function clearRow(row)
    for _, child in ipairs(row:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

-- VARIABLES
local currentText = ""
local capsLock = false
local symbolMode = false

local function updateText()
    textBox.Text = currentText
end

local function sendMessage(msg)
    if msg == "" then return end
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if channel then
            channel:SendAsync(msg)
        end
    else
        game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents").SayMessageRequest:FireServer(msg, "All")
    end
end

-- DATA
local angka = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}
local huruf2 = {"Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"}
local huruf3 = {"A", "S", "D", "F", "G", "H", "J", "K", "L"}
local huruf4 = {"Z", "X", "C", "V", "B", "N", "M"}

local simbol1 = {"!", "@", "#", "$", "%", "^", "&", "*", "(", ")"}
local simbol2 = {"-", "_", "=", "+", "[", "]", "{", "}", "\\", "|"}
local simbol3 = {";", ":", "'", '"', ",", ".", "<", ">", "/", "?"}
local simbol4 = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}

local function refreshKeyboard()
    clearRow(row1)
    
    -- Hapus baris 2,3,4,5 jika ada
    for i = 2, 5 do
        local row = keyboardArea:FindFirstChild("row"..i)
        if row then
            clearRow(row)
        end
    end
    
    if symbolMode then
        -- MODE SIMBOL
        local row2 = Instance.new("Frame", keyboardArea)
        row2.Name = "row2"
        row2.Size = UDim2.new(1, -20, 0, 40)
        row2.Position = UDim2.new(0, 10, 0, 50)
        row2.BackgroundTransparency = 1
        
        local row3 = Instance.new("Frame", keyboardArea)
        row3.Name = "row3"
        row3.Size = UDim2.new(1, -20, 0, 40)
        row3.Position = UDim2.new(0, 10, 0, 95)
        row3.BackgroundTransparency = 1
        
        local row4 = Instance.new("Frame", keyboardArea)
        row4.Name = "row4"
        row4.Size = UDim2.new(1, -20, 0, 40)
        row4.Position = UDim2.new(0, 10, 0, 140)
        row4.BackgroundTransparency = 1
        
        local row5 = Instance.new("Frame", keyboardArea)
        row5.Name = "row5"
        row5.Size = UDim2.new(1, -20, 0, 40)
        row5.Position = UDim2.new(0, 10, 0, 185)
        row5.BackgroundTransparency = 1
        
        createRowButtons(row1, simbol1, function(t) currentText = currentText .. t updateText() end, Color3.fromRGB(70, 70, 70))
        createRowButtons(row2, simbol2, function(t) currentText = currentText .. t updateText() end, Color3.fromRGB(70, 70, 70))
        createRowButtons(row3, simbol3, function(t) currentText = currentText .. t updateText() end, Color3.fromRGB(70, 70, 70))
        createRowButtons(row4, simbol4, function(t) currentText = currentText .. t updateText() end, Color3.fromRGB(60, 60, 80))
        
        -- Tombol bawah
        local bawah = {"ABC", "SPACE", "⌫", "CLEAR"}
        createRowButtons(row5, bawah, function(t)
            if t == "ABC" then
                symbolMode = false
                refreshKeyboard()
            elseif t == "SPACE" then
                currentText = currentText .. " "
                updateText()
            elseif t == "⌫" then
                currentText = currentText:sub(1, -2)
                updateText()
            elseif t == "CLEAR" then
                currentText = ""
                updateText()
            end
        end, Color3.fromRGB(80, 80, 80))
        
    else
        -- MODE HURUF
        local row2 = Instance.new("Frame", keyboardArea)
        row2.Name = "row2"
        row2.Size = UDim2.new(1, -20, 0, 40)
        row2.Position = UDim2.new(0, 10, 0, 50)
        row2.BackgroundTransparency = 1
        
        local row3 = Instance.new("Frame", keyboardArea)
        row3.Name = "row3"
        row3.Size = UDim2.new(0.85, -20, 0, 40)
        row3.Position = UDim2.new(0.075, 10, 0, 95)
        row3.BackgroundTransparency = 1
        
        local row4 = Instance.new("Frame", keyboardArea)
        row4.Name = "row4"
        row4.Size = UDim2.new(0.7, -20, 0, 40)
        row4.Position = UDim2.new(0.15, 10, 0, 140)
        row4.BackgroundTransparency = 1
        
        local row5 = Instance.new("Frame", keyboardArea)
        row5.Name = "row5"
        row5.Size = UDim2.new(1, -20, 0, 40)
        row5.Position = UDim2.new(0, 10, 0, 185)
        row5.BackgroundTransparency = 1
        
        -- Angka
        createRowButtons(row1, angka, function(t) currentText = currentText .. t updateText() end, Color3.fromRGB(60, 60, 80))
        
        -- Huruf baris 2
        local huruf2Display = huruf2
        if capsLock then
            createRowButtons(row2, huruf2, function(t) currentText = currentText .. t updateText() end, Color3.fromRGB(55, 55, 55))
        else
            local lower = {"q", "w", "e", "r", "t", "y", "u", "i", "o", "p"}
            createRowButtons(row2, lower, function(t) currentText = currentText .. t updateText() end, Color3.fromRGB(55, 55, 55))
        end
        
        -- Huruf baris 3
        if capsLock then
            createRowButtons(row3, huruf3, function(t) currentText = currentText .. t updateText() end, Color3.fromRGB(55, 55, 55))
        else
            local lower = {"a", "s", "d", "f", "g", "h", "j", "k", "l"}
            createRowButtons(row3, lower, function(t) currentText = currentText .. t updateText() end, Color3.fromRGB(55, 55, 55))
        end
        
        -- Huruf baris 4
        if capsLock then
            createRowButtons(row4, huruf4, function(t) currentText = currentText .. t updateText() end, Color3.fromRGB(55, 55, 55))
        else
            local lower = {"z", "x", "c", "v", "b", "n", "m"}
            createRowButtons(row4, lower, function(t) currentText = currentText .. t updateText() end, Color3.fromRGB(55, 55, 55))
        end
        
        -- Tombol bawah
        local bawah = {"CAPS", "?!#", "SPACE", "⌫", "CLEAR"}
        createRowButtons(row5, bawah, function(t)
            if t == "CAPS" then
                capsLock = not capsLock
                if capsLock then
                    capsLockLabel.Text = "ABC"
                    capsLockLabel.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
                else
                    capsLockLabel.Text = "abc"
                    capsLockLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                end
                refreshKeyboard()
            elseif t == "?!#" then
                symbolMode = true
                refreshKeyboard()
            elseif t == "SPACE" then
                currentText = currentText .. " "
                updateText()
            elseif t == "⌫" then
                currentText = currentText:sub(1, -2)
                updateText()
            elseif t == "CLEAR" then
                currentText = ""
                updateText()
            end
        end, Color3.fromRGB(80, 80, 80))
    end
end

-- FLOATING BUBBLE (KECIL)
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0, 45, 0, 45)
bubble.Position = UDim2.new(0, 10, 0.65, 0)
bubble.Text = "⌨"
bubble.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
bubble.TextColor3 = Color3.new(1, 1, 1)
bubble.TextSize = 25
bubble.BorderSizePixel = 0

-- DRAG BUBBLE
local dragStart, startPos, dragging = nil, nil, false

bubble.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        bubble.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

bubble.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.2), {Position = UDim2.new(0.5, -250, 0.5, -140)}):Play()
end)

minimize.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.2), {Position = UDim2.new(0.5, -250, 1, -280)}):Play()
end)

sendBtn.MouseButton1Click:Connect(function()
    sendMessage(currentText)
    currentText = ""
    updateText()
end)

refreshKeyboard()
