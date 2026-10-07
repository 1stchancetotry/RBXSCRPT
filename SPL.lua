local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local UserInputService= game:GetService("UserInputService")
local CoreGui         = game:GetService("CoreGui")
local VirtualUser     = game:GetService("VirtualUser")
local Lighting        = game:GetService("Lighting")
local TweenService    = game:GetService("TweenService")
local HttpService     = game:GetService("HttpService")
local StarterGui      = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local Stats           = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

local function tryParent(p)
    if not p then return false end
    local ok = pcall(function() local t = Instance.new("Folder"); t.Parent = p; t:Destroy() end)
    return ok
end
local function getHiddenParent()
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui and tryParent(hui) then return hui end
    end
    if CoreGui and tryParent(CoreGui) then return CoreGui end
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pg and tryParent(pg) then return pg end
    return CoreGui
end
local HIDDEN_PARENT = getHiddenParent()

for _, name in ipairs({"SkillPointUtility","SPU_Settings","SPU_Toasts","SPU_Dialogs","SPU_Status","SPU_Radar"}) do
    local old = HIDDEN_PARENT:FindFirstChild(name)
    if old then old:Destroy() end
end

local STR = {
    tab_main="Main", tab_zones="Zones", tab_players="Players", tab_farm="Farm",
    tab_hitbox="Hitbox", tab_visual="Visual", tab_tracker="Tracker", tab_utils="Utils",
    tab_settings="Settings",
    header_settings="Settings",
    sec_server="Server", sec_jump="Jump & Movement", sec_speed="Speed", sec_flight="Flight",
    sec_radar="Radar", sec_ghost="Ghost",
    btn_server_hop="Server Hop (change server)",
    tog_inf_jump="Infinite Jump", desc_inf_jump="Jump without stopping",
    tog_speed="Speed Hack", desc_speed="Movement speed boost", lbl_speed_value="WALK SPEED",
    tog_fly="Fly (flight)", desc_fly="W/A/S/D + Space / LeftCtrl — controls", lbl_fly_speed="FLY SPEED",
    tog_radar="Radar (minimap)", desc_radar="Mobs, bosses and players around you", lbl_radar_range="RADAR RANGE",
    tog_radar_mobs="Mobs on radar", tog_radar_bosses="Bosses on radar", tog_radar_players="Players on radar",
    tog_noclip="Ghost (through walls)", desc_noclip="Walk through walls and textures",
    sec_tp="Fast teleport", sec_my_points="My points", btn_save_pos="Save current position",
    sec_bosses_top="Bosses — top weapon", sec_bosses="Bosses",
    sec_players="Player list", lbl_no_other_players="No other players", lbl_pos_unavailable="📍 Position unavailable",
    sec_autofarm="Auto farm", tog_autofarm="Auto-farm mobs", desc_autofarm="Teleport to mob + click + return",
    tog_return="Return to start", lbl_hit_delay="HIT DELAY (0.1s – 3.0s)",
    sec_mob_hitbox="Mob hitbox", tog_hitbox="Expand hitbox", desc_hitbox="Increases mob hit area",
    lbl_hitbox_size="HITBOX SIZE", btn_restore_hitboxes="Restore hitboxes",
    sec_kill_aura="Kill Aura", tog_kill_aura="Kill Aura", desc_kill_aura="Auto-attack all mobs in radius",
    lbl_kill_aura_range="KILL AURA RADIUS", lbl_kill_aura_delay="ATTACK DELAY (s)",
    sec_mob_esp="Mob ESP", tog_mob_esp="Mob ESP", desc_mob_esp="Highlight mobs through walls",
    tog_mob_hp="Mob HP", tog_mob_dist="Mob distance",
    sec_player_esp="Player ESP", tog_player_esp="Player ESP", desc_player_esp="Highlight players through walls",
    tog_player_hp="Player HP", desc_player_hp="Show player HP in ESP",
    tog_player_dist="Player distance", desc_player_dist="Show distance to player",
    sec_esp_color="ESP Color", sec_lighting="Lighting & Camera", tog_fullbright="Fullbright", desc_fullbright="Removes shadows",
    tog_nofog="Remove fog", tog_zoom="Camera zoom out", lbl_zoom_value="CAMERA DISTANCE",
    tog_tracker="Enable Mob Tracker", desc_tracker="Shows all nearby mobs", sec_stats_tracker="Statistics",
    lbl_sort="SORT", sort_dist="Dist", sort_boss="💀 Bosses", sort_hp="HP", sort_name="Name",
    stat_mobs="MOBS", stat_hp="TOTAL HP", stat_nearest="NEAREST", lbl_no_mobs="No mobs nearby",
    sec_clicker="Clicker", tog_clicker="Auto-Clicker", desc_clicker="Automatic left clicks", lbl_cps="CLICKS PER SECOND",
    sec_friends="Friends", tog_friend_notify="Friend notifications", desc_friend_notify="Chat message on friend join/leave",
    sec_perf="Performance", tog_fps="FPS Booster", desc_fps="Removes particles, shadows and effects for +FPS",
    tog_antiafk="Anti-AFK", desc_antiafk="Prevents idle kick",
    sec_configs="Configs", btn_save_config="Save config", btn_load_config="Load config", btn_reset_all="Reset settings",
    sec_theme="Theme", sec_controls="Controls", lbl_hide="Hide / show script", lbl_hide_desc="Click the button and press a key",
    sec_friends_notif="Friends (notifications)", btn_add_friend="Add friend",
    sec_social="Social", discord_open="Open →", discord_join="Join our group",
    sec_about="About me", about_text="Script made by Hirago",
    dlg_save_cfg="Save config", dlg_cfg_name="My config", dlg_cfg_name_ph="Name...",
    dlg_add_friend="Add friend", dlg_player_name="Player name...",
    dlg_enter="Enter...", dlg_cancel="Cancel", dlg_rename="Rename", dlg_new_name="New name...",
    dlg_no_configs="No saved configs", dlg_load_cfg="Load config",
    toast_script_loaded="Script loaded", toast_script_hidden="Script hidden", toast_script_shown="Script shown",
    toast_script_off="Script disabled",
    toast_search_server="Searching for server...", toast_hop="Hop: %d/%d players",
    toast_no_servers="No available servers", toast_parse_error="Server parse error",
    toast_http_unavail="HTTP unavailable", toast_wait_hop="Wait before next hop",
    toast_inf_jump_on="Infinite Jump: ON", toast_inf_jump_off="Infinite Jump: OFF",
    toast_speed_on="Speed Hack: %s", toast_speed_off="Speed Hack disabled",
    toast_fly_on="Fly: %s", toast_fly_off="Fly disabled",
    toast_radar_on="Radar enabled", toast_radar_off="Radar disabled",
    toast_ghost_on="Ghost: ON", toast_ghost_off="Ghost: OFF",
    toast_tp="Teleport: %s", toast_saved="Saved: %s",
    toast_autofarm_on="Auto-Farm started", toast_autofarm_off="Auto-Farm stopped",
    toast_return_on="Return: ON", toast_return_off="Return: OFF",
    toast_hitbox_on="Hitbox: ON (%s)", toast_hitbox_off="Hitbox: OFF", toast_hitbox_restored="Hitboxes restored",
    toast_kill_aura_on="Kill Aura: ON (radius %s)", toast_kill_aura_off="Kill Aura: OFF",
    toast_esp_mobs_on="Mob ESP: ON", toast_esp_mobs_off="Mob ESP: OFF",
    toast_esp_plr_on="Player ESP: ON", toast_esp_plr_off="Player ESP: OFF",
    toast_esp_color="ESP color: %s",
    toast_fullbright_on="Fullbright: ON", toast_fullbright_off="Fullbright: OFF",
    toast_fog_off="Fog removed", toast_fog_on="Fog restored",
    toast_cam_on="Camera: %s", toast_cam_off="Camera: OFF",
    toast_tracker_on="Mob Tracker: ON", toast_tracker_off="Mob Tracker: OFF",
    toast_clicker_on="Auto-Clicker started", toast_clicker_off="Auto-Clicker stopped",
    toast_fps_on="FPS Booster: ON", toast_fps_off="FPS Booster: OFF",
    toast_antiafk_on="Anti-AFK: ON", toast_antiafk_off="Anti-AFK: OFF",
    toast_friend_notify_on="Friend notifications: ON", toast_friend_notify_off="Friend notifications: OFF",
    toast_friend_joined="Friend joined: %s", toast_friend_left="Friend left: %s",
    toast_friend_added="Added: %s", toast_friend_removed="Removed: %s",
    toast_key_hide="Hide key: %s", toast_tp_mob="Teleport to %s", toast_to_mob="To %s",
    toast_cfg_saved="Config saved: %s", toast_cfg_save_err="Save error",
    toast_cfg_deleted="Config deleted: %s", toast_cfg_busy="File busy — try later",
    toast_cfg_del_fail="Failed to delete", toast_cfg_loaded="Loaded: %s",
    toast_reset_settings="Settings reset",
    toast_theme="Theme: %s", toast_link_copied="Link copied", toast_link_buffer="Link in buffer — paste in browser",
    toast_fs_unavail="FS not available",
    toast_hide_hint="Script hidden  ·  %s to return",
    chat_friend_joined="🟢 Friend joined: %s", chat_friend_left="🔴 Friend left: %s",
    player_tp_to="Teleport to %s", player_pos_unavail="Position of %s unavailable",
}
local function T(key, ...)
    local s = STR[key] or key
    if select("#", ...) > 0 then
        local ok, res = pcall(string.format, s, ...)
        if ok then return res end
    end
    return s
end

local textRegistry = {}
local function regLang(inst, key)
    inst:SetAttribute("_langKey", key)
    inst.Text = T(key)
    table.insert(textRegistry, inst)
    return inst
end
local function refreshAllLang()
    for _, inst in ipairs(textRegistry) do
        if inst and inst.Parent then
            local k = inst:GetAttribute("_langKey")
            local sk = inst:GetAttribute("_langSectionKey")
            if sk then
                local icon = inst:GetAttribute("_langSectionIcon") or ""
                inst.Text = (icon ~= "" and (icon.."  ") or "")..string.upper(T(sk))
            elseif k and (inst:IsA("TextLabel") or inst:IsA("TextButton")) then
                inst.Text = T(k)
            end
        end
    end
end

local CONFIG_PREFIX = "SPU_config_"
local FRIENDS_FILE = "SPU_friends.json"
local FS_AVAILABLE = (writefile ~= nil) and (readfile ~= nil) and (isfile ~= nil) and (delfile ~= nil)
local LIST_AVAILABLE = FS_AVAILABLE and (listfiles ~= nil)

local _silentDepth = 0
local function isSilent() return _silentDepth > 0 end
local function enterSilent() _silentDepth = _silentDepth + 1 end
local function exitSilentDelayed(delay)
    task.delay(delay or 0.8, function() _silentDepth = math.max(0, _silentDepth - 1) end)
end

local recentlyDeleted = {}
local RECENT_DELETE_TTL = 2.5
local openConfigLists = {}

local TrackedConnections = {}
local isShuttingDown = false
local _shutdownHooks = {}
local function track(conn) if conn then table.insert(TrackedConnections, conn) end return conn end
local function disconnectAll()
    for _, c in ipairs(TrackedConnections) do pcall(function() c:Disconnect() end) end
    TrackedConnections = {}
end
local shutdown

local _hbTasks = {}
local _hbCounter = 0
local function scheduleHeartbeat(fn, intervalSec, name)
    _hbCounter = _hbCounter + 1
    local id = name or ("hb_" .. _hbCounter)
    _hbTasks[id] = { fn = fn, interval = intervalSec, acc = 0 }
    return id
end
local function unscheduleHeartbeat(id) _hbTasks[id] = nil end

track(RunService.Heartbeat:Connect(function(dt)
    if isShuttingDown then return end
    local ids = {}
    for id in pairs(_hbTasks) do ids[#ids+1] = id end
    for i = 1, #ids do
        local t = _hbTasks[ids[i]]
        if t then
            t.acc = t.acc + dt
            if t.acc >= t.interval then
                t.acc = 0
                pcall(t.fn)
            end
        end
    end
end))

local DS = {
    R = { window=22, panel=16, card=14, button=12, chip=10, small=8, round=999 },
    S = { xs=4, sm=6, md=10, lg=14, xl=20 },
    A = { fast=0.14, normal=0.22, slow=0.32,
          ease=Enum.EasingStyle.Quint, easeOut=Enum.EasingStyle.Quad },
    F = { title=Enum.Font.GothamBold, bold=Enum.Font.GothamBold,
          body=Enum.Font.GothamMedium, subtle=Enum.Font.Gotham, mono=Enum.Font.Code },
    Z = { header=62, sidebar=192, tabH=42, rowH=50, toastW=340, toastH=64 },
}

local T2 = {
    Radius = { window=DS.R.window, card=DS.R.card, button=DS.R.button, small=DS.R.small, pill=DS.R.round },
    Size   = { windowW=720, windowH=500, header=DS.Z.header, sidebar=DS.Z.sidebar, tabH=DS.Z.tabH, rowH=DS.Z.rowH },
}

local THEMES = {
    {name="Purple", bg=Color3.fromRGB(20,17,28), bgAlt=Color3.fromRGB(28,24,38), card=Color3.fromRGB(36,31,48), hover=Color3.fromRGB(46,40,60), accent=Color3.fromRGB(155,120,255), accent2=Color3.fromRGB(200,170,255)},
    {name="Blue",   bg=Color3.fromRGB(14,18,28), bgAlt=Color3.fromRGB(20,26,38), card=Color3.fromRGB(28,34,50), hover=Color3.fromRGB(38,46,64), accent=Color3.fromRGB(90,150,240),  accent2=Color3.fromRGB(150,195,255)},
    {name="Green",  bg=Color3.fromRGB(14,22,17), bgAlt=Color3.fromRGB(20,30,24), card=Color3.fromRGB(28,40,34), hover=Color3.fromRGB(38,52,44), accent=Color3.fromRGB(90,205,135),  accent2=Color3.fromRGB(160,235,190)},
    {name="Red",    bg=Color3.fromRGB(26,15,18), bgAlt=Color3.fromRGB(36,22,26), card=Color3.fromRGB(48,30,36), hover=Color3.fromRGB(62,40,48), accent=Color3.fromRGB(230,105,115), accent2=Color3.fromRGB(255,170,150)},
    {name="Pink",   bg=Color3.fromRGB(26,15,22), bgAlt=Color3.fromRGB(36,24,34), card=Color3.fromRGB(48,34,46), hover=Color3.fromRGB(62,46,60), accent=Color3.fromRGB(240,125,185), accent2=Color3.fromRGB(255,185,225)},
    {name="Gold",   bg=Color3.fromRGB(22,20,14), bgAlt=Color3.fromRGB(32,28,20), card=Color3.fromRGB(46,40,28), hover=Color3.fromRGB(60,52,38), accent=Color3.fromRGB(240,190,90),  accent2=Color3.fromRGB(255,225,150)},
    {name="Dark",   bg=Color3.fromRGB(10,10,12), bgAlt=Color3.fromRGB(16,16,20), card=Color3.fromRGB(24,24,30), hover=Color3.fromRGB(34,34,42), accent=Color3.fromRGB(150,150,180), accent2=Color3.fromRGB(200,200,225)},
    {name="Cyan",   bg=Color3.fromRGB(12,20,24), bgAlt=Color3.fromRGB(18,30,36), card=Color3.fromRGB(26,42,50), hover=Color3.fromRGB(36,54,64), accent=Color3.fromRGB(85,200,210),  accent2=Color3.fromRGB(150,240,235)},
    {name="Glass",  bg=Color3.fromRGB(20,20,28), bgAlt=Color3.fromRGB(28,28,38), card=Color3.fromRGB(38,38,48), hover=Color3.fromRGB(48,48,60),
        accent=Color3.fromRGB(180,140,255), accent2=Color3.fromRGB(140,220,255),
        bgTransparency=0.88, bgAltTransparency=0.72, cardTransparency=0.55, hoverTransparency=0.5, forceLightText=true},
}
local currentTheme = THEMES[1]

local Config = {
    InfiniteJump=false, HitboxEnabled=false, HitboxSize=15,
    Noclip=false,
    SpeedHack=false, SpeedValue=100,
    FlyEnabled=false, FlySpeed=60,
    Radar=false, RadarRange=300, RadarShowMobs=true, RadarShowBosses=true, RadarShowPlayers=true,
    FPSBooster=false,
    ESPEnabled=false, ESPShowHP=true, ESPShowDist=true,
    ESPPlayers=false, ESPPlayersShowHP=true, ESPPlayersShowDist=true,
    ESPColor=Color3.fromRGB(255,60,60), Fullbright=false, NoFog=false,
    ZoomEnabled=false, ZoomValue=500, AntiAFK=false, MobTracker=false,
    AutoFarm=false, AutoFarmDelay=0.8, AutoFarmReturn=true,
    KillAura=false, KillAuraRange=300, KillAuraDelay=0.15,
    AutoClicker=false, AutoClickerCPS=10, NotifyFriends=true,
    ToggleKey = Enum.KeyCode.Delete,
}
local savedFriends = {}
local capturingKey = false
local keybindBtn = nil
local showInputDialog
local savedPositions, favoritedPoints, rebuildSavedList
local isDialogOpen = false

local C = {
    bg=THEMES[1].bg, bgAlt=THEMES[1].bgAlt, card=THEMES[1].card,
    hover=THEMES[1].hover, accent=THEMES[1].accent, accent2=THEMES[1].accent2,
    success=Color3.fromRGB(80,220,130), danger=Color3.fromRGB(255,90,100),
    warn=Color3.fromRGB(255,190,80), gold=Color3.fromRGB(255,200,60),
    text=Color3.fromRGB(240,240,250), textDim=Color3.fromRGB(150,150,175),
    textMuted=Color3.fromRGB(110,110,135),
    border=Color3.fromRGB(48,48,62), borderLight=Color3.fromRGB(60,60,78),
}

local ZONES = {
    {name="🌱 Grassland",      coords=Vector3.new(635,4,958)},
    {name="👑 Cursed Kingdom", coords=Vector3.new(659,175,-649)},
    {name="☁ Heaven",          coords=Vector3.new(544,406,-2258)},
    {name="🏜 Crown of Sand",  coords=Vector3.new(629,90,-3591)},
    {name="🌋 Molten Peaks",   coords=Vector3.new(25875,-290,-3798)},
    {name="🧚 Fairyland",      coords=Vector3.new(761,95,-9238)},
}

local BOSSES = {
    {name="💀 Ashgor",   coords=Vector3.new(637,   2,  844), note="Event"},
    {name="🐂 Minotaur", coords=Vector3.new(674, -94,  594), note="Top weapon"},
}

local BOSSES_BY_ZONE = {
    {zone="🌱 Grassland", bosses={
        {name="Chief",      coords=Vector3.new(666, 4, 211)},
        {name="Dino",       coords=Vector3.new(939, 68, 233)},
        {name="Arachinex",  coords=Vector3.new(324, 68, 241)},
    }},
    {zone="👑 Cursed Kingdom", bosses={
        {name="Grimroot",   coords=Vector3.new(618, 157, -199)},
        {name="Leonidas",   coords=Vector3.new(617, 175, -649)},
    }},
    {zone="☁ Heaven", bosses={
        {name="Lightning God", coords=Vector3.new(631, 406, -2187)},
    }},
    {zone="🏜 Crown of Sand", bosses={
        {name="Sand Golem", coords=Vector3.new(782, 90, -3469)},
        {name="Hydra Worm", coords=Vector3.new(483, 92, -3604)},
        {name="Dragon",     coords=Vector3.new(608, 333, -3765)},
    }},
    {zone="🌋 Molten Peaks", bosses={
        {name="Nevermore",  coords=Vector3.new(26057, -399, -3319)},
        {name="Simba",      coords=Vector3.new(25792, -318, -3563)},
        {name="Anubis",     coords=Vector3.new(25798, -287, -3886)},
    }},
    {zone="🧚 Fairyland", bosses={
        {name="Eyegor",            coords=Vector3.new(587, 202, -9186)},
        {name="BloodrootWitch",    coords=Vector3.new(216, 95, -9524)},
        {name="Queen of Serpents", coords=Vector3.new(467, -137, -9222)},
    }},
}

local TRANSP_FIELD = { bg="bgTransparency", bgAlt="bgAltTransparency", card="cardTransparency", hover="hoverTransparency" }
local TEXT_ROLES = {
    text = Color3.fromRGB(240,240,250),
    textDim = Color3.fromRGB(150,150,175),
    textMuted = Color3.fromRGB(110,110,135),
}
local GLASS_PLACEHOLDER = Color3.fromRGB(200,200,215)

local new, corner, stroke, gradient, drawCrossIcon, applyGlassTextTo
do
    local function findRole(color)
        for _, t in ipairs(THEMES) do
            if color == t.bg then return "bg" end
            if color == t.bgAlt then return "bgAlt" end
            if color == t.card then return "card" end
            if color == t.hover then return "hover" end
            if color == t.accent then return "accent" end
            if color == t.accent2 then return "accent2" end
        end
        return nil
    end
    local function findTextRole(color)
        for role, c in pairs(TEXT_ROLES) do if color == c then return role end end
        return nil
    end

    applyGlassTextTo = function(inst)
        if not currentTheme.forceLightText then return end
        if not (inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox")) then return end
        local role = inst:GetAttribute("_textRole")
        local newColor = Color3.fromRGB(245,245,255)
        if role == "textDim" then newColor = Color3.fromRGB(215,215,235)
        elseif role == "textMuted" then newColor = Color3.fromRGB(190,190,215) end
        inst.TextColor3 = newColor
        inst.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        inst.TextStrokeTransparency = 0.15
        if inst:IsA("TextBox") then inst.PlaceholderColor3 = GLASS_PLACEHOLDER end
    end

    local function applyTransparencyToElement(inst)
        local bgRole = inst:GetAttribute("_bgRole")
        if not bgRole then return end
        local field = TRANSP_FIELD[bgRole]
        if not field then return end
        local baseTransp = inst:GetAttribute("_baseTransp") or 0
        if baseTransp > 0 then return end
        inst.BackgroundTransparency = currentTheme[field] or 0
    end

    new = function(class, props)
        local inst = Instance.new(class)
        for k, v in pairs(props or {}) do if k ~= "Parent" then inst[k] = v end end
        if props and props.Parent then inst.Parent = props.Parent end
        if inst:IsA("GuiObject") then
            inst:SetAttribute("_baseTransp", inst.BackgroundTransparency)
            local bgRole = findRole(inst.BackgroundColor3)
            if bgRole then
                inst:SetAttribute("_bgRole", bgRole)
                inst:SetAttribute("_baseColor", inst.BackgroundColor3)
            end
            if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
                local textRole = findTextRole(inst.TextColor3)
                if textRole then inst:SetAttribute("_textRole", textRole) end
                applyGlassTextTo(inst)
            end
            applyTransparencyToElement(inst)
        end
        return inst
    end

    corner = function(p, r) return new("UICorner", { CornerRadius = UDim.new(0, r or DS.R.card), Parent = p }) end
    stroke = function(p, c, t, tr)
        local actualColor = c or C.border
        local s = new("UIStroke", {
            Color=actualColor, Thickness=t or 1, Transparency=tr or 0,
            ApplyStrokeMode=Enum.ApplyStrokeMode.Border, Parent=p
        })
        local role = findRole(actualColor)
        if role then s:SetAttribute("_strokeRole", role) end
        return s
    end
    gradient = function(p, c1, c2, r)
        local gr = new("UIGradient", { Color=ColorSequence.new(c1,c2), Rotation=r or 0, Parent=p })
        local r1, r2 = findRole(c1), findRole(c2)
        if r1 and r2 then gr:SetAttribute("_gRole1", r1) gr:SetAttribute("_gRole2", r2) end
        return gr
    end
    drawCrossIcon = function(btn, lineColor, size)
        lineColor = lineColor or Color3.fromRGB(255,255,255)
        size = size or 12
        btn.Text = ""
        local th = 2
        local l1 = new("Frame", { Size=UDim2.new(0,size,0,th), Position=UDim2.new(0.5,0,0.5,0),
            AnchorPoint=Vector2.new(0.5,0.5), Rotation=45, BackgroundColor3=lineColor, BorderSizePixel=0, Parent=btn })
        corner(l1, 1)
        local l2 = new("Frame", { Size=UDim2.new(0,size,0,th), Position=UDim2.new(0.5,0,0.5,0),
            AnchorPoint=Vector2.new(0.5,0.5), Rotation=-45, BackgroundColor3=lineColor, BorderSizePixel=0, Parent=btn })
        corner(l2, 1)
        return l1, l2
    end
end

local function protectGui(gui)
    if not gui then return end
    if syn and syn.protect_gui then pcall(syn.protect_gui, gui) return end
    if KRNL_LOADED and protect_gui then pcall(protect_gui, gui) return end
    if protect_gui then pcall(protect_gui, gui) return end
end

local function createCloseButton(parent, size, callback)
    size = size or 30
    local btn = new("TextButton", {
        Size=UDim2.new(0,size,0,size), BackgroundColor3=C.card, Text="",
        BorderSizePixel=0, AutoButtonColor=false, Parent=parent
    })
    corner(btn, DS.R.small)
    local l1, l2 = drawCrossIcon(btn, C.textDim, math.floor(size*0.5))
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(DS.A.fast), { BackgroundColor3=C.danger }):Play()
        TweenService:Create(l1, TweenInfo.new(DS.A.fast), { BackgroundColor3=Color3.fromRGB(255,255,255) }):Play()
        TweenService:Create(l2, TweenInfo.new(DS.A.fast), { BackgroundColor3=Color3.fromRGB(255,255,255) }):Play()
    end)
    btn.MouseLeave:Connect(function()
        local restore = btn:GetAttribute("_baseColor") or C.card
        TweenService:Create(btn, TweenInfo.new(DS.A.fast), { BackgroundColor3=restore }):Play()
        TweenService:Create(l1, TweenInfo.new(DS.A.fast), { BackgroundColor3=C.textDim }):Play()
        TweenService:Create(l2, TweenInfo.new(DS.A.fast), { BackgroundColor3=C.textDim }):Play()
    end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createDeleteButton(parent, size, callback)
    size = size or 28
    local btn = new("TextButton", {
        Size=UDim2.new(0,size,0,size), BackgroundColor3=C.danger, Text="",
        BackgroundTransparency=0.15, BorderSizePixel=0, AutoButtonColor=false, Parent=parent
    })
    corner(btn, DS.R.small)
    drawCrossIcon(btn, Color3.fromRGB(255,255,255), math.floor(size*0.42))
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(DS.A.fast), { BackgroundTransparency=0 }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(DS.A.fast), { BackgroundTransparency=0.15 }):Play()
    end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local toastGui = new("ScreenGui", {
    Name="SPU_Toasts", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset=true, DisplayOrder=500, Parent=HIDDEN_PARENT
})
local dialogGui = new("ScreenGui", {
    Name="SPU_Dialogs", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset=true, DisplayOrder=999, Parent=HIDDEN_PARENT
})
local statusGui = new("ScreenGui", {
    Name="SPU_Status", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset=true, DisplayOrder=99999, Parent=HIDDEN_PARENT
})
protectGui(dialogGui)
protectGui(statusGui)

local showToast, chatNotify
do
    local toastStack = {}
    local MAX_TOASTS = 4
    local TOAST_GAP = 8
    local TOAST_LIFETIME = 3.2

    local function relayoutToasts()
        task.defer(function()
            local y = 16
            for _, t in ipairs(toastStack) do
                if t.Parent then
                    TweenService:Create(t, TweenInfo.new(DS.A.normal, DS.A.easeOut), {
                        Position = UDim2.new(1, -(DS.Z.toastW + 20), 0, y)
                    }):Play()
                    y = y + DS.Z.toastH + TOAST_GAP
                end
            end
        end)
    end

    local function removeToast(toast, instant)
        for i, t in ipairs(toastStack) do if t == toast then table.remove(toastStack, i) break end end
        if toast.Parent then
            if instant then toast:Destroy()
            else
                TweenService:Create(toast, TweenInfo.new(DS.A.normal), {
                    BackgroundTransparency = 1, Position = UDim2.new(1, 30, toast.Position.Y.Scale, toast.Position.Y.Offset)
                }):Play()
                for _, ch in ipairs(toast:GetDescendants()) do
                    if ch:IsA("TextLabel") then TweenService:Create(ch, TweenInfo.new(DS.A.normal), { TextTransparency = 1 }):Play()
                    elseif ch:IsA("Frame") then TweenService:Create(ch, TweenInfo.new(DS.A.normal), { BackgroundTransparency = 1 }):Play()
                    elseif ch:IsA("UIStroke") then TweenService:Create(ch, TweenInfo.new(DS.A.normal), { Transparency = 1 }):Play()
                    end
                end
                task.delay(DS.A.normal + 0.05, function() if toast.Parent then toast:Destroy() end end)
            end
        end
        relayoutToasts()
    end

    showToast = function(text, color, icon)
        if isSilent() or isShuttingDown then return end
        color = color or C.accent
        icon = icon or "•"
        while #toastStack >= MAX_TOASTS do removeToast(toastStack[1], true) end
        local idx = #toastStack + 1
        local targetY = 16 + (idx-1) * (DS.Z.toastH + TOAST_GAP)
        local toast = new("Frame", {
            Size = UDim2.new(0, DS.Z.toastW, 0, DS.Z.toastH),
            Position = UDim2.new(1, 30, 0, targetY),
            BackgroundColor3 = C.card, BackgroundTransparency = 0.02,
            BorderSizePixel = 0, Parent = toastGui
        })
        corner(toast, DS.R.card)
        gradient(toast, C.card, C.bgAlt, 135)
        local accentBar = new("Frame", {
            Size=UDim2.new(0,3,1,-16), Position=UDim2.new(0,8,0,8),
            BackgroundColor3=color, BorderSizePixel=0, Parent=toast
        })
        corner(accentBar, DS.R.round)
        stroke(toast, color, 1, 0.55)
        local iconBox = new("Frame", {
            Size=UDim2.new(0,36,0,36), Position=UDim2.new(0,18,0.5,-18),
            BackgroundColor3=color, BackgroundTransparency=0.82, BorderSizePixel=0, Parent=toast
        })
        corner(iconBox, DS.R.round)
        local ring = stroke(iconBox, color, 1.2)
        ring.Transparency = 0.35
        new("TextLabel", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
            Text=icon, TextColor3=color, Font=DS.F.bold, TextSize=18, Parent=iconBox })
        local title, msg = text, ""
        local sep = text:find("[%:%.%-]")
        if sep and sep > 2 and sep < #text then
            title = text:sub(1, sep-1)
            msg = text:sub(sep+1):gsub("^%s+", "")
        end
        new("TextLabel", { Size=UDim2.new(1, -110, 0, 16), Position=UDim2.new(0, 66, 0, 13),
            BackgroundTransparency=1, Text=title, TextColor3=C.text, Font=DS.F.bold, TextSize=13,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=toast })
        if msg ~= "" then
            new("TextLabel", { Size=UDim2.new(1, -110, 0, 14), Position=UDim2.new(0, 66, 0, 31),
                BackgroundTransparency=1, Text=msg, TextColor3=C.textDim, Font=DS.F.subtle, TextSize=11,
                TextXAlignment=Enum.TextXAlignment.Left, Parent=toast })
        end
        local progressBg = new("Frame", { Size=UDim2.new(1, -36, 0, 3), Position=UDim2.new(0, 18, 1, -10),
            BackgroundColor3=color, BackgroundTransparency=0.75, BorderSizePixel=0, Parent=toast })
        corner(progressBg, DS.R.round)
        local progressFill = new("Frame", { Size=UDim2.new(1, 0, 1, 0), BackgroundColor3=color, BorderSizePixel=0, Parent=progressBg })
        corner(progressFill, DS.R.round)
        table.insert(toastStack, toast)
        TweenService:Create(toast, TweenInfo.new(DS.A.slow, DS.A.ease), {
            Position = UDim2.new(1, -(DS.Z.toastW + 20), 0, targetY) }):Play()
        TweenService:Create(progressFill, TweenInfo.new(TOAST_LIFETIME, Enum.EasingStyle.Linear), {
            Size = UDim2.new(0, 0, 1, 0) }):Play()
        task.delay(TOAST_LIFETIME, function() removeToast(toast) end)
    end

    chatNotify = function(text)
        pcall(function()
            StarterGui:SetCore("ChatMakeSystemMessage", { Text="[SPU] "..text, Color=C.accent, Font=Enum.Font.SourceSansBold })
        end)
    end
end

local showStatus, hideStatus
do
    local statusFrame = new("Frame", {
        Size=UDim2.new(0,260,0,40),
        Position=UDim2.new(1,-20,1,-20),
        AnchorPoint=Vector2.new(1,1),
        BackgroundColor3=Color3.fromRGB(20,20,26), BackgroundTransparency=0.05,
        BorderSizePixel=0, Visible=false, Parent=statusGui
    })
    corner(statusFrame, DS.R.card)
    gradient(statusFrame, Color3.fromRGB(24,24,30), Color3.fromRGB(18,18,24), 135)
    local statusStroke = stroke(statusFrame, Color3.fromRGB(120,120,140), 1.2)
    local statusIconBox = new("Frame", {
        Size=UDim2.new(0,26,0,26), Position=UDim2.new(0,8,0.5,-13),
        BackgroundColor3=Color3.fromRGB(255,200,80), BackgroundTransparency=0.82,
        BorderSizePixel=0, Parent=statusFrame
    })
    corner(statusIconBox, DS.R.round)
    local statusIconStroke = stroke(statusIconBox, Color3.fromRGB(255,200,80), 1.2)
    statusIconStroke.Transparency = 0.35
    local statusIconLbl = new("TextLabel", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
        Text="⚡", TextColor3=Color3.fromRGB(255,200,80), Font=DS.F.bold, TextSize=13, Parent=statusIconBox })
    local statusLabel = new("TextLabel", { Size=UDim2.new(1,-50,1,0), Position=UDim2.new(0,42,0,0),
        BackgroundTransparency=1, Text="", TextColor3=Color3.fromRGB(255,255,255),
        Font=DS.F.bold, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, Parent=statusFrame })

    local statusHideTask = nil
    showStatus = function(text, color, autoHideAfter)
        if statusHideTask then pcall(function() task.cancel(statusHideTask) end) statusHideTask = nil end
        statusLabel.Text = text
        statusLabel.TextColor3 = color
        statusLabel.TextTransparency = 0
        statusIconBox.BackgroundColor3 = color
        statusIconBox.BackgroundTransparency = 0.82
        statusIconLbl.TextColor3 = color
        statusIconStroke.Color = color
        statusIconStroke.Transparency = 0.35
        statusStroke.Color = color
        statusStroke.Transparency = 0.4
        statusFrame.BackgroundTransparency = 0.05
        statusFrame.Visible = true
        if autoHideAfter then
            statusHideTask = task.delay(autoHideAfter, function()
                for i = 0, 20 do
                    if not statusFrame or not statusFrame.Parent then return end
                    local t = i / 20
                    statusFrame.BackgroundTransparency = math.min(1, 0.05 + t * 0.95)
                    statusLabel.TextTransparency = t
                    statusStroke.Transparency = math.min(1, 0.4 + t * 0.6)
                    task.wait(0.025)
                end
                if statusFrame and statusFrame.Parent then statusFrame.Visible = false end
                statusHideTask = nil
            end)
        end
    end
    hideStatus = function()
        if statusHideTask then pcall(function() task.cancel(statusHideTask) end) statusHideTask = nil end
        statusFrame.Visible = false
    end
end

local screenGui = new("ScreenGui", {
    Name="SkillPointUtility", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset=true, DisplayOrder=10, Parent=HIDDEN_PARENT
})
protectGui(screenGui)

local main = new("Frame", {
    Size=UDim2.new(0,T2.Size.windowW,0,T2.Size.windowH),
    Position=UDim2.new(0.5,-T2.Size.windowW/2,0.5,-T2.Size.windowH/2),
    BackgroundColor3=C.bg, BorderSizePixel=0, Parent=screenGui,
    ClipsDescendants=true,
})
corner(main, DS.R.window)
local mainStroke = stroke(main, C.border, 1.2)

local header = new("Frame", {
    Size=UDim2.new(1,0,0,T2.Size.header),
    BackgroundColor3=C.bgAlt, BorderSizePixel=0, Parent=main
})
corner(header, DS.R.window)
new("Frame", { Size=UDim2.new(1,0,0,DS.R.window), Position=UDim2.new(0,0,1,-DS.R.window),
    BackgroundColor3=C.bgAlt, BorderSizePixel=0, Parent=header })
new("Frame", { Size=UDim2.new(1,-32,0,1), Position=UDim2.new(0,16,1,-1),
    BackgroundColor3=C.border, BackgroundTransparency=0.4, BorderSizePixel=0, Parent=header })

do
    local logoBox = new("Frame", { Size=UDim2.new(0,36,0,36), Position=UDim2.new(0,20,0.5,-18),
        BackgroundColor3=C.accent, BorderSizePixel=0, Parent=header })
    corner(logoBox, DS.R.chip)
    gradient(logoBox, C.accent, C.accent2, 135)
    stroke(logoBox, C.accent2, 1, 0.6)
    new("TextLabel", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
        Text="⚡", Font=DS.F.bold, TextSize=20, TextColor3=Color3.fromRGB(255,255,255), Parent=logoBox })
end

local titleLbl = new("TextLabel", { Size=UDim2.new(0,220,0,18), Position=UDim2.new(0,68,0,14),
    BackgroundTransparency=1, Text="Skill Point Legends", TextColor3=C.text,
    Font=DS.F.title, TextSize=15, TextXAlignment=Enum.TextXAlignment.Left, Parent=header })
local subtitleLbl = new("TextLabel", { Size=UDim2.new(0,220,0,14), Position=UDim2.new(0,68,0,34),
    BackgroundTransparency=1, Text="Utility v29", TextColor3=C.textMuted,
    Font=DS.F.subtle, TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, Parent=header })

local miniBtn = new("TextButton", { Size=UDim2.new(0,30,0,30), Position=UDim2.new(1,-78,0.5,-15),
    BackgroundColor3=C.card, Text="", BorderSizePixel=0, AutoButtonColor=false, Parent=header })
corner(miniBtn, DS.R.small)
do
    local miniLine = new("Frame", { Size=UDim2.new(0,12,0,2), Position=UDim2.new(0.5,0,0.5,0),
        AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=C.textDim, BorderSizePixel=0, Parent=miniBtn })
    corner(miniLine, DS.R.round)
    miniBtn.MouseEnter:Connect(function()
        TweenService:Create(miniBtn, TweenInfo.new(DS.A.fast), { BackgroundColor3=C.hover }):Play()
        TweenService:Create(miniLine, TweenInfo.new(DS.A.fast), { BackgroundColor3=C.text }):Play()
    end)
    miniBtn.MouseLeave:Connect(function()
        local restore = miniBtn:GetAttribute("_baseColor") or C.card
        TweenService:Create(miniBtn, TweenInfo.new(DS.A.fast), { BackgroundColor3=restore }):Play()
        TweenService:Create(miniLine, TweenInfo.new(DS.A.fast), { BackgroundColor3=C.textDim }):Play()
    end)
end

local closeBtn = createCloseButton(header, 30, function() if shutdown then shutdown() end end)
closeBtn.Position = UDim2.new(1,-42,0.5,-15)

local serverInfoLbl = new("TextLabel", {
    Size=UDim2.new(0,180,0,22),
    Position=UDim2.new(1,-440,0.5,-11),
    BackgroundTransparency=1,
    Text="Ping --ms  ·  FPS --  ·  --/--",
    TextColor3=C.danger,
    Font=DS.F.mono,
    TextSize=11,
    TextXAlignment=Enum.TextXAlignment.Right,
    Parent=header
})
serverInfoLbl:SetAttribute("_textRole", nil)
serverInfoLbl:SetAttribute("_customTextColor", C.danger)

local minimized, savedSize, savedMainBg, savedMainTransparency = false, main.Size, main.BackgroundColor3, main.BackgroundTransparency

local sidebar = new("Frame", { Size=UDim2.new(0,T2.Size.sidebar,1,-(T2.Size.header+28)),
    Position=UDim2.new(0,14,0,T2.Size.header+14),
    BackgroundColor3=C.bgAlt, BorderSizePixel=0, Parent=main })
corner(sidebar, DS.R.card)
stroke(sidebar, C.border, 1, 0.4)

local sidebarTabs = new("ScrollingFrame", {
    Size=UDim2.new(1,0,1,-64), BackgroundTransparency=1, BorderSizePixel=0,
    ScrollBarThickness=4, ScrollBarImageColor3=C.accent, ScrollBarImageTransparency=0.35,
    CanvasSize=UDim2.new(0,0,0,0),
    AutomaticCanvasSize=Enum.AutomaticSize.Y, Parent=sidebar
})
new("UIListLayout", { Padding=UDim.new(0,4), SortOrder=Enum.SortOrder.LayoutOrder,
    HorizontalAlignment=Enum.HorizontalAlignment.Center,
    VerticalAlignment=Enum.VerticalAlignment.Top, Parent=sidebarTabs })
new("UIPadding", { PaddingTop=UDim.new(0,10), PaddingBottom=UDim.new(0,8),
    PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,12), Parent=sidebarTabs })

local settingsBar = new("Frame", { Size=UDim2.new(1,0,0,56), Position=UDim2.new(0,0,1,-56),
    BackgroundTransparency=1, Parent=sidebar })
new("Frame", { Size=UDim2.new(1,-24,0,1), Position=UDim2.new(0,12,0,0),
    BackgroundColor3=C.border, BackgroundTransparency=0.4, BorderSizePixel=0, Parent=settingsBar })
local settingsBtn = new("TextButton", { Size=UDim2.new(1,-16,0,40), Position=UDim2.new(0,8,0.5,-20),
    BackgroundColor3=C.card, Text="", BorderSizePixel=0, AutoButtonColor=false, Parent=settingsBar })
corner(settingsBtn, DS.R.card)
stroke(settingsBtn, C.border, 1, 0.5)
local settingsIcon = new("TextLabel", { Size=UDim2.new(0,24,1,0), Position=UDim2.new(0,14,0,0),
    BackgroundTransparency=1, Text="⚙", TextColor3=C.textDim, Font=DS.F.bold, TextSize=15,
    TextXAlignment=Enum.TextXAlignment.Center, Parent=settingsBtn })
local settingsLabel = regLang(new("TextLabel", { Size=UDim2.new(1,-42,1,0), Position=UDim2.new(0,42,0,0),
    BackgroundTransparency=1, TextColor3=C.textDim,
    Font=DS.F.body, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, Parent=settingsBtn }), "header_settings")

local contentFrame = new("Frame", {
    Size=UDim2.new(1,-(T2.Size.sidebar+38),1,-(T2.Size.header+28)),
    Position=UDim2.new(0,T2.Size.sidebar+28,0,T2.Size.header+14),
    BackgroundTransparency=1, Parent=main })

do
    local MINI_WIDTH = 148
    miniBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            savedSize, savedMainBg, savedMainTransparency = main.Size, main.BackgroundColor3, main.BackgroundTransparency
            sidebar.Visible = false
            contentFrame.Visible = false
            titleLbl.Visible = false
            subtitleLbl.Visible = false
            serverInfoLbl.Visible = false
            main.BackgroundColor3, main.BackgroundTransparency, mainStroke.Transparency = C.bgAlt, 0, 1
            TweenService:Create(main, TweenInfo.new(0.28, DS.A.ease, Enum.EasingDirection.Out), {
                Size=UDim2.new(0,MINI_WIDTH,0,T2.Size.header) }):Play()
        else
            main.BackgroundColor3, main.BackgroundTransparency, mainStroke.Transparency = savedMainBg, savedMainTransparency, 0
            TweenService:Create(main, TweenInfo.new(0.28, DS.A.ease, Enum.EasingDirection.Out), { Size=savedSize }):Play()
            task.delay(0.2, function()
                sidebar.Visible = true
                contentFrame.Visible = true
                titleLbl.Visible = true
                subtitleLbl.Visible = true
                serverInfoLbl.Visible = true
            end)
        end
    end)
end

do
    local dragging, dragStart, startPos
    local function isOverHeaderControl(pos)
        for _, btn in ipairs({miniBtn, closeBtn}) do
            if btn and btn.Parent then
                local ap, asz = btn.AbsolutePosition, btn.AbsoluteSize
                if pos.X>=ap.X and pos.X<=ap.X+asz.X and pos.Y>=ap.Y and pos.Y<=ap.Y+asz.Y then return true end
            end
        end
        return false
    end
    track(header.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            if isOverHeaderControl(Vector2.new(input.Position.X, input.Position.Y)) then return end
            dragging = true dragStart = input.Position startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then dragging=false end
            end)
        end
    end))
    track(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
        end
    end))
end

local tabContents, activeTab = {}, nil
local function switchTab(name)
    if activeTab == name then return end
    activeTab = name
    for n, data in pairs(tabContents) do
        local isActive = (n == name)
        data.page.Visible = isActive
        if isActive then
            data.button:SetAttribute("_bgRole", "card")
            data.button:SetAttribute("_baseColor", C.card)
            TweenService:Create(data.button, TweenInfo.new(DS.A.normal, DS.A.easeOut), {
                BackgroundTransparency=0, BackgroundColor3=C.card }):Play()
            TweenService:Create(data.icon, TweenInfo.new(DS.A.normal), { TextColor3=C.accent }):Play()
            TweenService:Create(data.label, TweenInfo.new(DS.A.normal), { TextColor3=C.text }):Play()
            data.accentBar.Visible = true
            TweenService:Create(data.accentBar, TweenInfo.new(DS.A.normal), { Size=UDim2.new(0,3,0.55,0) }):Play()
        else
            data.button:SetAttribute("_bgRole", "bgAlt")
            data.button:SetAttribute("_baseColor", C.bgAlt)
            TweenService:Create(data.button, TweenInfo.new(DS.A.normal), { BackgroundTransparency=1 }):Play()
            TweenService:Create(data.icon, TweenInfo.new(DS.A.normal), { TextColor3=C.textDim }):Play()
            TweenService:Create(data.label, TweenInfo.new(DS.A.normal), { TextColor3=C.textDim }):Play()
            data.accentBar.Visible = false
            data.accentBar.Size = UDim2.new(0,3,0,0)
        end
    end
    if name == "tab_settings" then
        TweenService:Create(settingsIcon, TweenInfo.new(DS.A.normal), { TextColor3=C.accent }):Play()
        TweenService:Create(settingsLabel, TweenInfo.new(DS.A.normal), { TextColor3=C.text }):Play()
    else
        TweenService:Create(settingsIcon, TweenInfo.new(DS.A.normal), { TextColor3=C.textDim }):Play()
        TweenService:Create(settingsLabel, TweenInfo.new(DS.A.normal), { TextColor3=C.textDim }):Play()
    end
end

local function createTab(icon, nameKey, order)
    local btn = new("TextButton", {
        Size=UDim2.new(1,0,0,T2.Size.tabH), BackgroundColor3=C.bgAlt, BackgroundTransparency=1,
        Text="", BorderSizePixel=0, AutoButtonColor=false, LayoutOrder=order, Parent=sidebarTabs })
    corner(btn, DS.R.chip)
    local accentBar = new("Frame", { Size=UDim2.new(0,3,0,0), Position=UDim2.new(0,0,0.5,0),
        AnchorPoint=Vector2.new(0,0.5), BackgroundColor3=C.accent, BorderSizePixel=0,
        Visible=false, Parent=btn })
    corner(accentBar, DS.R.round)
    local iconLbl = new("TextLabel", { Size=UDim2.new(0,24,1,0), Position=UDim2.new(0,14,0,0),
        BackgroundTransparency=1, Text=icon, TextColor3=C.textDim,
        Font=DS.F.bold, TextSize=14, TextXAlignment=Enum.TextXAlignment.Center, Parent=btn })
    local nameLbl = regLang(new("TextLabel", { Size=UDim2.new(1,-46,1,0), Position=UDim2.new(0,44,0,0),
        BackgroundTransparency=1, TextColor3=C.textDim,
        Font=DS.F.body, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, Parent=btn }), nameKey)
    local isFixed = (nameKey == "tab_tracker")
    local page = new("ScrollingFrame", {
        Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, BorderSizePixel=0,
        ScrollBarThickness=isFixed and 0 or 5, ScrollBarImageColor3=C.accent,
        ScrollBarImageTransparency=0.4, ScrollingEnabled=not isFixed,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=isFixed and Enum.AutomaticSize.None or Enum.AutomaticSize.Y,
        Visible=false, Parent=contentFrame })
    new("UIListLayout", { Padding=UDim.new(0,DS.S.md), SortOrder=Enum.SortOrder.LayoutOrder, Parent=page })
    if not isFixed then
        new("UIPadding", { PaddingTop=UDim.new(0,6), PaddingBottom=UDim.new(0,16),
            PaddingRight=UDim.new(0,8), PaddingLeft=UDim.new(0,2), Parent=page })
    end
    tabContents[nameKey] = {button=btn, page=page, icon=iconLbl, label=nameLbl, accentBar=accentBar}
    btn.MouseEnter:Connect(function()
        if activeTab ~= nameKey then
            TweenService:Create(btn, TweenInfo.new(DS.A.fast), { BackgroundTransparency=0.5, BackgroundColor3=C.hover }):Play()
            TweenService:Create(iconLbl, TweenInfo.new(DS.A.fast), { TextColor3=C.text }):Play()
            TweenService:Create(nameLbl, TweenInfo.new(DS.A.fast), { TextColor3=C.text }):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= nameKey then
            TweenService:Create(btn, TweenInfo.new(DS.A.fast), { BackgroundTransparency=1 }):Play()
            TweenService:Create(iconLbl, TweenInfo.new(DS.A.fast), { TextColor3=C.textDim }):Play()
            TweenService:Create(nameLbl, TweenInfo.new(DS.A.fast), { TextColor3=C.textDim }):Play()
        end
    end)
    btn.MouseButton1Click:Connect(function() switchTab(nameKey) end)
    return page
end

local pageMain     = createTab("🏠", "tab_main", 1)
local pageZones    = createTab("🌀", "tab_zones", 2)
local pageTP       = createTab("👥", "tab_players", 3)
local pageFarm     = createTab("⚔", "tab_farm", 4)
local pageHitbox   = createTab("👊", "tab_hitbox", 5)
local pageVisual   = createTab("👁", "tab_visual", 6)
local pageTracker  = createTab("📊", "tab_tracker", 7)
local pageUtility  = createTab("🛠", "tab_utils", 8)
local pageSettings = createTab("⚙", "tab_settings", 99)
tabContents["tab_settings"].button.Visible = false

activeTab = "tab_main"
tabContents["tab_main"].page.Visible = true
tabContents["tab_main"].button.BackgroundTransparency = 0
tabContents["tab_main"].button.BackgroundColor3 = C.card
tabContents["tab_main"].button:SetAttribute("_bgRole", "card")
tabContents["tab_main"].button:SetAttribute("_baseColor", C.card)
tabContents["tab_main"].icon.TextColor3 = C.accent
tabContents["tab_main"].label.TextColor3 = C.text
tabContents["tab_main"].accentBar.Visible = true
tabContents["tab_main"].accentBar.Size = UDim2.new(0,3,0.55,0)

settingsBtn.MouseButton1Click:Connect(function() switchTab("tab_settings") end)
settingsBtn.MouseEnter:Connect(function()
    TweenService:Create(settingsBtn, TweenInfo.new(DS.A.fast), { BackgroundColor3=C.hover }):Play()
    if activeTab ~= "tab_settings" then
        TweenService:Create(settingsIcon, TweenInfo.new(DS.A.fast), { TextColor3=C.accent }):Play()
        TweenService:Create(settingsLabel, TweenInfo.new(DS.A.fast), { TextColor3=C.text }):Play()
    end
end)
settingsBtn.MouseLeave:Connect(function()
    local restore = settingsBtn:GetAttribute("_baseColor") or C.card
    TweenService:Create(settingsBtn, TweenInfo.new(DS.A.fast), { BackgroundColor3=restore }):Play()
    if activeTab ~= "tab_settings" then
        TweenService:Create(settingsIcon, TweenInfo.new(DS.A.fast), { TextColor3=C.textDim }):Play()
        TweenService:Create(settingsLabel, TweenInfo.new(DS.A.fast), { TextColor3=C.textDim }):Play()
    end
end)

local toggleRegistry, allToggles, allSliders = {}, {}, {}
local makeSection, createToggle, createSlider, createButton
do
    makeSection = function(parent, textKey, icon)
        local row = new("Frame", { Size=UDim2.new(1,-8,0,26), BackgroundTransparency=1, Parent=parent })
        local accent = new("Frame", { Size=UDim2.new(0,3,0,12), Position=UDim2.new(0,0,0.5,-6),
            BackgroundColor3=C.accent, BackgroundTransparency=0.3, BorderSizePixel=0, Parent=row })
        corner(accent, DS.R.round)
        local lbl = new("TextLabel", { Size=UDim2.new(1,-10,1,0), Position=UDim2.new(0,10,0,0), BackgroundTransparency=1,
            Text=(icon and (icon.."  ") or "")..string.upper(T(textKey)),
            TextColor3=C.textMuted, Font=DS.F.bold, TextSize=10,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=row })
        lbl:SetAttribute("_langSectionKey", textKey)
        lbl:SetAttribute("_langSectionIcon", icon or "")
        table.insert(textRegistry, lbl)
        return row
    end

    createToggle = function(parent, labelKey, default, callback, id, descKey)
        local rowH = descKey and 60 or T2.Size.rowH
        local frame = new("Frame", { Size=UDim2.new(1,-8,0,rowH), BackgroundColor3=C.card, BorderSizePixel=0, Parent=parent })
        corner(frame, DS.R.card)
        local frameStroke = stroke(frame, C.border, 1, 0.5)
        regLang(new("TextLabel", { Size=UDim2.new(1,-110,0,18),
            Position=UDim2.new(0,16,0,descKey and 12 or (rowH/2-9)),
            BackgroundTransparency=1, TextColor3=C.text,
            Font=DS.F.body, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=frame }), labelKey)
        if descKey then
            regLang(new("TextLabel", { Size=UDim2.new(1,-110,0,14), Position=UDim2.new(0,16,0,30),
                BackgroundTransparency=1, TextColor3=C.textMuted,
                Font=DS.F.subtle, TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, Parent=frame }), descKey)
        end
        local switchBg = new("Frame", { Size=UDim2.new(0,46,0,24), Position=UDim2.new(1,-62,0.5,-12),
            BackgroundColor3=default and C.success or C.borderLight,
            BackgroundTransparency=default and 0 or 0.2, BorderSizePixel=0, Parent=frame })
        corner(switchBg, DS.R.round)
        local trackStroke = stroke(switchBg, default and C.success or C.borderLight, 1, 0.5)
        local thumb = new("Frame", { Size=UDim2.new(0,18,0,18),
            Position=default and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9),
            BackgroundColor3=Color3.fromRGB(255,255,255), BorderSizePixel=0, Parent=switchBg })
        corner(thumb, DS.R.round)
        local btn = new("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="",
            BorderSizePixel=0, AutoButtonColor=false, Parent=frame })
        local state = default
        local function setState(newState, fireCallback)
            state = newState
            TweenService:Create(switchBg, TweenInfo.new(DS.A.normal, DS.A.easeOut), {
                BackgroundColor3=state and C.success or C.borderLight,
                BackgroundTransparency=state and 0 or 0.2 }):Play()
            TweenService:Create(trackStroke, TweenInfo.new(DS.A.normal), {
                Color=state and C.success or C.borderLight }):Play()
            TweenService:Create(thumb, TweenInfo.new(DS.A.normal, DS.A.easeOut), {
                Position=state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9) }):Play()
            if fireCallback ~= false then
                local ok, err = pcall(callback, state)
                if not ok then warn("[Toggle] "..tostring(id)..": "..tostring(err)) end
            end
        end
        btn.MouseButton1Click:Connect(function() setState(not state, true) end)
        frame.MouseEnter:Connect(function()
            TweenService:Create(frame, TweenInfo.new(DS.A.fast), { BackgroundColor3=C.hover }):Play()
            TweenService:Create(frameStroke, TweenInfo.new(DS.A.fast), { Transparency=0.2 }):Play()
        end)
        frame.MouseLeave:Connect(function()
            local restore = frame:GetAttribute("_baseColor") or C.card
            TweenService:Create(frame, TweenInfo.new(DS.A.fast), { BackgroundColor3=restore }):Play()
            TweenService:Create(frameStroke, TweenInfo.new(DS.A.fast), { Transparency=0.5 }):Play()
        end)
        if id then
            toggleRegistry[id] = { setState=setState, getState=function() return state end }
            allToggles[id] = { setState=setState, getState=function() return state end }
        end
        return frame
    end

    createSlider = function(parent, labelKey, min, max, default, color, onChange, id)
        local card = new("Frame", { Size=UDim2.new(1,-8,0,74), BackgroundColor3=C.card, BorderSizePixel=0, Parent=parent })
        corner(card, DS.R.card)
        local cardStroke = stroke(card, C.border, 1, 0.5)
        regLang(new("TextLabel", { Size=UDim2.new(1,-100,0,16), Position=UDim2.new(0,16,0,12),
            BackgroundTransparency=1, TextColor3=C.textDim,
            Font=DS.F.bold, TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, Parent=card }), labelKey)
        local valueBadge = new("Frame", { Size=UDim2.new(0,64,0,22), Position=UDim2.new(1,-80,0,10),
            BackgroundColor3=color or C.accent, BackgroundTransparency=0.85, BorderSizePixel=0, Parent=card })
        corner(valueBadge, DS.R.round)
        stroke(valueBadge, color or C.accent, 1, 0.5)
        local valueLabel = new("TextLabel", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text=tostring(default),
            TextColor3=color or C.accent, Font=DS.F.bold, TextSize=12, Parent=valueBadge })
        local bar = new("Frame", { Size=UDim2.new(1,-32,0,8), Position=UDim2.new(0,16,0,46),
            BackgroundColor3=C.bgAlt, BorderSizePixel=0, Parent=card })
        corner(bar, DS.R.round)
        stroke(bar, C.border, 1, 0.6)
        local clampedDefault = math.clamp(default, min, max)
        local initRel = (clampedDefault-min)/math.max(1e-6, (max-min))
        local fill = new("Frame", { Size=UDim2.new(initRel,0,1,0), BackgroundColor3=color or C.accent,
            BorderSizePixel=0, Parent=bar })
        corner(fill, DS.R.round)
        local thumb = new("Frame", { Size=UDim2.new(0,18,0,18), Position=UDim2.new(initRel,-9,0.5,-9),
            BackgroundColor3=Color3.fromRGB(255,255,255), BorderSizePixel=0, Parent=bar })
        corner(thumb, DS.R.round)
        stroke(thumb, color or C.accent, 2.5)
        local hitbox = new("TextButton", { Size=UDim2.new(0,28,0,28), Position=UDim2.new(initRel,-14,0.5,-14),
            BackgroundTransparency=1, Text="", BorderSizePixel=0, AutoButtonColor=false, Parent=bar })
        local currentValue = clampedDefault
        local function setValue(val)
            val = math.clamp(val, min, max)
            currentValue = val
            valueLabel.Text = tostring(val)
            local rel = (val-min)/math.max(1e-6, (max-min))
            fill.Size = UDim2.new(rel,0,1,0)
            thumb.Position = UDim2.new(rel,-9,0.5,-9)
            hitbox.Position = UDim2.new(rel,-14,0.5,-14)
            onChange(val)
        end
        if id then allSliders[id] = { setValue=setValue, getValue=function() return currentValue end } end
        local dragging = false
        hitbox.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                dragging = true
                TweenService:Create(cardStroke, TweenInfo.new(DS.A.fast), { Transparency=0 }):Play()
            end
        end)
        track(UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
                local relX = math.clamp((input.Position.X - bar.AbsolutePosition.X) / math.max(1, bar.AbsoluteSize.X), 0, 1)
                setValue(math.floor(min + relX * (max - min)))
            end
        end))
        track(UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                dragging = false
                TweenService:Create(cardStroke, TweenInfo.new(DS.A.fast), { Transparency=0.5 }):Play()
            end
        end))
        return card
    end

    createButton = function(parent, textKey, color, callback, icon)
        local baseColor = color or C.accent
        local btn = new("TextButton", {
            Size=UDim2.new(1,-8,0,44), BackgroundColor3=baseColor, Text="",
            BackgroundTransparency=0, BorderSizePixel=0, AutoButtonColor=false, Parent=parent })
        corner(btn, DS.R.button)
        local btnStroke = stroke(btn, baseColor, 1, 0.4)
        local content = new("Frame", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Parent=btn })
        new("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal,
            HorizontalAlignment=Enum.HorizontalAlignment.Center,
            VerticalAlignment=Enum.VerticalAlignment.Center,
            Padding=UDim.new(0,8), Parent=content })
        if icon then
            new("TextLabel", { Size=UDim2.new(0,16,1,0), BackgroundTransparency=1, Text=icon,
                TextColor3=C.text, Font=DS.F.bold, TextSize=14, LayoutOrder=1, Parent=content })
        end
        local textLbl = new("TextLabel", { Size=UDim2.new(0,0,1,0), AutomaticSize=Enum.AutomaticSize.X,
            BackgroundTransparency=1, Text=T(textKey), TextColor3=C.text,
            Font=DS.F.bold, TextSize=12, LayoutOrder=2, Parent=content })
        textLbl:SetAttribute("_langKey", textKey)
        table.insert(textRegistry, textLbl)
        btn.MouseEnter:Connect(function()
            local cur = btn.BackgroundColor3
            TweenService:Create(btn, TweenInfo.new(DS.A.fast), {
                BackgroundColor3=Color3.new(math.min(1,cur.R+0.08), math.min(1,cur.G+0.08), math.min(1,cur.B+0.08)) }):Play()
            TweenService:Create(btnStroke, TweenInfo.new(DS.A.fast), { Transparency=0 }):Play()
        end)
        btn.MouseLeave:Connect(function()
            local restore = btn:GetAttribute("_baseColor") or baseColor
            TweenService:Create(btn, TweenInfo.new(DS.A.fast), { BackgroundColor3=restore }):Play()
            TweenService:Create(btnStroke, TweenInfo.new(DS.A.fast), { Transparency=0.4 }):Play()
        end)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end
end

local parseNumber, formatNumber
do
    local NUMBER_SUFFIXES = {
        K=1e3, M=1e6, B=1e9, T=1e12, QD=1e15, QA=1e15, QN=1e18, QI=1e18,
        SX=1e21, SP=1e24, OC=1e27, NO=1e30, DC=1e33, Q=1e15, QQ=1e18,
        UD=1e36, DD=1e39, TD=1e42, QAD=1e45, QID=1e48, SXD=1e51, SPD=1e54,
        OCD=1e57, NOD=1e60, VG=1e63,
    }
    parseNumber = function(str)
        if not str then return nil end
        if type(str) == "number" then return str end
        str = tostring(str):upper():gsub(",", ""):gsub("%s", "")
        local num, suffix = string.match(str, "^([%d%.]+)(%a*)$")
        if not num then return nil end
        local n = tonumber(num)
        if not n then return nil end
        if suffix and suffix ~= "" then
            local keys = {}
            for k in pairs(NUMBER_SUFFIXES) do table.insert(keys, k) end
            table.sort(keys, function(a, b) return #a > #b end)
            for _, s in ipairs(keys) do
                if suffix == s then return n * NUMBER_SUFFIXES[s] end
            end
        end
        return n
    end
    formatNumber = function(num)
        if not num then return "?" end
        if num < 1e3 then return tostring(math.floor(num)) end
        local units = {
            {1e63,"Vg"},{1e60,"NoD"},{1e57,"OcD"},{1e54,"SpD"},{1e51,"SxD"},
            {1e48,"QiD"},{1e45,"QaD"},{1e42,"TD"},{1e39,"DD"},{1e36,"UD"},
            {1e33,"Dc"},{1e30,"No"},{1e27,"Oc"},{1e24,"Sp"},{1e21,"Sx"},
            {1e18,"Qn"},{1e15,"Qd"},{1e12,"T"},{1e9,"B"},{1e6,"M"},{1e3,"K"},
        }
        for _, u in ipairs(units) do
            if num >= u[1] then
                local v = num / u[1]
                if v == math.floor(v) then return string.format("%d%s", v, u[2])
                else return string.format("%.1f%s", v, u[2]) end
            end
        end
        return tostring(math.floor(num))
    end
end

local getMobRoot, getMobDisplayName, getMobHP, hasBossEmoji, isBossMob,
      invalidateMobCache, getAllMobs
do
    local function getNpcsFolder() return workspace:FindFirstChild("Npcs") end
    getMobRoot = function(mob)
        local hrp = mob:FindFirstChild("HumanoidRootPart") if hrp and hrp:IsA("BasePart") then return hrp end
        local rp = mob:FindFirstChild("RootPart") if rp and rp:IsA("BasePart") then return rp end
        for _, d in ipairs(mob:GetDescendants()) do if d:IsA("BasePart") then return d end end
        return nil
    end
    local function isHPText(txt)
        if not txt or txt == "" then return false end
        if string.match(txt, "^[%d%.]+%a*%s*/%s*[%d%.]+%a*$") then return true end
        if string.match(txt, "^[%d%.]+[KMBTQSPNODC]+$") then return true end
        if string.match(txt, "^[%d%.]+$") then return true end
        return false
    end
    getMobDisplayName = function(mob)
        for _, attrName in ipairs({"DisplayName","displayName","MobName","mobName","NpcName","npcName","MonsterName","monsterName","Name","name"}) do
            local v = mob:GetAttribute(attrName)
            if type(v) == "string" and v ~= "" and not string.match(v, "^[%d%s%.,]+$") then return v end
        end
        for _, ch in ipairs(mob:GetChildren()) do
            if ch:IsA("StringValue") then
                local l = string.lower(ch.Name)
                if l == "name" or l == "displayname" or l == "mobname" then
                    local v = ch.Value
                    if v and v ~= "" and not string.match(v, "^[%d%s%.,]+$") then return v end
                end
            end
        end
        for _, ch in ipairs(mob:GetChildren()) do
            if ch:IsA("TextLabel") or ch:IsA("TextBox") then
                local txt = ch.Text or ""
                if txt ~= "" and not isHPText(txt) then
                    if not string.match(txt, "·") and not string.match(txt, "HP") then
                        local cleaned = txt:gsub("^%s+",""):gsub("%s+$","")
                        if #cleaned >= 2 and not string.match(cleaned, "^[%d%s%.,]+$") then return cleaned end
                    end
                end
            end
        end
        for _, ch in ipairs(mob:GetDescendants()) do
            if ch:IsA("TextLabel") or ch:IsA("TextBox") then
                local txt = ch.Text or ""
                if txt ~= "" and not isHPText(txt) then
                    if not string.match(txt, "·") and not string.match(txt, "HP") then
                        local cleaned = txt:gsub("^%s+",""):gsub("%s+$","")
                        if #cleaned >= 2 and not string.match(cleaned, "^[%d%s%.,]+$") then return cleaned end
                    end
                end
            end
        end
        return mob.Name
    end
    getMobHP = function(mob)
        for _, attrName in ipairs({"Health","health","HP","hp","CurrentHealth","currenthealth"}) do
            local v = mob:GetAttribute(attrName)
            if type(v) == "number" and v > 0 then
                local maxV = mob:GetAttribute("MaxHealth") or mob:GetAttribute("maxHealth") or mob:GetAttribute("MaxHP") or v
                return v, maxV, tostring(v), tostring(maxV)
            end
        end
        for _, ch in ipairs(mob:GetChildren()) do
            if ch:IsA("TextLabel") or ch:IsA("TextBox") then
                local txt = ch.Text or ""
                local a, b = string.match(txt, "^([%d%.]+%a*)%s*/%s*([%d%.]+%a*)$")
                if not a then a, b = string.match(txt, "^.-([%d%.]+%a*)%s*/%s*([%d%.]+%a*)$") end
                if a and b then
                    local hp, maxHp = parseNumber(a), parseNumber(b)
                    if hp and maxHp and hp > 0 then return hp, maxHp, a, b end
                end
            end
        end
        for _, ch in ipairs(mob:GetDescendants()) do
            if ch:IsA("TextLabel") or ch:IsA("TextBox") then
                local txt = ch.Text or ""
                local a, b = string.match(txt, "^([%d%.]+%a*)%s*/%s*([%d%.]+%a*)$")
                if not a then a, b = string.match(txt, "^.-([%d%.]+%a*)%s*/%s*([%d%.]+%a*)$") end
                if a and b then
                    local hp, maxHp = parseNumber(a), parseNumber(b)
                    if hp and maxHp and hp > 0 then return hp, maxHp, a, b end
                end
            end
        end
        return nil, nil, nil, nil
    end
    local SKULL_1 = "\240\159\146\128"
    local SKULL_2 = "\226\152\160"
    local CROWN   = "\240\159\145\145"
    local SKULL_3 = "\240\159\152\136"
    hasBossEmoji = function(str)
        if not str then return false end
        return string.find(str, SKULL_1, 1, true) or string.find(str, SKULL_2, 1, true)
            or string.find(str, CROWN, 1, true) or string.find(str, SKULL_3, 1, true)
    end
    local STRUCTURE_KEYWORDS = {
        "gate","door","portal","sign","chest","spawner","barrier","wall","tower","shrine","altar","statue",
        "beacon","totem","lamp","torch","platform","bridge","fence","button","lever","pressure","pad",
        "quest","npc shop","shop","vendor","teleport","waypoint","objective","heal","regen","buff","zone",
        "checkpoint","crystal",
    }
    local BOSS_KEYWORDS = {"boss","elite","lord","king","queen","titan","demon","dragon","ancient","legendary","mythic"}
    local function isStructureName(name)
        if not name then return false end
        local lower = string.lower(name)
        for _, kw in ipairs(STRUCTURE_KEYWORDS) do if string.find(lower, kw, 1, true) then return true end end
        return false
    end
    local BOSS_NAME_WHITELIST = {
        "ashgor","минотавр","minotaur","chief","dino","arachinex","grimroot","leonidas",
        "lightning god","sand golem","hydra worm","dragon","nevermore","simba","anubis",
        "eyegor","bloodrootwitch","queen of serpents",
    }
    local function matchBossName(s)
        if not s then return false end
        local l = string.lower(tostring(s)):gsub("^%s+",""):gsub("%s+$","")
        for _, name in ipairs(BOSS_NAME_WHITELIST) do
            if l == name then return true end
            if string.find(l, "^"..name.."%s*[%[%(%!%-]") then return true end
        end
        return false
    end
    local bossBarCache = { name = nil, hp = nil, maxHp = nil, time = 0, hasCache = false }
    local function sniffBossBar()
        local now = tick()
        local ttl = bossBarCache.hasCache and 0.75 or 3.0
        if now - bossBarCache.time < ttl then return bossBarCache.name, bossBarCache.hp, bossBarCache.maxHp end
        bossBarCache.time = now
        bossBarCache.name = nil bossBarCache.hp = nil bossBarCache.maxHp = nil
        local root = LocalPlayer:FindFirstChild("PlayerGui")
        if not root then return nil, nil, nil end
        local hpPattern = "^([%d%.]+%a*)%s*/%s*([%d%.]+%a*)$"
        local bestHpLbl, bestArea = nil, 0
        local MAX_DEPTH = 5
        local function scanChildren(container, depth)
            if depth > MAX_DEPTH then return end
            for _, obj in ipairs(container:GetChildren()) do
                if obj:IsA("TextLabel") and obj.Visible then
                    local t = (obj.Text or ""):gsub("^%s+",""):gsub("%s+$","")
                    local a, b = string.match(t, hpPattern)
                    if a and b then
                        local hasSuffix = string.match(a, "%a") or string.match(b, "%a")
                        local maxNum = parseNumber(b) or 0
                        local area = obj.AbsoluteSize.X * obj.AbsoluteSize.Y
                        if (hasSuffix or maxNum > 10000) and area > 20000 then
                            if area > bestArea then bestArea = area bestHpLbl = obj end
                        end
                    end
                elseif obj:IsA("GuiObject") or obj:IsA("LayerCollector") then
                    scanChildren(obj, depth + 1)
                end
            end
        end
        scanChildren(root, 1)
        if bestHpLbl then
            local a, b = string.match(bestHpLbl.Text, hpPattern)
            bossBarCache.hp = parseNumber(a)
            bossBarCache.maxHp = parseNumber(b)
            local parent = bestHpLbl.Parent
            for _ = 1, 4 do
                if not parent then break end
                for _, sib in ipairs(parent:GetDescendants()) do
                    if sib:IsA("TextLabel") and sib ~= bestHpLbl then
                        local st = (sib.Text or ""):gsub("^%s+",""):gsub("%s+$","")
                        if #st >= 2 and #st <= 40 and not string.match(st, "^[%d%.%s%,/]+$") and not string.match(st, hpPattern) then
                            bossBarCache.name = st
                            break
                        end
                    end
                end
                if bossBarCache.name then break end
                parent = parent.Parent
            end
        end
        bossBarCache.hasCache = (bossBarCache.hp ~= nil and bossBarCache.maxHp ~= nil)
        return bossBarCache.name, bossBarCache.hp, bossBarCache.maxHp
    end
    isBossMob = function(mob, hp, displayName)
        if matchBossName(displayName) or matchBossName(mob and mob.Name) then return true end
        if isStructureName(displayName) then return false end
        if hasBossEmoji(displayName) then return true end
        for _, attrName in ipairs({"IsBoss","isBoss","Boss","boss","IsElite","isElite","Elite","elite","Unique","unique","IsUnique","isUnique","BossType","bossType","Rank","rank"}) do
            if mob:GetAttribute(attrName) == true then return true end
        end
        for _, ch in ipairs(mob:GetChildren()) do
            local n = string.lower(ch.Name)
            if string.find(n, "uniquebosshealth", 1, true) or string.find(n, "bosshealth", 1, true) or string.find(n, "uniquehealth", 1, true) then return true end
        end
        if displayName and hp and hp > 0 then
            local lower = string.lower(displayName)
            for _, kw in ipairs(BOSS_KEYWORDS) do if string.find(lower, kw, 1, true) then return true end end
        end
        return false
    end
    local MOB_CACHE_TTL = 0.6
    local mobCache = { data=nil, time=0 }
    invalidateMobCache = function() mobCache.data = nil mobCache.time = 0 end
    getAllMobs = function()
        local now = tick()
        if mobCache.data and (now - mobCache.time) < MOB_CACHE_TTL then return mobCache.data end
        local list, seen = {}, {}
        local function tryAdd(m)
            if not m:IsA("Model") or seen[m] then return end
            seen[m] = true
            local root = getMobRoot(m)
            if not root then return end
            if m:GetAttribute("Dead") == true then return end
            local hp, maxHp, hpText, maxHpText = getMobHP(m)
            if hp ~= nil and hp <= 0 then return end
            local displayName = getMobDisplayName(m)
            local boss = isBossMob(m, hp, displayName)
            local isNpc = m:GetAttribute("Npc") == true
            local hasAnimCtrl = m:FindFirstChildOfClass("AnimationController") ~= nil
            if isNpc or hasAnimCtrl or boss then
                if not Players:GetPlayerFromCharacter(m) then
                    table.insert(list, {model=m, hrp=root, hp=hp, maxHp=maxHp, hpText=hpText, maxHpText=maxHpText, displayName=displayName, isBoss=boss})
                end
            end
        end
        local folder = getNpcsFolder()
        if folder then for _, m in ipairs(folder:GetChildren()) do tryAdd(m) end end
        for _, m in ipairs(workspace:GetChildren()) do tryAdd(m) end
        local barName, barHp, barMaxHp = sniffBossBar()
        if barName and matchBossName(barName) then
            local barLower = string.lower(barName)
            local alreadyInList = false
            for _, item in ipairs(list) do
                local n = string.lower(item.displayName or (item.model and item.model.Name) or "")
                if string.find(n, barLower, 1, true) or string.find(barLower, n, 1, true) then
                    item.isBoss = true
                    if not item.hp then
                        item.hp = barHp item.maxHp = barMaxHp
                        item.hpText = tostring(barHp) item.maxHpText = tostring(barMaxHp)
                    end
                    alreadyInList = true break
                end
            end
            if not alreadyInList then
                local foundModel, foundRoot = nil, nil
                local function tryFindModel(container)
                    if not container or foundModel then return end
                    for _, m in ipairs(container:GetChildren()) do
                        if m:IsA("Model") and string.find(string.lower(m.Name), barLower, 1, true) then
                            local root = getMobRoot(m)
                            if root then foundModel = m foundRoot = root return end
                        end
                    end
                end
                tryFindModel(workspace:FindFirstChild("Npcs"))
                tryFindModel(workspace:FindFirstChild("LivingMobs"))
                tryFindModel(workspace:FindFirstChild("Mobs"))
                tryFindModel(workspace)
                if foundModel then
                    table.insert(list, {
                        model = foundModel, hrp = foundRoot,
                        hp = barHp, maxHp = barMaxHp,
                        hpText = tostring(barHp), maxHpText = tostring(barMaxHp),
                        displayName = barName, isBoss = true,
                    })
                end
            end
        end
        mobCache.data = list mobCache.time = now
        return list
    end
end

local function teleportTo(pos)
    local char = LocalPlayer.Character
    if not char then return end
    pcall(function() char:PivotTo(CFrame.new(pos)) end)
end
local ZONE_MAX_DIST = 3000
local function getZoneByPos(pos)
    if not pos then return "?" end
    local nn, nd = nil, math.huge
    for _, zone in ipairs(ZONES) do
        local d = (zone.coords - pos).Magnitude
        if d < nd then nd = d nn = zone.name end
    end
    if nd > ZONE_MAX_DIST then return "?" end
    return nn or "?"
end
local function getNearestMob()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local near, nd = nil, math.huge
    for _, data in ipairs(getAllMobs()) do
        local d = (data.hrp.Position - hrp.Position).Magnitude
        if d < nd then nd = d near = data end
    end
    return near, nd
end
local function clickLeftMouse()
    if mouse1click then
        local ok = pcall(mouse1click)
        if ok then return true end
    end
    if mouse1press and mouse1release then
        local ok = pcall(function() mouse1press() task.wait(0.03) mouse1release() end)
        if ok then return true end
    end
    local cam = workspace.CurrentCamera
    local center = cam and Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2) or Vector2.new(400, 300)
    return pcall(function()
        VirtualUser:Button1Down(center)
        task.wait(0.03)
        VirtualUser:Button1Up(center)
    end)
end
local function httpGet(url)
    if type(url) ~= "string" then return nil end
    if not string.match(url, "^https://") then return nil end
    local ok, resp
    if request then
        ok, resp = pcall(request, {Url=url, Method="GET"})
        if ok and type(resp) == "table" and resp.Body then return resp.Body end
    end
    if http_request then
        ok, resp = pcall(http_request, {Url=url, Method="GET"})
        if ok and type(resp) == "table" and resp.Body then return resp.Body end
    end
    if syn and syn.request then
        ok, resp = pcall(syn.request, {Url=url, Method="GET"})
        if ok and type(resp) == "table" and resp.Body then return resp.Body end
    end
    if game.HttpGet then
        local body
        ok, body = pcall(game.HttpGet, game, url)
        if ok then return body end
    end
    if game.HttpGetAsync then
        local body
        ok, body = pcall(game.HttpGetAsync, game, url)
        if ok then return body end
    end
    return nil
end

makeSection(pageMain, "sec_server", "🌐")
do
    local lastHopTime = 0
    local function serverHop()
        if tick() - lastHopTime < 3 then
            showToast(T("toast_wait_hop"), C.warn, "⏳")
            return
        end
        lastHopTime = tick()
        if FS_AVAILABLE then
            pcall(function()
                local data = {
                    Config = {HitboxSize=Config.HitboxSize,
                        KillAuraRange=Config.KillAuraRange, KillAuraDelay=Config.KillAuraDelay,
                        ESPColor={R=Config.ESPColor.R, G=Config.ESPColor.G, B=Config.ESPColor.B},
                        ZoomValue=Config.ZoomValue, AutoFarmDelay=Config.AutoFarmDelay,
                        AutoClickerCPS=Config.AutoClickerCPS,
                        SpeedValue=Config.SpeedValue, FlySpeed=Config.FlySpeed,
                        RadarRange=Config.RadarRange,
                        ToggleKey=Config.ToggleKey and Config.ToggleKey.Name or "Delete"},
                    Toggles={}, Theme=currentTheme.name,
                    SavedPositions={}, Favorites=favoritedPoints, Friends=savedFriends,
                }
                for id, d in pairs(allToggles) do data.Toggles[id] = d.getState() end
                for name, pos in pairs(savedPositions) do data.SavedPositions[name] = {X=pos.X, Y=pos.Y, Z=pos.Z} end
                writefile(CONFIG_PREFIX.."_autoload.json", HttpService:JSONEncode(data))
            end)
        end
        showToast(T("toast_search_server"), C.accent, "🌐")
        local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local data = httpGet(url)
        if not data then showToast(T("toast_http_unavail"), C.danger, "⚠") return end
        local ok, parsed = pcall(function() return HttpService:JSONDecode(data) end)
        if not ok or not parsed or not parsed.data then
            showToast(T("toast_parse_error"), C.danger, "⚠")
            return
        end
        local candidates = {}
        for _, srv in ipairs(parsed.data) do
            if srv.id ~= game.JobId and srv.playing < srv.maxPlayers then
                table.insert(candidates, srv)
            end
        end
        if #candidates == 0 then showToast(T("toast_no_servers"), C.warn, "⚠") return end
        local target = candidates[math.random(1, #candidates)]
        showToast(string.format(T("toast_hop"), target.playing, target.maxPlayers), C.success, "🌐")
        task.wait(0.4)
        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, target.id, LocalPlayer) end)
    end
    createButton(pageMain, "btn_server_hop", C.accent, serverHop, "🌐")
end

makeSection(pageMain, "sec_jump", "🦘")
do
    local infiniteJumpConn
    local function toggleInfiniteJump(state)
        Config.InfiniteJump = state
        if state then
            if infiniteJumpConn then pcall(function() infiniteJumpConn:Disconnect() end) infiniteJumpConn = nil end
            infiniteJumpConn = track(UserInputService.JumpRequest:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                end
            end))
            showToast(T("toast_inf_jump_on"), C.success, "🦘")
        else
            if infiniteJumpConn then pcall(function() infiniteJumpConn:Disconnect() end) infiniteJumpConn = nil end
            showToast(T("toast_inf_jump_off"), C.warn, "🦘")
        end
    end
    createToggle(pageMain, "tog_inf_jump", false, toggleInfiniteJump, "InfiniteJump", "desc_inf_jump")
end

makeSection(pageMain, "sec_speed", "🏃")
do
    local speedTaskId = nil
    local function applySpeedHack()
        if not Config.SpeedHack or isShuttingDown then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= Config.SpeedValue then hum.WalkSpeed = Config.SpeedValue end
    end
    local function toggleSpeedHack(state)
        Config.SpeedHack = state
        if state then
            applySpeedHack()
            if not speedTaskId then speedTaskId = scheduleHeartbeat(applySpeedHack, 0.1, "speedHack") end
            showToast(string.format(T("toast_speed_on"), Config.SpeedValue), C.success, "🏃")
        else
            if speedTaskId then unscheduleHeartbeat(speedTaskId) speedTaskId = nil end
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
            showToast(T("toast_speed_off"), C.warn, "🏃")
        end
    end
    createToggle(pageMain, "tog_speed", false, toggleSpeedHack, "SpeedHack", "desc_speed")
    createSlider(pageMain, "lbl_speed_value", 16, 500, 100, C.success, function(v)
        Config.SpeedValue = v
        if Config.SpeedHack then applySpeedHack() end
    end, "SpeedValue")
end

makeSection(pageMain, "sec_flight", "🕊")
local destroyFly
do
    local flyAtt, flyLV, flyAlignAtt, flyAO, flyConn = nil, nil, nil, nil, nil
    local FLY_KEYS = {
        forward=Enum.KeyCode.W, backward=Enum.KeyCode.S, left=Enum.KeyCode.A, right=Enum.KeyCode.D,
        up=Enum.KeyCode.Space, down=Enum.KeyCode.LeftControl,
    }
    local function cleanupFlyInstances()
        if flyLV then pcall(function() flyLV:Destroy() end) flyLV = nil end
        if flyAO then pcall(function() flyAO:Destroy() end) flyAO = nil end
        if flyAtt then pcall(function() flyAtt:Destroy() end) flyAtt = nil end
        if flyAlignAtt then pcall(function() flyAlignAtt:Destroy() end) flyAlignAtt = nil end
    end
    destroyFly = function()
        if flyConn then pcall(function() flyConn:Disconnect() end) flyConn = nil end
        cleanupFlyInstances()
    end
    local function ensureFlyInstances(root)
        if not flyAtt or not flyAtt.Parent then
            flyAtt = Instance.new("Attachment") flyAtt.Name = "SPU_FlyAtt" flyAtt.Parent = root
        end
        if not flyLV or not flyLV.Parent then
            flyLV = Instance.new("LinearVelocity")
            flyLV.Name = "SPU_FlyLV" flyLV.Attachment0 = flyAtt
            flyLV.MaxForce = 1e9 flyLV.VectorVelocity = Vector3.zero
            flyLV.RelativeTo = Enum.ActuatorRelativeTo.World flyLV.Parent = root
        end
        if not flyAlignAtt or not flyAlignAtt.Parent then
            flyAlignAtt = Instance.new("Attachment") flyAlignAtt.Name = "SPU_FlyAlignAtt" flyAlignAtt.Parent = root
        end
        if not flyAO or not flyAO.Parent then
            flyAO = Instance.new("AlignOrientation")
            flyAO.Name = "SPU_FlyAO" flyAO.Attachment0 = flyAlignAtt
            flyAO.Mode = Enum.OrientationAlignmentMode.OneAttachment
            flyAO.MaxTorque = 1e9 flyAO.Responsiveness = 100 flyAO.Parent = root
        end
    end
    local function stopFly()
        destroyFly()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
    end
    local function startFly()
        stopFly()
        local char = LocalPlayer.Character
        if not char then Config.FlyEnabled = false return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then Config.FlyEnabled = false return end
        ensureFlyInstances(hrp)
        flyConn = track(RunService.RenderStepped:Connect(function()
            if not Config.FlyEnabled or isShuttingDown then return end
            local c = LocalPlayer.Character
            if not c then return end
            local root = c:FindFirstChild("HumanoidRootPart")
            if not root then return end
            if not flyAtt or not flyAtt.Parent then ensureFlyInstances(root) end
            if not flyLV or not flyLV.Parent then ensureFlyInstances(root) end
            if not flyAO or not flyAO.Parent then ensureFlyInstances(root) end
            local cam = workspace.CurrentCamera
            local moveDir = Vector3.zero
            if UserInputService:IsKeyDown(FLY_KEYS.forward)  then moveDir += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(FLY_KEYS.backward) then moveDir -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(FLY_KEYS.left)     then moveDir -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(FLY_KEYS.right)    then moveDir += cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(FLY_KEYS.up)       then moveDir += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(FLY_KEYS.down)     then moveDir -= Vector3.new(0,1,0) end
            if moveDir.Magnitude > 0 then moveDir = moveDir.Unit * Config.FlySpeed end
            if flyLV then flyLV.VectorVelocity = moveDir end
            if flyAO then flyAO.CFrame = cam.CFrame end
        end))
    end
    local function toggleFly(state)
        Config.FlyEnabled = state
        if state then
            startFly()
            if Config.FlyEnabled then showToast(string.format(T("toast_fly_on"), Config.FlySpeed), C.success, "🕊") end
        else
            stopFly()
            showToast(T("toast_fly_off"), C.warn, "🕊")
        end
    end
    createToggle(pageMain, "tog_fly", false, toggleFly, "Fly", "desc_fly")
    createSlider(pageMain, "lbl_fly_speed", 10, 500, 60, C.accent2, function(v) Config.FlySpeed = v end, "FlySpeed")
end

makeSection(pageMain, "sec_radar", "📡")
local radarGui, radarRoot
do
    radarGui = new("ScreenGui", {
        Name="SPU_Radar", ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset=true, DisplayOrder=15, Parent=HIDDEN_PARENT
    })
    protectGui(radarGui)
    local RADAR_SIZE = 200
    radarRoot = new("Frame", {
        Size=UDim2.new(0,RADAR_SIZE,0,RADAR_SIZE),
        Position=UDim2.new(1,-(RADAR_SIZE+20),1,-(RADAR_SIZE+20)),
        BackgroundColor3=C.bgAlt, BackgroundTransparency=0.15,
        BorderSizePixel=0, Visible=false, Parent=radarGui
    })
    corner(radarRoot, DS.R.card)
    gradient(radarRoot, C.bgAlt, C.bg, 135)
    stroke(radarRoot, C.accent, 1.2, 0.3)
    for i = 1, 3 do
        local ring = new("Frame", {
            Size=UDim2.new(0, RADAR_SIZE * i / 4, 0, RADAR_SIZE * i / 4),
            Position=UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint=Vector2.new(0.5, 0.5),
            BackgroundTransparency=1, BorderSizePixel=0, Parent=radarRoot
        })
        corner(ring, DS.R.round)
        stroke(ring, C.border, 1, 0.6)
    end
    new("Frame", { Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,0.5,0),
        BackgroundColor3=C.border, BackgroundTransparency=0.5, BorderSizePixel=0, Parent=radarRoot })
    new("Frame", { Size=UDim2.new(0,1,1,0), Position=UDim2.new(0.5,0,0,0),
        BackgroundColor3=C.border, BackgroundTransparency=0.5, BorderSizePixel=0, Parent=radarRoot })
    local radarCenter = new("Frame", {
        Size=UDim2.new(0,10,0,10), Position=UDim2.new(0.5,-5,0.5,-5),
        BackgroundColor3=C.success, BorderSizePixel=0, Parent=radarRoot
    })
    corner(radarCenter, DS.R.round)
    stroke(radarCenter, Color3.fromRGB(255,255,255), 1.5, 0)
    new("TextLabel", { Size=UDim2.new(1,0,0,16), Position=UDim2.new(0,8,0,6),
        BackgroundTransparency=1, Text="📡 RADAR",
        TextColor3=C.textDim, Font=DS.F.bold, TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=radarRoot })
    local radarDots = {}
    local dotPool = {}
    local radarTaskId = nil
    local function acquireDot()
        local n = #dotPool
        if n > 0 then local d = dotPool[n] dotPool[n] = nil return d end
        local d = new("Frame", {
            Size=UDim2.new(0,6,0,6), AnchorPoint=Vector2.new(0.5,0.5),
            BackgroundColor3=Color3.fromRGB(255,255,255), BorderSizePixel=0, Parent=radarRoot
        })
        corner(d, DS.R.round)
        return d
    end
    local function releaseDot(d)
        if d and d.Parent then d.Visible = false table.insert(dotPool, d) end
    end
    local function updateRadar()
        if not Config.Radar or isShuttingDown then return end
        local char = LocalPlayer.Character
        local myHrp = char and char:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        local origin = myHrp.Position
        local range = Config.RadarRange
        local halfSize = RADAR_SIZE / 2
        local scale = halfSize / range
        local seen = {}
        local function placeDot(key, worldPos, color, size)
            local rel = worldPos - origin
            local dx = rel.X * scale
            local dz = rel.Z * scale
            if math.abs(dx) > halfSize - 4 or math.abs(dz) > halfSize - 4 then
                if radarDots[key] then releaseDot(radarDots[key]) radarDots[key] = nil end
                return
            end
            seen[key] = true
            local dot = radarDots[key]
            if not dot then dot = acquireDot() radarDots[key] = dot end
            dot.BackgroundColor3 = color
            dot.Size = UDim2.new(0,size,0,size)
            dot.Position = UDim2.new(0.5, dx, 0.5, dz)
            dot.Visible = true
        end
        if Config.RadarShowMobs or Config.RadarShowBosses then
            for _, data in ipairs(getAllMobs()) do
                if data.isBoss then
                    if Config.RadarShowBosses then placeDot(data.model, data.hrp.Position, C.gold, 9) end
                else
                    if Config.RadarShowMobs then placeDot(data.model, data.hrp.Position, Color3.fromRGB(255,120,80), 6) end
                end
            end
        end
        if Config.RadarShowPlayers then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local hp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hp then placeDot("plr_"..plr.UserId, hp.Position, Color3.fromRGB(90,160,255), 7) end
                end
            end
        end
        for key, dot in pairs(radarDots) do
            if not seen[key] then releaseDot(dot) radarDots[key] = nil end
        end
    end
    local function toggleRadar(state)
        Config.Radar = state
        radarRoot.Visible = state
        if state then
            if not radarTaskId then radarTaskId = scheduleHeartbeat(updateRadar, 0.1, "radarUpdate") end
            task.defer(updateRadar)
            showToast(T("toast_radar_on"), C.accent2, "📡")
        else
            if radarTaskId then unscheduleHeartbeat(radarTaskId) radarTaskId = nil end
            for _, dot in pairs(radarDots) do if dot.Parent then dot:Destroy() end end
            for _, dot in ipairs(dotPool) do if dot.Parent then dot:Destroy() end end
            radarDots = {} dotPool = {}
            showToast(T("toast_radar_off"), C.warn, "📡")
        end
    end
    createToggle(pageMain, "tog_radar", false, toggleRadar, "Radar", "desc_radar")
    createSlider(pageMain, "lbl_radar_range", 100, 1000, 300, C.accent2, function(v) Config.RadarRange = v end, "RadarRange")
    createToggle(pageMain, "tog_radar_mobs", true, function(s) Config.RadarShowMobs = s end, "RadarShowMobs")
    createToggle(pageMain, "tog_radar_bosses", true, function(s) Config.RadarShowBosses = s end, "RadarShowBosses")
    createToggle(pageMain, "tog_radar_players", true, function(s) Config.RadarShowPlayers = s end, "RadarShowPlayers")
end

makeSection(pageMain, "sec_ghost", "👻")
do
    local noclipTaskId = nil
    local noclipOriginals = setmetatable({}, {__mode = "k"})
    local function applyNoclip()
        if not Config.Noclip or isShuttingDown then return end
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if noclipOriginals[part] == nil then noclipOriginals[part] = part.CanCollide end
                if part.CanCollide then part.CanCollide = false end
            end
        end
    end
    local function toggleNoclip(state)
        Config.Noclip = state
        if state then
            applyNoclip()
            if not noclipTaskId then noclipTaskId = scheduleHeartbeat(applyNoclip, 0.05, "noclip") end
            showToast(T("toast_ghost_on"), C.accent2, "👻")
        else
            if noclipTaskId then unscheduleHeartbeat(noclipTaskId) noclipTaskId = nil end
            local char = LocalPlayer.Character
            if char then
                for part, orig in pairs(noclipOriginals) do
                    if part and part.Parent and part:IsA("BasePart") then
                        pcall(function() part.CanCollide = orig end)
                    end
                end
            end
            noclipOriginals = setmetatable({}, {__mode = "k"})
            showToast(T("toast_ghost_off"), C.warn, "👻")
        end
    end
    createToggle(pageMain, "tog_noclip", false, toggleNoclip, "Noclip", "desc_noclip")
end

local function tpToCoords(zoneName, coords)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _ = 1, 5 do
        pcall(function() char:PivotTo(CFrame.new(coords)) end)
        pcall(function() hrp.CFrame = CFrame.new(coords) end)
        task.wait(0.15)
    end
    showToast(string.format(T("toast_tp"), zoneName), C.accent, "🌀")
end

makeSection(pageZones, "sec_tp", "🌀")
do
    local zonesList = new("Frame", { Size=UDim2.new(1,-8,0,0), BackgroundTransparency=1, AutomaticSize=Enum.AutomaticSize.Y, Parent=pageZones })
    new("UIListLayout", { Padding=UDim.new(0,DS.S.sm), SortOrder=Enum.SortOrder.LayoutOrder, Parent=zonesList })
    for i, zone in ipairs(ZONES) do
        local btn = new("TextButton", { Size=UDim2.new(1,0,0,48), BackgroundColor3=C.card, Text="",
            BackgroundTransparency=0.02, BorderSizePixel=0, AutoButtonColor=false, LayoutOrder=i, Parent=zonesList })
        corner(btn, DS.R.card)
        local bs = stroke(btn, C.border, 1, 0.5)
        new("TextLabel", { Size=UDim2.new(1,-50,0,18), Position=UDim2.new(0,16,0,8),
            BackgroundTransparency=1, Text=zone.name, TextColor3=C.text,
            Font=DS.F.bold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=btn })
        new("TextLabel", { Size=UDim2.new(1,-50,0,14), Position=UDim2.new(0,16,0,27),
            BackgroundTransparency=1,
            Text=string.format("%d, %d, %d", math.floor(zone.coords.X), math.floor(zone.coords.Y), math.floor(zone.coords.Z)),
            TextColor3=C.textMuted, Font=DS.F.mono, TextSize=10,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=btn })
        new("TextLabel", { Size=UDim2.new(0,26,0,26), Position=UDim2.new(1,-42,0.5,-13),
            BackgroundTransparency=1, Text="→", TextColor3=C.accent,
            Font=DS.F.bold, TextSize=17, Parent=btn })
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(DS.A.fast), { BackgroundColor3=C.hover, BackgroundTransparency=0 }):Play()
            TweenService:Create(bs, TweenInfo.new(DS.A.fast), { Transparency=0.15 }):Play()
        end)
        btn.MouseLeave:Connect(function()
            local restore = btn:GetAttribute("_baseColor") or C.card
            TweenService:Create(btn, TweenInfo.new(DS.A.fast), { BackgroundColor3=restore, BackgroundTransparency=0.02 }):Play()
            TweenService:Create(bs, TweenInfo.new(DS.A.fast), { Transparency=0.5 }):Play()
        end)
        btn.MouseButton1Click:Connect(function() tpToCoords(zone.name, zone.coords) end)
    end
end

makeSection(pageZones, "sec_my_points", "📍")
savedPositions, favoritedPoints = {}, {}
do
    local savedList = new("ScrollingFrame", {
        Size=UDim2.new(1,-8,0,0), BackgroundColor3=C.card, BorderSizePixel=0,
        ScrollBarThickness=5, ScrollBarImageColor3=C.accent, ScrollBarImageTransparency=0.4,
        CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, Parent=pageZones })
    corner(savedList, DS.R.card)
    stroke(savedList, C.border, 1, 0.5)
    new("UIListLayout", { Padding=UDim.new(0,5), Parent=savedList })
    new("UIPadding", { PaddingTop=UDim.new(0,6), PaddingBottom=UDim.new(0,6), PaddingLeft=UDim.new(0,6), PaddingRight=UDim.new(0,6), Parent=savedList })
    local function updateSavedListSize()
        local count = 0
        for _ in pairs(savedPositions) do count = count + 1 end
        if count == 0 then savedList.Size = UDim2.new(1,-8,0,0) savedList.Visible = false
        else savedList.Size = UDim2.new(1,-8,0,math.min(150, count*46+12)) savedList.Visible = true end
    end
    local function getUniquePointName()
        local maxN = 0
        for n, _ in pairs(savedPositions) do
            local num = tonumber(string.match(n, "^Point (%d+)$"))
            if num and num > maxN then maxN = num end
        end
        local candidate = "Point "..(maxN+1)
        while savedPositions[candidate] do maxN = maxN + 1 candidate = "Point "..maxN end
        return candidate
    end
    rebuildSavedList = function()
        for _, ch in ipairs(savedList:GetChildren()) do
            if not ch:IsA("UIListLayout") and not ch:IsA("UIPadding") then ch:Destroy() end
        end
        local list = {}
        for name, pos in pairs(savedPositions) do
            table.insert(list, {name=name, pos=pos, fav=favoritedPoints[name] == true})
        end
        table.sort(list, function(a, b)
            if a.fav and not b.fav then return true end
            if not a.fav and b.fav then return false end
            return string.lower(a.name) < string.lower(b.name)
        end)
        local idx = 0
        for _, item in ipairs(list) do
            idx = idx + 1
            local row = new("Frame", { Size=UDim2.new(1,-8,0,44), BackgroundColor3=C.bgAlt, BackgroundTransparency=0.3,
                BorderSizePixel=0, LayoutOrder=idx, Parent=savedList })
            corner(row, DS.R.card)
            local favBtn = new("TextButton", { Size=UDim2.new(0,32,1,0), Position=UDim2.new(0,4,0,0),
                BackgroundTransparency=1, Text=item.fav and "⭐" or "☆",
                TextColor3=C.gold, Font=DS.F.bold, TextSize=15,
                BorderSizePixel=0, AutoButtonColor=false, Parent=row })
            favBtn.MouseButton1Click:Connect(function()
                favoritedPoints[item.name] = not favoritedPoints[item.name]
                rebuildSavedList()
            end)
            local mainBtn = new("TextButton", { Size=UDim2.new(1,-110,1,0), Position=UDim2.new(0,38,0,0),
                BackgroundTransparency=1, Text="  "..item.name, TextColor3=C.text,
                Font=DS.F.body, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left,
                BorderSizePixel=0, AutoButtonColor=false, Parent=row })
            mainBtn.MouseButton1Click:Connect(function() tpToCoords(item.name, savedPositions[item.name]) end)
            new("TextLabel", { Size=UDim2.new(1,-110,0,12), Position=UDim2.new(0,38,0,26),
                BackgroundTransparency=1,
                Text=string.format("%d, %d, %d", math.floor(item.pos.X), math.floor(item.pos.Y), math.floor(item.pos.Z)),
                TextColor3=C.textMuted, Font=DS.F.mono, TextSize=9,
                TextXAlignment=Enum.TextXAlignment.Left, Parent=row })
            local renameBtn = new("TextButton", { Size=UDim2.new(0,28,0,28), Position=UDim2.new(1,-66,0.5,-14),
                BackgroundColor3=C.accent, BackgroundTransparency=0.15, Text="✏",
                TextColor3=C.text, Font=DS.F.bold, TextSize=11,
                BorderSizePixel=0, AutoButtonColor=false, Parent=row })
            corner(renameBtn, DS.R.small)
            local delBtn = createDeleteButton(row, 28, function()
                savedPositions[item.name] = nil
                favoritedPoints[item.name] = nil
                rebuildSavedList()
            end)
            delBtn.Position = UDim2.new(1,-34,0.5,-14)
            renameBtn.MouseButton1Click:Connect(function()
                showInputDialog(T("dlg_rename"), item.name, T("dlg_new_name"), function(newName)
                    if newName ~= item.name then
                        local posData, fav = savedPositions[item.name], favoritedPoints[item.name]
                        savedPositions[item.name] = nil favoritedPoints[item.name] = nil
                        savedPositions[newName] = posData
                        if fav then favoritedPoints[newName] = true end
                        rebuildSavedList()
                    end
                end)
            end)
        end
        task.defer(function() updateSavedListSize() end)
    end
    createButton(pageZones, "btn_save_pos", C.gold, function()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local name = getUniquePointName()
        savedPositions[name] = hrp.Position
        rebuildSavedList()
        showToast(string.format(T("toast_saved"), name), C.gold, "📍")
    end, "📍")
end

makeSection(pageZones, "sec_bosses_top", "💀")
do
    local bossList = new("Frame", { Size=UDim2.new(1,-8,0,0), BackgroundTransparency=1,
        AutomaticSize=Enum.AutomaticSize.Y, Parent=pageZones })
    new("UIListLayout", { Padding=UDim.new(0,DS.S.sm), SortOrder=Enum.SortOrder.LayoutOrder, Parent=bossList })
    for i, boss in ipairs(BOSSES) do
        local btn = new("TextButton", { Size=UDim2.new(1,0,0,54), BackgroundColor3=C.card,
            BackgroundTransparency=0.02, BorderSizePixel=0, AutoButtonColor=false,
            Text="", LayoutOrder=i, Parent=bossList })
        corner(btn, DS.R.card)
        local bs = stroke(btn, C.gold, 1, 0.45)
        local iconBox = new("Frame", { Size=UDim2.new(0,32,0,32), Position=UDim2.new(0,14,0.5,-16),
            BackgroundColor3=C.gold, BackgroundTransparency=0.82, BorderSizePixel=0, Parent=btn })
        corner(iconBox, DS.R.round)
        stroke(iconBox, C.gold, 1.2, 0.35)
        new("TextLabel", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
            Text="💀", TextColor3=C.gold, Font=DS.F.bold, TextSize=15, Parent=iconBox })
        new("TextLabel", { Size=UDim2.new(1,-60,0,18), Position=UDim2.new(0,56,0,8),
            BackgroundTransparency=1, Text=boss.name, TextColor3=C.gold,
            Font=DS.F.bold, TextSize=13.5, TextXAlignment=Enum.TextXAlignment.Left, Parent=btn })
        new("TextLabel", { Size=UDim2.new(1,-60,0,14), Position=UDim2.new(0,56,0,29),
            BackgroundTransparency=1,
            Text=string.format("%d, %d, %d  •  %s",
                math.floor(boss.coords.X), math.floor(boss.coords.Y), math.floor(boss.coords.Z),
                boss.note or ""),
            TextColor3=C.textMuted, Font=DS.F.mono, TextSize=10,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=btn })
        new("TextLabel", { Size=UDim2.new(0,26,0,26), Position=UDim2.new(1,-42,0.5,-13),
            BackgroundTransparency=1, Text="→", TextColor3=C.gold,
            Font=DS.F.bold, TextSize=17, Parent=btn })
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(DS.A.fast), { BackgroundColor3=C.hover, BackgroundTransparency=0 }):Play()
            TweenService:Create(bs, TweenInfo.new(DS.A.fast), { Transparency=0.1 }):Play()
            TweenService:Create(iconBox, TweenInfo.new(DS.A.fast), { BackgroundTransparency=0.65 }):Play()
        end)
        btn.MouseLeave:Connect(function()
            local restore = btn:GetAttribute("_baseColor") or C.card
            TweenService:Create(btn, TweenInfo.new(DS.A.fast), { BackgroundColor3=restore, BackgroundTransparency=0.02 }):Play()
            TweenService:Create(bs, TweenInfo.new(DS.A.fast), { Transparency=0.45 }):Play()
            TweenService:Create(iconBox, TweenInfo.new(DS.A.fast), { BackgroundTransparency=0.82 }):Play()
        end)
        btn.MouseButton1Click:Connect(function() tpToCoords(boss.name, boss.coords) end)
    end
end

makeSection(pageZones, "sec_bosses", "🗡")
do
    for _, group in ipairs(BOSSES_BY_ZONE) do
        local header = new("Frame", { Size=UDim2.new(1,-8,0,22), BackgroundTransparency=1, Parent=pageZones })
        local accent = new("Frame", { Size=UDim2.new(0,3,0,10), Position=UDim2.new(0,0,0.5,-5),
            BackgroundColor3=C.gold, BackgroundTransparency=0.3, BorderSizePixel=0, Parent=header })
        corner(accent, DS.R.round)
        new("TextLabel", { Size=UDim2.new(1,-10,1,0), Position=UDim2.new(0,10,0,0), BackgroundTransparency=1,
            Text=string.upper(group.zone), TextColor3=C.gold, Font=DS.F.bold, TextSize=10,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=header })
        local list = new("Frame", { Size=UDim2.new(1,-8,0,0), BackgroundTransparency=1,
            AutomaticSize=Enum.AutomaticSize.Y, Parent=pageZones })
        new("UIListLayout", { Padding=UDim.new(0,DS.S.xs), SortOrder=Enum.SortOrder.LayoutOrder, Parent=list })
        for i, boss in ipairs(group.bosses) do
            local btn = new("TextButton", { Size=UDim2.new(1,0,0,44), BackgroundColor3=C.card,
                BackgroundTransparency=0.02, BorderSizePixel=0, AutoButtonColor=false,
                Text="", LayoutOrder=i, Parent=list })
            corner(btn, DS.R.card)
            local bs = stroke(btn, C.border, 1, 0.5)
            local iconFrame = new("Frame", { Size=UDim2.new(0,28,0,28), Position=UDim2.new(0,10,0.5,-14),
                BackgroundColor3=C.danger, BackgroundTransparency=0.85, BorderSizePixel=0, Parent=btn })
            corner(iconFrame, DS.R.round)
            stroke(iconFrame, C.danger, 1, 0.4)
            new("TextLabel", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
                Text="💀", TextColor3=C.danger, Font=DS.F.bold, TextSize=13, Parent=iconFrame })
            new("TextLabel", { Size=UDim2.new(1,-130,0,16), Position=UDim2.new(0,48,0,7),
                BackgroundTransparency=1, Text=boss.name, TextColor3=C.text,
                Font=DS.F.bold, TextSize=12.5, TextXAlignment=Enum.TextXAlignment.Left, Parent=btn })
            new("TextLabel", { Size=UDim2.new(1,-130,0,12), Position=UDim2.new(0,48,0,24),
                BackgroundTransparency=1,
                Text=string.format("%d, %d, %d", math.floor(boss.coords.X), math.floor(boss.coords.Y), math.floor(boss.coords.Z)),
                TextColor3=C.textMuted, Font=DS.F.mono, TextSize=9,
                TextXAlignment=Enum.TextXAlignment.Left, Parent=btn })
            new("TextLabel", { Size=UDim2.new(0,22,0,22), Position=UDim2.new(1,-32,0.5,-11),
                BackgroundTransparency=1, Text="→", TextColor3=C.gold,
                Font=DS.F.bold, TextSize=15, Parent=btn })
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(DS.A.fast), { BackgroundColor3=C.hover, BackgroundTransparency=0 }):Play()
                TweenService:Create(bs, TweenInfo.new(DS.A.fast), { Transparency=0.15 }):Play()
            end)
            btn.MouseLeave:Connect(function()
                local restore = btn:GetAttribute("_baseColor") or C.card
                TweenService:Create(btn, TweenInfo.new(DS.A.fast), { BackgroundColor3=restore, BackgroundTransparency=0.02 }):Play()
                TweenService:Create(bs, TweenInfo.new(DS.A.fast), { Transparency=0.5 }):Play()
            end)
            btn.MouseButton1Click:Connect(function() tpToCoords(group.zone.." • "..boss.name, boss.coords) end)
        end
    end
end

makeSection(pageTP, "sec_players", "👥")
do
    local tpList = new("Frame", { Size=UDim2.new(1,-8,0,0), BackgroundTransparency=1,
        AutomaticSize=Enum.AutomaticSize.Y, Parent=pageTP })
    new("UIListLayout", { Padding=UDim.new(0,DS.S.sm), SortOrder=Enum.SortOrder.LayoutOrder, Parent=tpList })
    local lastKnownPos = {}
    local function getPlayerPosition(plr)
        local char = plr.Character
        if not char or not char.Parent then char = workspace:FindFirstChild(plr.Name) end
        if char and char:IsA("Model") then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:IsA("BasePart") then
                lastKnownPos[plr.UserId] = {pos=hrp.Position, time=tick()}
                return hrp.Position, "live", 0
            end
            for _, name in ipairs({"Head","UpperTorso","Torso","LowerTorso"}) do
                local p = char:FindFirstChild(name)
                if p and p:IsA("BasePart") then
                    lastKnownPos[plr.UserId] = {pos=p.Position, time=tick()}
                    return p.Position, "live", 0
                end
            end
            local ok, pivot = pcall(function() return char:GetPivot() end)
            if ok and pivot and pivot.Position.Magnitude > 1 then
                lastKnownPos[plr.UserId] = {pos=pivot.Position, time=tick()}
                return pivot.Position, "live", 0
            end
        end
        local cached = lastKnownPos[plr.UserId]
        if cached then return cached.pos, "cache", math.floor(tick() - cached.time) end
        return nil, "none", 0
    end
    local tpRows = {}
    local tpEmptyLabel = nil
    local function createTPRow(plr, order)
        local btn = new("TextButton", {
            Size=UDim2.new(1,0,0,58), BackgroundColor3=C.card, Text="",
            BackgroundTransparency=0.02, BorderSizePixel=0, AutoButtonColor=false,
            LayoutOrder=order, Parent=tpList })
        corner(btn, DS.R.card)
        local btnStroke = stroke(btn, C.border, 1, 0.5)
        local avatar = new("Frame", { Size=UDim2.new(0,32,0,32), Position=UDim2.new(0,14,0.5,-16),
            BackgroundColor3=C.accent, BackgroundTransparency=0.8, BorderSizePixel=0, Parent=btn })
        corner(avatar, DS.R.round)
        stroke(avatar, C.accent, 1, 0.4)
        new("TextLabel", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
            Text=string.upper(string.sub(plr.Name, 1, 1)),
            TextColor3=C.accent, Font=DS.F.bold, TextSize=14, Parent=avatar })
        local nameLbl = new("TextLabel", { Size=UDim2.new(1,-100,0,20), Position=UDim2.new(0,56,0,8),
            BackgroundTransparency=1, Text=plr.Name, TextColor3=C.text,
            Font=DS.F.bold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=btn })
        local subLbl = new("TextLabel", { Size=UDim2.new(1,-100,0,16), Position=UDim2.new(0,56,0,30),
            BackgroundTransparency=1, Text="...", TextColor3=C.textDim,
            Font=DS.F.subtle, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, Parent=btn })
        new("TextLabel", { Size=UDim2.new(0,28,0,28), Position=UDim2.new(1,-42,0.5,-14),
            BackgroundTransparency=1, Text="→", TextColor3=C.accent,
            Font=DS.F.bold, TextSize=18, Parent=btn })
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(DS.A.fast), { BackgroundColor3=C.hover, BackgroundTransparency=0 }):Play()
            TweenService:Create(btnStroke, TweenInfo.new(DS.A.fast), { Transparency=0.15 }):Play()
        end)
        btn.MouseLeave:Connect(function()
            local restore = btn:GetAttribute("_baseColor") or C.card
            TweenService:Create(btn, TweenInfo.new(DS.A.fast), { BackgroundColor3=restore, BackgroundTransparency=0.02 }):Play()
            TweenService:Create(btnStroke, TweenInfo.new(DS.A.fast), { Transparency=0.5 }):Play()
        end)
        btn.MouseButton1Click:Connect(function()
            local fresh = getPlayerPosition(plr)
            if fresh then
                teleportTo(Vector3.new(fresh.X, fresh.Y+3, fresh.Z))
                showToast(string.format(T("player_tp_to"), plr.Name), C.accent, "✓")
            else
                showToast(string.format(T("player_pos_unavail"), plr.Name), C.danger, "⚠")
            end
        end)
        return {btn=btn, nameLbl=nameLbl, subLbl=subLbl}
    end
    local function refreshTP()
        if isShuttingDown then return end
        local seen = {}
        local order = 0
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                seen[plr.UserId] = true
                order = order + 1
                local row = tpRows[plr.UserId]
                if not row then row = createTPRow(plr, order) tpRows[plr.UserId] = row
                else row.btn.LayoutOrder = order if row.nameLbl.Text ~= plr.Name then row.nameLbl.Text = plr.Name end end
                local pos, source, age = getPlayerPosition(plr)
                if pos then
                    local zone = getZoneByPos(pos)
                    local suffix = source == "cache" and ("  •  "..age.."s") or ""
                    local newSub = string.format("%d, %d, %d  •  %s%s",
                        math.floor(pos.X), math.floor(pos.Y), math.floor(pos.Z), zone, suffix)
                    if row.subLbl.Text ~= newSub then row.subLbl.Text = newSub end
                    if not currentTheme.forceLightText then
                        local liveColor = (source == "live") and C.text or C.textDim
                        if row.nameLbl.TextColor3 ~= liveColor then row.nameLbl.TextColor3 = liveColor end
                    end
                else
                    if row.subLbl.Text ~= T("lbl_pos_unavailable") then row.subLbl.Text = T("lbl_pos_unavailable") end
                end
            end
        end
        for uid, row in pairs(tpRows) do
            if not seen[uid] then row.btn:Destroy() tpRows[uid] = nil end
        end
        if order == 0 then
            if not tpEmptyLabel then
                tpEmptyLabel = new("TextLabel", {
                    Size=UDim2.new(1,0,0,40), BackgroundTransparency=1,
                    TextColor3=C.textMuted, Font=DS.F.subtle, TextSize=12,
                    TextXAlignment=Enum.TextXAlignment.Center, LayoutOrder=9999, Parent=tpList })
                tpEmptyLabel:SetAttribute("_langKey", "lbl_no_other_players")
                tpEmptyLabel.Text = T("lbl_no_other_players")
                table.insert(textRegistry, tpEmptyLabel)
            end
        else
            if tpEmptyLabel then tpEmptyLabel:Destroy() tpEmptyLabel = nil end
        end
    end
    scheduleHeartbeat(refreshTP, 0.15, "refreshTP")
    task.delay(0.2, function() if not isShuttingDown then pcall(refreshTP) end end)
    track(Players.PlayerRemoving:Connect(function(plr) lastKnownPos[plr.UserId] = nil end))
end

makeSection(pageFarm, "sec_autofarm", "⚔")
do
    local farmStartPos, farmRunning = nil, false
    local farmCharConn = nil
    local function startFarm()
        if farmRunning then return end
        farmRunning = true farmStartPos = nil
        if farmCharConn then pcall(function() farmCharConn:Disconnect() end) end
        farmCharConn = track(LocalPlayer.CharacterAdded:Connect(function()
            task.wait(0.8)
            local c = LocalPlayer.Character
            if c then local h = c:FindFirstChild("HumanoidRootPart") if h then farmStartPos = h.Position end end
        end))
        showToast(T("toast_autofarm_on"), C.success, "⚔")
        task.spawn(function()
            task.wait(1)
            if not farmRunning then return end
            while farmRunning and Config.AutoFarm and not isShuttingDown do
                invalidateMobCache()
                pcall(function()
                    local mob = getNearestMob()
                    if not mob then task.wait(0.5) return end
                    local char = LocalPlayer.Character
                    if not char then return end
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    if not farmStartPos then farmStartPos = hrp.Position end
                    teleportTo(mob.hrp.Position + Vector3.new(0,3,2))
                    task.wait(0.15)
                    local bp = LocalPlayer:FindFirstChild("Backpack")
                    if bp and not char:FindFirstChildOfClass("Tool") then
                        local tool = bp:FindFirstChildOfClass("Tool")
                        if tool then
                            local hum = char:FindFirstChildOfClass("Humanoid")
                            if hum then pcall(function() hum:EquipTool(tool) end) end
                        end
                    end
                    clickLeftMouse()
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then pcall(function() tool:Activate() end) end
                    task.wait(Config.AutoFarmDelay)
                    if Config.AutoFarmReturn and farmStartPos then teleportTo(farmStartPos) end
                end)
                task.wait(0.05)
            end
            farmRunning = false
            if farmCharConn then pcall(function() farmCharConn:Disconnect() end) farmCharConn = nil end
        end)
    end
    local function stopFarm()
        local wasRunning = farmRunning
        farmRunning = false Config.AutoFarm = false
        if farmCharConn then pcall(function() farmCharConn:Disconnect() end) farmCharConn = nil end
        if wasRunning then showToast(T("toast_autofarm_off"), C.warn, "⚔") end
    end
    createToggle(pageFarm, "tog_autofarm", false, function(s)
        Config.AutoFarm = s
        if s then startFarm() else stopFarm() end
    end, "AutoFarm", "desc_autofarm")
    createToggle(pageFarm, "tog_return", true, function(s)
        Config.AutoFarmReturn = s
        showToast(s and T("toast_return_on") or T("toast_return_off"), s and C.success or C.warn, "🔁")
    end, "AutoFarmReturn")
    createSlider(pageFarm, "lbl_hit_delay", 1, 30, 8, C.accent, function(v) Config.AutoFarmDelay = v/10 end, "AutoFarmDelay")
end

makeSection(pageHitbox, "sec_mob_hitbox", "👊")
do
    local hitboxOriginals, hitboxTaskId = {}, nil

    local function findBaseParts(mob)
        local parts = {}
        for _, name in ipairs({"HumanoidRootPart","RootPart","Head","Torso","UpperTorso","LowerTorso","Shell"}) do
            local p = mob:FindFirstChild(name)
            if p and p:IsA("BasePart") then table.insert(parts, p) end
        end
        if #parts == 0 then
            for _, d in ipairs(mob:GetDescendants()) do if d:IsA("BasePart") then table.insert(parts, d) end end
        end
        return parts
    end

    local function restorePart(part, orig)
        if not part or not orig then return end
        if not part.Parent then return end
        pcall(function()
            part.Size = orig.Size
            part.CanCollide = orig.CanCollide
            part.Transparency = orig.Transparency
            part.Massless = orig.Massless
        end)
    end

    local function isMobDead(model)
        if not model or not model.Parent then return true end
        if model:GetAttribute("Dead") == true then return true end
        local hum = model:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then return true end
        return false
    end

    local function expandHitbox()
        local alive = {}
        for _, data in ipairs(getAllMobs()) do alive[data.model] = true end

        for part, orig in pairs(hitboxOriginals) do
            local shouldRestore = false
            if not part or not part.Parent then
                shouldRestore = true
            else
                local model = part:FindFirstAncestorOfClass("Model")
                if not model or not alive[model] or isMobDead(model) then
                    shouldRestore = true
                end
            end
            if shouldRestore then
                restorePart(part, orig)
                hitboxOriginals[part] = nil
            end
        end

        for _, data in ipairs(getAllMobs()) do
            if not isMobDead(data.model) then
                for _, part in ipairs(findBaseParts(data.model)) do
                    if not hitboxOriginals[part] then
                        hitboxOriginals[part] = {
                            Size = part.Size,
                            CanCollide = part.CanCollide,
                            Transparency = part.Transparency,
                            Massless = part.Massless,
                        }
                    end
                    local s = math.max(1, Config.HitboxSize)
                    local targetSize = Vector3.new(s,s,s)
                    if part.Size ~= targetSize then part.Size = targetSize end
                    if part.CanCollide then part.CanCollide = false end
                    if part.Transparency ~= 0.5 then part.Transparency = 0.5 end
                    if not part.Massless then part.Massless = true end
                end
            end
        end
    end

    local function restoreHitboxes()
        Config.HitboxEnabled = false
        if hitboxTaskId then unscheduleHeartbeat(hitboxTaskId) hitboxTaskId = nil end
        for part, orig in pairs(hitboxOriginals) do
            restorePart(part, orig)
        end
        hitboxOriginals = {}
    end

    local function toggleHitbox(state)
        Config.HitboxEnabled = state
        if state then
            expandHitbox()
            if hitboxTaskId then unscheduleHeartbeat(hitboxTaskId) end
            hitboxTaskId = scheduleHeartbeat(function()
                if Config.HitboxEnabled and not isShuttingDown then expandHitbox() end
            end, 0.1, "hitbox")
            showToast(string.format(T("toast_hitbox_on"), Config.HitboxSize), C.gold, "👊")
        else
            restoreHitboxes()
            showToast(T("toast_hitbox_off"), C.warn, "👊")
        end
    end

    createToggle(pageHitbox, "tog_hitbox", false, toggleHitbox, "HitboxEnabled", "desc_hitbox")
    createSlider(pageHitbox, "lbl_hitbox_size", 1, 600, 15, C.gold, function(v)
        Config.HitboxSize = math.max(1, v)
        if Config.HitboxEnabled then expandHitbox() end
    end, "HitboxSize")
    createButton(pageHitbox, "btn_restore_hitboxes", C.warn, function()
        if toggleRegistry["HitboxEnabled"] then toggleRegistry["HitboxEnabled"].setState(false, true)
        else restoreHitboxes() end
        showToast(T("toast_hitbox_restored"), C.success, "✓")
    end, "🔄")
end

makeSection(pageHitbox, "sec_kill_aura", "⚡")
do
    local killAuraRunning = false
    local function attackMob(data)
        local char = LocalPlayer.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            pcall(function() tool:Activate() end)
        end
        clickLeftMouse()
    end
    local function startKillAura()
        if killAuraRunning then return end
        killAuraRunning = true
        showToast(string.format(T("toast_kill_aura_on"), Config.KillAuraRange), C.danger, "⚡")
        task.spawn(function()
            while Config.KillAura and killAuraRunning and not isShuttingDown do
                local char = LocalPlayer.Character
                local myHrp = char and char:FindFirstChild("HumanoidRootPart")
                if myHrp then
                    local mobs = getAllMobs()
                    local range = Config.KillAuraRange
                    local inRange = {}
                    for _, data in ipairs(mobs) do
                        if data.hrp and data.hrp.Parent then
                            local dist = (data.hrp.Position - myHrp.Position).Magnitude
                            if dist <= range and not (data.hp and data.hp <= 0) then
                                table.insert(inRange, {data=data, dist=dist})
                            end
                        end
                    end
                    table.sort(inRange, function(a, b) return a.dist < b.dist end)
                    for _, entry in ipairs(inRange) do
                        if not Config.KillAura or isShuttingDown then break end
                        pcall(attackMob, entry.data)
                    end
                end
                task.wait(Config.KillAuraDelay)
            end
            killAuraRunning = false
        end)
    end
    local function stopKillAura()
        Config.KillAura = false
        killAuraRunning = false
        showToast(T("toast_kill_aura_off"), C.warn, "⚡")
    end
    createToggle(pageHitbox, "tog_kill_aura", false, function(state)
        Config.KillAura = state
        if state then startKillAura() else stopKillAura() end
    end, "KillAura", "desc_kill_aura")
    createSlider(pageHitbox, "lbl_kill_aura_range", 50, 1000, 300, C.danger, function(v)
        Config.KillAuraRange = v
    end, "KillAuraRange")
    createSlider(pageHitbox, "lbl_kill_aura_delay", 1, 20, 15, C.warn, function(v)
        Config.KillAuraDelay = v / 100
    end, "KillAuraDelay")
end

local espColorButtons, setESPColor
do
    local espHighlights, espBillboards = {}, {}
    local espTaskId = nil
    local playerESP = { highlights = {}, billboards = {} }
    local playerESPTaskId = nil
    local function createESP(mob)
        if not mob or espHighlights[mob] or mob == LocalPlayer.Character then return end
        local hl = Instance.new("Highlight")
        hl.FillColor = Config.ESPColor
        hl.OutlineColor = Color3.fromRGB(255,255,255)
        hl.FillTransparency = 0.6 hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = mob
        espHighlights[mob] = hl
    end
    local function updateBillboardFor(mob, data, myHrp)
        local bbData = espBillboards[mob]
        if not bbData then
            local hrp = (mob:IsA("Model") and (mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("RootPart"))) or (mob:IsA("BasePart") and mob)
            if not hrp then return end
            local bb = Instance.new("BillboardGui")
            bb.Size = UDim2.new(0,200,0,22) bb.StudsOffset = Vector3.new(0,5,0)
            bb.AlwaysOnTop = true bb.Adornee = hrp bb.Parent = mob
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1,0,1,0) label.BackgroundTransparency = 1
            label.TextColor3 = Config.ESPColor
            label.TextStrokeTransparency = 0 label.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            label.Font = Enum.Font.GothamBold label.TextSize = 14
            label.Text = data.displayName or mob.Name
            label.Parent = bb
            espBillboards[mob] = {gui=bb, label=label}
            bbData = espBillboards[mob]
        end
        local dist = math.floor((data.hrp.Position - myHrp.Position).Magnitude)
        local parts = {data.displayName or mob.Name}
        if data.isBoss then parts[1] = "💀 "..parts[1] end
        if Config.ESPShowHP then
            if data.hp and data.maxHp then parts[#parts+1] = formatNumber(data.hp).."/"..formatNumber(data.maxHp)
            elseif data.hpText and data.maxHpText then parts[#parts+1] = data.hpText.."/"..data.maxHpText
            else parts[#parts+1] = "HP ?" end
        end
        if Config.ESPShowDist then parts[#parts+1] = dist.."m" end
        local newText = table.concat(parts, "  ·  ")
        if bbData.label.Text ~= newText then bbData.label.Text = newText end
    end
    local function updateESP()
        if not Config.ESPEnabled or isShuttingDown then return end
        local char = LocalPlayer.Character
        local myHrp = char and char:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        local seen = {}
        for _, data in ipairs(getAllMobs()) do
            seen[data.model] = true
            createESP(data.model)
            updateBillboardFor(data.model, data, myHrp)
        end
        for mob, hl in pairs(espHighlights) do
            if not seen[mob] then
                if hl and hl.Parent then hl:Destroy() end
                espHighlights[mob] = nil
                local bb = espBillboards[mob]
                if bb and bb.gui and bb.gui.Parent then bb.gui:Destroy() end
                espBillboards[mob] = nil
            end
        end
    end
    local function removeAllESP()
        for _, hl in pairs(espHighlights) do if hl and hl.Parent then hl:Destroy() end end
        for _, data in pairs(espBillboards) do if data.gui and data.gui.Parent then data.gui:Destroy() end end
        espHighlights = {} espBillboards = {}
    end
    local function refreshBillboards()
        for _, data in pairs(espBillboards) do if data.gui and data.gui.Parent then data.gui:Destroy() end end
        espBillboards = {}
        if Config.ESPEnabled then task.defer(updateESP) end
    end
    makeSection(pageVisual, "sec_mob_esp", "👁")
    createToggle(pageVisual, "tog_mob_esp", false, function(state)
        Config.ESPEnabled = state
        if state then
            if not espTaskId then espTaskId = scheduleHeartbeat(updateESP, 0.08, "espUpdate") end
            showToast(T("toast_esp_mobs_on"), C.success, "👁")
        else
            if espTaskId then unscheduleHeartbeat(espTaskId) espTaskId = nil end
            removeAllESP()
            showToast(T("toast_esp_mobs_off"), C.warn, "👁")
        end
    end, "ESPEnabled", "desc_mob_esp")
    createToggle(pageVisual, "tog_mob_hp", true, function(s) Config.ESPShowHP = s refreshBillboards() end, "ESPShowHP")
    createToggle(pageVisual, "tog_mob_dist", true, function(s) Config.ESPShowDist = s refreshBillboards() end, "ESPShowDist")
    local function createPlayerESP(char)
        if not char or playerESP.highlights[char] or char == LocalPlayer.Character then return end
        local hl = Instance.new("Highlight")
        hl.FillColor = Config.ESPColor
        hl.OutlineColor = Color3.fromRGB(255,255,255)
        hl.FillTransparency = 0.6 hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = char
        playerESP.highlights[char] = hl
    end
    local function updatePlayerBillboard(plr, char, myHrp)
        local bbData = playerESP.billboards[char]
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if not bbData then
            local bb = Instance.new("BillboardGui")
            bb.Size = UDim2.new(0,200,0,22) bb.StudsOffset = Vector3.new(0,5,0)
            bb.AlwaysOnTop = true bb.Adornee = hrp bb.Parent = char
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1,0,1,0) label.BackgroundTransparency = 1
            label.TextColor3 = Config.ESPColor
            label.TextStrokeTransparency = 0 label.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            label.Font = Enum.Font.GothamBold label.TextSize = 14
            label.Text = plr.Name
            label.Parent = bb
            playerESP.billboards[char] = {gui=bb, label=label, plr=plr}
            bbData = playerESP.billboards[char]
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hp, maxHp = 0, 0
        if hum then hp = math.floor(hum.Health or 0) maxHp = math.floor(hum.MaxHealth or 100) end
        local dist = math.floor((hrp.Position - myHrp.Position).Magnitude)
        local parts = {plr.Name}
        if Config.ESPPlayersShowHP then parts[#parts+1] = formatNumber(hp).."/"..formatNumber(maxHp) end
        if Config.ESPPlayersShowDist then parts[#parts+1] = dist.."m" end
        local newText = table.concat(parts, "  ·  ")
        if bbData.label.Text ~= newText then bbData.label.Text = newText end
    end
    local function updatePlayerESP()
        if not Config.ESPPlayers or isShuttingDown then return end
        local myChar = LocalPlayer.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        local seen = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local char = plr.Character
                if char and char.Parent then
                    seen[char] = true
                    createPlayerESP(char)
                    updatePlayerBillboard(plr, char, myHrp)
                end
            end
        end
        for char, hl in pairs(playerESP.highlights) do
            if not seen[char] then
                if hl and hl.Parent then hl:Destroy() end
                playerESP.highlights[char] = nil
            end
        end
        for char, data in pairs(playerESP.billboards) do
            if not seen[char] then
                if data.gui and data.gui.Parent then data.gui:Destroy() end
                playerESP.billboards[char] = nil
            end
        end
    end
    local function removeAllPlayerESP()
        for _, hl in pairs(playerESP.highlights) do if hl and hl.Parent then hl:Destroy() end end
        for _, d in pairs(playerESP.billboards) do if d.gui and d.gui.Parent then d.gui:Destroy() end end
        playerESP.highlights = {} playerESP.billboards = {}
    end
    local function refreshPlayerBillboards()
        for _, d in pairs(playerESP.billboards) do if d.gui and d.gui.Parent then d.gui:Destroy() end end
        playerESP.billboards = {}
        if Config.ESPPlayers then task.defer(updatePlayerESP) end
    end
    makeSection(pageVisual, "sec_player_esp", "🧑")
    createToggle(pageVisual, "tog_player_esp", false, function(state)
        Config.ESPPlayers = state
        if state then
            if not playerESPTaskId then playerESPTaskId = scheduleHeartbeat(updatePlayerESP, 0.1, "espPlayers") end
            task.defer(function() if not isShuttingDown then pcall(updatePlayerESP) end end)
            showToast(T("toast_esp_plr_on"), C.success, "🧑")
        else
            if playerESPTaskId then unscheduleHeartbeat(playerESPTaskId) playerESPTaskId = nil end
            removeAllPlayerESP()
            showToast(T("toast_esp_plr_off"), C.warn, "🧑")
        end
    end, "ESPPlayers", "desc_player_esp")
    createToggle(pageVisual, "tog_player_hp", true, function(s)
        Config.ESPPlayersShowHP = s refreshPlayerBillboards()
    end, "ESPPlayersShowHP", "desc_player_hp")
    createToggle(pageVisual, "tog_player_dist", true, function(s)
        Config.ESPPlayersShowDist = s refreshPlayerBillboards()
    end, "ESPPlayersShowDist", "desc_player_dist")
    makeSection(pageVisual, "sec_esp_color", "🎨")
    local ESP_PRESETS = {
        {name="Red", color=Color3.fromRGB(255,60,60)}, {name="Orange", color=Color3.fromRGB(255,150,50)},
        {name="Yellow", color=Color3.fromRGB(255,220,60)}, {name="Green", color=Color3.fromRGB(80,220,100)},
        {name="Cyan", color=Color3.fromRGB(60,220,220)}, {name="Blue", color=Color3.fromRGB(70,140,255)},
        {name="Purple", color=Color3.fromRGB(170,110,255)}, {name="Pink", color=Color3.fromRGB(255,110,190)},
        {name="White", color=Color3.fromRGB(255,255,255)}, {name="Black", color=Color3.fromRGB(30,30,30)},
    }
    local espColorGrid = new("Frame", { Size=UDim2.new(1,-8,0,68), BackgroundTransparency=1, Parent=pageVisual })
    new("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,8),
        SortOrder=Enum.SortOrder.LayoutOrder, Wraps=true, Parent=espColorGrid })
    espColorButtons = {}
    setESPColor = function(color)
        Config.ESPColor = color
        for _, hl in pairs(espHighlights) do if hl and hl.Parent then hl.FillColor = color end end
        for _, data in pairs(espBillboards) do if data.label and data.label.Parent then data.label.TextColor3 = color end end
        for _, hl in pairs(playerESP.highlights) do if hl and hl.Parent then hl.FillColor = color end end
        for _, data in pairs(playerESP.billboards) do if data.label and data.label.Parent then data.label.TextColor3 = color end end
        for _, btn in ipairs(espColorButtons) do
            local isCurrent = btn.color == color
            btn.inst.BackgroundColor3 = btn.color
            if isCurrent then
                btn.stroke.Color = Color3.fromRGB(255,255,255) btn.stroke.Thickness = 2.5 btn.stroke.Transparency = 0
            else
                btn.stroke.Color = Color3.fromRGB(80,80,90) btn.stroke.Thickness = 1 btn.stroke.Transparency = 0.3
            end
        end
        return color
    end
    for i, preset in ipairs(ESP_PRESETS) do
        local btn = new("TextButton", { Size=UDim2.new(0,36,0,36), BackgroundColor3=preset.color,
            Text="", BorderSizePixel=0, AutoButtonColor=false, LayoutOrder=i, Parent=espColorGrid })
        corner(btn, DS.R.chip)
        local s = stroke(btn, Color3.fromRGB(80,80,90), 1, 0.3)
        btn:SetAttribute("_bgRole", nil) btn:SetAttribute("_baseColor", nil)
        table.insert(espColorButtons, {inst=btn, color=preset.color, stroke=s})
        btn.MouseButton1Click:Connect(function()
            setESPColor(preset.color)
            showToast(string.format(T("toast_esp_color"), preset.name), preset.color, "🎨")
        end)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(DS.A.fast), { Size=UDim2.new(0,38,0,38) }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(DS.A.fast), { Size=UDim2.new(0,36,0,36) }):Play()
        end)
    end
    task.defer(function() setESPColor(Config.ESPColor) end)
end

makeSection(pageVisual, "sec_lighting", "🎨")
local originalLighting, originalZoom
do
    local function toggleFullbright(state)
        Config.Fullbright = state
        if state then
            if not originalLighting then
                originalLighting = {Brightness=Lighting.Brightness, Ambient=Lighting.Ambient, OutdoorAmbient=Lighting.OutdoorAmbient, ClockTime=Lighting.ClockTime, GlobalShadows=Lighting.GlobalShadows}
            end
            Lighting.Brightness=3 Lighting.Ambient=Color3.fromRGB(255,255,255)
            Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255)
            Lighting.ClockTime=12 Lighting.GlobalShadows=false
            showToast(T("toast_fullbright_on"), C.success, "🌞")
        elseif originalLighting then
            pcall(function()
                Lighting.Brightness=originalLighting.Brightness Lighting.Ambient=originalLighting.Ambient
                Lighting.OutdoorAmbient=originalLighting.OutdoorAmbient Lighting.ClockTime=originalLighting.ClockTime
                Lighting.GlobalShadows=originalLighting.GlobalShadows
            end)
            originalLighting = nil
            showToast(T("toast_fullbright_off"), C.warn, "🌞")
        end
    end
    createToggle(pageVisual, "tog_fullbright", false, toggleFullbright, "Fullbright", "desc_fullbright")
    local fogOriginals, createdAtm = nil, nil
    local function toggleNoFog(state)
        Config.NoFog = state
        if state then
            if not fogOriginals then
                fogOriginals = {FogEnd=Lighting.FogEnd, FogStart=Lighting.FogStart, FogColor=Lighting.FogColor, Effects={}}
                for _, ch in ipairs(Lighting:GetChildren()) do
                    if ch:IsA("ColorCorrectionEffect") then fogOriginals.Effects[ch] = {Brightness=ch.Brightness, Contrast=ch.Contrast, Saturation=ch.Saturation}
                    elseif ch:IsA("BloomEffect") then fogOriginals.Effects[ch] = {Intensity=ch.Intensity, Size=ch.Size}
                    elseif ch:IsA("SunRaysEffect") then fogOriginals.Effects[ch] = {Intensity=ch.Intensity}
                    elseif ch:IsA("DepthOfFieldEffect") then fogOriginals.Effects[ch] = {FarIntensity=ch.FarIntensity, NearIntensity=ch.NearIntensity, InFocusRadius=ch.InFocusRadius}
                    end
                end
                local atm = Lighting:FindFirstChildOfClass("Atmosphere")
                if atm then fogOriginals.AtmosphereRef = atm fogOriginals.AtmosphereData = {Density=atm.Density, Haze=atm.Haze, Glare=atm.Glare} end
            end
            Lighting.FogEnd = 100000 Lighting.FogStart = 100000
            local atm = Lighting:FindFirstChildOfClass("Atmosphere")
            if atm then atm.Density=0 atm.Haze=0 atm.Glare=0
            else
                createdAtm = Instance.new("Atmosphere")
                createdAtm.Density=0 createdAtm.Haze=0 createdAtm.Glare=0
                createdAtm.Parent = Lighting
            end
            for _, ch in ipairs(Lighting:GetChildren()) do
                if ch:IsA("ColorCorrectionEffect") then ch.Brightness=0 ch.Contrast=0 ch.Saturation=0
                elseif ch:IsA("BloomEffect") then ch.Intensity=0 ch.Size=0
                elseif ch:IsA("SunRaysEffect") then ch.Intensity=0
                elseif ch:IsA("DepthOfFieldEffect") then ch.FarIntensity=0 ch.NearIntensity=0 ch.InFocusRadius=0 end
            end
            showToast(T("toast_fog_off"), C.success, "🌫")
        elseif fogOriginals then
            pcall(function()
                Lighting.FogEnd=fogOriginals.FogEnd Lighting.FogStart=fogOriginals.FogStart Lighting.FogColor=fogOriginals.FogColor
            end)
            for effect, data in pairs(fogOriginals.Effects) do
                if effect and effect.Parent then pcall(function() for k,v in pairs(data) do effect[k]=v end end) end
            end
            if fogOriginals.AtmosphereRef and fogOriginals.AtmosphereRef.Parent then
                pcall(function() for k,v in pairs(fogOriginals.AtmosphereData) do fogOriginals.AtmosphereRef[k]=v end end)
            end
            if createdAtm then pcall(function() createdAtm:Destroy() end) createdAtm = nil end
            fogOriginals = nil
            showToast(T("toast_fog_on"), C.warn, "🌫")
        end
    end
    createToggle(pageVisual, "tog_nofog", false, toggleNoFog, "NoFog")
    local function toggleZoom(state)
        Config.ZoomEnabled = state
        if state then
            if not originalZoom then originalZoom = LocalPlayer.CameraMaxZoomDistance end
            LocalPlayer.CameraMaxZoomDistance = Config.ZoomValue
            LocalPlayer.CameraMinZoomDistance = Config.ZoomValue / 2
            showToast(string.format(T("toast_cam_on"), Config.ZoomValue), C.success, "🔍")
        else
            pcall(function()
                LocalPlayer.CameraMaxZoomDistance = originalZoom or 128
                LocalPlayer.CameraMinZoomDistance = 0.5
            end)
            showToast(T("toast_cam_off"), C.warn, "🔍")
        end
    end
    createToggle(pageVisual, "tog_zoom", false, toggleZoom, "ZoomEnabled")
    createSlider(pageVisual, "lbl_zoom_value", 50, 2000, 500, C.accent2, function(v)
        Config.ZoomValue = v
        if Config.ZoomEnabled then
            pcall(function() LocalPlayer.CameraMaxZoomDistance = v LocalPlayer.CameraMinZoomDistance = v/2 end)
        end
    end, "ZoomValue")
end

do
    local trackerConn, lastTrackerUpdate = nil, 0
    local currentSortMode = "Distance"
    local statsRef = {}
    local trackerListRef = nil
    local updateTracker
    local trackerRowMap = {}
    local function makeMiniSection(parent, textKey, icon)
        local row = new("Frame", { Size=UDim2.new(1,-8,0,18), BackgroundTransparency=1, Parent=parent })
        local accent = new("Frame", { Size=UDim2.new(0,3,0,11), Position=UDim2.new(0,0,0.5,-5.5),
            BackgroundColor3=C.accent, BackgroundTransparency=0.3, BorderSizePixel=0, Parent=row })
        corner(accent, DS.R.round)
        local lbl = new("TextLabel", { Size=UDim2.new(1,-10,1,0), Position=UDim2.new(0,10,0,0), BackgroundTransparency=1,
            Text=(icon and (icon.." ") or "")..string.upper(T(textKey)),
            TextColor3=C.textMuted, Font=DS.F.bold, TextSize=9,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=row })
        lbl:SetAttribute("_langSectionKey", textKey)
        lbl:SetAttribute("_langSectionIcon", icon or "")
        table.insert(textRegistry, lbl)
    end
    createToggle(pageTracker, "tog_tracker", false, function(state)
        Config.MobTracker = state
        if trackerListRef then trackerListRef.Visible = state end
        if state then
            if trackerConn then pcall(function() trackerConn:Disconnect() end) end
            trackerConn = track(RunService.Heartbeat:Connect(function()
                if isShuttingDown then return end
                if tick() - lastTrackerUpdate > 0.6 then
                    lastTrackerUpdate = tick()
                    pcall(updateTracker)
                end
            end))
            task.defer(function() if not isShuttingDown then pcall(updateTracker) end end)
            showToast(T("toast_tracker_on"), C.success, "📊")
        else
            if trackerConn then pcall(function() trackerConn:Disconnect() end) trackerConn = nil end
            if trackerListRef then
                for _, ch in ipairs(trackerListRef:GetChildren()) do
                    if ch:IsA("TextButton") or ch:IsA("TextLabel") then ch:Destroy() end
                end
            end
            trackerRowMap = {}
            if statsRef.mobs then statsRef.mobs.Text = "0" end
            if statsRef.hp then statsRef.hp.Text = "0" end
            if statsRef.nearest then statsRef.nearest.Text = "—" end
            showToast(T("toast_tracker_off"), C.warn, "📊")
        end
    end, "MobTracker", "desc_tracker")
    makeMiniSection(pageTracker, "sec_stats_tracker", "📈")
    local statsRow = new("Frame", { Size=UDim2.new(1,-8,0,72), BackgroundTransparency=1, Parent=pageTracker })
    new("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,8), SortOrder=Enum.SortOrder.LayoutOrder, Parent=statsRow })
    local function createStatCard(labelKey, icon, color, order)
        local card = new("Frame", { Size=UDim2.new(0.333,-6,1,0), BackgroundColor3=C.card, BorderSizePixel=0, LayoutOrder=order, Parent=statsRow })
        corner(card, DS.R.card)
        stroke(card, C.border, 1, 0.5)
        local badge = new("Frame", { Size=UDim2.new(0,22,0,22), Position=UDim2.new(0,10,0,10),
            BackgroundColor3=color, BackgroundTransparency=0.82, BorderSizePixel=0, Parent=card })
        corner(badge, DS.R.round)
        stroke(badge, color, 1, 0.4)
        new("TextLabel", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text=icon,
            TextColor3=color, Font=DS.F.bold, TextSize=11, Parent=badge })
        regLang(new("TextLabel", { Size=UDim2.new(1,-40,0,14), Position=UDim2.new(0,38,0,13),
            BackgroundTransparency=1, TextColor3=C.textMuted,
            Font=DS.F.bold, TextSize=9,
            TextXAlignment=Enum.TextXAlignment.Left, Parent=card }), labelKey)
        return new("TextLabel", { Size=UDim2.new(1,-16,0,26), Position=UDim2.new(0,10,0,36),
            BackgroundTransparency=1, Text="0", TextColor3=color,
            Font=DS.F.title, TextSize=21, TextXAlignment=Enum.TextXAlignment.Left, Parent=card })
    end
    statsRef.mobs = createStatCard("stat_mobs", "👾", C.accent, 1)
    statsRef.hp = createStatCard("stat_hp", "❤", C.success, 2)
    statsRef.nearest = createStatCard("stat_nearest", "🎯", C.gold, 3)
    local sortBar = new("Frame", { Size=UDim2.new(1,-8,0,38), BackgroundColor3=C.card, BorderSizePixel=0, Parent=pageTracker })
    corner(sortBar, DS.R.card)
    stroke(sortBar, C.border, 1, 0.5)
    regLang(new("TextLabel", { Size=UDim2.new(0,60,1,0), Position=UDim2.new(0,16,0,0), BackgroundTransparency=1,
        TextColor3=C.textMuted, Font=DS.F.bold, TextSize=9,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=sortBar }), "lbl_sort")
    local sortLayout = new("Frame", { Size=UDim2.new(1,-80,1,0), Position=UDim2.new(0,66,0,0), BackgroundTransparency=1, Parent=sortBar })
    new("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,6), VerticalAlignment=Enum.VerticalAlignment.Center, SortOrder=Enum.SortOrder.LayoutOrder, Parent=sortLayout })
    local sortModes = {
        {name="Distance", key="sort_dist"}, {name="Boss", key="sort_boss"},
        {name="HP", key="sort_hp"}, {name="Name", key="sort_name"},
    }
    local sortButtons = {}
    for i, mode in ipairs(sortModes) do
        local sb = new("TextButton", { Size=UDim2.new(0,0,0,26), AutomaticSize=Enum.AutomaticSize.X,
            BackgroundColor3=(i==1) and C.accent or C.bgAlt, BackgroundTransparency=(i==1) and 0 or 0.3,
            TextColor3=C.text, Font=DS.F.body, TextSize=11,
            BorderSizePixel=0, AutoButtonColor=false, LayoutOrder=i, Parent=sortLayout })
        regLang(sb, mode.key)
        corner(sb, DS.R.chip)
        new("UIPadding", { PaddingLeft=UDim.new(0,12), PaddingRight=UDim.new(0,12), Parent=sb })
        sortButtons[mode.name] = sb
        sb.MouseButton1Click:Connect(function()
            currentSortMode = mode.name
            for n, btn in pairs(sortButtons) do
                local role = (n==mode.name) and "accent" or "bgAlt"
                local col = (role == "accent") and C.accent or C.bgAlt
                btn.BackgroundColor3 = col
                btn.BackgroundTransparency = (role == "accent") and 0 or 0.3
                btn:SetAttribute("_bgRole", role)
                btn:SetAttribute("_baseColor", col)
            end
            task.defer(function() if not isShuttingDown then pcall(updateTracker) end end)
        end)
    end
    local trackerList = new("ScrollingFrame", {
        Size=UDim2.new(1,-8,0,200), BackgroundColor3=C.card, BorderSizePixel=0,
        ScrollBarThickness=5, ScrollBarImageColor3=C.accent, ScrollBarImageTransparency=0.4,
        CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
        Visible=false, Parent=pageTracker })
    corner(trackerList, DS.R.card)
    stroke(trackerList, C.border, 1, 0.5)
    new("UIListLayout", { Padding=UDim.new(0,5), Parent=trackerList })
    new("UIPadding", { PaddingTop=UDim.new(0,8), PaddingBottom=UDim.new(0,8), PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8), Parent=trackerList })
    trackerListRef = trackerList
    updateTracker = function()
        if not Config.MobTracker or isShuttingDown then return end
        local char = LocalPlayer.Character
        local myHrp = char and char:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        local mobs = {}
        for _, data in ipairs(getAllMobs()) do
            table.insert(mobs, {
                model = data.model,
                name = data.displayName or (data.model and data.model.Name) or "?",
                hrp = data.hrp,
                dist = math.floor((data.hrp.Position - myHrp.Position).Magnitude),
                hp = data.hp, maxHp = data.maxHp,
                hpText = data.hpText, maxHpText = data.maxHpText,
                isBoss = data.isBoss,
            })
        end
        if currentSortMode == "Distance" then
            table.sort(mobs, function(a,b) if a.dist~=b.dist then return a.dist<b.dist end return a.name<b.name end)
        elseif currentSortMode == "Boss" then
            table.sort(mobs, function(a,b)
                local aB, bB = a.isBoss and 1 or 0, b.isBoss and 1 or 0
                if aB~=bB then return aB>bB end
                return (a.hp or 0) < (b.hp or 0)
            end)
        elseif currentSortMode == "HP" then
            table.sort(mobs, function(a,b) return (a.hp or 0)<(b.hp or 0) end)
        elseif currentSortMode == "Name" then
            table.sort(mobs, function(a,b) return string.lower(a.name)<string.lower(b.name) end)
        end
        local totalHP, nearestDist = 0, math.huge
        for _, m in ipairs(mobs) do
            totalHP = totalHP + (m.hp or 0)
            if m.dist < nearestDist then nearestDist = m.dist end
        end
        if statsRef.mobs then statsRef.mobs.Text = tostring(#mobs) end
        if statsRef.hp then statsRef.hp.Text = formatNumber(totalHP) end
        if statsRef.nearest then statsRef.nearest.Text = (nearestDist~=math.huge) and (nearestDist.."m") or "—" end
        local renderCount = math.min(#mobs, 60)
        local visible = {}
        for i = 1, renderCount do if mobs[i].model then visible[mobs[i].model] = i end end
        for model, cached in pairs(trackerRowMap) do
            if model ~= "__empty" and not visible[model] then
                cached.row:Destroy()
                trackerRowMap[model] = nil
            end
        end
        if renderCount == 0 then
            if not trackerRowMap.__empty then
                local lbl = new("TextLabel", {
                    Size=UDim2.new(1,0,0,44), BackgroundTransparency=1,
                    TextColor3=C.textMuted, Font=DS.F.subtle, TextSize=12,
                    TextXAlignment=Enum.TextXAlignment.Center,
                    LayoutOrder=1, Parent=trackerList })
                lbl:SetAttribute("_langKey", "lbl_no_mobs")
                lbl.Text = T("lbl_no_mobs")
                table.insert(textRegistry, lbl)
                trackerRowMap.__empty = {row=lbl}
            end
            return
        end
        if trackerRowMap.__empty then trackerRowMap.__empty.row:Destroy() trackerRowMap.__empty = nil end
        for i = 1, renderCount do
            local m = mobs[i]
            local cached = trackerRowMap[m.model]
            if not cached then
                local rowBg = m.isBoss and Color3.fromRGB(45,35,20) or C.bgAlt
                local row = new("TextButton", {
                    Size=UDim2.new(1,-8,0,54), BackgroundColor3=rowBg, Text="",
                    BorderSizePixel=0, AutoButtonColor=false, LayoutOrder=i, Parent=trackerList })
                corner(row, DS.R.card)
                if m.isBoss then stroke(row, C.gold, 1.5, 0) end
                local numBox = new("TextLabel", {
                    Size=UDim2.new(0,28,0,28), Position=UDim2.new(0,10,0.5,-14),
                    BackgroundColor3=m.isBoss and C.gold or C.card,
                    BackgroundTransparency=m.isBoss and 0 or 0.3,
                    Text=m.isBoss and "💀" or tostring(i),
                    TextColor3=m.isBoss and C.bg or C.textMuted,
                    Font=DS.F.bold, TextSize=m.isBoss and 15 or 11,
                    BorderSizePixel=0, Parent=row })
                corner(numBox, DS.R.round)
                local nameLbl = new("TextLabel", {
                    Size=UDim2.new(1,-190,0,18), Position=UDim2.new(0,48,0,9),
                    BackgroundTransparency=1, Text=m.name, TextColor3=m.isBoss and C.gold or C.text,
                    Font=DS.F.bold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=row })
                local hpLbl = new("TextLabel", {
                    Size=UDim2.new(1,-190,0,14), Position=UDim2.new(0,48,0,29),
                    BackgroundTransparency=1, Text="HP", TextColor3=C.textDim,
                    Font=DS.F.subtle, TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, Parent=row })
                local distLbl = new("TextLabel", {
                    Size=UDim2.new(0,70,0,18), Position=UDim2.new(1,-152,0,9),
                    BackgroundTransparency=1, Text=m.dist.."m", TextColor3=C.accent2,
                    Font=DS.F.bold, TextSize=12, TextXAlignment=Enum.TextXAlignment.Right, Parent=row })
                local tpBtn = new("TextButton", {
                    Size=UDim2.new(0,68,0,36), Position=UDim2.new(1,-78,0.5,-18),
                    BackgroundColor3=m.isBoss and C.gold or C.accent, Text="TP →",
                    TextColor3=m.isBoss and C.bg or C.text,
                    Font=DS.F.bold, TextSize=11, BorderSizePixel=0, AutoButtonColor=false, Parent=row })
                corner(tpBtn, DS.R.chip)
                cached = {row=row, rowBg=rowBg, nameLbl=nameLbl, hpLbl=hpLbl, distLbl=distLbl, tpBtn=tpBtn, mob=m, isBoss=m.isBoss}
                trackerRowMap[m.model] = cached
                tpBtn.MouseButton1Click:Connect(function()
                    local cur = trackerRowMap[m.model]
                    if cur and cur.mob and cur.mob.hrp then
                        teleportTo(cur.mob.hrp.Position + Vector3.new(0,3,2))
                        showToast(string.format(T("toast_to_mob"), cur.mob.name), cur.isBoss and C.gold or C.accent, cur.isBoss and "💀" or "→")
                    end
                end)
                row.MouseEnter:Connect(function()
                    local cur = trackerRowMap[m.model]
                    local bg = (cur and cur.isBoss) and Color3.fromRGB(58,45,28) or C.hover
                    TweenService:Create(row, TweenInfo.new(DS.A.fast), { BackgroundColor3=bg }):Play()
                end)
                row.MouseLeave:Connect(function()
                    local cur = trackerRowMap[m.model]
                    local bg = (cur and cur.rowBg) or C.bgAlt
                    TweenService:Create(row, TweenInfo.new(DS.A.fast), { BackgroundColor3=bg }):Play()
                end)
            end
            cached.mob = m
            if cached.row.LayoutOrder ~= i then cached.row.LayoutOrder = i end
            if cached.nameLbl.Text ~= m.name then cached.nameLbl.Text = m.name end
            if cached.distLbl.Text ~= m.dist.."m" then cached.distLbl.Text = m.dist.."m" end
            local hpText
            if m.hp then hpText = formatNumber(m.hp).." / "..formatNumber(m.maxHp or m.hp).." HP"
            elseif m.hpText and m.maxHpText then hpText = m.hpText.." / "..m.maxHpText.." HP"
            else hpText = "HP: ?" end
            if cached.hpLbl.Text ~= hpText then cached.hpLbl.Text = hpText end
        end
    end
end

makeSection(pageUtility, "sec_clicker", "🖱")
do
    local clickerRunning = false
    local function startClicker()
        if clickerRunning then return end
        clickerRunning = true
        showToast(T("toast_clicker_on"), C.gold, "🖱")
        task.spawn(function()
            task.wait(1)
            if not clickerRunning then return end
            while clickerRunning and Config.AutoClicker and not isShuttingDown do
                pcall(clickLeftMouse)
                task.wait(1 / math.max(1, Config.AutoClickerCPS))
            end
            clickerRunning = false
        end)
    end
    local function stopClicker()
        if not clickerRunning then return end
        clickerRunning = false
        Config.AutoClicker = false
        showToast(T("toast_clicker_off"), C.warn, "🖱")
    end
    createToggle(pageUtility, "tog_clicker", false, function(s)
        Config.AutoClicker = s
        if s then startClicker() else stopClicker() end
    end, "AutoClicker", "desc_clicker")
    createSlider(pageUtility, "lbl_cps", 1, 50, 10, C.gold, function(v) Config.AutoClickerCPS = v end, "AutoClickerCPS")
end

makeSection(pageUtility, "sec_friends", "👥")
createToggle(pageUtility, "tog_friend_notify", true, function(s)
    Config.NotifyFriends = s
    showToast(s and T("toast_friend_notify_on") or T("toast_friend_notify_off"),
        s and C.success or C.warn, "👥")
end, "NotifyFriends", "desc_friend_notify")

local applyThemeFull
local function collectConfigData()
    local data = {
        Config = {HitboxSize=Config.HitboxSize,
            KillAuraRange=Config.KillAuraRange, KillAuraDelay=Config.KillAuraDelay,
            ESPColor={R=Config.ESPColor.R, G=Config.ESPColor.G, B=Config.ESPColor.B},
            ZoomValue=Config.ZoomValue, AutoFarmDelay=Config.AutoFarmDelay,
            AutoClickerCPS=Config.AutoClickerCPS,
            SpeedValue=Config.SpeedValue, FlySpeed=Config.FlySpeed,
            RadarRange=Config.RadarRange,
            ToggleKey=Config.ToggleKey and Config.ToggleKey.Name or "Delete"},
        Toggles={}, Theme=currentTheme.name,
        SavedPositions={}, Favorites=favoritedPoints, Friends=savedFriends,
    }
    for id, d in pairs(allToggles) do data.Toggles[id] = d.getState() end
    for name, pos in pairs(savedPositions) do data.SavedPositions[name] = {X=pos.X, Y=pos.Y, Z=pos.Z} end
    return data
end
local function sanitizeConfigData(data)
    if type(data) ~= "table" then return nil end
    if type(data.Toggles) ~= "table" then data.Toggles = {} end
    for id, state in pairs(data.Toggles) do
        if type(state) ~= "boolean" then
            data.Toggles[id] = (state == true or state == 1 or state == "true" or state == "1")
        end
    end
    if type(data.Config) ~= "table" then data.Config = {} end
    local numericFields = {
        HitboxSize = {1, 600}, ZoomValue = {50, 2000},
        AutoFarmDelay = {0.1, 3.0}, AutoClickerCPS = {1, 50},
        SpeedValue = {16, 500}, FlySpeed = {10, 500}, RadarRange = {100, 1000},
        KillAuraRange = {50, 1000}, KillAuraDelay = {0.01, 0.2},
    }
    for field, range in pairs(numericFields) do
        local v = data.Config[field]
        if type(v) == "number" and v >= range[1] and v <= range[2] then
        elseif type(v) == "number" then data.Config[field] = math.clamp(v, range[1], range[2])
        else data.Config[field] = nil end
    end
    if type(data.Config.ESPColor) ~= "table" then data.Config.ESPColor = nil end
    if type(data.Theme) ~= "string" then data.Theme = "Purple" end
    if type(data.SavedPositions) ~= "table" then data.SavedPositions = {} end
    for name, pos in pairs(data.SavedPositions) do
        if type(pos) ~= "table" or type(pos.X) ~= "number" or type(pos.Y) ~= "number" or type(pos.Z) ~= "number" then
            data.SavedPositions[name] = nil
        end
    end
    if type(data.Friends) ~= "table" then data.Friends = {} end
    if type(data.Favorites) ~= "table" then data.Favorites = {} end
    return data
end
local function applyConfigData(data)
    data = sanitizeConfigData(data)
    if not data then return false end
    enterSilent()
    if data.Toggles then
        for id, state in pairs(data.Toggles) do
            if allToggles[id] then pcall(function() allToggles[id].setState(state, true) end) end
        end
    end
    if data.Config then
        if data.Config.HitboxSize and allSliders["HitboxSize"] then pcall(function() allSliders["HitboxSize"].setValue(data.Config.HitboxSize) end) end
        if data.Config.ZoomValue and allSliders["ZoomValue"] then pcall(function() allSliders["ZoomValue"].setValue(data.Config.ZoomValue) end) end
        if data.Config.AutoClickerCPS and allSliders["AutoClickerCPS"] then pcall(function() allSliders["AutoClickerCPS"].setValue(data.Config.AutoClickerCPS) end) end
        if data.Config.AutoFarmDelay and allSliders["AutoFarmDelay"] then
            pcall(function() allSliders["AutoFarmDelay"].setValue(math.clamp(math.floor(data.Config.AutoFarmDelay*10+0.5), 1, 30)) end)
        end
        if data.Config.SpeedValue and allSliders["SpeedValue"] then pcall(function() allSliders["SpeedValue"].setValue(data.Config.SpeedValue) end) end
        if data.Config.FlySpeed and allSliders["FlySpeed"] then pcall(function() allSliders["FlySpeed"].setValue(data.Config.FlySpeed) end) end
        if data.Config.RadarRange and allSliders["RadarRange"] then pcall(function() allSliders["RadarRange"].setValue(data.Config.RadarRange) end) end
        if data.Config.KillAuraRange and allSliders["KillAuraRange"] then pcall(function() allSliders["KillAuraRange"].setValue(data.Config.KillAuraRange) end) end
        if data.Config.KillAuraDelay and allSliders["KillAuraDelay"] then pcall(function() allSliders["KillAuraDelay"].setValue(math.floor(data.Config.KillAuraDelay*100+0.5)) end) end
        if data.Config.ESPColor then
            local ec = data.Config.ESPColor
            if type(setESPColor) == "function" then
                pcall(setESPColor, Color3.new(ec.R or 1, ec.G or 0.235, ec.B or 0.235))
            end
        end
        if data.Config.ToggleKey then
            local kc = Enum.KeyCode[data.Config.ToggleKey]
            if kc then Config.ToggleKey = kc if keybindBtn then keybindBtn.Text = kc.Name end end
        end
    end
    if data.Theme and applyThemeFull then applyThemeFull(data.Theme) end
    if data.SavedPositions then
        savedPositions = {}
        for name, pos in pairs(data.SavedPositions) do savedPositions[name] = Vector3.new(pos.X,pos.Y,pos.Z) end
    end
    if data.Favorites then favoritedPoints = data.Favorites end
    if data.Friends then savedFriends = data.Friends end
    rebuildSavedList()
    exitSilentDelayed(0.8)
    return true
end
local function getAllConfigs()
    local list = {}
    if not LIST_AVAILABLE then return list end
    local now = tick()
    for f, t in pairs(recentlyDeleted) do if now - t > RECENT_DELETE_TTL then recentlyDeleted[f] = nil end end
    local autoloadFile = CONFIG_PREFIX .. "_autoload.json"
    local ok, files = pcall(listfiles, "")
    if not ok or type(files) ~= "table" then ok, files = pcall(listfiles) end
    if ok and type(files) == "table" then
        for _, f in ipairs(files) do
            if type(f) == "string" and string.find(f, CONFIG_PREFIX, 1, true)
            and f ~= autoloadFile and not recentlyDeleted[f] then
                local name = string.match(f, CONFIG_PREFIX.."(.-)%.json$")
                if name then table.insert(list, {file=f, name=name}) end
            end
        end
    end
    table.sort(list, function(a, b) return string.lower(tostring(a.name)) < string.lower(tostring(b.name)) end)
    return list
end
local function refreshAllOpenConfigLists()
    for _, fn in ipairs(openConfigLists) do pcall(fn) end
end

makeSection(pageSettings, "sec_perf", "⚡")
do
    local fpsBoosterData = nil
    local function isParticle(v) return v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") end
    local function killParticle(v)
        if not fpsBoosterData then return end
        if isParticle(v) and v.Enabled then
            fpsBoosterData.disabled[v] = true
            pcall(function() v.Enabled = false end)
        end
    end
    local function toggleFPSBooster(state)
        Config.FPSBooster = state
        if state then
            if not fpsBoosterData then
                fpsBoosterData = {GlobalShadows=Lighting.GlobalShadows, Effects={}, disabled={}, descendantConn=nil}
                for _, v in ipairs(Lighting:GetChildren()) do
                    if v:IsA("PostEffect") then fpsBoosterData.Effects[v] = {Enabled=v.Enabled}
                    elseif v:IsA("Atmosphere") then fpsBoosterData.Effects[v] = {Density=v.Density, Haze=v.Haze, Glare=v.Glare} end
                end
            end
            Lighting.GlobalShadows = false
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("PostEffect") then pcall(function() v.Enabled = false end)
                elseif v:IsA("Atmosphere") then pcall(function() v.Density=0 v.Haze=0 v.Glare=0 end) end
            end
            task.spawn(function()
                local data = fpsBoosterData
                for _, v in ipairs(workspace:GetDescendants()) do
                    if data ~= fpsBoosterData or not Config.FPSBooster then return end
                    killParticle(v)
                end
            end)
            fpsBoosterData.descendantConn = workspace.DescendantAdded:Connect(function(v)
                if Config.FPSBooster then killParticle(v) end
            end)
            showToast(T("toast_fps_on"), C.success, "⚡")
        else
            if fpsBoosterData then
                if fpsBoosterData.descendantConn then
                    pcall(function() fpsBoosterData.descendantConn:Disconnect() end)
                    fpsBoosterData.descendantConn = nil
                end
                pcall(function() Lighting.GlobalShadows = fpsBoosterData.GlobalShadows end)
                for v, orig in pairs(fpsBoosterData.Effects) do
                    if v and v.Parent then
                        pcall(function() for k, val in pairs(orig) do v[k] = val end end)
                    end
                end
                for v in pairs(fpsBoosterData.disabled) do
                    if v and v.Parent then pcall(function() v.Enabled = true end) end
                end
                fpsBoosterData = nil
            end
            showToast(T("toast_fps_off"), C.warn, "⚡")
        end
    end
    createToggle(pageSettings, "tog_fps", false, toggleFPSBooster, "FPSBooster", "desc_fps")
end

do
    local antiAFKConn = nil
    local function antiAFKAction()
        local ok = pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
        if not ok then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    pcall(function()
                        hum:Move(Vector3.new(0,0,1), true) task.wait(0.1)
                        hum:Move(Vector3.new(0,0,-1), true) task.wait(0.1)
                        hum:Move(Vector3.new(0,0,0), false)
                    end)
                end
            end
            if keypress and keyrelease then pcall(function() keypress(0x20) task.wait(0.05) keyrelease(0x20) end) end
        end
    end
    local function toggleAntiAFK(state)
        Config.AntiAFK = state
        if state then            if antiAFKConn then pcall(function() antiAFKConn:Disconnect() end) end
            antiAFKConn = track(LocalPlayer.Idled:Connect(function() antiAFKAction() end))
            showToast(T("toast_antiafk_on"), C.success, "🛡")
        else
            if antiAFKConn then pcall(function() antiAFKConn:Disconnect() end) antiAFKConn = nil end
            showToast(T("toast_antiafk_off"), C.warn, "🛡")
        end
    end
    createToggle(pageSettings, "tog_antiafk", false, toggleAntiAFK, "AntiAFK", "desc_antiafk")
end

makeSection(pageSettings, "sec_configs", "💾")
createButton(pageSettings, "btn_save_config", C.success, function()
    if not FS_AVAILABLE then showToast(T("toast_fs_unavail"), C.danger, "⚠") return end
    showInputDialog(T("dlg_save_cfg"), T("dlg_cfg_name"), T("dlg_cfg_name_ph"), function(name)
        name = string.gsub(name, '[\\/:*?"<>|]', "_")
        name = string.gsub(name, "%.%.", "_")
        name = name:gsub("^%s+", ""):gsub("%s+$", "")
        if name == "" then name = "config" end
        local ok = pcall(function()
            local data = collectConfigData()
            data.Name = name
            writefile(CONFIG_PREFIX..name..".json", HttpService:JSONEncode(data))
        end)
        if ok then
            showToast(string.format(T("toast_cfg_saved"), name), C.success, "✓")
            refreshAllOpenConfigLists()
        else
            showToast(T("toast_cfg_save_err"), C.danger, "⚠")
        end
    end)
end, "💾")

createButton(pageSettings, "btn_load_config", C.accent, function()
    if not FS_AVAILABLE or not LIST_AVAILABLE then showToast(T("toast_fs_unavail"), C.danger, "⚠") return end
    local overlay = new("Frame", { Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.new(0,0,0),
        BackgroundTransparency=0.6, BorderSizePixel=0, ZIndex=1, Parent=dialogGui })
    local win = new("Frame", { Size=UDim2.new(0,420,0,480), Position=UDim2.new(0.5,-210,0.5,-240),
        BackgroundColor3=C.bg, BorderSizePixel=0, ZIndex=2, Parent=dialogGui })
    corner(win, DS.R.window)
    stroke(win, C.accent, 1.2, 0.4)
    gradient(win, C.bg, C.bgAlt, 135)
    new("TextLabel", {Size=UDim2.new(1,-70,0,26), Position=UDim2.new(0,22,0,18),
        BackgroundTransparency=1, Text=T("dlg_load_cfg"),
        TextColor3=C.text, Font=DS.F.title, TextSize=15,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3, Parent=win})
    local listFrame = new("ScrollingFrame", {Size=UDim2.new(1,-32,1,-98), Position=UDim2.new(0,16,0,72),
        BackgroundTransparency=1, BorderSizePixel=0, ScrollBarThickness=5,
        ScrollBarImageColor3=C.accent, ScrollBarImageTransparency=0.4,
        CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ZIndex=3, Parent=win})
    new("UIListLayout", {Padding=UDim.new(0,8), Parent=listFrame})
    local function rebuildConfigsUI()
        if not listFrame or not listFrame.Parent then return end
        listFrame.CanvasSize = UDim2.new(0,0,0,0)
        for _, ch in ipairs(listFrame:GetChildren()) do if not ch:IsA("UIListLayout") then ch:Destroy() end end
        local configs = getAllConfigs()
        if #configs == 0 then
            new("TextLabel", {Size=UDim2.new(1,0,0,40), BackgroundTransparency=1,
                Text=T("dlg_no_configs"), TextColor3=C.textMuted,
                Font=DS.F.subtle, TextSize=12,
                TextXAlignment=Enum.TextXAlignment.Center, ZIndex=4, Parent=listFrame})
            return
        end
        for i, cfg in ipairs(configs) do
            local row = new("Frame", {Size=UDim2.new(1,-8,0,52), BackgroundColor3=C.card,
                BackgroundTransparency=0.05, BorderSizePixel=0, LayoutOrder=i, ZIndex=4, Parent=listFrame})
            corner(row, DS.R.card)
            stroke(row, C.border, 1, 0.5)
            new("TextLabel", {Size=UDim2.new(1,-110,1,0), Position=UDim2.new(0,16,0,0),
                BackgroundTransparency=1, Text="📄  "..cfg.name, TextColor3=C.text,
                Font=DS.F.body, TextSize=12,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=5, Parent=row})
            local loadBtn = new("TextButton", {Size=UDim2.new(0,38,0,32), Position=UDim2.new(1,-84,0.5,-16),
                BackgroundColor3=C.success, Text="📂", TextColor3=Color3.fromRGB(255,255,255),
                Font=DS.F.bold, TextSize=14, BorderSizePixel=0,
                AutoButtonColor=false, ZIndex=5, Parent=row})
            corner(loadBtn, DS.R.chip)
            local delBtn = createDeleteButton(row, 32, function()
                local ok = pcall(function() delfile(cfg.file) end)
                local reallyDeleted = true
                if ok and isfile then reallyDeleted = not isfile(cfg.file) end
                if ok and reallyDeleted then
                    recentlyDeleted[cfg.file] = tick()
                    showToast(string.format(T("toast_cfg_deleted"), cfg.name), C.danger, "🗑")
                    refreshAllOpenConfigLists()
                    task.delay(0.5, refreshAllOpenConfigLists)
                elseif ok then
                    showToast(T("toast_cfg_busy"), C.warn, "⚠")
                else
                    showToast(T("toast_cfg_del_fail"), C.warn, "⚠")
                end
            end)
            delBtn.Position = UDim2.new(1,-44,0.5,-16) delBtn.ZIndex = 5
            loadBtn.MouseButton1Click:Connect(function()
                local ok = pcall(function() applyConfigData(HttpService:JSONDecode(readfile(cfg.file))) end)
                if ok then
                    for idx, fn in ipairs(openConfigLists) do
                        if fn == rebuildConfigsUI then table.remove(openConfigLists, idx) break end
                    end
                    overlay:Destroy() win:Destroy()
                    task.delay(0.5, function() showToast(string.format(T("toast_cfg_loaded"), cfg.name), C.success, "📂") end)
                end
            end)
        end
    end
    local function closeAll()
        for idx, fn in ipairs(openConfigLists) do
            if fn == rebuildConfigsUI then table.remove(openConfigLists, idx) break end
        end
        overlay:Destroy() win:Destroy()
    end
    table.insert(openConfigLists, rebuildConfigsUI)
    local closeWin = createCloseButton(win, 30, closeAll)
    closeWin.Position = UDim2.new(1,-44,0,18) closeWin.ZIndex = 3
    rebuildConfigsUI()
    overlay.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            local pos = inp.Position
            local ap, asz = win.AbsolutePosition, win.AbsoluteSize
            if pos.X < ap.X or pos.X > ap.X + asz.X or pos.Y < ap.Y or pos.Y > ap.Y + asz.Y then
                closeAll()
            end
        end
    end)
end, "📂")

createButton(pageSettings, "btn_reset_all", C.warn, function()
    enterSilent()
    for _, d in pairs(allToggles) do pcall(function() d.setState(false, true) end) end
    if allSliders["HitboxSize"] then allSliders["HitboxSize"].setValue(15) end
    if allSliders["ZoomValue"] then allSliders["ZoomValue"].setValue(500) end
    if allSliders["SpeedValue"] then allSliders["SpeedValue"].setValue(100) end
    if allSliders["FlySpeed"] then allSliders["FlySpeed"].setValue(60) end
    if allSliders["RadarRange"] then allSliders["RadarRange"].setValue(300) end
    if allSliders["KillAuraRange"] then allSliders["KillAuraRange"].setValue(300) end
    if allSliders["KillAuraDelay"] then allSliders["KillAuraDelay"].setValue(15) end
    savedPositions = {} favoritedPoints = {}
    rebuildSavedList()
    Config.ToggleKey = Enum.KeyCode.Delete
    if keybindBtn then keybindBtn.Text = "Delete" end
    if applyThemeFull then applyThemeFull("Purple") end
    exitSilentDelayed(0.8)
    task.delay(1.0, function() showToast(T("toast_reset_settings"), C.warn, "🔄") end)
end, "🆕")

makeSection(pageSettings, "sec_theme", "🎨")
do
    local themesList = new("Frame", { Size=UDim2.new(1,-8,0,0), BackgroundTransparency=1,
        AutomaticSize=Enum.AutomaticSize.Y, Parent=pageSettings })
    new("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,8),
        SortOrder=Enum.SortOrder.LayoutOrder, Wraps=true, Parent=themesList })
    applyThemeFull = function(themeName)
        local newTheme = nil
        for _, t in ipairs(THEMES) do if t.name == themeName then newTheme = t break end end
        if not newTheme then return end
        local prevGlass = currentTheme.forceLightText == true
        local nowGlass = newTheme.forceLightText == true
        C.bg, C.bgAlt, C.card, C.hover = newTheme.bg, newTheme.bgAlt, newTheme.card, newTheme.hover
        C.accent, C.accent2 = newTheme.accent, newTheme.accent2
        currentTheme = newTheme
        for _, gui in ipairs({screenGui, toastGui, dialogGui, statusGui, radarGui}) do
            if gui then
                for _, desc in ipairs(gui:GetDescendants()) do
                    pcall(function()
                        if not desc:IsA("GuiObject") then return end
                        local bgRole = desc:GetAttribute("_bgRole")
                        if bgRole and newTheme[bgRole] then
                            desc.BackgroundColor3 = newTheme[bgRole]
                            desc:SetAttribute("_baseColor", newTheme[bgRole])
                            local field = TRANSP_FIELD[bgRole]
                            if field then
                                local baseTransp = desc:GetAttribute("_baseTransp") or 0
                                if baseTransp == 0 then desc.BackgroundTransparency = newTheme[field] or 0 end
                            end
                        end
                        if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
                            if nowGlass then applyGlassTextTo(desc)
                            else
                                if prevGlass then
                                    desc.TextStrokeTransparency = 1
                                    if desc:IsA("TextBox") then desc.PlaceholderColor3 = C.textMuted end
                                end
                                local role = desc:GetAttribute("_textRole")
                                if role and TEXT_ROLES[role] then desc.TextColor3 = TEXT_ROLES[role]
                                else
                                    local customColor = desc:GetAttribute("_customTextColor")
                                    if customColor then desc.TextColor3 = customColor end
                                end
                            end
                        end
                        local st = desc:FindFirstChildOfClass("UIStroke")
                        if st then
                            local sRole = st:GetAttribute("_strokeRole")
                            if sRole and newTheme[sRole] then st.Color = newTheme[sRole] end
                        end
                        local gr = desc:FindFirstChildOfClass("UIGradient")
                        if gr then
                            local r1, r2 = gr:GetAttribute("_gRole1"), gr:GetAttribute("_gRole2")
                            if r1 and r2 and newTheme[r1] and newTheme[r2] then
                                gr.Color = ColorSequence.new(newTheme[r1], newTheme[r2])
                            end
                        end
                    end)
                end
            end
        end
    end
    for _, t in ipairs(THEMES) do
        local btn = new("TextButton", { Size=UDim2.new(0,78,0,38), BackgroundColor3=t.accent, Text=t.name,
            TextColor3=Color3.fromRGB(255,255,255), Font=DS.F.bold, TextSize=11,
            BorderSizePixel=0, AutoButtonColor=false, Parent=themesList })
        btn:SetAttribute("_bgRole", nil) btn:SetAttribute("_textRole", nil)
        btn:SetAttribute("_baseColor", nil) btn:SetAttribute("_baseTransp", nil)
        corner(btn, DS.R.chip)
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(DS.A.fast), { Size=UDim2.new(0,82,0,40) }):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(DS.A.fast), { Size=UDim2.new(0,78,0,38) }):Play() end)
        btn.MouseButton1Click:Connect(function()
            applyThemeFull(t.name)
            showToast(string.format(T("toast_theme"), t.name), t.accent, "🎨")
        end)
    end
end

makeSection(pageSettings, "sec_controls", "⌨")
do
    local keybindCard = new("Frame", { Size=UDim2.new(1,-8,0,58), BackgroundColor3=C.card, BackgroundTransparency=0.05,
        BorderSizePixel=0, Parent=pageSettings })
    corner(keybindCard, DS.R.card)
    stroke(keybindCard, C.border, 1, 0.5)
    regLang(new("TextLabel", { Size=UDim2.new(1,-150,0,18), Position=UDim2.new(0,16,0,10),
        BackgroundTransparency=1, TextColor3=C.text, Font=DS.F.body, TextSize=13,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=keybindCard }), "lbl_hide")
    regLang(new("TextLabel", { Size=UDim2.new(1,-150,0,14), Position=UDim2.new(0,16,0,32),
        BackgroundTransparency=1, TextColor3=C.textMuted,
        Font=DS.F.subtle, TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=keybindCard }), "lbl_hide_desc")
    keybindBtn = new("TextButton", { Size=UDim2.new(0,120,0,36), Position=UDim2.new(1,-136,0.5,-18),
        BackgroundColor3=C.accent, Text=Config.ToggleKey.Name, TextColor3=Color3.fromRGB(255,255,255),
        Font=DS.F.bold, TextSize=12, BorderSizePixel=0, AutoButtonColor=false, Parent=keybindCard })
    corner(keybindBtn, DS.R.chip)
    keybindBtn.MouseEnter:Connect(function()
        if not capturingKey then
            local cur = keybindBtn.BackgroundColor3
            TweenService:Create(keybindBtn, TweenInfo.new(DS.A.fast), {
                BackgroundColor3=Color3.new(math.min(1,cur.R+0.08),math.min(1,cur.G+0.08),math.min(1,cur.B+0.08)) }):Play()
        end
    end)
    keybindBtn.MouseLeave:Connect(function()
        if not capturingKey then
            local restore = keybindBtn:GetAttribute("_baseColor") or C.accent
            TweenService:Create(keybindBtn, TweenInfo.new(DS.A.fast), { BackgroundColor3=restore }):Play()
        end
    end)
    keybindBtn.MouseButton1Click:Connect(function()
        if capturingKey then return end
        capturingKey = true
        keybindBtn.Text = "…"
        keybindBtn.BackgroundColor3 = C.warn
    end)
end

makeSection(pageSettings, "sec_friends_notif", "👥")
local friendsList
local rebuildFriendsList
do
    friendsList = new("Frame", { Size=UDim2.new(1,-8,0,0), BackgroundTransparency=1,
        AutomaticSize=Enum.AutomaticSize.Y, Parent=pageSettings })
    new("UIListLayout", { Padding=UDim.new(0,6), Parent=friendsList })
    rebuildFriendsList = function()
        for _, ch in ipairs(friendsList:GetChildren()) do
            if not ch:IsA("UIListLayout") then ch:Destroy() end
        end
        local i = 0
        for name, _ in pairs(savedFriends) do
            i = i + 1
            local row = new("Frame", {Size=UDim2.new(1,0,0,40), BackgroundColor3=C.bgAlt,
                BackgroundTransparency=0.2, BorderSizePixel=0, LayoutOrder=i, Parent=friendsList})
            corner(row, DS.R.card)
            local av = new("Frame", { Size=UDim2.new(0,26,0,26), Position=UDim2.new(0,10,0.5,-13),
                BackgroundColor3=C.accent, BackgroundTransparency=0.8, BorderSizePixel=0, Parent=row })
            corner(av, DS.R.round)
            stroke(av, C.accent, 1, 0.4)
            new("TextLabel", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
                Text=string.upper(string.sub(name,1,1)), TextColor3=C.accent,
                Font=DS.F.bold, TextSize=12, Parent=av})
            new("TextLabel", {Size=UDim2.new(1,-90,1,0), Position=UDim2.new(0,46,0,0),
                BackgroundTransparency=1, Text=name, TextColor3=C.text,
                Font=DS.F.body, TextSize=12,
                TextXAlignment=Enum.TextXAlignment.Left, Parent=row})
            local delBtn = createDeleteButton(row, 28, function()
                savedFriends[name] = nil
                rebuildFriendsList()
                if FS_AVAILABLE then pcall(function() writefile(FRIENDS_FILE, HttpService:JSONEncode(savedFriends)) end) end
                showToast(string.format(T("toast_friend_removed"), name), C.warn, "👤")
            end)
            delBtn.Position = UDim2.new(1,-38,0.5,-14)
        end
    end
    createButton(pageSettings, "btn_add_friend", C.accent, function()
        showInputDialog(T("dlg_add_friend"), "", T("dlg_player_name"), function(name)
            savedFriends[name] = true
            rebuildFriendsList()
            if FS_AVAILABLE then pcall(function() writefile(FRIENDS_FILE, HttpService:JSONEncode(savedFriends)) end) end
            showToast(string.format(T("toast_friend_added"), name), C.accent, "👤")
        end)
    end, "➕")
end

makeSection(pageSettings, "sec_social", "💬")
do
    local DISCORD_URL = "https://discord.gg/K3ksDHaCdA"
    local function copyToClipboard(text)
        pcall(function()
            if setclipboard then setclipboard(text)
            elseif toclipboard then toclipboard(text)
            elseif syn and syn.set_clipboard then syn.set_clipboard(text) end
        end)
    end
    local function openInBrowser(url)
        local functions = {
            function() if launch then launch(url) end end,
            function() if openbrowser then openbrowser(url) end end,
            function() if openurl then openurl(url) end end,
            function() if syn and syn.openBrowser then syn.openBrowser(url) end end,
        }
        for _, fn in ipairs(functions) do
            local ok = pcall(fn)
            if ok then return true end
        end
        return false
    end
    local discordCard = new("TextButton", {
        Size=UDim2.new(1,-8,0,58),
        BackgroundColor3=Color3.fromRGB(88,101,242),
        BackgroundTransparency=0.05,
        BorderSizePixel=0, AutoButtonColor=false, Text="",
        Parent=pageSettings
    })
    corner(discordCard, DS.R.card)
    local dStroke = stroke(discordCard, Color3.fromRGB(88,101,242), 1, 0.4)
    discordCard:SetAttribute("_bgRole", nil)
    discordCard:SetAttribute("_baseColor", Color3.fromRGB(88,101,242))
    local dLogo = new("Frame", {
        Size=UDim2.new(0,38,0,38), Position=UDim2.new(0,14,0.5,-19),
        BackgroundColor3=Color3.fromRGB(255,255,255), BackgroundTransparency=0.85,
        BorderSizePixel=0, Parent=discordCard
    })
    corner(dLogo, DS.R.round)
    stroke(dLogo, Color3.fromRGB(255,255,255), 1, 0.3)
    new("TextLabel", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
        Text="💬", TextColor3=Color3.fromRGB(255,255,255),
        Font=DS.F.bold, TextSize=20, Parent=dLogo })
    new("TextLabel", { Size=UDim2.new(1,-150,0,20), Position=UDim2.new(0,64,0,10),
        BackgroundTransparency=1, Text="Discord",
        TextColor3=Color3.fromRGB(255,255,255),
        Font=DS.F.bold, TextSize=15,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=discordCard })
    regLang(new("TextLabel", { Size=UDim2.new(1,-150,0,14), Position=UDim2.new(0,64,0,32),
        BackgroundTransparency=1, TextColor3=Color3.fromRGB(225,230,255),
        Font=DS.F.subtle, TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=discordCard }), "discord_join")
    regLang(new("TextLabel", { Size=UDim2.new(0,90,1,0), Position=UDim2.new(1,-100,0,0),
        BackgroundTransparency=1, TextColor3=Color3.fromRGB(255,255,255),
        Font=DS.F.bold, TextSize=12,
        TextXAlignment=Enum.TextXAlignment.Right, Parent=discordCard }), "discord_open")
    discordCard.MouseEnter:Connect(function()
        TweenService:Create(discordCard, TweenInfo.new(DS.A.fast), { BackgroundTransparency=0 }):Play()
        TweenService:Create(dStroke, TweenInfo.new(DS.A.fast), { Transparency=0 }):Play()
    end)
    discordCard.MouseLeave:Connect(function()
        TweenService:Create(discordCard, TweenInfo.new(DS.A.fast), { BackgroundTransparency=0.05 }):Play()
        TweenService:Create(dStroke, TweenInfo.new(DS.A.fast), { Transparency=0.4 }):Play()
    end)
    discordCard.MouseButton1Click:Connect(function()
        copyToClipboard(DISCORD_URL)
        showToast(T("toast_link_copied"), C.success, "📋")
        task.wait(0.2)
        local opened = openInBrowser(DISCORD_URL)
        if not opened then showToast(T("toast_link_buffer"), C.warn, "⚠") end
    end)
end

makeSection(pageSettings, "sec_about", "👤")
do
    local aboutCard = new("Frame", {
        Size=UDim2.new(1,-8,0,58),
        BackgroundColor3=C.card, BackgroundTransparency=0.05,
        BorderSizePixel=0, Parent=pageSettings
    })
    corner(aboutCard, DS.R.card)
    stroke(aboutCard, C.border, 1, 0.5)
    local aLogo = new("Frame", {
        Size=UDim2.new(0,38,0,38), Position=UDim2.new(0,14,0.5,-19),
        BackgroundColor3=C.accent, BackgroundTransparency=0.82,
        BorderSizePixel=0, Parent=aboutCard
    })
    corner(aLogo, DS.R.round)
    stroke(aLogo, C.accent, 1, 0.4)
    new("TextLabel", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
        Text="⚡", TextColor3=C.accent,
        Font=DS.F.bold, TextSize=18, Parent=aLogo })
    regLang(new("TextLabel", { Size=UDim2.new(1,-80,0,20), Position=UDim2.new(0,64,0,10),
        BackgroundTransparency=1, TextColor3=C.text,
        Font=DS.F.bold, TextSize=14,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=aboutCard }), "about_text")
    new("TextLabel", { Size=UDim2.new(1,-80,0,14), Position=UDim2.new(0,64,0,32),
        BackgroundTransparency=1, Text="Skill Point Legends • Utility v29",
        TextColor3=C.textMuted,
        Font=DS.F.subtle, TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=aboutCard })
end

showInputDialog = function(title, default, placeholder, onSave)
    if isDialogOpen then return end
    isDialogOpen = true
    local overlay = new("Frame", { Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.new(0,0,0),
        BackgroundTransparency=0.6, BorderSizePixel=0, ZIndex=10, Parent=dialogGui })
    local dialog = new("Frame", { Size=UDim2.new(0,400,0,180), Position=UDim2.new(0.5,-200,0.5,-90),
        BackgroundColor3=C.bg, BorderSizePixel=0, ZIndex=11, Parent=dialogGui })
    corner(dialog, DS.R.window)
    stroke(dialog, C.accent, 1.2, 0.4)
    gradient(dialog, C.bg, C.bgAlt, 135)
    new("TextLabel", {Size=UDim2.new(1,-32,0,24), Position=UDim2.new(0,20,0,18),
        BackgroundTransparency=1, Text=title, TextColor3=C.text,
        Font=DS.F.title, TextSize=15,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=12, Parent=dialog})
    local inputBg = new("Frame", { Size=UDim2.new(1,-40,0,42), Position=UDim2.new(0,20,0,56),
        BackgroundColor3=C.card, BorderSizePixel=0, ZIndex=12, Parent=dialog })
    corner(inputBg, DS.R.chip)
    stroke(inputBg, C.border, 1, 0.5)
    local input = new("TextBox", { Size=UDim2.new(1,-24,1,0), Position=UDim2.new(0,12,0,0),
        BackgroundTransparency=1, Text=default or "",
        PlaceholderText=placeholder or T("dlg_enter"),
        PlaceholderColor3=C.textMuted, TextColor3=C.text,
        Font=DS.F.body, TextSize=13, ClearTextOnFocus=false, ZIndex=13, Parent=inputBg })
    local btnRow = new("Frame", { Size=UDim2.new(1,-40,0,40), Position=UDim2.new(0,20,1,-54),
        BackgroundTransparency=1, ZIndex=12, Parent=dialog })
    new("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal,
        Padding=UDim.new(0,10), SortOrder=Enum.SortOrder.LayoutOrder, Parent=btnRow })
    local cancelBtn = new("TextButton", { Size=UDim2.new(0.5,-5,1,0), BackgroundColor3=C.card, BackgroundTransparency=0.1,
        Text=T("dlg_cancel"), TextColor3=C.text, Font=DS.F.bold, TextSize=12,
        BorderSizePixel=0, AutoButtonColor=false, LayoutOrder=1, ZIndex=13, Parent=btnRow })
    corner(cancelBtn, DS.R.chip)
    stroke(cancelBtn, C.border, 1, 0.5)
    local saveBtn = new("TextButton", { Size=UDim2.new(0.5,-5,1,0), BackgroundColor3=C.accent,
        Text="OK", TextColor3=Color3.fromRGB(255,255,255), Font=DS.F.bold, TextSize=12,
        BorderSizePixel=0, AutoButtonColor=false, LayoutOrder=2, ZIndex=13, Parent=btnRow })
    corner(saveBtn, DS.R.chip)
    cancelBtn.MouseEnter:Connect(function() TweenService:Create(cancelBtn, TweenInfo.new(DS.A.fast), { BackgroundTransparency=0 }):Play() end)
    cancelBtn.MouseLeave:Connect(function() TweenService:Create(cancelBtn, TweenInfo.new(DS.A.fast), { BackgroundTransparency=0.1 }):Play() end)
    saveBtn.MouseEnter:Connect(function()
        local cur = saveBtn.BackgroundColor3
        TweenService:Create(saveBtn, TweenInfo.new(DS.A.fast), { BackgroundColor3=Color3.new(math.min(1,cur.R+0.08),math.min(1,cur.G+0.08),math.min(1,cur.B+0.08)) }):Play()
    end)
    saveBtn.MouseLeave:Connect(function()
        TweenService:Create(saveBtn, TweenInfo.new(DS.A.fast), { BackgroundColor3=C.accent }):Play()
    end)
    local fired = false
    local function close()
        isDialogOpen = false
        overlay:Destroy()
        dialog:Destroy()
    end
    cancelBtn.MouseButton1Click:Connect(close)
    overlay.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            local pos = inp.Position
            local ap, asz = dialog.AbsolutePosition, dialog.AbsoluteSize
            if pos.X < ap.X or pos.X > ap.X + asz.X or pos.Y < ap.Y or pos.Y > ap.Y + asz.Y then close() end
        end
    end)
    saveBtn.MouseButton1Click:Connect(function()
        if fired then return end
        fired = true
        local v = input.Text
        close()
        if v and v ~= "" then onSave(v) end
    end)
end

track(Players.PlayerAdded:Connect(function(plr)
    if not Config.NotifyFriends or isShuttingDown then return end
    if savedFriends[plr.Name] then
        chatNotify(string.format(T("chat_friend_joined"), plr.Name))
        showToast(string.format(T("toast_friend_joined"), plr.Name), C.success, "🟢")
    end
end))
track(Players.PlayerRemoving:Connect(function(plr)
    if not Config.NotifyFriends or isShuttingDown then return end
    if savedFriends[plr.Name] then
        chatNotify(string.format(T("chat_friend_left"), plr.Name))
        showToast(string.format(T("toast_friend_left"), plr.Name), C.danger, "🔴")
    end
end))

track(UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if isShuttingDown then return end
    if capturingKey then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            capturingKey = false
            Config.ToggleKey = input.KeyCode
            if keybindBtn then
                keybindBtn.Text = input.KeyCode.Name
                local restore = keybindBtn:GetAttribute("_baseColor") or C.accent
                keybindBtn.BackgroundColor3 = restore
            end
            showToast(string.format(T("toast_key_hide"), input.KeyCode.Name), C.accent, "⌨")
        end
        return
    end
    if gameProcessed then return end
    if input.KeyCode == Config.ToggleKey then
        local ns = not screenGui.Enabled
        screenGui.Enabled, toastGui.Enabled, dialogGui.Enabled = ns, ns, ns
        if not ns then
            showStatus(string.format(T("toast_hide_hint"), Config.ToggleKey.Name), Color3.fromRGB(255, 200, 80), 3)
        else
            hideStatus()
            task.defer(function() showToast(T("toast_script_shown"), C.accent, "⚡") end)
        end
        return
    end
    if input.KeyCode == Enum.KeyCode.F1 then
        invalidateMobCache()
        local mob = getNearestMob()
        if mob then
            local char = LocalPlayer.Character
            if char then
                pcall(function() char:PivotTo(CFrame.new(mob.hrp.Position + Vector3.new(0,3,2))) end)
                showToast(string.format(T("toast_tp_mob"), (mob.displayName or mob.model.Name)), C.accent, "⚔")
            end
        end
    elseif input.KeyCode == Enum.KeyCode.F2 then
        if toggleRegistry["ESPEnabled"] then toggleRegistry["ESPEnabled"].setState(not Config.ESPEnabled, true) end
    elseif input.KeyCode == Enum.KeyCode.F3 then
        if toggleRegistry["HitboxEnabled"] then toggleRegistry["HitboxEnabled"].setState(not Config.HitboxEnabled, true) end
    end
end))

shutdown = function()
    if isShuttingDown then return end
    isShuttingDown = true
    capturingKey = false
    isDialogOpen = false
    Config.AutoFarm, Config.AutoClicker, Config.KillAura = false, false, false
    for id in pairs(_hbTasks) do unscheduleHeartbeat(id) end
    for _, fn in ipairs(_shutdownHooks) do pcall(fn) end
    pcall(function()
        if toggleRegistry["InfiniteJump"] then toggleRegistry["InfiniteJump"].setState(false, true) end
        if toggleRegistry["HitboxEnabled"] then toggleRegistry["HitboxEnabled"].setState(false, true) end
        if toggleRegistry["KillAura"] then toggleRegistry["KillAura"].setState(false, true) end
        if toggleRegistry["ESPEnabled"] then toggleRegistry["ESPEnabled"].setState(false, true) end
        if toggleRegistry["ESPPlayers"] then toggleRegistry["ESPPlayers"].setState(false, true) end
        if toggleRegistry["MobTracker"] then toggleRegistry["MobTracker"].setState(false, true) end
        if toggleRegistry["AntiAFK"] then toggleRegistry["AntiAFK"].setState(false, true) end
        if toggleRegistry["Fullbright"] then toggleRegistry["Fullbright"].setState(false, true) end
        if toggleRegistry["NoFog"] then toggleRegistry["NoFog"].setState(false, true) end
        if toggleRegistry["ZoomEnabled"] then toggleRegistry["ZoomEnabled"].setState(false, true) end
        if toggleRegistry["SpeedHack"] then toggleRegistry["SpeedHack"].setState(false, true) end
        if toggleRegistry["Fly"] then toggleRegistry["Fly"].setState(false, true) end
        if toggleRegistry["Noclip"] then toggleRegistry["Noclip"].setState(false, true) end
        if toggleRegistry["Radar"] then toggleRegistry["Radar"].setState(false, true) end
        if toggleRegistry["FPSBooster"] then toggleRegistry["FPSBooster"].setState(false, true) end
    end)
    pcall(destroyFly)
    pcall(function() if radarGui then radarGui:Destroy() end end)
    if originalLighting then
        pcall(function()
            Lighting.Brightness=originalLighting.Brightness Lighting.Ambient=originalLighting.Ambient
            Lighting.OutdoorAmbient=originalLighting.OutdoorAmbient Lighting.ClockTime=originalLighting.ClockTime
            Lighting.GlobalShadows=originalLighting.GlobalShadows
        end)
    end
    pcall(function()
        LocalPlayer.CameraMaxZoomDistance = originalZoom or 128
        LocalPlayer.CameraMinZoomDistance = 0.5
    end)
    disconnectAll()
    for _, gui in ipairs({screenGui, toastGui, dialogGui, statusGui}) do
        pcall(function() if gui then gui:Destroy() end end)
    end
    showStatus(T("toast_script_off"), Color3.fromRGB(255, 90, 100), 3.5)
end

task.delay(2, function()
    if isShuttingDown then return end
    local autoloadFile = CONFIG_PREFIX.."_autoload.json"
    local loaded = false
    if FS_AVAILABLE and isfile(autoloadFile) then
        local ok, err = pcall(function()
            applyConfigData(HttpService:JSONDecode(readfile(autoloadFile)))
            loaded = true
        end)
        if not ok or not loaded then pcall(function() delfile(autoloadFile) end) end
    end
    if not loaded and FS_AVAILABLE and LIST_AVAILABLE then
        pcall(function()
            local configs = getAllConfigs()
            if #configs > 0 then
                local last = configs[#configs]
                applyConfigData(HttpService:JSONDecode(readfile(last.file)))
            end
        end)
    end
    if FS_AVAILABLE and isfile(FRIENDS_FILE) then
        pcall(function()
            savedFriends = HttpService:JSONDecode(readfile(FRIENDS_FILE)) or {}
            rebuildFriendsList()
        end)
    end
end)

rebuildSavedList()
rebuildFriendsList()

track(Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
    if isShuttingDown then return end
    task.wait(0.8)
    if isShuttingDown then return end
    if Config.SpeedHack then
        pcall(function()
            local hum = newChar:WaitForChild("Humanoid", 5)
            if hum then hum.WalkSpeed = Config.SpeedValue end
        end)
    end
    if Config.Noclip then
        pcall(function()
            for _, part in ipairs(newChar:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    end
end))

do
    local fpsCounter, fpsValue, fpsLastTime = 0, 60, tick()
    scheduleHeartbeat(function()
        fpsCounter = fpsCounter + 1
        local now = tick()
        if now - fpsLastTime >= 1 then
            fpsValue = fpsCounter
            fpsCounter = 0
            fpsLastTime = now
        end
    end, 1/60, "fpsCounter")
    local pingItem = Stats.Network.ServerStatsItem and Stats.Network.ServerStatsItem["Data Ping"]
    task.spawn(function()
        while not isShuttingDown do
            pcall(function()
                if serverInfoLbl and serverInfoLbl.Parent then
                    local ping = 0
                    if pingItem then
                        local ok, v = pcall(function() return pingItem:GetValue() end)
                        if ok and v then ping = math.floor(v) end
                    end
                    local players = #Players:GetPlayers()
                    local maxPlayers = Players.MaxPlayers or 0
                    serverInfoLbl.Text = string.format("Ping %dms  ·  FPS %d  ·  %d/%d",
                        ping, fpsValue, players, maxPlayers)
                end
            end)
            task.wait(1)
        end
    end)
end

print("MvP Loaded for "..LocalPlayer.Name)
showToast(T("toast_script_loaded"), C.accent, "⚡")
