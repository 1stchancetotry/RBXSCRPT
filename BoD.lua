-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Global Settings
_G.KillAuraEnabled = false
_G.AuraDistance = 250
_G.MaxZombies = 15
_G.WalkSpeed = 16
_G.JumpPower = 80

-- Initialize Rayfield Window
local Window = Rayfield:CreateWindow({
   Name = "MvP",
   LoadingTitle = "MvP Interface",
   LoadingSubtitle = "Loaded Successfully",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BakeOrDie",
      FileName = "BakeConfig"
   },
   Discord = {
      Enabled = false,
      RememberJoins = true
   },
   KeySystem = false,
})

-- Game Services & Remotes
local ZAP = require(game:GetService("ReplicatedStorage").Client.ClientRemotes)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Function to apply movement settings to a specific character
local function applyMovementSettings(character)
    if not character then return end
    
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.WalkSpeed = _G.WalkSpeed
        humanoid.JumpPower = _G.JumpPower
    end
end

-- Listen for Character Added (Fixes speed resetting on respawn)
LocalPlayer.CharacterAdded:Connect(function(character)
    -- Wait for root part to ensure character is fully loaded
    character:WaitForChild("HumanoidRootPart")
    applyMovementSettings(character)
end)

-- Apply settings immediately if character already exists
if LocalPlayer.Character then
    task.spawn(function()
        applyMovementSettings(LocalPlayer.Character)
    end)
end

-- Combat Tab
local CombatTab = Window:CreateTab("Combat", 4483362458)
CombatTab:CreateSection("Kill Aura")

local KillAuraToggle = CombatTab:CreateToggle({
   Name = "Kill Aura",
   CurrentValue = false,
   Flag = "KillAuraToggle",
   Callback = function(Value)
      _G.KillAuraEnabled = Value
   end,
})

local AuraDistanceSlider = CombatTab:CreateSlider({
   Name = "Kill Aura Distance",
   Range = {10, 1500},
   Increment = 50,
   Suffix = "Studs",
   CurrentValue = 250,
   Flag = "AuraDistance",
   Callback = function(Value)
      _G.AuraDistance = Value
   end,
})

local MaxZombiesSlider = CombatTab:CreateSlider({
   Name = "Max Zombies per Tick",
   Range = {1, 15},
   Increment = 1,
   Suffix = "Targets",
   CurrentValue = 15,
   Flag = "MaxZombies",
   Callback = function(Value)
      _G.MaxZombies = Value
   end,
})

-- Items Tab
local ItemsTab = Window:CreateTab("Items", 4483362458)
ItemsTab:CreateSection("Item Management")

local BringBodiesButton = ItemsTab:CreateButton({
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

local BringAllButton = ItemsTab:CreateButton({
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

-- Player Tab
local PlayerTab = Window:CreateTab("Player", 4483362458)
PlayerTab:CreateSection("Character Settings")

local WalkSpeedSlider = PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 200},
   Increment = 5,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
      _G.WalkSpeed = Value
      -- Apply immediately when slider moves
      if LocalPlayer.Character then
          local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
          if humanoid then humanoid.WalkSpeed = Value end
      end
   end,
})

local JumpPowerSlider = PlayerTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 200},
   Increment = 10,
   Suffix = "Power",
   CurrentValue = 80,
   Flag = "JumpPower",
   Callback = function(Value)
      _G.JumpPower = Value
      -- Apply immediately when slider moves
      if LocalPlayer.Character then
          local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
          if humanoid then 
              humanoid.UseJumpPower = true
              humanoid.JumpPower = Value 
          end
      end
   end,
})

-- Kill Aura Loop
task.spawn(function()
    while true do
        if _G.KillAuraEnabled then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local root = character.HumanoidRootPart
                local distance = _G.AuraDistance or 250
                local maxTargets = _G.MaxZombies or 15
                local count = 0
                
                -- Check if Monsters folder exists to prevent errors
                if workspace:FindFirstChild("Monsters") then
                    for _, monster in pairs(workspace.Monsters:GetChildren()) do
                        if count >= maxTargets then break end
                        if monster:FindFirstChild("HumanoidRootPart") then
                            local d = (root.Position - monster.HumanoidRootPart.Position).Magnitude
                            if d < distance then
                                -- Use pcall to prevent script crash if remote fails
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
        task.wait(0.1) -- Slightly faster tick for better aura responsiveness
    end
end)

-- Movement Stability Loop (Ensures speed stays constant against server resets)
task.spawn(function()
    while true do
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                -- Only update if values differ to reduce network stress
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

-- Final Notification
Rayfield:Notify({
   Title = "Script Loaded",
   Content = "All features updated & Movement Fixed.",
   Duration = 3,
   Image = 4483362458,
   Actions = {
      Ignore = {
         Name = "Okay!",
         Callback = function() end
      }
   },
})
