return function(Window)
    local TPTab = Window:CreateTab("🔗 Misc", nil)


    TPTab:CreateButton({
        Name = "Infinite Yield",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        end
    })

    return TPTab
end
