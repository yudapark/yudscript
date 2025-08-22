-- Movement Enhancements Script with GUI Toggle
-- Original by Secure Explorer, modified by Yuda

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

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

-- Variables
local flyBodyVelocity = nil
local flyBodyAngularVelocity = nil
local originalWalkSpeed = 16
local originalJumpHeight = 7.2
local connections = {}
local flyKeys = {W=false,A=false,S=false,D=false,E=false,Q=false,Space=false,LeftShift=false}

-- ==== [FUNCTIONS ASLI TETAP SAMA] ====
-- (Semua function fly, noclip, teleport, speed hack, dsb tetap sama kayak script lu)
-- biar gak kepanjangan gua skip tulis ulangnya

-- ==============================
-- GUI BUAT TOGGLE FITUR
-- ==============================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MovementUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 300)
Frame.Position = UDim2.new(0, 20, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = Frame

-- Helper buat bikin tombol
local function createToggleButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0,5,0,0)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Text = name .. ": OFF"
    btn.Parent = Frame
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = name .. ": " .. (enabled and "ON" or "OFF")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(50,50,50)
        callback(enabled)
    end)
    
    return btn
end

-- Buat tombol untuk setiap fitur
createToggleButton("Noclip", function(state)
    NOCLIP_ENABLED = state
end)

createToggleButton("Fly", function(state)
    FLY_ENABLED = state
    if state then enableFly() else disableFly() end
end)

createToggleButton("SpeedHack", function(state)
    SPEED_HACK_ENABLED = state
    if state then enableSpeedHack() else disableSpeedHack() end
end)

createToggleButton("Infinite Jump", function(state)
    INFINITE_JUMP_ENABLED = state
end)

createToggleButton("Jump Height", function(state)
    JUMP_HEIGHT_ENABLED = state
    if state then enableJumpHeight() else disableJumpHeight() end
end)

createToggleButton("Spinbot", function(state)
    SPINBOT_ENABLED = state
end)

-- ==============================
-- LOOP UTAMA (tetap sama)
-- ==============================
connections.mainLoop = RunService.Heartbeat:Connect(function()
    if NOCLIP_ENABLED then enableNoclip() end
    if FLY_ENABLED then updateFlyMovement() end
    if SPEED_HACK_ENABLED then enableSpeedHack() end
    if JUMP_HEIGHT_ENABLED then enableJumpHeight() end
    updateSpinbot()
end)

print("✅ Movement Enhancements + GUI Loaded!")
