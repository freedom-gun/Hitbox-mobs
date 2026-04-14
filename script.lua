_G.BodySize = 20
_G.BodyTransparency = 0.5
_G.BodyEnabled = false

_G.HeadSize = 20
_G.HeadTransparency = 0.5
_G.HeadEnabled = false

_G.Running = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local targets = {}  -- Cache semua model yang diproses

-- ================= GUI (sama) =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Hamimsfy"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,200,0,260)
main.Position = UDim2.new(0,100,0,100)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true

local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.new(0,40,0,40)
icon.Position = UDim2.new(0,100,0,100)
icon.Text = "H"
icon.Visible = false
icon.BackgroundColor3 = Color3.fromRGB(30,30,30)
icon.TextColor3 = Color3.new(1,1,1)
icon.Active = true
icon.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,20)
title.BackgroundTransparency = 1
title.Text = "Hamimsfy"
title.TextColor3 = Color3.new(1,1,1)

local mini = Instance.new("TextButton", main)
mini.Size = UDim2.new(0,20,0,20)
mini.Position = UDim2.new(1,-45,0,0)
mini.Text = "-"

local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0,20,0,20)
close.Position = UDim2.new(1,-20,0,0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(170,0,0)
close.TextColor3 = Color3.new(1,1,1)

local function label(text,y)
    local l = Instance.new("TextLabel", main)
    l.Size = UDim2.new(1,0,0,15)
    l.Position = UDim2.new(0,0,0,y)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.new(1,1,1)
    l.Text = text
    return l
end

local function btn(text,x,y)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0,90,0,20)
    b.Position = UDim2.new(0,x,0,y)
    b.Text = text
    return b
end

-- BODY UI
local bodyToggle = Instance.new("TextButton", main)
bodyToggle.Size = UDim2.new(0,180,0,25)
bodyToggle.Position = UDim2.new(0,10,0,25)
bodyToggle.Text = "BODY OFF"
bodyToggle.BackgroundColor3 = Color3.fromRGB(170,0,0)

local bodySizeLabel = label("Body Size : ".._G.BodySize,55)
local bodyTransLabel = label("Body Trans : ".._G.BodyTransparency,90)

local bPlus = btn("Size +",10,70)
local bMinus = btn("Size -",100,70)
local btPlus = btn("Trans +",10,105)
local btMinus = btn("Trans -",100,105)

-- HEAD UI
local headToggle = Instance.new("TextButton", main)
headToggle.Size = UDim2.new(0,180,0,25)
headToggle.Position = UDim2.new(0,10,0,130)
headToggle.Text = "HEAD OFF"
headToggle.BackgroundColor3 = Color3.fromRGB(170,0,0)

local headSizeLabel = label("Head Size : ".._G.HeadSize,160)
local headTransLabel = label("Head Trans : ".._G.HeadTransparency,195)

local hPlus = btn("Size +",10,175)
local hMinus = btn("Size -",100,175)
local htPlus = btn("Trans +",10,210)
local htMinus = btn("Trans -",100,210)

-- ================= RESET =================
local function resetBody(model)
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Size = Vector3.new(2,2,1)
        hrp.Transparency = 1
        hrp.Material = Enum.Material.Plastic
    end
end

local function resetHead(model)
    local head = model:FindFirstChild("Head")
    if head then
        head.Size = Vector3.new(2,1,1)
        head.Transparency = 0
        head.Material = Enum.Material.Plastic
    end
end

-- ================= TOGGLE & BUTTONS (sama) =================
bodyToggle.MouseButton1Click:Connect(function()
    _G.BodyEnabled = not _G.BodyEnabled
    bodyToggle.Text = _G.BodyEnabled and "BODY ON" or "BODY OFF"
    bodyToggle.BackgroundColor3 = _G.BodyEnabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
end)

headToggle.MouseButton1Click:Connect(function()
    _G.HeadEnabled = not _G.HeadEnabled
    headToggle.Text = _G.HeadEnabled and "HEAD ON" or "HEAD OFF"
    headToggle.BackgroundColor3 = _G.HeadEnabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
end)

-- Size controls sama...
bPlus.MouseButton1Click:Connect(function()
    _G.BodySize = math.clamp(_G.BodySize+5,5,100)
    bodySizeLabel.Text = "Body Size : ".._G.BodySize
end)
bMinus.MouseButton1Click:Connect(function()
    _G.BodySize = math.clamp(_G.BodySize-5,5,100)
    bodySizeLabel.Text = "Body Size : ".._G.BodySize
end)
btPlus.MouseButton1Click:Connect(function()
    _G.BodyTransparency = math.clamp(_G.BodyTransparency+0.1,0.1,0.9)
    bodyTransLabel.Text = "Body Trans : "..string.format("%.1f",_G.BodyTransparency)
end)
btMinus.MouseButton1Click:Connect(function()
    _G.BodyTransparency = math.clamp(_G.BodyTransparency-0.1,0.1,0.9)
    bodyTransLabel.Text = "Body Trans : "..string.format("%.1f",_G.BodyTransparency)
end)
hPlus.MouseButton1Click:Connect(function()
    _G.HeadSize = math.clamp(_G.HeadSize+5,5,100)
    headSizeLabel.Text = "Head Size : ".._G.HeadSize
end)
hMinus.MouseButton1Click:Connect(function()
    _G.HeadSize = math.clamp(_G.HeadSize-5,5,100)
    headSizeLabel.Text = "Head Size : ".._G.HeadSize
end)
htPlus.MouseButton1Click:Connect(function()
    _G.HeadTransparency = math.clamp(_G.HeadTransparency+0.1,0.1,0.9)
    headTransLabel.Text = "Head Trans : "..string.format("%.1f",_G.HeadTransparency)
end)
htMinus.MouseButton1Click:Connect(function()
    _G.HeadTransparency = math.clamp(_G.HeadTransparency-0.1,0.1,0.9)
    headTransLabel.Text = "Head Trans : "..string.format("%.1f",_G.HeadTransparency)
end)

mini.MouseButton1Click:Connect(function()
    main.Visible = false
    icon.Visible = true
end)

icon.MouseButton1Click:Connect(function()
    main.Visible = true
    icon.Visible = false
end)

-- ================= OPTIMIZED PROCESS =================
local function processBody(model)
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if hrp then
        if _G.BodyEnabled then
            hrp.Size = Vector3.new(_G.BodySize, _G.BodySize, _G.BodySize)
            hrp.Transparency = _G.BodyTransparency
            hrp.Material = Enum.Material.Neon
        else
            resetBody(model)
        end
        return true
    end
    return false
end

local function processHead(model)
    local head = model:FindFirstChild("Head")
    if head then
        if _G.HeadEnabled then
            head.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
            head.Transparency = _G.HeadTransparency
            head.Material = Enum.Material.Neon
        else
            resetHead(model)
        end
        return true
    end
    return false
end

local function processModel(model)
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local player = Players:GetPlayerFromCharacter(model)
    
    if player then return end
    if humanoid and humanoid.Health <= 0 then
        resetBody(model)
        resetHead(model)
        return
    end
    
    processBody(model)
    processHead(model)
end

-- ================= INITIAL SCAN & CACHE =================
local function scanWorkspace()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            targets[obj] = true
        end
    end
end

scanWorkspace()  -- Scan sekali awal

-- ================= OPTIMIZED LOOP dengan Heartbeat =================
local heartbeatConnection
heartbeatConnection = RunService.Heartbeat:Connect(function()
    if not _G.Running then
        heartbeatConnection:Disconnect()
        return
    end

    -- Update cache dengan perubahan baru (efisien)
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and not targets[obj] then
            targets[obj] = true
        end
    end

    -- Proses hanya model di cache
    for model in pairs(targets) do
        if model.Parent then  -- Masih ada
            processModel(model)
        else
            targets[model] = nil  -- Cleanup hilang
        end
    end
end)

-- ================= CLOSE =================
close.MouseButton1Click:Connect(function()
    _G.Running = false

    -- Reset semua di cache
    for model in pairs(targets) do
        if model.Parent then
            resetBody(model)
            resetHead(model)
        end
    end

    if heartbeatConnection then
        heartbeatConnection:Disconnect()
    end

    gui:Destroy()
end)
