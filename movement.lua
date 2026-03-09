--[[
   CounterBlox v1 - Movement
--]]

if _G.CBv1.Loaded.Movement then return end
_G.CBv1.Loaded.Movement = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if _G.CBv1.Settings.Movement.InfiniteJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState("Jumping")
        end
    end
end)

-- Speed Hack
RunService.RenderStepped:Connect(function()
    if _G.CBv1.Settings.Movement.Speed and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = _G.CBv1.Settings.Movement.SpeedValue
        end
    end
end)

print("✅ [CBv1] Movement loaded")
