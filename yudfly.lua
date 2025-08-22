-- LocalScript di StarterGui
-- Fly GUI lengkap dengan: noclip, speed multiplier, draggable GUI, minimize/close, dan persist saat respawn

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local flying = false
local flySpeed = 50
local bodyVelocity
local currentMultiplier = 1

-- Fungsi ambil HumanoidRootPart tiap respawn
local function getRoot()
	local character = player.Character or player.CharacterAdded:Wait()
	return character:WaitForChild("HumanoidRootPart")
end

local humanoidRootPart = getRoot()
player.CharacterAdded:Connect(function(char)
	humanoidRootPart = char:WaitForChild("HumanoidRootPart")
	if flying then
		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Velocity = Vector3.new(0,0,0)
		bodyVelocity.MaxForce = Vector3.new(4000,4000,4000)
		bodyVelocity.Parent = humanoidRootPart
	end
end)

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 140)
mainFrame.Position = UDim2.new(0.05, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Fly Button
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 180, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 10)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Parent = mainFrame

-- Speed Dropdown
local speedDropdown = Instance.new("TextButton")
speedDropdown.Size = UDim2.new(0, 180, 0, 30)
speedDropdown.Position = UDim2.new(0, 10, 0, 55)
speedDropdown.Text = "Speed: x1"
speedDropdown.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
speedDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDropdown.Parent = mainFrame

local multipliers = {1,2,3,4,5,6,7}
local currentIndex = 1
speedDropdown.MouseButton1Click:Connect(function()
	currentIndex = currentIndex % #multipliers + 1
	currentMultiplier = multipliers[currentIndex]
	speedDropdown.Text = "Speed: x"..currentMultiplier
end)

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 60, 0, 25)
minimizeButton.Position = UDim2.new(1, -95, 0, 5)
minimizeButton.Text = "-"
minimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Parent = mainFrame

local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, child in pairs(mainFrame:GetChildren()) do
		if child ~= minimizeButton and child ~= closeButton then
			child.Visible = not minimized
		end
	end
	minimizeButton.Text = minimized and "+" or "-"
end)

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = mainFrame

closeButton.MouseButton1Click:Connect(function()
	screenGui.Enabled = false
end)

-- Fungsi Noclip
local function setNoclip(state)
	if player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide ~= nil then
				part.CanCollide = not state
			end
		end
	end
end

-- Toggle Fly
local function toggleFly()
	flying = not flying
	if flying then
		flyButton.Text = "Fly: ON"
		flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Velocity = Vector3.new(0,0,0)
		bodyVelocity.MaxForce = Vector3.new(4000,4000,4000)
		bodyVelocity.Parent = humanoidRootPart

		-- noclip aktif
		RunService.Stepped:Connect(function()
			if flying and player.Character then
				setNoclip(true)
			end
		end)
	else
		flyButton.Text = "Fly: OFF"
		flyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		if bodyVelocity then bodyVelocity:Destroy() end
		setNoclip(false)
	end
end
flyButton.MouseButton1Click:Connect(toggleFly)

-- Kontrol Fly
RunService.Heartbeat:Connect(function()
	if flying and bodyVelocity and humanoidRootPart then
		local moveDir = Vector3.new(0,0,0)
		local camCF = workspace.CurrentCamera.CFrame

		if UIS:IsKeyDown(Enum.KeyCode.W) then
			moveDir = moveDir + camCF.LookVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.S) then
			moveDir = moveDir - camCF.LookVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.A) then
			moveDir = moveDir - camCF.RightVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.D) then
			moveDir = moveDir + camCF.RightVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then
			moveDir = moveDir + Vector3.new(0,1,0)
		end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
			moveDir = moveDir + Vector3.new(0,-1,0)
		end

		if moveDir.Magnitude > 0 then
			bodyVelocity.Velocity = moveDir.Unit * flySpeed * currentMultiplier
		else
			bodyVelocity.Velocity = Vector3.new(0,0,0)
		end
	end
end)
