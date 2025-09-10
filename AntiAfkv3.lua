-- Anti-AFK Script dengan GUI (LocalScript)
-- Letakkan di StarterPlayerScripts atau StarterGui

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Buat GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiAFK_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame (bisa dipindah)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true -- Biar bisa di-drag
mainFrame.Draggable = true -- Fitur drag
mainFrame.Parent = screenGui

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -70, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Anti-AFK JEBEK GACOR"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 14
titleLabel.Parent = titleBar

-- Tombol Close
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 2.5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 14
closeButton.Parent = titleBar

-- Tombol Minimize
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -60, 0, 2.5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 18
minimizeButton.Parent = titleBar

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
contentFrame.Parent = mainFrame

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 10)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: OFF"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 14
statusLabel.Parent = contentFrame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 30)
toggleButton.Position = UDim2.new(0.5, -50, 0, 50)
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
toggleButton.Text = "Turn ON"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 14
toggleButton.Parent = contentFrame

-- Settings Frame
local settingsFrame = Instance.new("Frame")
settingsFrame.Size = UDim2.new(1, -20, 0, 80)
settingsFrame.Position = UDim2.new(0, 10, 0, 90)
settingsFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
settingsFrame.Parent = contentFrame

-- Jump Interval Slider
local jumpLabel = Instance.new("TextLabel")
jumpLabel.Size = UDim2.new(0, 80, 0, 20)
jumpLabel.Position = UDim2.new(0, 0, 0, 5)
jumpLabel.BackgroundTransparency = 1
jumpLabel.Text = "Jump (s):"
jumpLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
jumpLabel.TextSize = 12
jumpLabel.Parent = settingsFrame

local jumpSlider = Instance.new("TextBox")
jumpSlider.Size = UDim2.new(0, 50, 0, 20)
jumpSlider.Position = UDim2.new(0, 85, 0, 5)
jumpSlider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
jumpSlider.Text = "30"
jumpSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpSlider.TextSize = 12
jumpSlider.Parent = settingsFrame

-- Camera Move Slider
local cameraLabel = Instance.new("TextLabel")
cameraLabel.Size = UDim2.new(0, 80, 0, 20)
cameraLabel.Position = UDim2.new(0, 0, 0, 30)
cameraLabel.BackgroundTransparency = 1
cameraLabel.Text = "Camera (s):"
cameraLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
cameraLabel.TextSize = 12
cameraLabel.Parent = settingsFrame

local cameraSlider = Instance.new("TextBox")
cameraSlider.Size = UDim2.new(0, 50, 0, 20)
cameraSlider.Position = UDim2.new(0, 85, 0, 30)
cameraSlider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
cameraSlider.Text = "15"
cameraSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
cameraSlider.TextSize = 12
cameraSlider.Parent = settingsFrame

-- Minimized Frame (tersembunyi)
local minimizedFrame = Instance.new("Frame")
minimizedFrame.Size = UDim2.new(0, 150, 0, 30)
minimizedFrame.Position = UDim2.new(0.5, -75, 0.1, 0)
minimizedFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
minimizedFrame.BorderSizePixel = 0
minimizedFrame.Active = true
minimizedFrame.Draggable = true
minimizedFrame.Visible = false
minimizedFrame.Parent = screenGui

local minimizedLabel = Instance.new("TextLabel")
minimizedLabel.Size = UDim2.new(1, -30, 1, 0)
minimizedLabel.BackgroundTransparency = 1
minimizedLabel.Text = "Anti-AFK"
minimizedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizedLabel.Font = Enum.Font.SourceSansBold
minimizedLabel.TextSize = 14
minimizedLabel.Parent = minimizedFrame

local restoreButton = Instance.new("TextButton")
restoreButton.Size = UDim2.new(0, 25, 0, 25)
restoreButton.Position = UDim2.new(1, -30, 0, 2.5)
restoreButton.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
restoreButton.Text = "+"
restoreButton.TextColor3 = Color3.fromRGB(255, 255, 255)
restoreButton.Font = Enum.Font.SourceSansBold
restoreButton.TextSize = 18
restoreButton.Parent = minimizedFrame

-- Variabel
local isAntiAFKEnabled = false
local lastJumpTime = 0
local lastCameraTime = 0
local jumpInterval = 30 -- detik
local cameraInterval = 15 -- detik

-- Fungsi untuk menggerakkan kamera
local function moveCamera()
    local camera = game.Workspace.CurrentCamera
    if camera then
        -- Simpan rotasi awal
        local originalCFrame = camera.CFrame
        
        -- Gerakan kamera random (horizontal dan vertikal)
        local randomX = math.random(-15, 15)
        local randomY = math.random(-10, 10)
        
        -- Rotasi kamera
        camera.CFrame = camera.CFrame * CFrame.Angles(
            math.rad(randomY), 
            math.rad(randomX), 
            0
        )
        
        -- Kembalikan ke posisi awal setelah 0.1 detik
        wait(0.1)
        camera.CFrame = originalCFrame
    end
end

-- Fungsi untuk melompat
local function jump()
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.Jump = true
    end
end

-- Loop utama anti-AFK
spawn(function()
    while true do
        if isAntiAFKEnabled then
            local currentTime = tick()
            
            -- Cek interval lompat
            if currentTime - lastJumpTime >= jumpInterval then
                jump()
                lastJumpTime = currentTime
                -- Tambahkan random delay 1-5 detik
                wait(math.random(1, 5))
            end
            
            -- Cek interval kamera
            if currentTime - lastCameraTime >= cameraInterval then
                moveCamera()
                lastCameraTime = currentTime
                -- Tambahkan random delay 1-3 detik
                wait(math.random(1, 3))
            end
        end
        wait(1)
    end
end)

-- Event Toggle
toggleButton.MouseButton1Click:Connect(function()
    isAntiAFKEnabled = not isAntiAFKEnabled
    
    if isAntiAFKEnabled then
        toggleButton.Text = "Turn OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        statusLabel.Text = "Status: ON"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        toggleButton.Text = "Turn ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        statusLabel.Text = "Status: OFF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- Event Close
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Event Minimize
minimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    minimizedFrame.Visible = true
end)

-- Event Restore
restoreButton.MouseButton1Click:Connect(function()
    minimizedFrame.Visible = false
    mainFrame.Visible = true
end)

-- Update interval dari slider
jumpSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local value = tonumber(jumpSlider.Text)
        if value and value >= 5 and value <= 120 then
            jumpInterval = value
        else
            jumpSlider.Text = tostring(jumpInterval)
        end
    end
end)

cameraSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local value = tonumber(cameraSlider.Text)
        if value and value >= 5 and value <= 60 then
            cameraInterval = value
        else
            cameraSlider.Text = tostring(cameraInterval)
        end
    end
end)

-- Mobile Support: Touch drag untuk GUI
if UserInputService.TouchEnabled then
    local dragToggle = nil
    local dragStart = nil
    local startPos = nil
    local dragging = false

    local function updateInput(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
        mainFrame.Position = position
    end

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and dragToggle then
            updateInput(input)
        end
    end)
end

-- Notifikasi
print("Anti-AFK GUI loaded! Drag the window to move it.")
