-- DRAG SUPER FIX (100% HP + PC)

local dragging = false
local dragStart = Vector2.new()
local startPos = UDim2.new()

bubble.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch 
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        
        dragging = true
        dragStart = input.Position
        startPos = bubble.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

bubble.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.Touch 
        or input.UserInputType == Enum.UserInputType.MouseMovement) then
        
        local delta = input.Position - dragStart

        bubble.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
