--[[ Redz UI Style GUI for Blox Fruits (Executor Script) - v1.3 Dropdown & Slider --]]

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Prevent script errors from stopping execution in some executors
local success, err = pcall(function()

    -- Theme (Based on DamThien)
    local theme = {
        colorHub1Start = Color3.fromRGB(25, 25, 25),
        colorHub1Mid = Color3.fromRGB(32.5, 32.5, 32.5),
        colorHub1End = Color3.fromRGB(25, 25, 25),
        colorHub2 = Color3.fromRGB(30, 30, 30),
        colorStroke = Color3.fromRGB(40, 40, 40),
        colorTheme = Color3.fromRGB(128, 255, 0), -- Lime green
        colorText = Color3.fromRGB(243, 243, 243),
        colorDarkText = Color3.fromRGB(180, 180, 180),
    }

    -- Initial Config & State
    local initialWidth = 550
    local initialHeight = 380
    local initialTabWidth = 160
    local windowTitle = "Blox Fruits UI"
    local windowSubTitle = "by Manus"

    local currentWidth = initialWidth
    local currentHeight = initialHeight
    local currentTabWidth = initialTabWidth
    local minimized = false
    local minimizedHeight = 28 -- Height of topBar
    local savedSize = UDim2.fromOffset(currentWidth, currentHeight)

    -- Min/Max Sizes from original lib
    local minWindowWidth = 430
    local minWindowHeight = 200
    local maxWindowWidth = 1000 -- Arbitrary reasonable max
    local maxWindowHeight = 700 -- Arbitrary reasonable max
    local minTabWidth = 135
    local maxTabWidth = 250

    -- Create ScreenGui
    local existingGui = CoreGui:FindFirstChild("BloxFruitsRedzUI")
    if existingGui then
        existingGui:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BloxFruitsRedzUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui

    -- Main Window Frame
    local mainWindow = Instance.new("ImageButton")
    mainWindow.Name = "MainWindow"
    mainWindow.Size = UDim2.fromOffset(currentWidth, currentHeight)
    mainWindow.Position = UDim2.new(0.5, -currentWidth / 2, 0.5, -currentHeight / 2)
    mainWindow.BackgroundColor3 = theme.colorHub2
    mainWindow.BackgroundTransparency = 0.1
    mainWindow.BorderSizePixel = 0
    mainWindow.AutoButtonColor = false
    mainWindow.Selectable = true
    mainWindow.Active = true
    mainWindow.Draggable = true
    mainWindow.ClipsDescendants = true
    mainWindow.Parent = screenGui

    -- Gradient, Corner, Stroke
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0.00, theme.colorHub1Start), ColorSequenceKeypoint.new(0.50, theme.colorHub1Mid), ColorSequenceKeypoint.new(1.00, theme.colorHub1End)})
    gradient.Rotation = 45
    gradient.Parent = mainWindow
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 7)
    corner.Parent = mainWindow
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.colorStroke
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = mainWindow

    -- Top Bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 28)
    topBar.BackgroundTransparency = 1
    topBar.Parent = mainWindow

    -- Title & Subtitle
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.AutomaticSize = Enum.AutomaticSize.XY
    titleLabel.Position = UDim2.new(0, 15, 0.5, 0)
    titleLabel.AnchorPoint = Vector2.new(0, 0.5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.Text = windowTitle
    titleLabel.TextColor3 = theme.colorText
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar
    local subTitleLabel = Instance.new("TextLabel")
    subTitleLabel.Name = "SubTitle"
    subTitleLabel.AutomaticSize = Enum.AutomaticSize.X
    subTitleLabel.Size = UDim2.new(subTitleLabel.Size.X.Scale, subTitleLabel.Size.X.Offset, 1, 0)
    subTitleLabel.Position = UDim2.new(1, 5, 0.9, 0)
    subTitleLabel.AnchorPoint = Vector2.new(0, 1)
    subTitleLabel.BackgroundTransparency = 1
    subTitleLabel.Font = Enum.Font.Gotham
    subTitleLabel.Text = windowSubTitle
    subTitleLabel.TextColor3 = theme.colorDarkText
    subTitleLabel.TextSize = 8
    subTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subTitleLabel.TextYAlignment = Enum.TextYAlignment.Bottom
    subTitleLabel.Parent = titleLabel

    -- Top Bar Buttons (Close, Minimize)
    local topButtonLayout = Instance.new("UIListLayout")
    topButtonLayout.FillDirection = Enum.FillDirection.Horizontal
    topButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    topButtonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    topButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    topButtonLayout.Padding = UDim.new(0, 5)
    topButtonLayout.Parent = topBar

    local closeButton = Instance.new("ImageButton")
    closeButton.Name = "CloseButton"
    closeButton.LayoutOrder = 2
    closeButton.Size = UDim2.fromOffset(14, 14)
    closeButton.Position = UDim2.new(1, -10, 0.5, 0) -- Positioned by layout now
    closeButton.AnchorPoint = Vector2.new(1, 0.5)
    closeButton.BackgroundTransparency = 1
    closeButton.Image = "rbxassetid://10747384394" -- Close X icon
    closeButton.ImageColor3 = theme.colorText
    closeButton.Parent = topBar

    local minimizeButton = Instance.new("ImageButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.LayoutOrder = 1
    minimizeButton.Size = UDim2.fromOffset(14, 14)
    minimizeButton.Position = UDim2.new(1, -35, 0.5, 0) -- Positioned by layout now
    minimizeButton.AnchorPoint = Vector2.new(1, 0.5)
    minimizeButton.BackgroundTransparency = 1
    minimizeButton.Image = "rbxassetid://10734896206" -- Minimize icon
    minimizeButton.ImageColor3 = theme.colorText
    minimizeButton.Parent = topBar

    -- Content Area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, 0, 1, -topBar.Size.Y.Offset)
    contentArea.Position = UDim2.new(0, 0, 0, topBar.Size.Y.Offset)
    contentArea.BackgroundTransparency = 1
    contentArea.ClipsDescendants = true
    contentArea.Parent = mainWindow

    -- Tab Scroll Area
    local tabScrollArea = Instance.new("ScrollingFrame")
    tabScrollArea.Name = "TabScrollArea"
    tabScrollArea.Size = UDim2.new(0, currentTabWidth, 1, 0)
    tabScrollArea.Position = UDim2.new(0, 0, 0, 0)
    tabScrollArea.BackgroundTransparency = 1
    tabScrollArea.BorderSizePixel = 0
    tabScrollArea.ScrollBarImageColor3 = theme.colorTheme
    tabScrollArea.ScrollBarImageTransparency = 0.2
    tabScrollArea.ScrollBarThickness = 6
    tabScrollArea.ScrollingDirection = Enum.ScrollingDirection.Y
    tabScrollArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabScrollArea.CanvasSize = UDim2.new()
    tabScrollArea.Parent = contentArea
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingLeft = UDim.new(0, 10)
    tabPadding.PaddingRight = UDim.new(0, 10)
    tabPadding.PaddingTop = UDim.new(0, 10)
    tabPadding.PaddingBottom = UDim.new(0, 10)
    tabPadding.Parent = tabScrollArea
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabScrollArea
    local tabSeparatorStroke = Instance.new("UIStroke")
    tabSeparatorStroke.Color = theme.colorStroke
    tabSeparatorStroke.Thickness = 1
    tabSeparatorStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    tabSeparatorStroke.Parent = tabScrollArea

    -- Options Container
    local optionsContainer = Instance.new("Frame")
    optionsContainer.Name = "OptionsContainer"
    optionsContainer.Size = UDim2.new(1, -currentTabWidth, 1, 0)
    optionsContainer.Position = UDim2.new(0, currentTabWidth, 0, 0)
    optionsContainer.BackgroundTransparency = 1
    optionsContainer.ClipsDescendants = true
    optionsContainer.Parent = contentArea

    -- Dropdown Holder (Global, to ensure only one dropdown is open)
    local dropdownHolder = Instance.new("Frame")
    dropdownHolder.Name = "DropdownHolder"
    dropdownHolder.Size = UDim2.new(1, 0, 1, 0)
    dropdownHolder.BackgroundTransparency = 1
    dropdownHolder.Visible = false -- Hidden until a dropdown is opened
    dropdownHolder.ZIndex = 50 -- Above options, below dialogs
    dropdownHolder.Parent = screenGui -- Parent to ScreenGui to overlay everything

    -- Input State Variables
    local dragging = false
    local resizingWindow = false
    local resizingTabs = false
    local sliding = false -- For slider
    local dragStart = nil
    local startPos = nil
    local startSize = nil
    local startTabWidth = nil
    local lastInputPos = nil -- For smooth drag
    local activeSliderInfo = nil -- Holds info about the currently dragged slider

    -- Smooth Drag Logic
    local dragTweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local currentDragTween = nil

    mainWindow.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local target = input.GuiObject
            if target and (target.Name == "WindowResizeHandle" or target.Name == "TabResizeHandle" or target == closeButton or target == minimizeButton) then
                return
            end
            -- Check if clicking inside an active dropdown or slider knob
            if target and (target:FindFirstAncestor("DropdownFrame") or target.Name == "SliderKnob") then
                 return
            end
            -- Prevent dragging when clicking options (unless it's the base frame)
            local optionFrameAncestor = target:FindFirstAncestor("OptionFrame")
            if optionFrameAncestor and target ~= optionFrameAncestor then
                 return
            end

            -- dragging = true -- Disabled by Manus for Draggable=true
            dragStart = input.Position
            startPos = mainWindow.Position
            lastInputPos = dragStart
            if currentDragTween then currentDragTween:Cancel() end

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    lastInputPos = nil
                end
            end)
        end
    end)

    -- Window Resize Handle
    local windowResizeHandle = Instance.new("ImageButton")
    windowResizeHandle.Name = "WindowResizeHandle"
    windowResizeHandle.Size = UDim2.fromOffset(15, 15)
    windowResizeHandle.Position = UDim2.new(1, -windowResizeHandle.Size.X.Offset, 1, -windowResizeHandle.Size.Y.Offset)
    windowResizeHandle.BackgroundTransparency = 1
    windowResizeHandle.Image = "rbxassetid://10709791523"
    windowResizeHandle.ImageColor3 = theme.colorTheme
    windowResizeHandle.ImageTransparency = 0.5
    windowResizeHandle.Rotation = 45
    windowResizeHandle.ZIndex = 10
    windowResizeHandle.Parent = mainWindow
    windowResizeHandle.MouseEnter:Connect(function() windowResizeHandle.ImageTransparency = 0 end)
    windowResizeHandle.MouseLeave:Connect(function() windowResizeHandle.ImageTransparency = 0.5 end)
    windowResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizingWindow = true
            dragStart = input.Position
            startSize = mainWindow.AbsoluteSize
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizingWindow = false
                end
            end)
        end
    end)

    -- Tab Resize Handle
    local tabResizeHandle = Instance.new("Frame")
    tabResizeHandle.Name = "TabResizeHandle"
    tabResizeHandle.Size = UDim2.new(0, 5, 1, 0)
    tabResizeHandle.Position = UDim2.new(0, currentTabWidth - 2.5, 0, 0)
    tabResizeHandle.BackgroundColor3 = theme.colorStroke
    tabResizeHandle.BackgroundTransparency = 0.7
    tabResizeHandle.BorderSizePixel = 0
    tabResizeHandle.ZIndex = 10
    tabResizeHandle.Parent = contentArea
    tabResizeHandle.MouseEnter:Connect(function() tabResizeHandle.BackgroundTransparency = 0.4 end)
    tabResizeHandle.MouseLeave:Connect(function() tabResizeHandle.BackgroundTransparency = 0.7 end)
    tabResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizingTabs = true
            dragStart = input.Position
            startTabWidth = tabScrollArea.AbsoluteSize.X
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizingTabs = false
                end
            end)
        end
    end)

    -- Global Input Handling for Dragging/Resizing/Sliding
    UserInputService.InputChanged:Connect(function(input)
        if not (dragging or resizingWindow or resizingTabs or sliding) then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local currentPos = input.Position

            --[[ Disabled by Manus for Draggable=true
            if dragging and lastInputPos then
                local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + (currentPos.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (currentPos.Y - dragStart.Y))
                if currentDragTween then currentDragTween:Cancel() end
                currentDragTween = TweenService:Create(mainWindow, dragTweenInfo, {Position = targetPos})
                currentDragTween:Play()
                startPos = targetPos -- Approximation
                lastInputPos = currentPos
            end
            --]]

            if resizingWindow then
                local resizeDelta = currentPos - dragStart
                local newWidth = math.clamp(startSize.X + resizeDelta.X, minWindowWidth, maxWindowWidth)
                local newHeight = math.clamp(startSize.Y + resizeDelta.Y, minWindowHeight, maxWindowHeight)
                mainWindow.Size = UDim2.fromOffset(newWidth, newHeight)
                currentWidth = newWidth
                currentHeight = newHeight
                savedSize = mainWindow.Size
                windowResizeHandle.Position = UDim2.new(1, -windowResizeHandle.Size.X.Offset, 1, -windowResizeHandle.Size.Y.Offset)
                contentArea.Size = UDim2.new(1, 0, 1, -topBar.Size.Y.Offset)
                local newTabWidth = math.clamp(currentTabWidth, minTabWidth, math.min(maxTabWidth, currentWidth - 20))
                tabScrollArea.Size = UDim2.new(0, newTabWidth, 1, 0)
                optionsContainer.Size = UDim2.new(1, -newTabWidth, 1, 0)
                optionsContainer.Position = UDim2.new(0, newTabWidth, 0, 0)
                tabResizeHandle.Position = UDim2.new(0, newTabWidth - 2.5, 0, 0)
                currentTabWidth = newTabWidth
            end

            if resizingTabs then
                local resizeDelta = currentPos - dragStart
                local newTabWidth = math.clamp(startTabWidth + resizeDelta.X, minTabWidth, math.min(maxTabWidth, currentWidth - 20))
                tabScrollArea.Size = UDim2.new(0, newTabWidth, 1, 0)
                optionsContainer.Size = UDim2.new(1, -newTabWidth, 1, 0)
                optionsContainer.Position = UDim2.new(0, newTabWidth, 0, 0)
                tabResizeHandle.Position = UDim2.new(0, newTabWidth - 2.5, 0, 0)
                currentTabWidth = newTabWidth
            end

            if sliding and activeSliderInfo then
                local sliderBar = activeSliderInfo.sliderBar
                local knob = activeSliderInfo.knob
                local indicator = activeSliderInfo.indicator
                local valueLabel = activeSliderInfo.valueLabel
                local minVal = activeSliderInfo.minVal
                local maxVal = activeSliderInfo.maxVal
                local step = activeSliderInfo.step
                local callback = activeSliderInfo.callback
                local api = activeSliderInfo.api

                local relativeX = currentPos.X - sliderBar.AbsolutePosition.X
                local percentage = math.clamp(relativeX / sliderBar.AbsoluteSize.X, 0, 1)

                -- Calculate raw value and snap to step
                local rawValue = minVal + percentage * (maxVal - minVal)
                local steppedValue = math.floor(rawValue / step + 0.5) * step
                steppedValue = math.clamp(steppedValue, minVal, maxVal)

                -- Update visuals based on stepped value percentage
                local steppedPercentage = (steppedValue - minVal) / (maxVal - minVal)
                knob.Position = UDim2.fromScale(steppedPercentage, 0.5)
                indicator.Size = UDim2.fromScale(steppedPercentage, 1)

                -- Update label and trigger callback only if value changed
                if steppedValue ~= api:GetValue() then
                    api._currentValue = steppedValue -- Update internal value directly
                    valueLabel.Text = string.format("%.2f", steppedValue):gsub("%.?0*$", "") -- Format nicely
                    if callback then task.spawn(callback, steppedValue) end
                end
            end
        end
    end)

    -- Helper: Create standard button frame base
    local function createButtonFrameBase(parent, title, description, rightElementWidth)
        local frame = Instance.new("TextButton")
        frame.Name = "OptionFrame"
        frame.Size = UDim2.new(1, 0, 0, 25)
        frame.AutomaticSize = Enum.AutomaticSize.Y
        frame.BackgroundColor3 = theme.colorHub2
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel = 0
        frame.AutoButtonColor = false
        frame.Text = ""
        frame.Parent = parent
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = frame
        local labelHolder = Instance.new("Frame")
        labelHolder.Name = "LabelHolder"
        labelHolder.Size = UDim2.new(1, -(10 + rightElementWidth + 10), 1, 0)
        labelHolder.Position = UDim2.new(0, 10, 0, 0)
        labelHolder.BackgroundTransparency = 1
        labelHolder.AutomaticSize = Enum.AutomaticSize.Y
        labelHolder.Parent = frame
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 2)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        listLayout.Parent = labelHolder
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 5)
        padding.PaddingBottom = UDim.new(0, 5)
        padding.Parent = labelHolder
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "TitleLabel"
        titleLabel.Size = UDim2.new(1, 0, 0, 0)
        titleLabel.AutomaticSize = Enum.AutomaticSize.Y
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Enum.Font.GothamMedium
        titleLabel.TextColor3 = theme.colorText
        titleLabel.TextSize = 10
        titleLabel.Text = title or ""
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.TextWrapped = true
        titleLabel.Parent = labelHolder
        local descLabel = Instance.new("TextLabel")
        descLabel.Name = "DescLabel"
        descLabel.Size = UDim2.new(1, 0, 0, 0)
        descLabel.AutomaticSize = Enum.AutomaticSize.Y
        descLabel.BackgroundTransparency = 1
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextColor3 = theme.colorDarkText
        descLabel.TextSize = 8
        descLabel.Text = description or ""
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.TextWrapped = true
        descLabel.Visible = (description and description ~= "")
        descLabel.Parent = labelHolder

        local function updateAlignment()
            if descLabel.Visible and descLabel.Text ~= "" then labelHolder.VerticalAlignment = Enum.VerticalAlignment.Top else labelHolder.VerticalAlignment = Enum.VerticalAlignment.Center end
        end
        updateAlignment()

        frame.MouseEnter:Connect(function() TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play() end)
        frame.MouseLeave:Connect(function() TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() end)

        local api = {}
        function api:SetTitle(newTitle) titleLabel.Text = newTitle or ""; updateAlignment() end
        function api:SetDesc(newDesc) descLabel.Text = newDesc or ""; descLabel.Visible = (newDesc and newDesc ~= ""); updateAlignment() end
        function api:Visible(isVisible) frame.Visible = isVisible end
        function api:Destroy() frame:Destroy() end
        api._frame = frame -- Expose frame for internal use

        return frame, api
    end

    -- Function to create Option Frame
    local function createOptionFrame(tabName)
        local optionFrame = Instance.new("ScrollingFrame")
        optionFrame.Name = tabName .. "_Options"
        optionFrame.Size = UDim2.new(1, 0, 1, 0)
        optionFrame.Position = UDim2.new(0, 0, 0, 0)
        optionFrame.BackgroundTransparency = 1
        optionFrame.BorderSizePixel = 0
        optionFrame.ScrollBarImageColor3 = theme.colorTheme
        optionFrame.ScrollBarImageTransparency = 0.2
        optionFrame.ScrollBarThickness = 6
        optionFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        optionFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        optionFrame.CanvasSize = UDim2.new()
        optionFrame.Visible = false
        optionFrame.Parent = optionsContainer
        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 10)
        padding.PaddingRight = UDim.new(0, 10)
        padding.PaddingTop = UDim.new(0, 10)
        padding.PaddingBottom = UDim.new(0, 10)
        padding.Parent = optionFrame
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 5)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = optionFrame
        return optionFrame
    end

    -- Function to add Tab
    local function addTab(tabName, iconId)
        local optionFrame = createOptionFrame(tabName)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName .. "_Tab"
        tabButton.Size = UDim2.new(1, 0, 0, 24)
        tabButton.BackgroundColor3 = theme.colorHub2
        tabButton.BackgroundTransparency = 1
        tabButton.BorderSizePixel = 0
        tabButton.AutoButtonColor = false
        tabButton.Text = ""
        tabButton.Parent = tabScrollArea
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = tabButton
        local labelSizeX = iconId and -25 or -15
        local labelPosX = iconId and 25 or 15
        local tabLabel = Instance.new("TextLabel")
        tabLabel.Name = "Label"
        tabLabel.Size = UDim2.new(1, labelSizeX, 1, 0)
        tabLabel.Position = UDim2.new(0, labelPosX, 0, 0)
        tabLabel.BackgroundTransparency = 1
        tabLabel.Font = Enum.Font.GothamMedium
        tabLabel.Text = tabName
        tabLabel.TextColor3 = theme.colorText
        tabLabel.TextSize = 10
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.TextTransparency = 0.3
        tabLabel.Parent = tabButton
        local tabIcon = Instance.new("ImageLabel")
        tabIcon.Name = "Icon"
        tabIcon.Size = UDim2.new(0, 13, 0, 13)
        tabIcon.Position = UDim2.new(0, 8, 0.5, 0)
        tabIcon.AnchorPoint = Vector2.new(0, 0.5)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Image = iconId or ""
        tabIcon.ImageTransparency = 0.3
        tabIcon.Visible = (iconId ~= nil and iconId ~= "")
        tabIcon.Parent = tabButton
        local selectedIndicator = Instance.new("Frame")
        selectedIndicator.Name = "SelectedIndicator"
        selectedIndicator.Size = UDim2.new(0, 4, 0, 4)
        selectedIndicator.Position = UDim2.new(0, 1, 0.5, 0)
        selectedIndicator.AnchorPoint = Vector2.new(0, 0.5)
        selectedIndicator.BackgroundColor3 = theme.colorTheme
        selectedIndicator.BackgroundTransparency = 1
        selectedIndicator.BorderSizePixel = 0
        selectedIndicator.Parent = tabButton
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(0.5, 0)
        indicatorCorner.Parent = selectedIndicator

        tabButton.MouseEnter:Connect(function()
            if not optionFrame.Visible then TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play() end
        end)
        tabButton.MouseLeave:Connect(function()
             if not optionFrame.Visible then TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() end
        end)
        tabButton.MouseButton1Click:Connect(function()
            for _, otherTab in ipairs(tabScrollArea:GetChildren()) do
                if otherTab:IsA("TextButton") and otherTab ~= tabButton then
                    local otherLabel = otherTab:FindFirstChild("Label")
                    local otherIcon = otherTab:FindFirstChild("Icon")
                    local otherIndicator = otherTab:FindFirstChild("SelectedIndicator")
                    local otherOptionFrameName = otherTab.Name:gsub("_Tab", "") .. "_Options"
                    local otherOptionFrame = optionsContainer:FindFirstChild(otherOptionFrameName)
                    if otherOptionFrame and otherOptionFrame.Visible then
                        otherOptionFrame.Visible = false
                        TweenService:Create(otherTab, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                        if otherLabel then TweenService:Create(otherLabel, TweenInfo.new(0.35), {TextTransparency = 0.3}):Play() end
                        if otherIcon then TweenService:Create(otherIcon, TweenInfo.new(0.35), {ImageTransparency = 0.3}):Play() end
                        if otherIndicator then
                            TweenService:Create(otherIndicator, TweenInfo.new(0.35), {Size = UDim2.new(0, 4, 0, 4)}):Play()
                            TweenService:Create(otherIndicator, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
                        end
                    end
                end
            end
            optionFrame.Visible = true
            TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            if tabLabel then TweenService:Create(tabLabel, TweenInfo.new(0.35), {TextTransparency = 0}):Play() end
            if tabIcon then TweenService:Create(tabIcon, TweenInfo.new(0.35), {ImageTransparency = 0}):Play() end
            if selectedIndicator then
                TweenService:Create(selectedIndicator, TweenInfo.new(0.35), {Size = UDim2.new(0, 4, 0, 13)}):Play()
                TweenService:Create(selectedIndicator, TweenInfo.new(0.35), {BackgroundTransparency = 0}):Play()
            end
        end)

        -- Tab API
        local tabApi = {}
        tabApi.Name = tabName -- Expose name for default selection
        tabApi._optionFrame = optionFrame -- Expose for internal use

        function tabApi:AddButton(bName, bDesc, bCallback)
             local btnFrame, baseApi = createButtonFrameBase(optionFrame, bName, bDesc, 24)
             local icon = Instance.new("ImageLabel")
             icon.Size = UDim2.fromOffset(14, 14)
             icon.Position = UDim2.new(1, -10, 0.5, 0)
             icon.AnchorPoint = Vector2.new(1, 0.5)
             icon.BackgroundTransparency = 1
             icon.Image = "rbxassetid://10709791437" -- Button arrow icon
             icon.ImageColor3 = theme.colorText
             icon.Parent = btnFrame
             btnFrame.MouseButton1Click:Connect(function()
                 if bCallback then task.spawn(bCallback) end
             end)
             return baseApi
        end

        function tabApi:AddToggle(tName, tDesc, tDefault, tCallback)
            local toggleState = tDefault or false
            local toggleWidth = 35
            local toggleHeight = 18
            local knobSize = 12
            local btnFrame, baseApi = createButtonFrameBase(optionFrame, tName, tDesc, toggleWidth + 10)
            local holder = Instance.new("Frame")
            holder.Name = "ToggleHolder"
            holder.Size = UDim2.fromOffset(toggleWidth, toggleHeight)
            holder.Position = UDim2.new(1, -10, 0.5, 0)
            holder.AnchorPoint = Vector2.new(1, 0.5)
            holder.BackgroundColor3 = theme.colorStroke
            holder.Parent = btnFrame
            local holderCorner = Instance.new("UICorner")
            holderCorner.CornerRadius = UDim.new(0.5, 0)
            holderCorner.Parent = holder
            local knob = Instance.new("Frame")
            knob.Name = "Knob"
            knob.Size = UDim2.fromOffset(knobSize, knobSize)
            knob.BackgroundColor3 = theme.colorTheme
            knob.BorderSizePixel = 0
            knob.Parent = holder
            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(0.5, 0)
            knobCorner.Parent = knob
            local function updateToggleVisuals(state, animate)
                 local targetPos, targetTransparency, targetAnchor
                 if state then targetPos = UDim2.new(1, -3, 0.5, 0); targetTransparency = 0; targetAnchor = Vector2.new(1, 0.5)
                 else targetPos = UDim2.new(0, 3, 0.5, 0); targetTransparency = 0.3; targetAnchor = Vector2.new(0, 0.5) end
                 local tweenInfo = TweenInfo.new(animate and 0.25 or 0)
                 TweenService:Create(knob, tweenInfo, {Position = targetPos, BackgroundTransparency = targetTransparency, AnchorPoint = targetAnchor}):Play()
            end
            updateToggleVisuals(toggleState, false)
            btnFrame.MouseButton1Click:Connect(function()
                 toggleState = not toggleState
                 updateToggleVisuals(toggleState, true)
                 if tCallback then task.spawn(tCallback, toggleState) end
            end)
            function baseApi:Set(newState)
                 if type(newState) == "boolean" and newState ~= toggleState then
                      toggleState = newState; updateToggleVisuals(toggleState, true)
                      if tCallback then task.spawn(tCallback, toggleState) end
                 end
            end
            function baseApi:GetState() return toggleState end
            return baseApi
        end

        function tabApi:AddDropdown(dName, dDesc, dOptions, dDefault, dCallback)
            local dropdownWidth = 150
            local dropdownHeight = 18
            local btnFrame, baseApi = createButtonFrameBase(optionFrame, dName, dDesc, dropdownWidth + 10)
            local currentSelection = dDefault or (dOptions and #dOptions > 0 and dOptions[1]) or "..."
            local isOpen = false

            local selectedFrame = Instance.new("Frame")
            selectedFrame.Name = "SelectedFrame"
            selectedFrame.Size = UDim2.fromOffset(dropdownWidth, dropdownHeight)
            selectedFrame.Position = UDim2.new(1, -10, 0.5, 0)
            selectedFrame.AnchorPoint = Vector2.new(1, 0.5)
            selectedFrame.BackgroundColor3 = theme.colorStroke
            selectedFrame.Parent = btnFrame
            local sfCorner = Instance.new("UICorner")
            sfCorner.CornerRadius = UDim.new(0, 4)
            sfCorner.Parent = selectedFrame

            local activeLabel = Instance.new("TextLabel")
            activeLabel.Name = "ActiveLabel"
            activeLabel.Size = UDim2.new(1, -20, 1, 0) -- Leave space for arrow
            activeLabel.Position = UDim2.new(0, 10, 0.5, 0)
            activeLabel.AnchorPoint = Vector2.new(0, 0.5)
            activeLabel.BackgroundTransparency = 1
            activeLabel.Font = Enum.Font.GothamBold
            activeLabel.TextColor3 = theme.colorText
            activeLabel.TextSize = 10
            activeLabel.Text = tostring(currentSelection)
            activeLabel.TextXAlignment = Enum.TextXAlignment.Left
            activeLabel.Parent = selectedFrame

            local arrow = Instance.new("ImageLabel")
            arrow.Name = "Arrow"
            arrow.Size = UDim2.fromOffset(15, 15)
            arrow.Position = UDim2.new(1, -5, 0.5, 0)
            arrow.AnchorPoint = Vector2.new(1, 0.5)
            arrow.BackgroundTransparency = 1
            arrow.Image = "rbxassetid://10709791523" -- Down arrow
            arrow.ImageColor3 = theme.colorText
            arrow.Parent = selectedFrame

            -- Dropdown List Frame (created on demand)
            local dropFrame = nil
            local scrollFrame = nil
            local optionButtons = {}

            local function closeDropdown()
                if not isOpen or not dropFrame then return end
                isOpen = false
                dropdownHolder.Visible = false
                TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0, ImageColor3 = theme.colorText}):Play()
                local tween = TweenService:Create(dropFrame, TweenInfo.new(0.2), {Size = UDim2.new(dropFrame.Size.X.Scale, dropFrame.Size.X.Offset, 0, 0)})
                tween.Completed:Connect(function() if dropFrame then dropFrame:Destroy() dropFrame = nil end end)
                tween:Play()
            end

            local function openDropdown()
                if isOpen then closeDropdown() return end
                isOpen = true

                -- Close any other open dropdowns
                for _, child in ipairs(dropdownHolder:GetChildren()) do
                    if child:IsA("Frame") and child.Name == "DropdownFrame" then child:Destroy() end
                end

                dropFrame = Instance.new("Frame")
                dropFrame.Name = "DropdownFrame"
                dropFrame.Size = UDim2.fromOffset(dropdownWidth, 0) -- Start height 0
                dropFrame.BackgroundColor3 = theme.colorHub1Mid -- Match theme
                dropFrame.BorderSizePixel = 1
                dropFrame.BorderColor3 = theme.colorStroke
                dropFrame.ClipsDescendants = true
                dropFrame.ZIndex = 51 -- Above holder background
                dropFrame.Parent = dropdownHolder
                local dfCorner = Instance.new("UICorner")
                dfCorner.CornerRadius = UDim.new(0, 4)
                dfCorner.Parent = dropFrame

                scrollFrame = Instance.new("ScrollingFrame")
                scrollFrame.Size = UDim2.new(1, 0, 1, 0)
                scrollFrame.BackgroundTransparency = 1
                scrollFrame.BorderSizePixel = 0
                scrollFrame.ScrollBarImageColor3 = theme.colorTheme
                scrollFrame.ScrollBarThickness = 4
                scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
                scrollFrame.CanvasSize = UDim2.new()
                scrollFrame.Parent = dropFrame
                local sfPadding = Instance.new("UIPadding")
                sfPadding.PaddingLeft = UDim.new(0, 5)
                sfPadding.PaddingRight = UDim.new(0, 5)
                sfPadding.PaddingTop = UDim.new(0, 5)
                sfPadding.PaddingBottom = UDim.new(0, 5)
                sfPadding.Parent = scrollFrame
                local sfLayout = Instance.new("UIListLayout")
                sfLayout.Padding = UDim.new(0, 2)
                sfLayout.SortOrder = Enum.SortOrder.LayoutOrder
                sfLayout.Parent = scrollFrame

                optionButtons = {}
                local totalHeight = 10 -- Padding top/bottom
                for i, optionName in ipairs(dOptions or {}) do
                    local optionBtn = Instance.new("TextButton")
                    optionBtn.Name = "Option"
                    optionBtn.Size = UDim2.new(1, 0, 0, 21)
                    optionBtn.BackgroundColor3 = theme.colorHub2
                    optionBtn.BackgroundTransparency = 1
                    optionBtn.BorderSizePixel = 0
                    optionBtn.AutoButtonColor = false
                    optionBtn.Text = ""
                    optionBtn.Parent = scrollFrame
                    local obCorner = Instance.new("UICorner")
                    obCorner.CornerRadius = UDim.new(0, 4)
                    obCorner.Parent = optionBtn

                    local obLabel = Instance.new("TextLabel")
                    obLabel.Size = UDim2.new(1, -10, 1, 0)
                    obLabel.Position = UDim2.new(0, 10, 0, 0)
                    obLabel.BackgroundTransparency = 1
                    obLabel.Font = Enum.Font.GothamBold
                    obLabel.TextColor3 = theme.colorText
                    obLabel.TextSize = 10
                    obLabel.Text = tostring(optionName)
                    obLabel.TextXAlignment = Enum.TextXAlignment.Left
                    obLabel.TextTransparency = (tostring(optionName) == tostring(currentSelection)) and 0 or 0.4
                    obLabel.Parent = optionBtn

                    optionBtn.MouseEnter:Connect(function() if tostring(optionName) ~= tostring(currentSelection) then TweenService:Create(optionBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.6}):Play() end end)
                    optionBtn.MouseLeave:Connect(function() TweenService:Create(optionBtn, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play() end)

                    optionBtn.MouseButton1Click:Connect(function()
                        currentSelection = optionName
                        activeLabel.Text = tostring(currentSelection)
                        closeDropdown()
                        if dCallback then task.spawn(dCallback, currentSelection) end
                        -- Update visual state of options
                        for _, otherBtnData in ipairs(optionButtons) do
                             local isSelected = (tostring(otherBtnData.name) == tostring(currentSelection))
                             TweenService:Create(otherBtnData.label, TweenInfo.new(0.2), {TextTransparency = isSelected and 0 or 0.4}):Play()
                        end
                    end)

                    table.insert(optionButtons, {button = optionBtn, label = obLabel, name = optionName})
                    totalHeight = totalHeight + 21 + sfLayout.Padding.Offset
                end
                totalHeight = totalHeight - sfLayout.Padding.Offset -- Remove last padding
                local maxHeight = 150 -- Limit max height
                local targetHeight = math.min(totalHeight, maxHeight)

                -- Position dropdown relative to selectedFrame
                local framePos = selectedFrame.AbsolutePosition
                local frameSize = selectedFrame.AbsoluteSize
                local screenHeight = screenGui.AbsoluteSize.Y
                local spaceBelow = screenHeight - (framePos.Y + frameSize.Y)
                local spaceAbove = framePos.Y

                if spaceBelow >= targetHeight or spaceBelow >= spaceAbove then -- Open downwards
                    dropFrame.Position = UDim2.fromOffset(framePos.X, framePos.Y + frameSize.Y)
                    dropFrame.AnchorPoint = Vector2.new(0, 0)
                else -- Open upwards
                    dropFrame.Position = UDim2.fromOffset(framePos.X, framePos.Y)
                    dropFrame.AnchorPoint = Vector2.new(0, 1)
                end

                dropdownHolder.Visible = true
                TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 180, ImageColor3 = theme.colorTheme}):Play() -- Rotate arrow up
                TweenService:Create(dropFrame, TweenInfo.new(0.2), {Size = UDim2.fromOffset(dropdownWidth, targetHeight)}):Play()
            end

            btnFrame.MouseButton1Click:Connect(openDropdown)

            -- Close dropdown if clicked outside
            dropdownHolder.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if not dropFrame or not input.GuiObject or not input.GuiObject:IsDescendantOf(dropFrame) then
                        closeDropdown()
                    end
                end
            end)
            dropdownHolder.Active = true -- Enable InputBegan

            function baseApi:Set(newOptionsOrSelection)
                 if type(newOptionsOrSelection) == "table" then
                      dOptions = newOptionsOrSelection
                      -- If current selection is no longer valid, reset
                      local found = false
                      for _, opt in ipairs(dOptions) do if tostring(opt) == tostring(currentSelection) then found = true break end end
                      if not found and #dOptions > 0 then
                           currentSelection = dOptions[1]
                           activeLabel.Text = tostring(currentSelection)
                           if dCallback then task.spawn(dCallback, currentSelection) end
                      elseif #dOptions == 0 then
                           currentSelection = "..."
                           activeLabel.Text = "..."
                      end
                      if isOpen then openDropdown() end -- Re-render if open
                 elseif newOptionsOrSelection ~= nil then
                      local found = false
                      for _, opt in ipairs(dOptions) do if tostring(opt) == tostring(newOptionsOrSelection) then found = true break end end
                      if found and tostring(newOptionsOrSelection) ~= tostring(currentSelection) then
                           currentSelection = newOptionsOrSelection
                           activeLabel.Text = tostring(currentSelection)
                           if dCallback then task.spawn(dCallback, currentSelection) end
                           if isOpen then -- Update visuals if open
                                for _, otherBtnData in ipairs(optionButtons) do
                                     local isSelected = (tostring(otherBtnData.name) == tostring(currentSelection))
                                     TweenService:Create(otherBtnData.label, TweenInfo.new(0.2), {TextTransparency = isSelected and 0 or 0.4}):Play()
                                end
                           end
                      end
                 end
            end
            function baseApi:GetValue() return currentSelection end

            return baseApi
        end

        function tabApi:AddSlider(sName, sDesc, sMin, sMax, sStep, sDefault, sCallback)
            local sliderWidth = 150
            local sliderHeight = 18
            local knobWidth = 6
            local knobHeight = 12
            local barHeight = 6

            local minVal = sMin or 0
            local maxVal = sMax or 100
            local step = sStep or 1
            local currentValue = math.clamp(sDefault or minVal, minVal, maxVal)

            local btnFrame, baseApi = createButtonFrameBase(optionFrame, sName, sDesc, sliderWidth + 10)
            baseApi._currentValue = currentValue -- Store value internally for GetValue

            local sliderHolder = Instance.new("Frame")
            sliderHolder.Name = "SliderHolder"
            sliderHolder.Size = UDim2.fromOffset(sliderWidth, sliderHeight)
            sliderHolder.Position = UDim2.new(1, -10, 0.5, 0)
            sliderHolder.AnchorPoint = Vector2.new(1, 0.5)
            sliderHolder.BackgroundTransparency = 1
            sliderHolder.Parent = btnFrame

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Name = "ValueLabel"
            valueLabel.Size = UDim2.new(0, 30, 1, 0) -- Fixed width for value
            valueLabel.Position = UDim2.new(1, 0, 0.5, 0)
            valueLabel.AnchorPoint = Vector2.new(1, 0.5)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.TextColor3 = theme.colorText
            valueLabel.TextSize = 10
            valueLabel.Text = string.format("%.2f", currentValue):gsub("%.?0*$", "") -- Format nicely
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Parent = sliderHolder

            local sliderBar = Instance.new("Frame")
            sliderBar.Name = "SliderBar"
            sliderBar.Size = UDim2.new(1, -35, 0, barHeight) -- Width adjusted for value label
            sliderBar.Position = UDim2.new(0, 0, 0.5, 0)
            sliderBar.AnchorPoint = Vector2.new(0, 0.5)
            sliderBar.BackgroundColor3 = theme.colorStroke
            sliderBar.Parent = sliderHolder
            local sbCorner = Instance.new("UICorner")
            sbCorner.CornerRadius = UDim.new(0.5, 0)
            sbCorner.Parent = sliderBar

            local indicator = Instance.new("Frame")
            indicator.Name = "Indicator"
            indicator.Size = UDim2.fromScale(0, 1) -- Initial size based on value
            indicator.BackgroundColor3 = theme.colorTheme
            indicator.BorderSizePixel = 0
            indicator.Parent = sliderBar
            local indCorner = Instance.new("UICorner")
            indCorner.CornerRadius = UDim.new(0.5, 0)
            indCorner.Parent = indicator

            local knob = Instance.new("Frame")
            knob.Name = "SliderKnob"
            knob.Size = UDim2.fromOffset(knobWidth, knobHeight)
            knob.Position = UDim2.fromScale(0, 0.5) -- Initial position based on value
            knob.AnchorPoint = Vector2.new(0.5, 0.5)
            knob.BackgroundColor3 = theme.colorText -- White knob like original
            knob.BorderSizePixel = 0
            knob.ZIndex = 2
            knob.Parent = sliderBar
            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(0.3, 0) -- Slightly rounded rect
            knobCorner.Parent = knob

            local function updateSliderVisuals(value, animate)
                 local percentage = (value - minVal) / (maxVal - minVal)
                 percentage = math.clamp(percentage, 0, 1)
                 local targetPos = UDim2.fromScale(percentage, 0.5)
                 local targetSize = UDim2.fromScale(percentage, 1)
                 local tweenInfo = TweenInfo.new(animate and 0.15 or 0)

                 TweenService:Create(knob, tweenInfo, {Position = targetPos}):Play()
                 TweenService:Create(indicator, tweenInfo, {Size = targetSize}):Play()
                 valueLabel.Text = string.format("%.2f", value):gsub("%.?0*$", "")
            end

            updateSliderVisuals(currentValue, false) -- Set initial state

            -- Input handling for slider bar click/drag
            local sliderInputButton = Instance.new("TextButton") -- Invisible button over bar for input
            sliderInputButton.Name = "SliderInput"
            sliderInputButton.Size = UDim2.new(1, 0, 1.5, 0) -- Slightly larger vertically for easier clicking
            sliderInputButton.Position = UDim2.new(0.5, 0, 0.5, 0)
            sliderInputButton.AnchorPoint = Vector2.new(0.5, 0.5)
            sliderInputButton.BackgroundTransparency = 1
            sliderInputButton.Text = ""
            sliderInputButton.ZIndex = 3 -- Above knob
            sliderInputButton.Parent = sliderBar

            sliderInputButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    activeSliderInfo = {
                        sliderBar = sliderBar, knob = knob, indicator = indicator, valueLabel = valueLabel,
                        minVal = minVal, maxVal = maxVal, step = step, callback = sCallback, api = baseApi
                    }
                    -- Immediately update position on click
                    local relativeX = input.Position.X - sliderBar.AbsolutePosition.X
                    local percentage = math.clamp(relativeX / sliderBar.AbsoluteSize.X, 0, 1)
                    local rawValue = minVal + percentage * (maxVal - minVal)
                    local steppedValue = math.floor(rawValue / step + 0.5) * step
                    steppedValue = math.clamp(steppedValue, minVal, maxVal)
                    if steppedValue ~= baseApi:GetValue() then
                         baseApi._currentValue = steppedValue
                         updateSliderVisuals(steppedValue, true)
                         if sCallback then task.spawn(sCallback, steppedValue) end
                    else
                         updateSliderVisuals(steppedValue, true) -- Still animate visuals
                    end

                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            sliding = false
                            activeSliderInfo = nil
                        end
                    end)
                end
            end)

            function baseApi:Set(newValue)
                 if type(newValue) == "number" then
                      local clampedValue = math.clamp(newValue, minVal, maxVal)
                      -- Snap to step (optional, but good practice)
                      local steppedValue = math.floor(clampedValue / step + 0.5) * step
                      steppedValue = math.clamp(steppedValue, minVal, maxVal)
                      if steppedValue ~= baseApi:GetValue() then
                           baseApi._currentValue = steppedValue
                           updateSliderVisuals(steppedValue, true)
                           if sCallback then task.spawn(sCallback, steppedValue) end
                      end
                 end
            end
            function baseApi:GetValue() return baseApi._currentValue end

            return baseApi
        end

        function tabApi:AddTextbox(...) warn("Textbox not implemented yet.") end
        function tabApi:AddKeybind(...) warn("Keybind not implemented yet.") end
        function tabApi:AddParagraph(...) warn("Paragraph not implemented yet.") end
        function tabApi:AddSection(...) warn("Section not implemented yet.") end

        return tabApi
    end

    -- Function to show Dialog
    local function showDialog(dTitle, dText, dOptions)
        if mainWindow:FindFirstChild("DialogOverlay") then return end
        local overlay = Instance.new("Frame")
        overlay.Name = "DialogOverlay"
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.BackgroundColor3 = Color3.fromRGB(0,0,0) -- Darker overlay
        overlay.BackgroundTransparency = 1
        overlay.ZIndex = 100
        overlay.Parent = mainWindow
        local dialogFrame = Instance.new("Frame")
        dialogFrame.Name = "DialogFrame"
        dialogFrame.Size = UDim2.fromOffset(250 * 1.08, 150 * 1.08)
        dialogFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        dialogFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        dialogFrame.BackgroundTransparency = 1
        dialogFrame.ClipsDescendants = true
        dialogFrame.Parent = overlay
        local dGradient = Instance.new("UIGradient")
        dGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0.00, theme.colorHub1Start), ColorSequenceKeypoint.new(0.50, theme.colorHub1Mid), ColorSequenceKeypoint.new(1.00, theme.colorHub1End)})
        dGradient.Rotation = 270
        dGradient.Parent = dialogFrame
        local dCorner = Instance.new("UICorner")
        dCorner.CornerRadius = UDim.new(0, 7)
        dCorner.Parent = dialogFrame
        local dStroke = Instance.new("UIStroke")
        dStroke.Color = theme.colorStroke
        dStroke.Thickness = 1
        dStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        dStroke.Parent = dialogFrame
        local dTitleLabel = Instance.new("TextLabel")
        dTitleLabel.Size = UDim2.new(1, -30, 0, 20)
        dTitleLabel.Position = UDim2.new(0, 15, 0, 5)
        dTitleLabel.BackgroundTransparency = 1
        dTitleLabel.Font = Enum.Font.GothamBold
        dTitleLabel.Text = dTitle or "Dialog"
        dTitleLabel.TextColor3 = theme.colorText
        dTitleLabel.TextSize = 15
        dTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        dTitleLabel.Parent = dialogFrame
        local dTextLabel = Instance.new("TextLabel")
        dTextLabel.Size = UDim2.new(1, -30, 0, 0)
        dTextLabel.AutomaticSize = Enum.AutomaticSize.Y
        dTextLabel.Position = UDim2.new(0, 15, 0, 25)
        dTextLabel.BackgroundTransparency = 1
        dTextLabel.Font = Enum.Font.GothamMedium
        dTextLabel.Text = dText or ""
        dTextLabel.TextColor3 = theme.colorDarkText
        dTextLabel.TextSize = 12
        dTextLabel.TextWrapped = true
        dTextLabel.TextXAlignment = Enum.TextXAlignment.Left
        dTextLabel.Parent = dialogFrame
        local buttonHolder = Instance.new("Frame")
        buttonHolder.Size = UDim2.new(1, -20, 0, 32)
        buttonHolder.Position = UDim2.new(0.5, 0, 1, -10)
        buttonHolder.AnchorPoint = Vector2.new(0.5, 1)
        buttonHolder.BackgroundTransparency = 1
        buttonHolder.Parent = dialogFrame
        local buttonLayout = Instance.new("UIListLayout")
        buttonLayout.FillDirection = Enum.FillDirection.Horizontal
        buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
        buttonLayout.Padding = UDim.new(0, 10)
        buttonLayout.Parent = buttonHolder
        local function closeDialog()
            local closeTweenInfo = TweenInfo.new(0.15)
            TweenService:Create(overlay, closeTweenInfo, {BackgroundTransparency = 1}):Play()
            TweenService:Create(dialogFrame, closeTweenInfo, {Size = UDim2.fromOffset(250 * 1.08, 150 * 1.08), Transparency = 1}):Play()
            task.wait(0.15); overlay:Destroy()
        end
        local numOptions = #dOptions
        for i, optionData in ipairs(dOptions) do
            local btnText = optionData[1]; local btnCallback = optionData[2]
            local dialogButton = Instance.new("TextButton")
            local btnWidth = (buttonHolder.AbsoluteSize.X - (numOptions - 1) * buttonLayout.Padding.Offset) / numOptions
            dialogButton.Size = UDim2.fromOffset(btnWidth, 32)
            dialogButton.BackgroundColor3 = theme.colorHub2
            dialogButton.BorderSizePixel = 1
            dialogButton.BorderColor3 = theme.colorStroke
            dialogButton.TextColor3 = theme.colorText
            dialogButton.Font = Enum.Font.GothamBold
            dialogButton.TextSize = 12
            dialogButton.Text = btnText
            dialogButton.Parent = buttonHolder
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = dialogButton
            dialogButton.MouseButton1Click:Connect(function() closeDialog(); if btnCallback then task.spawn(btnCallback) end end)
        end
        local openTweenInfo = TweenInfo.new(0.2)
        TweenService:Create(overlay, openTweenInfo, {BackgroundTransparency = 0.6}):Play()
        TweenService:Create(dialogFrame, openTweenInfo, {Size = UDim2.fromOffset(250, 150), Transparency = 0}):Play()
    end

    -- Minimize/Restore Logic
    local minimizeTweenInfo = TweenInfo.new(0.25)
    minimizeButton.MouseButton1Click:Connect(function()
        if minimized then
            minimizeButton.Image = "rbxassetid://10734896206"
            mainWindow.ClipsDescendants = true
            windowResizeHandle.Visible = true
            tabResizeHandle.Visible = true
            TweenService:Create(mainWindow, minimizeTweenInfo, {Size = savedSize}):Play()
            minimized = false
        else
            minimizeButton.Image = "rbxassetid://10734924532"
            savedSize = mainWindow.Size
            mainWindow.ClipsDescendants = false
            windowResizeHandle.Visible = false
            tabResizeHandle.Visible = false
            TweenService:Create(mainWindow, minimizeTweenInfo, {Size = UDim2.new(savedSize.X.Scale, savedSize.X.Offset, 0, minimizedHeight)}):Play()
            minimized = true
        end
    end)

    -- Close Button Logic
    closeButton.MouseButton1Click:Connect(function()
        showDialog("Close Script?", "Do you really want to close this UI?", {
            {"Confirm", function() screenGui:Destroy() end},
            {"Cancel"}
        })
    end)

    -- Add Example Tabs & Elements
    local mainTabApi = addTab("Main", "rbxassetid://10747384394")
    local combatTabApi = addTab("Combat", "rbxassetid://10709791437")
    local farmingTabApi = addTab("Farming", "rbxassetid://6034390919")
    local miscTabApi = addTab("Misc", "rbxassetid://6034417256")
    local settingsTabApi = addTab("Settings", "rbxassetid://6034416869")

    -- Add example elements
    local exampleButton = mainTabApi:AddButton("Show Dialog", "Click to show an example dialog", function()
        showDialog("Example Dialog", "This is a test dialog box.", {{"OK"}, {"Cancel"}})
    end)

    local exampleToggle = mainTabApi:AddToggle("Enable Feature", "Toggles an example feature on/off", false, function(newState)
        print("Example Feature Toggled:", newState)
        exampleButton:SetDesc(newState and "Feature is ON" or "Feature is OFF")
    end)

    local exampleDropdown = combatTabApi:AddDropdown("Select Weapon", "Choose your primary weapon", {"Sword", "Gun", "Melee", "Fruit"}, "Sword", function(selectedWeapon)
        print("Selected Weapon:", selectedWeapon)
    end)

    local exampleSlider = farmingTabApi:AddSlider("Farm Speed", "Adjust the farming speed", 0, 100, 5, 50, function(speed)
        print("Farm Speed Set To:", speed)
    end)

    settingsTabApi:AddButton("Destroy UI", "Close the UI immediately", function()
         screenGui:Destroy()
    end)

    -- Select the first tab by default
    task.wait(0.1)
    local firstTabButton = tabScrollArea:FindFirstChild(mainTabApi.Name .. "_Tab")
    if firstTabButton and firstTabButton.MouseButton1Click then
        firstTabButton.MouseButton1Click:Fire()
    end

    print("Blox Fruits Redz Style UI Initialized Successfully! (v1.3)")

end)

-- Print error if initialization failed
if not success then
    warn("Blox Fruits UI Error:", err)
end




    -- Game Interaction Logic (Placeholder - Needs Blox Fruits specific implementation)
    local autoFarmEnabled = false
    local currentFarmTarget = nil

    local function findNearestMob(mobName)
        -- Placeholder: Find the nearest NPC with the given name
        local playerPos = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        if not playerPos then return nil end

        local nearestDist = math.huge
        local nearestMob = nil
        for _, v in pairs(game.Workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name == mobName and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                local dist = (v.HumanoidRootPart.Position - playerPos).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearestMob = v
                end
            end
        end
        return nearestMob
    end

    local function attackTarget(target)
        -- Placeholder: Move to and attack the target
        if not target or not target:FindFirstChild("Humanoid") or target.Humanoid.Health <= 0 then return end
        local playerChar = game.Players.LocalPlayer.Character
        local humanoid = playerChar and playerChar:FindFirstChildOfClass("Humanoid")
        local rootPart = playerChar and playerChar:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then return end

        -- Simple move and attack logic (needs refinement for actual game)
        humanoid:MoveTo(target.HumanoidRootPart.Position)
        -- Add attack logic here (e.g., using remote events or tool activation)
        print("Attacking: " .. target.Name)
        wait(0.5) -- Placeholder delay
    end

    local function autoFarmLoop()
        while autoFarmEnabled and task.wait(1) do
            -- Placeholder logic: Find and attack a specific mob (e.g., "Bandit")
            -- Needs logic for quest handling, finding correct mobs based on level, etc.
            local mobName = "Bandit" -- Example mob name, needs to be dynamic
            currentFarmTarget = findNearestMob(mobName)
            if currentFarmTarget then
                attackTarget(currentFarmTarget)
            else
                print("No target found: " .. mobName)
                -- Add logic to move to farming area or find quest giver
            end
        end
    end

    -- UI Creation
    local tabs = {}
    local function createTabsAndOptions()
        -- Create Main Tab
        local mainTab = addTab("Main", "rbxassetid://10709791437") -- Using an arrow icon for now
        tabs[mainTab.Name] = mainTab

        -- Add Auto Farm Level Toggle
        mainTab:AddToggle("Auto Farm Level", "Automatically farms levels.", false, function(state)
            autoFarmEnabled = state
            print("Auto Farm Level: " .. tostring(state))
            if autoFarmEnabled then
                task.spawn(autoFarmLoop) -- Start the loop in a new thread
            else
                -- Stop the loop (autoFarmEnabled flag will handle this)
                currentFarmTarget = nil
            end
        end)

        -- Select Main Tab by default
        selectTab(mainTab)
    end





    -- Additional Feature Logic (Placeholders)
    local autoClickEnabled = false
    local killAuraEnabled = false
    local autoStatsEnabled = false
    local espPlayersEnabled = false
    local espFruitsEnabled = false
    local espChestsEnabled = false

    local function autoClickLoop()
        while autoClickEnabled and task.wait(0.1) do -- Adjust delay as needed
            -- Placeholder: Simulate mouse click
            -- Needs specific implementation using mouse_event or similar
            print("Auto Clicking...")
            -- Example: game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
            -- wait(0.05)
            -- game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
    end

    local function killAuraLoop()
        while killAuraEnabled and task.wait(0.5) do
            -- Placeholder: Find and attack nearby hostile players/NPCs
            local playerChar = game.Players.LocalPlayer.Character
            local rootPart = playerChar and playerChar:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end

            local killRadius = 50 -- Example radius

            for _, targetPlayer in pairs(game.Players:GetPlayers()) do
                if targetPlayer ~= game.Players.LocalPlayer then
                    local targetChar = targetPlayer.Character
                    local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                    local targetHumanoid = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
                    if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                        if (targetRoot.Position - rootPart.Position).Magnitude <= killRadius then
                            print("Kill Aura attacking Player: " .. targetPlayer.Name)
                            -- Add attack logic here (similar to autoFarm)
                            -- attackTarget(targetChar) -- Reuse or adapt attack logic
                        end
                    end
                end
            end
            -- Add logic for NPCs if needed
        end
    end

    local function autoStats(statName)
        -- Placeholder: Automatically assign stat points
        print("Auto Assigning Stat: " .. statName)
        -- Needs logic to interact with the game's stat allocation UI or functions
    end

    local function teleportToFruit()
        -- Placeholder: Find the nearest spawned fruit and teleport
        print("Teleporting to nearest fruit...")
        local nearestFruit = nil
        local nearestDist = math.huge
        local playerPos = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        if not playerPos then return end

        -- Iterate through workspace items that might be fruits (names vary)
        for _, item in pairs(game.Workspace:GetDescendants()) do
             -- Add specific fruit detection logic here (e.g., by name, class, properties)
             if item.Name == "Blox Fruit" then -- Example name
                 local dist = (item.Position - playerPos).Magnitude
                 if dist < nearestDist then
                     nearestDist = dist
                     nearestFruit = item
                 end
             end
        end

        if nearestFruit then
            print("Found fruit: " .. nearestFruit.Name .. " at " .. tostring(nearestFruit.Position))
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = nearestFruit.CFrame + Vector3.new(0, 5, 0) -- Teleport above
        else
            print("No fruit found.")
        end
    end

    -- ESP Drawing Logic (Placeholder - Requires Drawing library)
    -- local Drawing = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Drawing/main/Source.lua'))()

    local function drawEspText(text, position, color)
        -- Placeholder using BillboardGui (simple example)
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPDraw"
        billboard.Size = UDim2.fromOffset(100, 20)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Adornee = game.Workspace -- Temporary, should be attached to target part
        billboard.AlwaysOnTop = true

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = color or Color3.new(1, 1, 1)
        label.Font = Enum.Font.SourceSans
        label.TextSize = 14
        label.Parent = billboard

        -- Need to parent billboard to the actual target part and manage cleanup
        -- Example: billboard.Adornee = targetPart
        -- game:GetService("Debris"):AddItem(billboard, 0.1) -- Auto cleanup
        print("ESP Draw (Placeholder): " .. text .. " at " .. tostring(position))
    end

    local function espLoop()
        while espPlayersEnabled or espFruitsEnabled or espChestsEnabled do
            -- Clear previous ESP drawings (important!)
            -- Example: for _, v in pairs(game.Workspace:GetDescendants()) do if v.Name == "ESPDraw" then v:Destroy() end end

            if espPlayersEnabled then
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local pos = player.Character.HumanoidRootPart.Position
                        local name = player.Name
                        local health = player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health or "?"
                        drawEspText(name .. " [" .. tostring(math.floor(health)) .. "]", pos, Color3.new(1, 0, 0))
                    end
                end
            end

            if espFruitsEnabled then
                -- Add fruit finding logic (similar to teleportToFruit)
                -- Draw ESP for found fruits
                 for _, item in pairs(game.Workspace:GetDescendants()) do
                     if item.Name == "Blox Fruit" then -- Example name
                         drawEspText("Fruit", item.Position, Color3.new(0, 1, 0))
                     end
                 end
            end

            if espChestsEnabled then
                -- Add chest finding logic (e.g., by name or properties)
                -- Draw ESP for found chests
                 for _, item in pairs(game.Workspace:GetDescendants()) do
                     if item.Name == "Treasure Chest" then -- Example name
                         drawEspText("Chest", item.Position, Color3.new(1, 1, 0))
                     end
                 end
            end

            task.wait(0.1) -- ESP update rate
        end
        -- Clear ESP drawings when loop stops
        -- Example: for _, v in pairs(game.Workspace:GetDescendants()) do if v.Name == "ESPDraw" then v:Destroy() end end
    end

    -- Modify UI Creation to include new options
    local tabs = {}
    local function createTabsAndOptions()
        -- Create Main Tab
        local mainTab = addTab("Main", "rbxassetid://10709791437") -- Using an arrow icon for now
        tabs[mainTab.Name] = mainTab

        -- Add Auto Farm Level Toggle
        mainTab:AddToggle("Auto Farm Level", "Automatically farms levels.", false, function(state)
            autoFarmEnabled = state
            print("Auto Farm Level: " .. tostring(state))
            if autoFarmEnabled then
                task.spawn(autoFarmLoop) -- Start the loop in a new thread
            else
                currentFarmTarget = nil
            end
        end)

        -- Add Auto Click Toggle
        mainTab:AddToggle("Auto Click", "Automatically clicks.", false, function(state)
            autoClickEnabled = state
            print("Auto Click: " .. tostring(state))
            if autoClickEnabled then
                task.spawn(autoClickLoop)
            end
        end)

        -- Add Kill Aura Toggle
        mainTab:AddToggle("Kill Aura", "Automatically attacks nearby hostiles.", false, function(state)
            killAuraEnabled = state
            print("Kill Aura: " .. tostring(state))
            if killAuraEnabled then
                task.spawn(killAuraLoop)
            end
        end)

        -- Add Auto Stats Dropdown
        local statsOptions = {"Melee", "Defense", "Sword", "Gun", "Blox Fruit"}
        mainTab:AddDropdown("Auto Stats", "Automatically assign stats.", statsOptions, statsOptions[1], function(selectedStat)
            -- Note: This dropdown just selects the stat. A separate toggle/button might be needed to enable/disable the auto-assigning process.
            print("Selected Auto Stat: " .. selectedStat)
            -- autoStats(selectedStat) -- Call this when the auto-assign process is active
        end)
        -- Add a toggle for enabling Auto Stats
        mainTab:AddToggle("Enable Auto Stats", "Enable automatic stat assignment.", false, function(state)
             autoStatsEnabled = state
             print("Auto Stats Enabled: " .. tostring(state))
             -- Add logic here to start/stop the auto-stat assignment based on the selected stat from the dropdown
             if autoStatsEnabled then
                 -- Get selected stat from dropdown and start process
                 -- local selectedStat = ... -- Need a way to get the current dropdown value
                 -- task.spawn(function() while autoStatsEnabled do autoStats(selectedStat) task.wait(5) end end)
             end
        end)

        -- Create Teleport Tab
        local teleportTab = addTab("Teleport", "rbxassetid://10709791523") -- Placeholder icon
        tabs[teleportTab.Name] = teleportTab

        -- Add Teleport to Fruit Button
        teleportTab:AddButton("Teleport to Fruit", "Teleports to the nearest fruit.", function()
            teleportToFruit()
        end)
        -- Add other teleport options here (e.g., islands, players)

        -- Create ESP Tab
        local espTab = addTab("ESP", "rbxassetid://10734896206") -- Placeholder icon
        tabs[espTab.Name] = espTab

        local function updateEspLoopState()
            if espPlayersEnabled or espFruitsEnabled or espChestsEnabled then
                -- Check if loop is already running
                -- If not, spawn espLoop
                task.spawn(espLoop)
            end
            -- The loop itself checks the boolean flags
        end

        -- Add ESP Toggles
        espTab:AddToggle("ESP Players", "Show player information.", false, function(state)
            espPlayersEnabled = state
            print("ESP Players: " .. tostring(state))
            updateEspLoopState()
        end)
        espTab:AddToggle("ESP Fruits", "Show fruit locations.", false, function(state)
            espFruitsEnabled = state
            print("ESP Fruits: " .. tostring(state))
            updateEspLoopState()
        end)
        espTab:AddToggle("ESP Chests", "Show chest locations.", false, function(state)
            espChestsEnabled = state
            print("ESP Chests: " .. tostring(state))
            updateEspLoopState()
        end)

        -- Select Main Tab by default
        selectTab(mainTab)
    end


