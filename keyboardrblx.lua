-- External Keyboard Mobile - FIXED 2024 (Modern TextChatService Compatible)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YudaExternalKeyboard"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 1000
screenGui.Parent = playerGui

-- ================== IMPROVED DRAG FUNCTION ==================
local draggingFrame = nil
local dragStart = nil
local startPos = nil

local function makeDraggable(frame)
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingFrame = frame
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingFrame = nil
                end
            end)
        end
    end)
end

UserInputService.InputChanged:Connect(function(input)
    if draggingFrame and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local newX = UDim.new(startPos.X.Scale, startPos.X.Offset + delta.X)
        local newY = UDim.new(startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        
        local frameSize = draggingFrame.AbsoluteSize
        local screenSize = workspace.CurrentCamera.ViewportSize
        
        newX = UDim.new(0, math.clamp(startPos.X.Offset + delta.X, 0, screenSize.X - frameSize.X))
        newY = UDim.new(0, math.clamp(startPos.Y.Offset + delta.Y, 0, screenSize.Y - frameSize.Y))
        
        draggingFrame.Position = UDim2.new(newX, newY)
    end
end)

-- ================== MODERN CHAT TEXTBOX ==================
local function getChatTextBox()
    local success, result = pcall(function()
        local textChannels = TextChatService:WaitForChild("TextChannels", 5)
        if not textChannels then return nil end
        
        local rbxGeneral = textChannels:WaitForChild("RBXGeneral", 2)
        if not rbxGeneral then return nil end
        
        local textChatBox = rbxGeneral:WaitForChild("TextChatBox", 2)
        return textChatBox
    end)
    
    return success and result or nil
end

-- ================== BUBBLE BUTTON ==================
local bubble = Instance.new("ImageButton")
bubble.Size = UDim2.new(0, 80, 0, 80)
bubble.Position = UDim2.new(0.85, 0, 0.6, 0)
bubble.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
bubble.BorderSizePixel = 0
bubble.ImageTransparency = 1
bubble.Parent = screenGui

local bubbleCorner = Instance.new("UICorner")
bubbleCorner.CornerRadius = UDim.new(1, 0)
bubbleCorner.Parent = bubble

local bubbleLabel = Instance.new("TextLabel")
bubbleLabel.Size = UDim2.new(1, 0, 1, 0)
bubbleLabel.BackgroundTransparency = 1
bubbleLabel.Text = "⌨️"
bubbleLabel.TextScaled = true
bubbleLabel.TextColor3 = Color3.new(1, 1, 1)
bubbleLabel.Font = Enum.Font.GothamBold
bubbleLabel.Parent = bubble

makeDraggable(bubble)

-- ================== KEYBOARD FRAME ==================
local keyboard = Instance.new("Frame")
keyboard.Size = UDim2.new(0.95, 0, 0.55, 0)
keyboard.Position = UDim2.new(0.025, 0, 0.35, 0)
keyboard.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
keyboard.Visible = false
keyboard.Parent = screenGui

local keyboardCorner = Instance.new("UICorner")
keyboardCorner.CornerRadius = UDim.new(0, 20)
keyboardCorner.Parent = keyboard

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
titleBar.Parent = keyboard

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 15)
titleBarCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⌨️ External Keyboard"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamSemibold
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 45, 1, 0)
closeBtn.Position = UDim2.new(1, -50, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 12)
closeBtnCorner.Parent = closeBtn

makeDraggable(titleBar)

-- ================== KEYS CONTAINER ==================
local keysFrame = Instance.new("Frame")
keysFrame.Size = UDim2.new(1, -20, 1, -65)
keysFrame.Position = UDim2.new(0, 10, 0, 55)
keysFrame.BackgroundTransparency = 1
keysFrame.Parent = keyboard

local rowLayout = Instance.new("UIListLayout")
rowLayout.FillDirection = Enum.FillDirection.Vertical
rowLayout.Padding = UDim.new(0, 8)
rowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
rowLayout.Parent = keysFrame

-- Key rows data
local keyRows = {
    {keys = {"Q","W","E","R","T","Y","U","I","O","P"}, size = 0.085},
    {keys = {"A","S","D","F","G","H","J","K","L"}, size = 0.094},
    {keys = {"Z","X","C","V","B","N","M"}, size = 0.12},
    {keys = {"⌫", "⇧", "Space", "↵"}, size = {0.15, 0.15, 0.45, 0.15}, colors = {
        Color3.fromRGB(80, 50, 50), Color3.fromRGB(60, 60, 80), 
        Color3.fromRGB(45, 45, 55), Color3.fromRGB(50, 80, 50)
    }}
}

local letterBtns = {}
local isShift = false

-- Create key rows
for rowIndex, rowData in ipairs(keyRows) do
    local rowFrame = Instance.new("Frame")
    rowFrame.Size = UDim2.new(1, 0, 0, 55)
    rowFrame.BackgroundTransparency = 1
    rowFrame.Parent = keysFrame
    
    local rowList = Instance.new("UIListLayout")
    rowList.FillDirection = Enum.FillDirection.Horizontal
    rowList.Padding = UDim.new(0, 6)
    rowList.Parent = rowFrame
    
    local rowSizes = rowData.size
    if type(rowSizes) == "table" then rowSizes = rowData.sizes end
    
    for keyIndex, keyText in ipairs(rowData.keys) do
        local btnSize = type(rowData.size) == "number" and rowData.size or rowData.sizes[keyIndex] or 0.1
        local btnColor = rowData.colors and rowData.colors[keyIndex] or Color3.fromRGB(45, 45, 55)
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(btnSize, 0, 1, 0)
        btn.BackgroundColor3 = btnColor
        btn.Text = keyText
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamSemibold
        btn.Parent = rowFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn
        
        table.insert(letterBtns, btn)
    end
end

-- ================== KEY EVENT HANDLERS ==================
local function typeChar(char)
    local tb = getChatTextBox()
    if not tb then
        warn("⚠️ Chat tidak ditemukan! Buka chat terlebih dahulu.")
        return
    end
    
    tb.TextEditable = true
    tb:CaptureFocus()
    task.wait()
    
    tb.Text = tb.Text .. char
    tb.CursorPosition = #tb.Text + 1
end

-- Letter keys
for _, btn in ipairs(letterBtns) do
    btn.MouseButton1Click:Connect(function()
        if string.find(btn.Text, "[QWERTYUIOPASDFGHJKLZXCVBNM]") then
            local char = isShift and btn.Text or btn.Text:lower()
            typeChar(char)
            
            if isShift then
                isShift = false
                for _, b in ipairs(letterBtns) do
                    if string.find(b.Text, "[QWERTYUIOPASDFGHJKLZXCVBNM]") then
                        b.Text = b.Text:lower()
                    end
                end
            end
        end
    end)
end

-- Special keys (find by text)
local function findKeyByText(text)
    for _, btn in ipairs(letterBtns) do
        if btn.Text == text then return btn end
    end
    return nil
end

-- Backspace
local backBtn = findKeyByText("⌫")
if backBtn then
    backBtn.MouseButton1Click:Connect(function()
        local tb = getChatTextBox()
        if tb and #tb.Text > 0 then
            tb.TextEditable = true
            tb:CaptureFocus()
            tb.Text = tb.Text:sub(1, -2)
            tb.CursorPosition = #tb.Text + 1
        end
    end)
end

-- Shift
local shiftBtn = findKeyByText("⇧")
if shiftBtn then
    shiftBtn.MouseButton1Click:Connect(function()
        isShift = not isShift
        for _, btn in ipairs(letterBtns) do
            if string.find(btn.Text, "[QWERTYUIOPASDFGHJKLZXCVBNM]") then
                btn.Text = isShift and btn.Text or btn.Text:lower()
            end
        end
    end)
end

-- Space
local spaceBtn = findKeyByText("Space")
if spaceBtn then
    spaceBtn.MouseButton1Click:Connect(function()
        typeChar(" ")
    end)
end

-- Enter
local enterBtn = findKeyByText("↵")
if enterBtn then
    enterBtn.MouseButton1Click:Connect(function()
        local tb = getChatTextBox()
        if tb and tb.Text ~= "" then
            tb.TextEditable = true
            tb:CaptureFocus()
            task.wait()
            tb.Parent:SendAsync(tb.Text)  -- Modern TextChatService send
            tb.Text = ""
        end
    end)
end

-- ================== TOGGLE ==================
bubble.MouseButton1Click:Connect(function()
    keyboard.Visible = true
    bubble.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
    keyboard.Visible = false
    bubble.Visible = true
end)

-- Update keyboard size on resize
RunService.Heartbeat:Connect(function()
    if keyboard.Visible then
        local viewportSize = workspace.CurrentCamera.ViewportSize
        keyboard.Size = UDim2.new(0.95, 0, 0, math.min(500, viewportSize.Y * 0.55))
    end
end)

print("✅ External Keyboard FIXED - Modern TextChatService Compatible!")
print("📱 Drag bubble untuk pindah | Klik bubble untuk buka keyboard")
