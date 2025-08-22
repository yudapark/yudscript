--========================================
-- 🚀 YudFly Full Script + GUI
--========================================

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- Feature Flags
local NOCLIP_ENABLED = false
local FLY_ENABLED = false
local SPEED_HACK_ENABLED = false
local INFINITE_JUMP_ENABLED = false
local JUMP_HEIGHT_ENABLED = false
local SPINBOT_ENABLED = false

-- Settings
local FLY_SPEED = 50
local SPEED_MULTIPLIER = 3
local JUMP_HEIGHT = 100
local SPINBOT_SPEED = 10

-- Vars
local flyBodyVelocity = nil
local flyBodyAngularVelocity = nil
local originalWalkSpeed = 16
local originalJumpHeight = 7.2
local connections = {}
local flyKeys = {
    W = false, A = false, S = false, D = false,
    E = false, Q = false, Space = false, LeftShift = false
}

--========================================
-- ✨ Feature Functions
--========================================
local function enableNoclip()
    if not LocalPlayer.Character then return end
    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
        end
    end
end
local function disableNoclip()
    if not LocalPlayer.Character then return end
    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.CanCollide = true
        end
    end
end

local function enableFly()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = LocalPlayer.Character.HumanoidRootPart
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = rootPart
    flyBodyAngularVelocity = Instance.new("BodyAngularVelocity")
    flyBodyAngularVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
    flyBodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
    flyBodyAngularVelocity.Parent = rootPart
end
local function disableFly()
    if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    if flyBodyAngularVelocity then flyBodyAngularVelocity:Destroy() flyBodyAngularVelocity = nil end
end
local function updateFlyMovement()
    if not FLY_ENABLED or not flyBodyVelocity or not LocalPlayer.Character then return end
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    local moveVector = Vector3.new()
    local lookVector, rightVector = Camera.CFrame.LookVector, Camera.CFrame.RightVector
    local upVector = Vector3.new(0, 1, 0)
    if flyKeys.W then moveVector += lookVector end
    if flyKeys.S then moveVector -= lookVector end
    if flyKeys.A then moveVector -= rightVector end
    if flyKeys.D then moveVector += rightVector end
    if flyKeys.E or flyKeys.Space then moveVector += upVector end
    if flyKeys.Q or flyKeys.LeftShift then moveVector -= upVector end
    if moveVector.Magnitude > 0 then moveVector = moveVector.Unit * FLY_SPEED end
    flyBodyVelocity.Velocity = moveVector
end

local function enableSpeedHack()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") then return end
    local humanoid = LocalPlayer.Character.Humanoid
    originalWalkSpeed = humanoid.WalkSpeed
    humanoid.WalkSpeed = originalWalkSpeed * SPEED_MULTIPLIER
end
local function disableSpeedHack()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = originalWalkSpeed
    end
end

local function enableJumpHeight()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        originalJumpHeight = LocalPlayer.Character.Humanoid.JumpHeight
        LocalPlayer.Character.Humanoid.JumpHeight = JUMP_HEIGHT
    end
end
local function disableJumpHeight()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpHeight = originalJumpHeight
    end
end

local function handleInfiniteJump()
    if not INFINITE_JUMP_ENABLED or not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end

local function updateSpinbot()
    if not SPINBOT_ENABLED or not LocalPlayer.Character then return end
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(SPINBOT_SPEED), 0)
    end
end

local function teleportForward(distance)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame += Camera.CFrame.LookVector * (distance or 10)
    end
end
local function teleportBackward(distance)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame -= Camera.CFrame.LookVector * (distance or 10)
    end
end

--========================================
-- 🖥️ GUI
--========================================
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Position = UDim2.new(0.35, 0, 0.35, 0)

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.Size = UDim2.new(1, 0, 0, 30)

local Title = Instance.new("TextLabel", TitleBar)
Title.Text = "🚀 YudFly GUI"
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close & Minimize
local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Text, CloseBtn.Size, CloseBtn.Position = "X", UDim2.new(0,30,1,0), UDim2.new(1,-30,0,0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local MinBtn = Instance.new("TextButton", TitleBar)
MinBtn.Text, MinBtn.Size, MinBtn.Position = "-", UDim2.new(0,30,1,0), UDim2.new(1,-60,0,0)
MinBtn.BackgroundColor3 = Color3.fromRGB(255,170,0)
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame.Size = minimized and UDim2.new(0,300,0,30) or UDim2.new(0,300,0,300)
end)

-- Tombol Fitur
local function createButton(name, posY, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Text, btn.Size, btn.Position = name, UDim2.new(0.9,0,0,30), UDim2.new(0.05,0,0,posY)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font, btn.TextSize = Enum.Font.GothamBold, 14
    btn.MouseButton1Click:Connect(callback)
end

createButton("Toggle Noclip", 40, function() NOCLIP_ENABLED = not NOCLIP_ENABLED end)
createButton("Toggle Fly", 80, function()
    FLY_ENABLED = not FLY_ENABLED
    if FLY_ENABLED then enableFly() else disableFly() end
end)
createButton("Toggle Speed Hack", 120, function()
    SPEED_HACK_ENABLED = not SPEED_HACK_ENABLED
    if SPEED_HACK_ENABLED then enableSpeedHack() else disableSpeedHack() end
end)
createButton("Infinite Jump", 160, function() INFINITE_JUMP_ENABLED = not INFINITE_JUMP_ENABLED end)
createButton("Jump Height", 200, function()
    JUMP_HEIGHT_ENABLED = not JUMP_HEIGHT_ENABLED
    if JUMP_HEIGHT_ENABLED then enableJumpHeight() else disableJumpHeight() end
end)
createButton("Spinbot", 240, function() SPINBOT_ENABLED = not SPINBOT_ENABLED end)
createButton("Teleport Forward", 280, function() teleportForward(15) end)
createButton("Teleport Backward", 320, function() teleportBackward(15) end)

-- Dragging
local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging, dragStart, startPos = true, input.Position, MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
TitleBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
    end
end)

--========================================
-- 🔄 Main Loop
--========================================
RunService.Heartbeat:Connect(function()
    if NOCLIP_ENABLED then enableNoclip() end
    if FLY_ENABLED then updateFlyMovement() end
    if SPEED_HACK_ENABLED then enableSpeedHack() end
    if JUMP_HEIGHT_ENABLED then enableJumpHeight() end
    updateSpinbot()
end)
