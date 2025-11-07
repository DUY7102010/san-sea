local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local lighting = game:GetService("Lighting")
lighting.FogEnd = 100000
lighting.FogStart = 0
lighting.FogColor = Color3.new(1, 1, 1)

for _, v in pairs(lighting:GetChildren()) do
    if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") then
        v:Destroy()
    end
end

for _, v in pairs(hrp:GetChildren()) do
    if v:IsA("BodyPosition") then
        v:Destroy()
    end
end

local bp = Instance.new("BodyPosition")
bp.Position = Vector3.new(hrp.Position.X, hrp.Position.Y + 75, hrp.Position.Z)
bp.MaxForce = Vector3.new(0, math.huge, 0)
bp.P = 1250
bp.Name = "FloatMode"
bp.Parent = hrp

local speed = 400
local moving = false
local enabled = false

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "SpeedToggleGui"

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 40)
toggleButton.Position = UDim2.new(0, 100, 0, 100)
toggleButton.Text = "Tăng tốc"
toggleButton.TextColor3 = Color3.new(0, 0, 0)
toggleButton.BackgroundColor3 = Color3.new(1, 1, 0)
toggleButton.Parent = screenGui
toggleButton.Active = true
toggleButton.Draggable = true

local function updateButtonColor()
    if enabled then
        toggleButton.BackgroundColor3 = Color3.new(0, 1, 0)
    else
        toggleButton.BackgroundColor3 = Color3.new(1, 0, 0)
    end
end

toggleButton.MouseButton1Click:Connect(function()
    enabled = not enabled
    print("Chế độ tăng tốc: " .. (enabled and "BẬT" or "TẮT"))
    updateButtonColor()
end)

uis.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.P then
        enabled = not enabled
        print("Chế độ tăng tốc: " .. (enabled and "BẬT" or "TẮT"))
        updateButtonColor()
    end
    if enabled and (input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D) then
        moving = true
    end
end)

uis.InputEnded:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D then
        moving = false
    end
end)

runService.RenderStepped:Connect(function()
    if enabled and moving then
        hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * (speed / 60)
    end
end)

updateButtonColor()
