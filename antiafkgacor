-- Gabungan Script: Anti-AFK + Utility (Rejoin, Lock Pos, Auto Equip)
-- Taruh di StarterPlayer > StarterPlayerScripts

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UtilityAntiAFKGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 300)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "Utility + Anti AFK"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = title

-- Minimize Button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -60, 0, 0)
minBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255,255,255)
minBtn.Parent = title

-- Bubble
local bubble = Instance.new("TextButton")
bubble.Size = UDim2.new(0, 60, 0, 30)
bubble.Position = UDim2.new(0.5, -30, 0.5, 0)
bubble.Text = "Open"
bubble.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
bubble.Visible = false
bubble.Active = true
bubble.Draggable = true
bubble.Parent = screenGui

-- Buttons
local toggleAntiAFK = Instance.new("TextButton")
toggleAntiAFK.Size = UDim2.new(0, 120, 0, 40)
toggleAntiAFK.Position = UDim2.new(0, 10, 0, 50)
toggleAntiAFK.BackgroundColor3 = Color3.fromRGB(100,100,100)
toggleAntiAFK.Text = "Anti AFK: OFF"
toggleAntiAFK.TextColor3 = Color3.fromRGB(255,255,255)
toggleAntiAFK.Parent = frame

local autoRejoinBtn = Instance.new("TextButton")
autoRejoinBtn.Size = UDim2.new(0, 120, 0, 40)
autoRejoinBtn.Position = UDim2.new(0, 10, 0, 100)
autoRejoinBtn.Text = "Auto Rejoin: OFF"
autoRejoinBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
autoRejoinBtn.TextColor3 = Color3.fromRGB(255,255,255)
autoRejoinBtn.Parent = frame

local lockBtn = Instance.new("TextButton")
lockBtn.Size = UDim2.new(0, 120, 0, 40)
lockBtn.Position = UDim2.new(0, 10, 0, 150)
lockBtn.Text = "Lock Pos: OFF"
lockBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
lockBtn.TextColor3 = Color3.fromRGB(255,255,255)
lockBtn.Parent = frame

local equipBtn = Instance.new("TextButton")
equipBtn.Size = UDim2.new(0, 120, 0, 40)
equipBtn.Position = UDim2.new(0, 10, 0, 200)
equipBtn.Text = "Auto Equip: OFF"
equipBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
equipBtn.TextColor3 = Color3.fromRGB(255,255,255)
equipBtn.Parent = frame

-- Variables
local isAntiAFK = false
local afkThread
local autoRejoin = false
local lockPos = false
local autoEquip = false
local savedCFrame = nil

-- Close & Minimize
closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
    if afkThread then coroutine.close(afkThread) end
end)

minBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    bubble.Visible = true
end)

bubble.MouseButton1Click:Connect(function()
    frame.Visible = true
    bubble.Visible = false
end)

-- Anti AFK Functions
local function startAntiAFK()
    if afkThread then return end
    afkThread = coroutine.create(function()
        while isAntiAFK do
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
            wait(5)
        end
    end)
    coroutine.resume(afkThread)
end

local function stopAntiAFK()
    if afkThread then
        coroutine.close(afkThread)
        afkThread = nil
    end
end

toggleAntiAFK.MouseButton1Click:Connect(function()
    isAntiAFK = not isAntiAFK
    if isAntiAFK then
        toggleAntiAFK.Text = "Anti AFK: ON"
        toggleAntiAFK.BackgroundColor3 = Color3.fromRGB(50,200,50)
        startAntiAFK()
    else
        toggleAntiAFK.Text = "Anti AFK: OFF"
        toggleAntiAFK.BackgroundColor3 = Color3.fromRGB(100,100,100)
        stopAntiAFK()
    end
end)

-- Auto Rejoin Toggle
autoRejoinBtn.MouseButton1Click:Connect(function()
    autoRejoin = not autoRejoin
    if autoRejoin then
        autoRejoinBtn.Text = "Auto Rejoin: ON"
        autoRejoinBtn.BackgroundColor3 = Color3.fromRGB(50,200,50)
    else
        autoRejoinBtn.Text = "Auto Rejoin: OFF"
        autoRejoinBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
    end
end)

-- Lock Pos Toggle
lockBtn.MouseButton1Click:Connect(function()
    lockPos = not lockPos
    if lockPos then
        lockBtn.Text = "Lock Pos: ON"
        lockBtn.BackgroundColor3 = Color3.fromRGB(50,200,50)
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            savedCFrame = player.Character.HumanoidRootPart.CFrame
        end
    else
        lockBtn.Text = "Lock Pos: OFF"
        lockBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        savedCFrame = nil
    end
end)

-- Auto Equip Toggle
equipBtn.MouseButton1Click:Connect(function()
    autoEquip = not autoEquip
    if autoEquip then
        equipBtn.Text = "Auto Equip: ON"
        equipBtn.BackgroundColor3 = Color3.fromRGB(50,200,50)
    else
        equipBtn.Text = "Auto Equip: OFF"
        equipBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
    end
end)

-- Heartbeat Loop
RunService.Heartbeat:Connect(function()
    if lockPos and savedCFrame then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = savedCFrame
        end
    end

    if autoEquip then
        local backpack = player:FindFirstChild("Backpack")
        local char = player.Character
        if backpack and char then
            local hasToolEquipped = false
            for _, item in pairs(char:GetChildren()) do
                if item:IsA("Tool") then
                    hasToolEquipped = true
                    break
                end
            end
            if not hasToolEquipped then
                local firstTool = backpack:FindFirstChildWhichIsA("Tool")
                if firstTool then
                    firstTool.Parent = char
                end
            end
        end
    end
end)

-- Auto Rejoin Logic
player.OnTeleport:Connect(function(State)
    if autoRejoin and State == Enum.TeleportState.Failed then
        TeleportService:Teleport(game.PlaceId, player)
    end
end)

Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player and autoRejoin then
        TeleportService:Teleport(game.PlaceId, player)
    end
end)
