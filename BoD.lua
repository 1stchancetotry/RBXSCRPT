local HelixiaLIB = loadstring(game:HttpGet("https://raw.githubusercontent.com/topraqk11/Helixia-LIBRARY/refs/heads/main/library/source"))()

_G.KillAuraEnabled = false
_G.AuraDistance = 250
_G.MaxZombies = 15
_G.NoclipEnabled = false
_G.VFlyEnabled = false
_G.FlySpeed = 50

local win = HelixiaLIB:CreateWindow({
    Title    = "MvP",
    SubTitle = "BakeOrDie",
    Icon     = "rbxassetid://102278873791566",
    Size     = Vector2.new(860, 540),
})

local ZAP = require(game:GetService("ReplicatedStorage").Client.ClientRemotes)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ===== COMBAT TAB =====
local CombatTab = win:CreateTab({Name = "Combat", Icon = "rbxassetid://138525646531017"})
CombatTab:CreateSection("Kill Aura")

CombatTab:CreateToggle({
    Text     = "Kill Aura",
    Default  = false,
    Callback = function(Value)
        _G.KillAuraEnabled = Value
    end,
})

CombatTab:CreateSlider({
    Text     = "Kill Aura Distance",
    Min      = 10,
    Max      = 1500,
    Default  = 250,
    Increment = 50,
    Suffix   = " Studs",
    Callback = function(Value)
        _G.AuraDistance = Value
    end,
})

CombatTab:CreateSlider({
    Text     = "Max Zombies per Tick",
    Min      = 1,
    Max      = 15,
    Default  = 15,
    Increment = 1,
    Suffix   = " Targets",
    Callback = function(Value)
        _G.MaxZombies = Value
    end,
})

-- ===== ITEMS TAB =====
local ItemsTab = win:CreateTab({Name = "Items", Icon = "rbxassetid://138525646531017"})
ItemsTab:CreateSection("Item Management")

ItemsTab:CreateButton({
    Text     = "Bring Bodies",
    Callback = function()
        local character = LocalPlayer.Character
        if not character or not character.PrimaryPart then return end
        for _, v in pairs(workspace.Interactables:GetChildren()) do
            if v:IsA("Model") and not v:FindFirstChild("ProductPriceTag") then
                if v:FindFirstChild("Humanoid") or string.match(v.Name:lower(), "body") or string.match(v.Name:lower(), "corpse") then
                    local root = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                    if root then
                        root.CFrame = character.PrimaryPart.CFrame
                    end
                end
            end
        end
    end,
})

ItemsTab:CreateButton({
    Text     = "Bring All Items",
    Callback = function()
        local character = LocalPlayer.Character
        if not character or not character.PrimaryPart then return end
        for _, v in pairs(workspace.Interactables:GetChildren()) do
            if v:IsA("Model") and not v:FindFirstChild("ProductPriceTag") and v.PrimaryPart then
                v.PrimaryPart.CFrame = character.PrimaryPart.CFrame
            end
        end
    end,
})

-- ===== PLAYER TAB =====
local PlayerTab = win:CreateTab({Name = "Player", Icon = "rbxassetid://138525646531017"})
PlayerTab:CreateSection("Movement")

PlayerTab:CreateToggle({
    Text     = "Noclip",
    Default  = false,
    Callback = function(Value)
        _G.NoclipEnabled = Value
    end,
})

PlayerTab:CreateToggle({
    Text     = "VFly",
    Default  = false,
    Callback = function(Value)
        _G.VFlyEnabled = Value
        if not Value then
            local char = LocalPlayer.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    root.AssemblyLinearVelocity = Vector3.zero
                end
            end
        end
    end,
})

PlayerTab:CreateSlider({
    Text     = "Fly Speed",
    Min      = 10,
    Max      = 300,
    Default  = 50,
    Increment = 5,
    Suffix   = " Speed",
    Callback = function(Value)
        _G.FlySpeed = Value
    end,
})

-- ===== KILL AURA LOOP =====
task.spawn(function()
    while true do
        if _G.KillAuraEnabled then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local root = character.HumanoidRootPart
                local distance = _G.AuraDistance or 250
                local maxTargets = _G.MaxZombies or 15
                local count = 0
                if workspace:FindFirstChild("Monsters") then
                    for _, monster in pairs(workspace.Monsters:GetChildren()) do
                        if count >= maxTargets then break end
                        if monster:FindFirstChild("HumanoidRootPart") then
                            local d = (root.Position - monster.HumanoidRootPart.Position).Magnitude
                            if d < distance then
                                pcall(function()
                                    ZAP.meleeAttack.fire({
                                        monsters = {monster},
                                        civilians = {},
                                        activeSlot = 1
                                    })
                                end)
                                count = count + 1
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

-- ===== NOCLIP LOOP =====
task.spawn(function()
    while true do
        if _G.NoclipEnabled then
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end
        task.wait(0.2)
    end
end)

-- ===== VFLY LOOP =====
task.spawn(function()
    while true do
        if _G.VFlyEnabled then
            local character = LocalPlayer.Character
            if character then
                local root = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if root and humanoid then
                    local camera = workspace.CurrentCamera
                    local moveDir = Vector3.zero
                    local UIS = game:GetService("UserInputService")
                    if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += camera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= camera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= camera.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += camera.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
                    if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0, 1, 0) end
                    local mobileMove = humanoid.MoveDirection
                    if mobileMove.Magnitude > 0 then
                        moveDir += mobileMove
                    end
                    if moveDir.Magnitude > 0 then
                        root.AssemblyLinearVelocity = moveDir.Unit * _G.FlySpeed
                    else
                        root.AssemblyLinearVelocity = Vector3.zero
                    end
                end
            end
        end
        task.wait()
    end
end)

-- ===== LOAD NOTIFICATION =====
HelixiaLIB:Notify({
    Title    = "MvP Loaded",
    Message  = "All features ready.",
    Type     = "Success",
    Duration = 3,
})
