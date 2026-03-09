--[[
   CounterBlox v1 - Core
--]]

-- Защита от повторной загрузки
if _G.CBv1_Loaded then return end
_G.CBv1_Loaded = true

print("✅ [CBv1] Core loaded - start")

-- Сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Глобальные настройки
_G.CBv1 = {
    Version = "1.0",
    Loaded = {},
    Settings = {
        ESP = {
            Enabled = false,
            Box = true,
            Name = true,
            Health = true,
            Distance = true,
            Weapons = false,
            Tracers = false,
            TeamCheck = true,
            BoxColor = Color3.fromRGB(255, 100, 100),
            TeamColor = Color3.fromRGB(0, 255, 0),
            UseTeamColor = false,
            ShowTeam = true,
            BoxShift = 0,
            BoxSize = Vector3.new(4, 6, 0),
            FaceCamera = true,
            Thickness = 1,
            AttachShift = 1
        },
        Aimbot = {
        Enabled = false,
        FOV = 60,
        Smooth = 0.03,
        TeamCheck = true
    },
    SilentAim = {
        Enabled = false,
        TeamCheck = true,
        Size = 13
    
        },
        Movement = {
            InfiniteJump = false,
            Speed = false,
            SpeedValue = 16
        }
    }
}

print("✅ [CBv1] Core loaded - end")
