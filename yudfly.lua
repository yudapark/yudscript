-- yudfly.lua - GUI Functional dengan Tombol Clickable
-- Updated dengan tombol interactive dan close/minimize

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera

-- Pengaturan
local FLY_SPEED = 50
local SPEED_MULTIPLIER = 2
local JUMP_POWER = 100
local FLY_KEY = Enum.KeyCode.F
local NOCLIP_KEY = Enum.KeyCode.B
local SPEED_KEY = Enum.KeyCode.G
local INFJUMP_KEY = Enum.KeyCode.H
local SUPERJUMP_KEY = Enum.KeyCode.J

-- States
local flying = false
local noclip = false
local speedboost = false
local infiniteJump = false
local superJump = false

-- Fly variables
local flyBV = nil
local flyBG = nil
local flySpeed = 0

-- GUI Setup yang lebih interaktif
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YudFlyHub"
ScreenGui.Parent = player.PlayerGui
ScreenGui.ResetOnSpawn = false

-- Main Frame dengan title bar
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Title Bar dengan close/minimize
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "YudFly Hub v2.0"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14
TitleText.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 14
MinimizeButton.Parent = TitleBar

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Header
local Header = Instance.new("TextLabel")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundTransparency = 1
Header.Text = "FEATURE CONTROLS"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.Font = Enum.Font.GothamBold
Header.TextSize = 18
Header.Parent = ContentFrame

-- Function untuk membuat tombol feature
local function CreateFeatureButton(name, yPosition)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = name .. "Frame"
    buttonFrame.Size = UDim2.new(1, 0, 0, 40)
    buttonFrame.Position = UDim2.new(0, 0, 0, yPosition)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = ContentFrame

    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(0.7, 0, 1, 0)
    button.Position = UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.BorderSizePixel = 0
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = buttonFrame

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = name .. "Status"
    statusLabel.Size = UDim2.new(0.3, 0, 1, 0)
    statusLabel.Position = UDim2.new(0.7, 0, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "OFF"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 12
    statusLabel.TextXAlignment = Enum.TextXAlignment.Right
    statusLabel.Parent = buttonFrame

    return button, statusLabel
end

-- Buat tombol-tombol feature
local FlyButton, FlyStatus = CreateFeatureButton("FLY", 50)
local NoclipButton, NoclipStatus = CreateFeatureButton("NOCLIP", 100)
local SpeedButton, SpeedStatus = CreateFeatureButton("SPEED", 150)
local InfJumpButton, InfJumpStatus = CreateFeatureButton("INF JUMP", 200)
local SuperJumpButton, SuperJumpStatus = CreateFeatureButton("SUPER JUMP", 250)

-- Status indicator untuk minimized state
local minimized = false

-- Function untuk toggle minimize
local function ToggleMinimize()
    minimized = not minimized
    if minimized then
        -- Minimize: hanya tunjukkan title bar
        ContentFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 350, 0, 30)
        MinimizeButton.Text = "+"
    else
        -- Restore: tunjukkan semua content
        ContentFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 350, 0, 400)
        MinimizeButton.Text = "_"
    end
end

-- Function untuk update status tampilan
local function UpdateStatusDisplay()
    FlyStatus.Text = flying and "ON" or "OFF"
    FlyStatus.TextColor3 = flying and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    FlyButton.BackgroundColor3 = flying and Color3.fromRGB(80, 160, 80) or Color3.fromRGB(60, 60, 60)
    
    NoclipStatus.Text = noclip and "ON" or "OFF"
    NoclipStatus.TextColor3 = noclip and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    NoclipButton.BackgroundColor3 = noclip and Color3.fromRGB(80, 160, 80) or Color3.fromRGB(60, 60, 60)
    
    SpeedStatus.Text = speedboost and "ON" or "OFF"
    SpeedStatus.TextColor3 = speedboost and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    SpeedButton.BackgroundColor3 = speedboost and Color3.fromRGB(80, 160, 80) or Color3.fromRGB(60, 60, 60)
    
    InfJumpStatus.Text = infiniteJump and "ON" or "OFF"
    InfJumpStatus.TextColor3 = infiniteJump and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    InfJumpButton.BackgroundColor3 = infiniteJump and Color3.fromRGB(80, 160, 80) or Color3.fromRGB(60, 60, 60)
    
    SuperJumpStatus.Text = superJump and "ON" or "OFF"
    SuperJumpStatus.TextColor3 = superJump and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    SuperJumpButton.BackgroundColor3 = superJump and Color3.fromRGB(80, 160, 80) or Color3.fromRGB(60, 60, 60)
end

-- Fly functions
local function startFly()
    flying = true
    UpdateStatusDisplay()
    
    if not character or not humanoid then return end
    
    flyBV = Instance.new("BodyVelocity")
    flyBV.Velocity = Vector3.new(0, 0, 0)
    flyBV.MaxForce = Vector3.new(0, 0, 0)
    flyBV.Parent = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
    
    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(0, 0, 0)
    flyBG.P = 1000
    flyBG.D = 50
    flyBG.Parent = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
    
    flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    
    local flyConnection
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flying or not character or not humanoid then
            flyConnection:Disconnect()
            return
        end
        
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        flyBG.CFrame = camera.CFrame
        flyBV.Velocity = camera.CFrame.LookVector * flySpeed
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            flySpeed = math.min(flySpeed + 1, FLY_SPEED)
        elseif UIS:IsKeyDown(Enum.KeyCode.S) then
            flySpeed = math.max(flySpeed - 1, -FLY_SPEED)
        else
            flySpeed = flySpeed * 0.9
            if math.abs(flySpeed) < 0.1 then
                flySpeed = 0
            end
        end
    end)
end

local function stopFly()
    flying = false
    UpdateStatusDisplay()
    
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
end

-- Noclip function
local function toggleNoclip()
    noclip = not noclip
    UpdateStatusDisplay()
    
    if noclip then
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    else
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

-- Speed function
local function toggleSpeed()
    speedboost = not speedboost
    UpdateStatusDisplay()
    
    if speedboost then
        humanoid.WalkSpeed = humanoid.WalkSpeed * SPEED_MULTIPLIER
    else
        humanoid.WalkSpeed = 16
    end
end

-- Infinite jump function
local function toggleInfiniteJump()
    infiniteJump = not infiniteJump
    UpdateStatusDisplay()
end

-- Super jump function
local function toggleSuperJump()
    superJump = not superJump
    UpdateStatusDisplay()
    
    if superJump then
        humanoid.JumpPower = JUMP_POWER
    else
        humanoid.JumpPower = 50
    end
end

-- Connect button events
FlyButton.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
    else
        startFly()
    end
end)

NoclipButton.MouseButton1Click:Connect(toggleNoclip)
SpeedButton.MouseButton1Click:Connect(toggleSpeed)
InfJumpButton.MouseButton1Click:Connect(toggleInfiniteJump)
SuperJumpButton.MouseButton1Click:Connect(toggleSuperJump)

-- Close and minimize events
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(ToggleMinimize)

-- Infinite jump implementation
local infiniteJumpConnection
infiniteJumpConnection = UIS.JumpRequest:Connect(function()
    if infiniteJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Initial status update
UpdateStatusDisplay()

-- Drag functionality untuk title bar
local dragging = false
local dragInput, dragStart, startPos

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

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("YudFly Hub GUI telah diaktifkan! Klik tombol untuk mengontrol fitur.")
