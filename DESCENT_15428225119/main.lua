local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "👾 Cheat Menu",
    LoadingTitle = "Loading Cheat Menu...",
    LoadingSubtitle = "by Bobertic",
    ConfigurationSaving = {Enabled = false}
})

local highlights = {
    isItemHighlight = false,
    isEnemyHighlight = false,
    isPlayerHighlight = false,
    highlightList = {}
}

local originalAmbient
local originalExposure
local savedLights = {}

local Lighting = game:GetService("Lighting")

local isAutomaticSettings = false

local DestroyMenu = false

local itemPrices = {
    ['RedCrate'] = 70,             -- Красный ящик
    ['BlueCrate'] = 70,            -- Синий ящик
    ['GreenCrate'] = 70,           -- Зелёный ящик
    ['OrangeCrate'] = 70,          -- Оранжевый ящик
   
    ['RedCanister'] = 70,          -- Красная большая канистра
    ['BlueCanister'] = 70,         -- Синяя большая канистра
    ['GreenCanister'] = 70,        -- Зелёная большая канистра
    ['OrangeCanister'] = 70,       -- Оранжевая большая канистра
   
    ['RedJerrycan'] = 22,          -- Красная канистра
    ['BlueJerrycan'] = 22,         -- Синяя канистра
    ['BigRedJerrycan'] = 36,       -- Большая красная канистра
    ['BigBlueJerrycan'] = 36,      -- Большая синяя канистра
   
    ['Bottle'] = 21,               -- Бутылка
    ['Pan'] = 52,                  -- Сковорода
    ['Remote'] = 43,               -- Пульт
    ['AmmoBox'] = 54,              -- Ящик с боеприпасами
    ['TV'] = 104,                  -- Теливизор
    ['MetalPipe'] = 72,            -- Металлическая труба
    ['FartCushion'] = 21,          -- Подушка-пердушка
    ['Scrap'] = 64,                -- Метал
    ['PoliceSiren'] = 43,          -- Поличейская сирена
    ['BananaPeel'] = 0.2,          -- Банановая кожура
    ['Battery2'] = 30,             -- Батарейка
    ['Battery'] = 90,              -- Золотая батарейка
    ['WalkieTalkie'] = 4,          -- Рация
    ['RiotShield'] = 33,           -- Щит
    ['ValuableScanner'] = 107,     -- Сканер
    ['NightvisionGoggles'] = 104,  -- Очки ночного зрения

    -- Технические
    ['Flashlight'] = 0,            -- Фонарик
    ['Clipboard'] = 0,             -- Таблички о сущностях
    ['HoldingItem'] = 0            -- Предметы, поставленные синими робатами
}


local function IsInForbiddenZone(position)
    if not position then return false end
    local x, y, z = position.X, position.Y, position.Z
    return x >= -20 and x <= 20
       and y >= -10 and y <= 10
       and z >= -10 and z <= 27
end

local function CreateHighlight(element, Color, storage)
    local h = Instance.new("Highlight")
    h.FillColor = Color
    h.FillTransparency = 0.5
    h.OutlineColor = Color
    h.OutlineTransparency = 0
    h.Adornee = element
    h.Parent = element
    table.insert(storage, h)
    return h
end

local function Eps()
    while true do
        for _, h in ipairs(highlights.highlightList) do h:Destroy() end
        highlights.highlightList = {}

        if DestroyMenu then
            break
        end

        if highlights.isPlayerHighlight then
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    local char = player.Character
                    if char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:IsDescendantOf(game) then
                        CreateHighlight(char, Color3.new(0.7, 0.7, 0.7), highlights.highlightList)
                    end
                end
            end
        end

        if highlights.isEnemyHighlight then
            local folder = game.Workspace:FindFirstChild("Mobs")
            if folder then
                for _, enemy in ipairs(folder:GetChildren()) do
                    if enemy:IsA("Model") and enemy.PrimaryPart and enemy.PrimaryPart:IsDescendantOf(game) then
                        local isBlueMonkey = string.find(enemy.Name:lower(), "bluemonkey") ~= nil
                        local color = isBlueMonkey and Color3.new(0, 0, 1) or Color3.new(1, 0, 0)
                        CreateHighlight(enemy, color, highlights.highlightList)
                    end
                end
            end
        end

        if highlights.isItemHighlight then
            local folder = game.Workspace:FindFirstChild("ItemDrops")
            if folder then
                for _, object in ipairs(folder:GetChildren()) do
                    if object:IsA("Model") and object.PrimaryPart and object.PrimaryPart:IsDescendantOf(game) and not IsInForbiddenZone(object.PrimaryPart.Position) then
                        CreateHighlight(object, Color3.new(0, 1, 0), highlights.highlightList)
                    end
                end
            end
        end

        task.wait(5)
    end
end


local function DeleteShadows()
    Lighting:ClearAllChildren()

    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.ExposureCompensation = -1.5
end



local function AutomaticSettings()
    while isAutomaticSettings do
        if DestroyMenu then
            break
        end

        DeleteShadows()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then humanoid.WalkSpeed = 40 end

        task.wait(0.1)
    end
end

local MainTab = Window:CreateTab("Основные функции", nil)
local HighlightTab = Window:CreateTab("Подсветка", nil)
local InfoTab = Window:CreateTab("Информация", nil)

MainTab:CreateSlider({
    Name = "Скорость движения",
    Range = {16, 250},
    Increment = 1,
    Suffix = "ед.",
    CurrentValue = 16,
    Callback = function(value)
        local player = game.Players.LocalPlayer
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        if humanoid then humanoid.WalkSpeed = value end
    end
})

MainTab:CreateButton({Name = "Удалить тени", Callback = DeleteShadows})


local AutomaticSettingsToggle = MainTab:CreateToggle({
    Name = "Автоматические настройки",
    CurrentValue = false,
    Flag = "AutomaticSettings_Toggle",
    Callback = function(Value)
        if Value then
            isAutomaticSettings = true
            AutomaticSettings()
        else
            isAutomaticSettings = false
        end
    end
})

MainTab:CreateButton({
    Name = "Завершить меню",
    Callback = function()
        DestroyMenu = true
        task.wait(1)
        Rayfield:Destroy()
    end
})


local EpsItemsToggle = HighlightTab:CreateToggle({
    Name = "Подсветка предметов",
    CurrentValue = false,
    Flag = "EpsItem",
    Callback = function(Value)
        if Value then
            highlights.isItemHighlight = true
        else
            highlights.isItemHighlight = false
        end
    end
})

local EpsMobsToggle = HighlightTab:CreateToggle({
    Name = "Подсветка врагов",
    CurrentValue = false,
    Flag = "EpsMobs",
    Callback = function(Value)
        if Value then
            highlights.isEnemyHighlight = true
        else
            highlights.isEnemyHighlight = false
        end
    end
})

local EpsPlayersToggle = HighlightTab:CreateToggle({
    Name = "Подсветка игроков",
    CurrentValue = false,
    Flag = "EpsPlayers",
    Callback = function(Value)
        if Value then
            highlights.isPlayerHighlight = true
        else
            highlights.isPlayerHighlight = false
        end
    end
})

InfoTab:CreateSection("Текущее положение")
local PositionLabel = InfoTab:CreateLabel("Загрузка позиции...")

InfoTab:CreateSection("Clipboard")
local ClipboardLabel = InfoTab:CreateLabel("Поиск предметов...")

InfoTab:CreateSection("Количество предметов")
local ItemCountOutside = InfoTab:CreateLabel("0 предметов")
local ItemCountLift = InfoTab:CreateLabel("0 предметов")
local HoldingItemOutside = InfoTab:CreateLabel("0 предметов")

InfoTab:CreateSection("Неизвестные предметы")
local UnknownObjects = InfoTab:CreateLabel("Null")

task.spawn(function()
    while true do
        if DestroyMenu then
            break
        end

        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local folder = game.Workspace:FindFirstChild("ItemDrops")
        
        if rootPart then
            PositionLabel:Set(string.format("X: %.0f | Y: %.0f | Z: %.0f", 
                rootPart.Position.X, rootPart.Position.Y, rootPart.Position.Z))
        else
            PositionLabel:Set("Позиция недоступна")
        end
        
        local itemsText_clipboard = {}
        local itemsCount_holdingitem = 0
        local counterOutside = {}
        local counterLift = {}
        local UnknownObjectsList = {}
        
        if folder and rootPart then
            for _, object in ipairs(folder:GetChildren()) do
                if object:IsA("Model") and object.PrimaryPart then
                    local pos = object.PrimaryPart.Position
                    local name = object.Name
                    if pos.Y <= 2000 then
                        local inForbidden = IsInForbiddenZone(pos)
                        local location = inForbidden and "Lift" or "Outside"
                        
                        if inForbidden then
                            counterLift[name] = (counterLift[name] or 0) + 1
                        else
                            counterOutside[name] = (counterOutside[name] or 0) + 1

                            if string.find(name:lower(), "clipboard") then
                                local distance = (pos - rootPart.Position).Magnitude
                                table.insert(itemsText_clipboard, string.format(
                                    "• [%s] X: %.0f Y: %.0f Z: %.0f | %.1fм",
                                    name, pos.X, pos.Y, pos.Z, distance
                                ))
                            end 
                            if string.find(name:lower(), "holdingitem") then
                                itemsCount_holdingitem = itemsCount_holdingitem + 1
                            end
                        end
                        
                        if not itemPrices[name] then
                            local distance = (pos - rootPart.Position).Magnitude
                            table.insert(UnknownObjectsList, {
                                name = name,
                                location = location,
                                position = pos,
                                distance = distance
                            })
                        end
                        
                    end
                end
            end
        end
        
        local UnknownObjectsText = {}
        for _, item in ipairs(UnknownObjectsList) do
            if not string.find(item.name, 'LOCKER_ITEM') then
                table.insert(UnknownObjectsText, string.format(
                    "• [%s] | %s | X: %.0f Y: %.0f Z: %.0f | %.1fм",
                    item.name,
                    item.location,
                    item.position.X,
                    item.position.Y,
                    item.position.Z,
                    item.distance
                ))
            end
        end
        
        ClipboardLabel:Set(#itemsText_clipboard > 0 and table.concat(itemsText_clipboard, "\n") or "Предметы не найдены")
        HoldingItemOutside:Set(itemsCount_holdingitem > 0 and string.format("HoldingItem: %s", tostring(itemsCount_holdingitem)) or "Предметы не найдены")
        UnknownObjects:Set(#UnknownObjectsText > 0 and table.concat(UnknownObjectsText, "\n") or "Null")
        
        local totalOutside, countOutside = 0, 0
        for name, count in pairs(counterOutside) do
            totalOutside = totalOutside + (itemPrices[name] or 0) * count
            countOutside = countOutside + count
        end
        ItemCountOutside:Set(string.format("%d предмет(ов) за лифтом | %.1f очков", countOutside, totalOutside))
        
        local totalLift, countLift = 0, 0
        for name, count in pairs(counterLift) do
            totalLift = totalLift + (itemPrices[name] or 0) * count
            countLift = countLift + count
        end
        ItemCountLift:Set(string.format("%d предмет(ов) в лифте | %.1f очков", countLift, totalLift))
        
        task.wait(0.2)
    end
end)

Eps()
