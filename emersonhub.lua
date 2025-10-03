loadstring([[
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Evita duplicados
if PlayerGui:FindFirstChild("EmersonHub") then
    PlayerGui.EmersonHub:Destroy()
end

-- GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EmersonHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 320, 0, 240)
main.Position = UDim2.new(0.5, -160, 0.5, -120)
main.BackgroundTransparency = 0.2
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Parent = ScreenGui
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -40, 0, 36)
title.Position = UDim2.new(0, 10, 0, 6)
title.BackgroundTransparency = 1
title.Text = "Emerson"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 26, 0, 26)
close.Position = UDim2.new(1, -36, 0, 6)
close.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
close.BorderSizePixel = 0
close.Text = "X"
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.SourceSansBold
close.TextSize = 18

local function createButton(text, ypos)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, ypos)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(235,235,235)
    btn.Text = text
    return btn
end

-- Botones
local tp1Btn = createButton("TP 1", 54)
local tp2Btn = createButton("TP 2", 100)
local jumpBtn = createButton("Multi jump", 146)
local speedBtn = createButton("Speed Bost", 192)

-- Estado
local savedCFrame = nil
local boosted = false
local originalWalkSpeed = 16
local multiJumpEnabled = false
local jumps = 0
local maxJumps = 5

-- Funciones
tp1Btn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedCFrame = char.HumanoidRootPart.CFrame
        tp1Btn.Text = "Posición guardada"
        wait(1.2)
        tp1Btn.Text = "TP 1"
    end
end)

tp2Btn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if char and char:FindFirstChild("HumanoidRootPart") and savedCFrame then
        char.HumanoidRootPart.CFrame = savedCFrame
    else
        tp2Btn.Text = "No hay TP"
        wait(1.2)
        tp2Btn.Text = "TP 2"
    end
end)

jumpBtn.MouseButton1Click:Connect(function()
    multiJumpEnabled = not multiJumpEnabled
    if multiJumpEnabled then
        jumpBtn.Text = "Multi jump (ON)"
    else
        jumpBtn.Text = "Multi jump"
    end
end)

-- Sistema de multi jump
game:GetService("UserInputService").JumpRequest:Connect(function()
    if multiJumpEnabled then
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum:GetState() ~= Enum.HumanoidStateType.Freefall then
            jumps = 0
        elseif hum and jumps < maxJumps then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            jumps += 1
        end
    end
end)

speedBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if not boosted then
            originalWalkSpeed = humanoid.WalkSpeed or 16
            humanoid.WalkSpeed = originalWalkSpeed * 3
            boosted = true
            speedBtn.Text = "Speed Bost (ON)"
        else
            humanoid.WalkSpeed = originalWalkSpeed
            boosted = false
            speedBtn.Text = "Speed Bost"
        end
    end
end)

close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Restaurar estado al respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        if boosted then
            hum.WalkSpeed = originalWalkSpeed * 3
        else
            hum.WalkSpeed = originalWalkSpeed
        end
    end
    jumps = 0
end)
]])()
