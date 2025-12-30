return function(Window)
    local TPTab = Window:CreateTab("🔗 Misc", nil)
    
    TPTab:CreateButton({
        Name = "Join Discord",
        Callback = function()
            setclipboard("https://discord.gg/WJrkNkf4yY")
        end
    })
    
    TPTab:CreateButton({
        Name = "Infinite Yield",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        end
    })
end
