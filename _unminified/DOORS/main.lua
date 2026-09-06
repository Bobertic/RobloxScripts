local RayfieldLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/Bobertic/RobloxScripts/refs/heads/master/_unminified/BasicData/rayfield-loader.lua'))()("Doors")
local Rayfield = RayfieldLib.Rayfield
local Window = RayfieldLib.Window

local DestroyRenderScript = nil
local DestroyEspScript = nil
local DestroyMonstersScript = nil

local function totalUnload()
    if DestroyRenderScript then DestroyRenderScript() end
    if DestroyEspScript then DestroyEspScript() end
    if DestroyMonstersScript then DestroyMonstersScript() end
    if Rayfield then Rayfield:Destroy() end
end



local successMisc, LoadMiscTab = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/Bobertic/RobloxScripts/refs/heads/master/_unminified/BasicData/misc-tab.lua'))()
end)

local MiscTabObject

if successMisc and type(LoadMiscTab) == "function" then
    MiscTabObject = LoadMiscTab(Window, Rayfield)
else
    warn("Не удалось загрузить misc--tab.lua")
end

if MiscTabObject then
    MiscTabObject:CreateSection("")
    MiscTabObject:CreateSection("Управление скриптом")

    MiscTabObject:CreateButton({
        Name = "❌ Выгрузить скрипт",
        Info = "Полностью удаляет интерфейс чита и очищает память",
        Callback = totalUnload
    })
end


local successRender, LoadRenderTab = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/Bobertic/RobloxScripts/refs/heads/master/_unminified/DOORS/modules/render-tab.lua'))()
end)

if successRender and type(LoadRenderTab) == "function" then
    DestroyRenderScript = LoadRenderTab(Window, Rayfield)
else
    warn("Не удалось загрузить render-tab.lua")
end


local successEsp, LoadEspTab = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/Bobertic/RobloxScripts/refs/heads/master/_unminified/DOORS/modules/esp-tab.lua'))()
end)

if successEsp and type(LoadEspTab) == "function" then
    DestroyEspScript = LoadEspTab(Window, Rayfield)
else
    warn("Не удалось загрузить esp-tab.lua")
end


local successMonsters, LoadMonstersTab = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/Bobertic/RobloxScripts/refs/heads/master/_unminified/DOORS/modules/esp-monsters-tab.lua'))()
end)

if successMonsters and type(LoadMonstersTab) == "function" then
    DestroyMonstersScript = LoadMonstersTab(Window, Rayfield)
else
    warn("Не удалось загрузить monsters-tab.lua")
end
