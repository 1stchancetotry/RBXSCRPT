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
-- ITEMS TAB (BUTTON LIST SCANNER)
-- ========================
local ItemsTab = Window:CreateTab("Items", 4483362458)
ItemsTab:CreateSection("Item Scanner")

-- Container to hold our dynamic buttons
local ItemListContainer = ItemsTab:CreateSection("Scanned Items List")

-- Button to Scan and Create Buttons
local ScanButton = ItemsTab:CreateButton({
   Name = "Scan & Load Items",
   Callback = function()
      -- Clear previous buttons if any (Rayfield doesn't support clearing sections easily, 
      -- so we just append new ones. For a clean UI, you might need to reload the script after scanning.)
      
      local itemList = {}
      local foundCount = 0
      
      -- Search common folders
      local possibleFolders = {
         Workspace:FindFirstChild("Interactables"),
         Workspace:FindFirstChild("Drops"),
         Workspace:FindFirstChild("Items"),
         Workspace:FindFirstChild("Map"),
      }
      
      -- If no specific folder, search whole workspace
      local searchArea = Workspace
      for _, folder in pairs(possibleFolders) do
         if folder then
            searchArea = folder
            break
         end
      end

      -- Get all models
      for _, v in pairs(searchArea:GetChildren()) do
         if v:IsA("Model") and not v:FindFirstChild("ProductPriceTag") and not v:FindFirstChild("BillboardGui") then
            if not table.find(itemList, v.Name) then
               table.insert(itemList, v.Name)
               foundCount = foundCount + 1
            end
         end
      end
      
      -- Sort alphabetically
      table.sort(itemList)
      
      if #itemList > 0 then
         Rayfield:Notify({
            Title = "Scan Complete",
            Content = "Found " .. #itemList .. " items. Scroll down to see them.",
            Duration = 3
         })
         
         -- Create a button for EACH item
         for _, itemName in ipairs(itemList) do
            ItemsTab:CreateButton({
               Name = "Bring: " .. itemName,
               Callback = function()
                  BringItemToPlayer(itemName)
               end,
            })
         end
      else
         Rayfield:Notify({
            Title = "Scan Failed",
            Content = "No interactable models found.",
            Duration = 3
         })
      end
   end,
})

ItemsTab:CreateSection("Bulk Actions")

local BringBodiesButton = ItemsTab:CreateButton({
   Name = "Bring All Bodies",
   Callback = function()
      local character = Players.LocalPlayer.Character
      if not character or not character.PrimaryPart then return end
      for _, v in pairs(Workspace:GetDescendants()) do
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
