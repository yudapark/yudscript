-- 🔥 YUDA HUB FINAL 🔥
-- by yudapark

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Flags
local NOCLIP_ENABLED, FLY_ENABLED, SPEED_ENABLED, INFJUMP_ENABLED, JUMPBOOST_ENABLED = false, false, false, false, false

-- Settings
local BASE_FLY_SPEED = 50
local currentSpeedMult = 1
local JUMP_POWER = 100
local TELEPORT_DIST = 15

local bodyVelocity
local humanoid, rootPart

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
mainFrame.Size = UDim2.new(0, 260, 0, 340)
mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local UIStroke = Instance.new("UIStroke", mainFrame)
UIStroke.Color = Color3.fromRGB(0, 200, 255)
UIStroke.Thickness = 2

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, -60, 0, 30)
title.Text = "🔥 YUDA HUB 🔥"
title.TextColor3 = Color3.fromRGB(0,200,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BackgroundTransparency = 1
title.Position = UDim2.new(0,10,0,0)

-- Close & Minimize
local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0,25,0,25)
closeBtn.Position = UDim2.new(1,-30,0,2)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,0,0)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.BackgroundTransparency = 1

local minBtn = Instance.new("TextButton", mainFrame)
minBtn.Size = UDim2.new(0,25,0,25)
minBtn.Position = UDim2.new(1,-60,0,2)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255,255,0)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.BackgroundTransparency = 1

local content = Instance.new("Frame", mainFrame)
content.Size = UDim2.new(1, -10, 1, -40)
content.Position = UDim2.new(0,5,0,35)
content.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", content)
UIList.Padding = UDim.new(0,5)
UIList.FillDirection = Enum.FillDirection.Vertical

-- Button Factory
local function makeBtn(text)
	local btn = Instance.new("TextButton", content)
	btn.Size = UDim2.new(1,0,0,30)
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Text = text
	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Color3.fromRGB(0,200,255)
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

-- Speed Control Frame
local speedFrame = Instance.new("Frame", content)
speedFrame.Size = UDim2.new(1,0,0,30)
speedFrame.BackgroundTransparency = 1

local minusBtn = Instance.new("TextButton", speedFrame)
minusBtn.Size = UDim2.new(0,40,1,0)
minusBtn.Text = "-"
minusBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
minusBtn.TextColor3 = Color3.fromRGB(255,255,255)
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 18

local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Size = UDim2.new(0.6,0,1,0)
speedLabel.Position = UDim2.new(0.2,0,0,0)
speedLabel.Text = "⚡ Speed: x1"
speedLabel.TextColor3 = Color3.fromRGB(0,200,255)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 14
speedLabel.BackgroundTransparency = 1

local plusBtn = Instance.new("TextButton", speedFrame)
plusBtn.Size = UDim2.new(0,40,1,0)
plusBtn.Position = UDim2.new(1,-40,0,0)
plusBtn.Text = "+"
plusBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
plusBtn.TextColor3 = Color3.fromRGB(255,255,255)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 18

speedFrame.Parent = content

local function updateSpeedLabel()
	speedLabel.Text = "⚡ Speed: x" .. tostring(currentSpeedMult)
end

plusBtn.MouseButton1Click:Connect(function()
	if currentSpeedMult < 8 then
		currentSpeedMult += 1
		updateSpeedLabel()
	end
end)

minusBtn.MouseButton1Click:Connect(function()
	if currentSpeedMult > 1 then
		currentSpeedMult -= 1
		updateSpeedLabel()
	end
end)

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

-- Close/Minimize
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)
local minimized = false
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	content.Visible = not minimized
	mainFrame.Size = minimized and UDim2.new(0,260,0,35) or UDim2.new(0,260,0,340)
end)

-- Keyboard Shortcuts
UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.F then toggleFly()
	elseif i.KeyCode == Enum.KeyCode.B then toggleNoClip()
	elseif i.KeyCode == Enum.KeyCode.G then toggleSpeed()
	elseif i.KeyCode == Enum.KeyCode.H then toggleInfJump()
	elseif i.KeyCode == Enum.KeyCode.J then toggleJumpBoost()
	elseif i.KeyCode == Enum.KeyCode.Up then if rootPart then rootPart.CFrame = rootPart.CFrame + rootPart.CFrame.LookVector * TELEPORT_DIST end
	elseif i.KeyCode == Enum.KeyCode.Down then if rootPart then rootPart.CFrame = rootPart.CFrame - rootPart.CFrame.LookVector * TELEPORT_DIST end
	end
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
	if INFJUMP_ENABLED and humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- Fly Handler (NO SLIDE / NO LICIN)
RunService.Heartbeat:Connect(function()
	if FLY_ENABLED and rootPart and humanoid and bodyVelocity then
		local move = Vector3.new()
		local camCF = workspace.CurrentCamera.CFrame
		local look, right = camCF.LookVector, camCF.RightVector

		if UIS:IsKeyDown(Enum.KeyCode.W) then move += look end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move -= look end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move -= right end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move += right end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end

		if move.Magnitude > 0 then
			bodyVelocity.Velocity = move.Unit * (BASE_FLY_SPEED * currentSpeedMult)
		else
			-- ❌ langsung berhenti, ga ngeluncur/geser
			bodyVelocity.Velocity = Vector3.zero
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
