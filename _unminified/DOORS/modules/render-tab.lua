return function(Window, Rayfield)
    local RenderTab = Window:CreateTab("🎬 Графика", nil)

    local UserInputService = game:GetService("UserInputService")
    local Lighting = game:GetService("Lighting")

    local defaultSettings = {}
    local isCustomLighting = false

    local connections = {}
    local cameraConnection = nil
    local keybindConnection = nil

    local TARGET_BRIGHTNESS = 2
    local TARGET_AMBIENT = Color3.new(1, 1, 1)
    local TARGET_FOV = 70
    local isUpdating = false

    local function enforceSettings()
        if isUpdating then return end
        isUpdating = true

        if Lighting.GlobalShadows ~= false then Lighting.GlobalShadows = false end
        if Lighting.ShadowSoftness ~= 0 then Lighting.ShadowSoftness = 0 end
        if Lighting.Brightness ~= TARGET_BRIGHTNESS then Lighting.Brightness = TARGET_BRIGHTNESS end
        if Lighting.Ambient ~= TARGET_AMBIENT then Lighting.Ambient = TARGET_AMBIENT end

        local camera = workspace.CurrentCamera
        if camera and camera.FieldOfView ~= TARGET_FOV then
            camera.FieldOfView = TARGET_FOV
        end

        isUpdating = false
    end

    local function applyNoShadows()
        defaultSettings.GlobalShadows = Lighting.GlobalShadows
        defaultSettings.ShadowSoftness = Lighting.ShadowSoftness
        defaultSettings.Brightness = Lighting.Brightness
        defaultSettings.Ambient = Lighting.Ambient
        defaultSettings.FOV = workspace.CurrentCamera and workspace.CurrentCamera.FieldOfView or 70

        enforceSettings()

        local propertiesToWatch = {"GlobalShadows", "ShadowSoftness", "Brightness", "Ambient"}
        for _, prop in ipairs(propertiesToWatch) do
            local conn = Lighting:GetPropertyChangedSignal(prop):Connect(enforceSettings)
            table.insert(connections, conn)
        end

        if workspace.CurrentCamera then
            cameraConnection = workspace.CurrentCamera:GetPropertyChangedSignal("FieldOfView"):Connect(enforceSettings)
        end
    end

    local function restoreDefault()
        for _, conn in ipairs(connections) do
            if conn then conn:Disconnect() end
        end
        connections = {}

        if cameraConnection then
            cameraConnection:Disconnect()
            cameraConnection = nil
        end

        isUpdating = true
        Lighting.GlobalShadows = defaultSettings.GlobalShadows
        Lighting.ShadowSoftness = defaultSettings.ShadowSoftness
        Lighting.Brightness = defaultSettings.Brightness
        Lighting.Ambient = defaultSettings.Ambient
        if workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = defaultSettings.FOV
        end
        isUpdating = false
    end

    local function selfDestruct()
        if isCustomLighting then
            restoreDefault()
        end

        for _, conn in ipairs(connections) do
            if conn then conn:Disconnect() end
        end
        if cameraConnection then cameraConnection:Disconnect() end

        connections = nil
        defaultSettings = nil
        cameraConnection = nil
        enforceSettings = nil
        applyNoShadows = nil
        restoreDefault = nil
    end

    local LightingToggle

    LightingToggle = RenderTab:CreateToggle({
        Name = "Яркий свет и Без теней",
        CurrentValue = false,
        Flag = "LightingToggle",
        Callback = function(Value)
            isCustomLighting = Value
            if isCustomLighting then
                applyNoShadows()
            else
                restoreDefault()
            end
        end,
    })

    RenderTab:CreateKeybind({
        Name = "Клавиша активации",
        CurrentKeybind = "Y",
        HoldToInteract = false,
        Flag = "LightingKeybind",
        Callback = function(Key)
            if LightingToggle then
                LightingToggle:Set(not isCustomLighting)
            end
        end,
    })

    return selfDestruct
end
