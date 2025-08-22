-- 🔥 JEBEK.ID 🔥
-- by yuda

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
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
local GUI_COLORS = {
    {name = "Blue", color = Color3.fromRGB(0, 200, 255)},
    {name = "Red", color = Color3.fromRGB(255, 0, 0)},
    {name = "Green", color = Color3.fromRGB(0, 255, 0)},
    {name = "Purple", color = Color3.fromRGB(128, 0, 128)}
}
local currentTheme = 1
local SPEED_PRESETS = {2, 4, 6, 8}
local espAdornments = {}
local selectedPlayer = nil

-- Setup Char
local function setupChar()
    local char = player.Character or player.CharacterAdded:Wait()
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
end
setupChar()
player.CharacterAdded:Connect(setupChar)

-- GUI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "YudaHub"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 260, 0, 550) -- Adjusted for new buttons
mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local UIStroke = Instance.new("UIStroke", mainFrame)
UIStroke.Color = GUI_COLORS[currentTheme].color
UIStroke.Thickness = 2

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, -60, 0, 30)
title.Text = "🔥 YUDA HUB 🔥"
title.TextColor3 = GUI_COLORS[currentTheme].color
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 10, 0, 0)

-- Close & Minimize
local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 2)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.BackgroundTransparency = 1

local minBtn = Instance.new("TextButton", mainFrame)
minBtn.Size = UDim2.new(0, 25, 0, 25)
minBtn.Position = UDim2.new(1, -60, 0, 2)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.BackgroundTransparency = 1

local content = Instance.new("Frame", mainFrame)
content.Size = UDim2.new(1, -10, 1, -40)
content.Position = UDim2.new(0, 5, 0, 35)
content.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", content)
UIList.Padding = UDim.new(0, 5)
UIList.FillDirection = Enum.FillDirection.Vertical

-- Button Factory
local function makeBtn(text)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = text
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = GUI_COLORS[currentTheme].color
    stroke.Thickness = 1
    return btn
end

local flyBtn = makeBtn("✈️ Fly [F]")
local noclipBtn = makeBtn("🚪 NoClip [B]")
local speedBtn = makeBtn("⚡ Speed Hack [G]")
local infJumpBtn = makeBtn("🌀 Infinite Jump [H]")
local jumpBoostBtn = makeBtn("⬆️ Jump Boost [J]")
local tpFBtn = makeBtn("➡️ Teleport Forward [↑]")
local tpBBtn = makeBtn("⬅️ Teleport Backward [↓]")
local espBtn = makeBtn("👁️ ESP [E]")
local godModeBtn = makeBtn("🛡️ God Mode [M]")
local antiAfkBtn = makeBtn("😴 Anti-AFK [0]")

-- Speed Control Frame
local speedFrame = Instance.new("Frame", content)
speedFrame.Size = UDim2.new(1, 0, 0, 30)
speedFrame.BackgroundTransparency = 1

local minusBtn = Instance.new("TextButton", speedFrame)
minusBtn.Size = UDim2.new(0, 40, 1, 0)
minusBtn.Text = "-"
minusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 18

local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Size = UDim2.new(0.6, 0, 1, 0)
speedLabel.Position = UDim2.new(0.2, 0, 0, 0)
speedLabel.Text = "⚡ Speed: x1"
speedLabel.TextColor3 = GUI_COLORS[currentTheme].color
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 14
speedLabel.BackgroundTransparency = 1

local plusBtn = Instance.new("TextButton", speedFrame)
plusBtn.Size = UDim2.new(0, 40, 1, 0)
plusBtn.Position = UDim2.new(1, -40, 0, 0)
plusBtn.Text = "+"
plusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 18

-- Speed Presets Frame
local presetFrame = Instance.new("Frame", content)
presetFrame.Size = UDim2.new(1, 0, 0, 30)
presetFrame.BackgroundTransparency = 1

local presetLabel = Instance.new("TextLabel", presetFrame)
presetLabel.Size = UDim2.new(0.4, 0, 1, 0)
presetLabel.Text = "Presets:"
presetLabel.TextColor3 = GUI_COLORS[currentTheme].color
presetLabel.Font = Enum.Font.GothamBold
presetLabel.TextSize = 14
presetLabel.BackgroundTransparency = 1

for i, preset in ipairs(SPEED_PRESETS) do
    local presetBtn = Instance.new("TextButton", presetFrame)
    presetBtn.Size = UDim2.new(0.15, 0, 1, 0)
    presetBtn.Position = UDim2.new(0.4 + (i-1) * 0.15, 0, 0, 0)
    presetBtn.Text = "x" .. preset
    presetBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    presetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    presetBtn.Font = Enum.Font.GothamBold
    presetBtn.TextSize = 12
    presetBtn.MouseButton1Click:Connect(function()
        currentSpeedMult = preset
        updateSpeedLabel()
    end)
end

-- Teleport to Player Frame
local tpPlayerFrame = Instance.new("Frame", content)
tpPlayerFrame.Size = UDim2.new(1, 0, 0, 60)
tpPlayerFrame.BackgroundTransparency = 1

local tpPlayerLabel = Instance.new("TextLabel", tpPlayerFrame)
tpPlayerLabel.Size = UDim2.new(1, 0, 0, 30)
tpPlayerLabel.Text = "TP Player:"
tpPlayerLabel.TextColor3 = GUI_COLORS[currentTheme].color
tpPlayerLabel.Font = Enum.Font.GothamBold
tpPlayerLabel.TextSize = 14
tpPlayerLabel.BackgroundTransparency = 1

local tpPlayerList = Instance.new("ScrollingFrame", tpPlayerFrame)
tpPlayerList.Size = UDim2.new(1, 0, 0, 30)
tpPlayerList.Position = UDim2.new(0, 0, 0, 30)
tpPlayerList.BackgroundTransparency = 1
tpPlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
tpPlayerList.ScrollBarThickness = 4

local tpPlayerListLayout = Instance.new("UIListLayout", tpPlayerList)
tpPlayerListLayout.Padding = UDim.new(0, 2)
tpPlayerListLayout.FillDirection = Enum.FillDirection.Vertical

-- Visual Customization Frame
local themeFrame = Instance.new("Frame", content)
themeFrame.Size = UDim2.new(1, 0, 0, 30)
themeFrame.BackgroundTransparency = 1

local themeLabel = Instance.new("TextLabel", themeFrame)
themeLabel.Size = UDim2.new(0.4, 0, 1, 0)
themeLabel.Text = "Theme:"
themeLabel.TextColor3 = GUI_COLORS[currentTheme].color
themeLabel.Font = Enum.Font.GothamBold
themeLabel.TextSize = 14
themeLabel.BackgroundTransparency = 1

local themeBtn = Instance.new("TextButton", themeFrame)
themeBtn.Size = UDim2.new(0.6, 0, 1, 0)
themeBtn.Position = UDim2.new(0.4, 0, 0, 0)
themeBtn.Text = GUI_COLORS[currentTheme].name
themeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
themeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
themeBtn.Font = Enum.Font.GothamBold
themeBtn.TextSize = 14

-- Update Speed Label
local function updateSpeedLabel()
    speedLabel.Text = "⚡ Speed: x" .. tostring(currentSpeedMult)
end

-- Update Theme
local function updateTheme()
    UIStroke.Color = GUI_COLORS[currentTheme].color
    title.TextColor3 = GUI_COLORS[currentTheme].color
    speedLabel.TextColor3 = GUI_COLORS[currentTheme].color
    presetLabel.TextColor3 = GUI_COLORS[currentTheme].color
    tpPlayerLabel.TextColor3 = GUI_COLORS[currentTheme].color
    themeLabel.TextColor3 = GUI_COLORS[currentTheme].color
    for _, btn in ipairs(content:GetChildren()) do
        if btn:IsA("TextButton") then
            local stroke = btn:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = GUI_COLORS[currentTheme].color end
        end
    end
    for _, btn in ipairs(tpPlayerList:GetChildren()) do
        if btn:IsA("TextButton") then
            local stroke = btn:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = GUI_COLORS[currentTheme].color end
        end
    end
end

-- Update Player List
local function updatePlayerList()
    for _, btn in ipairs(tpPlayerList:GetChildren()) do
        if btn:IsA("TextButton") then btn:Destroy() end
    end
    local players = Players:GetPlayers()
    tpPlayerList.CanvasSize = UDim2.new(0, 0, 0, #players * 32)
    for _, p in ipairs(players) do
        if p ~= player then
            local btn = Instance.new("TextButton", tpPlayerList)
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 14
            btn.Text = p.Name
            local stroke = Instance.new("UIStroke", btn)
            stroke.Color = GUI_COLORS[currentTheme].color
            stroke.Thickness = 1
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = p
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    rootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                end
            end)
        end
    end
end
updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

plusBtn.MouseButton1Click:Connect(function()
    if currentSpeedMult < 8 then
        currentSpeedMult = math.min(currentSpeedMult + 1, 8)
        updateSpeedLabel()
    end
end)

minusBtn.MouseButton1Click:Connect(function()
    if currentSpeedMult > 1 then
        currentSpeedMult = math.max(currentSpeedMult - 1, 1)
        updateSpeedLabel()
    end
end)

themeBtn.MouseButton1Click:Connect(function()
    currentTheme = (currentTheme % #GUI_COLORS) + 1
    themeBtn.Text = GUI_COLORS[currentTheme].name
    updateTheme()
end)

-- Toggle Functions
local function toggleFly()
    FLY_ENABLED = not FLY_ENABLED
    if FLY_ENABLED then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Parent = rootPart
    else
        if bodyVelocity then bodyVelocity:Destroy() end
    end
    flyBtn.Text = "✈️ Fly [F] : " .. (FLY_ENABLED and "ON" or "OFF")
end

local function toggleNoClip()
    NOCLIP_ENABLED = not NOCLIP_ENABLED
    noclipBtn.Text = "🚪 NoClip [B] : " .. (NOCLIP_ENABLED and "ON" or "OFF")
end

local function toggleSpeed()
    SPEED_ENABLED = not SPEED_ENABLED
    speedBtn.Text = "⚡ Speed Hack [G] : " .. (SPEED_ENABLED and "ON" or "OFF")
end

local function toggleInfJump()
    INFJUMP_ENABLED = not INFJUMP_ENABLED
    infJumpBtn.Text = "🌀 Infinite Jump [H] : " .. (INFJUMP_ENABLED and "ON" or "OFF")
end

local function toggleJumpBoost()
    JUMPBOOST_ENABLED = not JUMPBOOST_ENABLED
    if humanoid then humanoid.JumpPower = JUMPBOOST_ENABLED and JUMP_POWER or 50 end
    jumpBoostBtn.Text = "⬆️ Jump Boost [J] : " .. (JUMPBOOST_ENABLED and "ON" or "OFF")
end

local function toggleESP()
    ESP_ENABLED = not ESP_ENABLED
    espBtn.Text = "👁️ ESP [E] : " .. (ESP_ENABLED and "ON" or "OFF")
    if not ESP_ENABLED then
        for _, adorn in pairs(espAdornments) do adorn:Destroy() end
        espAdornments = {}
    end
end

local function toggleGodMode()
    GODMODE_ENABLED = not GODMODE_ENABLED
    godModeBtn.Text = "🛡️ God Mode [M] : " .. (GODMODE_ENABLED and "ON" or "OFF")
end

local function toggleAntiAFK()
    ANTIAFK_ENABLED = not ANTIAFK_ENABLED
    antiAfkBtn.Text = "😴 Anti-AFK [0] : " .. (ANTIAFK_ENABLED and "ON" or "OFF")
end

-- Bind Buttons
flyBtn.MouseButton1Click:Connect(toggleFly)
noclipBtn.MouseButton1Click:Connect(toggleNoClip)
speedBtn.MouseButton1Click:Connect(toggleSpeed)
infJumpBtn.MouseButton1Click:Connect(toggleInfJump)
jumpBoostBtn.MouseButton1Click:Connect(toggleJumpBoost)
tpFBtn.MouseButton1Click:Connect(function()
    if rootPart then rootPart.CFrame = rootPart.CFrame + rootPart.CFrame.LookVector * TELEPORT_DIST end
end)
tpBBtn.MouseButton1Click:Connect(function()
    if rootPart then rootPart.CFrame = rootPart.CFrame - rootPart.CFrame.LookVector * TELEPORT_DIST end
end)
espBtn.MouseButton1Click:Connect(toggleESP)
godModeBtn.MouseButton1Click:Connect(toggleGodMode)
antiAfkBtn.MouseButton1Click:Connect(toggleAntiAFK)

-- Close/Minimize
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    mainFrame.Size = minimized and UDim2.new(0, 260, 0, 35) or UDim2.new(0, 260, 0, 550)
end)

-- Keyboard Shortcuts
UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.F then toggleFly()
    elseif i.KeyCode == Enum.KeyCode.B then toggleNoClip()
    elseif i.KeyCode == Enum.KeyCode.G then toggleSpeed()
    elseif i.KeyCode == Enum.KeyCode.H then toggleInfJump()
    elseif i.KeyCode == Enum.KeyCode.J then toggleJumpBoost()
    elseif i.KeyCode == Enum.KeyCode.Up then if rootPart then rootPart.CFrame = rootPart.CFrame + rootPart.CFrame.LookVector * TELEPORT_DIST end
    elseif i.KeyCode == Enum.KeyCode.Down then if rootPart then rootPart.CFrame = rootPart.CFrame - rootPart.CFrame.LookVector * TELEPORT_DIST end
    elseif i.KeyCode == Enum.KeyCode.E then toggleESP()
    elseif i.KeyCode == Enum.KeyCode.M then toggleGodMode()
    elseif i.KeyCode == Enum.KeyCode.Zero then toggleAntiAFK()
    elseif i.KeyCode == Enum.KeyCode.T then
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            rootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if INFJUMP_ENABLED and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Fly Handler (PC + Mobile)
RunService.Heartbeat:Connect(function()
    if FLY_ENABLED and rootPart and humanoid and bodyVelocity then
        local camCF = workspace.CurrentCamera.CFrame
        local look = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z).Unit
        local right = Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z).Unit

        local moveDir = Vector3.zero

        -- 📌 PC Mode
        if UIS.KeyboardEnabled then
            if UIS:IsKeyDown(Enum.KeyCode.W) then
                moveDir += look
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) then
                moveDir -= look
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) then
                moveDir -= right
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) then
                moveDir += right
            end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                moveDir += Vector3.new(0, 1, 0) -- naik
            end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDir -= Vector3.new(0, 1, 0) -- turun
            end
        end

        -- 📌 Mobile Mode
        if UIS.TouchEnabled then
            local move = humanoid.MoveDirection
            if move.Magnitude > 0 then
                -- analog + kamera → gerakan
                moveDir += (look * move.Z + right * move.X)
            end

            -- kunci kamera di depan (first-person-like saat fly)
            workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, rootPart.Position + look)
        else
            -- reset kamera kalau bukan mobile
            if workspace.CurrentCamera.CameraType ~= Enum.CameraType.Custom then
                workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            end
        end

        -- apply velocity
        if moveDir.Magnitude > 0 then
            bodyVelocity.Velocity = moveDir.Unit * (BASE_FLY_SPEED * currentSpeedMult)
        else
            bodyVelocity.Velocity = Vector3.zero
            rootPart.AssemblyLinearVelocity = Vector3.zero
        end
    else
        -- kalau fly mati, pastikan kamera balik normal
        if workspace.CurrentCamera.CameraType ~= Enum.CameraType.Custom then
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        end
    end
end)

-- NoClip
RunService.Stepped:Connect(function()
    if NOCLIP_ENABLED and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Speed Hack
RunService.RenderStepped:Connect(function()
    if humanoid then
        if SPEED_ENABLED then
            humanoid.WalkSpeed = 16 * currentSpeedMult
        else
            humanoid.WalkSpeed = 16
        end
    end
end)

-- ESP Handler
RunService.RenderStepped:Connect(function()
    if ESP_ENABLED then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                if not espAdornments[p] then
                    local adorn = Instance.new("BoxHandleAdornment")
                    adorn.Size = hrp.Size + Vector3.new(0.5, 0.5, 0.5)
                    adorn.Adornee = hrp
                    adorn.AlwaysOnTop = true
                    adorn.ZIndex = 10
                    adorn.Transparency = 0.5
                    adorn.Color3 = ESP_COLOR
                    adorn.Parent = hrp
                    espAdornments[p] = adorn
                end
            end
        end
        for p, adorn in pairs(espAdornments) do
            if not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then
                adorn:Destroy()
                espAdornments[p] = nil
            end
        end
    end
end)

-- God Mode
RunService.Heartbeat:Connect(function()
    if GODMODE_ENABLED and humanoid then
        humanoid.Health = humanoid.MaxHealth
    end
end)

-- Anti-AFK
local lastAction = tick()
RunService.Heartbeat:Connect(function()
    if ANTIAFK_ENABLED and tick() - lastAction >= 60 then
        if humanoid then
            humanoid:Jump()
            lastAction = tick()
        end
    end
end)
