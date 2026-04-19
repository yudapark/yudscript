-- KEYBOARD ROBLOX (1234567890 - QWERTYUIOP - ASDFGHJKL - ZXCVBNM)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "KeyboardUI"

-- MAIN KEYBOARD
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(1,0,0,380)
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

-- ============ BARIS 1 (ANGKA) ============
local row1 = Instance.new("Frame", keyboardContainer)
row1.Size = UDim2.new(1,0,0,65)
row1.Position = UDim2.new(0,0,0,5)
row1.BackgroundTransparency = 1

local row1Layout = Instance.new("UIGridLayout", row1)
row1Layout.CellSize = UDim2.new(0.09, -2, 1, -4)
row1Layout.CellPadding = UDim2.new(0,2,0,0)

-- ============ BARIS 2 (QWERTYUIOP) ============
local row2 = Instance.new("Frame", keyboardContainer)
row2.Size = UDim2.new(1,0,0,65)
row2.Position = UDim2.new(0,0,0,75)
row2.BackgroundTransparency = 1

local row2Layout = Instance.new("UIGridLayout", row2)
row2Layout.CellSize = UDim2.new(0.09, -2, 1, -4)
row2Layout.CellPadding = UDim2.new(0,2,0,0)

-- ============ BARIS 3 (ASDFGHJKL) ============
local row3 = Instance.new("Frame", keyboardContainer)
row3.Size = UDim2.new(1,0,0,65)
row3.Position = UDim2.new(0,0,0,145)
row3.BackgroundTransparency = 1

local row3Layout = Instance.new("UIGridLayout", row3)
row3Layout.CellSize = UDim2.new(0.09, -2, 1, -4)
row3Layout.CellPadding = UDim2.new(0,2,0,0)

-- ============ BARIS 4 (ZXCVBNM + Tombol Khusus) ============
local row4 = Instance.new("Frame", keyboardContainer)
row4.Size = UDim2.new(1,0,0,65)
row4.Position = UDim2.new(0,0,0,215)
row4.BackgroundTransparency = 1

local row4Layout = Instance.new("UIGridLayout", row4)
row4Layout.CellSize = UDim2.new(0.09, -2, 1, -4)
row4Layout.CellPadding = UDim2.new(0,2,0,0)

-- ============ BARIS 5 (Tombol Bawah: CAPS, SYMBOL, SPACE, DEL, CLEAR) ============
local row5 = Instance.new("Frame", keyboardContainer)
row5.Size = UDim2.new(1,0,0,65)
row5.Position = UDim2.new(0,0,0,285)
row5.BackgroundTransparency = 1

local row5Layout = Instance.new("UIGridLayout", row5)
row5Layout.CellSize = UDim2.new(0.18, -2, 1, -4)
row5Layout.CellPadding = UDim2.new(0,2,0,0)

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
local function createButton(parent, text, bgColor, onClick)
    local btn = Instance.new("TextButton", parent)
    btn.Text = text
    btn.BackgroundColor3 = bgColor or Color3.fromRGB(55,55,55)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.MouseButton1Click:Connect(onClick)
    return btn
end

-- DATA TOMBOL
local numbers = {"1","2","3","4","5","6","7","8","9","0"}
local row2Lower = {"q","w","e","r","t","y","u","i","o","p"}
local row2Upper = {"Q","W","E","R","T","Y","U","I","O","P"}
local row3Lower = {"a","s","d","f","g","h","j","k","l"}
local row3Upper = {"A","S","D","F","G","H","J","K","L"}
local row4Lower = {"z","x","c","v","b","n","m"}
local row4Upper = {"Z","X","C","V","B","N","M"}

-- SIMBOL
local symbolRow1 = {"!", "@", "#", "$", "%", "^", "&", "*", "(", ")"}
local symbolRow2 = {"-", "_", "=", "+", "[", "]", "{", "}", "\\", "|"}
local symbolRow3 = {";", ":", "'", '"', ",", ".", "<", ">", "/", "?"}
local symbolRow4 = {"1","2","3","4","5","6","7","8","9","0"}

-- Fungsi refresh keyboard
local function refreshKeyboard()
    -- Hapus semua tombol
    for _, row in ipairs({row1, row2, row3, row4, row5}) do
        for _, child in ipairs(row:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
    end
    
    if showSymbols then
        -- ============ MODE SIMBOL ============
        -- Baris 1: simbol baris 1
        for _, sym in ipairs(symbolRow1) do
            createButton(row1, sym, Color3.fromRGB(70,70,70), function()
                currentText = currentText .. sym
                updateText()
            end)
        end
        
        -- Baris 2: simbol baris 2
        for _, sym in ipairs(symbolRow2) do
            createButton(row2, sym, Color3.fromRGB(70,70,70), function()
                currentText = currentText .. sym
                updateText()
            end)
        end
        
        -- Baris 3: simbol baris 3
        for _, sym in ipairs(symbolRow3) do
            createButton(row3, sym, Color3.fromRGB(70,70,70), function()
                currentText = currentText .. sym
                updateText()
            end)
        end
        
        -- Baris 4: angka
        for _, num in ipairs(symbolRow4) do
            createButton(row4, num, Color3.fromRGB(60,60,80), function()
                currentText = currentText .. num
                updateText()
            end)
        end
        
        -- Baris 5: tombol kembali ke huruf
        createButton(row5, "ABC", Color3.fromRGB(0,150,150), function()
            showSymbols = false
            refreshKeyboard()
        end)
        
        createButton(row5, "SPACE", Color3.fromRGB(70,70,90), function()
            currentText = currentText .. " "
            updateText()
        end)
        
        createButton(row5, "⌫", Color3.fromRGB(180,60,60), function()
            currentText = currentText:sub(1,-2)
            updateText()
        end)
        
        createButton(row5, "CLEAR", Color3.fromRGB(180,100,60), function()
            currentText = ""
            updateText()
        end)
        
    else
        -- ============ MODE HURUF ============
        -- Baris 1: ANGKA 1 2 3 4 5 6 7 8 9 0
        for _, num in ipairs(numbers) do
            createButton(row1, num, Color3.fromRGB(60,60,80), function()
                currentText = currentText .. num
                updateText()
            end)
        end
        
        -- Baris 2: Q W E R T Y U I O P
        local lettersRow2 = capsLock and row2Upper or row2Lower
        for _, letter in ipairs(lettersRow2) do
            createButton(row2, letter, Color3.fromRGB(55,55,55), function()
                currentText = currentText .. letter
                updateText()
            end)
        end
        
        -- Baris 3: A S D F G H J K L
        local lettersRow3 = capsLock and row3Upper or row3Lower
        for _, letter in ipairs(lettersRow3) do
            createButton(row3, letter, Color3.fromRGB(55,55,55), function()
                currentText = currentText .. letter
                updateText()
            end)
        end
        
        -- Baris 4: Z X C V B N M
        local lettersRow4 = capsLock and row4Upper or row4Lower
        for _, letter in ipairs(lettersRow4) do
            createButton(row4, letter, Color3.fromRGB(55,55,55), function()
                currentText = currentText .. letter
                updateText()
            end)
        end
        
        -- Tambahkan tombol kosong di baris 4 untuk melengkapi 10 slot (karena ZXCVBNM cuma 7)
        for i = 1, 3 do
            local emptyBtn = Instance.new("TextButton", row4)
            emptyBtn.Text = ""
            emptyBtn.BackgroundColor3 = Color3.fromRGB(18,18,18)
            emptyBtn.TextScaled = true
            emptyBtn.AutoButtonColor = false
        end
        
        -- Baris 5: CAPS, SYMBOL, SPACE, DEL, CLEAR
        -- CAPS
        createButton(row5, "CAPS", capsLock and Color3.fromRGB(0,150,0) or Color3.fromRGB(80,80,80), function()
            capsLock = not capsLock
            if capsLock then
                capsLockLabel.Text = "ABC"
                capsLockLabel.BackgroundColor3 = Color3.fromRGB(0,170,0)
            else
                capsLockLabel.Text = "abc"
                capsLockLabel.BackgroundColor3 = Color3.fromRGB(60,60,60)
            end
            refreshKeyboard()
        end)
        
        -- SYMBOL
        createButton(row5, "?!#", Color3.fromRGB(80,80,80), function()
            showSymbols = true
            refreshKeyboard()
        end)
        
        -- SPACE
        createButton(row5, "SPACE", Color3.fromRGB(70,70,90), function()
            currentText = currentText .. " "
            updateText()
        end)
        
        -- DEL
        createButton(row5, "⌫", Color3.fromRGB(180,60,60), function()
            currentText = currentText:sub(1,-2)
            updateText()
        end)
        
        -- CLEAR
        createButton(row5, "CLEAR", Color3.fromRGB(180,100,60), function()
            currentText = ""
            updateText()
        end)
    end
end

-- BUTTON EVENTS
sendBtn.MouseButton1Click:Connect(function()
    sendMessage(currentText)
    currentText = ""
    updateText()
end)

bubble.MouseButton1Click:Connect(function()
    local targetPos = main.Position.Y.Offset == 0 and -380 or 0
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
