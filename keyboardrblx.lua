-- External Keyboard Mobile - FIXED & IMPROVED 2026
loadstring([[
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YudaExternalKeyboard"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ================== DRAG FUNCTION (Bisa digeser bebas + batas layar) ==================
local function makeDraggable(frame)
    local dragging = false
    local dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            -- Untuk touch drag yang lebih smooth
            if input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            local newX = startPos.X.Offset + delta.X
            local newY = startPos.Y.Offset + delta.Y
            
            -- Batasi agar tidak keluar layar
            local frameSize = frame.AbsoluteSize
            local screenSize = screenGui.AbsoluteSize
            
            newX = math.clamp(newX, 0, screenSize.X - frameSize.X)
            newY = math.clamp(newY, 0, screenSize.Y - frameSize.Y)
            
            frame.Position = UDim2.new(0, newX, 0, newY)
        end
    end)
end

-- ================== AMBIL CHAT TEXTBOX ==================
local function getChatTextBox()
    -- TextChatService (Chat baru Roblox)
    local chatInputBar = TextChatService:FindFirstChild("ChatInputBarConfiguration")
    if chatInputBar then
        local textBox = chatInputBar:FindFirstChild("TextBox")
        if textBox and textBox:IsA("TextBox") then
            return textBox
        end
    end
    
    -- Legacy Chat (Chat lama)
    local chatGui = playerGui:FindFirstChild("Chat")
    if chatGui then
        local chatBar = chatGui:FindFirstChild("ChatBar")
        if chatBar then
            local textBox = chatBar:FindFirstChild("TextBox")
            if textBox and textBox:IsA("TextBox") then
                return textBox
            end
        end
    end
    return nil
end

-- ================== FOCUS CHAT ==================
local function focusChat()
    local tb = getChatTextBox()
    if tb then
        tb.TextEditable = true
        tb:CaptureFocus()
        return tb
    end
    return nil
end

-- ================== BUBBLE ==================
local bubble = Instance.new("ImageButton")
bubble.Size = UDim2.new(0, 80, 0, 80)
bubble.Position = UDim2.new(0.85, 0, 0.6, 0)
bubble.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
bubble.BackgroundTransparency = 0
bubble.BorderSizePixel = 0
bubble.AutoButtonColor = true
bubble.Parent = screenGui

local bubbleCorner = Instance.new("UICorner", bubble)
bubbleCorner.CornerRadius = UDim.new(1, 0)

local bubbleLabel = Instance.new("TextLabel")
bubbleLabel.Size = UDim2.new(1,0,1,0)
bubbleLabel.BackgroundTransparency = 1
bubbleLabel.Text = "⌨️"
bubbleLabel.TextScaled = true
bubbleLabel.TextColor3 = Color3.new(1,1,1)
bubbleLabel.Font = Enum.Font.GothamBold
bubbleLabel.Parent = bubble

makeDraggable(bubble)

-- ================== KEYBOARD ==================
local keyboard = Instance.new("Frame")
keyboard.Size = UDim2.new(0.95, 0, 0.6, 0)
keyboard.Position = UDim2.new(0.025, 0, 0.2, 0)
keyboard.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
keyboard.BackgroundTransparency = 0
keyboard.Visible = false
keyboard.Parent = screenGui
keyboard.Active = true
keyboard.ClipsDescendants = true

local keyboardCorner = Instance.new("UICorner", keyboard)
keyboardCorner.CornerRadius = UDim.new(0, 20)

-- Shadow effect
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.BorderSizePixel = 0
shadow.ZIndex = 0
shadow.Parent = keyboard
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 20)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,45)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
titleBar.BackgroundTransparency = 0
titleBar.Parent = keyboard
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 15)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-60,1,0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⌨️ External Keyboard"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamSemibold
title.Parent = titleBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 45, 1, 0)
minBtn.Position = UDim2.new(1, -50, 0, 0)
minBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
minBtn.Text = "✕"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.TextSize = 20
minBtn.Font = Enum.Font.GothamBold
minBtn.Parent = titleBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 12)

makeDraggable(titleBar)

-- ================== KEYS ==================
local isShift = false
local isCapsLock = false
local letterBtns = {}

local keyRows = {
    {"q","w","e","r","t","y","u","i","o","p"},
    {"a","s","d","f","g","h","j","k","l"},
    {"z","x","c","v","b","n","m","⌫"},
    {"Shift", "Space", "Enter"}
}

local keysFrame = Instance.new("ScrollingFrame")
keysFrame.Size = UDim2.new(1, -20, 1, -65)
keysFrame.Position = UDim2.new(0, 10, 0, 55)
keysFrame.BackgroundTransparency = 1
keysFrame.ScrollBarThickness = 0
keysFrame.Parent = keyboard

local uiList = Instance.new("UIListLayout")
uiList.FillDirection = Enum.FillDirection.Vertical
uiList.Padding = UDim.new(0, 10)
uiList.Parent = keysFrame

-- Resize scrolling frame content
uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    keysFrame.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y)
end)

for _, row in ipairs(keyRows) do
    local rowFrame = Instance.new("Frame")
    rowFrame.Size = UDim2.new(1, 0, 0, 55)
    rowFrame.BackgroundTransparency = 1
    rowFrame.Parent = keysFrame

    local rowList = Instance.new("UIListLayout")
    rowList.FillDirection = Enum.FillDirection.Horizontal
    rowList.Padding = UDim.new(0, 8)
    rowList.Parent = rowFrame

    for _, key in ipairs(row) do
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = (key == "⌫" or key == "Enter") and Color3.fromRGB(80, 60, 60) or Color3.fromRGB(45, 45, 55)
        btn.BackgroundTransparency = 0
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextSize = 20
        btn.Font = Enum.Font.GothamSemibold
        btn.Parent = rowFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

        if key == "Space" then
            btn.Size = UDim2.new(0.55, 0, 1, 0)
            btn.Text = "SPACE"
        elseif key == "⌫" then
            btn.Size = UDim2.new(0.18, 0, 1, 0)
            btn.Text = "⌫"
            btn.BackgroundColor3 = Color3.fromRGB(80, 50, 50)
        elseif key == "Enter" then
            btn.Size = UDim2.new(0.22, 0, 1, 0)
            btn.Text = "↵"
            btn.BackgroundColor3 = Color3.fromRGB(50, 80, 50)
        elseif key == "Shift" then
            btn.Size = UDim2.new(0.18, 0, 1, 0)
            btn.Text = "⇧"
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        else
            btn.Size = UDim2.new(0.085, 0, 1, 0)
            btn.Text = key
            table.insert(letterBtns, btn)
        end

        -- Hover effect
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = btn.BackgroundColor3:Lerp(Color3.new(1,1,1), 0.2)
        end)
        
        btn.MouseLeave:Connect(function()
            if key == "⌫" or key == "Enter" then
                btn.BackgroundColor3 = (key == "⌫") and Color3.fromRGB(80, 50, 50) or Color3.fromRGB(50, 80, 50)
            elseif key == "Shift" then
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            else
                btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            end
        end)

        btn.MouseButton1Click:Connect(function()
            local tb = getChatTextBox()
            if not tb then
                -- Coba fokus chat dulu
                tb = focusChat()
                if not tb then
                    warn("⚠️ Buka chat terlebih dahulu dengan menekan '/' atau klik pada chat box!")
                    return
                end
            end

            tb.TextEditable = true
            tb:CaptureFocus()
            task.wait(0.05)

            if key == "⌫" then
                -- Hapus karakter
                if #tb.Text > 0 then
                    tb.Text = tb.Text:sub(1, -2)
                end
            elseif key == "Enter" then
                -- Simulasi Enter untuk kirim pesan
                local chatInputBar = TextChatService:FindFirstChild("ChatInputBarConfiguration")
                if chatInputBar and chatInputBar:FindFirstChild("OnTextSubmitted") then
                    -- Untuk chat baru
                    local onTextSubmitted = chatInputBar.OnTextSubmitted
                    if onTextSubmitted then
                        onTextSubmitted:Fire(tb.Text)
                    end
                end
                tb.Text = ""
            elseif key == "Space" then
                tb.Text = tb.Text .. " "
            elseif key == "Shift" then
                isShift = not isShift
                isCapsLock = false
                for _, b in ipairs(letterBtns) do
                    b.Text = isShift and b.Text:upper() or b.Text:lower()
                end
                -- Reset shift setelah mengetik satu huruf
                if isShift then
                    task.wait(0.3)
                    isShift = false
                    for _, b in ipairs(letterBtns) do
                        b.Text = b.Text:lower()
                    end
                end
            else
                local char = (isShift or isCapsLock) and key:upper() or key
                tb.Text = tb.Text .. char
                -- Reset shift setelah mengetik
                if isShift then
                    isShift = false
                    for _, b in ipairs(letterBtns) do
                        b.Text = b.Text:lower()
                    end
                end
            end

            -- Update cursor position
            tb.CursorPosition = #tb.Text + 1
        end)
    end
    
    -- Update row frame height after UIListLayout
    task.defer(function()
        rowFrame.Size = UDim2.new(1, 0, 0, rowList.AbsoluteContentSize.Y)
    end)
end

-- ================== TOGGLE ==================
bubble.MouseButton1Click:Connect(function()
    keyboard.Visible = true
    bubble.Visible = false
    -- Auto focus chat saat keyboard muncul
    task.wait(0.1)
    focusChat()
end)

minBtn.MouseButton1Click:Connect(function()
    keyboard.Visible = false
    bubble.Visible = true
end)

-- ================== AUTO HIDE WHEN TYPING ==================
local chatBox = getChatTextBox()
if chatBox then
    chatBox.Focused:Connect(function()
        -- Optional: auto hide keyboard when chat box is focused
        -- keyboard.Visible = false
    end)
end

-- ================== RESIZE HANDLER ==================
local function updateKeyboardSize()
    local screenSize = screenGui.AbsoluteSize
    if screenSize.Y > 0 then
        keyboard.Size = UDim2.new(0.95, 0, math.min(0.6, (screenSize.Y - 100) / screenSize.Y), 0)
    end
end

RunService.RenderStepped:Connect(updateKeyboardSize)

print("✅ External Keyboard Mobile Aktif!")
print("   • Klik bubble ⌨️ untuk membuka keyboard")
print("   • Geser bubble atau title bar untuk memindahkan")
print("   • Pastikan chat Roblox sudah terbuka sebelum mengetik")
]])
