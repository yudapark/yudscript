-- 🔥 JEBEK.ID 🔥
-- Yuda Mobile Hub Edition

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Flags
local NOCLIP_ENABLED, FLY_ENABLED, SPEED_ENABLED, INFJUMP_ENABLED, JUMPBOOST_ENABLED = false, false, false, false, false
local ESP_ENABLED, GODMODE_ENABLED, ANTIAFK_ENABLED = false, false, false

-- Settings
local BASE_FLY_SPEED = 50
local currentSpeedMult = 1
local JUMP_POWER = 100
local TELEPORT_DIST = 15
local ESP_COLOR = Color3.fromRGB(255, 0, 0)
local GUI_COLOR = Color3.fromRGB(0,200,255)

local humanoid, rootPart, bodyVelocity

local function setupChar()
    local char = player.Character or player.CharacterAdded:Wait()
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
end
setupChar()
player.CharacterAdded:Connect(setupChar)

-- GUI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "YudaMobileHub"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 260, 0, 500)
mainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Active = true
mainFrame.Draggable = true

local UIStroke = Instance.new("UIStroke", mainFrame)
UIStroke.Color = GUI_COLOR
UIStroke.Thickness = 2

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, -10, 0, 30)
title.Text = "🔥 YUDA HUB Mobile 🔥"
title.TextColor3 = GUI_COLOR
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 5, 0, 0)

local content = Instance.new("Frame", mainFrame)
content.Size = UDim2.new(1, -10, 1, -40)
content.Position = UDim2.new(0, 5, 0, 35)
content.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", content)
UIList.Padding = UDim.new(0, 5)

-- Button Factory
local function makeBtn(text, callback)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = text
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = GUI_COLOR
    stroke.Thickness = 1
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Toggle Functions
local function toggleFly()
    FLY_ENABLED = not FLY_ENABLED
    if FLY_ENABLED then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000,4000,4000)
        bodyVelocity.Parent = rootPart
    else
        if bodyVelocity then bodyVelocity:Destroy() end
    end
end

local function toggleNoClip() NOCLIP_ENABLED = not NOCLIP_ENABLED end
local function toggleSpeed() SPEED_ENABLED = not SPEED_ENABLED end
local function toggleInfJump() INFJUMP_ENABLED = not INFJUMP_ENABLED end
local function toggleJumpBoost()
    JUMPBOOST_ENABLED = not JUMPBOOST_ENABLED
    if humanoid then humanoid.JumpPower = JUMPBOOST_ENABLED and JUMP_POWER or 50 end
end
local function toggleESP() ESP_ENABLED = not ESP_ENABLED end
local function toggleGodMode() GODMODE_ENABLED = not GODMODE_ENABLED end
local function toggleAntiAFK() ANTIAFK_ENABLED = not ANTIAFK_ENABLED end

-- Buttons
makeBtn("✈️ Fly", toggleFly)
makeBtn("🚪 NoClip", toggleNoClip)
makeBtn("⚡ Speed Hack", toggleSpeed)
makeBtn("🌀 Infinite Jump", toggleInfJump)
makeBtn("⬆️ Jump Boost", toggleJumpBoost)
makeBtn("👁️ ESP", toggleESP)
makeBtn("🛡️ God Mode", toggleGodMode)
makeBtn("😴 Anti-AFK", toggleAntiAFK)

-- Fly Joystick (extra frame)
local flyFrame = Instance.new("Frame", screenGui)
flyFrame.Size = UDim2.new(0,150,0,150)
flyFrame.Position = UDim2.new(0.8,0,0.6,0)
flyFrame.BackgroundTransparency = 1

local function makeControl(name,pos,dir)
    local b = Instance.new("TextButton", flyFrame)
    b.Size = UDim2.new(0,45,0,45)
    b.Position = pos
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.MouseButton1Down:Connect(function()
        if bodyVelocity then
            bodyVelocity.Velocity = dir * (BASE_FLY_SPEED * currentSpeedMult)
        end
    end)
    b.MouseButton1Up:Connect(function()
        if bodyVelocity then bodyVelocity.Velocity = Vector3.zero end
    end)
end

makeControl("↑", UDim2.new(0.33,0,0,0), Vector3.new(0,0,-1))
makeControl("↓", UDim2.new(0.33,0,0.66,0), Vector3.new(0,0,1))
makeControl("←", UDim2.new(0,0,0.33,0), Vector3.new(-1,0,0))
makeControl("→", UDim2.new(0.66,0,0.33,0), Vector3.new(1,0,0))
makeControl("⤒", UDim2.new(0.33,0,0.33,0), Vector3.new(0,1,0))
makeControl("⤓", UDim2.new(0.66,0,0.66,0), Vector3.new(0,-1,0))

-- Infinite Jump
game:GetService("UserInputService").JumpRequest:Connect(function()
    if INFJUMP_ENABLED and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Speed Hack
RunService.RenderStepped:Connect(function()
    if humanoid then
        humanoid.WalkSpeed = SPEED_ENABLED and 16*currentSpeedMult or 16
    end
end)

-- NoClip
RunService.Stepped:Connect(function()
    if NOCLIP_ENABLED and player.Character then
        for _,part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- God Mode
RunService.Heartbeat:Connect(function()
    if GODMODE_ENABLED and humanoid then humanoid.Health = humanoid.MaxHealth end
end)

-- Anti-AFK
local lastAction = tick()
RunService.Heartbeat:Connect(function()
    if ANTIAFK_ENABLED and tick()-lastAction>=60 then
        if humanoid then humanoid:Jump() end
        lastAction=tick()
    end
end)
