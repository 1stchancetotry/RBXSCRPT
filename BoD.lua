local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

_G.KillAuraEnabled = false
_G.AuraDistance = 25
_G.MaxZombies = 5
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
local Workspace = game:GetService("Workspace")

-- ========================
-- COMBAT TAB
-- ========================
local CombatTab = Window:CreateTab("Combat", 4483362458)
CombatTab:CreateSection("Kill Aura")

local KillAuraToggle = CombatTab:CreateToggle({
   Name = "Kill Aura",
   CurrentValue = false,
   Flag = "KillAuraToggle",
   Callback = function(Value) _G.KillAuraEnabled = Value end,
})

local AuraDistanceSlider = CombatTab:CreateSlider({
   Name = "Kill Aura Distance",
   Range = {10, 1000}, Increment = 5, Suffix = "Studs",
   CurrentValue = 25, Flag = "AuraDistance",
   Callback = function(Value) _G.AuraDistance = Value end,
})

local MaxZombiesSlider = CombatTab:CreateSlider({
   Name = "Max Zombies per Tick",
   Range = {1, 15}, Increment = 1, Suffix = "Targets",
   CurrentValue = 5, Flag = "MaxZombies",
   Callback = function(Value) _G.MaxZombies = Value end,
})

-- ========================
-- ITEMS TAB (SEARCH & BRING)
-- ========================
local ItemsTab = Window:CreateTab("Items", 4483362458)
ItemsTab:CreateSection("Item Scanner & Search")

-- Input Box for Item Name
local ItemSearchInput = ItemsTab:CreateInput({
   Name = "Enter Item Name",
   PlaceholderText = "e.g. Flour, Shotgun",
   RemoveTextAfterFocusLost = false,
   Flag = "ItemSearchInput",
   Callback = function(Text)
      -- Store the text in a global variable for the button to use
      _G.SearchQuery = Text
   end,
})

-- Button to Scan and Show Count
local ScanButton = ItemsTab:CreateButton({
   Name = "Scan All Items",
   Callback = function()
      local count = 0
      for _, v in pairs(Workspace:GetDescendants()) do
         if v:IsA("Model") and not v:FindFirstChild("ProductPriceTag") then
            count = count + 1
         end
      end
      Rayfield:Notify({
         Title = "Scan Complete",
         Content = "Found " .. count .. " interactable models.",
         Duration = 3
      })
   end,
})

-- Button to Bring Item by Name
local BringByNameButton = ItemsTab:CreateButton({
   Name = "Bring Item by Name",
   Callback = function()
      local query = _G.SearchQuery
      if not query or query == "" then
         Rayfield:Notify({ Title = "Error", Content = "Please enter an item name first!", Duration = 3 })
         return
      end
      
      local character = Players.LocalPlayer.Character
      if not character or not character.PrimaryPart then
         Rayfield:Notify({ Title = "Error", Content = "Character not loaded!", Duration = 3 })
         return
      end
      
      local found = false
      -- Search everywhere for the item (case-insensitive partial match)
      for _, v in pairs(Workspace:GetDescendants()) do
         if v:IsA("Model") and v.Name:lower():find(query:lower()) and v.PrimaryPart then
            v.PrimaryPart.CFrame = character.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
            found = true
            Rayfield:Notify({
               Title = "Success",
               Content = "Brought '" .. v.Name .. "' to you.",
               Duration = 3
            })
            break -- Stop after finding the first match
         end
      end
      
      if not found then
         Rayfield:Notify({
            Title = "Not Found",
            Content = "No item matching '" .. query .. "' found.",
            Duration = 3
         })
      end
   end,
})

ItemsTab:CreateSection("Bulk Actions")

-- RESTORED ORIGINAL LOGIC: Only brings bodies/corpses
local BringBodiesButton = ItemsTab:CreateButton({
   Name = "Bring All Bodies",
   Callback = function()
      local character = Players.LocalPlayer.Character
      if not character or not character.PrimaryPart then return end
      
      for _, v in pairs(Workspace:GetDescendants()) do
          if v:IsA("Model") and not v:FindFirstChild("ProductPriceTag") then
              -- Check if it's a body/corpse by name or humanoid presence
              -- This matches your original logic exactly
              if v:FindFirstChild("Humanoid") or string.match(v.Name:lower(), "body") or string.match(v.Name:lower(), "corpse") then
                  local root = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                  if root then
                      root.CFrame = character.PrimaryPart.CFrame
                  end
              end
          end
      end
      Rayfield:Notify({
         Title = "Action Complete",
         Content = "Brought all bodies/corpses to you.",
         Duration = 3
      })
   end,
})

local BringAllButton = ItemsTab:CreateButton({
   Name = "Bring All Items",
   Callback = function()
      local character = Players.LocalPlayer.Character
      if not character or not character.PrimaryPart then return end
      for _, v in pairs(Workspace:GetDescendants()) do
          if v:IsA("Model") and not v:FindFirstChild("ProductPriceTag") and v.PrimaryPart then
              v.PrimaryPart.CFrame = character.PrimaryPart.CFrame
          end
      end
      Rayfield:Notify({
         Title = "Action Complete",
         Content = "Brought all items to you.",
         Duration = 3
      })
   end,
})

-- ========================
-- PLAYER TAB
-- ========================
local PlayerTab = Window:CreateTab("Player", 4483362458)
PlayerTab:CreateSection("Character Settings")

local WalkSpeedSlider = PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 200}, Increment = 5, Suffix = "Speed",
   CurrentValue = 16, Flag = "WalkSpeed",
   Callback = function(Value) _G.WalkSpeed = Value end,
})

local JumpPowerSlider = PlayerTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 200}, Increment = 10, Suffix = "Power",
   CurrentValue = 50, Flag = "JumpPower",
   Callback = function(Value) _G.JumpPower = Value end,
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
                
                local monstersFolder = Workspace:FindFirstChild("Monsters")
                if monstersFolder then
                    for _, monster in pairs(monstersFolder:GetChildren()) do
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
   Content = "Search & Bring System Active.",
   Duration = 5,
   Image = 4483362458,
})
