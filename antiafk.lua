--[[
  Anti-AFK GUI (Mobile + PC)
  Single-file LocalScript — place in StarterPlayer > StarterPlayerScripts

  Features:
  - Toggle Anti-AFK ON/OFF (button + RightShift hotkey)
  - Choose method: VirtualUser / MicroMove / Jump
  - Adjustable interval (15–300s) with + / - controls and optional random jitter
  - Minimize / Close buttons, draggable window
  - Mobile-friendly large hit targets when touch is enabled

  Note: Some experiences may have custom anti-cheat/AFK logic. Use responsibly and at your own risk.
]]

--// Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local camera = workspace.CurrentCamera

--// State
local state = {
	enabled = false,
	method = "VirtualUser", -- "VirtualUser" | "MicroMove" | "Jump"
	interval = 60,          -- seconds
	jitter = true,          -- randomize interval +/- 20%
	minimized = false,
	closing = false,
}

--// Helpers
local function fmtSeconds(s)
	if s >= 60 then
		local m = math.floor(s/60)
		local r = s - m*60
		return string.format("%dm %ds", m, r)
	end
	return string.format("%ds", s)
end

local function nextWait()
	local t = state.interval
	if state.jitter then
		local jitter = math.clamp(t*0.2, 2, 30)
		t = math.max(5, t + math.random(-jitter, jitter))
	end
	return t
end

-- Slight camera nudge (imperceptible)
local function microMove()
	if not camera then return end
	local cf = camera.CFrame
	camera.CFrame = cf * CFrame.Angles(0, math.rad(1), 0)
	RunService.Heartbeat:Wait()
	camera.CFrame = cf
end

-- Light jump pulse
local function pulseJump()
	char = player.Character or char
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then hum.Jump = true end
end

-- VirtualUser click pulse
local function pulseVirtualUser()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new(0,0), camera.CFrame)
end

local function doPulse()
	if state.method == "MicroMove" then
		microMove()
	elseif state.method == "Jump" then
		pulseJump()
	else
		pulseVirtualUser()
	end
end

--// Core worker thread
local workerThread: thread? = nil
local function startWorker(updateStatus)
	if workerThread then return end
	workerThread = task.spawn(function()
		while state.enabled and not state.closing do
			local waitFor = nextWait()
			if updateStatus then updateStatus("Next pulse in "..fmtSeconds(waitFor).."…") end
			task.wait(waitFor)
			if not state.enabled or state.closing then break end
			doPulse()
			if updateStatus then updateStatus("Pulsed ("..state.method..") at "..os.date("%H:%M:%S")) end
		end
		workerThread = nil
	end)
end

local function stopWorker()
	state.enabled = false
end

-- Also hook Roblox's built-in Idled signal as a fallback
player.Idled:Connect(function()
	if state.enabled then
		pulseVirtualUser()
	end
end)

--// UI
local gui = Instance.new("ScreenGui")
gui.Name = "JebekAntiAFK"
-- Respect ResetOnSpawn so it survives respawn
gui.ResetOnSpawn = false

-- ZIndex behavior for clean layering
pcall(function()
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
end)

gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UIS.TouchEnabled and UDim2.fromOffset(360, 230) or UDim2.fromOffset(320, 210)
main.Position = UDim2.fromScale(0.5, 0.2)
main.AnchorPoint = Vector2.new(0.5, 0.0)
main.BackgroundColor3 = Color3.fromRGB(26, 26, 30)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 16)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 1
stroke.Color = Color3.fromRGB(70, 70, 80)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local padding = Instance.new("UIPadding", main)
padding.PaddingTop = UDim.new(0, 14)
padding.PaddingBottom = UDim.new(0, 14)
padding.PaddingLeft = UDim.new(0, 14)
padding.PaddingRight = UDim.new(0, 14)

local list = Instance.new("UIListLayout", main)
list.Padding = UDim.new(0, 10)
list.SortOrder = Enum.SortOrder.LayoutOrder

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.BackgroundTransparency = 1
header.Size = UDim2.new(1, 0, 0, 32)
header.LayoutOrder = 1
header.Parent = main

local hList = Instance.new("UIListLayout", header)
hList.FillDirection = Enum.FillDirection.Horizontal
hList.HorizontalAlignment = Enum.HorizontalAlignment.Left
hList.VerticalAlignment = Enum.VerticalAlignment.Center
hList.Padding = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -96, 1, 0)
title.Text = "Anti-AFK — Jebek.ID"
title.TextColor3 = Color3.fromRGB(235, 235, 245)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left

-- Make title draggable area
local dragArea = Instance.new("Frame")
dragArea.BackgroundTransparency = 1
dragArea.Size = UDim2.new(1, -96, 1, 0)
dragArea.Parent = header

title.Parent = dragArea

local btnRow = Instance.new("Frame")
btnRow.BackgroundTransparency = 1
btnRow.Size = UDim2.new(0, 96, 1, 0)
btnRow.Parent = header

local btnLayout = Instance.new("UIListLayout", btnRow)
btnLayout.FillDirection = Enum.FillDirection.Horizontal
btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
btnLayout.Padding = UDim.new(0, 6)

local function makeBtn(text, w)
	local b = Instance.new("TextButton")
	b.AutoButtonColor = true
	b.Text = text
	b.Size = UDim2.fromOffset(w or 36, 28)
	b.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
	b.TextColor3 = Color3.fromRGB(220, 220, 230)
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	local bc = Instance.new("UICorner", b)
	bc.CornerRadius = UDim.new(0, 10)
	local bs = Instance.new("UIStroke", b)
	bs.Color = Color3.fromRGB(60, 60, 70)
	bs.Thickness = 1
	return b
end

local minimizeBtn = makeBtn("–", 36)
minimizeBtn.Parent = btnRow

local closeBtn = makeBtn("×", 36)
closeBtn.Parent = btnRow

-- Status line
local status = Instance.new("TextLabel")
status.Name = "Status"
status.BackgroundTransparency = 1
status.Size = UDim2.new(1, 0, 0, 22)
status.LayoutOrder = 2
status.Text = "Status: OFF"
status.TextColor3 = Color3.fromRGB(180, 180, 190)
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

local function setStatus(t)
	status.Text = t
end

-- Controls container
local controls = Instance.new("Frame")
controls.BackgroundTransparency = 1
controls.Size = UDim2.new(1, 0, 1, -96)
controls.LayoutOrder = 3
controls.Parent = main

local grid = Instance.new("UIGridLayout", controls)
grid.CellPadding = UDim2.fromOffset(8, 8)
local cellW = UIS.TouchEnabled and 164 or 152
grid.CellSize = UDim2.fromOffset(cellW, 56)

local function makeToggle(text)
	local b = Instance.new("TextButton")
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
	b.TextColor3 = Color3.fromRGB(235, 235, 245)
	b.Font = Enum.Font.GothamMedium
	b.TextSize = 14
	local c = Instance.new("UICorner", b)
	c.CornerRadius = UDim.new(0, 12)
	local s = Instance.new("UIStroke", b)
	s.Color = Color3.fromRGB(60, 60, 70)
	s.Thickness = 1
	return b
end

local toggleBtn = makeToggle("Anti-AFK: OFF")
toggleBtn.Parent = controls

local methodBtn = makeToggle("Method: VirtualUser")
methodBtn.Parent = controls

local intervalCtl = Instance.new("Frame")
intervalCtl.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
local ic = Instance.new("UICorner", intervalCtl)
ic.CornerRadius = UDim.new(0, 12)
local is = Instance.new("UIStroke", intervalCtl)
is.Color = Color3.fromRGB(60, 60, 70)
is.Thickness = 1
intervalCtl.Parent = controls

local iList = Instance.new("UIListLayout", intervalCtl)
iList.FillDirection = Enum.FillDirection.Horizontal
iList.HorizontalAlignment = Enum.HorizontalAlignment.Center
iList.VerticalAlignment = Enum.VerticalAlignment.Center
iList.Padding = UDim.new(0, 8)

local minusBtn = makeBtn("-", 40)
minusBtn.Parent = intervalCtl

local intervalLabel = Instance.new("TextLabel")
intervalLabel.BackgroundTransparency = 1
intervalLabel.Size = UDim2.fromOffset(80, 24)
intervalLabel.Text = "Every "..fmtSeconds(state.interval)
intervalLabel.TextColor3 = Color3.fromRGB(235, 235, 245)
intervalLabel.Font = Enum.Font.Gotham
intervalLabel.TextSize = 14
intervalLabel.Parent = intervalCtl

local plusBtn = makeBtn("+", 40)
plusBtn.Parent = intervalCtl

local jitterBtn = makeToggle("Jitter: ON")
jitterBtn.Parent = controls

-- Footer hint
local hint = Instance.new("TextLabel")
hint.BackgroundTransparency = 1
hint.Size = UDim2.new(1, 0, 0, 20)
hint.LayoutOrder = 4
hint.Text = "RightShift = Toggle • Drag title to move"
hint.TextColor3 = Color3.fromRGB(120, 120, 130)
hint.Font = Enum.Font.Gotham
hint.TextSize = 12
hint.Parent = main

-- Floating bubble when minimized
local bubble = Instance.new("TextButton")
bubble.Visible = false
bubble.Text = "Anti-AFK"
bubble.Size = UDim2.fromOffset(UIS.TouchEnabled and 140 or 110, UIS.TouchEnabled and 46 or 36)
bubble.Position = UDim2.new(1, -bubble.Size.X.Offset - 20, 1, -bubble.Size.Y.Offset - 80)
bubble.AnchorPoint = Vector2.new(1,1)
bubble.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
bubble.TextColor3 = Color3.fromRGB(235, 235, 245)
bubble.Font = Enum.Font.GothamMedium
bubble.TextSize = 14
local bubC = Instance.new("UICorner", bubble)
bubC.CornerRadius = UDim.new(0, 14)
local bubS = Instance.new("UIStroke", bubble)
bubS.Color = Color3.fromRGB(60, 60, 70)
bubS.Thickness = 1
bubble.Parent = gui

-- Drag logic
local dragging = false
local dragStart, startPos

local function beginDrag(pos)
	dragging = true
	dragStart = pos
	startPos = main.Position
end

local function updateDrag(pos)
	if not dragging then return end
	local delta = pos - dragStart
	main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

local function endDrag()
	dragging = false
end

-- Mouse
dragArea.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		beginDrag(input.Position)
	end
end)

dragArea.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		updateDrag(input.Position)
	end
end)

dragArea.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		endDrag()
	end
end)

-- Touch
if UIS.TouchEnabled then
	dragArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			beginDrag(input.Position)
		end
	end)
		dragArea.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			updateDrag(input.Position)
		end
	end)
		dragArea.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			endDrag()
		end
	end)
end

-- UI wiring
local function refreshToggleVisual()
	toggleBtn.Text = "Anti-AFK: "..(state.enabled and "ON" or "OFF")
	setStatus("Status: "..(state.enabled and ("ON ("..state.method..")") or "OFF"))
	if state.enabled then
		startWorker(setStatus)
	else
		setStatus("Status: OFF")
	end
end

local function refreshMethodVisual()
	methodBtn.Text = "Method: "..state.method
end

local function refreshIntervalVisual()
	intervalLabel.Text = "Every "..fmtSeconds(state.interval)
end

local function refreshJitterVisual()
	jitterBtn.Text = "Jitter: "..(state.jitter and "ON" or "OFF")
end

local function toggle()
	state.enabled = not state.enabled
	if not state.enabled then
		stopWorker()
	else
		startWorker(setStatus)
	end
	refreshToggleVisual()
end

local function cycleMethod()
	local order = {"VirtualUser", "MicroMove", "Jump"}
	local idx = table.find(order, state.method) or 1
	idx = (idx % #order) + 1
	state.method = order[idx]
	refreshMethodVisual()
end

local function adjustInterval(delta)
	local new = math.clamp(state.interval + delta, 15, 300)
	state.interval = new
	refreshIntervalVisual()
end

local function toggleJitter()
	state.jitter = not state.jitter
	refreshJitterVisual()
end

-- Buttons
toggleBtn.MouseButton1Click:Connect(toggle)
methodBtn.MouseButton1Click:Connect(cycleMethod)
minusBtn.MouseButton1Click:Connect(function() adjustInterval(-5) end)
plusBtn.MouseButton1Click:Connect(function() adjustInterval(+5) end)
jitterBtn.MouseButton1Click:Connect(toggleJitter)

-- Minimize / Restore / Close
local function minimize()
	state.minimized = true
	main.Visible = false
	bubble.Visible = true
end

local function restore()
	state.minimized = false
	main.Visible = true
	bubble.Visible = false
end

minimizeBtn.MouseButton1Click:Connect(minimize)
bubble.MouseButton1Click:Connect(restore)

closeBtn.MouseButton1Click:Connect(function()
	state.closing = true
	stopWorker()
	gui:Destroy()
end)

-- Hotkey (PC)
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		toggle()
	end
end)

-- Initial paint
refreshToggleVisual()
refreshMethodVisual()
refreshIntervalVisual()
refreshJitterVisual()
setStatus("Ready.")

-- Ensure StarterGui doesn't hide reset notifications etc.
pcall(function()
	StarterGui:SetCore("ResetButtonCallback", true)
end)
