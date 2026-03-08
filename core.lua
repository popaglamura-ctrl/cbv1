--[[
   CounterBlox v1 - Core
--]]

if _G.CBv1_Loaded then return end
_G.CBv1_Loaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

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
            TeamCheck = true,
            BoxColor = Color3.fromRGB(255, 100, 100),
            BoxWidth = 60,
            BoxHeight = 100
        },
        Aimbot = {
            Enabled = false,
            FOV = 60,
            Smooth = 0.03,
            TeamCheck = true
        },
        Movement = {
            InfiniteJump = false,
            Speed = false,
            SpeedValue = 16
        }
    }
}

print("✅ [CBv1] Core loaded")
