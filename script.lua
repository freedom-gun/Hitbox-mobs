-- ================= CONFIGURATION =================
_G.BodySize = 20
_G.BodyTransparency = 0.5
_G.BodyEnabled = false

_G.HeadSize = 20
_G.HeadTransparency = 0.5
_G.HeadEnabled = false

_G.Running = true

-- Aimbot settings
_G.AimbotEnabled = false
_G.AimbotFovRadius = 150   -- pixels, medium-sized circle
_G.AimbotSmoothness = 0.1  -- lower = snappier, higher = smoother (camera control)

-- ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ================= CACHE =================
local targets = {}  -- Models of NPCs/enemies

-- ================= GUI (MODERN BUT KEEPS ORIGINAL LAYOUT) =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Hamimsfy_Modern"
gui.ResetOnSpawn = false

-- Main frame (position/size unchanged)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,200,0,260)
main.Position = UDim2.new(0,100,0,100)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true

-- Modern styling: rounded corners, subtle drop shadow effect via a darker underlay
local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0,8)

local underlay = Instance.new("Frame", main)
underlay.Size = UDim2.new(1,0,1,0)
underlay.Position = UDim2.new(0,0,0,0)
underlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
underlay.BackgroundTransparency = 0.7
underlay.ZIndex = -1
local underlayCorner = Instance.new("UICorner", underlay)
underlayCorner.CornerRadius = UDim.new(0,8)

-- Icon button (toggle GUI)
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.new(0,40,0,40)
icon.Position = UDim2.new(0,100,0,100)
icon.Text = "H"
icon.Visible = false
icon.BackgroundColor3 = Color3.fromRGB(30,30,30)
icon.TextColor3 = Color3.new(1,1,1)
local iconCorner = Instance.new("UICorner", icon)
iconCorner.CornerRadius = UDim.new(0,6)

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,20)
title.BackgroundTransparency = 1
title.Text = "Hamimsfy V2"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

-- Minimize / Close buttons (styled)
local mini = Instance.new("TextButton", main)
mini.Size = UDim2.new(0,20,0,20)
mini.Position = UDim2.new(1,-45,0,0)
mini.Text = "-"
mini.BackgroundColor3 = Color3.fromRGB(40,40,40)
mini.TextColor3 = Color3.new(1,1,1)
local miniCorner = Instance.new("UICorner", mini)
miniCorner.CornerRadius = UDim.new(0,4)

local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0,20,0,20)
close.Position = UDim2.new(1,-20,0,0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(170,0,0)
close.TextColor3 = Color3.new(1,1,1)
local closeCorner = Instance.new("UICorner", close)
closeCorner.CornerRadius = UDim.new(0,4)

-- Helper to create labels / buttons (unchanged positions)
local function label(text,y)
    local l = Instance.new("TextLabel", main)
    l.Size = UDim2.new(1,0,0,15)
    l.Position = UDim2.new(0,0,0,y)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.new(1,1,1)
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
    l.Text = text
    return l
end

local function btn(text,x,y)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0,90,0,20)
    b.Position = UDim2.new(0,x,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    local bc = Instance.new("UICorner", b)
    bc.CornerRadius = UDim.new(0,4)
    return b
end

-- ================= BODY UI =================
local bodyToggle = Instance.new("TextButton", main)
bodyToggle.Size = UDim2.new(0,180,0,25)
bodyToggle.Position = UDim2.new(0,10,0,25)
bodyToggle.Text = "BODY OFF"
bodyToggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
bodyToggle.Font = Enum.Font.Gotham
bodyToggle.TextSize = 12
local bodyTCorner = Instance.new("UICorner", bodyToggle)
bodyTCorner.CornerRadius = UDim.new(0,4)

local bodySizeLabel = label("Body Size : ".._G.BodySize,55)
local bodyTransLabel = label("Body Trans : ".._G.BodyTransparency,90)

local bPlus = btn("Size +",10,70)
local bMinus = btn("Size -",100,70)
local btPlus = btn("Trans +",10,105)
local btMinus = btn("Trans -",100,105)

-- ================= HEAD UI =================
local headToggle = Instance.new("TextButton", main)
headToggle.Size = UDim2.new(0,180,0,25)
headToggle.Position = UDim2.new(0,10,0,130)
headToggle.Text = "HEAD OFF"
headToggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
headToggle.Font = Enum.Font.Gotham
headToggle.TextSize = 12
local headTCorner = Instance.new("UICorner", headToggle)
headTCorner.CornerRadius = UDim.new(0,4)

local headSizeLabel = label("Head Size : ".._G.HeadSize,160)
local headTransLabel = label("Head Trans : ".._G.HeadTransparency,195)

local hPlus = btn("Size +",10,175)
local hMinus = btn("Size -",100,175)
local htPlus = btn("Trans +",10,210)
local htMinus = btn("Trans -",100,210)

-- ================= AIMBOT UI (NEW) =================
local aimbotToggle = Instance.new("TextButton", main)
aimbotToggle.Size = UDim2.new(0,180,0,25)
aimbotToggle.Position = UDim2.new(0,10,0,240)   -- placed at bottom
aimbotToggle.Text = "AIMBOT OFF"
aimbotToggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
aimbotToggle.Font = Enum.Font.Gotham
aimbotToggle.TextSize = 12
local aimbotTCorner = Instance.new("UICorner", aimbotToggle)
aimbotTCorner.CornerRadius = UDim.new(0,4)

-- Crosshair circle (FOV indicator) – will be shown when aimbot is on
local fovCircle = Instance.new("Frame", gui)
fovCircle.Size = UDim2.new(0, _G.AimbotFovRadius*2, 0, _G.AimbotFovRadius*2)
fovCircle.Position = UDim2.new(0.5, -_G.AimbotFovRadius, 0.5, -_G.AimbotFovRadius)
fovCircle.BackgroundTransparency = 0.9
fovCircle.BackgroundColor3 = Color3.fromRGB(0,255,255)
fovCircle.Visible = false
local fovCorner = Instance.new("UICorner", fovCircle)
fovCorner.CornerRadius = UDim.new(0.5,0)   -- perfect circle

-- ================= RESET FUNCTIONS =================
local function resetBody(model)
    local hrp = model:FindFirstChild("HumanoidRootPart")
    local torso = model:FindFirstChild("Torso")
    local bodyPart = hrp or torso

    if bodyPart then
        bodyPart.Size = Vector3.new(2,2,1)
        bodyPart.Transparency = 1
        bodyPart.Material = Enum.Material.Plastic
        bodyPart.CanCollide = true   -- restore original collision
        bodyPart.Massless = false
    end
end

local function resetHead(model)
    local head = model:FindFirstChild("Head")
    if head then
        head.Size = Vector3.new(2,1,1)
        head.Transparency = 0
        head.Material = Enum.Material.Plastic
        head.CanCollide = true
        head.Massless = false
    end
end

-- ================= TOGGLE & BUTTON LOGIC =================
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

aimbotToggle.MouseButton1Click:Connect(function()
    _G.AimbotEnabled = not _G.AimbotEnabled
    aimbotToggle.Text = _G.AimbotEnabled and "AIMBOT ON" or "AIMBOT OFF"
    aimbotToggle.BackgroundColor3 = _G.AimbotEnabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
    fovCircle.Visible = _G.AimbotEnabled
end)

-- Size / Transparency controls (unchanged)
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

close.MouseButton1Click:Connect(function()
    _G.Running = false
    for model,_ in pairs(targets) do
        if model.Parent then
            resetBody(model)
            resetHead(model)
        end
    end
    if heartbeatConnection then heartbeatConnection:Disconnect() end
    gui:Destroy()
end)

-- ================= HITBOX PROCESSING (UNIVERSAL, NON‑COLLIDING) =================
local function getBodyPart(model)
    return model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
end

local function applyHitbox(part, size, transparency)
    if not part then return end
    part.Size = Vector3.new(size, size, size)
    part.Transparency = transparency
    part.Material = Enum.Material.Neon
    part.CanCollide = false   -- crucial: prevents wall‑like blocking and getting stuck
    part.Massless = true      -- reduces physics interference
end

local function processBody(model)
    local bodyPart = getBodyPart(model)
    if bodyPart then
        if _G.BodyEnabled then
            applyHitbox(bodyPart, _G.BodySize, _G.BodyTransparency)
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
            applyHitbox(head, _G.HeadSize, _G.HeadTransparency)
        else
            resetHead(model)
        end
        return true
    end
    return false
end

local function processModel(model)
    -- Skip the local player’s character
    local player = Players:GetPlayerFromCharacter(model)
    if player and player.Character == model then return end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health <= 0 then
        resetBody(model)
        resetHead(model)
        targets[model] = nil
        return
    end

    processBody(model)
    processHead(model)
end

-- ================= AIMBOT LOGIC (NPC/ENEMY ONLY, CAMERA‑SMOOTH) =================
local function getEnemyModels()
    local list = {}
    for model,_ in pairs(targets) do
        if model.Parent then
            local humanoid = model:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                table.insert(list, model)
            end
        end
    end
    return list
end

local function worldToScreenPoint(pos)
    local vector, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(vector.X, vector.Y), onScreen
end

local function getClosestEnemyInFov()
    if not _G.AimbotEnabled then return nil end
    local enemies = getEnemyModels()
    local bestTarget = nil
    bestTarget, _ = Camera:GetPartsObscuringTarget({Camera.CFrame.p}, {LocalPlayer.Character})
    local mousePos = UserInputService:GetMouseLocation()
    local closestDist = math.huge

    for _, model in ipairs(enemies) do
        local part = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head")
        if not part then continue end
        local screenPos, onScreen = worldToScreenPoint(part.Position)
        if not onScreen then continue end
        local dist = (screenPos - mousePos).Magnitude
        if dist <= _G.AimbotFovRadius and dist < closestDist then
            closestDist = dist
            bestTarget = model
        end
    end
    return bestTarget
end

local function smoothCameraTo(targetModel)
    local part = targetModel:FindFirstChild("HumanoidRootPart") or targetModel:FindFirstChild("Head")
    if not part then return end
    local desiredCFrame = CFrame.new(Camera.CFrame.p, part.Position)
    Camera.CFrame = Camera.CFrame:Lerp(desiredCFrame, _G.AimbotSmoothness)
end

RunService.RenderStepped:Connect(function()
    if _G.AimbotEnabled then
        local target = getClosestEnemyInFov()
        if target then
            smoothCameraTo(target)
        end
    end
end)

-- ================= CACHE EVENTS =================
local function onModelAdded(model)
    if model:IsA("Model") then
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        if humanoid then
            targets[model] = true
        end
    end
end

workspace.DescendantAdded:Connect(onModelAdded)
workspace.DescendantRemoving:Connect(function(child)
    if child:IsA("Model") then
        targets[child] = nil
    end
end)

-- Initial scan
for _, obj in pairs(workspace:GetDescendants()) do
    onModelAdded(obj)
end

-- ================= MAIN LOOP (Heartbeat) =================
local heartbeatConnection
heartbeatConnection = RunService.Heartbeat:Connect(function()
    if not _G.Running then
        heartbeatConnection:Disconnect()
        return
    end

    for model in pairs(targets) do
        if model.Parent then
            processModel(model)
        else
            targets[model] = nil
        end
    end
end)
