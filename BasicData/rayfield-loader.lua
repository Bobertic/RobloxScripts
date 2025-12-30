local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "👾 Cheat Menu",
    LoadingTitle = "Loading Cheat Menu...",
    LoadingSubtitle = "by Bobertic",
    ConfigurationSaving = {Enabled = false}
})

local LoadMiscTab = loadstring(game:HttpGet('https://raw.githubusercontent.com/Bobertic/testo/refs/heads/main/misc-tab.lua'))()
LoadMiscTab(Window)

return {Rayfield = Rayfield, Window = Window}
