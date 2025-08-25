--[[
🔥 Universal Hack By Jebek Gacor — Modern GUI + Feature Pack
Author: Yuda (Jebek) — jebek.id
]]

-- ===== Services =====
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- ===== State =====
local humanoid, rootPart, bodyVelocity
local lastVel = Vector3.zero

local NOCLIP, FLY, SPEED, INFJUMP, JUMPBOOST = false, false, false, false, false
local ESP_ON, ESP_NAME_ON, ESP_HEALTH_ON = false, true, true
local GODMODE, ANTIAFK, SPECTATING = false, false, false
local AUTOHEAL_ON = false
local AUTO_FARM_ON = false
local HUB_VISIBLE = true

local BASE_FLY_SPEED = 50
local SPEED_MULT = 1 -- 1..8
local SPEED_PRESETS = {2,4,6,8}
local JUMP_POWER_ON, JUMP_POWER_OFF = 100, 50
local TELEPORT_DIST = 15
local ESP_COLOR_CYCLE = {
    Color3.fromRGB(0, 200, 255),
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(0, 255, 100),
    Color3.fromRGB(255, 170, 0),
    Color3.fromRGB(170, 0, 255)
}
local ESP_COLOR_INDEX = 1

local THEME_ACCENT = Color3.fromRGB(32, 200, 255)
local THEME_BG = Color3.fromRGB(15, 15, 20)
local THEME_BG_2 = Color3.fromRGB(22, 22, 28)

local waypoints = {}
local wpOrbs = {} -- [index] = {part=Part, billboard=BillboardGui}
local selectedPlayer: Player? = nil
local espAdorn = {} -- [player] = {box=BoxHandleAdornment, bill=BillboardGui}
local lastAction = tick()
local currentCamera = workspace.CurrentCamera
local farmTween

-- Keybind Map (editable via Macro Editor)
local Keybinds = {
    ToggleFly = Enum.KeyCode.F,
    ToggleNoclip = Enum.KeyCode.B,
    ToggleSpeed = Enum.KeyCode.G,
    ToggleInfJump = Enum.KeyCode.H,
    ToggleJumpBoost = Enum.KeyCode.J,
    ToggleESP = Enum.KeyCode.E,
    ToggleGod = Enum.KeyCode.M,
    ToggleAntiAFK = Enum.KeyCode.Zero,
    TeleportForward = Enum.KeyCode.Up,
    TeleportBack = Enum.KeyCode.Down,
    QuickTPSelected = Enum.KeyCode.T,
    ToggleHub = Enum.KeyCode.RightShift,
}

-- Files
local WP_FILE = "yudahub_waypoints.json"

-- ===== Utils =====
local function notify(title, text, dur)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title, Text = text, Duration = dur or 2
        })
    end)
end

local function safeWaitForChar()
    local char = player.Character or player.CharacterAdded:Wait()
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
end
safeWaitForChar()
player.CharacterAdded:Connect(function()
    safeWaitForChar()
    if SPECTATING then -- stop spectate on respawn
        SPECTATING = false
        currentCamera.CameraSubject = humanoid
        currentCamera.CameraType = Enum.CameraType.Custom
    end
end)

local function canFile()
    return writefile and readfile and (isfile ~= nil)
end

local function jsonEncode(tbl)
    return game:GetService("HttpService"):JSONEncode(tbl)
end
local function jsonDecode(str)
    return game:GetService("HttpService"):JSONDecode(str)
end

local function createRound(instance, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 12)
    c.Parent = instance
    return c
end
local function stroke(instance, thickness, color)
    local s = Instance.new("UIStroke")
    s.Thickness = thickness or 1
    s.Color = color or THEME_ACCENT
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = instance
    return s
end

-- ===== GUI (Modern) =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YudaHub2"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local root = Instance.new("Frame")
root.Size = UDim2.new(0, 860, 0, 520)
root.Position = UDim2.new(0.05, 0, 0.15, 0)
root.BackgroundColor3 = THEME_BG
root.BackgroundTransparency = 0.1
root.Active = true
root.Draggable = true
root.Parent = screenGui
createRound(root, 16)
stroke(root, 2, THEME_ACCENT)

-- Header
local header = Instance.new("Frame", root)
header.Size = UDim2.new(1, 0, 0, 44)
header.BackgroundColor3 = THEME_BG_2
header.BackgroundTransparency = 0.1
createRound(header, 16)
stroke(header, 1, THEME_ACCENT)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.new(0, 16, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔥 Universal Hack By Jebek Gacor"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = THEME_ACCENT

local btnHide = Instance.new("TextButton", header)
btnHide.Size = UDim2.new(0, 90, 0, 28)
btnHide.Position = UDim2.new(1, -100, 0.5, -14)
btnHide.Text = "Hide [RShift]"
btnHide.Font = Enum.Font.GothamBold
btnHide.TextSize = 13
btnHide.BackgroundColor3 = THEME_BG
btnHide.TextColor3 = Color3.new(1,1,1)
createRound(btnHide, 10)
stroke(btnHide, 1, THEME_ACCENT)

-- Sidebar Tabs
local sidebar = Instance.new("Frame", root)
sidebar.Size = UDim2.new(0, 160, 1, -54)
sidebar.Position = UDim2.new(0, 10, 0, 54)
sidebar.BackgroundColor3 = THEME_BG_2
sidebar.BackgroundTransparency = 0.1
createRound(sidebar, 16)
stroke(sidebar, 1, THEME_ACCENT)

local sideList = Instance.new("UIListLayout", sidebar)
sideList.Padding = UDim.new(0, 6)
sideList.FillDirection = Enum.FillDirection.Vertical
sideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideList.SortOrder = Enum.SortOrder.LayoutOrder

local function makeTabBtn(text)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -16, 0, 38)
    b.Position = UDim2.new(0, 8, 0, 0)
    b.Text = text
    b.BackgroundColor3 = THEME_BG
    b.TextColor3 = Color3.fromRGB(230,230,230)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    createRound(b, 10)
    stroke(b, 1, THEME_ACCENT)
    b.Parent = sidebar
    return b
end

local tabs = {"Toggles","Players","Waypoints","ESP","Farm","Macros","Extras","Scripts"}
local tabBtn = {}
for _,name in ipairs(tabs) do
    tabBtn[name] = makeTabBtn(name)
end

local content = Instance.new("Frame", root)
content.Size = UDim2.new(1, -190, 1, -64)
content.Position = UDim2.new(0, 180, 0, 54)
content.BackgroundTransparency = 1

local function makePage()
    local s = Instance.new("ScrollingFrame")
    s.Size = UDim2.new(1, 0, 1, 0)
    s.BackgroundTransparency = 1
    s.ScrollBarThickness = 5
    s.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local pad = Instance.new("UIPadding", s)
    pad.PaddingTop = UDim.new(0,6)
    pad.PaddingLeft = UDim.new(0,6)
    pad.PaddingRight = UDim.new(0,6)
    local list = Instance.new("UIListLayout", s)
    list.Padding = UDim.new(0, 8)
    list.FillDirection = Enum.FillDirection.Vertical
    list.HorizontalAlignment = Enum.HorizontalAlignment.Left
    return s
end

local pages = {}
for _,name in ipairs(tabs) do
    local p = makePage()
    p.Visible = false
    p.Parent = content
    pages[name] = p
end

local function showTab(name)
    for k,v in pairs(pages) do v.Visible = (k==name) end
end
showTab("Toggles")

for name,btn in pairs(tabBtn) do
    btn.MouseButton1Click:Connect(function()
        showTab(name)
    end)
end

local function makeButton(parent, text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 36)
    b.Text = text
    b.BackgroundColor3 = THEME_BG
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    createRound(b, 10)
    stroke(b, 1, THEME_ACCENT)
    b.Parent = parent
    if callback then b.MouseButton1Click:Connect(callback) end
    return b
end

local function makeRow(parent)
    local r = Instance.new("Frame")
    r.Size = UDim2.new(1, 0, 0, 36)
    r.BackgroundTransparency = 1
    local l = Instance.new("UIListLayout", r)
    l.FillDirection = Enum.FillDirection.Horizontal
    l.Padding = UDim.new(0, 6)
    r.Parent = parent
    return r
end

local function smallBtn(parent, text, width, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, width or 80, 1, 0)
    b.BackgroundColor3 = THEME_BG
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    createRound(b, 10)
    stroke(b, 1, THEME_ACCENT)
    b.Parent = parent
    if cb then b.MouseButton1Click:Connect(cb) end
    return b
end

local function label(parent, text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = THEME_ACCENT
    l.Font = Enum.Font.GothamBold
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

-- ====== Toggles Page ======
local pTog = pages["Toggles"]
local function stateText(flag) return flag and "ON" or "OFF" end

local bFly = makeButton(pTog, "✈️ Fly [F]: "..stateText(FLY), function()
    FLY = not FLY
    if FLY then
        if bodyVelocity then bodyVelocity:Destroy() end
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
        bodyVelocity.Velocity = Vector3.zero
        bodyVelocity.Parent = rootPart
        rootPart.AssemblyLinearVelocity = Vector3.zero
    else
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity=nil end
        rootPart.AssemblyLinearVelocity = Vector3.zero
    end
    bFly.Text = "✈️ Fly [F]: "..stateText(FLY)
end)

local bNoclip = makeButton(pTog, "🚪 NoClip [B]: "..stateText(NOCLIP), function()
    NOCLIP = not NOCLIP
    bNoclip.Text = "🚪 NoClip [B]: "..stateText(NOCLIP)
end)

local speedRow = makeRow(pTog)
label(speedRow, "⚡ Speed x"..SPEED_MULT)
local minus = smallBtn(speedRow, "-", 40, function()
    if SPEED_MULT>1 then SPEED_MULT -= 1 end
    speedRow:FindFirstChildOfClass("TextLabel").Text = "⚡ Speed x"..SPEED_MULT
end)
local plus = smallBtn(speedRow, "+", 40, function()
    if SPEED_MULT<8 then SPEED_MULT += 1 end
    speedRow:FindFirstChildOfClass("TextLabel").Text = "⚡ Speed x"..SPEED_MULT
end)
for _,p in ipairs(SPEED_PRESETS) do
    smallBtn(speedRow, "x"..p, 48, function()
        SPEED_MULT = p
        speedRow:FindFirstChildOfClass("TextLabel").Text = "⚡ Speed x"..SPEED_MULT
    end)
end

local bSpeed = makeButton(pTog, "⚡ Speed Hack [G]: "..stateText(SPEED), function()
    SPEED = not SPEED
    bSpeed.Text = "⚡ Speed Hack [G]: "..stateText(SPEED)
end)

local bInf = makeButton(pTog, "🌀 Infinite Jump [H]: "..stateText(INFJUMP), function()
    INFJUMP = not INFJUMP
    bInf.Text = "🌀 Infinite Jump [H]: "..stateText(INFJUMP)
end)

local bJump = makeButton(pTog, "⬆️ Jump Boost [J]: "..stateText(JUMPBOOST), function()
    JUMPBOOST = not JUMPBOOST
    if humanoid then humanoid.JumpPower = JUMPBOOST and JUMP_POWER_ON or JUMP_POWER_OFF end
    bJump.Text = "⬆️ Jump Boost [J]: "..stateText(JUMPBOOST)
end)

local tpRow = makeRow(pTog)
label(tpRow, "Teleport:")
smallBtn(tpRow, "Forward", 90, function()
    if rootPart then rootPart.CFrame = rootPart.CFrame + rootPart.CFrame.LookVector * TELEPORT_DIST end
end)
smallBtn(tpRow, "Backward", 90, function()
    if rootPart then rootPart.CFrame = rootPart.CFrame - rootPart.CFrame.LookVector * TELEPORT_DIST end
end)
smallBtn(tpRow, "Random Safe", 120, function()
    if not rootPart then return end
    local origin = rootPart.Position + Vector3.new(0, 120, 0)
    -- Raycast straight down to find ground
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {player.Character}
    local result = workspace:Raycast(origin, Vector3.new(0, -500, 0), params)
    if result then
        local pos = result.Position + Vector3.new(0, 5, 0)
        rootPart.CFrame = CFrame.new(pos)
    else
        rootPart.CFrame = rootPart.CFrame + Vector3.new(0, 150, 0)
    end
end)

local bESP = makeButton(pTog, "👁️ ESP [E]: "..stateText(ESP_ON), function()
    ESP_ON = not ESP_ON
    bESP.Text = "👁️ ESP [E]: "..stateText(ESP_ON)
    if not ESP_ON then
        for p,pack in pairs(espAdorn) do
            if pack.box then pack.box:Destroy() end
            if pack.bill then pack.bill:Destroy() end
            espAdorn[p] = nil
        end
    end
end)

local bGod = makeButton(pTog, "🛡️ God Mode [M]: "..stateText(GODMODE), function()
    GODMODE = not GODMODE
    bGod.Text = "🛡️ God Mode [M]: "..stateText(GODMODE)
end)

local bAfk = makeButton(pTog, "😴 Anti-AFK [0]: "..stateText(ANTIAFK), function()
    ANTIAFK = not ANTIAFK
    bAfk.Text = "😴 Anti-AFK [0]: "..stateText(ANTIAFK)
end)

local bReset = makeButton(pTog, "♻️ Reset Character", function()
    if humanoid then humanoid.Health = 0 end
end)

-- ====== Players Page (Search + Spectate + TP) ======
local pPlayers = pages["Players"]
local searchRow = makeRow(pPlayers)
local searchBox = Instance.new("TextBox", searchRow)
searchBox.Size = UDim2.new(1, 0, 1, 0)
searchBox.BackgroundColor3 = THEME_BG
searchBox.TextColor3 = Color3.fromRGB(230,230,230)
searchBox.PlaceholderText = "Cari nama pemain..."
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14
createRound(searchBox, 10)
stroke(searchBox, 1, THEME_ACCENT)

local listPlayers = Instance.new("ScrollingFrame", pPlayers)
listPlayers.Size = UDim2.new(1, 0, 0, 160)
listPlayers.BackgroundTransparency = 1
listPlayers.ScrollBarThickness = 5
listPlayers.AutomaticCanvasSize = Enum.AutomaticSize.Y
local lpl = Instance.new("UIListLayout", listPlayers)
lpl.Padding = UDim.new(0, 6)

local function makeListButton(parent, text)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 32)
    b.Text = text
    b.BackgroundColor3 = THEME_BG
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    createRound(b, 10)
    stroke(b, 1, THEME_ACCENT)
    b.Parent = parent
    return b
end

local function refreshPlayerList()
    for _,c in ipairs(listPlayers:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local q = string.lower(searchBox.Text or "")
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local ok = (q=="") or (string.find(string.lower(p.Name), q, 1, true)~=nil)
            if ok then
                local b = makeListButton(listPlayers, p.Name)
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

searchBox:GetPropertyChangedSignal("Text"):Connect(refreshPlayerList)
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)
refreshPlayerList()

local pr = makeRow(pPlayers)
label(pr, "Spectate / TP Selected:")
smallBtn(pr, "Spectate", 100, function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Humanoid") then
        SPECTATING = true
        currentCamera.CameraSubject = selectedPlayer.Character:FindFirstChild("Humanoid")
        currentCamera.CameraType = Enum.CameraType.Custom
    else
        notify("Spectate", "Pilih player terlebih dahulu.", 2)
    end
end)
smallBtn(pr, "Unspectate", 110, function()
    SPECTATING = false
    currentCamera.CameraSubject = humanoid
    currentCamera.CameraType = Enum.CameraType.Custom
end)
smallBtn(pr, "TP [T]", 80, function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        rootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame
    end
end)

-- ====== Waypoints Page ======
local pWP = pages["Waypoints"]
local addWp = makeButton(pWP, "➕ Add Waypoint (posisi sekarang)", function()
    if rootPart then
        local wp = {name="WP"..tostring(#waypoints+1), cframe=rootPart.CFrame}
        table.insert(waypoints, wp)
        local idx = #waypoints
        -- 3D marker
        local orb = Instance.new("Part")
        orb.Shape = Enum.PartType.Ball
        orb.Color = THEME_ACCENT
        orb.Material = Enum.Material.Neon
        orb.Anchored = true
        orb.CanCollide = false
        orb.Transparency = 0.25
        orb.Size = Vector3.new(1.6,1.6,1.6)
        orb.Position = wp.cframe.Position + Vector3.new(0,2,0)
        orb.Parent = workspace
        local bill = Instance.new("BillboardGui")
        bill.Size = UDim2.new(0, 120, 0, 20)
        bill.Adornee = orb
        bill.AlwaysOnTop = true
        bill.Parent = orb
        local txt = Instance.new("TextLabel", bill)
        txt.Size = UDim2.new(1,0,1,0)
        txt.BackgroundTransparency = 1
        txt.Text = wp.name
        txt.Font = Enum.Font.GothamBold
        txt.TextSize = 14
        txt.TextColor3 = Color3.new(1,1,1)
        wpOrbs[idx] = {part=orb, billboard=bill, label=txt}
        refreshWpList()
    end
end)

local listWP = Instance.new("ScrollingFrame", pWP)
listWP.Size = UDim2.new(1, 0, 0, 200)
listWP.BackgroundTransparency = 1
listWP.ScrollBarThickness = 5
listWP.AutomaticCanvasSize = Enum.AutomaticSize.Y
local lwp = Instance.new("UIListLayout", listWP)
lwp.Padding = UDim.new(0, 6)

function refreshWpList()
    for _,c in ipairs(listWP:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    for i,wp in ipairs(waypoints) do
        local row = makeRow(listWP)
        local nameBtn = smallBtn(row, wp.name, 170, function()
            nameBtn.Visible=false
            local editor = Instance.new("TextBox", row)
            editor.Size = UDim2.new(0, 170, 1, 0)
            editor.BackgroundColor3 = THEME_BG
            editor.TextColor3 = Color3.new(1,1,1)
            editor.Text = wp.name
            editor.ClearTextOnFocus = false
            editor.Font = Enum.Font.GothamBold
            editor.TextSize = 14
            createRound(editor, 10)
            stroke(editor,1,THEME_ACCENT)
            editor.FocusLost:Connect(function()
                local newName = editor.Text:gsub("^%s+",""):gsub("%s+$","")
                if newName ~= "" then wp.name = newName end
                if wpOrbs[i] and wpOrbs[i].label then wpOrbs[i].label.Text = wp.name end
                nameBtn.Text = wp.name
                editor:Destroy(); nameBtn.Visible=true
            end)
        end)
        smallBtn(row, "TP", 60, function()
            if rootPart then rootPart.CFrame = wp.cframe end
        end)
        smallBtn(row, "Del", 60, function()
            table.remove(waypoints, i)
            if wpOrbs[i] and wpOrbs[i].part then wpOrbs[i].part:Destroy() end
            wpOrbs[i] = nil
            refreshWpList()
        end)
    end
end

local saveloadRow = makeRow(pWP)
smallBtn(saveloadRow, "💾 Save", 90, function()
    if canFile() then
        local data = {}
        for _,w in ipairs(waypoints) do table.insert(data, {name=w.name, cframe={w.cframe:GetComponents()}}) end
        writefile(WP_FILE, jsonEncode(data))
        notify("Waypoints", "Tersimpan ke "..WP_FILE, 2)
    else
        notify("Waypoints", "Save butuh writefile/readfile (exploit).", 3)
    end
end)
smallBtn(saveloadRow, "📂 Load", 90, function()
    if canFile() and (isfile(WP_FILE)) then
        local ok, decoded = pcall(function() return jsonDecode(readfile(WP_FILE)) end)
        if ok and type(decoded)=="table" then
            -- clear old
            for i,_ in ipairs(waypoints) do if wpOrbs[i] and wpOrbs[i].part then wpOrbs[i].part:Destroy() end end
            waypoints = {}
            wpOrbs = {}
            for _,d in ipairs(decoded) do
                local cf = CFrame.new(unpack(d.cframe))
                table.insert(waypoints, {name=d.name or ("WP"..tostring(#waypoints+1)), cframe=cf})
                local idx = #waypoints
                local orb = Instance.new("Part")
                orb.Shape = Enum.PartType.Ball
                orb.Color = THEME_ACCENT
                orb.Material = Enum.Material.Neon
                orb.Anchored = true
                orb.CanCollide = false
                orb.Transparency = 0.25
                orb.Size = Vector3.new(1.6,1.6,1.6)
                orb.Position = cf.Position + Vector3.new(0,2,0)
                orb.Parent = workspace
                local bill = Instance.new("BillboardGui")
                bill.Size = UDim2.new(0, 120, 0, 20)
                bill.Adornee = orb
                bill.AlwaysOnTop = true
                bill.Parent = orb
                local txt = Instance.new("TextLabel", bill)
                txt.Size = UDim2.new(1,0,1,0)
                txt.BackgroundTransparency = 1
                txt.Text = waypoints[idx].name
                txt.Font = Enum.Font.GothamBold
                txt.TextSize = 14
                txt.TextColor3 = Color3.new(1,1,1)
                wpOrbs[idx] = {part=orb, billboard=bill, label=txt}
            end
            refreshWpList()
            notify("Waypoints", "Loaded "..tostring(#waypoints).." WP", 2)
        else
            notify("Waypoints", "File rusak/invalid.", 2)
        end
    else
        notify("Waypoints", "Load butuh writefile/readfile (exploit).", 3)
    end
end)
refreshWpList()

-- ====== ESP Page ======
local pESP = pages["ESP"]
local bEspOn = makeButton(pESP, "👁️ Toggle ESP: "..stateText(ESP_ON), function()
    ESP_ON = not ESP_ON
    bEspOn.Text = "👁️ Toggle ESP: "..stateText(ESP_ON)
    if not ESP_ON then
        for p,pack in pairs(espAdorn) do
            if pack.box then pack.box:Destroy() end
            if pack.bill then pack.bill:Destroy() end
            espAdorn[p]=nil
        end
    end
end)
local rowEsp = makeRow(pESP)
label(rowEsp, "Labels:")
smallBtn(rowEsp, "Name: "..(ESP_NAME_ON and "ON" or "OFF"), 130, function(btn)
    ESP_NAME_ON = not ESP_NAME_ON
    btn.Text = "Name: "..(ESP_NAME_ON and "ON" or "OFF")
end)
smallBtn(rowEsp, "Health: "..(ESP_HEALTH_ON and "ON" or "OFF"), 150, function(btn)
    ESP_HEALTH_ON = not ESP_HEALTH_ON
    btn.Text = "Health: "..(ESP_HEALTH_ON and "ON" or "OFF")
end)
smallBtn(rowEsp, "Color", 90, function()
    ESP_COLOR_INDEX = (ESP_COLOR_INDEX % #ESP_COLOR_CYCLE) + 1
end)

-- ====== Farm Page ======
local pFarm = pages["Farm"]
local farmSpeed = 50
local farmWait = 0.2
local lblFarm = makeButton(pFarm, "▶️ Start Auto-Farm (loop waypoints)")
local function stopFarm()
    AUTO_FARM_ON = false
    if farmTween then farmTween:Cancel() end
    lblFarm.Text = "▶️ Start Auto-Farm (loop waypoints)"
end
lblFarm.MouseButton1Click:Connect(function()
    if AUTO_FARM_ON then stopFarm() return end
    if #waypoints == 0 then notify("Farm", "Buat/Load waypoint dulu.", 2) return end
    AUTO_FARM_ON = true
    lblFarm.Text = "⏸ Stop Auto-Farm"
    task.spawn(function()
        while AUTO_FARM_ON do
            for i,wp in ipairs(waypoints) do
                if not AUTO_FARM_ON then break end
                if rootPart then
                    local tween = TweenService:Create(rootPart, TweenInfo.new((rootPart.Position - wp.cframe.Position).Magnitude / math.max(1,farmSpeed), Enum.EasingStyle.Linear), {CFrame = wp.cframe})
                    farmTween = tween
                    tween:Play()
                    tween.Completed:Wait()
                    task.wait(farmWait)
                end
            end
        end
    end)
end)
local r2 = makeRow(pFarm)
label(r2, "Speed")
smallBtn(r2, "-", 40, function()
    farmSpeed = math.max(10, farmSpeed-10)
end)
smallBtn(r2, "+", 40, function()
    farmSpeed = math.min(250, farmSpeed+10)
end)
label(r2, "Delay")
smallBtn(r2, "-", 40, function()
    farmWait = math.max(0, farmWait-0.05)
end)
smallBtn(r2, "+", 40, function()
    farmWait = math.min(2, farmWait+0.05)
end)

-- ====== Macros (Keybind Editor) ======
local pMacros = pages["Macros"]
local macroInfo = Instance.new("TextLabel", pMacros)
macroInfo.Size = UDim2.new(1,0,0,40)
macroInfo.BackgroundTransparency = 1
macroInfo.TextColor3 = THEME_ACCENT
macroInfo.Font = Enum.Font.Gotham
macroInfo.TextSize = 14
macroInfo.TextXAlignment = Enum.TextXAlignment.Left
macroInfo.Text = "Klik tombol, lalu tekan key barumu."

local function addBindRow(actionName, keyName)
    local r = makeRow(pMacros)
    label(r, actionName)
    local b = smallBtn(r, tostring(Keybinds[keyName].Name), 120)
    b.MouseButton1Click:Connect(function()
        b.Text = "Press..."
        local con
        con = UIS.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                Keybinds[keyName] = input.KeyCode
                b.Text = input.KeyCode.Name
                notify("Keybind", actionName.." -> "..input.KeyCode.Name, 2)
                con:Disconnect()
            end
        end)
    end)
end

addBindRow("Toggle Fly", "ToggleFly")
addBindRow("Toggle NoClip", "ToggleNoclip")
addBindRow("Toggle Speed", "ToggleSpeed")
addBindRow("Toggle Infinite Jump", "ToggleInfJump")
addBindRow("Toggle Jump Boost", "ToggleJumpBoost")
addBindRow("Toggle ESP", "ToggleESP")
addBindRow("Toggle God Mode", "ToggleGod")
addBindRow("Toggle Anti-AFK", "ToggleAntiAFK")
addBindRow("Teleport Forward", "TeleportForward")
addBindRow("Teleport Back", "TeleportBack")
addBindRow("Quick TP Selected", "QuickTPSelected")
addBindRow("Toggle Hub Visibility", "ToggleHub")

-- ====== Extras Page (Auto-Heal, Hide Hub) ======
local pExtras = pages["Extras"]
local bHeal = makeButton(pExtras, "❤️‍🩹 Auto-Heal: "..stateText(AUTOHEAL_ON), function()
    AUTOHEAL_ON = not AUTOHEAL_ON
    bHeal.Text = "❤️‍🩹 Auto-Heal: "..stateText(AUTOHEAL_ON)
end)

local bHideHub = makeButton(pExtras, "🕶️ Hide/Show Hub [RightShift]", function()
    HUB_VISIBLE = not HUB_VISIBLE
    screenGui.Enabled = HUB_VISIBLE
end)

-- ====== Script Hub Page ======
local pScripts = pages["Scripts"]
local desc = Instance.new("TextLabel", pScripts)
desc.Size = UDim2.new(1,0,0,40)
desc.BackgroundTransparency = 1
desc.TextColor3 = THEME_ACCENT
desc.Font = Enum.Font.Gotham
desc.TextSize = 14
desc.TextXAlignment = Enum.TextXAlignment.Left
desc.Text = "Masukkan Lua (loadstring diperlukan di exploit)."

local codeBox = Instance.new("TextBox", pScripts)
codeBox.Size = UDim2.new(1,0,0,160)
codeBox.BackgroundColor3 = THEME_BG
codeBox.TextColor3 = Color3.fromRGB(230,230,230)
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 13
codeBox.ClearTextOnFocus = false
codeBox.MultiLine = true
createRound(codeBox, 10)
stroke(codeBox, 1, THEME_ACCENT)

makeButton(pScripts, "▶ Execute", function()
    local src = codeBox.Text
    if loadstring then
        local ok, fn = pcall(loadstring, src)
        if ok and type(fn)=="function" then
            local ok2, err = pcall(fn)
            if not ok2 then notify("Script Hub", "Runtime error: "..tostring(err), 3) end
        else
            notify("Script Hub", "Compile error.", 3)
        end
    else
        notify("Script Hub", "loadstring tidak tersedia.", 3)
    end
end)

-- ====== ESP Runtime ======
local function ensureESPFor(p)
    if not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = p.Character.HumanoidRootPart
    local pack = espAdorn[p]
    local color = ESP_COLOR_CYCLE[ESP_COLOR_INDEX]
    if not pack then pack = {} espAdorn[p] = pack end
    if not pack.box or not pack.box.Parent then
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = hrp
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Transparency = 0.5
        box.Size = hrp.Size + Vector3.new(0.5,0.5,0.5)
        box.Color3 = color
        box.Parent = hrp
        pack.box = box
    else
        pack.box.Color3 = color
    end
    if not pack.bill or not pack.bill.Parent then
        local bill = Instance.new("BillboardGui")
        bill.Adornee = hrp
        bill.Size = UDim2.new(0,140,0,34)
        bill.AlwaysOnTop = true
        bill.Parent = hrp
        local txt = Instance.new("TextLabel", bill)
        txt.Size = UDim2.new(1,0,1,0)
        txt.BackgroundTransparency = 1
        txt.Font = Enum.Font.GothamBold
        txt.TextSize = 14
        txt.TextColor3 = Color3.new(1,1,1)
        pack.bill = bill
        pack.text = txt
    end
    local nameStr = ESP_NAME_ON and p.Name or ""
    local healthStr = ""
    local hum = p.Character:FindFirstChildOfClass("Humanoid")
    if ESP_HEALTH_ON and hum then
        healthStr = string.format("  (%.0f/%d)", hum.Health, hum.MaxHealth)
    end
    if pack.text then pack.text.Text = nameStr..healthStr end
end

RunService.RenderStepped:Connect(function()
    if ESP_ON then
        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                ensureESPFor(p)
            end
        end
        -- cleanup
        for p,pack in pairs(espAdorn) do
            if not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then
                if pack.box then pack.box:Destroy() end
                if pack.bill then pack.bill:Destroy() end
                espAdorn[p] = nil
            end
        end
    end
end)

-- ====== Movement / Toggles Runtime ======
RunService.Heartbeat:Connect(function(dt)
    -- Fly (smooth)
    if FLY and rootPart then
        local move = Vector3.new()
        local camCF = currentCamera.CFrame
        local look, right = camCF.LookVector, camCF.RightVector
        if UIS:IsKeyDown(Enum.KeyCode.W) then move += look end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move -= look end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move -= right end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move += right end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
        local target = Vector3.zero
        if move.Magnitude>0 then target = move.Unit * (BASE_FLY_SPEED * SPEED_MULT) end
        lastVel = lastVel:Lerp(target, math.clamp(10*dt, 0, 1))
        if not bodyVelocity or bodyVelocity.Parent ~= rootPart then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
            bodyVelocity.Parent = rootPart
        end
        bodyVelocity.Velocity = lastVel
        if target.Magnitude < 0.1 then rootPart.AssemblyLinearVelocity = Vector3.zero end
    end

    -- God Mode
    if GODMODE and humanoid then
        humanoid.Health = humanoid.MaxHealth
    end

    -- Anti-AFK
    if ANTIAFK and tick() - lastAction >= 60 then
        if humanoid then humanoid:Jump() end
        lastAction = tick()
    end

    -- Auto-Heal
    if AUTOHEAL_ON and humanoid then
        if humanoid.Health < (humanoid.MaxHealth * 0.6) then
            local bp = player:FindFirstChild("Backpack")
            if bp then
                for _,itm in ipairs(bp:GetChildren()) do
                    if itm:IsA("Tool") then
                        local n = string.lower(itm.Name)
                        if n:find("med") or n:find("heal") or n:find("bandage") or n:find("kit") then
                            humanoid:EquipTool(itm)
                            task.wait(0.1)
                            pcall(function() itm:Activate() end)
                            task.wait(0.2)
                            humanoid:UnequipTools()
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- NoClip
RunService.Stepped:Connect(function()
    if NOCLIP and player.Character then
        for _,part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Speed
RunService.RenderStepped:Connect(function()
    if humanoid then
        humanoid.WalkSpeed = SPEED and (16 * SPEED_MULT) or 16
    end
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if INFJUMP and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ====== Inputs / Global Shortcuts ======
UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.UserInputType == Enum.UserInputType.Keyboard then
        local kc = i.KeyCode
        if kc == Keybinds.ToggleFly then 
            FLY = not FLY
            if FLY then
                if bodyVelocity then bodyVelocity:Destroy() end
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
                bodyVelocity.Velocity = Vector3.zero
                bodyVelocity.Parent = rootPart
                rootPart.AssemblyLinearVelocity = Vector3.zero
            else
                if bodyVelocity then bodyVelocity:Destroy() bodyVelocity=nil end
                rootPart.AssemblyLinearVelocity = Vector3.zero
            end
            bFly.Text = "✈️ Fly [F]: "..stateText(FLY)
        elseif kc == Keybinds.ToggleNoclip then 
            NOCLIP = not NOCLIP
            bNoclip.Text = "🚪 NoClip [B]: "..stateText(NOCLIP)
        elseif kc == Keybinds.ToggleSpeed then 
            SPEED = not SPEED
            bSpeed.Text = "⚡ Speed Hack [G]: "..stateText(SPEED)
        elseif kc == Keybinds.ToggleInfJump then 
            INFJUMP = not INFJUMP
            bInf.Text = "🌀 Infinite Jump [H]: "..stateText(INFJUMP)
        elseif kc == Keybinds.ToggleJumpBoost then 
            JUMPBOOST = not JUMPBOOST
            if humanoid then humanoid.JumpPower = JUMPBOOST and JUMP_POWER_ON or JUMP_POWER_OFF end
            bJump.Text = "⬆️ Jump Boost [J]: "..stateText(JUMPBOOST)
        elseif kc == Keybinds.TeleportForward then if rootPart then rootPart.CFrame = rootPart.CFrame + rootPart.CFrame.LookVector*TELEPORT_DIST end
        elseif kc == Keybinds.TeleportBack then if rootPart then rootPart.CFrame = rootPart.CFrame - rootPart.CFrame.LookVector*TELEPORT_DIST end
        elseif kc == Keybinds.ToggleESP then 
            ESP_ON = not ESP_ON
            bESP.Text = "👁️ ESP [E]: "..stateText(ESP_ON)
            if not ESP_ON then
                for p,pack in pairs(espAdorn) do
                    if pack.box then pack.box:Destroy() end
                    if pack.bill then pack.bill:Destroy() end
                    espAdorn[p] = nil
                end
            end
        elseif kc == Keybinds.ToggleGod then 
            GODMODE = not GODMODE
            bGod.Text = "🛡️ God Mode [M]: "..stateText(GODMODE)
        elseif kc == Keybinds.ToggleAntiAFK then 
            ANTIAFK = not ANTIAFK
            bAfk.Text = "😴 Anti-AFK [0]: "..stateText(ANTIAFK)
        elseif kc == Keybinds.QuickTPSelected then
            if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                rootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame
            end
        elseif kc == Keybinds.ToggleHub then
            HUB_VISIBLE = not HUB_VISIBLE
            screenGui.Enabled = HUB_VISIBLE
        end
    end
end)

-- Header Hide Button
btnHide.MouseButton1Click:Connect(function()
    HUB_VISIBLE = not HUB_VISIBLE
    screenGui.Enabled = HUB_VISIBLE
end)

-- Cleanup ESP on character respawn for others
Players.PlayerRemoving:Connect(function(p)
    local pack = espAdorn[p]
    if pack then
        if pack.box then pack.box:Destroy() end
        if pack.bill then pack.bill:Destroy() end
        espAdorn[p] = nil
    end
end)

-- Final
notify("Universal Hack By Jebek Gacor", "Loaded ✅", 3)
