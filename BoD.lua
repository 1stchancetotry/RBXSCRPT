local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

_G.KillAuraEnabled = false
_G.AuraDistance = 250
_G.MaxZombies = 15
_G.WalkSpeed = 16
_G.JumpPower = 80

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

local ZAP = require(game:GetService("ReplicatedStorage").Client.ClientRemotes)
local Players = game:GetService("Players")

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

local ItemsTab = Window:CreateTab("Items", 4483362458)
ItemsTab:CreateSection("Item Management")

local BringBodiesButton = ItemsTab:CreateButton({
   Name = "Bring Bodies",
   Callback = function()
      local character = Players.LocalPlayer.Character
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
      local character = Players.LocalPlayer.Character
      if not character or not character.PrimaryPart then return end
      for _, v in pairs(workspace.Interactables:GetChildren()) do
          if v:IsA("Model") and not v:FindFirstChild("ProductPriceTag") and v.PrimaryPart then
              v.PrimaryPart.CFrame = character.PrimaryPart.CFrame
          end
      end
   end,
})

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
   end,
})

task.spawn(function()
    while true do
        if _G.KillAuraEnabled then
            local character = Players.LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local root = character.HumanoidRootPart
                local distance = _G.AuraDistance or 25
                local maxTargets = _G.MaxZombies or 5
                local count = 0
                
                for _, monster in pairs(workspace.Monsters:GetChildren()) do
                    if count >= maxTargets then break end
                    if monster:FindFirstChild("HumanoidRootPart") then
                        local d = (root.Position - monster.HumanoidRootPart.Position).Magnitude
                        if d < distance then
                            ZAP.meleeAttack.fire({
                                monsters = {monster},
                                civilians = {},
                                activeSlot = 1
                            })
                            count = count + 1
                        end
                    end
                end
            end
        end
        task.wait()
    end
end)

task.spawn(function()
    while true do
        local character = Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            local humanoid = character.Humanoid
            if _G.WalkSpeed then humanoid.WalkSpeed = _G.WalkSpeed end
            if _G.JumpPower then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = _G.JumpPower
            end
        end
        task.wait()
    end
end)

Rayfield:Notify({
   Title = "Script Loaded",
   Content = "All features updated.",
   Duration = 1,
   Image = 4483362458,
   Actions = {
      Ignore = {
         Name = "Okay!",
         Callback = function() end
      }
   },
})
