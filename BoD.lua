local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ImInsane-1337/neverlose-ui/refs/heads/main/source/library.lua"))()

_G.KillAuraEnabled = false
_G.AuraDistance = 250
_G.MaxZombies = 15
_G.WalkSpeed = 16
_G.JumpPower = 80

local Window = Library:Window({
    Name = "MvP",
    SubName = "BakeOrDie",
    Logo = "123456789",
    MenuKeybind = Enum.KeyCode.End
})

local ZAP = require(game:GetService("ReplicatedStorage").Client.ClientRemotes)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function applyMovementSettings(character)
    if not character then return end
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.WalkSpeed = _G.WalkSpeed
        humanoid.JumpPower = _G.JumpPower
    end
end

LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("HumanoidRootPart")
    applyMovementSettings(character)
end)

if LocalPlayer.Character then
    task.spawn(function()
        applyMovementSettings(LocalPlayer.Character)
    end)
end

local CombatPage = Window:Page({Name = "Combat", Icon = "rbxassetid://123"})
local CombatSection = CombatPage:Section({Name = "Kill Aura", Side = 1})

CombatSection:Toggle({
    Name = "Kill Aura",
    Flag = "KillAuraToggle",
    Default = false,
    Callback = function(Value)
        _G.KillAuraEnabled = Value
    end,
})

CombatSection:Slider({
    Name = "Kill Aura Distance",
    Flag = "AuraDistance",
    Min = 10,
    Max = 1500,
    Default = 250,
    Suffix = " studs",
    Callback = function(Value)
        _G.AuraDistance = Value
    end,
})

CombatSection:Slider({
    Name = "Max Zombies per Tick",
    Flag = "MaxZombies",
    Min = 1,
    Max = 15,
    Default = 15,
    Suffix = " targets",
    Callback = function(Value)
        _G.MaxZombies = Value
    end,
})

local ItemsPage = Window:Page({Name = "Items", Icon = "rbxassetid://123"})
local ItemsSection = ItemsPage:Section({Name = "Item Management", Side = 1})

ItemsSection:Button({
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

ItemsSection:Button({
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

local PlayerPage = Window:Page({Name = "Player", Icon = "rbxassetid://123"})
local PlayerSection = PlayerPage:Section({Name = "Character Settings", Side = 1})

PlayerSection:Slider({
    Name = "WalkSpeed",
    Flag = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Suffix = " speed",
    Callback = function(Value)
        _G.WalkSpeed = Value
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then humanoid.WalkSpeed = Value end
        end
    end,
})

PlayerSection:Slider({
    Name = "JumpPower",
    Flag = "JumpPower",
    Min = 50,
    Max = 200,
    Default = 80,
    Suffix = " power",
    Callback = function(Value)
        _G.JumpPower = Value
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = Value
            end
        end
    end,
})

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

task.spawn(function()
    while true do
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                if math.abs(humanoid.WalkSpeed - _G.WalkSpeed) > 0.1 then
                    humanoid.WalkSpeed = _G.WalkSpeed
                end
                if math.abs(humanoid.JumpPower - _G.JumpPower) > 0.1 then
                    humanoid.UseJumpPower = true
                    humanoid.JumpPower = _G.JumpPower
                end
            end
        end
        task.wait(0.2)
    end
end)
