-- GUI Buatan Yuda 🚀
-- Script ini bikin GUI modern dengan tombol fitur + minimize + close + dragable

-- Bikin ScreenGui
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleBar = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local UIStroke = Instance.new("UIStroke")
local UICorner = Instance.new("UICorner")

-- Parent
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Size = UDim2.new(0, 300, 0, 220)
MainFrame.Position = UDim2.new(0.35, 0, 0.35, 0)

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

UIStroke.Parent = MainFrame
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 255, 255)

-- Title Bar
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Position = UDim2.new(0, 0, 0, 0)

TitleLabel.Parent = TitleBar
TitleLabel.Text = "YudFly GUI 🚀"
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
CloseButton.Parent = TitleBar
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Minimize Button
MinimizeButton.Parent = TitleBar
MinimizeButton.Text = "-"
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
MinimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 14

local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 300, 0, 30)
    else
        MainFrame.Size = UDim2.new(0, 300, 0, 220)
    end
end)

-- Fitur Tombol
local function createButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Text = name
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(callback)
end

-- Contoh fitur tombol sesuai script lo
createButton("Toggle Noclip", 50, function()
    print("Noclip Aktif/Nonaktif") 
    -- masukin kode noclip lo di sini
end)

createButton("Toggle Fly", 90, function()
    print("Fly Aktif/Nonaktif") 
    -- masukin kode fly lo di sini
end)

createButton("Speed +", 130, function()
    print("Speed Tambah") 
    -- masukin kode speed up lo di sini
end)

createButton("Speed -", 170, function()
    print("Speed Kurang") 
    -- masukin kode speed down lo di sini
end)

-- Bisa di drag
local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
