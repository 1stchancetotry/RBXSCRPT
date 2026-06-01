local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

_G.KillAuraEnabled = false
_G.AuraDistance = 25
_G.MaxZombies = 15
_G.WalkSpeed = 16
_G.JumpPower = 50

local Window = Rayfield:CreateWindow({
   Name = "Bake or Die",
   LoadingTitle = "Bake or Die Interface",
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

-- ========================
-- COMBAT TAB
-- ========================
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
   Range = {10, 1000},
   Increment = 5,
   Suffix = "Studs",
   CurrentValue = 25,
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

-- ========================
-- ITEMS TAB (SCANNER & SELECTOR)
-- ========================
local ItemsTab = Window:CreateTab("Items", 4483362458)
ItemsTab:CreateSection("Item Scanner & Selector")

-- Dropdown to hold the list of scanned items
local ItemSelectorDropdown = ItemsTab:CreateDropdown({
   Name = "Select Item to Bring",
   Options = {"Scan First"},
   CurrentOption = {"Scan First"},
   MultipleOptions = false,
   Flag = "ItemSelectorDropdown",
   Callback = function(SelectedOptions)
      -- Just updates the internal variable, no action needed here yet
   end,
})

-- Button to Scan and Populate Dropdown
local ScanButton = ItemsTab:CreateButton({
   Name = "Scan All Items",
   Callback = function()
      local itemList = {}
      local interactables = workspace:FindFirstChild("Interactables")
      
      if interactables then
         for _, v in pairs(interactables:GetChildren()) do
            -- Filter out price tags and non-models
            if v:IsA("Model") and not v:FindFirstChild("ProductPriceTag") then
               table.insert(itemList, v.Name)
            end
         end
         
         -- Sort alphabetically
         table.sort(itemList)
         
         if #itemList > 0 then
            ItemSelectorDropdown:SetOptions(itemList)
            Rayfield:Notify({
               Title = "Scan Complete",
               Content = "Found " .. #itemList .. " items. Select one below.",
               Duration = 3
            })
         else
            ItemSelectorDropdown:SetOptions({"No Items Found"})
            Rayfield:Notify({
               Title = "Scan Failed",
               Content = "No interactable items found.",
               Duration = 3
            })
         end
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "Interactables folder not found!",
            Duration = 3
         })
      end
   end,
})

-- Button to Bring ONLY the Selected Item
local BringSelectedButton = ItemsTab:CreateButton({
   Name = "Bring Selected Item",
   Callback = function()
      local selectedName = ItemSelectorDropdown.CurrentOption[1]
      local character = Players.LocalPlayer.Character
      
      if not character or not character.PrimaryPart then
         Rayfield:Notify({ Title = "Error", Content = "Character not loaded!", Duration = 3 })
         return
      end
      
      if selectedName == "Scan First" or selectedName == "No Items Found" then
         Rayfield:Notify({ Title = "Error", Content = "Please scan and select an item first!", Duration = 3 })
         return
      end
      
      local interactables = workspace:FindFirstChild("Interactables")
      if interactables then
         local found = false
         for _, v in pairs(interactables:GetChildren()) do
            if v.Name == selectedName and v:IsA("Model") and v.PrimaryPart then
               -- Teleport the specific item to the player
               v.PrimaryPart.CFrame = character.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
               found = true
               Rayfield:Notify({
                  Title = "Success",
                  Content = "Brought '" .. selectedName .. "' to you.",
                  Duration = 3
               })
               break -- Stop after finding the first match
            end
         end
         
         if not found then
            Rayfield:Notify({
               Title = "Not Found",
               Content = "Item '" .. selectedName .. "' was not found in workspace.",
               Duration = 3
            })
         end
      end
   end,
})

ItemsTab:CreateSection("Bulk Actions")

-- Keep your original Bring Bodies button
local BringBodiesButton = ItemsTab:CreateButton({
   Name = "Bring All Bodies",
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

-- ========================
-- PLAYER TAB
-- ========================
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
   CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(Value)
      _G.JumpPower = Value
   end,
})

-- ========================
-- LOOPS
-- ========================
task.spawn(function()
    while task.wait() do
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
    end
end)

task.spawn(function()
    while task.wait() do
        local character = Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            local humanoid = character.Humanoid
            if _G.WalkSpeed then humanoid.WalkSpeed = _G.WalkSpeed end
            if _G.JumpPower then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = _G.JumpPower
            end
        end
    end
end)

Rayfield:Notify({
   Title = "Bake or Die Script Loaded",
   Content = "Item Selector Added.",
   Duration = 5,
   Image = 4483362458,
   Actions = {
      Ignore = {
         Name = "Okay!",
         Callback = function() end
      }
   },
})
