local RayfieldLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/Bobertic/RobloxScripts/refs/heads/main/BasicData/rayfield-loader.lua'))()
local Rayfield = RayfieldLib.Rayfield
local Window = RayfieldLib.Window

local Lighting = game:GetService("Lighting")

local savedSettings = {}

-- Переменные для управления состояниями
local Clip = true
local Noclipping = nil
local isDeleteShadows = false
local DestroyMenu = false
local view = "first"


local function SaveLightingSettings()
    savedSettings.ambient = Lighting.Ambient
    savedSettings.exposure = Lighting.ExposureCompensation
    savedSettings.children = {}
    
    for _, child in ipairs(Lighting:GetChildren()) do
        table.insert(savedSettings.children, child:Clone())
    end
end

local function DeleteShadows()
    while isDeleteShadows do
        if DestroyMenu then
            isDeleteShadows = false
            RestoreLightingSettings()
            return
        end

        Lighting:ClearAllChildren()

        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.ExposureCompensation = -1.5

        task.wait(0.05)
    end
end

local function RestoreLightingSettings()
    if not next(savedSettings) then return end
    
    Lighting.Ambient = savedSettings.ambient
    Lighting.ExposureCompensation = savedSettings.exposure
    Lighting:ClearAllChildren()
    
    for _, child in ipairs(savedSettings.children) do
        child:Clone().Parent = Lighting
    end
end

local function noclip()
    Clip = false
    local function NoclipLoop()
        if Clip == false and Players.LocalPlayer.Character then
            for _, part in pairs(Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
    Noclipping = RunService.Stepped:Connect(NoclipLoop)
end

local function unnoclip()
    if Noclipping then
        Noclipping:Disconnect()
    end
    Clip = true
end

local function thirdp()
    Players.LocalPlayer.CameraMode = Enum.CameraMode.Classic
end

local function firstp()
    Players.LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
end


local MainTab = Window:CreateTab("Основные функции", nil)
local InfoTab = Window:CreateTab("Информация", nil)


local AutomaticSettingsToggle = MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip_Toggle",
    Callback = function(Value)
        if Value then
            noclip()
        else
            unnoclip()
        end
    end
})

local AutomaticSettingsToggle = MainTab:CreateToggle({
    Name = "Удалить тени",
    CurrentValue = false,
    Flag = "DeleteShadows_Toggle",
    Callback = function(Value)
        if Value then
            isDeleteShadows = true
            DeleteShadows()
        else
            isAutomaticSettings = false
            RestoreLightingSettings()
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


InfoTab:CreateSection("Текущее положение")
local PositionLabel = InfoTab:CreateLabel("Загрузка позиции...")

task.spawn(function()
    local player = game.Players.LocalPlayer
    local function updatePos()
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart", 1)
        if rootPart then
            PositionLabel:Set(("X: %.0f | Y: %.0f | Z: %.0f"):format(rootPart.Position.X, rootPart.Position.Y, rootPart.Position.Z))
        else
            PositionLabel:Set("Позиция недоступна")
        end
    end

    while not DestroyMenu do
        updatePos()
        task.wait(0.05)
    end
end)

SaveLightingSettings()
