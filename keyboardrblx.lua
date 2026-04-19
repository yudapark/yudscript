-- =============================================
--   EXTERNAL KEYBOARD MOBILE ROBLOX (Android)
--   Dibuat khusus buat kamu
-- =============================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ================== CREATE SCREEN GUI ==================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ExternalKeyboardGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ================== FUNGSI DRAG (bisa di-drag) ==================
local function makeDraggable(dragObject, targetObject)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = targetObject.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            targetObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ================== AMBIL CHAT TEXTBOX ROBLOX ==================
local function getChatTextBox()
    local chatGui = playerGui:FindFirstChild("Chat")
    if not chatGui then return nil end

    for _, obj in ipairs(chatGui:GetDescendants()) do
        if obj:IsA("TextBox") and obj.Visible and obj.TextEditable then
            return obj
        end
    end
    return nil
end

-- ================== BUBBLE (Minimized) ==================
local bubble = Instance.new("Frame")
bubble.Name = "Bubble"
bubble.Size = UDim2.new(0, 80, 0, 80)
bubble.Position = UDim2.new(1, -120, 1, -150)
bubble.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
bubble.BorderSizePixel = 0
bubble.Parent = screenGui

local bubbleCorner = Instance.new("UICorner")
bubbleCorner.CornerRadius = UDim.new(1, 0)
bubbleCorner.Parent = bubble

local bubbleLabel = Instance.new("TextLabel")
bubbleLabel.Size = UDim2.new(1, 0, 1, 0)
bubbleLabel.BackgroundTransparency = 1
bubbleLabel.Text = "⌨️"
bubbleLabel.TextColor3 = Color3.new(1, 1, 1)
bubbleLabel.TextScaled = true
bubbleLabel.Font = Enum.Font.GothamBold
bubbleLabel.Parent = bubble

makeDraggable(bubble, bubble)  -- bisa di-drag

-- ================== KEYBOARD FRAME ==================
local keyboard = Instance.new("Frame")
keyboard.Name = "Keyboard"
keyboard.Size = UDim2.new(0.95, 0, 0.55, 0)
keyboard.Position = UDim2.new(0.025, 0, 0.35, 0)
keyboard.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
keyboard.BorderSizePixel = 0
keyboard.Visible = false
keyboard.Parent = screenGui

local kbCorner = Instance.new("UICorner")
kbCorner.CornerRadius = UDim.new(0, 12)
kbCorner.Parent = keyboard

-- Title Bar + Minimize Button
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
titleBar.BorderSizePixel = 0
titleBar.Parent = keyboard

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -90, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "External Keyboard"
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamSemibold
titleText.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 45, 0, 45)
minimizeBtn.Position = UDim2.new(1, -45, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
minimizeBtn.Text = "✕"
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = titleBar

makeDraggable(titleBar, keyboard)  -- drag dari title bar

-- ================== KEYBOARD BUTTONS ==================
local keysFrame = Instance.new("Frame")
keysFrame.Size = UDim2.new(1, -20, 1, -55)
keysFrame.Position = UDim2.new(0, 10, 0, 50)
keysFrame.BackgroundTransparency = 1
keysFrame.Parent = keyboard

local mainList = Instance.new("UIListLayout")
mainList.FillDirection = Enum.FillDirection.Vertical
mainList.Padding = UDim.new(0, 8)
mainList.Parent = keysFrame

local keyRows = {
    {"q","w","e","r","t","y","u","i","o","p"},
    {"a","s","d","f","g","h","j","k","l"},
    {"z","x","c","v","b","n","m","Backspace"},
    {"Shift", "Space", "Enter"}
}

local isShifted = false
local letterButtons = {}

for rowIndex, row in ipairs(keyRows) do
    local rowFrame = Instance.new("Frame")
    rowFrame.Size = UDim2.new(1, 0, 0, 55)
    rowFrame.BackgroundTransparency = 1
    rowFrame.Parent = keysFrame

    local rowList = Instance.new("UIListLayout")
    rowList.FillDirection = Enum.FillDirection.Horizontal
    rowList.Padding = UDim.new(0, 6)
    rowList.Parent = rowFrame

    for _, keyText in ipairs(row) do
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = (keyText == "Backspace" or keyText == "Enter") and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(45, 45, 45)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamSemibold
        btn.Parent = rowFrame

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn

        if keyText == "Space" then
            btn.Size = UDim2.new(0.45, 0, 1, 0)
            btn.Text = " "
        elseif keyText == "Backspace" then
            btn.Size = UDim2.new(0.22, 0, 1, 0)
            btn.Text = "⌫"
        elseif keyText == "Enter" then
            btn.Size = UDim2.new(0.22, 0, 1, 0)
            btn.Text = "⏎"
        elseif keyText == "Shift" then
            btn.Size = UDim2.new(0.15, 0, 1, 0)
            btn.Text = "⇧"
        else
            btn.Size = UDim2.new(0.085, 0, 1, 0)
            btn.Text = keyText
            table.insert(letterButtons, btn)
        end

        btn.MouseButton1Click:Connect(function()
            local chatBox = getChatTextBox()
            if not chatBox then 
                print("❌ Chatbox tidak ditemukan!") 
                return 
            end

            chatBox:CaptureFocus()

            if keyText == "Backspace" then
                chatBox.Text = chatBox.Text:sub(1, -2)
            elseif keyText == "Enter" then
                -- Enter hanya mengirim jika kamu tekan tombol enter di keyboard ini
                chatBox.Text = chatBox.Text
            elseif keyText == "Space" then
                chatBox.Text = chatBox.Text .. " "
            elseif keyText == "Shift" then
                isShifted = not isShifted
                for _, b in ipairs(letterButtons) do
                    b.Text = isShifted and b.Text:upper() or b.Text:lower()
                end
            else
                local char = isShifted and keyText:upper() or keyText
                chatBox.Text = chatBox.Text .. char
            end

            chatBox.CursorPosition = #chatBox.Text + 1
        end)
    end
end

-- ================== TOGGLE BUBBLE & KEYBOARD ==================
local function toggleKeyboard(show)
    keyboard.Visible = show
    bubble.Visible = not show
end

bubble.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleKeyboard(true)
    end
end)

minimizeBtn.MouseButton1Click:Connect(function()
    toggleKeyboard(false)
end)

-- Mulai dengan Bubble
bubble.Visible = true
keyboard.Visible = false

print("✅ External Keyboard Mobile berhasil dimuat! Klik bubble untuk mulai ketik.")
