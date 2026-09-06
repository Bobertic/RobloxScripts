return function(Window, Rayfield)
    local ESPTab = Window:CreateTab("👁️ ESP", nil)

    local Highlighter = loadstring(game:HttpGet('https://test.local/div/BasicData/HighlighterModule.lua'))()

    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local player = Players.LocalPlayer

    local isDoorsEspEnabled = false
    local enabledItems = {}

    local doorToggleObject = nil
    local itemToggleObjects = {}

    local espObjects = {}
    local activeConnections = {}
    local doorScannerConnections = {}
    local globalScannerConnection = nil

    local DOOR_CONFIG = {
        color = Color3.fromRGB(230, 210, 180),
        outline = { Use = 1, Color = Color3.fromRGB(230, 210, 180), Transparency = 0.2, AlwaysOnTop = true },
        fill   = { Use = 1, Color = Color3.fromRGB(115, 65, 35), Transparency = 0.85, AlwaysOnTop = true },
        text   = { Use = 1, Text = "Дверь", Color = Color3.fromRGB(230, 210, 180), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = 0, z = 0 } },
        ForceAll = false
    }

    local ESP_CONFIG = {
        KeyObtain = {
            uiName = "Ключи от дверей",
            name = "KeyObtain",
            color = Color3.fromRGB(74, 196, 217),
            outline = { Use = 1, Color = Color3.fromRGB(74, 196, 217), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(150, 240, 255), Transparency = 0.9, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Ключ", Color = Color3.fromRGB(74, 196, 217), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -1.5, z = 0 } },
            ForceAll = false
        },
        ElectricalKeyObtain = {
            name = "ElectricalKeyObtain",
            uiName = "Ключ от щитовой",
            color = Color3.fromRGB(0, 191, 255),
            outline = { Use = 1, Color = Color3.fromRGB(0, 191, 255), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(135, 206, 250), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Ключ от щитовой", Color = Color3.fromRGB(0, 191, 255), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -1.2, z = 0 } },
            ForceAll = false
        },
        LeverForGate = {
            name = "LeverForGate",
            uiName = "Рычаг от ворот",
            color = Color3.fromRGB(255, 120, 0),
            outline = { Use = 1, Color = Color3.fromRGB(255, 120, 0), Transparency = 0.1, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(255, 140, 30), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Рычаг", Color = Color3.fromRGB(255, 120, 0), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -0.5, z = 0 } },
            ForceAll = false
        },
        TimerLever = {
            name = "TimerLever",
            uiName = "Рычаг времени",
            color = Color3.fromRGB(255, 120, 0),
            outline = { Use = 1, Color = Color3.fromRGB(255, 120, 0), Transparency = 0.1, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(255, 140, 30), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Рычаг", Color = Color3.fromRGB(255, 120, 0), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -0.5, z = 0 } },
            ForceAll = false
        },
        LiveHintBook = {
            name = "LiveHintBook",
            uiName = "Книги",
            color = Color3.fromRGB(44, 241, 252),
            outline = { Use = 1, Color = Color3.fromRGB(44, 241, 252), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 0 },
            text   = { Use = 1, Text = "Книга", Color = Color3.fromRGB(44, 241, 252), Size = 14, AlwaysOnTop = true, Offset = { x = 0, y = 0, z = 0 } },
            ForceAll = false
        },
        GoldPile = {
            name = "GoldPile",
            uiName = "Золото",
            color = Color3.fromRGB(255, 215, 0),
            outline = { Use = 1, Color = Color3.fromRGB(255, 215, 0), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(255, 235, 120), Transparency = 0.9, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Золото", Color = Color3.fromRGB(255, 215, 0), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -1.5, z = 0 } },
            ForceAll = false
        },
        Smoothie = {
            name = "Smoothie",
            uiName = "Смузи",
            color = Color3.fromRGB(154, 205, 50),
            outline = { Use = 1, Color = Color3.fromRGB(154, 205, 50), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(180, 240, 70), Transparency = 0.9, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Смузи", Color = Color3.fromRGB(154, 205, 50), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -5.5, z = 0 } },
            ForceAll = false
        },
        Bandage = {
            name = "Bandage",
            uiName = "Пластыри",
            color = Color3.fromRGB(240, 128, 128),
            outline = { Use = 1, Color = Color3.fromRGB(240, 128, 128), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(255, 182, 193), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Пластырь", Color = Color3.fromRGB(240, 128, 128), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -7, z = 0 } },
            ForceAll = false
        },
        StardustPickup = {
            name = "StardustPickup",
            uiName = "Звёздная пыль",
            color = Color3.fromRGB(255, 170, 0),
            outline = { Use = 1, Color = Color3.fromRGB(255, 170, 0), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(255, 230, 100), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Звёздная пыль", Color = Color3.fromRGB(255, 190, 30), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -7, z = 0 } },
            ForceAll = false
        },
        Vitamins = {
            name = "Vitamins",
            uiName = "Витамины",
            color = Color3.fromRGB(0, 180, 255),
            outline = { Use = 1, Color = Color3.fromRGB(0, 180, 255), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(100, 220, 255), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Витамины", Color = Color3.fromRGB(0, 180, 255), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -6, z = 0 } },
            ForceAll = false
        },
        CrucifixWall = {
            name = "CrucifixWall",
            uiName = "Крест (Стена)",
            color = Color3.fromRGB(0, 255, 255),
            outline = { Use = 1, Color = Color3.fromRGB(0, 255, 255), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(150, 245, 255), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Крест (Стена)", Color = Color3.fromRGB(0, 255, 255), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = 1.5, z = 0 } },
            ForceAll = false
        },
        Crucifix = {
            name = "Crucifix",
            uiName = "Крест",
            color = Color3.fromRGB(0, 255, 255),
            outline = { Use = 1, Color = Color3.fromRGB(0, 255, 255), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(150, 245, 255), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Крест", Color = Color3.fromRGB(0, 255, 255), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -1, z = 0 } },
            ForceAll = false
        },
        Flashlight = {
            name = "Flashlight",
            uiName = "Фонарик",
            color = Color3.fromRGB(255, 215, 0),
            outline = { Use = 1, Color = Color3.fromRGB(255, 215, 0), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(255, 240, 150), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Фонарик", Color = Color3.fromRGB(255, 215, 0), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = 0, z = 0 } },
            ForceAll = false
        },
        Lighter = {
            name = "Lighter",
            uiName = "Зажигалка",
            color = Color3.fromRGB(255, 69, 0),
            outline = { Use = 1, Color = Color3.fromRGB(255, 69, 0), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(255, 120, 50), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Зажигалка", Color = Color3.fromRGB(255, 69, 0), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -1, z = 0 } },
            ForceAll = false
        },

        Green_Herb = {
            name = "Green_Herb",
            uiName = "Горшок с травой",
            color = Color3.fromRGB(34, 139, 34),
            outline = { Use = 1, Color = Color3.fromRGB(34, 139, 34), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(50, 205, 50), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Горшок с травой", Color = Color3.fromRGB(50, 205, 50), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = 1.2, z = 0 } },
            ForceAll = false
        },
        Shears = {
            name = "Shears",
            uiName = "Ножницы",
            color = Color3.fromRGB(192, 192, 192),
            outline = { Use = 1, Color = Color3.fromRGB(192, 192, 192), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(240, 240, 240), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Ножницы", Color = Color3.fromRGB(200, 200, 200), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -5.5, z = 0 } },
            ForceAll = false
        },
        LiveBreakerPolePickup = {
            name = "LiveBreakerPolePickup",
            uiName = "Предохранители",
            color = Color3.fromRGB(44, 241, 252),
            outline = { Use = 1, Color = Color3.fromRGB(44, 241, 252), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(120, 245, 255), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Предохранитель", Color = Color3.fromRGB(44, 241, 252), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -0.5, z = 0 } },
            ForceAll = false
        },
        Lockpick = {
            name = "Lockpick",
            uiName = "Отмычки",
            color = Color3.fromRGB(190, 195, 200),
            outline = { Use = 1, Color = Color3.fromRGB(190, 195, 200), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(220, 225, 230), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Отмычки", Color = Color3.fromRGB(190, 195, 200), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -1, z = 0 } },
            ForceAll = false
        },
        Candle = {
            name = "Candle",
            uiName = "Свеча",
            color = Color3.fromRGB(255, 190, 100),
            outline = { Use = 1, Color = Color3.fromRGB(255, 190, 100), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(255, 210, 140), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Свеча", Color = Color3.fromRGB(255, 190, 100), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -0.5, z = 0 } },
            ForceAll = false
        },
        AlarmClock = {
            name = "AlarmClock",
            uiName = "Будильник",
            color = Color3.fromRGB(205, 127, 50),
            outline = { Use = 1, Color = Color3.fromRGB(205, 127, 50), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(230, 200, 160), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Будильник", Color = Color3.fromRGB(205, 127, 50), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -0.5, z = 0 } },
            ForceAll = false
        },
        SkeletonKey = {
            name = "SkeletonKey",
            uiName = "Скелетный ключ",
            color = Color3.fromRGB(225, 220, 215),
            outline = { Use = 1, Color = Color3.fromRGB(225, 220, 215), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(150, 155, 160), Transparency = 0.85, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Скелетный ключ", Color = Color3.fromRGB(225, 220, 215), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -1, z = 0 } },
            ForceAll = false
        },

        PaperPlanePickup = {
            name = "PaperPlanePickup",
            uiName = "Бумажный самолётик",
            color = Color3.fromRGB(240, 240, 235),
            outline = { Use = 1, Color = Color3.fromRGB(245, 245, 240), Transparency = 0, AlwaysOnTop = true },
            fill = { Use = 1, Color = Color3.fromRGB(230, 215, 195), Transparency = 0.75, AlwaysOnTop = true },
            text = { Use = 1, Text = "Бумажный самолётик", Color = Color3.fromRGB(245, 245, 240), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -1, z = 0 } },
            ForceAll = false
        },
        Shakelight = {
            name = "Shakelight",
            uiName = "Динамо-фонарик",
            color = Color3.fromRGB(46, 204, 113),
            outline = { Use = 1, Color = Color3.fromRGB(0, 255, 128), Transparency = 0, AlwaysOnTop = true },
            fill = { Use = 1, Color = Color3.fromRGB(22, 160, 133), Transparency = 0.7, AlwaysOnTop = true },
            text = { Use = 1, Text = "Динамо-фонарик", Color = Color3.fromRGB(190, 255, 190), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -1, z = 0 } },
            ForceAll = false
        },
        HoneyPot = {
            name = "HoneyPot",
            uiName = "Горшочек с мёдом",
            color = Color3.fromRGB(245, 165, 35),
            outline = { Use = 1, Color = Color3.fromRGB(255, 180, 0), Transparency = 0, AlwaysOnTop = true },
            fill = { Use = 1, Color = Color3.fromRGB(160, 80, 45), Transparency = 0.7, AlwaysOnTop = true },
            text = { Use = 1, Text = "Горшочек с мёдом", Color = Color3.fromRGB(255, 235, 170), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -1, z = 0 } },
            ForceAll = false
        },
        Briefcase = {
            name = "Briefcase",
            uiName = "Портфель",
            color = Color3.fromRGB(130, 95, 70),
            outline = { Use = 1, Color = Color3.fromRGB(150, 110, 80), Transparency = 0, AlwaysOnTop = true },
            fill = { Use = 1, Color = Color3.fromRGB(80, 60, 45), Transparency = 0.75, AlwaysOnTop = true },
            text = { Use = 1, Text = "Портфель", Color = Color3.fromRGB(235, 215, 180), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -1, z = 0 } },
            ForceAll = false
        },
        Pizza = {
            name = "Pizza",
            uiName = "Пицца",
            color = Color3.fromRGB(130, 95, 70),
            outline = { Use = 1, Color = Color3.fromRGB(150, 110, 80), Transparency = 0, AlwaysOnTop = true },
            fill = { Use = 1, Color = Color3.fromRGB(80, 60, 45), Transparency = 0.75, AlwaysOnTop = true },
            text = { Use = 1, Text = "Пицца", Color = Color3.fromRGB(235, 215, 180), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -1, z = 0 } },
            ForceAll = false
        },

        MinesGenerator = {
            uiName = "Генератор",
            name = "MinesGenerator",
            color = Color3.fromRGB(74, 196, 217),
            outline = { Use = 1, Color = Color3.fromRGB(74, 196, 217), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(150, 240, 255), Transparency = 0.9, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Генератор", Color = Color3.fromRGB(74, 196, 217), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = 0, z = 0 } },
            ForceAll = false
        },
        FuseHolder = {
            uiName = "Предохранитель для генератора",
            name = "FuseHolder",
            color = Color3.fromRGB(74, 196, 217),
            outline = { Use = 1, Color = Color3.fromRGB(74, 196, 217), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(150, 240, 255), Transparency = 0.9, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Предохранитель", Color = Color3.fromRGB(74, 196, 217), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = 0, z = 0 } },
            ForceAll = false
        },
        MinesAnchor = {
            uiName = "Терминал Грамблы",
            name = "MinesAnchor",
            color = Color3.fromRGB(74, 196, 217),
            outline = { Use = 1, Color = Color3.fromRGB(74, 196, 217), Transparency = 0, AlwaysOnTop = true },
            fill   = { Use = 1, Color = Color3.fromRGB(150, 240, 255), Transparency = 0.9, AlwaysOnTop = true },
            text   = { Use = 1, Text = "Терминал", Color = Color3.fromRGB(74, 196, 217), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = 0, z = 0 } },
            ForceAll = false
        },

        LaserPointer = {
            name = "LaserPointer",
            uiName = "Лазерная указка",
            color = Color3.fromRGB(130, 95, 70),
            outline = { Use = 1, Color = Color3.fromRGB(150, 110, 80), Transparency = 0, AlwaysOnTop = true },
            fill = { Use = 1, Color = Color3.fromRGB(80, 60, 45), Transparency = 0.75, AlwaysOnTop = true },
            text = { Use = 1, Text = "Лазерная указка", Color = Color3.fromRGB(235, 215, 180), Size = 24, AlwaysOnTop = true, Offset = { x = 0, y = -1, z = 0 } },
            ForceAll = false
        },
    }

    local function shallowCopy(t)
        local copy = {}
        for k, v in pairs(t) do
            if type(v) == "table" then copy[k] = shallowCopy(v) else copy[k] = v end
        end
        return copy
    end

    local function shouldTrack(obj)
        if not obj or not obj.Name then return false end
        return ESP_CONFIG[obj.Name] ~= nil and enabledItems[obj.Name] == true
    end

    local function isInPlayerFolder(obj)
        local playerNames = {}
        for _, plr in ipairs(Players:GetPlayers()) do playerNames[plr.Name] = true end
        local parent = obj.Parent
        while parent do
            if playerNames[parent.Name] then return true end
            parent = parent.Parent
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

    local function createDoorESP(door)
        if not isDoorsEspEnabled or espObjects[door] then return end

        local room = door.Parent
        local textConfig = DOOR_CONFIG.text
        if room and room:IsA("Model") then
            local roomNumber = tonumber(room.Name)
            if roomNumber then
                local doorNumber = roomNumber + 1
                local formatted = string.format("%04d", doorNumber)
                textConfig = shallowCopy(DOOR_CONFIG.text)
                textConfig.Text = DOOR_CONFIG.text.Text .. " " .. formatted
            end
        end

        task.wait(0.1)
        if not isDoorsEspEnabled then return end

        local highlighter = Highlighter.new(door, {}, DOOR_CONFIG.outline, DOOR_CONFIG.fill, textConfig, DOOR_CONFIG.ForceAll)
        if highlighter then espObjects[door] = highlighter end

        local connection
        connection = door.AncestryChanged:Connect(function()
            if not door:IsDescendantOf(workspace) then
                if espObjects[door] then espObjects[door]:Destroy() espObjects[door] = nil end
                if connection then connection:Disconnect() end
            end
        end)
        table.insert(activeConnections, connection)
    end

    local function processRoom(room)
        for _, child in ipairs(room:GetChildren()) do
            if child.Name == "Door" then createDoorESP(child) end
        end
        local conn = room.ChildAdded:Connect(function(child)
            if child.Name == "Door" then createDoorESP(child) end
        end)
        table.insert(doorScannerConnections, conn)
    end

    local function initDoorScanner()
        local currentRooms = workspace:FindFirstChild("CurrentRooms") or workspace:WaitForChild("CurrentRooms", 15)
        if not currentRooms then return end

        local trackedRooms = {}
        for _, room in ipairs(currentRooms:GetChildren()) do
            if room:IsA("Model") and not trackedRooms[room] then
                trackedRooms[room] = true
                processRoom(room)
            end
        end
        local conn = currentRooms.ChildAdded:Connect(function(room)
            if room:IsA("Model") and not trackedRooms[room] then
                trackedRooms[room] = true
                processRoom(room)
            end
        end)
        table.insert(doorScannerConnections, conn)
    end

    local function createItemESP(obj)
        if espObjects[obj] then return end
        local config = ESP_CONFIG[obj.Name]
        if not config then return end

        local ignoreList = {}
        if config.ignoreNames then
            for _, desc in ipairs(obj:GetDescendants()) do
                if table.find(config.ignoreNames, desc.Name) then table.insert(ignoreList, desc) end
            end
        end

        local textConfig = config.text
        if obj.Name == "MinesAnchor" then
            local sign = obj:FindFirstChild("Sign", true)
            if sign and sign:IsA("TextLabel") then
                local signText = sign.Text
                if signText and signText ~= "" then
                    textConfig = shallowCopy(config.text)
                    textConfig.Text = "Терминал " .. signText
                end
            end
        end

        local highlighter = Highlighter.new(obj, ignoreList, config.outline, config.fill, textConfig, config.ForceAll or false)
        if highlighter then espObjects[obj] = highlighter end
    end

    local function trackObject(obj)
        if not shouldTrack(obj) or espObjects[obj] then return end
        task.wait(0.1)
        if not obj or not obj.Parent or espObjects[obj] or not shouldTrack(obj) then return end

        if obj.Name == "Candle" and hasAncestorWithName(obj, "Candle") then return end
        if obj.Name == "Lighter" then
            local handle = obj:FindFirstChild("Handle")
            if not handle or not handle:FindFirstChild("EffectsHolder") then return end
        end
        if isInPlayerFolder(obj) then return end

        createItemESP(obj)

        local connection
        connection = obj.AncestryChanged:Connect(function()
            if not obj:IsDescendantOf(workspace) then
                if espObjects[obj] then espObjects[obj]:Destroy() espObjects[obj] = nil end
                if connection then connection:Disconnect() end
            end
        end)
        table.insert(activeConnections, connection)
    end

    local function isAnyItemEnabled()
        for _, enabled in pairs(enabledItems) do
            if enabled then return true end
        end
        return false
    end

    local function updateGlobalScanner()
        if isAnyItemEnabled() then
            if not globalScannerConnection then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if shouldTrack(obj) then trackObject(obj) end
                end
                globalScannerConnection = workspace.DescendantAdded:Connect(function(obj)
                    if shouldTrack(obj) then trackObject(obj) end
                end)
            end
        else
            if globalScannerConnection then
                globalScannerConnection:Disconnect()
                globalScannerConnection = nil
            end
        end
    end

    local function removeItemsEspByName(itemName)
        for obj, highlighter in pairs(espObjects) do
            if obj.Name == itemName then
                if highlighter then highlighter:Destroy() end
                espObjects[obj] = nil
            end
        end
    end

    local function removeAllDoorsEsp()
        for door, highlighter in pairs(espObjects) do
            if door.Name == "Door" then
                if highlighter then highlighter:Destroy() end
                espObjects[door] = nil
            end
        end
        for _, conn in ipairs(doorScannerConnections) do
            if conn then conn:Disconnect() end
        end
        doorScannerConnections = {}
    end

    local function selfDestruct()
        isDoorsEspEnabled = false
        for k, _ in pairs(enabledItems) do enabledItems[k] = false end

        if globalScannerConnection then globalScannerConnection:Disconnect() globalScannerConnection = nil end
        removeAllDoorsEsp()

        for obj, highlighter in pairs(espObjects) do
            if highlighter then highlighter:Destroy() end
        end
        for _, conn in ipairs(activeConnections) do
            if conn then conn:Disconnect() end
        end

        espObjects = nil
        activeConnections = nil
        doorScannerConnections = nil
        enabledItems = nil
        Highlighter = nil
        itemToggleObjects = nil
    end

    ESPTab:CreateButton({
        Name = "🟢 Включить всё ESP",
        Callback = function()
            isDoorsEspEnabled = true
            for internalName, _ in pairs(ESP_CONFIG) do
                enabledItems[internalName] = true
            end

            initDoorScanner()
            updateGlobalScanner()

            if doorToggleObject then doorToggleObject:Set(true) end
            for _, toggle in pairs(itemToggleObjects) do
                toggle:Set(true)
            end
        end,
    })

    ESPTab:CreateButton({
        Name = "🔴 Выключить всё ESP",
        Callback = function()
            isDoorsEspEnabled = false
            for internalName, _ in pairs(ESP_CONFIG) do
                enabledItems[internalName] = false
                removeItemsEspByName(internalName)
            end

            removeAllDoorsEsp()
            if globalScannerConnection then
                globalScannerConnection:Disconnect()
                globalScannerConnection = nil
            end

            if doorToggleObject then doorToggleObject:Set(false) end
            for _, toggle in pairs(itemToggleObjects) do
                toggle:Set(false)
            end
        end,
    })

    ESPTab:CreateSection("Индивидуальные настройки")

    doorToggleObject = ESPTab:CreateToggle({
        Name = "Подсветка Дверей",
        CurrentValue = false,
        Flag = "DoorsEspToggle",
        Callback = function(Value)
            isDoorsEspEnabled = Value
            if isDoorsEspEnabled then initDoorScanner() else removeAllDoorsEsp() end
        end,
    })

    for internalName, data in pairs(ESP_CONFIG) do
        enabledItems[internalName] = false

        itemToggleObjects[internalName] = ESPTab:CreateToggle({
            Name = data.uiName or internalName,
            CurrentValue = false,
            Flag = internalName .. "Toggle",
            Callback = function(Value)
                enabledItems[internalName] = Value
                if Value then
                    updateGlobalScanner()
                else
                    removeItemsEspByName(internalName)
                    updateGlobalScanner()
                end
            end,
        })
    end

    return selfDestruct
end
