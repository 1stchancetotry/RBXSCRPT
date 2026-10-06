local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/J0se-j/My-Lua-Library/refs/heads/main/Booting-the-library.lua"))()

_G.KillAuraEnabled = false
_G.AuraDistance = 250
_G.MaxZombies = 15
_G.NoclipEnabled = false
_G.VFlyEnabled = false
_G.FlySpeed = 50

local Window = Library:CreateWindow({
    Name = "MvP",
    LoadingTitle = "MvP Interface",
    LoadingSubtitle = "Loaded Successfully",
    ToggleUIKeybind = Enum.KeyCode.K,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BakeOrDie",
        FileName = "BakeConfig"
    }
})

local ZAP = require(game:GetService("ReplicatedStorage").Client.ClientRemotes)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ========== Combat Tab ==========
local CombatTab = Window:CreateTab("Combat", 4483362458)
local CombatSection = CombatTab:CreateSection("Kill Aura")

CombatSection:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Flag = "KillAuraToggle",
    Callback = function(Value)
        _G.KillAuraEnabled = Value
    end,
})

CombatSection:CreateSlider({
    Name = "Kill Aura Distance",
    Min = 10,
    Max = 1500,
    Default = 250,
    Suffix = " Studs",
    Flag = "AuraDistance",
    Callback = function(Value)
        _G.AuraDistance = Value
    end,
})

CombatSection:CreateSlider({
    Name = "Max Zombies per Tick",
    Min = 1,
    Max = 15,
    Default = 15,
    Suffix = " Targets",
    Flag = "MaxZombies",
    Callback = function(Value)
        _G.MaxZombies = Value
    end,
})

-- ========== Items Tab ==========
local ItemsTab = Window:CreateTab("Items", 4483362458)
local ItemsSection = ItemsTab:CreateSection("Item Management")

ItemsSection:CreateButton({
    Name = "Bring Bodies",
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

ItemsSection:CreateButton({
    Name = "Bring All Items",
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

-- ========== Player Tab ==========
local PlayerTab = Window:CreateTab("Player", 4483362458)
local PlayerSection = PlayerTab:CreateSection("Movement")

PlayerSection:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        _G.NoclipEnabled = Value
    end,
})

PlayerSection:CreateToggle({
    Name = "VFly",
    CurrentValue = false,
    Flag = "VFlyToggle",
    Callback = function(Value)
        _G.VFlyEnabled = Value
        -- Stop velocity when turning off
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

PlayerSection:CreateSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 300,
    Default = 50,
    Suffix = " Speed",
    Flag = "FlySpeed",
    Callback = function(Value)
        _G.FlySpeed = Value
    end,
})

-- ========== Kill Aura Loop ==========
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

-- ========== Noclip Loop ==========
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

-- ========== VFly Loop ==========
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

                    -- PC keyboard controls
                    local UIS = game:GetService("UserInputService")
                    if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += camera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= camera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= camera.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += camera.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
                    if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0, 1, 0) end

                    -- Mobile thumbstick support
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
