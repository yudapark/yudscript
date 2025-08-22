-- LocalScript di StarterGui
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local flySpeed = 50
local bodyVelocity

-- Buat GUI button
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 120, 0, 50)
flyButton.Position = UDim2.new(0.05, 0, 0.8, 0) -- pojok kiri bawah
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Parent = screenGui

-- Fungsi toggle fly
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

-- Klik tombol = toggle fly
flyButton.MouseButton1Click:Connect(toggleFly)

-- Kontrol arah terbang
game:GetService("RunService").Heartbeat:Connect(function()
    if flying and bodyVelocity then
        local moveDir = Vector3.new(0,0,0)
        local camCF = workspace.CurrentCamera.CFrame
        local humanoid = character:WaitForChild("Humanoid")

        if humanoid.MoveDirection.Magnitude > 0 then
            moveDir = (camCF.LookVector * humanoid.MoveDirection.Z + camCF.RightVector * humanoid.MoveDirection.X).Unit
        end

        -- Naik dengan E, turun dengan Q
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.E) then
            moveDir = moveDir + Vector3.new(0,1,0)
        elseif game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Q) then
            moveDir = moveDir + Vector3.new(0,-1,0)
        end

        bodyVelocity.Velocity = moveDir * flySpeed
    end
end)
