-- YUDA FLY HUB
-- All-in-One Fly, Noclip, Speed, Jump, Teleport
-- Keybinds: B=NoClip, F=Fly, G=Speed, H=InfJump, J=JumpHeight, Arrows=Teleport

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Flags
local NOCLIP_ENABLED = false
local FLY_ENABLED = false
local SPEED_ENABLED = false
local INFJUMP_ENABLED = false
local JUMPBOOST_ENABLED = false

-- Settings
local FLY_SPEED = 50
local SPEED_MULTIPLIER = 8
local JUMP_POWER = 100
local TELEPORT_DIST = 15

local bodyVelocity
local humanoid, rootPart

-- Utility: Setup Char
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
mainFrame.Size = UDim2.new(0, 220, 0, 170)
mainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local UIStroke = Instance.new("UIStroke", mainFrame)
UIStroke.Color = Color3.fromRGB(0, 200, 255)
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🔥 YUDA HUB 🔥"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.BackgroundTransparency = 1

local statusBox = Instance.new("TextLabel", mainFrame)
statusBox.Size = UDim2.new(1, -10, 1, -40)
statusBox.Position = UDim2.new(0, 5, 0, 35)
statusBox.BackgroundTransparency = 1
statusBox.TextXAlignment = Enum.TextXAlignment.Left
statusBox.TextYAlignment = Enum.TextYAlignment.Top
statusBox.Font = Enum.Font.Code
statusBox.TextSize = 14
statusBox.TextColor3 = Color3.fromRGB(255,255,255)
statusBox.Text = ""

local function updateStatus()
	statusBox.Text = string.format(
		"F (Fly): %s\nB (NoClip): %s\nG (Speed): %s\nH (Inf Jump): %s\nJ (JumpBoost): %s\n↑↓ (Teleport)\n\nFly Speed: %d\nSpeed x%d\nJump Height: %d",
		FLY_ENABLED and "ON" or "OFF",
		NOCLIP_ENABLED and "ON" or "OFF",
		SPEED_ENABLED and "ON" or "OFF",
		INFJUMP_ENABLED and "ON" or "OFF",
		JUMPBOOST_ENABLED and "ON" or "OFF",
		FLY_SPEED,
		SPEED_MULTIPLIER,
		JUMP_POWER
	)
end
updateStatus()

-- Keybind Toggles
UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.B then
		NOCLIP_ENABLED = not NOCLIP_ENABLED
	elseif input.KeyCode == Enum.KeyCode.F then
		FLY_ENABLED = not FLY_ENABLED
		if FLY_ENABLED then
			bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.MaxForce = Vector3.new(4000,4000,4000)
			bodyVelocity.Velocity = Vector3.new(0,0,0)
			bodyVelocity.Parent = rootPart
		else
			if bodyVelocity then bodyVelocity:Destroy() end
		end
	elseif input.KeyCode == Enum.KeyCode.G then
		SPEED_ENABLED = not SPEED_ENABLED
	elseif input.KeyCode == Enum.KeyCode.H then
		INFJUMP_ENABLED = not INFJUMP_ENABLED
	elseif input.KeyCode == Enum.KeyCode.J then
		JUMPBOOST_ENABLED = not JUMPBOOST_ENABLED
		if humanoid then
			humanoid.UseJumpPower = true
			humanoid.JumpPower = JUMPBOOST_ENABLED and JUMP_POWER or 50
		end
	elseif input.KeyCode == Enum.KeyCode.Up then
		if rootPart then rootPart.CFrame = rootPart.CFrame + rootPart.CFrame.LookVector * TELEPORT_DIST end
	elseif input.KeyCode == Enum.KeyCode.Down then
		if rootPart then rootPart.CFrame = rootPart.CFrame - rootPart.CFrame.LookVector * TELEPORT_DIST end
	end
	updateStatus()
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
	if INFJUMP_ENABLED and humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- Fly Movement
RunService.Heartbeat:Connect(function()
	if FLY_ENABLED and rootPart and humanoid then
		local move = Vector3.new()
		local camCF = workspace.CurrentCamera.CFrame
		local look, right = camCF.LookVector, camCF.RightVector

		if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + look end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - look end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - right end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + right end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end

		if move.Magnitude > 0 then
			bodyVelocity.Velocity = move.Unit * FLY_SPEED
		else
			bodyVelocity.Velocity = Vector3.new(0,0,0)
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
	if SPEED_ENABLED and humanoid then
		humanoid.WalkSpeed = 16 * SPEED_MULTIPLIER
	else
		humanoid.WalkSpeed = 16
	end
end)

-- Cleanup on leave
player.AncestryChanged:Connect(function(_, parent)
	if not parent then
		if bodyVelocity then bodyVelocity:Destroy() end
		screenGui:Destroy()
	end
end)
