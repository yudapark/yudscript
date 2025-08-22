-- LocalScript @ StarterPlayerScripts
-- Fly Controller Mobile + Speed Preset + Noclip + Waypoint Teleport + Theme UI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ===== STATE =====
local flying = false
local minimized = false
local noclip = false
local baseSpeed = 30
local speed = baseSpeed
local verticalSpeed = baseSpeed
local accel = 10
local currentVel = Vector3.zero
local verticalInput = 0
local align
local waypoints = {} -- table untuk simpan waypoint
local themes = {
	["Dark"] = {bg=Color3.fromRGB(22,22,22), btn=Color3.fromRGB(40,140,80)},
	["Neon"] = {bg=Color3.fromRGB(10,10,40), btn=Color3.fromRGB(80,0,200)},
	["Retro"] = {bg=Color3.fromRGB(40,20,0), btn=Color3.fromRGB(200,120,40)},
}
local currentTheme = "Dark"

-- ===== UTIL =====
local function getChar()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local hum = char:WaitForChild("Humanoid")
	return char, hrp, hum
end

local function ensureAlign(hrp)
	if align and align.Parent == hrp then return end
	if align then align:Destroy() end
	align = Instance.new("AlignOrientation")
	align.Mode = Enum.OrientationAlignmentMode.OneAttachment
	align.RigidityEnabled = true
	local att = Instance.new("Attachment", hrp)
	align.Attachment0 = att
	align.Responsiveness = 200
	align.Parent = hrp
end

-- ===== GUI BUILD =====
local gui = Instance.new("ScreenGui")
gui.Name = "FlyMobileUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(300, 220)
frame.Position = UDim2.new(0, 20, 0, 120)
frame.BackgroundColor3 = themes[currentTheme].bg
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 0, 28)
title.Position = UDim2.new(0, 10, 0, 6)
title.BackgroundTransparency = 1
title.Text = "Fly Controller (Mobile)"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local function makeBtn(parent, text, size, pos, color)
	local b = Instance.new("TextButton")
	b.Size = size
	b.Position = pos
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.BackgroundColor3 = color or themes[currentTheme].btn
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Parent = parent
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
	return b
end

-- Minimize / Close
local btnMin = makeBtn(frame,"–",UDim2.fromOffset(28,24),UDim2.new(1,-64,0,6),Color3.fromRGB(50,50,50))
local btnClose = makeBtn(frame,"×",UDim2.fromOffset(28,24),UDim2.new(1,-32,0,6),Color3.fromRGB(120,40,40))

-- Start / Stop
local btnToggle = makeBtn(frame,"Start",UDim2.new(0,110,0,36),UDim2.new(0,10,0,48))

-- Noclip
local btnNoclip = makeBtn(frame,"Noclip: OFF",UDim2.new(0,110,0,36),UDim2.new(0,150,0,48),Color3.fromRGB(80,80,120))

-- Preset Speed
local presetFrame = Instance.new("Frame")
presetFrame.Size = UDim2.fromOffset(260, 30)
presetFrame.Position = UDim2.new(0, 10, 0, 90)
presetFrame.BackgroundTransparency = 1
presetFrame.Parent = frame
for i=1,8 do
	local btn = makeBtn(presetFrame,"x"..i,UDim2.fromOffset(28,28),UDim2.new(0,(i-1)*32,0,0),Color3.fromRGB(60,60,60))
	btn.MouseButton1Click:Connect(function()
		speed = baseSpeed * i
		verticalSpeed = speed
		for _,b in ipairs(presetFrame:GetChildren()) do
			if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(60,60,60) end
		end
		btn.BackgroundColor3 = themes[currentTheme].btn
	end)
end

-- Waypoint Controls
local waypointFrame = Instance.new("Frame")
waypointFrame.Size = UDim2.fromOffset(260, 60)
waypointFrame.Position = UDim2.new(0, 10, 0, 130)
waypointFrame.BackgroundTransparency = 1
waypointFrame.Parent = frame

local btnSaveWP = makeBtn(waypointFrame,"Save WP",UDim2.fromOffset(80,28),UDim2.new(0,0,0,0),Color3.fromRGB(60,120,60))
local btnTpWP = makeBtn(waypointFrame,"TP WP",UDim2.fromOffset(80,28),UDim2.new(0,90,0,0),Color3.fromRGB(120,60,60))
local btnClearWP = makeBtn(waypointFrame,"Clear",UDim2.fromOffset(70,28),UDim2.new(0,180,0,0),Color3.fromRGB(80,80,80))

-- Theme Dropdown
local themeDropdown = Instance.new("TextButton")
themeDropdown.Size = UDim2.fromOffset(120, 28)
themeDropdown.Position = UDim2.new(0, 10, 0, 170)
themeDropdown.Text = "Theme: "..currentTheme
themeDropdown.Font = Enum.Font.GothamBold
themeDropdown.TextSize = 14
themeDropdown.BackgroundColor3 = Color3.fromRGB(80,80,80)
themeDropdown.TextColor3 = Color3.fromRGB(255,255,255)
themeDropdown.Parent = frame
Instance.new("UICorner", themeDropdown).CornerRadius = UDim.new(0, 8)

-- Naik / Turun
local btnUp = makeBtn(gui,"↑",UDim2.fromOffset(60,60),UDim2.new(1,-80,1,-160),Color3.fromRGB(40,120,200))
btnUp.TextSize = 28
local btnDown = makeBtn(gui,"↓",UDim2.fromOffset(60,60),UDim2.new(1,-80,1,-90),Color3.fromRGB(200,80,40))
btnDown.TextSize = 28

-- ===== LOGIC =====
btnToggle.MouseButton1Click:Connect(function()
	flying = not flying
	btnToggle.Text = flying and "Stop" or "Start"
	btnToggle.BackgroundColor3 = flying and Color3.fromRGB(180,60,60) or themes[currentTheme].btn
	local _, _, hum = getChar()
	if flying then hum:ChangeState(Enum.HumanoidStateType.Physics)
	else hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics) end
end)

btnNoclip.MouseButton1Click:Connect(function()
	noclip = not noclip
	btnNoclip.Text = noclip and "Noclip: ON" or "Noclip: OFF"
	btnNoclip.BackgroundColor3 = noclip and Color3.fromRGB(200,80,80) or Color3.fromRGB(80,80,120)
end)

btnSaveWP.MouseButton1Click:Connect(function()
	local _, hrp = getChar()
	table.insert(waypoints, hrp.CFrame)
	btnSaveWP.Text = "Saved ("..#waypoints..")"
end)

btnTpWP.MouseButton1Click:Connect(function()
	if #waypoints > 0 then
		local _, hrp = getChar()
		hrp.CFrame = waypoints[#waypoints]
	end
end)

btnClearWP.MouseButton1Click:Connect(function()
	waypoints = {}
	btnSaveWP.Text = "Save WP"
end)

themeDropdown.MouseButton1Click:Connect(function()
	local keys = {}
	for k,_ in pairs(themes) do table.insert(keys,k) end
	local nextIndex = table.find(keys,currentTheme) % #keys + 1
	currentTheme = keys[nextIndex]
	themeDropdown.Text = "Theme: "..currentTheme
	frame.BackgroundColor3 = themes[currentTheme].bg
	btnToggle.BackgroundColor3 = themes[currentTheme].btn
end)

btnUp.MouseButton1Down:Connect(function() verticalInput = 1 end)
btnUp.MouseButton1Up:Connect(function() verticalInput = 0 end)
btnDown.MouseButton1Down:Connect(function() verticalInput = -1 end)
btnDown.MouseButton1Up:Connect(function() verticalInput = 0 end)

btnMin.MouseButton1Click:Connect(function()
	minimized = not minimized
	btnToggle.Visible = not minimized
	btnNoclip.Visible = not minimized
	presetFrame.Visible = not minimized
	waypointFrame.Visible = not minimized
	themeDropdown.Visible = not minimized
	frame.Size = minimized and UDim2.fromOffset(300, 36) or UDim2.fromOffset(300, 220)
end)

btnClose.MouseButton1Click:Connect(function()
	gui:Destroy()
	flying = false
end)

-- ===== FLY LOOP =====
RunService.RenderStepped:Connect(function(dt)
	local char, hrp, hum = getChar()
	if flying then
		ensureAlign(hrp)
		local cam = workspace.CurrentCamera
		local moveDir = hum.MoveDirection
		local moveH = Vector3.new(moveDir.X, 0, moveDir.Z)
		local moveV = Vector3.new(0, verticalInput, 0)

		local desired = Vector3.zero
		if moveH.Magnitude > 0 then desired += moveH.Unit * speed end
		if moveV.Magnitude ~= 0 then desired += moveV.Unit * verticalSpeed end

		currentVel = currentVel:Lerp(desired, math.clamp(accel * dt, 0, 1))
		hrp.AssemblyLinearVelocity = Vector3.new(currentVel.X, currentVel.Y, currentVel.Z)

		local _, y, _ = cam.CFrame:ToOrientation()
		align.CFrame = CFrame.Angles(0, y, 0)

		hum.PlatformStand = true
		if noclip then
			for _,v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") then v.CanCollide = false end
			end
		end
	else
		if hum.PlatformStand then hum.PlatformStand = false end
		currentVel = currentVel:Lerp(Vector3.zero, math.clamp(accel * dt, 0, 1))
		if align then align:Destroy() align = nil end
	end
end)

-- Reset saat respawn
player.CharacterAdded:Connect(function()
	flying = false
	currentVel = Vector3.zero
	if align then align:Destroy() align = nil end
	if gui.Parent == nil then gui.Parent = player:WaitForChild("PlayerGui") end
end)
