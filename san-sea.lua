-- INTRO GUI: LVDGODZ
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = Lighting

local IntroGui = Instance.new("ScreenGui", PlayerGui)
IntroGui.Name = "IntroLVD"
IntroGui.IgnoreGuiInset = true
IntroGui.ResetOnSpawn = false

local Background = Instance.new("Frame", IntroGui)
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(5, 5, 10)

local Gradient = Instance.new("UIGradient", Background)
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 25)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 25))
}
Gradient.Rotation = 45

local Glow = Instance.new("ImageLabel", Background)
Glow.Size = UDim2.new(1.5, 0, 1.5, 0)
Glow.Position = UDim2.new(-0.25, 0, -0.25, 0)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://9150630156"
Glow.ImageColor3 = Color3.fromRGB(90, 130, 255)
Glow.ImageTransparency = 0.85
Glow.ZIndex = 0

local Text = Instance.new("TextLabel", Background)
Text.AnchorPoint = Vector2.new(0.5, 0.5)
Text.Position = UDim2.new(0.5, 0, 0.5, 0)
Text.Size = UDim2.new(1, 0, 0.25, 0)
Text.Text = "LVDGODZ"
Text.TextColor3 = Color3.fromRGB(230, 235, 255)
Text.TextTransparency = 1
Text.TextScaled = true
Text.Font = Enum.Font.GothamBold
Text.ZIndex = 3
Text.BackgroundTransparency = 1

local Stroke = Instance.new("UIStroke", Text)
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(120, 150, 255)
Stroke.Transparency = 0.3
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local Shine = Instance.new("ImageLabel", Background)
Shine.AnchorPoint = Vector2.new(0.5, 0.5)
Shine.Position = UDim2.new(0.5, 0, 0.5, 0)
Shine.Size = UDim2.new(2, 0, 3, 0)
Shine.BackgroundTransparency = 1
Shine.Image = "rbxassetid://9150641010"
Shine.ImageColor3 = Color3.fromRGB(100, 130, 255)
Shine.ImageTransparency = 0.9
Shine.ZIndex = 2

TweenService:Create(Blur, TweenInfo.new(2), {Size = 25}):Play()
TweenService:Create(Text, TweenInfo.new(2), {TextTransparency = 0}):Play()
TweenService:Create(Stroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.5}):Play()
TweenService:Create(Shine, TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {ImageTransparency = 0.7}):Play()
TweenService:Create(Glow, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {ImageTransparency = 0.75}):Play()

task.delay(4, function()
    TweenService:Create(Text, TweenInfo.new(2), {TextTransparency = 1}):Play()
    TweenService:Create(Background, TweenInfo.new(2), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Blur, TweenInfo.new(2), {Size = 0}):Play()
    task.delay(2.2, function()
        IntroGui:Destroy()
        Blur:Destroy()
    end)
end)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local scriptEnabled = true
local speed = 210
local moving = false

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "ScriptToggleGui"

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 80, 0, 30)
toggleButton.Position = UDim2.new(0, 20, 0, 100)
toggleButton.Text = "Script"
toggleButton.TextColor3 = Color3.new(0, 0, 0)
toggleButton.BackgroundColor3 = Color3.new(1, 1, 0)
toggleButton.Parent = screenGui
toggleButton.Active = true
toggleButton.Draggable = true

local function updateButtonColor()
    if scriptEnabled then
        toggleButton.BackgroundColor3 = Color3.new(0, 1, 0)
    else
        toggleButton.BackgroundColor3 = Color3.new(1, 0, 0)
    end
end

local function applyScriptState()
    if scriptEnabled then
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
        bp.Position = Vector3.new(hrp.Position.X, hrp.Position.Y + 150, hrp.Position.Z)
        bp.MaxForce = Vector3.new(0, math.huge, 0)
        bp.P = 1250
        bp.Name = "FloatMode"
        bp.Parent = hrp
    else
        for _, v in pairs(hrp:GetChildren()) do
            if v:IsA("BodyPosition") and v.Name == "FloatMode" then
                v:Destroy()
            end
        end
    end
end

toggleButton.MouseButton1Click:Connect(function()
    scriptEnabled = not scriptEnabled
    print("Script: " .. (scriptEnabled and "BẬT" or "TẮT"))
    updateButtonColor()
    applyScriptState()
end)

uis.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.P then
        scriptEnabled = not scriptEnabled
        print("Script: " .. (scriptEnabled and "BẬT" or "TẮT"))
        updateButtonColor()
        applyScriptState()
    end
    if scriptEnabled and (input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D) then
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
    if scriptEnabled and moving then
        hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * (speed / 60)
    end
end)

updateButtonColor()
applyScriptState()
