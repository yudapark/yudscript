-- 🔥 JEBEK.ID - Anti AFK GUI 🔥
-- Taruh script ini sebagai LocalScript di StarterPlayerScripts

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

-- ===== GUI BUATAN =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiAFK_GUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 80)
Frame.Position = UDim2.new(0.5, -100, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.4, 0)
Title.Text = "🔥 Anti AFK JEBEK GACOR 🔥"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.8, 0, 0.4, 0)
ToggleButton.Position = UDim2.new(0.1, 0, 0.5, 0)
ToggleButton.Text = "OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextScaled = true
ToggleButton.Parent = Frame

local UICorner2 = Instance.new("UICorner", ToggleButton)
UICorner2.CornerRadius = UDim.new(0, 8)

-- ===== LOGIC ANTI AFK =====
local antiAFK = false
local connection

ToggleButton.MouseButton1Click:Connect(function()
	if antiAFK then
		-- MATIKAN
		antiAFK = false
		if connection then connection:Disconnect() end
		ToggleButton.Text = "OFF"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	else
		-- HIDUPKAN
		antiAFK = true
		connection = player.Idled:Connect(function()
			VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
			task.wait(1)
			VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
		end)
		ToggleButton.Text = "ON"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	end
end)
