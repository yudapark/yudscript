-- 🔥 JEBEK.ID 🔥
-- Yuda Hub - Clean GUI + Multi-Waypoint + Bugfix All Features
-- Put this as a LocalScript in StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

-- ===== STATE FLAGS =====
local NOCLIP_ENABLED, FLY_ENABLED, SPEED_ENABLED, INFJUMP_ENABLED, JUMPBOOST_ENABLED = false, false, false, false, false
local ESP_ENABLED, GODMODE_ENABLED, ANTIAFK_ENABLED = false, false, false

-- ===== SETTINGS =====
local BASE_FLY_SPEED = 50
local currentSpeedMult = 1 -- x1..x8
local JUMP_POWER_ON = 100
local JUMP_POWER_OFF = 50
local TELEPORT_DIST = 15
local ESP_COLOR = Color3.fromRGB(255, 0, 0)
local SPEED_PRESETS = {2, 4, 6, 8}

local GUI_COLORS = {
    {name = "Blue",   color = Color3.fromRGB(0, 200, 255)},
    {name = "Red",    color = Color3.fromRGB(255, 0, 0)},
    {name = "Green",  color = Color3.fromRGB(0, 255, 0)},
    {name = "Purple", color = Color3.fromRGB(128, 0, 128)}
}
local currentTheme = 1

-- ===== RUNTIME =====
local humanoid, rootPart, bodyVelocity
local espAdornments = {}
local selectedPlayer = nil
local waypoints = {}
local minimized = false

-- ===== UTIL =====
local function safeWaitForChar()
    local char = player.Character or player.CharacterAdded:Wait()
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
end
safeWaitForChar()
player.CharacterAdded:Connect(safeWaitForChar)

local function notify(title, text, dur)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title, Text = text, Duration = dur or 2
        })
    end)
end

-- ===== GUI ROOT =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YudaHub"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, 320, 0, 620)
mainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Thickness = 2
stroke.Color = GUI_COLORS[currentTheme].color

-- Header
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 44)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -90, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔥 YUDA HUB 🔥"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = GUI_COLORS[currentTheme].color

local btnMin = Instance.new("TextButton", header)
btnMin.Size = UDim2.new(0, 28, 0, 28)
btnMin.Position = UDim2.new(1, -64, 0.5, -14)
btnMin.Text = "-"
btnMin.Font = Enum.Font.GothamBold
btnMin.TextSize = 18
btnMin.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
btnMin.TextColor3 = Color3.fromRGB(255, 255, 0)
Instance.new("UICorner", btnMin).CornerRadius = UDim.new(0, 6)

local btnClose = Instance.new("TextButton", header)
btnClose.Size = UDim2.new(0, 28, 0, 28)
btnClose.Position = UDim2.new(1, -32, 0.5, -14)
btnClose.Text = "X"
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 18
btnClose.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
btnClose.TextColor3 = Color3.fromRGB(255, 0, 0)
Instance.new("UICorner", btnClose).CornerRadius = UDim.new(0, 6)

-- Body (scroll)
local content = Instance.new("ScrollingFrame", mainFrame)
content.Size = UDim2.new(1, -16, 1, -60)
content.Position = UDim2.new(0, 8, 0, 52)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 4
content.CanvasSize = UDim2.new(0,0,0,0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y

local list = Instance.new("UIListLayout", content)
list.Padding = UDim.new(0, 10)
list.FillDirection = Enum.FillDirection.Vertical
list.HorizontalAlignment = Enum.HorizontalAlignment.Center

local pad = Instance.new("UIPadding", content)
pad.PaddingLeft = UDim.new(0, 4)
pad.PaddingRight = UDim.new(0, 4)
pad.PaddingTop = UDim.new(0, 6)

-- ===== GUI HELPERS =====
local function makeSection(titleText)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 0)
    holder.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    holder.BackgroundTransparency = 0.2
    holder.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 8)

    local layout = Instance.new("UIListLayout", holder)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0, 6)

    local sectionTitle = Instance.new("TextLabel", holder)
    sectionTitle.Size = UDim2.new(1, -8, 0, 22)
    sectionTitle.Position = UDim2.new(0, 4, 0, 4)
    sectionTitle.Text = titleText
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.TextSize = 14
    sectionTitle.TextColor3 = GUI_COLORS[currentTheme].color
    sectionTitle.BackgroundTransparency = 1

    local container = Instance.new("Frame", holder)
    container.Size = UDim2.new(1, -8, 0, 0)
    container.Position = UDim2.new(0, 4, 0, 0)
    container.BackgroundTransparency = 1
    container.AutomaticSize = Enum.AutomaticSize.Y

    local il = Instance.new("UIListLayout", container)
    il.Padding = UDim.new(0, 6)
    il.FillDirection = Enum.FillDirection.Vertical

    holder.Parent = content
    return container, sectionTitle
end

local function makeBtn(parent, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke", btn)
    st.Thickness = 1
    st.Color = GUI_COLORS[currentTheme].color
    btn.Parent = parent
    return btn
end

local function makeRow(parent)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundTransparency = 1
    local hl = Instance.new("UIListLayout", row)
    hl.FillDirection = Enum.FillDirection.Horizontal
    hl.Padding = UDim.new(0, 6)
    row.Parent = parent
    return row
end

local function makeSmallBtn(parent, text, width)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, width or 40, 1, 0)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    b.Text = text
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    local st = Instance.new("UIStroke", b)
    st.Thickness = 1
    st.Color = GUI_COLORS[currentTheme].color
    b.Parent = parent
    return b
end

local function makeLabel(parent, text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = Enum.Font.GothamBold
    l.TextSize = 14
    l.TextColor3 = GUI_COLORS[currentTheme].color
    l.TextXAlignment = Enum.TextXAlignment.Center
    l.Parent = parent
    return l
end

-- ====== SECTIONS ======
local togglesSection = makeSection("⚙️ Main Toggles")
local speedSection = makeSection("🏃 Speed Control")
local presetsSection = makeSection("🎛️ Speed Presets")
local tpPlayerSection, tpPlayerLabel = makeSection("🧍 Teleport to Player")
local waypointsSection, wpLabel = makeSection("📍 Waypoints")
local themeSection, themeLabel = makeSection("🎨 Theme")

-- ---- Toggles
local flyBtn       = makeBtn(togglesSection, "✈️ Fly [F] : OFF")
local noclipBtn    = makeBtn(togglesSection, "🚪 NoClip [B] : OFF")
local speedBtn     = makeBtn(togglesSection, "⚡ Speed Hack [G] : OFF")
local infJumpBtn   = makeBtn(togglesSection, "🌀 Infinite Jump [H] : OFF")
local jumpBoostBtn = makeBtn(togglesSection, "⬆️ Jump Boost [J] : OFF")
local tpFBtn       = makeBtn(togglesSection, "➡️ Teleport Forward [↑]")
local tpBBtn       = makeBtn(togglesSection, "⬅️ Teleport Backward [↓]")
local espBtn       = makeBtn(togglesSection, "👁️ ESP [E] : OFF")
local godModeBtn   = makeBtn(togglesSection, "🛡️ God Mode [M] : OFF")
local antiAfkBtn   = makeBtn(togglesSection, "😴 Anti-AFK [0] : OFF")
local resetBtn     = makeBtn(togglesSection, "♻️ Reset Character")

-- ---- Speed Control
local speedRow = makeRow(speedSection)
local minusBtn = makeSmallBtn(speedRow, "-")
minusBtn.Size = UDim2.new(0, 42, 1, 0)
local speedLabel = makeLabel(speedRow, "⚡ Speed: x1")
speedLabel.Size = UDim2.new(1, -90, 1, 0)
local plusBtn = makeSmallBtn(speedRow, "+")
plusBtn.Size = UDim2.new(0, 42, 1, 0)

-- ---- Presets
local presetsRow = makeRow(presetsSection)
local presetInfo = Instance.new("TextLabel", presetsRow)
presetInfo.BackgroundTransparency = 1
presetInfo.Size = UDim2.new(0, 70, 1, 0)
presetInfo.Text = "Presets:"
presetInfo.Font = Enum.Font.GothamBold
presetInfo.TextSize = 14
presetInfo.TextXAlignment = Enum.TextXAlignment.Left
presetInfo.TextColor3 = GUI_COLORS[currentTheme].color
for _, p in ipairs(SPEED_PRESETS) do
    local b = makeSmallBtn(presetsRow, "x"..p, 48)
    b.MouseButton1Click:Connect(function()
        currentSpeedMult = p
        speedLabel.Text = "⚡ Speed: x"..tostring(currentSpeedMult)
    end)
end

-- ---- Teleport to Player (Search + List)
local searchRow = makeRow(tpPlayerSection)
local searchBox = Instance.new("TextBox", searchRow)
searchBox.Size = UDim2.new(1, 0, 1, 0)
searchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.PlaceholderText = "Cari nama pemain..."
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)
local stsb = Instance.new("UIStroke", searchBox)
stsb.Thickness = 1
stsb.Color = GUI_COLORS[currentTheme].color

local playerList = Instance.new("ScrollingFrame", tpPlayerSection)
playerList.Size = UDim2.new(1, 0, 0, 110)
playerList.BackgroundTransparency = 1
playerList.ScrollBarThickness = 5
playerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
local plLayout = Instance.new("UIListLayout", playerList)
plLayout.Padding = UDim.new(0, 4)
plLayout.FillDirection = Enum.FillDirection.Vertical

local function makeListButton(text)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 30)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.Text = text
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke", b)
    st.Thickness = 1
    st.Color = GUI_COLORS[currentTheme].color
    b.Parent = playerList
    return b
end

local function updatePlayerList()
    for _, child in ipairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local query = string.lower(searchBox.Text or "")
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local ok = true
            if query ~= "" then
                ok = string.find(string.lower(p.Name), query, 1, true) ~= nil
            end
            if ok then
                local b = makeListButton(p.Name)
                b.MouseButton1Click:Connect(function()
                    selectedPlayer = p
                    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        rootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                    end
                end)
            end
        end
    end
end
updatePlayerList()
searchBox:GetPropertyChangedSignal("Text"):Connect(updatePlayerList)
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- ---- Waypoints (Add + List)
local addWpBtn = makeBtn(waypointsSection, "➕ Add Waypoint (posisi sekarang)")
local wpList = Instance.new("ScrollingFrame", waypointsSection)
wpList.Size = UDim2.new(1, 0, 0, 160)
wpList.BackgroundTransparency = 1
wpList.ScrollBarThickness = 5
wpList.AutomaticCanvasSize = Enum.AutomaticSize.Y
local wpLayout = Instance.new("UIListLayout", wpList)
wpLayout.FillDirection = Enum.FillDirection.Vertical
wpLayout.Padding = UDim.new(0, 4)

local function refreshWpList()
    for _, child in ipairs(wpList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for i, wp in ipairs(waypoints) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 30)
        row.BackgroundTransparency = 1
        local rl = Instance.new("UIListLayout", row)
        rl.FillDirection = Enum.FillDirection.Horizontal
        rl.Padding = UDim.new(0, 6)

        local nameBtn = makeSmallBtn(row, wp.name, 160)
        nameBtn.TextSize = 14
        nameBtn.TextXAlignment = Enum.TextXAlignment.Left

        local tpBtn = makeSmallBtn(row, "TP", 50)
        local delBtn = makeSmallBtn(row, "🗑", 40)

        nameBtn.MouseButton1Click:Connect(function()
            -- rename inline using TextBox dialog
            nameBtn.Visible = false
            local editor = Instance.new("TextBox")
            editor.Size = nameBtn.Size
            editor.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            editor.TextColor3 = Color3.fromRGB(255, 255, 255)
            editor.Text = wp.name
            editor.ClearTextOnFocus = false
            editor.Font = Enum.Font.GothamBold
            editor.TextSize = 14
            Instance.new("UICorner", editor).CornerRadius = UDim.new(0, 6)
            local st = Instance.new("UIStroke", editor)
            st.Thickness = 1
            st.Color = GUI_COLORS[currentTheme].color
            editor.Parent = row
            editor.FocusLost:Connect(function(enter)
                local newName = string.gsub(editor.Text, "%s*$", "")
                newName = string.gsub(newName, "^%s*", "")
                if newName ~= "" then wp.name = newName end
                editor:Destroy()
                nameBtn.Text = wp.name
                nameBtn.Visible = true
            end)
        end)

        tpBtn.MouseButton1Click:Connect(function()
            if rootPart then rootPart.CFrame = wp.cframe end
        end)
        delBtn.MouseButton1Click:Connect(function()
            table.remove(waypoints, i)
            refreshWpList()
        end)

        row.Parent = wpList
    end
end

addWpBtn.MouseButton1Click:Connect(function()
    if rootPart then
        local wp = { name = "WP"..tostring(#waypoints + 1), cframe = rootPart.CFrame }
        table.insert(waypoints, wp)
        refreshWpList()
    end
end)

-- ---- Theme
local themeBtn = makeBtn(themeSection, GUI_COLORS[currentTheme].name)
local function updateTheme()
    stroke.Color = GUI_COLORS[currentTheme].color
    title.TextColor3 = GUI_COLORS[currentTheme].color
    presetInfo.TextColor3 = GUI_COLORS[currentTheme].color
    tpPlayerLabel.TextColor3 = GUI_COLORS[currentTheme].color
    themeLabel.TextColor3 = GUI_COLORS[currentTheme].color
    wpLabel.TextColor3 = GUI_COLORS[currentTheme].color
    speedLabel.TextColor3 = GUI_COLORS[currentTheme].color
    for _, frame in ipairs({content, playerList, wpList}) do
        for _, d in ipairs(frame:GetDescendants()) do
            if d:IsA("UIStroke") then
                d.Color = GUI_COLORS[currentTheme].color
            end
            if d:IsA("TextLabel") and d.TextColor3 == presetInfo.TextColor3 then
                d.TextColor3 = GUI_COLORS[currentTheme].color
            end
        end
    end
end
themeBtn.MouseButton1Click:Connect(function()
    currentTheme = (currentTheme % #GUI_COLORS) + 1
    themeBtn.Text = GUI_COLORS[currentTheme].name
    updateTheme()
end)

-- ====== BUTTON LOGIC ======
local function setBtnState(btn, on) btn.Text = btn.Text:gsub(" : .*$", "").." : "..(on and "ON" or "OFF") end

local function toggleFly()
    FLY_ENABLED = not FLY_ENABLED
    if FLY_ENABLED then
        if bodyVelocity then bodyVelocity:Destroy() end
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bodyVelocity.Velocity = Vector3.zero
        bodyVelocity.Parent = rootPart
        rootPart.AssemblyLinearVelocity = Vector3.zero
    else
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        rootPart.AssemblyLinearVelocity = Vector3.zero
    end
    setBtnState(flyBtn, FLY_ENABLED)
end

local function toggleNoClip()
    NOCLIP_ENABLED = not NOCLIP_ENABLED
    setBtnState(noclipBtn, NOCLIP_ENABLED)
end

local function toggleSpeed()
    SPEED_ENABLED = not SPEED_ENABLED
    setBtnState(speedBtn, SPEED_ENABLED)
end

local function toggleInfJump()
    INFJUMP_ENABLED = not INFJUMP_ENABLED
    setBtnState(infJumpBtn, INFJUMP_ENABLED)
end

local function toggleJumpBoost()
    JUMPBOOST_ENABLED = not JUMPBOOST_ENABLED
    if humanoid then humanoid.JumpPower = JUMPBOOST_ENABLED and JUMP_POWER_ON or JUMP_POWER_OFF end
    setBtnState(jumpBoostBtn, JUMPBOOST_ENABLED)
end

local function toggleESP()
    ESP_ENABLED = not ESP_ENABLED
    if not ESP_ENABLED then
        for _, adorn in pairs(espAdornments) do if adorn and adorn.Destroy then adorn:Destroy() end end
        espAdornments = {}
    end
    setBtnState(espBtn, ESP_ENABLED)
end

local function toggleGodMode()
    GODMODE_ENABLED = not GODMODE_ENABLED
    setBtnState(godModeBtn, GODMODE_ENABLED)
end

local function toggleAntiAFK()
    ANTIAFK_ENABLED = not ANTIAFK_ENABLED
    setBtnState(antiAfkBtn, ANTIAFK_ENABLED)
end

-- Bind UI Buttons
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
resetBtn.MouseButton1Click:Connect(function()
    if humanoid then humanoid.Health = 0 end
end)

btnClose.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

btnMin.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    themeSection.Visible = not minimized
    if minimized then
        mainFrame.Size = UDim2.new(0, 300, 0, 52)
    else
        mainFrame.Size = UDim2.new(0, 300, 0, 610)
    end
end)

-- Speed +/-
plusBtn.MouseButton1Click:Connect(function()
    if currentSpeedMult < 8 then
        currentSpeedMult = currentSpeedMult + 1
        speedLabel.Text = "⚡ Speed: x"..tostring(currentSpeedMult)
    end
end)
minusBtn.MouseButton1Click:Connect(function()
    if currentSpeedMult > 1 then
        currentSpeedMult = currentSpeedMult - 1
        speedLabel.Text = "⚡ Speed: x"..tostring(currentSpeedMult)
    end
end)

-- ====== INPUT SHORTCUTS ======
UIS.InputBegan:Connect(function(i, g)
    if g then return end -- ignore when focused on TextBox etc.
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

-- ====== FEATURE HANDLERS ======

-- Smooth Fly (less slippery)
local lastVel = Vector3.zero
RunService.Heartbeat:Connect(function(dt)
    if FLY_ENABLED and rootPart then
        local move = Vector3.new()
        local camCF = workspace.CurrentCamera.CFrame
        local look, right = camCF.LookVector, camCF.RightVector
        if UIS:IsKeyDown(Enum.KeyCode.W) then move += look end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move -= look end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move -= right end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move += right end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0, 1, 0) end

        local target = Vector3.zero
        if move.Magnitude > 0 then
            target = move.Unit * (BASE_FLY_SPEED * currentSpeedMult)
        end
        -- simple smoothing
        lastVel = lastVel:Lerp(target, math.clamp(10 * dt, 0, 1))
        if not bodyVelocity or bodyVelocity.Parent ~= rootPart then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bodyVelocity.Parent = rootPart
        end
        bodyVelocity.Velocity = lastVel
        if target.Magnitude < 0.1 then
            rootPart.AssemblyLinearVelocity = Vector3.zero
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

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if INFJUMP_ENABLED and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ESP
RunService.RenderStepped:Connect(function()
    if ESP_ENABLED then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                if not espAdornments[p] or not espAdornments[p].Parent then
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
                if adorn and adorn.Destroy then adorn:Destroy() end
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

-- Init theme
updateTheme()
notify("Yuda Hub", "Loaded ✅", 2)
