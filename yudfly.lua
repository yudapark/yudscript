-- LocalScript @ StarterPlayerScripts
-- Versi Mobile: arah gerak pakai analog (MoveDirection), naik/turun pakai tombol GUI
-- Ada tombol Start/Stop, Minimize, Close

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ===== STATE =====
local flying = false
local minimized = false
local speed = 60
local verticalSpeed = 60
local accel = 10
local currentVel = Vector3.zero
local verticalInput = 0
local align

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
gui.IgnoreGuiInset = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(260, 120)
frame.Position = UDim2.new(0, 20, 0, 120)
frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
frame.BackgroundTransparency = 0.1
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

-- tombol minimize & close
local btnMin = Instance.new("TextButton")
btnMin.Size = UDim2.fromOffset(28, 24)
btnMin.Position = UDim2.new(1, -64, 0, 6)
btnMin.Text = "–"
btnMin.Font = Enum.Font.GothamBold
btnMin.TextSize = 18
btnMin.BackgroundColor3 = Color3.fromRGB(50,50,50)
btnMin.TextColor3 = Color3.fromRGB(255,255,255)
btnMin.Parent = frame
Instance.new("UICorner", btnMin).CornerRadius = UDim.new(0, 8)

local btnClose = Instance.new("TextButton")
btnClose.Size = UDim2.fromOffset(28, 24)
btnClose.Position = UDim2.new(1, -32, 0, 6)
btnClose.Text = "×"
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 18
btnClose.BackgroundColor3 = Color3.fromRGB(120,40,40)
btnClose.TextColor3 = Color3.fromRGB(255,255,255)
btnClose.Parent = frame
Instance.new("UICorner", btnClose).CornerRadius = UDim.new(0, 8)

-- tombol start/stop
local btnToggle = Instance.new("TextButton")
btnToggle.Size = UDim2.new(0, 110, 0, 36)
btnToggle.Position = UDim2.new(0, 10, 0, 48)
btnToggle.Text = "Start"
btnToggle.Font = Enum.Font.GothamBold
btnToggle.TextSize = 16
btnToggle.BackgroundColor3 = Color3.fromRGB(40,140,80)
btnToggle.TextColor3 = Color3.fromRGB(255,255,255)
btnToggle.Parent = frame
Instance.new("UICorner", btnToggle).CornerRadius = UDim.new(0, 10)

-- label speed
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 110, 0, 20)
speedLabel.Position = UDim2.new(0, 140, 0, 44)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: "..tostring(speed)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 14
speedLabel.TextColor3 = Color3.fromRGB(220,220,220)
speedLabel.Parent = frame

-- tombol speed -
local btnSpeedDown = Instance.new("TextButton")
btnSpeedDown.Size = UDim2.new(0, 36, 0, 28)
btnSpeedDown.Position = UDim2.new(0, 140, 0, 66)
btnSpeedDown.Text = "-10"
btnSpeedDown.Font = Enum.Font.GothamBold
btnSpeedDown.TextSize = 16
btnSpeedDown.BackgroundColor3 = Color3.fromRGB(50,50,50)
btnSpeedDown.TextColor3 = Color3.fromRGB(255,255,255)
btnSpeedDown.Parent = frame
Instance.new("UICorner", btnSpeedDown).CornerRadius = UDim.new(0, 8)

-- tombol speed +
local btnSpeedUp = Instance.new("TextButton")
btnSpeedUp.Size = UDim2.new(0, 36, 0, 28)
btnSpeedUp.Position = UDim2.new(0, 186, 0, 66)
btnSpeedUp.Text = "+10"
btnSpeedUp.Font = Enum.Font.GothamBold
btnSpeedUp.TextSize = 16
btnSpeedUp.BackgroundColor3 = Color3.fromRGB(50,50,50)
btnSpeedUp.TextColor3 = Color3.fromRGB(255,255,255)
btnSpeedUp.Parent = frame
Instance.new("UICorner", btnSpeedUp).CornerRadius = UDim.new(0, 8)

-- tombol naik/turun (mobile)
local btnUp = Instance.new("TextButton")
btnUp.Size = UDim2.fromOffset(60, 60)
btnUp.Position = UDim2.new(1, -80, 1, -160)
btnUp.Text = "↑"
btnUp.Font = Enum.Font.GothamBold
btnUp.TextSize = 28
btnUp.BackgroundColor3 = Color3.fromRGB(40,120,200)
btnUp.TextColor3 = Color3.fromRGB(255,255,255)
btnUp.Parent = gui
Instance.new("UICorner", btnUp).CornerRadius = UDim.new(1, 0)

local btnDown = Instance.new("TextButton")
btnDown.Size = UDim2.fromOffset(60, 60)
btnDown.Position = UDim2.new(1, -80, 1, -90)
btnDown.Text = "↓"
btnDown.Font = Enum.Font.GothamBold
btnDown.TextSize = 28
btnDown.BackgroundColor3 = Color3.fromRGB(200,80,40)
btnDown.TextColor3 = Color3.fromRGB(255,255,255)
btnDown.Parent = gui
Instance.new("UICorner", btnDown).CornerRadius = UDim.new(1, 0)

-- ===== GUI LOGIC =====
local function updateSpeedLabel()
	speedLabel.Text = "Speed: "..tostring(speed)
end

btnSpeedDown.MouseButton1Click:Connect(function()
	speed = math.clamp(speed - 10, 10, 300)
	verticalSpeed = speed
	updateSpeedLabel()
end)

btnSpeedUp.MouseButton1Click:Connect(function()
	speed = math.clamp(speed + 10, 10, 300)
	verticalSpeed = speed
	updateSpeedLabel()
end)

btnToggle.MouseButton1Click:Connect(function()
	flying = not flying
	btnToggle.Text = flying and "Stop" or "Start"
	btnToggle.BackgroundColor3 = flying and Color3.fromRGB(180,60,60) or Color3.fromRGB(40,140,80)
	local _, _, hum = getChar()
	if flying then
		hum:ChangeState(Enum.HumanoidStateType.Physics)
	else
		hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	end
end)

btnMin.MouseButton1Click:Connect(function()
	minimized = not minimized
	btnToggle.Visible = not minimized
	speedLabel.Visible = not minimized
	btnSpeedDown.Visible = not minimized
	btnSpeedUp.Visible = not minimized
	frame.Size = minimized and UDim2.fromOffset(260, 36) or UDim2.fromOffset(260, 120)
end)

btnClose.MouseButton1Click:Connect(function()
	gui:Destroy()
	flying = false
end)

btnUp.MouseButton1Down:Connect(function() verticalInput = 1 end)
btnUp.MouseButton1Up:Connect(function() verticalInput = 0 end)

btnDown.MouseButton1Down:Connect(function() verticalInput = -1 end)
btnDown.MouseButton1Up:Connect(function() verticalInput = 0 end)

-- ===== FLY LOOP =====
RunService.RenderStepped:Connect(function(dt)
	local char, hrp, hum = getChar()
	if flying then
		ensureAlign(hrp)
		local cam = workspace.CurrentCamera
		local moveDir = hum.MoveDirection -- otomatis sesuai analog
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
	if gui.Parent == nil then
		gui.Parent = player:WaitForChild("PlayerGui")
	end
end)

updateSpeedLabel()
