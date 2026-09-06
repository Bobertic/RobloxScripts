return function(Window, Rayfield)
    local MonstersTab = Window:CreateTab("👁️ ESP Монстры", nil)

    local Highlighter = loadstring(game:HttpGet('https://test.local/div/BasicData/HighlighterModule.lua'))()

    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local player = Players.LocalPlayer

    local enabledMonsters = {}
    local isMassUpdating = false

    local monsterToggleObjects = {}

    local espObjects = {}
    local activeConnections = {}
    local globalScannerConnection = nil

    local ESP_CONFIG = {
        Eyes = {
            name = "Eyes",
            uiName = "Подсветка Глаз",
            color = Color3.fromRGB(180, 0, 255),
            outline = { Use = 1, Color = Color3.fromRGB(180, 0, 255), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(100, 0, 50), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "ГЛАЗА", Color = Color3.fromRGB(200, 50, 255), Size = 28, AlwaysOnTop = true, Offset = { x = 0, y = 0, z = 0 } },
            ForceAll = true
        },
        AmbushMoving = {
            name = "Ambush",
            uiName = "Подсветка Амбуша",
            color = Color3.fromRGB(0, 255, 0),
            outline = { Use = 1, Color = Color3.fromRGB(0, 255, 0), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(100, 255, 100), Transparency = 0.9, AlwaysOnTop = true },
            text   = { Use = 1, Text = "AMBUSH", Color = Color3.fromRGB(0, 255, 0), Size = 28, AlwaysOnTop = true, Offset = { x = 0, y = -2.5, z = 0 } },
            ForceAll = true
        },
        RushMoving = {
            name = "Rush",
            uiName = "Подсветка Раша",
            color = Color3.fromRGB(138, 43, 226),
            outline = { Use = 1, Color = Color3.fromRGB(138, 43, 226), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(186, 85, 211), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "RUSH", Color = Color3.fromRGB(147, 112, 219), Size = 28, AlwaysOnTop = true, Offset = { x = 0, y = 3, z = 0 } },
            ForceAll = true
        },
        FigureRig = {
            name = "FigureRig",
            uiName = "Подсветка Фигуры",
            color = Color3.fromRGB(255, 0, 0) ,
            outline = { Use = 1, Color = Color3.fromRGB(255, 0, 0), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(180, 20, 20), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "ФИГУРА", Color = Color3.fromRGB(255, 50, 50), Size = 28, AlwaysOnTop = true, Offset = { x = 0, y = 2, z = 0 } },
            ForceAll = true
        },
        Snare = {
            name = "Snare",
            uiName = "Подсветка Ловушек (Snare)",
            color = Color3.fromRGB(155, 135, 12),
            outline = { Use = 1, Color = Color3.fromRGB(155, 135, 12), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(120, 100, 20), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Ловушка", Color = Color3.fromRGB(185, 160, 20), Size = 16, AlwaysOnTop = true, Offset = { x = 0, y = 1.0, z = 0 } },
            ForceAll = true
        },
        DoorFake = {
            name = "DoorFake",
            uiName = "Подсветка Дюпа (Бокового)",
            color = Color3.fromRGB(255, 69, 0),
            outline = { Use = 1, Color = Color3.fromRGB(255, 69, 0), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(139, 0, 0), Transparency = 0.8, AlwaysOnTop = true },
            text   = { Use = 1, Text = "ДЮП (ФЕЙК)", Color = Color3.fromRGB(255, 0, 0), Size = 26, AlwaysOnTop = true, Offset = { x = 0, y = 0, z = 0 } },
            ForceAll = true
        },
        Screech = {
            name = "Screech",
            uiName = "Подсветка Screech",
            color = Color3.fromRGB(255, 69, 0),
            outline = { Use = 1, Color = Color3.fromRGB(255, 69, 0), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(139, 0, 0), Transparency = 0.8, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Screech", Color = Color3.fromRGB(255, 0, 0), Size = 26, AlwaysOnTop = true, Offset = { x = 0, y = 0, z = 0 } },
            ForceAll = true
        },

        BackdoorRush = {
            name = "BackdoorRush",
            uiName = "Подсветка Блица",
            color = Color3.fromRGB(57, 255, 20),
            outline = { Use = 1, Color = Color3.fromRGB(57, 255, 20), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(10, 30, 10), Transparency = 0.6, AlwaysOnTop = true },
            text   = { Use = 1, Text = "БЛИЦ", Color = Color3.fromRGB(173, 255, 47), Size = 26, AlwaysOnTop = true, Offset = { x = 0, y = 0, z = 0 } },
            ForceAll = true
        },
        BackdoorLookman = {
            name = "BackdoorLookman",
            uiName = "Подсветка Лукмана",
            color = Color3.fromRGB(245, 245, 245),
            outline = { Use = 1, Color = Color3.fromRGB(245, 245, 245), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(10, 10, 10), Transparency = 0.5, AlwaysOnTop = true },
            text   = { Use = 1, Text = "LOOKMAN", Color = Color3.fromRGB(255, 255, 255), Size = 26, AlwaysOnTop = true, Offset = { x = 0, y = 0, z = 0 } },
            ForceAll = true
        },

        TellerRig = {
            name = "Teller",
            uiName = "Кассир",
            color = Color3.fromRGB(255, 30, 30),
            outline = { Use = 1, Color = Color3.fromRGB(255, 0, 0), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(35, 5, 5), Transparency = 0.6, AlwaysOnTop = true },
            text   = { Use = 1, Text = "КАССИР", Color = Color3.fromRGB(255, 60, 60), Size = 26, AlwaysOnTop = true, Offset = { x = 0, y = 0, z = 0 } },
            ForceAll = true
        },
        DronesStampede = {
            name = "Drone",
            uiName = "Нашествие дронов",
            color = Color3.fromRGB(130, 110, 150),
            outline = { Use = 1, Color = Color3.fromRGB(150, 150, 150), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(0, 0, 0), Transparency = 0.5, AlwaysOnTop = true },
            text   = { Use = 1, Text = "ДРОНЫ", Color = Color3.fromRGB(240, 240, 240), Size = 26, AlwaysOnTop = true, Offset = { x = 0, y = 0, z = 0 } },
            ForceAll = true
        },
        Alma = {
            name = "Alma",
            uiName = "Альма",
            color = Color3.fromRGB(180, 185, 190),
            outline = { Use = 1, Color = Color3.fromRGB(160, 170, 180), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(0, 0, 0), Transparency = 0.6, AlwaysOnTop = true },
            text   = { Use = 1, Text = "АЛЬМА", Color = Color3.fromRGB(220, 225, 230), Size = 26, AlwaysOnTop = true, Offset = { x = 0, y = 0, z = 0 } },
            ForceAll = true
        },
        Ransom = {
            name = "Ransom",
            uiName = "Ransom",
            color = Color3.fromRGB(180, 230, 245),
            outline = { Use = 1, Color = Color3.fromRGB(150, 220, 240), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(30, 35, 40), Transparency = 0.6, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Ransom", Color = Color3.fromRGB(190, 240, 255), Size = 26, AlwaysOnTop = true, Offset = { x = 0, y = 0, z = 0 } },
            ForceAll = true
        },
        BashMoving = {
            name = "BashMoving",
            uiName = "BashMoving",
            color = Color3.fromRGB(138, 43, 226),
            outline = { Use = 1, Color = Color3.fromRGB(138, 43, 226), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(186, 85, 211), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "BASH", Color = Color3.fromRGB(147, 112, 219), Size = 28, AlwaysOnTop = true, Offset = { x = 0, y = 3, z = 0 } },
            ForceAll = true
        },
        Scribbles = {
            name = "Scribbles",
            uiName = "Каракули",
            color = Color3.fromRGB(138, 43, 226),
            outline = { Use = 1, Color = Color3.fromRGB(138, 43, 226), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(186, 85, 211), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Каракули", Color = Color3.fromRGB(147, 112, 219), Size = 28, AlwaysOnTop = true, Offset = { x = 0, y = 3, z = 0 } },
            ForceAll = true
        },

        Gloombat = {
            name = "Gloombat",
            uiName = "Глумбат",
            color = Color3.fromRGB(180, 230, 245),
            outline = { Use = 1, Color = Color3.fromRGB(150, 220, 240), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(30, 35, 40), Transparency = 0.6, AlwaysOnTop = true },
            text   = { Use = 1, Text = "ГЛУМБАТ", Color = Color3.fromRGB(190, 240, 255), Size = 26, AlwaysOnTop = true, Offset = { x = 0, y = 0, z = 0 } },
            ForceAll = true
        },
        _QueenGrumble = {
            name = "_QueenGrumble",
            uiName = "Королева грамблов",
            color = Color3.fromRGB(180, 230, 245),
            outline = { Use = 1, Color = Color3.fromRGB(150, 220, 240), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(30, 35, 40), Transparency = 0.6, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Королева грамблов", Color = Color3.fromRGB(190, 240, 255), Size = 26, AlwaysOnTop = true, Offset = { x = 0, y = 0, z = 0 } },
            ForceAll = true
        },
        GrumbleRig = {
            name = "GrumbleRig",
            uiName = "Грамбл",
            color = Color3.fromRGB(180, 230, 245),
            outline = { Use = 1, Color = Color3.fromRGB(150, 220, 240), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(30, 35, 40), Transparency = 0.6, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Грамбл", Color = Color3.fromRGB(190, 240, 255), Size = 26, AlwaysOnTop = true, Offset = { x = 0, y = 0, z = 0 } },
            ForceAll = true
        },

    }

    local function shallowCopy(t)
        local copy = {}
        for k, v in pairs(t) do
            if type(v) == "table" then copy[k] = shallowCopy(v) else copy[k] = v end
        end
        return copy
    end

    local function isInCurrentRooms(obj)
        local currentRooms = workspace:FindFirstChild("CurrentRooms")
        if not currentRooms then return false end
        return obj:IsDescendantOf(currentRooms)
    end

    local function isInCamera(obj)
        local camera = workspace.CurrentCamera
        if not camera then
            return false
        end
        return obj:IsDescendantOf(camera)
    end

    local function isInsidePlayer(obj)
        local current = obj
        while current and current.Parent ~= workspace do
            current = current.Parent
        end
        if current and current.Parent == workspace then
            if current:FindFirstChild("Humanoid") and current:FindFirstChild("Body Colors") then
                return true
            end
        end
        return false
    end

    local function hasAncestorWithName(obj, name)
        local parent = obj.Parent
        while parent do
            if parent.Name == name then return true end
            parent = parent.Parent
        end
        return false
    end

    local function shouldTrack(obj)
        if not obj or not obj.Name then return false end
        return ESP_CONFIG[obj.Name] ~= nil and enabledMonsters[obj.Name] == true
    end

    local function createESP(obj)
        if espObjects[obj] then return end
        local config = ESP_CONFIG[obj.Name]
        if not config then return end

        local ignoreList = {}
        if config.ignoreNames then
            for _, desc in ipairs(obj:GetDescendants()) do
                if table.find(config.ignoreNames, desc.Name) then table.insert(ignoreList, desc) end
            end
        end

        local highlighter = Highlighter.new(obj, ignoreList, config.outline, config.fill, config.text, config.ForceAll or false)
        if highlighter then espObjects[obj] = highlighter end
    end

    local function trackObject(obj)
        if not shouldTrack(obj) then return end

        if obj.Name == "Eyes" and (isInCurrentRooms(obj) or isInCamera(obj) or hasAncestorWithName(obj, "Gloombat") or isInsidePlayer(obj)) then
            return
        end
        if obj.Name == "Snare" and hasAncestorWithName(obj, "Snare") then return end

        if espObjects[obj] then return end

        task.wait(0.1)
        if not obj or not obj.Parent or espObjects[obj] or not shouldTrack(obj) then return end

        createESP(obj)

        local connection
        connection = obj.AncestryChanged:Connect(function()
            if not obj:IsDescendantOf(workspace) then
                if espObjects[obj] then espObjects[obj]:Destroy() espObjects[obj] = nil end
                if connection then connection:Disconnect() end
            end
        end)
        table.insert(activeConnections, connection)
    end

    local function checkObjectAndDescendants(obj)
        if not obj then return end

        trackObject(obj)

        for _, descendant in ipairs(obj:GetDescendants()) do
            trackObject(descendant)
        end
    end

    local function isAnyMonsterEnabled()
        for _, enabled in pairs(enabledMonsters) do
            if enabled then return true end
        end
        return false
    end

    local function updateScanner()
        if isAnyMonsterEnabled() then
            if not globalScannerConnection then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    trackObject(obj)
                end
                globalScannerConnection = workspace.DescendantAdded:Connect(function(obj)
                    checkObjectAndDescendants(obj)
                end)
            end
        else
            if globalScannerConnection then
                globalScannerConnection:Disconnect()
                globalScannerConnection = nil
            end
        end
    end

    local function removeMonsterEspByName(monsterName)
        for obj, highlighter in pairs(espObjects) do
            if obj.Name == monsterName then
                if highlighter then highlighter:Destroy() end
                espObjects[obj] = nil
            end
        end
    end

    local function selfDestruct()
        for k, _ in pairs(enabledMonsters) do enabledMonsters[k] = false end
        if globalScannerConnection then globalScannerConnection:Disconnect() globalScannerConnection = nil end

        for obj, highlighter in pairs(espObjects) do
            if highlighter then highlighter:Destroy() end
        end
        for _, conn in ipairs(activeConnections) do
            if conn then conn:Disconnect() end
        end

        espObjects = nil
        activeConnections = nil
        enabledMonsters = nil
        Highlighter = nil
        monsterToggleObjects = nil
    end

    MonstersTab:CreateButton({
        Name = "🟢 Включить всех Монстров",
        Callback = function()
            isMassUpdating = true
            for internalName, _ in pairs(ESP_CONFIG) do
                enabledMonsters[internalName] = true
            end
            updateScanner()

            for _, toggle in pairs(monsterToggleObjects) do toggle:Set(true) end
            isMassUpdating = false
        end,
    })

    MonstersTab:CreateButton({
        Name = "🔴 Выключить всех Монстров",
        Callback = function()
            isMassUpdating = true
            for internalName, _ in pairs(ESP_CONFIG) do
                enabledMonsters[internalName] = false
                removeMonsterEspByName(internalName)
            end
            if globalScannerConnection then globalScannerConnection:Disconnect() globalScannerConnection = nil end

            for _, toggle in pairs(monsterToggleObjects) do toggle:Set(false) end
            isMassUpdating = false
        end,
    })

    MonstersTab:CreateSection("Индивидуальные настройки")

    for internalName, data in pairs(ESP_CONFIG) do
        enabledMonsters[internalName] = false

        monsterToggleObjects[internalName] = MonstersTab:CreateToggle({
            Name = data.uiName or internalName,
            CurrentValue = false,
            Flag = internalName .. "MonsterToggle",
            Callback = function(Value)
                if isMassUpdating then return end
                enabledMonsters[internalName] = Value
                if Value then
                    updateScanner()
                else
                    removeMonsterEspByName(internalName)
                    updateScanner()
                end
            end,
        })
    end

    return selfDestruct
end
