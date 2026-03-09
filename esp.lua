--[[
   CounterBlox v1 - ESP (Hexagon стиль)
--]]

print("✅ [CBv1] Esp loading...")

-- Проверяем, что _G.CBv1 существует
if not _G.CBv1 then
    print("❌ [CBv1] _G.CBv1 не найден!")
    return
end

if _G.CBv1.Loaded.Esp then return end
_G.CBv1.Loaded.Esp = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

print("✅ [CBv1] Esp services loaded")

local Esp = {
    Enabled = false,
    Boxes = true,
    ShowInfo = true,
    Tracers = false,
    TeamColor = Color3.new(0, 1, 0),
    EnemyColor = Color3.fromRGB(255, 100, 100),
    ShowTeam = true,
    Info = {
        Name = true,
        Health = true,
        Weapons = false,
        Distance = true
    },
    Objects = {},
    FaceCamera = true,
    BoxSize = Vector3.new(4, 6, 0),
    BoxShift = CFrame.new(0, -1.5, 0),
    Thickness = 1,
    AttachShift = 1,
    UseTeamColor = false
}

-- Функция для создания Drawing объектов
local function Draw(obj, props)
    local new = Drawing.new(obj)
    props = props or {}
    for i,v in pairs(props) do
        new[i] = v
    end
    return new
end

-- Проверка на тиммейта
function Esp:IsTeamMate(plr)
    if not plr or not LocalPlayer then return false end
    return plr.Team == LocalPlayer.Team
end

-- Получение цвета для игрока
function Esp:GetColor(plr)
    if not plr then return self.EnemyColor end
    
    if self.UseTeamColor then
        if plr.Team then
            return plr.Team.TeamColor.Color
        end
    end
    
    if self:IsTeamMate(plr) and self.ShowTeam then
        return self.TeamColor
    else
        return self.EnemyColor
    end
end

-- Добавление ESP для игрока
function Esp:Add(plr)
    if self.Objects[plr] then return end
    if plr == LocalPlayer then return end
    
    local function onCharacterAdded(char)
        task.wait(0.5)
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local box = {
            Player = plr,
            Object = char,
            PrimaryPart = root,
            Components = {}
        }
        
        -- Quad (бокс)
        box.Components.Quad = Draw("Quad", {
            Thickness = self.Thickness,
            Color = self:GetColor(plr),
            Transparency = 1,
            Filled = false,
            Visible = false
        })
        
        -- Имя
        box.Components.Name = Draw("Text", {
            Text = plr.Name,
            Color = Color3.fromRGB(255, 255, 255),
            Center = true,
            Outline = true,
            Size = 16,
            Visible = false
        })
        
        -- Здоровье
        box.Components.Health = Draw("Text", {
            Color = Color3.fromRGB(100, 255, 100),
            Center = true,
            Outline = true,
            Size = 14,
            Visible = false
        })
        
        -- Дистанция
        box.Components.Distance = Draw("Text", {
            Color = Color3.fromRGB(200, 200, 200),
            Center = true,
            Outline = true,
            Size = 14,
            Visible = false
        })
        
        -- Оружие
        box.Components.Weapons = Draw("Text", {
            Color = Color3.fromRGB(255, 255, 0),
            Center = true,
            Outline = true,
            Size = 14,
            Visible = false
        })
        
        -- Трейсер
        box.Components.Tracer = Draw("Line", {
            Thickness = self.Thickness,
            Color = self:GetColor(plr),
            Transparency = 1,
            Visible = false
        })
        
        self.Objects[plr] = box
        print("✅ [CBv1] ESP added for", plr.Name)
        
        -- Автоудаление при смерти
        char.AncestryChanged:Connect(function()
            if char.Parent == nil then
                self:Remove(plr)
            end
        end)
    end
    
    if plr.Character then
        onCharacterAdded(plr.Character)
    end
    
    plr.CharacterAdded:Connect(onCharacterAdded)
end

-- Удаление ESP
function Esp:Remove(plr)
    if self.Objects[plr] then
        for _, comp in pairs(self.Objects[plr].Components) do
            comp:Remove()
        end
        self.Objects[plr] = nil
    end
end

-- Обновление ESP для игрока
function Esp:Update(plr)
    local box = self.Objects[plr]
    if not box or not box.PrimaryPart or not box.PrimaryPart.Parent then
        self:Remove(plr)
        return
    end
    
    local char = box.Object
    local root = box.PrimaryPart
    local hum = char:FindFirstChild("Humanoid")
    
    if not hum or hum.Health <= 0 then
        for _, comp in pairs(box.Components) do
            comp.Visible = false
        end
        return
    end
    
    -- Team Check
    if not self.ShowTeam and self:IsTeamMate(plr) then
        for _, comp in pairs(box.Components) do
            comp.Visible = false
        end
        return
    end
    
    local color = self:GetColor(plr)
    
    -- Расчет позиций
    local cf = root.CFrame + Vector3.new(0, 1, 0)
    if self.FaceCamera then
        cf = CFrame.new(cf.p, Camera.CFrame.p)
    end
    
    local shift = CFrame.new(0, -1.5 + self.BoxShift, 0)
    local size = self.BoxSize
    local locs = {
        TopLeft = cf * shift * CFrame.new(size.X/2, size.Y/2, 0),
        TopRight = cf * shift * CFrame.new(-size.X/2, size.Y/2, 0),
        BottomLeft = cf * shift * CFrame.new(size.X/2, -size.Y/2, 0),
        BottomRight = cf * shift * CFrame.new(-size.X/2, -size.Y/2, 0),
        TagPos = cf * shift * CFrame.new(0, size.Y/2, 0),
        Torso = cf * shift
    }
    
    -- Отрисовка бокса
    if self.Boxes then
        local tl, v1 = Camera:WorldToViewportPoint(locs.TopLeft.p)
        local tr, v2 = Camera:WorldToViewportPoint(locs.TopRight.p)
        local bl, v3 = Camera:WorldToViewportPoint(locs.BottomLeft.p)
        local br, v4 = Camera:WorldToViewportPoint(locs.BottomRight.p)
        
        if box.Components.Quad then
            if v1 or v2 or v3 or v4 then
                box.Components.Quad.Visible = true
                box.Components.Quad.Thickness = self.Thickness
                box.Components.Quad.PointA = Vector2.new(tr.X, tr.Y)
                box.Components.Quad.PointB = Vector2.new(tl.X, tl.Y)
                box.Components.Quad.PointC = Vector2.new(bl.X, bl.Y)
                box.Components.Quad.PointD = Vector2.new(br.X, br.Y)
                box.Components.Quad.Color = color
            else
                box.Components.Quad.Visible = false
            end
        end
    else
        box.Components.Quad.Visible = false
    end
    
    -- Отрисовка информации
    if self.ShowInfo then
        local tagPos, v5 = Camera:WorldToViewportPoint(locs.TagPos.p)
        
        if v5 then
            local offset = 20
            
            if self.Info.Distance then
                box.Components.Distance.Visible = true
                box.Components.Distance.Position = Vector2.new(tagPos.X, tagPos.Y - offset)
                local dist = (root.Position - Camera.CFrame.Position).Magnitude
                box.Components.Distance.Text = math.floor(dist) .. "m"
                box.Components.Distance.Color = color
                offset = offset + 14
            else
                box.Components.Distance.Visible = false
            end
            
            if self.Info.Weapons then
                local weapon = char:FindFirstChild("EquippedTool")
                if weapon then
                    box.Components.Weapons.Visible = true
                    box.Components.Weapons.Position = Vector2.new(tagPos.X, tagPos.Y - offset)
                    box.Components.Weapons.Text = "[" .. tostring(weapon.Value) .. "]"
                    box.Components.Weapons.Color = Color3.fromRGB(255, 255, 0)
                    offset = offset + 14
                else
                    box.Components.Weapons.Visible = false
                end
            else
                box.Components.Weapons.Visible = false
            end
            
            if self.Info.Health then
                box.Components.Health.Visible = true
                box.Components.Health.Position = Vector2.new(tagPos.X, tagPos.Y - offset)
                box.Components.Health.Text = math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
                box.Components.Health.Color = Color3.fromRGB(255 * (1 - hum.Health/hum.MaxHealth), 255 * (hum.Health/hum.MaxHealth), 0)
                offset = offset + 14
            else
                box.Components.Health.Visible = false
            end
            
            if self.Info.Name then
                box.Components.Name.Visible = true
                box.Components.Name.Position = Vector2.new(tagPos.X, tagPos.Y - offset)
                box.Components.Name.Text = plr.Name
                box.Components.Name.Color = Color3.fromRGB(255, 255, 255)
            else
                box.Components.Name.Visible = false
            end
        else
            box.Components.Name.Visible = false
            box.Components.Health.Visible = false
            box.Components.Weapons.Visible = false
            box.Components.Distance.Visible = false
        end
    else
        box.Components.Name.Visible = false
        box.Components.Health.Visible = false
        box.Components.Weapons.Visible = false
        box.Components.Distance.Visible = false
    end
    
    -- Отрисовка трейсеров
    if self.Tracers then
        local torsoPos, v6 = Camera:WorldToViewportPoint(locs.Torso.p)
        if v6 then
            box.Components.Tracer.Visible = true
            box.Components.Tracer.Thickness = self.Thickness
            box.Components.Tracer.From = Vector2.new(torsoPos.X, torsoPos.Y)
            box.Components.Tracer.To = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/self.AttachShift)
            box.Components.Tracer.Color = color
        else
            box.Components.Tracer.Visible = false
        end
    else
        box.Components.Tracer.Visible = false
    end
end

-- Подключаем всех игроков
for _, plr in ipairs(Players:GetPlayers()) do
    Esp:Add(plr)
end

Players.PlayerAdded:Connect(function(plr)
    Esp:Add(plr)
end)

Players.PlayerRemoving:Connect(function(plr)
    Esp:Remove(plr)
end)

-- Основной цикл обновления
RunService.RenderStepped:Connect(function()
    -- Загружаем настройки из _G.CBv1
    if _G.CBv1 and _G.CBv1.Settings and _G.CBv1.Settings.ESP then
        local s = _G.CBv1.Settings.ESP
        
        Esp.Enabled = s.Enabled
        Esp.Boxes = s.Box
        Esp.ShowTeam = s.ShowTeam
        Esp.Tracers = s.Tracers
        Esp.UseTeamColor = s.UseTeamColor
        Esp.TeamColor = s.TeamColor
        Esp.EnemyColor = s.BoxColor
        Esp.FaceCamera = s.FaceCamera
        Esp.BoxShift = s.BoxShift
        Esp.Thickness = s.Thickness
        Esp.AttachShift = s.AttachShift
        Esp.Info.Name = s.Name
        Esp.Info.Health = s.Health
        Esp.Info.Distance = s.Distance
        Esp.Info.Weapons = s.Weapons
    else
        -- Если настроек нет, выключаем ESP
        Esp.Enabled = false
    end
    
    for plr, _ in pairs(Esp.Objects) do
        pcall(function()
            Esp:Update(plr)
        end)
    end
end)

print("✅ [CBv1] Esp loaded")
