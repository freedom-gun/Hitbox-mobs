_G.HeadSize = 30
_G.Transparency = 0.5
_G.Disabled = true

local Players = game:GetService("Players")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "Hamimsfy"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0,180,0,160)
main.Position = UDim2.new(0,100,0,100)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,20)
title.BackgroundTransparency = 1
title.Text = "Hamimsfy"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 14
title.Font = Enum.Font.SourceSansBold
title.Parent = main

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,160,0,25)
toggle.Position = UDim2.new(0,10,0,25)
toggle.Text = "ON"
toggle.BackgroundColor3 = Color3.fromRGB(0,170,0)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Parent = main

-- SIZE
local sizeLabel = Instance.new("TextLabel")
sizeLabel.Size = UDim2.new(1,0,0,15)
sizeLabel.Position = UDim2.new(0,0,0,55)
sizeLabel.BackgroundTransparency = 1
sizeLabel.Text = "Size : ".._G.HeadSize
sizeLabel.TextColor3 = Color3.new(1,1,1)
sizeLabel.TextSize = 13
sizeLabel.Parent = main

local sizePlus = Instance.new("TextButton")
sizePlus.Size = UDim2.new(0,75,0,20)
sizePlus.Position = UDim2.new(0,10,0,70)
sizePlus.Text = "Size +"
sizePlus.Parent = main

local sizeMinus = Instance.new("TextButton")
sizeMinus.Size = UDim2.new(0,75,0,20)
sizeMinus.Position = UDim2.new(0,95,0,70)
sizeMinus.Text = "Size -"
sizeMinus.Parent = main

-- TRANSPARENCY
local transLabel = Instance.new("TextLabel")
transLabel.Size = UDim2.new(1,0,0,15)
transLabel.Position = UDim2.new(0,0,0,95)
transLabel.BackgroundTransparency = 1
transLabel.Text = "Transparent : ".._G.Transparency
transLabel.TextColor3 = Color3.new(1,1,1)
transLabel.TextSize = 13
transLabel.Parent = main

local transPlus = Instance.new("TextButton")
transPlus.Size = UDim2.new(0,75,0,20)
transPlus.Position = UDim2.new(0,10,0,110)
transPlus.Text = "Trans +"
transPlus.Parent = main

local transMinus = Instance.new("TextButton")
transMinus.Size = UDim2.new(0,75,0,20)
transMinus.Position = UDim2.new(0,95,0,110)
transMinus.Text = "Trans -"
transMinus.Parent = main

-- MINI & CLOSE
local mini = Instance.new("TextButton")
mini.Size = UDim2.new(0,20,0,20)
mini.Position = UDim2.new(1,-45,0,0)
mini.Text = "-"
mini.BackgroundColor3 = Color3.fromRGB(255,255,255)
mini.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.new(0,20,0,20)
close.Position = UDim2.new(1,-20,0,0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200,0,0)
close.TextColor3 = Color3.new(1,1,1)
close.Parent = main

-- ICON (minimize)
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0,40,0,40)
icon.Position = UDim2.new(0,100,0,100)
icon.Text = "H"
icon.Visible = false
icon.BackgroundColor3 = Color3.fromRGB(30,30,30)
icon.TextColor3 = Color3.new(1,1,1)
icon.Parent = gui
icon.Active = true
icon.Draggable = true

-- RESET
local function resetHitbox()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
            local hrp = v.HumanoidRootPart
            pcall(function()
                hrp.Size = Vector3.new(2,2,1)
                hrp.Transparency = 1
                hrp.Material = Enum.Material.Plastic
                hrp.CanCollide = false
            end)
        end
    end
end

-- TOGGLE
toggle.MouseButton1Click:Connect(function()
    _G.Disabled = not _G.Disabled
    if _G.Disabled then
        toggle.Text = "ON"
        toggle.BackgroundColor3 = Color3.fromRGB(0,170,0)
    else
        toggle.Text = "OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
        resetHitbox()
    end
end)

-- SIZE BUTTON
sizePlus.MouseButton1Click:Connect(function()
    _G.HeadSize = math.clamp(_G.HeadSize + 5,5,50)
    sizeLabel.Text = "Size : ".._G.HeadSize
end)

sizeMinus.MouseButton1Click:Connect(function()
    _G.HeadSize = math.clamp(_G.HeadSize - 5,5,50)
    sizeLabel.Text = "Size : ".._G.HeadSize
end)

-- TRANSPARENCY BUTTON
transPlus.MouseButton1Click:Connect(function()
    _G.Transparency = math.clamp(_G.Transparency + 0.1,0.1,0.9)
    transLabel.Text = "Transparent : "..string.format("%.1f",_G.Transparency)
end)

transMinus.MouseButton1Click:Connect(function()
    _G.Transparency = math.clamp(_G.Transparency - 0.1,0.1,0.9)
    transLabel.Text = "Transparent : "..string.format("%.1f",_G.Transparency)
end)

-- MINI
mini.MouseButton1Click:Connect(function()
    main.Visible = false
    icon.Visible = true
end)

icon.MouseButton1Click:Connect(function()
    main.Visible = true
    icon.Visible = false
end)

-- CLOSE
close.MouseButton1Click:Connect(function()
    _G.Disabled = false
    resetHitbox()
    gui:Destroy()
end)

-- HITBOX LOOP (FIX)
task.spawn(function()
    while task.wait(0.3) do
        if not _G.Disabled then continue end

        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model")
            and v:FindFirstChild("Humanoid")
            and v:FindFirstChild("HumanoidRootPart") then

                if Players:GetPlayerFromCharacter(v) then continue end

                local humanoid = v:FindFirstChild("Humanoid")
                local hrp = v:FindFirstChild("HumanoidRootPart")

                if humanoid.Health <= 0 then
                    hrp.Transparency = 1
                    continue
                end

                hrp.CanCollide = false
                hrp.Massless = true

                local size = math.clamp(_G.HeadSize,5,50)

                hrp.Size = Vector3.new(size,size,size)
                hrp.Transparency = _G.Transparency
                hrp.Material = Enum.Material.Neon
                hrp.Color = Color3.fromRGB(255,0,0)
            end
        end
    end
end)
