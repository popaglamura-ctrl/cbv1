--[[
   CounterBlox v1 - Aimbot + Silent Aim
   Обычный аимбот + увеличение хитбоксов
--]]

if _G.CBv1.Loaded.Aimbot then return end
_G.CBv1.Loaded.Aimbot = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Настройки (будут браться из _G.CBv1.Settings)
local Settings = _G.CBv1.Settings.Aimbot
local SilentSettings = {
    Enabled = false,
    TeamCheck = true,
    Size = 13
}

-- ==================== ОБЫЧНЫЙ AIMBOT ====================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Radius = Settings.FOV
FOVCircle.Color = Color3.fromRGB(255, 100, 100)
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Filled = false

local Holding = false

local function GetClosestPlayer()
    local target = nil
    local maxDist = Settings.FOV
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if Settings.TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            if player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                local screen, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local mousePos = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                    local dist = (mousePos - Vector2.new(screen.X, screen.Y)).Magnitude
                    if dist < maxDist then
                        maxDist = dist
                        target = player
                    end
                end
            end
        end
    end
    return target
end

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = false
    end
end)

RunService.RenderStepped:Connect(function()
    -- Обновляем FOV круг
    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    FOVCircle.Radius = Settings.FOV
    FOVCircle.Visible = Settings.Enabled
    
    if Holding and Settings.Enabled then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            -- Плавное наведение
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, head.Position), Settings.Smooth)
        end
    end
end)

-- ==================== SILENT AIM (ХИТБОКСЫ) ====================
task.spawn(function()
    while true do
        task.wait(0.5)
        
        -- Загружаем настройки
        if _G.CBv1 and _G.CBv1.Settings and _G.CBv1.Settings.SilentAim then
            SilentSettings.Enabled = _G.CBv1.Settings.SilentAim.Enabled
            SilentSettings.TeamCheck = _G.CBv1.Settings.SilentAim.TeamCheck
            SilentSettings.Size = _G.CBv1.Settings.SilentAim.Size
        end
        
        if SilentSettings.Enabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    if SilentSettings.TeamCheck and player.Team == LocalPlayer.Team then
                        continue
                    end
                    
                    -- Увеличиваем хитбоксы (как в Arsenal)
                    local parts = {
                        player.Character:FindFirstChild("RightUpperLeg"),
                        player.Character:FindFirstChild("LeftUpperLeg"),
                        player.Character:FindFirstChild("HeadHB"),
                        player.Character:FindFirstChild("HumanoidRootPart")
                    }
                    
                    for _, part in ipairs(parts) do
                        if part then
                            part.Size = Vector3.new(SilentSettings.Size, SilentSettings.Size, SilentSettings.Size)
                            part.Transparency = 0.8
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
    end
end)

print("✅ [CBv1] Aimbot + Silent Aim loaded")
