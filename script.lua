--[[
    Advanced Admin GUI
    Features: Speed Control, Fly, Invisibility, and more!
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Variables
local flying = false
local flySpeed = 50
local bodyVelocity = nil
local originalSpeed = 16
local originalWalkSpeed = 16
local invisible = false
local noclipEnabled = false

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoolAdminGUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 600)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Corner rounding
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "🔧 ADMIN PANEL"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0, 15, 0, 0)
title.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.BackgroundTransparency = 0.5
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 40, 0, 40)
minimizeBtn.Position = UDim2.new(1, -90, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimizeBtn.BackgroundTransparency = 0.5
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 25
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimizeBtn

local minimized = false
local originalSize = mainFrame.Size

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame:TweenSize(UDim2.new(0, 450, 0, 50), "Out", "Quad", 0.3, true)
    else
        mainFrame:TweenSize(originalSize, "Out", "Quad", 0.3, true)
    end
end)

-- Content Container
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, 0, 1, -50)
content.Position = UDim2.new(0, 0, 0, 50)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.ScrollBarThickness = 8
content.Parent = mainFrame

-- Function to create category sections
local function createCategory(title)
    local category = Instance.new("Frame")
    category.Size = UDim2.new(1, -20, 0, 80)
    category.Position = UDim2.new(0, 10, 0, 0)
    category.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    category.BackgroundTransparency = 0.3
    category.BorderSizePixel = 0
    category.Parent = content
    
    local catCorner = Instance.new("UICorner")
    catCorner.CornerRadius = UDim.new(0, 8)
    catCorner.Parent = category
    
    local catTitle = Instance.new("TextLabel")
    catTitle.Size = UDim2.new(1, 0, 0, 30)
    catTitle.Position = UDim2.new(0, 10, 0, 5)
    catTitle.BackgroundTransparency = 1
    catTitle.Text = title
    catTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    catTitle.TextSize = 18
    catTitle.Font = Enum.Font.GothamSemibold
    catTitle.TextXAlignment = Enum.TextXAlignment.Left
    catTitle.Parent = category
    
    return category, catTitle
end

-- Function to create buttons
local function createButton(parent, text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(85, 85, 95)}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65, 65, 75)}):Play()
    end)
    
    return btn
end

-- Function to create toggle buttons
local function createToggle(parent, text, yPos, callback)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 120, 0, 35)
    toggleBtn.Position = UDim2.new(0, 10, 0, yPos)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    toggleBtn.Text = text .. " ❌"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 14
    toggleBtn.Font = Enum.Font.Gotham
    toggleBtn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = toggleBtn
    
    local state = false
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = text .. (state and " ✅" or " ❌")
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(70, 120, 70) or Color3.fromRGB(65, 65, 75)
        callback(state)
    end)
    
    return toggleBtn, function() return state end
end

-- Function to create sliders
local function createSlider(parent, text, min, max, default, yPos, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0, 200, 0, 50)
    sliderFrame.Position = UDim2.new(0, 10, 0, yPos)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0, 4)
    slider.Position = UDim2.new(0, 0, 0, 25)
    slider.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    slider.BorderSizePixel = 0
    slider.Parent = sliderFrame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 20, 0, 20)
    sliderBtn.Position = UDim2.new((default - min) / (max - min), -10, 0, -8)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = sliderBtn
    
    local dragging = false
    local value = default
    
    sliderBtn.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    sliderBtn.MouseMove:Connect(function()
        if dragging then
            local mousePos = UserInputService:GetMouseLocation().X
            local framePos = sliderFrame.AbsolutePosition.X
            local frameWidth = sliderFrame.AbsoluteSize.X
            local percent = math.clamp((mousePos - framePos) / frameWidth, 0, 1)
            value = min + (max - min) * percent
            value = math.floor(value)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            sliderBtn.Position = UDim2.new(percent, -10, 0, -8)
            label.Text = text .. ": " .. value
            callback(value)
        end
    end)
    
    return sliderFrame, function() return value end
end

-- Calculate content height
local currentY = 10

-- Movement Category
local movementCat, _ = createCategory("🏃 MOVEMENT")
movementCat.Size = UDim2.new(1, -20, 0, 180)
movementCat.Position = UDim2.new(0, 10, 0, currentY)
currentY = currentY + 190

-- Speed Slider
local speedSlider, getSpeed = createSlider(movementCat, "Walk Speed", 16, 100, 16, 40, function(value)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

-- Fly Toggle
local flyToggle, isFlying = createToggle(movementCat, "Fly Mode", 100, function(state)
    flying = state
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if flying then
        originalWalkSpeed = humanoid.WalkSpeed
        humanoid.WalkSpeed = flySpeed
        humanoid.PlatformStand = true
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = character:FindFirstChild("HumanoidRootPart")
        
        -- Fly movement
        RunService:BindToRenderStep("FlyMovement", 0, function()
            if not flying or not character or not character.Parent then
                RunService:UnbindFromRenderStep("FlyMovement")
                return
            end
            
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not rootPart or not bodyVelocity then return end
            
            local moveDirection = Vector3.new(0, 0, 0)
            local camera = workspace.CurrentCamera
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end
            
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit
            end
            
            bodyVelocity.Velocity = moveDirection * flySpeed
        end)
    else
        humanoid.WalkSpeed = originalWalkSpeed
        humanoid.PlatformStand = false
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        RunService:UnbindFromRenderStep("FlyMovement")
    end
end)

-- Combat Category
local combatCat, _ = createCategory("⚔️ COMBAT")
combatCat.Size = UDim2.new(1, -20, 0, 130)
combatCat.Position = UDim2.new(0, 10, 0, currentY)
currentY = currentY + 140

-- Invisibility Toggle
local invisToggle, isInvisible = createToggle(combatCat, "Invisible", 40, function(state)
    invisible = state
    local character = LocalPlayer.Character
    if not character then return end
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = state and 1 or 0
        end
    end
    
    if state then
        -- Make character invisible to others
        local char = LocalPlayer.Character
        if char then
            char:FindFirstChild("Head").Transparency = 1
        end
    end
end)

-- NoClip Toggle
local noclipToggle, isNoclip = createToggle(combatCat, "NoClip", 85, function(state)
    noclipEnabled = state
    
    RunService:BindToRenderStep("NoClip", 100, function()
        if not noclipEnabled then
            RunService:UnbindFromRenderStep("NoClip")
            return
        end
        
        local character = LocalPlayer.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not noclipEnabled
                end
            end
        end
    end)
end)

-- Visuals Category
local visualsCat, _ = createCategory("👁️ VISUALS")
visualsCat.Size = UDim2.new(1, -20, 0, 130)
visualsCat.Position = UDim2.new(0, 10, 0, currentY)
currentY = currentY + 140

-- ESP Toggle (Simple)
local espToggle, isESP = createToggle(visualsCat, "ESP", 40, function(state)
    if state then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESP_Highlight"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = player.Character or player.CharacterAdded:Wait()
                
                player.CharacterAdded:Connect(function(character)
                    if espToggle.Text:find("✅") then
                        local newHighlight = Instance.new("Highlight")
                        newHighlight.Name = "ESP_Highlight"
                        newHighlight.FillColor = Color3.fromRGB(255, 0, 0)
                        newHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        newHighlight.Parent = character
                    end
                end)
            end
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                local highlight = player.Character:FindFirstChild("ESP_Highlight")
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

-- Fullbright Toggle
local fullbrightToggle = createToggle(visualsCat, "Fullbright", 85, function(state)
    local lighting = game:GetService("Lighting")
    if state then
        lighting.Brightness = 2
        lighting.ClockTime = 12
        lighting.FogEnd = 100000
        lighting.GlobalShadows = false
    else
        lighting.Brightness = 1
        lighting.GlobalShadows = true
    end
end)

-- Utility Category
local utilityCat, _ = createCategory("🔧 UTILITY")
utilityCat.Size = UDim2.new(1, -20, 0, 180)
utilityCat.Position = UDim2.new(0, 10, 0, currentY)
currentY = currentY + 190

-- Heal Button
createButton(utilityCat, "💚 Heal", 40, function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.Health = character.Humanoid.MaxHealth
    end
end)

-- Teleport to Mouse
createButton(utilityCat, "📍 Teleport", 85, function()
    local mouse = LocalPlayer:GetMouse()
    local target = mouse.Hit
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = target
    end
end)

-- Infinite Jump Toggle
local jumpToggle, isJumping = createToggle(utilityCat, "Infinite Jump", 130, function(state)
    if state then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            
            local jumpConnection
            jumpConnection = UserInputService.JumpRequest:Connect(function()
                if state and character and character:FindFirstChild("Humanoid") then
                    character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            
            -- Store connection for cleanup
            if not _G.jumpConnections then _G.jumpConnections = {} end
            _G.jumpConnections[LocalPlayer] = jumpConnection
        end
    else
        if _G.jumpConnections and _G.jumpConnections[LocalPlayer] then
            _G.jumpConnections[LocalPlayer]:Disconnect()
            _G.jumpConnections[LocalPlayer] = nil
        end
    end
end)

-- Update canvas size
content.CanvasSize = UDim2.new(0, 0, 0, currentY + 20)

-- Drag functionality
local dragging = false
local dragStartPos
local dragStartMouse

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = mainFrame.Position
        dragStartMouse = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartMouse
        mainFrame.Position = UDim2.new(dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X, 
                                        dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Character respawn handling
LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(1)
    if getSpeed and getSpeed() then
        character.Humanoid.WalkSpeed = getSpeed()
    end
    
    if isFlying and isFlying() then
        flying = true
        flyToggle.MouseButton1Click:Fire()
    end
    
    if isInvisible and isInvisible() then
        invisible = true
        invisToggle.MouseButton1Click:Fire()
    end
    
    if isNoclip and isNoclip() then
        noclipEnabled = true
        noclipToggle.MouseButton1Click:Fire()
    end
end)

print("GUI Loaded Successfully! Press 'F' to toggle visibility")
