-- KEYBOARD ROBLOX QWERTY LIKE GBOARD (FLOATING + CAPSLOCK + SYMBOL)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "KeyboardUI"

-- MAIN KEYBOARD
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(1,0,0,350)
main.Position = UDim2.new(0,0,1,0)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0

-- TOP BAR
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1,0,0,55)
topBar.BackgroundColor3 = Color3.fromRGB(30,30,30)

-- INPUT TEXT
local textBox = Instance.new("TextLabel", topBar)
textBox.Size = UDim2.new(0.5, -10, 1, -10)
textBox.Position = UDim2.new(0,10,0,5)
textBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
textBox.TextColor3 = Color3.new(1,1,1)
textBox.TextScaled = true
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.Text = ""

-- CAPSLOCK INDICATOR
local capsLockLabel = Instance.new("TextLabel", topBar)
capsLockLabel.Size = UDim2.new(0.08, 0, 0.5, 0)
capsLockLabel.Position = UDim2.new(0.52, 5, 0.25, 0)
capsLockLabel.BackgroundColor3 = Color3.fromRGB(60,60,60)
capsLockLabel.TextColor3 = Color3.new(1,1,1)
capsLockLabel.Text = "abc"
capsLockLabel.TextScaled = true

-- SEND BUTTON
local sendBtn = Instance.new("TextButton", topBar)
sendBtn.Size = UDim2.new(0.12, -5, 1, -10)
sendBtn.Position = UDim2.new(0.62, 5, 0,5)
sendBtn.Text = "KIRIM"
sendBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
sendBtn.TextColor3 = Color3.new(1,1,1)
sendBtn.TextScaled = true

-- MINIMIZE BUTTON
local minimize = Instance.new("TextButton", topBar)
minimize.Size = UDim2.new(0.1, -5, 1, -10)
minimize.Position = UDim2.new(0.85,5,0,5)
minimize.Text = "−"
minimize.BackgroundColor3 = Color3.fromRGB(200,80,80)
minimize.TextScaled = true

-- KEYBOARD AREA
local keyboardContainer = Instance.new("Frame", main)
keyboardContainer.Size = UDim2.new(1,0,1,-55)
keyboardContainer.Position = UDim2.new(0,0,0,55)
keyboardContainer.BackgroundTransparency = 1

-- ============ BARIS 1 (QWERTYUIOP) ============
local row1 = Instance.new("Frame", keyboardContainer)
row1.Size = UDim2.new(1,0,0,60)
row1.Position = UDim2.new(0,0,0,5)
row1.BackgroundTransparency = 1

local row1Layout = Instance.new("UIGridLayout", row1)
row1Layout.CellSize = UDim2.new(0.09, -2, 1, -4)
row1Layout.CellPadding = UDim2.new(0,2,0,0)

-- ============ BARIS 2 (ASDFGHJKL) ============
local row2 = Instance.new("Frame", keyboardContainer)
row2.Size = UDim2.new(1,0,0,60)
row2.Position = UDim2.new(0,0,0,70)
row2.BackgroundTransparency = 1

local row2Layout = Instance.new("UIGridLayout", row2)
row2Layout.CellSize = UDim2.new(0.09, -2, 1, -4)
row2Layout.CellPadding = UDim2.new(0,2,0,0)

-- ============ BARIS 3 (ZXCVBNM) ============
local row3 = Instance.new("Frame", keyboardContainer)
row3.Size = UDim2.new(1,0,0,60)
row3.Position = UDim2.new(0,0,0,135)
row3.BackgroundTransparency = 1

local row3Layout = Instance.new("UIGridLayout", row3)
row3Layout.CellSize = UDim2.new(0.09, -2, 1, -4)
row3Layout.CellPadding = UDim2.new(0,2,0,0)

-- ============ BARIS 4 (Tombol Khusus) ============
local row4 = Instance.new("Frame", keyboardContainer)
row4.Size = UDim2.new(1,0,0,60)
row4.Position = UDim2.new(0,0,0,200)
row4.BackgroundTransparency = 1

local row4Layout = Instance.new("UIGridLayout", row4)
row4Layout.CellSize = UDim2.new(0.18, -2, 1, -4)
row4Layout.CellPadding = UDim2.new(0,2,0,0)

-- FLOATING BUBBLE
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0,60,0,60)
bubble.Position = UDim2.new(0,50,0.5,0)
bubble.Text = "⌨"
bubble.BackgroundColor3 = Color3.fromRGB(0,170,255)
bubble.TextScaled = true

-- DRAG SYSTEM
local dragging = false
local dragStart
local startPos

local function updateDrag(input)
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

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)

-- VARIABLES
local currentText = ""
local capsLock = false
local showSymbols = false

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

-- FUNGSI MEMBUAT TOMBOL
local function createButton(parent, text, bgColor, onClick, widthScale)
    local btn = Instance.new("TextButton", parent)
    btn.Text = text
    btn.BackgroundColor3 = bgColor or Color3.fromRGB(55,55,55)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    
    if widthScale then
        btn.Size = UDim2.new(widthScale, 0, 1, -4)
        local layout = parent:FindFirstChildWhichIsA("UIGridLayout")
        if layout then
            layout:Remove()
        end
    end
    
    btn.MouseButton1Click:Connect(onClick)
    return btn
end

-- HURUF
local row1LettersLower = {"q","w","e","r","t","y","u","i","o","p"}
local row1LettersUpper = {"Q","W","E","R","T","Y","U","I","O","P"}
local row2LettersLower = {"a","s","d","f","g","h","j","k","l"}
local row2LettersUpper = {"A","S","D","F","G","H","J","K","L"}
local row3LettersLower = {"z","x","c","v","b","n","m"}
local row3LettersUpper = {"Z","X","C","V","B","N","M"}

-- SIMBOL (mode simbol)
local symbolRow1 = {"!", "@", "#", "$", "%", "^", "&", "*", "(", ")"}
local symbolRow2 = {"-", "_", "=", "+", "[", "]", "{", "}", "\\", "|"}
local symbolRow3 = {";", ":", "'", '"', ",", ".", "<", ">", "/", "?"}

-- ANGKA
local numberRow = {"1","2","3","4","5","6","7","8","9","0"}

-- Fungsi refresh keyboard
local function refreshKeyboard()
    -- Hapus semua tombol
    for _, row in ipairs({row1, row2, row3, row4}) do
        for _, child in ipairs(row:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
    end
    
    if showSymbols then
        -- MODE SIMBOL
        for i, sym in ipairs(symbolRow1) do
            createButton(row1, sym, Color3.fromRGB(70,70,70), function()
                currentText = currentText .. sym
                updateText()
            end)
        end
        
        for i, sym in ipairs(symbolRow2) do
            createButton(row2, sym, Color3.fromRGB(70,70,70), function()
                currentText = currentText .. sym
                updateText()
            end)
        end
        
        for i, sym in ipairs(symbolRow3) do
            createButton(row3, sym, Color3.fromRGB(70,70,70), function()
                currentText = currentText .. sym
                updateText()
            end)
        end
    else
        -- MODE HURUF (QWERTY)
        local row1Letters = capsLock and row1LettersUpper or row1LettersLower
        local row2Letters = capsLock and row2LettersUpper or row2LettersLower
        local row3Letters = capsLock and row3LettersUpper or row3LettersLower
        
        for i, letter in ipairs(row1Letters) do
            createButton(row1, letter, Color3.fromRGB(55,55,55), function()
                currentText = currentText .. letter
                updateText()
            end)
        end
        
        for i, letter in ipairs(row2Letters) do
            createButton(row2, letter, Color3.fromRGB(55,55,55), function()
                currentText = currentText .. letter
                updateText()
            end)
        end
        
        for i, letter in ipairs(row3Letters) do
            createButton(row3, letter, Color3.fromRGB(55,55,55), function()
                currentText = currentText .. letter
                updateText()
            end)
        end
    end
    
    -- ANGKA (selalu di baris 3 atau 4 tergantung mode)
    if showSymbols then
        for i, num in ipairs(numberRow) do
            createButton(row4, num, Color3.fromRGB(60,60,80), function()
                currentText = currentText .. num
                updateText()
            end)
        end
    else
        -- Tombol tambahan di baris 4
        -- Tombol CAPS
        createButton(row4, "CAPS", capsLock and Color3.fromRGB(0,150,0) or Color3.fromRGB(80,80,80), function()
            capsLock = not capsLock
            if capsLock then
                capsLockLabel.Text = "ABC"
                capsLockLabel.BackgroundColor3 = Color3.fromRGB(0,170,0)
            else
                capsLockLabel.Text = "abc"
                capsLockLabel.BackgroundColor3 = Color3.fromRGB(60,60,60)
            end
            refreshKeyboard()
        end, 0.15)
        
        -- Tombol SYMBOL
        createButton(row4, "?!#", Color3.fromRGB(80,80,80), function()
            showSymbols = true
            refreshKeyboard()
        end, 0.15)
        
        -- SPACE
        createButton(row4, "SPACE", Color3.fromRGB(70,70,90), function()
            currentText = currentText .. " "
            updateText()
        end, 0.3)
        
        -- DEL
        createButton(row4, "⌫", Color3.fromRGB(180,60,60), function()
            currentText = currentText:sub(1,-2)
            updateText()
        end, 0.12)
        
        -- CLEAR
        createButton(row4, "CLEAR", Color3.fromRGB(180,100,60), function()
            currentText = ""
            updateText()
        end, 0.12)
        
        -- Tombol kembali ke huruf jika di mode simbol (tidak dipakai di mode huruf)
    end
    
    -- Tombol khusus untuk mode simbol (kembali ke huruf)
    if showSymbols then
        -- Hapus tombol angka yang sudah dibuat di row4
        for _, child in ipairs(row4:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        -- Tombol ABC (kembali ke huruf)
        createButton(row4, "ABC", Color3.fromRGB(0,150,150), function()
            showSymbols = false
            refreshKeyboard()
        end, 0.15)
        
        -- SPACE
        createButton(row4, "SPACE", Color3.fromRGB(70,70,90), function()
            currentText = currentText .. " "
            updateText()
        end, 0.35)
        
        -- DEL
        createButton(row4, "⌫", Color3.fromRGB(180,60,60), function()
            currentText = currentText:sub(1,-2)
            updateText()
        end, 0.15)
        
        -- CLEAR
        createButton(row4, "CLEAR", Color3.fromRGB(180,100,60), function()
            currentText = ""
            updateText()
        end, 0.15)
        
        -- Angka (tambahkan setelah tombol khusus)
        for i, num in ipairs(numberRow) do
            createButton(row4, num, Color3.fromRGB(60,60,80), function()
                currentText = currentText .. num
                updateText()
            end)
        end
    end
end

-- BUTTON EVENTS
sendBtn.MouseButton1Click:Connect(function()
    sendMessage(currentText)
    currentText = ""
    updateText()
end)

bubble.MouseButton1Click:Connect(function()
    local targetPos = main.Position.Y.Offset == 0 and -350 or 0
    TweenService:Create(main, TweenInfo.new(0.3), {
        Position = UDim2.new(0,0,1,targetPos)
    }):Play()
end)

minimize.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.3), {
        Position = UDim2.new(0,0,1,0)
    }):Play()
end)

-- Inisialisasi
refreshKeyboard()
