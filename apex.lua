-- [[ Apex Destroyer ]] --
-- Developer: Farel Destroyer

local Players              = game:GetService("Players")
local RunService           = game:GetService("RunService")
local UIS                  = game:GetService("UserInputService")
local MarketplaceService   = game:GetService("MarketplaceService")
local Lighting             = game:GetService("Lighting")
local TeleportService      = game:GetService("TeleportService")

local player = Players.LocalPlayer
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- Anti-Kick
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    if getnamecallmethod() == "Kick" then return end
    return old(self, ...)
end)

local Window = WindUI:CreateWindow({
    Title        = "Apex Destroyer",
    Author       = "t.me/nyxdestroy",
    Theme        = "Dark",
    Size         = UDim2.fromOffset(660, 430),
    Folder       = "apex_destroyer",
    SideBarWidth = 190,
    ScrollBarEnabled = true
})

Window:SetBackgroundImage("rbxassetid://76527064525832")
Window:SetBackgroundImageTransparency(0.85)

WindUI:Notify({
    Title   = "Apex Destroyer Loaded",
    Content = "Mobile & PC Support",
    Icon    = "check",
    Duration = 5
})

-- Rainbow Title
task.spawn(function()
    while task.wait(0.03) do
        Window:EditWindow({ TitleColor = Color3.fromHSV((tick() % 5) / 5, 1, 1) })
    end
end)

-- ============================================
-- TABS
-- ============================================
local HomeTab       = Window:Tab({ Title = "Home", Icon = "house" })
local PlayerMenuTab = Window:Tab({ Title = "Player Menu", Icon = "swords" })
local TeleportTab   = Window:Tab({ Title = "Teleport Menu", Icon = "map-pin" })

-- ============================================
-- HOME TAB
-- ============================================
local executor = identifyexecutor and identifyexecutor() or getexecutorname and getexecutorname() or "Unknown"

HomeTab:Section({ Title = "Tools Information" })

HomeTab:Paragraph({
    Title   = "Apex Destroyer",
    Content = "Premium Mobility Tools\nVersion : 1.2\nExecutor : " .. executor
})

-- Discord Button dengan Icon Discord
HomeTab:Button({
    Title = "Copy Discord",
    Icon  = "message-circle",   -- Icon Discord style
    Callback = function()
        local discordLink = "https://discord.gg/fareldestroyer."   -- GANTI DENGAN LINK DISCORD KAMU
        if setclipboard then
            setclipboard(discordLink)
            WindUI:Notify({
                Title = "Copied!",
                Content = "Discord link has been copied",
                Icon = "check",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "Discord Link",
                Content = discordLink,
                Duration = 6
            })
        end
    end
})

-- Rejoin Server
HomeTab:Button({
    Title = "Rejoin Server",
    Icon  = "refresh-cw",
    Callback = function()
        WindUI:Notify({
            Title = "Rejoining...",
            Content = "Teleporting back to the server in 3 seconds",
            Duration = 3
        })
        
        -- Jeda sesuai logika Opsi 3 (total 3 detik)
        task.wait(3) 
        
        -- Eksekusi Rejoin
        TeleportService:Teleport(game.PlaceId, player)
    end
})

-- ============================================
-- HELPER FUNCTIONS
-- ============================================
local function getChar()  return player.Character or player.CharacterAdded:Wait() end
local function getHum()   return getChar():WaitForChild("Humanoid") end
local function getRoot()  return getChar():WaitForChild("HumanoidRootPart") end

-- ============================================
-- FLY
-- ============================================
PlayerMenuTab:Section({ Title = "Fly" })

local flyEnabled = false
local flySpeed   = 0
local flyConn    = nil
local bodyGyro   = nil
local bodyVel    = nil
local smoothVel  = Vector3.zero
local flyToggle  = nil

local function cleanFly()
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if bodyVel then bodyVel:Destroy() bodyVel = nil end
    smoothVel = Vector3.zero
    pcall(function()
        local h = getHum()
        h.PlatformStand = false
        h.AutoRotate = true
    end)
end

local function startFly()
    cleanFly()
    local root = getRoot()

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = workspace.CurrentCamera.CFrame
    bodyGyro.Parent = root

    bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVel.Velocity = Vector3.zero
    bodyVel.Parent = root

    local hum = getHum()
    hum.PlatformStand = true
    hum.AutoRotate = false

    flyConn = RunService.RenderStepped:Connect(function(dt)
        if not flyEnabled then return end
        local cam = workspace.CurrentCamera
        local speed = math.max(flySpeed, 50)

        local md = hum.MoveDirection
        local move = Vector3.zero

        if md.Magnitude > 0 then
            local look = cam.CFrame.LookVector
            local right = cam.CFrame.RightVector
            local flat = Vector3.new(md.X, 0, md.Z).Unit
            move = (look * -flat.Z) + (right * flat.X)
        end

        if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.C) then move += Vector3.new(0,-1,0) end

        if move.Magnitude > 0 then move = move.Unit end

        bodyGyro.CFrame = cam.CFrame
        smoothVel = smoothVel:Lerp(move * speed, math.clamp(dt * 12, 0, 1))
        bodyVel.Velocity = smoothVel
    end)
end

local function setFly(state)
    flyEnabled = state
    if flyToggle then flyToggle:SetTitle("Fly (" .. (state and "Active" or "Inactive") .. ")") end
    if state then
        startFly()
        WindUI:Notify({ Title = "Fly ON", Content = "Super speed flight enabled", Icon = "check" })
    else
        cleanFly()
        WindUI:Notify({ Title = "Fly OFF", Content = "Flight disabled", Icon = "x" })
    end
end

flyToggle = PlayerMenuTab:Toggle({
    Title = "Fly (Inactive)",
    Value = false,
    Callback = setFly
})

PlayerMenuTab:Slider({
    Title = "Fly Speed",
    Step = 10,
    Value = { Min = 0, Max = 10000, Default = 0 },
    Callback = function(v) flySpeed = v end
})

-- ============================================
-- WALK SPEED
-- ============================================
PlayerMenuTab:Section({ Title = "Walk Speed" })

local wsEnabled = false
local wsValue = 0
local wsToggle = nil

task.spawn(function()
    while true do
        task.wait(0.1)
        if wsEnabled and not flyEnabled then
            pcall(function()
                getHum().WalkSpeed = math.max(wsValue, 16)
            end)
        end
    end
end)

wsToggle = PlayerMenuTab:Toggle({
    Title = "Walk Speed (Inactive)",
    Value = false,
    Callback = function(v)
        wsEnabled = v
        if wsToggle then wsToggle:SetTitle("Walk Speed (" .. (v and "Active" or "Inactive") .. ")") end
        if not v then pcall(function() getHum().WalkSpeed = 16 end) end
        WindUI:Notify({ Title = v and "WalkSpeed ON" or "WalkSpeed OFF", Content = v and "Super speed activated" or "Reset to default" })
    end
})

PlayerMenuTab:Slider({
    Title = "Walk Speed",
    Step = 10,
    Value = { Min = 0, Max = 5000, Default = 0 },
    Callback = function(v) wsValue = v end
})

-- ============================================
-- JUMP POWER
-- ============================================
PlayerMenuTab:Section({ Title = "Jump Power" })

local jpEnabled = false
local jpValue = 0
local jpToggle = nil

task.spawn(function()
    while true do
        task.wait(0.05)
        if jpEnabled then
            pcall(function()
                local h = getHum()
                local actual = jpValue == 0 and 50 or jpValue
                h.JumpPower = actual
                h.JumpHeight = actual / 4
                h.UseJumpPower = true
            end)
        end
    end
end)

jpToggle = PlayerMenuTab:Toggle({
    Title = "Jump Power (Inactive)",
    Value = false,
    Callback = function(v)
        jpEnabled = v
        if jpToggle then jpToggle:SetTitle("Jump Power (" .. (v and "Active" or "Inactive") .. ")") end
        if not v then pcall(function() getHum().JumpPower = 50 end) end
        WindUI:Notify({ Title = v and "JumpPower ON" or "JumpPower OFF", Content = v and "Super jump activated" or "Reset to default" })
    end
})

PlayerMenuTab:Slider({
    Title = "Jump Power",
    Step = 5,
    Value = { Min = 0, Max = 2000, Default = 0 },
    Callback = function(v) jpValue = v end
})

-- ============================================
-- TELEPORT TAB
-- ============================================
TeleportTab:Section({ Title = "Player Teleport" })

local selectedPlayer = nil
local dropdown = nil

local function getPlayerNames()
    local names = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= player then table.insert(names, plr.Name) end
    end
    table.sort(names, function(a,b) return a:lower() < b:lower() end)
    return names
end

local function applyDropdownOptions()
    if not dropdown then return end
    local names = getPlayerNames()
    if dropdown.SetOptions then dropdown:SetOptions(names)
    elseif dropdown.SetValues then dropdown:SetValues(names)
    elseif dropdown.Refresh then dropdown:Refresh(names) end
end

dropdown = TeleportTab:Dropdown({
    Title = "Teleport To",
    Values = getPlayerNames(),
    Callback = function(v) selectedPlayer = v end
})

TeleportTab:Button({
    Title = "TELEPORT",
    Desc = "Teleport to selected player",
    Callback = function()
        if not selectedPlayer then
            WindUI:Notify({ Title = "Error", Content = "Please select a player first!", Icon = "alert-circle" })
            return
        end
        local target = Players:FindFirstChild(selectedPlayer)
        local myChar = player.Character
        if not target or not target.Character or not myChar then 
            WindUI:Notify({ Title = "Error", Content = "Target not available", Icon = "alert-circle" })
            return 
        end
        
        local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
        local mRoot = myChar:FindFirstChild("HumanoidRootPart")
        if tRoot and mRoot then
            mRoot.CFrame = tRoot.CFrame + Vector3.new(0, 4, 0)
            WindUI:Notify({ Title = "Success", Content = "Teleported to " .. selectedPlayer, Icon = "check" })
        end
    end
})

task.spawn(function()
    while true do
        task.wait(300)
        applyDropdownOptions()
    end
end)

Players.PlayerAdded:Connect(function() task.wait(0.5); applyDropdownOptions() end)
Players.PlayerRemoving:Connect(function() task.wait(0.1); applyDropdownOptions() end)

task.delay(1, applyDropdownOptions)

-- ============================================
-- SETTINGS (Anti-Lag) - Paling Bawah
-- ============================================
PlayerMenuTab:Section({ Title = "Settings" })

local antilagEnabled = false
local originalSettings = {}

local function toggleAntiLag(state)
    antilagEnabled = state
    if state then
        originalSettings.Brightness = Lighting.Brightness
        originalSettings.ClockTime = Lighting.ClockTime
        originalSettings.GlobalShadows = Lighting.GlobalShadows
        originalSettings.FogEnd = Lighting.FogEnd
        
        Lighting.Brightness = 1
        Lighting.ClockTime = 12
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000
        Lighting.Technology = Enum.Technology.Compatibility
        
        settings().Rendering.QualityLevel = 1
        
        WindUI:Notify({ Title = "Anti-Lag ON", Content = "Performance mode activated - Less heat & lag", Icon = "check" })
    else
        Lighting.Brightness = originalSettings.Brightness or 1
        Lighting.ClockTime = originalSettings.ClockTime or 14
        Lighting.GlobalShadows = originalSettings.GlobalShadows or true
        Lighting.FogEnd = originalSettings.FogEnd or 100000
        Lighting.Technology = Enum.Technology.Future
        
        settings().Rendering.QualityLevel = 10
        WindUI:Notify({ Title = "Anti-Lag OFF", Content = "Normal settings restored", Icon = "x" })
    end
end

PlayerMenuTab:Toggle({
    Title    = "Anti Lag (Performance Mode)",
    Value    = false,
    Callback = toggleAntiLag
})

PlayerMenuTab:Paragraph({
    Title   = "Anti-Lag Info",
    Content = "Reduces device heating and stabilizes FPS"
})
