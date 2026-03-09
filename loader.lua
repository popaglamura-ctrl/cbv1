--[[
   CounterBlox v1 - Loader
   Автор: Fox & Jack
--]]

-- Проверяем PlaceId (более стабильно, чем GameId)
local SUPPORTED_PLACES = {
    [301549746] = true,  -- Основной Counter Blox
    [1480424328] = true, -- Competitive
    [1869597719] = true, -- Deathmatch
    [5325113759] = true, -- Trading
    [115797356] = true,  -- UGC (твой случай)
}

if not SUPPORTED_PLACES[game.PlaceId] then
    game.Players.LocalPlayer:Kick("Game not supported!")
    return
end

-- Повышение потока для защиты
setthreadidentity(8)

-- Твой GitHub
local GITHUB_USER = "popaglamura-ctrl"
local REPO_NAME = "cbv1"

local parts = {
    "https://raw.githubusercontent.com/" .. GITHUB_USER .. "/" .. REPO_NAME .. "/refs/heads/main/core.lua",
    "https://raw.githubusercontent.com/" .. GITHUB_USER .. "/" .. REPO_NAME .. "/refs/heads/main/esp.lua",
    "https://raw.githubusercontent.com/" .. GITHUB_USER .. "/" .. REPO_NAME .. "/refs/heads/main/aimbot.lua",
    "https://raw.githubusercontent.com/" .. GITHUB_USER .. "/" .. REPO_NAME .. "/refs/heads/main/movement.lua",
    "https://raw.githubusercontent.com/" .. GITHUB_USER .. "/" .. REPO_NAME .. "/refs/heads/main/gui.lua"
}

-- Функция загрузки
local function loadPart(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        warn("[CBv1] Failed to load: " .. url)
        return nil
    end
    
    local loadSuccess, script = pcall(loadstring, result)
    if not loadSuccess then
        warn("[CBv1] Failed to compile: " .. url)
        return nil
    end
    
    return script
end

-- Загружаем все части
print("🚀 Загрузка CounterBlox v1...")

for _, url in ipairs(parts) do
    local part = loadPart(url)
    if part then
        part()
    end
    task.wait(0.1)
end

print("✅ CounterBlox v1 loaded successfully!")
