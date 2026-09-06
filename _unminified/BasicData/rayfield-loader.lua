return function(extraText)
    local nameExtension = ""
    if extraText and extraText ~= "" then
        nameExtension = " | " .. tostring(extraText)
    end

    local Rayfield = loadstring(game:HttpGet('https://test.local/div/BasicData/_IMPOTR/rayfield.lua'))()
    local Window = Rayfield:CreateWindow({
        Name = "👾 Cheat Menu" .. nameExtension,
        LoadingTitle = "Loading Cheat Menu...",
        LoadingSubtitle = "by Bobertic",
        ConfigurationSaving = {Enabled = false}
    })

    return {Rayfield = Rayfield, Window = Window}
end
