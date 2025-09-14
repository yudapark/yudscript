-- LocalScript di StarterPlayerScripts

-- Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UtilityGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Title Bar
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.Text = "Utility GUI"
titleBar.TextColor3 = Color3.fromRGB(255,255,255)
titleBar.Parent = mainFrame

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Parent = titleBar

-- Minimize Button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 1, 0)
minBtn.Position = UDim2.new(1, -60, 0, 0)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
minBtn.Parent = titleBar

-- Bubble (hidden by default)
local bubble = Instance.new("TextButton")
bubble.Size = UDim2.new(0, 60, 0, 30)
bubble.Position = UDim2.new(0.5, -30, 0.5, 0)
bubble.Text = "Open"
bubble.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
bubble.Visible = false
bubble.Active = true
bubble.Draggable = true
bubble.Parent = screenGui

-- Toggle Auto Rejoin
local autoRejoinBtn = Instance.new("TextButton")
autoRejoinBtn.Size = UDim2.new(0, 120, 0, 40)
autoRejoinBtn.Position = UDim2.new(0, 10, 0, 50)
autoRejoinBtn.Text = "Auto Rejoin: OFF"
autoRejoinBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
autoRejoinBtn.TextColor3 = Color3.fromRGB(255,255,255)
autoRejoinBtn.Parent = mainFrame

-- Toggle Lock Position
local lockBtn = Instance.new("TextButton")
lockBtn.Size = UDim2.new(0, 120, 0, 40)
lockBtn.Position = UDim2.new(0, 10, 0, 100)
lockBtn.Text = "Lock Pos: OFF"
lockBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
lockBtn.TextColor3 = Color3.fromRGB(255,255,255)
lockBtn.Parent = mainFrame

-- Variables
local autoRejoin = false
local lockPos = false
local savedCFrame = nil

-- Functions
closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

minBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    bubble.Visible = true
end)

bubble.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    bubble.Visible = false
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

-- Keep Character Locked
RunService.Heartbeat:Connect(function()
    if lockPos and savedCFrame then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = savedCFrame
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
