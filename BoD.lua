-- Load Amethyst UI (with minimize support)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/J0se-j/My-Lua-Library/refs/heads/main/Booting-the-library.lua"))()

-- Global settings
_G.KillAuraEnabled = false
_G.AuraDistance = 250
_G.MaxZombies = 15
_G.WalkSpeed = 16
_G.JumpPower = 80

-- Create window (minimize via ToggleUIKeybind)
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

-- Services and remotes
local ZAP = require(game:GetService("ReplicatedStorage").Client.ClientRemotes)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Apply movement settings
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
local PlayerSection = PlayerTab:CreateSection("Character Settings")

PlayerSection:CreateSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Suffix = " Speed",
    Flag = "WalkSpeed",
    Callback = function(Value)
        _G.WalkSpeed = Value
        -- Get fresh reference every time to prevent stale Humanoid after respawn
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = Value end
        end
    end,
})

PlayerSection:CreateSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 200,
    Default = 80,
    Suffix = " Power",
    Flag = "JumpPower",
    Callback = function(Value)
        _G.JumpPower = Value
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = Value
            end
        end
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

-- ========== Movement Stability Loop (strengthened version) ==========
task.spawn(function()
    while true do
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
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
        task.wait(0.1) -- Faster tick, better adapted for mobile
    end
end)
