local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "👾 Cheat Menu",
    LoadingTitle = "Loading Cheat Menu...",
    LoadingSubtitle = "by Bobertic",
    ConfigurationSaving = {Enabled = false}
})
return {Rayfield = Rayfield, Window = Window}
