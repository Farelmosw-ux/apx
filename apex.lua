-- [[ Apex Destroyer ]] --
-- Developer: Farel Destroyer

local Players              = game:GetService("Players")
local RunService           = game:GetService("RunService")
local UIS                  = game:GetService("UserInputService")
local MarketplaceService   = game:GetService("MarketplaceService")
local Lighting             = game:GetService("Lighting")
local TeleportService      = game:GetService("TeleportService")

local player = Players.LocalPlayer

-- ============================================
-- WINDUI LOADER (SUPER STABLE)
-- ============================================
local WindUI = nil

local urls = {
    "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua",
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua",
    "https://raw.githubusercontent.com/Footagesus/WindUI/main/main.lua"
}

for _, url in ipairs(urls) do
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url, true))()
    end)
    if success and result then
        WindUI = result
        print("✅ WindUI Loaded Successfully!")
        break
    end
end

if not WindUI then
    error("❌ WindUI gagal load. Coba restart executor atau ganti executor (Solara/Wave recommended)")
end

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

HomeTab:Button({
    Title = "Copy Discord",
    Icon  = "message-circle",
    Callback = function()
        local discordLink = "https://discord.gg/fareldestroyer"
        if setclipboard then
            setclipboard(discordLink)
            WindUI:Notify({ Title = "Copied!", Content = "Discord link copied to clipboard", Icon = "check", Duration = 3 })
        else
            WindUI:Notify({ Title = "Discord Link", Content = discordLink, Duration = 6 })
        end
    end
})

HomeTab:Button({
    Title = "Rejoin Server",
    Icon  = "refresh-cw",
    Callback = function()
        WindUI:Notify({ Title = "Rejoining...", Content = "Please wait...", Duration = 3 })
        task.wait(2)
        TeleportService:Teleport(game.PlaceId, player)
    end
})

-- ============================================
-- HELPER FUNCTIONS
-- ============================================
local function getChar()  return player.Character or player.CharacterAdded:Wait() end
local function getHum()   return getChar():WaitForChild("Humanoid") end
local function getRoot()  return getChar():WaitForChild("HumanoidRootPart") end

-- (Copy bagian Fly, WalkSpeed, JumpPower, Teleport dari script asli kamu yang tidak error)

-- Contoh Fly (disingkat, ganti dengan kode asli kamu kalau mau)
PlayerMenuTab:Section({ Title = "Fly" })

-- ... masukkan kode Fly, WalkSpeed, JumpPower, dan Teleport kamu di sini ...

-- ============================================
-- SETTINGS
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
        
        WindUI:Notify({ Title = "Anti-Lag ON", Content = "Performance mode activated", Icon = "check" })
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
