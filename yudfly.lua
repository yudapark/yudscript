-- LocalScript di StarterGui
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local flySpeed = 50
local bodyVelocity

-- Buat GUI Button
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 120, 0, 50)
flyButton.Position = UDim2.new(0.05, 0, 0.8, 0)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Parent = screenGui

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
	else
		flyButton.Text = "Fly: OFF"
		flyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		if bodyVelocity then bodyVelocity:Destroy() end
	end
end

flyButton.MouseButton1Click:Connect(toggleFly)

-- Input & Gerakan Fly
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

RunService.Heartbeat:Connect(function()
	if flying and bodyVelocity then
		local moveDir = Vector3.new(0,0,0)
		local camCF = workspace.CurrentCamera.CFrame

		-- W (maju) & S (mundur)
		if UIS:IsKeyDown(Enum.KeyCode.W) then
			moveDir = moveDir + camCF.LookVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.S) then
			moveDir = moveDir - camCF.LookVector
		end

		-- A (kiri) & D (kanan)
		if UIS:IsKeyDown(Enum.KeyCode.A) then
			moveDir = moveDir - camCF.RightVector
		end
		if UIS:IsKeyDown(Enum.KeyCode.D) then
			moveDir = moveDir + camCF.RightVector
		end

		-- Spasi (naik) & Ctrl (turun)
		if UIS:IsKeyDown(Enum.KeyCode.Space) then
			moveDir = moveDir + Vector3.new(0,1,0)
		end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
			moveDir = moveDir + Vector3.new(0,-1,0)
		end

		if moveDir.Magnitude > 0 then
			bodyVelocity.Velocity = moveDir.Unit * flySpeed
		else
			bodyVelocity.Velocity = Vector3.new(0,0,0)
		end
	end
end)
