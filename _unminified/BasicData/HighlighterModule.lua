local Highlighter = {}
Highlighter.__index = Highlighter

local activeHighlights = {}

local function getTargetBounds(target, ignoreMap)
    if target:IsA("Model") then
        if target.PrimaryPart then
            return target.PrimaryPart.CFrame, target.PrimaryPart.Size
        end
        return target:GetBoundingBox()
    elseif target:IsA("BasePart") then
        return target.CFrame, target.Size
    else
        local primary = target:FindFirstChildWhichIsA("BasePart", true)
        if primary and not ignoreMap[primary] then
            return primary.CFrame, primary.Size
        end
    end
    return nil, nil
end

function Highlighter.new(target, ignoreList, outlineConfig, fillConfig, textConfig, forceHighlightAll)
    if not target then
        warn("[Highlighter] Цель не указана")
        return nil
    end

    local forceAll = (forceHighlightAll == 1 or forceHighlightAll == true)

    if activeHighlights[target] then
        activeHighlights[target]:Destroy()
    end

    local self = setmetatable({}, Highlighter)
    self.Target = target
    self.Folder = Instance.new("Folder")
    self.Folder.Name = "Highlighter_" .. target.Name
    self.Folder.Parent = target
    self.OriginalModifiers = {}

    local ignoreMap = {}
    if ignoreList and type(ignoreList) == "table" then
        for _, obj in ipairs(ignoreList) do
            if obj then
                ignoreMap[obj] = true
                if obj:IsA("Instance") then
                    for _, desc in ipairs(obj:GetDescendants()) do
                        ignoreMap[desc] = true
                    end
                end
            end
        end
    end

    if ignoreMap[target] then
        return self
    end

    local useOutline = outlineConfig and outlineConfig.Use ~= 0
    local useFill = fillConfig and fillConfig.Use ~= 0

    if useOutline or useFill then
        if not forceAll then
            for _, desc in ipairs(target:GetDescendants()) do
                if desc:IsA("BasePart") then
                    if ignoreMap[desc] or desc.Name == "Hidden" or desc.Name == "Wall_Strip" or desc.Transparency >= 1 then
                        self.OriginalModifiers[desc] = desc.LocalTransparencyModifier
                        desc.LocalTransparencyModifier = 1
                    end
                end
            end
        end

        local highlight = Instance.new("Highlight")
        highlight.Adornee = target

        if useOutline then
            highlight.OutlineColor = outlineConfig.Color or Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = outlineConfig.Transparency or 0
        else
            highlight.OutlineTransparency = 1
        end

        if useFill then
            highlight.FillColor = fillConfig.Color or Color3.fromRGB(255, 0, 0)
            highlight.FillTransparency = fillConfig.Transparency or 0
        else
            highlight.FillTransparency = 1
        end

        local outlineAlwaysOnTop = outlineConfig and (outlineConfig.AlwaysOnTop == 1 or outlineConfig.AlwaysOnTop == true)
        local fillAlwaysOnTop = fillConfig and (fillConfig.AlwaysOnTop == 1 or fillConfig.AlwaysOnTop == true)
        highlight.DepthMode = (outlineAlwaysOnTop or fillAlwaysOnTop) and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded

        highlight.Parent = self.Folder
    end

    if textConfig and textConfig.Use ~= 0 and textConfig.Text and textConfig.Text ~= "" then
        local targetCFrame, targetSize = getTargetBounds(target, ignoreMap)

        if targetCFrame and targetSize then
            local billboard = Instance.new("BillboardGui")
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.AlwaysOnTop = (textConfig.AlwaysOnTop == 1 or textConfig.AlwaysOnTop == true)

            local customOffsetX = 0
            local customOffsetY = 0
            local customOffsetZ = 0

            if textConfig.Offset and type(textConfig.Offset) == "table" then
                customOffsetX = textConfig.Offset.x or textConfig.Offset.X or 0
                customOffsetY = textConfig.Offset.y or textConfig.Offset.Y or 0
                customOffsetZ = textConfig.Offset.z or textConfig.Offset.Z or 0
            end

            local baseHeight = targetSize.Y / 2 + 1.5
            billboard.StudsOffset = Vector3.new(customOffsetX, baseHeight + customOffsetY, customOffsetZ)

            local textAdornee = target:IsA("Model") and target.PrimaryPart or target
            if ignoreMap[textAdornee] or (target:IsA("Model") and not target.PrimaryPart) then
                local attachmentPart = Instance.new("Part")
                attachmentPart.Size = Vector3.new(0.1, 0.1, 0.1)
                attachmentPart.CFrame = targetCFrame
                attachmentPart.Transparency = 1
                attachmentPart.CanCollide = false
                attachmentPart.Anchored = true
                attachmentPart.Name = "TextAttachment"
                attachmentPart.Parent = self.Folder
                textAdornee = attachmentPart

                billboard.StudsOffset = Vector3.new(customOffsetX, (targetSize.Y / 2 + 1) + customOffsetY, customOffsetZ)
            end

            billboard.Adornee = textAdornee

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = textConfig.Text
            label.TextColor3 = textConfig.Color or Color3.fromRGB(255, 255, 255)
            label.TextSize = textConfig.Size or 14
            label.Font = Enum.Font.SourceSansBold
            label.TextStrokeTransparency = 0
            label.Parent = billboard

            billboard.Parent = self.Folder
        end
    end

    activeHighlights[target] = self
    return self
end

function Highlighter:Destroy()
    if self.OriginalModifiers then
        for part, originalValue in pairs(self.OriginalModifiers) do
            if part and part.Parent then
                part.LocalTransparencyModifier = originalValue
            end
        end
    end

    if self.Folder then
        self.Folder:Destroy()
    end
    if activeHighlights[self.Target] == self then
        activeHighlights[self.Target] = nil
    end
    self.Target = nil
end

return Highlighter
