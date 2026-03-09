--[[
   CounterBlox v1 - GUI
   Используем Rayfield
--]]

if _G.CBv1.Loaded.GUI then return end
_G.CBv1.Loaded.GUI = true

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "CounterBlox v1",
    LoadingTitle = "CBv1",
    LoadingSubtitle = "by Fox & Jack",
    ConfigurationSaving = { Enabled = true }
})

-- ESP Tab
local ESPTab = Window:CreateTab("ESP", 4483362458)

ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = _G.CBv1.Settings.ESP.Enabled,
    Callback = function(v) _G.CBv1.Settings.ESP.Enabled = v end
})

ESPTab:CreateToggle({
    Name = "Show Boxes",
    CurrentValue = _G.CBv1.Settings.ESP.Box,
    Callback = function(v) _G.CBv1.Settings.ESP.Box = v end
})

ESPTab:CreateToggle({
    Name = "Show Name",
    CurrentValue = _G.CBv1.Settings.ESP.Name,
    Callback = function(v) _G.CBv1.Settings.ESP.Name = v end
})

ESPTab:CreateToggle({
    Name = "Show Health",
    CurrentValue = _G.CBv1.Settings.ESP.Health,
    Callback = function(v) _G.CBv1.Settings.ESP.Health = v end
})

ESPTab:CreateToggle({
    Name = "Show Distance",
    CurrentValue = _G.CBv1.Settings.ESP.Distance,
    Callback = function(v) _G.CBv1.Settings.ESP.Distance = v end
})

ESPTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = _G.CBv1.Settings.ESP.TeamCheck,
    Callback = function(v) _G.CBv1.Settings.ESP.TeamCheck = v end
})

ESPTab:CreateColorPicker({
    Name = "Box Color",
    Color = _G.CBv1.Settings.ESP.BoxColor,
    Callback = function(v) _G.CBv1.Settings.ESP.BoxColor = v end
})

-- Aimbot Tab
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)

AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = _G.CBv1.Settings.Aimbot.Enabled,
    Callback = function(v) _G.CBv1.Settings.Aimbot.Enabled = v end
})

AimbotTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = _G.CBv1.Settings.Aimbot.TeamCheck,
    Callback = function(v) _G.CBv1.Settings.Aimbot.TeamCheck = v end
})

AimbotTab:CreateSlider({
    Name = "FOV",
    Range = {30, 200},
    Increment = 5,
    CurrentValue = _G.CBv1.Settings.Aimbot.FOV,
    Callback = function(v) _G.CBv1.Settings.Aimbot.FOV = v end
})

AimbotTab:CreateSlider({
    Name = "Smoothness",
    Range = {0.01, 0.1},
    Increment = 0.01,
    CurrentValue = _G.CBv1.Settings.Aimbot.Smooth,
    Callback = function(v) _G.CBv1.Settings.Aimbot.Smooth = v end
})

-- Movement Tab
local MoveTab = Window:CreateTab("Movement", 4483362458)

MoveTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = _G.CBv1.Settings.Movement.InfiniteJump,
    Callback = function(v) _G.CBv1.Settings.Movement.InfiniteJump = v end
})

MoveTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = _G.CBv1.Settings.Movement.Speed,
    Callback = function(v) _G.CBv1.Settings.Movement.Speed = v end
})

MoveTab:CreateSlider({
    Name = "Speed Value",
    Range = {16, 200},
    Increment = 5,
    CurrentValue = _G.CBv1.Settings.Movement.SpeedValue,
    Callback = function(v) _G.CBv1.Settings.Movement.SpeedValue = v end
})

print("✅ [CBv1] GUI loaded")
