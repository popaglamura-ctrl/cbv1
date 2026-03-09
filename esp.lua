--[[
   CounterBlox v1 - ESP (адаптированный из Hexagon)
--]]

if _G.CBv1.Loaded.ESP then return end  -- ← ИСПРАВЛЕНО: ESP заглавными
_G.CBv1.Loaded.ESP = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ESP = {
    Enabled = false,
    Tracers = true,
    Boxes = true,
    ShowInfo = true,
    UseTeamColor = true,
    TeamColor = Color3.new(0, 1, 0),
    EnemyColor = Color3.new(1, 0, 0),
    ShowTeam = true,
    Info = {
        ["Name"] = true,
        ["Health"] = true,
        ["Weapons"] = true,
        ["Distance"] = true
    },
    BoxShift = CFrame.new(0, -1.5, 0),
    BoxSize = Vector3.new(4, 6, 0),
    Color = Color3.fromRGB(255, 255, 255),
    TargetPlayers = true,
    FaceCamera = true,
    Thickness = 1,
    AttachShift = 1,
    Objects = setmetatable({}, {__mode="kv"}),
    Overrides = {}
}

-- Функция для Drawing
local function Draw(obj, props)
    local new = Drawing.new(obj)
    props = props or {}
    for i,v in pairs(props) do
        new[i] = v
    end
    return new
end

function ESP:GetTeam(p)
    return p and p.Team
end

function ESP:IsTeamMate(p)
    return self:GetTeam(p) == self:GetTeam(LocalPlayer)
end

function ESP:GetColor(obj)
    local p = Players:GetPlayerFromCharacter(obj)
    if not p then return self.EnemyColor end
    if self:IsTeamMate(p) then
        return self.TeamColor
    else
        return self.EnemyColor
    end
end

function ESP:Add(obj, options)
    if self.Objects[obj] then return end
    
    local box = {
        Name = options.Name or obj.Name,
        Object = obj,
        Player = options.Player or Players:GetPlayerFromCharacter(obj),
        PrimaryPart = options.PrimaryPart or obj:FindFirstChild("HumanoidRootPart"),
        Components = {},
        Size = options.Size or self.BoxSize,
        Color = options.Color
    }
    
    box.Components.Quad = Draw("Quad", {
        Thickness = self.Thickness,
        Color = box.Color,
        Transparency = 1,
        Filled = false,
        Visible = self.Enabled and self.Boxes
    })
    
    box.Components.Name = Draw("Text", {
        Text = box.Name,
        Color = box.Color,
        Center = true,
        Outline = true,
        Size = 16,
        Visible = self.Enabled and self.ShowInfo
    })
    
    box.Components.Health = Draw("Text", {
        Color = box.Color,
        Center = true,
        Outline = true,
        Size = 14,
        Visible = self.Enabled and self.ShowInfo
    })
    
    box.Components.Weapons = Draw("Text", {
        Color = box.Color,
        Center = true,
        Outline = true,
        Size = 14,
        Visible = self.Enabled and self.ShowInfo
    })
    
    box.Components.Distance = Draw("Text", {
        Color = box.Color,
        Center = true,
        Outline = true,
        Size = 14,
        Visible = self.Enabled and self.ShowInfo
    })
    
    box.Components.Tracer = Draw("Line", {
        Thickness = self.Thickness,
        Color = box.Color,
        Transparency = 1,
        Visible = self.Enabled and self.Tracers
    })
    
    self.Objects[obj] = box
    
    obj.AncestryChanged:Connect(function()
        if obj.Parent == nil then
            box:Remove()
        end
    end)
    
    return box
end

function ESP.Objects[obj]:Remove()
    for _, comp in pairs(self.Components) do
        comp:Remove()
    end
    ESP.Objects[self.Object] = nil
end

function ESP.Objects[obj]:Update()
    if not self.PrimaryPart then
        self:Remove()
        return
    end
    
    local color = self.Color or ESP:GetColor(self.Object)
    local allow = true
    
    if self.Player and not ESP.ShowTeam and ESP:IsTeamMate(self.Player) then
        allow = false
    end
    
    if not allow then
        for _, comp in pairs(self.Components) do
            comp.Visible = false
        end
        return
    end
    
    local cf = self.PrimaryPart.CFrame + Vector3.new(0, 1, 0)
    if ESP.FaceCamera then
        cf = CFrame.new(cf.p, Camera.CFrame.p)
    end
    
    local size = self.Size
    local locs = {
        TopLeft = cf * ESP.BoxShift * CFrame.new(size.X/2, size.Y/2, 0),
        TopRight = cf * ESP.BoxShift * CFrame.new(-size.X/2, size.Y/2, 0),
        BottomLeft = cf * ESP.BoxShift * CFrame.new(size.X/2, -size.Y/2, 0),
        BottomRight = cf * ESP.BoxShift * CFrame.new(-size.X/2, -size.Y/2, 0),
        TagPos = cf * ESP.BoxShift * CFrame.new(0, size.Y/2, 0),
        Torso = cf * ESP.BoxShift
    }
    
    if ESP.Boxes then
        local tl, v1 = Camera:WorldToViewportPoint(locs.TopLeft.p)
        local tr, v2 = Camera:WorldToViewportPoint(locs.TopRight.p)
        local bl, v3 = Camera:WorldToViewportPoint(locs.BottomLeft.p)
        local br, v4 = Camera:WorldToViewportPoint(locs.BottomRight.p)
        
        if self.Components.Quad then
            if v1 or v2 or v3 or v4 then
                self.Components.Quad.Visible = true
                self.Components.Quad.PointA = Vector2.new(tr.X, tr.Y)
                self.Components.Quad.PointB = Vector2.new(tl.X, tl.Y)
                self.Components.Quad.PointC = Vector2.new(bl.X, bl.Y)
                self.Components.Quad.PointD = Vector2.new(br.X, br.Y)
                self.Components.Quad.Color = color
            else
                self.Components.Quad.Visible = false
            end
        end
    else
        self.Components.Quad.Visible = false
    end
    
    if ESP.ShowInfo then
        local tagPos, v5 = Camera:WorldToViewportPoint(locs.TagPos.p)
        local char = self.PrimaryPart.Parent
        
        if v5 and char and char:FindFirstChild("Humanoid") then
            local hum = char:FindFirstChild("Humanoid")
            local offset = 20
            
            if ESP.Info.Distance then
                self.Components.Distance.Visible = true
                self.Components.Distance.Position = Vector2.new(tagPos.X, tagPos.Y - offset)
                self.Components.Distance.Text = "["..math.floor((Camera.CFrame.p - cf.p).magnitude).."m]"
                self.Components.Distance.Color = color
                offset = offset + 14
            else
                self.Components.Distance.Visible = false
            end
            
            if ESP.Info.Weapons and char:FindFirstChild("EquippedTool") then
                self.Components.Weapons.Visible = true
                self.Components.Weapons.Position = Vector2.new(tagPos.X, tagPos.Y - offset)
                self.Components.Weapons.Text = "["..tostring(char.EquippedTool.Value).."]"
                self.Components.Weapons.Color = color
                offset = offset + 14
            else
                self.Components.Weapons.Visible = false
            end
            
            if ESP.Info.Health then
                self.Components.Health.Visible = true
                self.Components.Health.Position = Vector2.new(tagPos.X, tagPos.Y - offset)
                self.Components.Health.Text = "["..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth).."]"
                self.Components.Health.Color = color
                offset = offset + 14
            else
                self.Components.Health.Visible = false
            end
            
            if ESP.Info.Name then
                self.Components.Name.Visible = true
                self.Components.Name.Position = Vector2.new(tagPos.X, tagPos.Y - offset)
                self.Components.Name.Text = self.Name
                self.Components.Name.Color = color
            else
                self.Components.Name.Visible = false
            end
        else
            self.Components.Name.Visible = false
            self.Components.Health.Visible = false
            self.Components.Weapons.Visible = false
            self.Components.Distance.Visible = false
        end
    end
    
    if ESP.Tracers then
        local torsoPos, v6 = Camera:WorldToViewportPoint(locs.Torso.p)
        if v6 then
            self.Components.Tracer.Visible = true
            self.Components.Tracer.From = Vector2.new(torsoPos.X, torsoPos.Y)
            self.Components.Tracer.To = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/ESP.AttachShift)
            self.Components.Tracer.Color = color
        else
            self.Components.Tracer.Visible = false
        end
    else
        self.Components.Tracer.Visible = false
    end
end

-- Подключаем игроков
local function AddPlayerESP(player)
    if player == LocalPlayer then return end
    
    local function onCharacterAdded(char)
        task.wait(0.5)
        local root = char:WaitForChild("HumanoidRootPart", 5)
        if root then
            ESP:Add(char, {
                Name = player.Name,
                Player = player,
                PrimaryPart = root
            })
        end
    end
    
    if player.Character then
        onCharacterAdded(player.Character)
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
end

for _, player in ipairs(Players:GetPlayers()) do
    AddPlayerESP(player)
end

Players.PlayerAdded:Connect(AddPlayerESP)

-- Основной цикл обновления с привязкой к настройкам
RunService.RenderStepped:Connect(function()
    -- Привязываем к настройкам из _G.CBv1
    ESP.Enabled = _G.CBv1.Settings.ESP.Enabled
    ESP.Boxes = _G.CBv1.Settings.ESP.Box
    ESP.ShowTeam = _G.CBv1.Settings.ESP.TeamCheck
    ESP.Info.Name = _G.CBv1.Settings.ESP.Name
    ESP.Info.Health = _G.CBv1.Settings.ESP.Health
    ESP.Info.Distance = _G.CBv1.Settings.ESP.Distance
    ESP.TeamColor = Color3.new(0, 1, 0)
    ESP.EnemyColor = _G.CBv1.Settings.ESP.BoxColor
    
    for _, obj in pairs(ESP.Objects) do
        pcall(function() obj:Update() end)
    end
end)

print("✅ [CBv1] ESP loaded")
