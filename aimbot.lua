--[[
   CounterBlox v1 - Aimbot
--]]

if _G.CBv1.Loaded.Aimbot then return end
_G.CBv1.Loaded.Aimbot = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Radius = _G.CBv1.Settings.Aimbot.FOV
FOVCircle.Color = Color3.fromRGB(255, 100, 100)
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Filled = false

local Holding = false

local function GetClosestPlayer()
    local target = nil
    local maxDist = _G.CBv1.Settings.Aimbot.FOV
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if _G.CBv1.Settings.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then
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
    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    FOVCircle.Radius = _G.CBv1.Settings.Aimbot.FOV
    FOVCircle.Visible = _G.CBv1.Settings.Aimbot.Enabled
    
    if Holding and _G.CBv1.Settings.Aimbot.Enabled then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, head.Position), _G.CBv1.Settings.Aimbot.Smooth)
        end
    end
end)

print("✅ [CBv1] Aimbot loaded")
