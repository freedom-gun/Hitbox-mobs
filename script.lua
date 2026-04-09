_G.HeadSize = 30
_G.Transparency = 0.5
_G.Disabled = true

local Players = game:GetService("Players")

-- GUI (punya kamu, nggak diubah)
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

-- RESET HITBOX
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

-- 🔥 HITBOX LOOP (FIX UTAMA)
task.spawn(function()
    while task.wait(0.3) do -- ⬅️ penting: biar nggak spam
        if not _G.Disabled then continue end

        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model")
            and v:FindFirstChild("Humanoid")
            and v:FindFirstChild("HumanoidRootPart") then

                -- skip player
                if Players:GetPlayerFromCharacter(v) then continue end

                local humanoid = v:FindFirstChild("Humanoid")
                local hrp = v:FindFirstChild("HumanoidRootPart")

                if humanoid.Health <= 0 then
                    hrp.Transparency = 1
                    continue
                end

                -- 🔥 FIX: biar nggak jadi tembok
                hrp.CanCollide = false
                hrp.Massless = true

                -- 🔥 size dibatasi biar nggak glitch
                local size = math.clamp(_G.HeadSize, 5, 50)

                hrp.Size = Vector3.new(size, size, size)
                hrp.Transparency = _G.Transparency
                hrp.Material = Enum.Material.Neon
                hrp.Color = Color3.fromRGB(255, 0, 0)
            end
        end
    end
end)
