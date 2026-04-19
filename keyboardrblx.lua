-- External Keyboard Mobile Fixed 2026
loadstring([[ 
-- =============================================
--   EXTERNAL KEYBOARD MOBILE ROBLOX (Android) - FIXED
-- =============================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ExternalKeyboardGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ================== DRAG FUNCTION (Full Dragable + Boundary) ==================
local function makeDraggable(dragObject, target)
    local dragging, dragInput, dragStart, startPos

    dragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
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
            local newPos = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
            -- Batasi agar tidak keluar layar
            newPos = UDim2.new(
                math.clamp(newPos.X.Scale, 0, 1),
                math.clamp(newPos.X.Offset, -target.AbsoluteSize.X/2, screenGui.AbsoluteSize.X - target.AbsoluteSize.X/2),
                math.clamp(newPos.Y.Scale, 0, 1),
                math.clamp(newPos.Y.Offset, -target.AbsoluteSize.Y/2, screenGui.AbsoluteSize.Y - target.AbsoluteSize.Y/2)
            )
            target.Position = newPos
        end
    end)
end

-- ================== GET CHAT TEXTBOX (Support New & Old Chat) ==================
local function getChatTextBox()
    -- New TextChatService
    local textChatService = game:GetService("TextChatService")
    if textChatService and textChatService.ChatInputBarConfiguration then
        local tb = textChatService.ChatInputBarConfiguration.TextBox
        if tb then return tb end
    end

    -- Old Legacy Chat
    local chatGui = playerGui:FindFirstChild("Chat")
    if chatGui then
        for _, obj in ipairs(chatGui:GetDescendants()) do
            if obj:IsA("TextBox") and obj.Visible and obj.TextEditable then
                return obj
            end
        end
    end
    return nil
end

-- ================== BUBBLE ==================
local bubble = Instance.new("Frame")
bubble.Size = UDim2.new(0, 85, 0, 85)
bubble.Position = UDim2.new(1, -130, 0.7, 0)
bubble.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
bubble.BorderSizePixel = 0
bubble.Parent = screenGui

Instance.new("UICorner", bubble).CornerRadius = UDim.new(1, 0)

local bubbleText = Instance.new("TextLabel")
bubbleText.Size = UDim2.new(1,0,1,0)
bubbleText.BackgroundTransparency = 1
bubbleText.Text = "⌨️"
bubbleText.TextColor3 = Color3.new(1,1,1)
bubbleText.TextScaled = true
bubbleText.Font = Enum.Font.GothamBold
bubbleText.Parent = bubble

makeDraggable(bubble, bubble)

-- ================== KEYBOARD FRAME ==================
local keyboard = Instance.new("Frame")
keyboard.Size = UDim2.new(0.96, 0, 0.58, 0)
keyboard.Position = UDim2.new(0.02, 0, 0.35, 0)
keyboard.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
keyboard.Visible = false
keyboard.Parent = screenGui

Instance.new("UICorner", keyboard).CornerRadius = UDim.new(0, 14)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,50)
titleBar.BackgroundColor3 = Color3.fromRGB(10,10,10)
titleBar.Parent = keyboard
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 14)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1,-100,1,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "External Keyboard"
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamSemibold
titleLabel.Parent = titleBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0,50,0,50)
minBtn.Position = UDim2.new(1,-50,0,0)
minBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
minBtn.Text = "✕"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.TextScaled = true
minBtn.Parent = titleBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,12)

makeDraggable(titleBar, keyboard)

-- ================== KEY ROWS ==================
local keysFrame = Instance.new("Frame")
keysFrame.Size = UDim2.new(1,-20,1,-70)
keysFrame.Position = UDim2.new(0,10,0,60)
keysFrame.BackgroundTransparency = 1
keysFrame.Parent = keyboard

local rows = {
    {"q","w","e","r","t","y","u","i","o","p"},
    {"a","s","d","f","g","h","j","k","l"},
    {"z","x","c","v","b","n","m","⌫"},
    {"Shift"," ","Enter"}
}

local isShift = false
local letters = {}

for _, rowKeys in ipairs(rows) do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,0,0,58)
    row.BackgroundTransparency = 1
    row.Parent = keysFrame

    local list = Instance.new("UIListLayout")
    list.FillDirection = Enum.FillDirection.Horizontal
    list.Padding = UDim.new(0,5)
    list.Parent = row

    for _, k in ipairs(rowKeys) do
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = (k == "⌫" or k == "Enter") and Color3.fromRGB(80,80,80) or Color3.fromRGB(40,40,40)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamSemibold
        btn.Parent = row

        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

        if k == " " then
            btn.Size = UDim2.new(0.48,0,1,0)
            btn.Text = "Space"
        elseif k == "⌫" then
            btn.Size = UDim2.new(0.18,0,1,0)
            btn.Text = "⌫"
        elseif k == "Enter" then
            btn.Size = UDim2.new(0.22,0,1,0)
            btn.Text = "Enter"
        elseif k == "Shift" then
            btn.Size = UDim2.new(0.18,0,1,0)
            btn.Text = "⇧"
        else
            btn.Size = UDim2.new(0.085,0,1,0)
            btn.Text = k
            table.insert(letters, btn)
        end

        btn.MouseButton1Click:Connect(function()
            local tb = getChatTextBox()
            if not tb then
                print("❌ Chatbox tidak ditemukan. Buka chat dulu!")
                return
            end

            tb.TextEditable = true
            tb:CaptureFocus()

            task.wait() -- penting untuk mobile

            if k == "⌫" then
                tb.Text = tb.Text:sub(1, -2)
            elseif k == "Enter" then
                -- Enter biasanya langsung kirim di Roblox
            elseif k == " " then
                tb.Text = tb.Text .. " "
            elseif k == "Shift" then
                isShift = not isShift
                for _, b in ipairs(letters) do
                    b.Text = isShift and b.Text:upper() or b.Text:lower()
                end
            else
                local char = isShift and k:upper() or k
                tb.Text = tb.Text .. char
            end

            tb.CursorPosition = #tb.Text + 1
        end)
    end
end

-- ================== TOGGLE ==================
local function showKeyboard(show)
    keyboard.Visible = show
    bubble.Visible = not show
end

bubble.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        showKeyboard(true)
    end
end)

minBtn.MouseButton1Click:Connect(function()
    showKeyboard(false)
end)

-- Auto prevent default keyboard when clicking chat
game:GetService("RunService").RenderStepped:Connect(function()
    local tb = getChatTextBox()
    if tb and tb:IsFocused() then
        -- Release focus sebentar agar keyboard bawaan HP tidak muncul
        tb:ReleaseFocus()
        task.wait(0.05)
        tb:CaptureFocus()
    end
end)

print("✅ External Keyboard Mobile FIXED berhasil dimuat!")
print("   Bubble bisa digeser bebas. Klik bubble untuk buka keyboard.")
]])()
