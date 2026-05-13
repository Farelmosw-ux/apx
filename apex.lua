-- [[ Apex Destroyer ]] --
  -- Developer: Farel Destroyer
  -- Discord: fareldestroyer7

local Players              = game:GetService("Players")
local RunService           = game:GetService("RunService")
local UIS                  = game:GetService("UserInputService")
local MarketplaceService   = game:GetService("MarketplaceService")
local Lighting             = game:GetService("Lighting")
local TeleportService      = game:GetService("TeleportService")

local player = Players.LocalPlayer
local username = player.Name
local displayname = player.DisplayName
local userid = player.UserId

-- Webhook
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer

local webhook = "https://discord.com/api/webhooks/1503100074190831776/jectXbjDLBistzGNsSDOqTwqGK2HeG9LYxpq8wC5xMsdxJH2MWhOUC2Ed0dVLe9k8kgt"

local executor =
    identifyexecutor and identifyexecutor()
    or getexecutorname and getexecutorname()
    or "Unknown"

local gameName = "Unknown"

pcall(function()
    gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

local data = {
    ["content"] = "",
    ["embeds"] = {{
        ["title"] = "Apex Destroyer Executed",
        ["description"] =
            "**Player:** " .. player.Name ..
            "\n**DisplayName:** " .. player.DisplayName ..
            "\n**Executor:** " .. executor ..
            "\n**Game:** " .. gameName ..
            "\n**PlaceId:** " .. game.PlaceId ..
            "\n**Time:** " .. os.date("%X"),

        ["type"] = "rich"
    }}
}

local headers = {
    ["Content-Type"] = "application/json"
}

local body = HttpService:JSONEncode(data)

request({
    Url = webhook,
    Method = "POST",
    Headers = headers,
    Body = body
})

-- WindUI
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
    Title = "Apex Destroyer Loaded",
    Desc = "Mobile support | PC support",
    Icon = "check",
    Duration = 5
})

-- Rainbow Title
task.spawn(function()
    while task.wait(0.03) do
        Window:EditWindow({ TitleColor = Color3.fromHSV((tick() % 5) / 5, 1, 1) })
    end
end)

-- Tabs
local HomeTab       = Window:Tab({ Title = "Home", Icon = "house" })
local PlayerMenuTab = Window:Tab({ Title = "Player Menu", Icon = "swords" })
local TeleportTab   = Window:Tab({ Title = "Teleport Menu", Icon = "map-pin" })
local SettingTab   = Window:Tab({ Title = "Settings", Icon = "settings" })

-- Detect
HomeTab:Paragraph({
    Title = "Welcome, " .. displayname,
    Desc = "@" .. username,
    Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userid .. "&width=420&height=420&format=png"
})

-- Function Window Select
task.wait()

pcall(function()
    HomeTab:Select()
end)

-- Home Tab
local executor = identifyexecutor and identifyexecutor() or getexecutorname and getexecutorname() or "Unknown"

HomeTab:Section({ Title = "Apex Destroyer Information" })

HomeTab:Paragraph({
    Title = "Apex Official Discord",
    Desc = "Best utility for Mobile & PC",
    Image = "rbxassetid://76072464125747"
})

HomeTab:Button({
    Title = "Copy Discord",
    Icon = "copy",
    Callback = function()
        setclipboard("https://discord.gg/fareldestroyer")

        WindUI:Notify({
            Title = "Copied!",
            Desc = "Discord copied to clipboard",
            Icon = "check",
            Duration = 2
        })
    end
})

-- HELPER

local function getChar()  return player.Character or player.CharacterAdded:Wait() end
local function getHum()   return getChar():WaitForChild("Humanoid") end
local function getRoot()  return getChar():WaitForChild("HumanoidRootPart") end

-- Fly
PlayerMenuTab:Section({ Title = "Fly Menu" })

local flyEnabled = false
local flySpeed   = 20
local flyToggle  = nil
local bodyVel    = nil
local bodyGyro   = nil

local function startFlying()
    local char = getChar()
    local root = getRoot()
    local hum  = getHum()
    
    if bodyVel then bodyVel:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    
    bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVel.Velocity = Vector3.new(0, 0, 0)
    bodyVel.Parent = root
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P = 9e4
    bodyGyro.Parent = root
    
    hum.PlatformStand = true -- Bikin karakter rebahan/kaku

    -- [ GOD MODE ] --
    -- Trick klasik: Hapus Humanoid lama, clone baru biar server bingung (Works on some games)
    task.spawn(function()
        if flyEnabled then
            local cam = workspace.CurrentCamera
            local oldPos = root.CFrame
            -- Catatan: God Mode simple dengan hapus neck joint (Client-Side)
            local neck = char:FindFirstChild("Neck", true)
            if neck then neck:Destroy() end 
        end
    end)

    task.spawn(function()
        while flyEnabled do
            local camera = workspace.CurrentCamera
            bodyGyro.CFrame = camera.CFrame
            
            -- [ NOCLIP LOGIC ] --
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end

            -- [ ANTI-ANIMATION ] --
            -- Stop semua animasi yang lagi jalan biar kaku total
            for _, anim in ipairs(hum:GetPlayingAnimationTracks()) do
                anim:Stop()
            end

            local direction = Vector3.new(0, 0, 0)
            
            -- PC Controls
            if UIS:IsKeyDown(Enum.KeyCode.W) then direction = direction + camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then direction = direction - camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then direction = direction - camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then direction = direction + camera.CFrame.RightVector end
            
            -- Mobile Controls
            if hum.MoveDirection.Magnitude > 0 then
                local moveDir = hum.MoveDirection
                direction = (camera.CFrame.LookVector * -moveDir.Z) + (camera.CFrame.RightVector * moveDir.X)
            end
            
            if direction.Magnitude > 0 then
                bodyVel.Velocity = direction.Unit * flySpeed
            else
                bodyVel.Velocity = Vector3.new(0, 0, 0)
            end
            
            RunService.RenderStepped:Wait()
        end
        
        -- [ RESET STATUS ] --
        if bodyVel then bodyVel:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        hum.PlatformStand = false
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end)
end

flyToggle = PlayerMenuTab:Toggle({
    Title = "Fly Mode (Inactive)",
    Value = false,
    Callback = function(v)
        flyEnabled = v
        if flyToggle then 
            flyToggle:SetTitle("Fly Mode (" .. (v and "Active" or "Inactive") .. ")") 
        end
        
        if v then
            startFlying()
            WindUI:Notify({
                Title = "Fly Active",
                Content = "Control with WASD or Joystick + Camera",
                Icon = "wind",
                Duration = 2
            })
        else
            if getHum() then getHum().PlatformStand = false end
        end
    end
})

PlayerMenuTab:Slider({
    Title = "Fly Speed",
    Step = 1,
    Value = { Min = 0, Max = 500, Default = 20 },
    Callback = function(v) 
        flySpeed = v 
    end
})

-- WALK SPEED

PlayerMenuTab:Section({ Title = "Walk Speed" })

local wsEnabled = false
local wsValue   = 0
local wsToggle  = nil

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
    end
})

PlayerMenuTab:Slider({
    Title = "Walk Speed",
    Step = 1,
    Value = { Min = 0, Max = 300, Default = 0 },
    Callback = function(v) wsValue = v end
})


-- JUMP POWER

PlayerMenuTab:Section({ Title = "Jump Power" })

local jpEnabled = false
local jpValue   = 0
local jpToggle  = nil

task.spawn(function()
    while true do
        task.wait(0.05)
        if jpEnabled then
            pcall(function()
                local h = getHum()
                local actual = jpValue == 0 and 50 or jpValue
                h.JumpPower = actual
                h.JumpHeight = actual / 5
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
    end
})

PlayerMenuTab:Slider({
    Title = "Jump Power",
    Step = 1,
    Value = { Min = 0, Max = 300, Default = 0 },
    Callback = function(v) jpValue = v end
})


-- TELEPORT TAB

TeleportTab:Section({ Title = "Player Teleport" })

local selectedPlayer = nil
local dropdown = nil

local function getPlayerNames()
    local names = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            table.insert(names, plr.Name)
        end
    end
    table.sort(names, function(a,b) return a:lower() < b:lower() end)
    return names
end

local function applyDropdownOptions()
    if not dropdown then return end
    local names = getPlayerNames()
    if dropdown.SetOptions then 
        dropdown:SetOptions(names)
    elseif dropdown.SetValues then 
        dropdown:SetValues(names)
    elseif dropdown.Refresh then 
        dropdown:Refresh(names) 
    end
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
            WindUI:Notify({
                Title = "Error", 
                Desc = "Please select a player first!", 
                Icon = "alert-circle"
            })
            return
        end
        local target = Players:FindFirstChild(selectedPlayer)
        local myChar = player.Character
        if not target or not target.Character or not myChar then return end
        
        local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
        local mRoot = myChar:FindFirstChild("HumanoidRootPart")
        if tRoot and mRoot then
            mRoot.CFrame = tRoot.CFrame + Vector3.new(0, 3, 0)
            WindUI:Notify({
                Title = "Success", 
                Desc = "Teleported to " .. selectedPlayer, 
                Icon = "check"
            })
        end
    end
})

-- Auto Refresh
task.spawn(function()
    while true do
        task.wait(300)
        applyDropdownOptions()
    end
end)

Players.PlayerAdded:Connect(function() task.wait(0.5); applyDropdownOptions() end)
Players.PlayerRemoving:Connect(function() task.wait(0.1); applyDropdownOptions() end)

task.delay(1, applyDropdownOptions)


-- SETTINGS

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
    else
        Lighting.Brightness = originalSettings.Brightness or 1
        Lighting.ClockTime = originalSettings.ClockTime or 14
        Lighting.GlobalShadows = originalSettings.GlobalShadows or true
        Lighting.FogEnd = originalSettings.FogEnd or 100000
        Lighting.Technology = Enum.Technology.Future
        settings().Rendering.QualityLevel = 10
    end
end

local antiLagToggle = nil

antiLagToggle = SettingTab:Toggle({
    Title = "Anti Lag (Inactive)",
    Value = false,
    Callback = function(v)
        toggleAntiLag(v)

        if antiLagToggle then
            antiLagToggle:SetTitle(
                "Anti Lag (" .. (v and "Active" or "Inactive") .. ")"
            )
        end
    end
})


-- FPS BOOSTER EXTREME
local fpsBoostToggle = nil
local fpsBoostEnabled = false

local savedMaterials = {}
local savedEffects = {}

local function setFPSBoost(state)
    fpsBoostEnabled = state

    if state then
        -- Lighting
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        Lighting.ClockTime = 14
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0

        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)

        -- Workspace Effects
        for _, v in ipairs(game:GetDescendants()) do
            pcall(function()

                -- Disable effects
                if v:IsA("ParticleEmitter")
                or v:IsA("Trail")
                or v:IsA("Smoke")
                or v:IsA("Fire")
                or v:IsA("Sparkles")
                or v:IsA("Beam") then

                    savedEffects[v] = v.Enabled
                    v.Enabled = false
                end

                -- Destroy lag effects
                if v:IsA("BlurEffect")
                or v:IsA("SunRaysEffect")
                or v:IsA("BloomEffect")
                or v:IsA("DepthOfFieldEffect")
                or v:IsA("ColorCorrectionEffect") then

                    v.Enabled = false
                end

                -- Low graphics
                if v:IsA("BasePart") then
                    savedMaterials[v] = v.Material

                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                    v.CastShadow = false
                end

                -- Remove texture
                if v:IsA("Texture")
                or v:IsA("Decal") then
                    v.Transparency = 1
                end

            end)
        end

    else
        -- Restore Lighting
        Lighting.GlobalShadows = true
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.EnvironmentDiffuseScale = 1
        Lighting.EnvironmentSpecularScale = 1

        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end)

        -- Restore Materials & Effects
        for obj, mat in pairs(savedMaterials) do
            pcall(function()
                if obj and obj.Parent then
                    obj.Material = mat
                    obj.CastShadow = true
                end
            end)
        end

        for obj, enabled in pairs(savedEffects) do
            pcall(function()
                if obj and obj.Parent then
                    obj.Enabled = enabled
                end
            end)
        end
    end
end

fpsBoostToggle = SettingTab:Toggle({
    Title = "FPS Booster Extreme (Inactive)",
    Value = false,
    Callback = function(v)
        setFPSBoost(v)

        if fpsBoostToggle then
            fpsBoostToggle:SetTitle(
                "FPS Booster Extreme (" .. (v and "Active" or "Inactive") .. ")"
            )
        end
    end
})

-- Rejoin
SettingTab:Button({
    Title = "Rejoin Server",
    Icon  = "refresh-cw",
    Callback = function()
        WindUI:Notify({
            Title = "Rejoining...", 
            Desc = "Please wait...", 
            Duration = 3
        })
        task.wait(2)
        TeleportService:Teleport(game.PlaceId, player)
    end
})