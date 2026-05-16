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
    Content = "Mobile support | PC support",
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
local HomeTab = Window:Tab({ Title = "Home", Icon = "layout-dashboard" })
local MainTab = Window:Tab({ Title = "Main Cheats", Icon = "zap" })
local NaviTab = Window:Tab({ Title = "Navigation", Icon = "send" })
local SettTab = Window:Tab({ Title = "Settings", Icon = "settings" })

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
    Image = "rbxassetid://76072464125747",
    Buttons = {
        {
            Title = "Copy Discord",
            Icon = "copy",
            Callback = function()
                setclipboard("https://discord.gg/fareldestroyer7")

                WindUI:Notify({
                    Title = "Copied!",
                    Content = "Discord copied to clipboard",
                    Icon = "check",
                    Duration = 2
                })
            end
        }
    }
})

-- [ Main Cheats ]
-- Helper
local function getChar()  return player.Character or player.CharacterAdded:Wait() end
local function getHum()   return getChar():WaitForChild("Humanoid") end
local function getRoot()  return getChar():WaitForChild("HumanoidRootPart") end

-- Fly
MainTab:Section({ Title = "Flight Control" })

local flyEnabled = false
local flying = false
local flySpeed = 50
local bodyVelocity, bodyGyro, flyConnection, stateChangedConnection, animationConnection, noclipConnection
local lastLookDirection = Vector3.new(0, 0, -1)
local rotationSpeed = 0.03 -- Sesuai LINHMC
local originalCollisionStates = {}

-- [[ CORE FUNCTIONS FROM LINHMC_NEW ]] --

local function isMovementAnimation(animationId)
    if not animationId then return false end
    local movementAnimIds = {
        "rbxassetid://180436334", "rbxassetid://180436148", "rbxassetid://125750702",
        "rbxassetid://180435571", "rbxassetid://180435792"
    }
    for _, id in pairs(movementAnimIds) do
        if animationId:find(id:gsub("rbxassetid://", "")) then return true end
    end
    return false
end

local function handleAnimations()
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    if animationConnection then animationConnection:Disconnect() end
    animationConnection = humanoid.AnimationPlayed:Connect(function(track)
        if flyEnabled and flying then
            if track.Animation and track.Animation.AnimationId then
                if isMovementAnimation(track.Animation.AnimationId) then
                    track:Stop() -- STIFF/KAKU LOGIC
                end
            end
        end
    end)
end

local function preventSitting()
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if stateChangedConnection then stateChangedConnection:Disconnect() end
        stateChangedConnection = humanoid.StateChanged:Connect(function(_, new)
            if flyEnabled and new == Enum.HumanoidStateType.Seated then
                task.wait(0.1)
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end
end

local function enableNoclip()
    if noclipConnection then noclipConnection:Disconnect() end
    noclipConnection = RunService.Stepped:Connect(function()
        if flyEnabled and flying and player.Character then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end)
end

-- [[ MAIN FLY LOGIC ]] --

local function startFly()
    local char = player.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if not root or not hum then return end
    flying = true
    
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = root
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 1e4
    bodyGyro.CFrame = root.CFrame
    bodyGyro.Parent = root

    -- Stop existing animations
    for _, track in pairs(hum:GetPlayingAnimationTracks()) do
        track:Stop()
    end
    
    hum.PlatformStand = true
    preventSitting()
    handleAnimations()
    enableNoclip()
    
    local camera = workspace.CurrentCamera
    local controlModule = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
    
    if flyConnection then flyConnection:Disconnect() end
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flyEnabled or not flying or not root.Parent then return end
        
        hum.PlatformStand = true
        local moveVec = controlModule:GetMoveVector()
        local targetVelocity = Vector3.zero
        
        if moveVec.Magnitude > 0 then
            -- PC & MOBILE DIRECTIONAL FIX
            local direction = camera.CFrame:VectorToWorldSpace(moveVec)
            targetVelocity = direction * flySpeed
        end
        
        -- Smoothing movement
        bodyVelocity.Velocity = bodyVelocity.Velocity:Lerp(targetVelocity, 0.25)
        
        -- Camera follow logic
        local currentLook = camera.CFrame.LookVector
        lastLookDirection = lastLookDirection:Lerp(currentLook, rotationSpeed)
        bodyGyro.CFrame = CFrame.lookAt(root.Position, root.Position + lastLookDirection)
        
        if targetVelocity.Magnitude == 0 then
            bodyVelocity.Velocity = Vector3.zero
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end)
end

local function stopFly()
    flying = false
    if flyConnection then flyConnection:Disconnect() end
    if noclipConnection then noclipConnection:Disconnect() end
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
end

-- [[ UI INTEGRATION ]] --
MainTab:Toggle({
    Title = "Fly",
    Value = false,
    Callback = function(v)
        flyEnabled = v
        if v then startFly() else stopFly() end
    end
})

MainTab:Slider({
    Title = "Fly Speed",
    Step = 1,
    Value = { Min = 0, Max = 1000, Default = 50 },
    Callback = function(v) 
        flySpeed = v 
    end
})

-- Walk Speed
MainTab:Section({ Title = "Walk Speed" })

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

wsToggle = MainTab:Toggle({
    Title = "Walk Speed (Inactive)",
    Value = false,
    Callback = function(v)
        wsEnabled = v
        if wsToggle then wsToggle:SetTitle("Walk Speed (" .. (v and "Active" or "Inactive") .. ")") end
        if not v then pcall(function() getHum().WalkSpeed = 16 end) end
    end
})

MainTab:Slider({
    Title = "Walk Speed",
    Step = 1,
    Value = { Min = 0, Max = 300, Default = 0 },
    Callback = function(v) wsValue = v end
})


-- Jump Power
MainTab:Section({ Title = "Jump Power" })

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

jpToggle = MainTab:Toggle({
    Title = "Jump Power (Inactive)",
    Value = false,
    Callback = function(v)
        jpEnabled = v
        if jpToggle then jpToggle:SetTitle("Jump Power (" .. (v and "Active" or "Inactive") .. ")") end
        if not v then pcall(function() getHum().JumpPower = 50 end) end
    end
})

MainTab:Slider({
    Title = "Jump Power",
    Step = 1,
    Value = { Min = 0, Max = 300, Default = 0 },
    Callback = function(v) jpValue = v end
})

-- Noclip (Tembus Dinding, Anti Jatuh ke Void)
MainTab:Section({ Title = "Noclip System" })

local noclipWallEnabled = false
local noclipWallToggle = nil
local noclipConnectionWall = nil

local function startNoclipWall()
    if noclipConnectionWall then noclipConnectionWall:Disconnect() end
    noclipConnectionWall = RunService.Stepped:Connect(function()
        if noclipWallEnabled and player.Character then
            local char = player.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            -- Deteksi objek di bawah kaki menggunakan Raycast sederhana
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {char}
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            
            -- Tembakkan ray ke bawah sejauh 4.5 unit dari RootPart
            local raycastResult = workspace:Raycast(root.Position, Vector3.new(0, -4.5, 0), raycastParams)
            local groundPart = raycastResult and raycastResult.Instance

            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end

            -- Matikan kolisi semua part map KECUALI tanah/lantai yang sedang dipijak
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide and not v:IsDescendantOf(char) then
                    if groundPart and (v == groundPart or v:IsAncestorOf(groundPart)) then
                        -- Biarkan lantai bawah tetap padat biar tidak jatuh ke void
                        v.CanCollide = true
                    else
                        -- Tembus objek/dinding selain lantai pijakan
                        v.CanCollide = false
                    end
                end
            end
        end
    end)
end

local function stopNoclipWall()
    noclipWallEnabled = false
    if noclipConnectionWall then noclipConnectionWall:Disconnect() end
    -- Kembalikan kolisi karakter ke normal
    if player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
end

noclipWallToggle = MainTab:Toggle({
    Title = "Noclip Wall (Inactive)",
    Icon = "unlocked",
    Value = false,
    Callback = function(v)
        noclipWallEnabled = v
        if noclipWallToggle then 
            noclipWallToggle:SetTitle("Noclip Wall (" .. (v and "Active" or "Inactive") .. ")") 
        end
        if v then startNoclipWall() else stopNoclipWall() end
    end
})

-- Invisible Character
MainTab:Section({ Title = "Ghost System" })

local invisEnabled = false
local invisToggle = nil
local invisConnection = nil
local storedCFrame = nil

local function startInvisible()
    local char = player.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    
    -- Simpan posisi awal karakter saat pertama kali menyala
    storedCFrame = root.CFrame
    
    -- Trik Invisible dengan menurunkan LowerTorso / UpperTorso (R15) atau Torso (R6) secara lokal ke bawah map
    -- agar di server, player lain mengira lu berada jauh di bawah, padahal di screen lu masih di atas.
    invisConnection = RunService.Heartbeat:Connect(function()
        if not invisEnabled or not player.Character then return end
        
        local character = player.Character
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        -- Sembunyikan bagian tubuh, baju, aksesoris, dan billboard name tag secara berulang
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                v.Transparency = 1
                v.CanCollide = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
                v.Enabled = false
            end
        end
        
        -- Memutuskan sambungan animasi agar karakter tidak memicu partikel/gerakan server
        local animate = character:FindFirstChild("Animate")
        if animate then animate.Enabled = false end
        
        -- Trik offset motor6D / joint ke bawah (supaya server-side ikut mendeteksi posisi lu di bawah/tidak terlihat)
        local lowerTorso = character:FindFirstChild("LowerTorso") or character:FindFirstChild("Torso")
        if lowerTorso then
            for _, joint in pairs(character:GetDescendants()) do
                if joint:IsA("Motor6D") and (joint.Name == "RootJoint" or joint.Name == "Root") then
                    joint.Transform = CFrame.new(0, -500, 0) -- Melempar visual tubuh ke bawah map agar tak terlihat server
                end
            end
        end
    end)
end

local function stopInvisible()
    invisEnabled = false
    if invisConnection then invisConnection:Disconnect() end
    
    -- Reset karakter dengan mematikan fungsi atau merefresh agar tubuh kembali normal
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        -- Cara paling aman mengembalikan karakter dari invisible total ke normal tanpa bug adalah me-reset / memicu respawn lokal jika hancur
        -- atau merestore transparansi jika masih utuh:
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                if v.Name ~= "HumanoidRootPart" then
                    v.Transparency = 0
                end
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 0
            elseif v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
                v.Enabled = true
            end
        end
        local animate = char:FindFirstChild("Animate")
        if animate then animate.Enabled = true end
        
        -- Kembalikan posisi Joint Tubuh ke semula
        for _, joint in pairs(char:GetDescendants()) do
            if joint:IsA("Motor6D") and (joint.Name == "RootJoint" or joint.Name == "Root") then
                joint.Transform = CFrame.new()
            end
        end
        
        -- Force update dengan melompat atau mereset state agar sinkron kembali ke server
        if hum then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
end

invisToggle = MainTab:Toggle({
    Title = "Invisible Character (Inactive)",
    Icon = "eye-off", -- Ikon mata disilang melambangkan tidak terlihat
    Value = false,
    Callback = function(v)
        invisEnabled = v
        if invisToggle then 
            invisToggle:SetTitle("Invisible Character (" .. (v and "Active" or "Inactive") .. ")") 
        end
        if v then startInvisible() else stopInvisible() end
    end
})

-- [ Navigation ]
NaviTab:Section({ Title = "Player Teleport" })

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

dropdown = NaviTab:Dropdown({
    Title = "Teleport To",
    Values = getPlayerNames(),
    Callback = function(v) selectedPlayer = v end
})

NaviTab:Button({
    Title = "TELEPORT",
    Desc = "Teleport to selected player",
    Callback = function()
        if not selectedPlayer then
            WindUI:Notify({
                Title = "Error", 
                Content = "Please select a player first!", 
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
                Content = "Teleported to " .. selectedPlayer, 
                Icon = "check"
            })
        end
    end
})

-- [ Settings ]
task.spawn(function()
    while true do
        task.wait(300)
        applyDropdownOptions()
    end
end)

Players.PlayerAdded:Connect(function() task.wait(0.5); applyDropdownOptions() end)
Players.PlayerRemoving:Connect(function() task.wait(0.1); applyDropdownOptions() end)

task.delay(1, applyDropdownOptions)


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

antiLagToggle = SettTab:Toggle({
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

fpsBoostToggle = SettTab:Toggle({
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
SettTab:Button({
    Title = "Rejoin Server",
    Icon  = "refresh-cw",
    Callback = function()
        WindUI:Notify({
            Title = "Rejoining...", 
            Content = "Please wait...", 
            Duration = 3
        })
        task.wait(2)
        TeleportService:Teleport(game.PlaceId, player)
    end
})

-- ========================================================
-- CUSTOM ROLE / TITLE & CHAT TAG SYSTEM (SETTTAB)
-- ========================================================
SettTab:Section({ Title = "Custom Identity System" })

local identityEnabled = false
local selectedRole = "Admin" -- Default role
local identityToggle = nil

-- Konfigurasi Warna Kece untuk Role & Tag
local roleConfigs = {
    ["Owner"]  = { Color = Color3.fromRGB(255, 0, 100),   Text = "[Owner]" },  -- Pink Neon Kece
    ["Admin"]  = { Color = Color3.fromRGB(0, 220, 255),   Text = "[Admin]" },  -- Cyan Elegan
    ["Hacker"] = { Color = Color3.fromRGB(0, 255, 130),   Text = "[Hacker]" }  -- Hijau Matrix
}

-- 1. FUNGSI TITLE DI ATAS KEPALA (BILLBOARD GUI)
local function createOverheadTitle()
    local char = player.Character
    local head = char and char:WaitForChild("Head", 5)
    if not head or not identityEnabled then return end
    
    -- Hapus title lama jika ada
    if head:FindFirstChild("ApexTitle") then head.ApexTitle:Destroy() end
    
    local config = roleConfigs[selectedRole]
    
    local bbg = Instance.new("BillboardGui")
    bbg.Name = "ApexTitle"
    bbg.Adornee = head
    bbg.Size = UDim2.new(0, 200, 0, 50)
    bbg.StudsOffset = Vector3.new(0, 2.5, 0) -- Jarak di atas nama asli
    bbg.AlwaysOnTop = true
    bbg.Parent = head
    
    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1, 0, 1, 0)
    tl.BackgroundTransparency = 1
    tl.Text = config.Text
    tl.TextColor3 = config.Color
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = 15
    tl.TextStrokeTransparency = 0.2
    tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    tl.Parent = bbg
end

-- 2. FUNGSI CHAT TAG INJECTOR
-- Mendukung TextChatService (Sistem Chat Baru Roblox)
local TextChatService = game:GetService("TextChatService")
if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    TextChatService.OnIncomingMessage = function(message)
        local properties = Instance.new("TextChatMessageProperties")
        if identityEnabled and message.TextSource and message.TextSource.UserId == player.UserId then
            local config = roleConfigs[selectedRole]
            -- Tag Berwarna + Nama Putih Default
            properties.PrefixText = "<font color='rgb("..math.floor(config.Color.R*255)..", "..math.floor(config.Color.G*255)..", "..math.floor(config.Color.B*255)..")'>" .. config.Text .. "</font> <font color='rgb(255,255,255)'>" .. message.PrefixText .. "</font>"
        end
        return properties
    end
end

-- Mendukung LegacyChatService (Sistem Chat Lama Roblox)
pcall(function()
    local ChatService = require(game:GetService("ServerScriptService")
        :WaitForChild("ChatServiceRunner")
        :WaitForChild("ChatService"))

    ChatService.SpeakerAdded:Connect(function(speakerName)
        if speakerName == player.Name then
            local speaker = ChatService:GetSpeaker(speakerName)

            RunService.Heartbeat:Connect(function()
                if identityEnabled then
                    local config = roleConfigs[selectedRole]
                    speaker:SetExtraData("Tags", {
                        {
                            TagText = config.Text,
                            TagColor = config.Color
                        }
                    })
                    speaker:SetExtraData("NameColor", Color3.fromRGB(255, 255, 255))
                else
                    speaker:SetExtraData("Tags", {})
                end
            end)
        end
    end)
end)

-- Loop agar Title di atas kepala selalu terpasang saat respawn
player.CharacterAdded:Connect(function()
    task.wait(1)
    if identityEnabled then createOverheadTitle() end
end)

-- 3. DROP-DOWN SELEKSI ROLE
SettTab:Dropdown({
    Title = "Select Role / Title",
    Icon = "user-cog",
    Values = {"Owner", "Admin", "Hacker"},
    Callback = function(v)
        selectedRole = v
        if identityEnabled then
            createOverheadTitle() -- Langsung update title jika aktif
        end
    end
})

-- 4. TOGGLE UTAMA IDENTITY FITUR
identityToggle = SettTab:Toggle({
    Title = "Identity System (Inactive)",
    Icon = "shield",
    Value = false,
    Callback = function(v)
        identityEnabled = v
        if identityToggle then
            identityToggle:SetTitle("Identity System (" .. (v and "Active" or "Inactive") .. ")")
        end
        
        if v then
            createOverheadTitle()
        else
            -- Hapus title jika dimatikan
            local char = player.Character
            local head = char and char:FindFirstChild("Head")
            if head and head:FindFirstChild("ApexTitle") then
                head.ApexTitle:Destroy()
            end
        end
    end
})
