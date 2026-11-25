local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local linoriaRepo = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(linoriaRepo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(linoriaRepo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(linoriaRepo .. "addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
    Title = "bd esp/aimbot | by ralsei ON SCRIPTBLOX!",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.15
})

local lp = Players.LocalPlayer
local lpUserId = lp.UserId
local Mouse = lp:GetMouse()

local BloodFolder = Workspace:FindFirstChild("BloodFolder")
local NPCSFolder = Workspace:FindFirstChild("NPCSFolder")

local espBlockList = {
    ["You"] = true
}

local darkRedTargets = {
    ["kai zhang"] = true,
    ["veronika kazakova"] = true
}

local validTagModes = {
    ["Role"] = true,
    ["Character Name"] = true,
    ["Username"] = true
}

local validColorModes = {
    ["Role"] = true,
    ["Custom"] = true
}

local isSyncingUi = false
local espConfigFile = "BloodDebtCustomEsp.json"
local configSlotName = "Default"
local currentTarget = nil

local lastVisRefresh = 0
local visRefreshInterval = 0.08
local lastEspRender = 0
local espRenderInterval = 0.02

local espSettings = {
    Enabled = false,
    CompactCqb = false,
    Box = true,
    BoxOutline = true,
    BoxThickness = 1.2,
    BoxWidthScale = 0.54,
    Skeleton = true,
    SkeletonThickness = 1.5,
    Highlight = false,
    HealthBar = true,
    HealthBarSide = "Left",
    HealthBarWidth = 3,
    HealthText = false,
    Nametag = true,
    NametagMode = "Role",
    NametagSize = 12,
    DistanceEsp = true,
    DistanceUnit = "Studs",
    InventoryEsp = true,
    EquippedOnly = true,
    InventorySize = 10,
    MaxDistance = 1500,
    FillOpacity = 0.92,
    ColorMode = "Role",
    BlockedShade = 0.5,
    CustomColor = {255, 255, 255},
    DarkRedPriority = true,
    NoRecoil = false
}

local aimbotConfig = {
    Enabled = false,
    TargetPart = "Head",
    FOV = 150,
    ShowFOV = true
}

local weaponRoles = {
    ["GG-17"] = "Vigilante",
    ["GG-17 Tan"] = "Vigilante",
    ["GG-17 TAN"] = "Vigilante",
    ["GG-1720"] = "Vigilante",
    ["GG-17GILDED"] = "Vigilante",
    ["GILDED GG-17"] = "Vigilante",
    ["Pretty Pink GG-17"] = "Vigilante",
    ["GG-17 Tropical Sunshine"] = "Vigilante",
    ["Dual GG-17"] = "Vigilante",
    ["Dual GG-17s"] = "Vigilante",
    ["Dual GG 17s"] = "Vigilante",
    ["GG-26"] = "Vigilante",
    ["J9-Meretta"] = "Vigilante",
    ["J9 Meretta"] = "Vigilante",
    ["J9-Merretta"] = "Vigilante",
    ["J9 Merretta"] = "Vigilante",
    ["J9-M"] = "Vigilante",
    ["RR-Snubby"] = "Vigilante",
    ["RR-Snubby 10"] = "Vigilante",
    ["RR-Snubby10"] = "Vigilante",
    ["RR-SnubbyGILDED"] = "Vigilante",
    ["GILDED RR-Snubby"] = "Vigilante",
    ["Golden RR-Snubby"] = "Vigilante",
    ["SilverSteel RR-Snubby"] = "Vigilante",
    ["R&E Snubby"] = "Vigilante",
    ["R&E M10"] = "Vigilante",
    ["ZKZ-Obrez"] = "Vigilante",
    ["ZKZ-Obrez10"] = "Vigilante",
    ["ZKZ-OBREZ10"] = "Vigilante",
    ["Clothed ZKZ-Obrez"] = "Vigilante",
    ["ZKZ-Obrez Sakuya"] = "Vigilante",
    ["HW-226"] = "Vigilante",
    ["HWISSH-226"] = "Vigilante",
    ["IZVEKH-412"] = "Vigilante",
    ["Charcoal Steel IZVEKH-412"] = "Vigilante",
    ["CharcoalSteel I412"] = "Vigilante",
    ["Beagle"] = "Vigilante",
    ["Beagle-44"] = "Vigilante",
    ["Beagle 44"] = "Vigilante",
    ["BEAGLE-44"] = "Vigilante",
    ["Beagle-55"] = "Vigilante",
    ["Beagle 55"] = "Vigilante",
    ["BEAGLE-55"] = "Vigilante",
    ["Paradise Beagle"] = "Vigilante",
    ["Beagle TIGERSTRIPES"] = "Vigilante",
    ["TIGERSTRIPE Beagle"] = "Vigilante",
    ["DRICO"] = "Vigilante",
    ["Case Hardened DRICO"] = "Vigilante",
    ["Case-Hardened DRICO"] = "Vigilante",
    ["HW-M5K"] = "Vigilante",
    ["HW-MPi5k"] = "Vigilante",
    ["ANKO46"] = "Vigilante",
    ["JS-5A-Obrez"] = "Vigilante",
    ["JS-5A-OBREZ"] = "Vigilante",
    ["Buxxberg-COMPACT"] = "Vigilante/Team War",
    ["BUXXBERG-COMPACT"] = "Vigilante/Team War",
    ["BUXXBERG COMPACT"] = "Vigilante/Team War",
    ["Pretty Pink Buxxberg-COMPACT"] = "Vigilante/Team War",
    ["Pretty Pink BUXXBERG COMPACT"] = "Vigilante/Team War",
    ["Shot-7"] = "Vigilante",

    ["AT's K16A1"] = "Juggernaut",
    ["RY's GG-17"] = "Juggernaut",
    ["VK's ANKM"] = "Juggernaut",
    ["AK47 Case Hardened 1000000"] = "Juggernaut",
    ["AK47 Case-Hardened 1000000"] = "Juggernaut",
    ["AT's KAR15"] = "Juggernaut",
    ["AT's KAR-15"] = "Juggernaut",
    ["VKAZ's RVK70"] = "Juggernaut",
    ["RVK"] = "Juggernaut",
    ["TG's ZVD"] = "Juggernaut",
    ["GZhG-7.62"] = "Juggernaut",
    ["GZHG-7.62"] = "Juggernaut",
    ["GZhG-7.62 HMG"] = "Juggernaut",
    ["LORD 12.7"] = "Juggernaut",
    ["ZKMP"] = "Juggernaut/Politsiya",
    ["KOLT-PSRL"] = "Juggernaut/Politsiya",
    ["BGRT-7"] = "Juggernaut",
    ["GGtastic"] = "Juggernaut",
    ["PTRZ-41"] = "Juggernaut",
    ["GATR 05"] = "Juggernaut",
    ["Coach Shotgun"] = "Team War/Juggernaut",

    ["ANK74M"] = "Politsiya",
    ["RVK70"] = "Politsiya",
    ["ZKMP1"] = "Politsiya",
    ["ZOZ-194"] = "Politsiya",
    ["ANK74SU"] = "Politsiya",
    ["ANKS-74U"] = "Politsiya / Team War",
    ["Izvekh-Bisen"] = "Politsiya/Team War",
    ["IZVEKH-BISEN"] = "Politsiya/Team War",
    ["AN-J91"] = "Team War / Politsiya",
    ["ZJ-23M"] = "Politsiya/Team War",

    ["Mersa-12"] = "Team War",
    ["MERSA-12"] = "Team War",
    ["BuxxBerg590"] = "Team War",
    ["Buxxberg-590"] = "Team War",
    ["HW 3"] = "Team War",
    ["HW3"] = "Team War",
    ["RR-40"] = "Team War",
    ["KEDIR"] = "Team War",
    ["BF F90"] = "Team War",
    ["HW-MPi5a4"] = "Team War",
    ["Tarakev-43"] = "Team War",
    ["ZR-1"] = "Team War",
    ["ZR-2"] = "Team War",
    ["HW-SpM45"] = "Team War",
    ["Auto 180"] = "Team War",
    ["IZVEKH-ViteX"] = "Team War",
    ["IZVEKH-VITEX"] = "Team War",
    ["ANKM"] = "Team War",
    ["Kolt AR-15"] = "Team War",
    ["KAR-15"] = "Team War",
    ["KOLT-733"] = "Team War",
    ["SAG STORM"] = "Team War",
    ["Blemington 700 Scoped"] = "Team War",
    ["Blemington-700 Scoped"] = "Team War",
    ["JAVELIN-ZVD"] = "Team War",
    ["JAVELIN-ZVU"] = "Team War",
    ["BF AAL"] = "Team War",
    ["A86M2L-SW"] = "Team War",
    ["AB-VIZG"] = "Team War",
    ["Rosen-Nagan"] = "Team War",
    ["KR2"] = "Team War",
    ["HW-G3a3"] = "Team War",
    ["VZZ"] = "Team War",
    ["RR-14"] = "Team War",
    ["RR-21-SWS"] = "Team War",
    ["H&W-G36CC"] = "Team War",
    ["CIR95"] = "Team War",
    ["ZPO-101"] = "Team War",
    ["Casaro 91"] = "Team War",
    ["A85L1"] = "Team War",
    ["JTS-225"] = "Team War",
    ["Palico-37"] = "Team War",
    ["JS-5A"] = "Team War",
    ["HUSHASH-12"] = "Team War",
    ["1895-Rosey"] = "Team War/Killer",
    ["ZKZ"] = "Team War/Scav War",

    ["Mini Ranch Rifle"] = "Scav War",
    ["AMAR-15"] = "Scav War",

    ["RR-LCP"] = "Killer",
    ["RR-LCP10"] = "Killer",
    ["RR-LCP 10M"] = "Killer",
    ["RR-LightCombatPistol"] = "Killer",
    ["Pretty Pink RR-LCP"] = "Killer",
    ["ChromeSlide Turqoise RR-LCP"] = "Killer",
    ["Chromeslide"] = "Killer",
    ["Whiteout RR-LCP"] = "Killer",
    ["Dual RR-LCPs"] = "Killer",
    ["Dual LCPs"] = "Killer",
    ["Kamatov"] = "Killer",
    ["KamatovS"] = "Killer",
    ["KamatovDRUM"] = "Killer",
    ["RR-LightCombatPistol (S)"] = "Killer/Survivor",
    ["RR-LightCombatPistolS"] = "Killer/Survivor",
    ["RR-LightCombatPistolS10"] = "Killer/Survivor",
    ["Whiteout RR-LightCompactPistolS"] = "Killer/Survivor",
    ["HWISHH-KP9"] = "Killer/Survivor",

    ["JS2-Derringy"] = "Killer",
    ["JS-2 Derringy"] = "Killer/Survivor",
    ["JS2-BondsDerringy"] = "Killer",
    ["Js2 Bond Derringy"] = "Killer",
    ["JS-2 Bonds Derringy"] = "Killer",
    ["JS2-DerringyGILDED"] = "Killer",
    ["GILDED JS-2 Derringy"] = "Killer",
    ["Memories"] = "Killer",
    ["Katya's 'Memories'"] = "Killer",
    ["Katya's Memories JS-2 Derringer"] = "Killer",
    ["JS1-Cyclops"] = "Killer",
    ["JS1-CYCLOPS"] = "Killer",
    ["J21a Meretta"] = "Killer",
    ["J21a Merretta"] = "Killer",
    ["Dual ELITES"] = "Killer",
    ["Dual Elites"] = "Killer",
    ["Jolibri"] = "Killer",

    ["K1911"] = "Killer",
    ["GraySteel K1911"] = "Killer",
    ["DarkSteel K1911"] = "Killer",
    ["Dark Steel"] = "Killer",
    ["SilverSteel K1911"] = "Killer",
    ["Silver Steel"] = "Killer",
    ["K1911GILDED"] = "Killer",
    ["GILDED K1911"] = "Killer",
    ["GILDED"] = "Killer",
    ["K1911 'Memorial'"] = "Killer",
    ["Memorial"] = "Killer",
    ["Dented K1911"] = "Killer",
    ["Nikolai's 'Dented'"] = "Killer",
    ["HEARDBALLER"] = "Killer",
    ["HEARDBALLA"] = "Killer",
    ["Testament"] = "Killer",

    ["JS-22"] = "Killer/Survivor",
    ["JS-22GILDED"] = "Killer/Survivor",
    ["GILDED JS-22"] = "Killer/Survivor",
    ["CharcoalSteel JS-22"] = "Killer/Survivor",
    ["Charcoal Steel JS-22"] = "Killer/Survivor",
    ["corrodedmetal JS-22"] = "Killer/Survivor",
    ["Corroded Metal JS-22"] = "Killer/Survivor",
    ["PLASTIC JS-22"] = "Killer/Survivor",
    ["Plastic JS-22"] = "Killer/Survivor",
    ["Anatoly's JS-22"] = "Killer/Survivor",

    ["JS-44"] = "Killer",
    ["CharcoalSteel JS-44"] = "Killer",
    ["Charcoal Steel JS-44"] = "Killer",
    ["JSK-44"] = "Killer",
    ["RR-MARK2"] = "Killer",
    ["RR-Mark2"] = "Killer",
    ["AGM-22"] = "Killer",
    ["AGM22"] = "Killer",
    ["WISP"] = "Killer",
    ["Mooser"] = "Killer",
    ["HW-K7"] = "Killer",
    ["ZT-33"] = "Killer",
    ["FT100"] = "Killer",
    ["RUZKH-12"] = "Killer",
    ["Pol357"] = "Killer",
    ["Bouquet"] = "Killer",
    ["Fleet K51"] = "Killer",
    ["Bezzhummy"] = "Killer",
    ["Gisil-Pistole"] = "Killer",
    ["RDG-2B"] = "Killer",
    ["Berf-JOLT"] = "Killer",

    ["Skorpion"] = "Killer",
    ["SKORPION"] = "Killer",
    ["SKORPION10"] = "Killer",
    ["SKORPION 'AMIRNOV"] = "Killer",
    ["Clothed SKORPION"] = "Killer",
    ["CharcoalSteel SKORPION"] = "Killer",
    ["Charcoal Steel SKORPION"] = "Killer",
    ["Dual SKORPS"] = "Killer",
    ["Dual SKORPIONs"] = "Killer",
    ["Mak-10"] = "Killer/Survivor",
    ["MAK-10"] = "Killer/Survivor",
    ["MAK-1020"] = "Killer/Survivor",
    ["Tropical Sunshine MAK-10"] = "Killer/Survivor",
    ["ZZ-90"] = "Killer",
    ["ZZ-71"] = "Killer",
    ["TEKE-9"] = "Killer",
    ["KR7S"] = "Killer",
    ["Lut-e Krus"] = "Killer",
    ["LUT-E KRUS"] = "Killer",
    ["LUT-E 'KRUS'"] = "Killer",
    ["Micro Kzi"] = "Killer",
    ["Micro KZI"] = "Killer",
    ["PPm-41"] = "Killer",
    ["APZ"] = "Killer",

    ["Rosen Obrez"] = "Killer",
    ["Rosen-Obrez"] = "Killer",
    ["Clothed Rosen Obrez"] = "Killer",
    ["Clothed Rosen-Obrez"] = "Killer",
    ["GILDED Rosen Obrez"] = "Killer",
    ["Whiteout Rosen-Obrez"] = "Killer",
    ["Skeleton Rosen-Obrez"] = "Killer",
    ["Skeletonized Rosen-Obrez"] = "Killer",
    ["Rosen Nagan"] = "Killer",
    ["Mares Leg"] = "Killer",
    ["Mare's Leg"] = "Killer",
    ["Mares Leg10"] = "Killer",
    ["JAVELIN-OBREZS"] = "Killer",
    ["Whizz"] = "Killer",
    ["WHIZZ"] = "Killer",
    ["VA's ANKM"] = "Killer",
    ["TG's JAVELIN-ZVD"] = "Killer",
    ["PTRB-41"] = "Killer",
    ["Daniqui-Obrez"] = "Killer",

    ["Sawed-Off"] = "Killer",
    ["Sawn-Off"] = "Killer",
    ["Sawn-off"] = "Killer",
    ["Sawn-off10"] = "Killer",
    ["Sawn-Off 10"] = "Killer",
    ["Sawn-offGILDED"] = "Killer",
    ["GILDED Sawn-Off"] = "Killer",
    ["Clothed Sawn-off"] = "Killer",
    ["Clothed Sawed Off"] = "Killer",
    ["JTS-225 Obrez"] = "Killer",
    ["JTS225-Obrez"] = "Killer",
    ["JTS225-OBREZ"] = "Killer",
    ["JTS225-Obrez10"] = "Killer",
    ["JTS225-ObrezGILDED"] = "Killer",
    ["JTS225-Obrez Poly"] = "Killer",
    ["JTS225-Obrez Monochrome"] = "Killer",
    ["JTS225-Obrez Partycannon"] = "Killer",
    ["TG's JTS225"] = "Killer",
    ["Thumpa"] = "Killer",
    ["THUMPA"] = "Killer",
    ["MANDOLS-5"] = "Killer",
    ["Mandols-5"] = "Killer",
    ["Wild MANDOLS-5"] = "Killer",
    ["Wild Mandols-5"] = "Killer",
    ["Merretta 486 Palubu"] = "Killer",
    ["Meretta486Palubu Sawn-Off"] = "Killer",
    ["Merretta486Palubu"] = "Killer",
    ["Kensington"] = "Killer",
    ["Kensington20"] = "Killer",
    ["Tropical Sunshine Kensington"] = "Killer",
    ["ZOZ-106"] = "Killer",
    [".410 Bonds Derringy"] = "Killer",
    ["JS"] = "Killer",
    ["Lenitrovyak-23"] = "Killer",

    ["Js1 Competitor"] = "Killer",
    ["JS1 Competitor"] = "Killer",
    ["JS1-Competitor"] = "Killer",
    ["DOOR'BLER"] = "Killer",
    ["Door'bler"] = "Killer",
    ["TIGERSTRIPE DOOR'BLER"] = "Killer",
    ["Door'bler TIGERSTRIPES"] = "Killer",
    ["Hammer N' Bullet"] = "Killer",
    ["Hammer 'n Bullet"] = "Killer",
    ["Comically Large Spoon"] = "Killer",
    ["THE SPOON"] = "Killer",
    ["Mason's Machete"] = "Killer"
}

local neutralGear = {
    ["Smoke Maker"] = true,
    ["Sound Maker"] = true,
    ["Throwing Dagger"] = true,
    ["NGO"] = true,
    ["Bandages"] = true,
    ["BandagePack"] = true,
    ["Zarye-2"] = true,
    ["Z26M Stungun"] = true,
    ["Cellphone"] = true,
    ["Cloth"] = true,
    ["SprayBottle"] = true,
    ["Spray Bottle"] = true,
    ["Hands"] = true,
    ["Cassette Player"] = true,
    ["Boxcutters"] = true,
    ["Boxcutter"] = true
}

local roleStyle = {
    ["Killer"] = {color = Color3.fromRGB(255, 0, 0), label = "KILLER"},
    ["Vigilante"] = {color = Color3.fromRGB(0, 150, 255), label = "VIGILANTE"},
    ["Team War"] = {color = Color3.fromRGB(255, 140, 0), label = "TEAM WAR"},
    ["Politsiya"] = {color = Color3.fromRGB(255, 230, 0), label = "POLITSIYA"},
    ["Scav War"] = {color = Color3.fromRGB(160, 0, 255), label = "SCAV WAR"},
    ["Juggernaut"] = {color = Color3.fromRGB(255, 0, 200), label = "JUGGERNAUT"},
    ["Survivor"] = {color = Color3.fromRGB(0, 255, 180), label = "SURVIVOR"},
    ["Innocent"] = {color = Color3.fromRGB(0, 255, 0), label = "INNOCENT"}
}

local darkRedColor = Color3.fromRGB(120, 0, 0)
local boxOutlineColor = Color3.fromRGB(10, 10, 12)
local distTextColor = Color3.fromRGB(190, 200, 215)
local equippedTextColor = Color3.fromRGB(255, 210, 90)
local invTextColor = Color3.fromRGB(215, 220, 230)

local rolePriority = {
    "Killer",
    "Juggernaut",
    "Vigilante",
    "Politsiya",
    "Team War",
    "Scav War",
    "Survivor"
}

local playerVisuals = {}
local playerCache = {}
local playerConnections = {}
local activeConnections = {}

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater = true

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Transparency = 0.7
fovCircle.Filled = false

local function trackConn(conn)
    activeConnections[#activeConnections + 1] = conn
    return conn
end

local function trimStr(s)
    return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function normalizeNameKey(s)
    local clean = trimStr(s):lower():gsub("%s+", " ")
    return clean
end

local function extractChoice(val, allowedMap, fallback)
    if type(val) == "string" then
        local trimmed = trimStr(val)
        if allowedMap[trimmed] then
            return trimmed
        end
        for k in pairs(allowedMap) do
            if k:lower() == trimmed:lower() then
                return k
            end
        end
    end
    if type(val) == "table" then
        for k, v in pairs(val) do
            if type(k) == "string" and v == true then
                local trimmed = trimStr(k)
                if allowedMap[trimmed] then
                    return trimmed
                end
            end
            if type(v) == "string" then
                local trimmed = trimStr(v)
                if allowedMap[trimmed] then
                    return trimmed
                end
            end
        end
    end
    return fallback
end

local function getAllConfigs()
    if not isfile or not readfile or not isfile(espConfigFile) then
        return {}
    end
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(readfile(espConfigFile))
    end)
    if ok and type(decoded) == "table" then
        return decoded
    end
    return {}
end

local function writeAllConfigs(allConfigs)
    if not writefile then
        return false
    end
    local ok = pcall(function()
        writefile(espConfigFile, HttpService:JSONEncode(allConfigs))
    end)
    return ok
end

local function saveEspConfig(slotName)
    local cleanName = trimStr(slotName)
    if cleanName == "" then
        cleanName = "Default"
    end
    local allConfigs = getAllConfigs()
    allConfigs[cleanName] = {
        esp = HttpService:JSONDecode(HttpService:JSONEncode(espSettings)),
        aimbot = {
            Enabled = aimbotConfig.Enabled,
            TargetPart = aimbotConfig.TargetPart,
            FOV = aimbotConfig.FOV,
            ShowFOV = aimbotConfig.ShowFOV
        }
    }
    return writeAllConfigs(allConfigs), cleanName
end

local function loadEspConfig(slotName)
    local allConfigs = getAllConfigs()
    local entry = allConfigs[slotName]
    if not entry or type(entry) ~= "table" then
        return false
    end
    if type(entry.esp) == "table" then
        for k, v in pairs(entry.esp) do
            if espSettings[k] ~= nil then
                espSettings[k] = v
            end
        end
    end
    if type(entry.aimbot) == "table" then
        for k, v in pairs(entry.aimbot) do
            if aimbotConfig[k] ~= nil then
                aimbotConfig[k] = v
            end
        end
    end
    espSettings.NametagMode = extractChoice(espSettings.NametagMode, validTagModes, "Role")
    espSettings.ColorMode = extractChoice(espSettings.ColorMode, validColorModes, "Role")
    return true
end

local function deleteEspConfig(slotName)
    local allConfigs = getAllConfigs()
    if not allConfigs[slotName] then
        return false
    end
    allConfigs[slotName] = nil
    return writeAllConfigs(allConfigs)
end

local function newLine(thickness, color, transparency)
    local line = Drawing.new("Line")
    line.Thickness = thickness or 1.6
    line.Color = color or Color3.fromRGB(255, 255, 255)
    line.Transparency = transparency or 1
    line.Visible = false
    return line
end

local function newSquare(thickness, color, transparency, filled)
    local sq = Drawing.new("Square")
    sq.Thickness = thickness or 1
    sq.Color = color or Color3.fromRGB(255, 255, 255)
    sq.Transparency = transparency or 1
    sq.Filled = filled or false
    sq.Visible = false
    return sq
end

local function newText(size, color, center, outline)
    local txt = Drawing.new("Text")
    txt.Size = size or 13
    txt.Color = color or Color3.fromRGB(255, 255, 255)
    txt.Center = center ~= false
    txt.Outline = outline ~= false
    txt.OutlineColor = Color3.fromRGB(0, 0, 0)
    txt.Font = Drawing.Fonts.Plex
    txt.Visible = false
    return txt
end

local function updateHighlight(vis, char, color, enabled)
    local hl = vis.highlight
    if not enabled or not char then
        if hl then
            hl.Enabled = false
            hl.Adornee = nil
        end
        return
    end

    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "EspSubtleHighlight"
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        vis.highlight = hl
    end

    if hl.Adornee ~= char then
        hl.Adornee = char
        hl.Parent = char
    end
    hl.FillColor = color
    hl.OutlineColor = color
    hl.FillTransparency = 0.85
    hl.OutlineTransparency = 0.35
    hl.Enabled = true
end

local function getOrCreateVisuals(player)
    local existing = playerVisuals[player]
    if existing then
        return existing
    end

    local headCircle = Drawing.new("Circle")
    headCircle.Thickness = espSettings.SkeletonThickness
    headCircle.NumSides = 16
    headCircle.Filled = false
    headCircle.Visible = false

    local vis = {
        visible = false,
        boxOutline = newSquare(espSettings.BoxThickness + 1.8, boxOutlineColor, 0.8, false),
        box = newSquare(espSettings.BoxThickness, Color3.fromRGB(255, 255, 255), 0.9, false),
        hpOutline = newSquare(1, boxOutlineColor, 0.85, true),
        hpFill = newSquare(1, Color3.fromRGB(0, 230, 90), 0.9, true),
        hpText = newText(11, Color3.fromRGB(255, 255, 255), false, true),
        nameText = newText(espSettings.NametagSize, Color3.fromRGB(255, 255, 255), true, true),
        distText = newText(11, distTextColor, true, true),
        equippedText = newText(espSettings.InventorySize, equippedTextColor, true, true),
        invText = newText(espSettings.InventorySize, invTextColor, true, true),
        headCircle = headCircle,
        neckToHip = newLine(),
        leftArmUpper = newLine(),
        leftArmLower = newLine(),
        rightArmUpper = newLine(),
        rightArmLower = newLine(),
        leftLegUpper = newLine(),
        leftLegLower = newLine(),
        rightLegUpper = newLine(),
        rightLegLower = newLine(),
        highlight = nil
    }

    playerVisuals[player] = vis
    return vis
end

local function hideVisuals(vis)
    if not vis or not vis.visible then
        if vis and vis.highlight and vis.highlight.Enabled then
            vis.highlight.Enabled = false
            vis.highlight.Adornee = nil
        end
        return
    end
    vis.visible = false
    vis.boxOutline.Visible = false
    vis.box.Visible = false
    vis.hpOutline.Visible = false
    vis.hpFill.Visible = false
    vis.hpText.Visible = false
    vis.nameText.Visible = false
    vis.distText.Visible = false
    vis.equippedText.Visible = false
    vis.invText.Visible = false
    vis.headCircle.Visible = false
    vis.neckToHip.Visible = false
    vis.leftArmUpper.Visible = false
    vis.leftArmLower.Visible = false
    vis.rightArmUpper.Visible = false
    vis.rightArmLower.Visible = false
    vis.leftLegUpper.Visible = false
    vis.leftLegLower.Visible = false
    vis.rightLegUpper.Visible = false
    vis.rightLegLower.Visible = false
    if vis.highlight then
        vis.highlight.Enabled = false
        vis.highlight.Adornee = nil
    end
end

local function clearPlayerConnections(player)
    local conns = playerConnections[player]
    if conns then
        for _, c in ipairs(conns) do
            c:Disconnect()
        end
        playerConnections[player] = nil
    end
end

local function destroyVisuals(player)
    clearPlayerConnections(player)
    local vis = playerVisuals[player]
    if not vis then
        playerCache[player] = nil
        return
    end
    vis.visible = true
    hideVisuals(vis)
    vis.boxOutline:Remove()
    vis.box:Remove()
    vis.hpOutline:Remove()
    vis.hpFill:Remove()
    vis.hpText:Remove()
    vis.nameText:Remove()
    vis.distText:Remove()
    vis.equippedText:Remove()
    vis.invText:Remove()
    vis.headCircle:Remove()
    vis.neckToHip:Remove()
    vis.leftArmUpper:Remove()
    vis.leftArmLower:Remove()
    vis.rightArmUpper:Remove()
    vis.rightArmLower:Remove()
    vis.leftLegUpper:Remove()
    vis.leftLegLower:Remove()
    vis.rightLegUpper:Remove()
    vis.rightLegLower:Remove()
    if vis.highlight then
        vis.highlight:Destroy()
        vis.highlight = nil
    end
    playerVisuals[player] = nil
    playerCache[player] = nil
end

local function splitRoles(roleStr)
    local result = {}
    for part in string.gmatch(roleStr, "[^/]+") do
        result[#result + 1] = trimStr(part)
    end
    return result
end

local function lookupWeaponRole(toolName)
    local upper = toolName:upper()
    if upper:find("BEAGLE", 1, true) then
        return "Vigilante"
    end
    if upper:find("SHIELD", 1, true) then
        return "Vigilante"
    end

    local exact = weaponRoles[toolName]
    if exact then
        return exact
    end

    local stripped = trimStr(toolName:gsub("%s*%b()", ""):gsub("%s*%-?%s*%d+%s*[Ww]ins?", ""))
    return weaponRoles[stripped]
end

local function isToolWeapon(tool)
    if not tool or not tool:IsA("Tool") then
        return false
    end
    if neutralGear[tool.Name] then
        return false
    end
    if lookupWeaponRole(tool.Name) ~= nil then
        return true
    end
    if tool:FindFirstChild("GUNCHECK")
        or tool:FindFirstChild("ammoModel")
        or tool:FindFirstChild("conf") then
        return true
    end
    return false
end

local function formatToolLabel(tool, equipped)
    local isGun = isToolWeapon(tool)
    local mapped = lookupWeaponRole(tool.Name) ~= nil
    local base = (isGun and not mapped) and ("[GUN] " .. tool.Name) or tool.Name
    if equipped then
        return "[" .. base .. "]"
    end
    return base
end

local function resolveRole(toolEntries)
    local detected = {}
    local hasUnmappedGun = false

    for _, entry in ipairs(toolEntries) do
        local roleEntry = lookupWeaponRole(entry.name)
        if roleEntry then
            for _, role in ipairs(splitRoles(roleEntry)) do
                detected[role] = true
            end
        elseif entry.isGun then
            hasUnmappedGun = true
        end
    end

    for _, priorityRole in ipairs(rolePriority) do
        if detected[priorityRole] then
            return priorityRole
        end
    end

    if hasUnmappedGun then
        return "Killer"
    end

    return "Innocent"
end

local function isAlive(character)
    if not character then
        return false
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    return humanoid ~= nil and humanoid.Health > 0
end

local function findClosestTarget()
    local bestPlayer = nil
    local closestDist = aimbotConfig.FOV
    local camera = Workspace.CurrentCamera
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)

    for player, meta in pairs(playerCache) do
        local char = meta.char
        local hum = meta.humanoid
        if char and char.Parent and hum and hum.Health > 0 then
            local aimPart = (aimbotConfig.TargetPart == "Head" and meta.head)
                or (aimbotConfig.TargetPart == "UpperTorso" and (meta.upperTorso or meta.torso))
                or (aimbotConfig.TargetPart == "HumanoidRootPart" and meta.root)
                or char:FindFirstChild(aimbotConfig.TargetPart)
            if aimPart then
                local screenPos, visible = camera:WorldToViewportPoint(aimPart.Position)
                if visible then
                    local dx = screenPos.X - mousePos.X
                    local dy = screenPos.Y - mousePos.Y
                    local dist = math.sqrt(dx * dx + dy * dy)
                    if dist < closestDist then
                        closestDist = dist
                        bestPlayer = player
                    end
                end
            end
        end
    end

    return bestPlayer
end

local function readNameFromContainer(container, player)
    if not container then
        return nil
    end

    local attrKeys = {"CharacterName", "CharName", "NPCName", "FullName", "Identity", "Name"}
    for _, key in ipairs(attrKeys) do
        local attrVal = container:GetAttribute(key)
        if type(attrVal) == "string" and trimStr(attrVal) ~= "" then
            return trimStr(attrVal)
        end
    end

    for _, child in ipairs(container:GetDescendants()) do
        if child:IsA("StringValue") then
            local lname = child.Name:lower()
            if lname:find("name", 1, true) and not lname:find("user", 1, true) and trimStr(child.Value) ~= "" then
                return trimStr(child.Value)
            end
        elseif child:IsA("TextLabel") then
            local txt = trimStr(child.Text)
            if txt ~= "" and txt ~= player.Name and txt ~= player.DisplayName and not txt:match("^%[.*%]$") then
                local lname = child.Name:lower()
                if lname:find("name", 1, true) or lname:find("char", 1, true) or lname:find("title", 1, true) then
                    return txt
                end
            end
        end
    end

    local humanoid = container:FindFirstChildOfClass("Humanoid")
    if humanoid and trimStr(humanoid.DisplayName) ~= "" and humanoid.DisplayName ~= player.Name then
        return trimStr(humanoid.DisplayName)
    end

    return nil
end

local function getCharacterName(player, char)
    if not NPCSFolder or not NPCSFolder.Parent then
        NPCSFolder = Workspace:FindFirstChild("NPCSFolder")
    end

    if NPCSFolder then
        local npcEntry = NPCSFolder:FindFirstChild(player.Name)
        if not npcEntry then
            for _, desc in ipairs(NPCSFolder:GetDescendants()) do
                if desc:IsA("StringValue") and desc.Value == player.Name then
                    npcEntry = desc.Parent
                    break
                elseif desc:GetAttribute("UserId") == player.UserId or desc:GetAttribute("PlayerName") == player.Name then
                    npcEntry = desc
                    break
                end
            end
        end
        local fromNpc = readNameFromContainer(npcEntry, player)
        if fromNpc then
            return fromNpc
        end
    end

    local fromChar = readNameFromContainer(char, player)
    if fromChar then
        return fromChar
    end

    if trimStr(player.DisplayName) ~= "" and player.DisplayName ~= player.Name then
        return trimStr(player.DisplayName)
    end

    return nil
end

local function isDarkRedTarget(player, meta)
    if not espSettings.DarkRedPriority then
        return false
    end

    local candidates = {}
    if meta then
        if meta.charName then candidates[#candidates + 1] = meta.charName end
        if meta.char then
            local hum = meta.humanoid or meta.char:FindFirstChildOfClass("Humanoid")
            if hum and hum.DisplayName then
                candidates[#candidates + 1] = hum.DisplayName
            end
            local charAttr = meta.char:GetAttribute("CharacterName") or meta.char:GetAttribute("CharName") or meta.char:GetAttribute("NPCName")
            if type(charAttr) == "string" then
                candidates[#candidates + 1] = charAttr
            end
        end
    end
    if player.DisplayName then candidates[#candidates + 1] = player.DisplayName end
    if player.Name then candidates[#candidates + 1] = player.Name end

    for _, raw in ipairs(candidates) do
        local key = normalizeNameKey(raw)
        if darkRedTargets[key] then
            return true
        end
    end

    return false
end

local function gatherTools(player, char)
    local entries = {}
    local equipped = nil
    local list = {}

    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") then
                local isGun = isToolWeapon(item)
                entries[#entries + 1] = {name = item.Name, isGun = isGun}
                equipped = formatToolLabel(item, true)
                list[#list + 1] = equipped
            end
        end
    end

    local backpack = player:FindFirstChildOfClass("Backpack")
    if backpack and not espSettings.EquippedOnly then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local isGun = isToolWeapon(item)
                entries[#entries + 1] = {name = item.Name, isGun = isGun}
                list[#list + 1] = formatToolLabel(item, false)
            end
        end
    end

    return entries, equipped, list
end

local function updatePlayerToolsOnly(player)
    local meta = playerCache[player]
    if not meta then
        return
    end
    local char = player.Character
    if not char then
        return
    end
    local toolEntries, equipped, invList = gatherTools(player, char)
    meta.role = resolveRole(toolEntries)
    meta.charName = getCharacterName(player, char) or meta.charName
    meta.equipped = equipped
    meta.invText = (#invList > 0) and table.concat(invList, " | ") or "[Empty]"
end

local function rebuildPlayerCache(player)
    if player.UserId == lpUserId or espBlockList[player.Name] then
        return
    end
    local char = player.Character
    if not char then
        playerCache[player] = nil
        return
    end

    local toolEntries, equipped, invList = gatherTools(player, char)
    local role = resolveRole(toolEntries)
    local charName = getCharacterName(player, char)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    local head = char:FindFirstChild("Head")
    local upperTorso = char:FindFirstChild("UpperTorso")
    local lowerTorso = char:FindFirstChild("LowerTorso")
    local torso = char:FindFirstChild("Torso")

    local prev = playerCache[player]
    playerCache[player] = {
        char = char,
        role = role,
        equipped = equipped,
        invText = (#invList > 0) and table.concat(invList, " | ") or "[Empty]",
        charName = charName,
        humanoid = humanoid,
        root = root,
        head = head,
        upperTorso = upperTorso,
        lowerTorso = lowerTorso,
        torso = torso,
        leftUpperArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm"),
        leftLowerArm = char:FindFirstChild("LeftLowerArm"),
        leftHand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm"),
        rightUpperArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm"),
        rightLowerArm = char:FindFirstChild("RightLowerArm"),
        rightHand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm"),
        leftUpperLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg"),
        leftLowerLeg = char:FindFirstChild("LeftLowerLeg"),
        leftFoot = char:FindFirstChild("LeftFoot") or char:FindFirstChild("Left Leg"),
        rightUpperLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg"),
        rightLowerLeg = char:FindFirstChild("RightLowerLeg"),
        rightFoot = char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg"),
        visible = prev and prev.visible or false,
        onScreen = false
    }
end

local function hookPlayer(player)
    if player.UserId == lpUserId or espBlockList[player.Name] then
        return
    end
    clearPlayerConnections(player)

    local conns = {}
    playerConnections[player] = conns

    local function bindCharacter(char)
        if not char then
            return
        end
        rebuildPlayerCache(player)
        task.delay(0.25, function()
            if player.Parent and player.Character == char then
                rebuildPlayerCache(player)
            end
        end)
        task.delay(1.0, function()
            if player.Parent and player.Character == char then
                rebuildPlayerCache(player)
            end
        end)
        conns[#conns + 1] = char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                updatePlayerToolsOnly(player)
            elseif child:IsA("BasePart") or child:IsA("Humanoid") or child:IsA("StringValue") or child:IsA("BillboardGui") then
                rebuildPlayerCache(player)
            end
        end)
        conns[#conns + 1] = char.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") then
                updatePlayerToolsOnly(player)
            end
        end)
    end

    local function bindBackpack(bp)
        if not bp or not bp:IsA("Backpack") then
            return
        end
        conns[#conns + 1] = bp.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                updatePlayerToolsOnly(player)
            end
        end)
        conns[#conns + 1] = bp.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") then
                updatePlayerToolsOnly(player)
            end
        end)
    end

    conns[#conns + 1] = player.CharacterAdded:Connect(bindCharacter)
    conns[#conns + 1] = player:GetPropertyChangedSignal("DisplayName"):Connect(function()
        rebuildPlayerCache(player)
    end)
    conns[#conns + 1] = player.ChildAdded:Connect(function(child)
        if child:IsA("Backpack") then
            bindBackpack(child)
        end
    end)

    if player.Character then
        bindCharacter(player.Character)
    end
    local bp = player:FindFirstChildOfClass("Backpack")
    if bp then
        bindBackpack(bp)
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    hookPlayer(player)
end

trackConn(Players.PlayerAdded:Connect(hookPlayer))
trackConn(Players.PlayerRemoving:Connect(destroyVisuals))

local function refreshAllPlayersMetadata()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.UserId ~= lpUserId and not espBlockList[player.Name] then
            if playerCache[player] and playerCache[player].char == player.Character then
                updatePlayerToolsOnly(player)
            else
                rebuildPlayerCache(player)
            end
        end
    end
end

local function rayHitsPoint(origin, targetPos, enemyChar)
    local delta = targetPos - origin
    local dist = delta.Magnitude
    if dist < 0.1 then
        return true
    end

    local result = Workspace:Raycast(origin, delta.Unit * (dist + 0.25), rayParams)
    if not result or not result.Instance then
        return false
    end
    return enemyChar ~= nil and result.Instance:IsDescendantOf(enemyChar)
end

local function checkCharacterVisibility(origin, head, root, neckPart, enemyChar)
    if head and rayHitsPoint(origin, head.Position, enemyChar) then
        return true
    end
    if neckPart then
        local rightVec = neckPart.CFrame.RightVector * 0.65
        if rayHitsPoint(origin, neckPart.Position, enemyChar)
            or rayHitsPoint(origin, neckPart.Position + rightVec, enemyChar)
            or rayHitsPoint(origin, neckPart.Position - rightVec, enemyChar) then
            return true
        end
    end
    if root and rayHitsPoint(origin, root.Position, enemyChar) then
        return true
    end
    return false
end

local function refreshVisibility(camera, now)
    if (now - lastVisRefresh) < visRefreshInterval then
        return
    end
    lastVisRefresh = now

    local filterList = {}
    if lp.Character then
        filterList[#filterList + 1] = lp.Character
    end
    if BloodFolder then
        filterList[#filterList + 1] = BloodFolder
    end
    if NPCSFolder then
        filterList[#filterList + 1] = NPCSFolder
    end
    if camera then
        filterList[#filterList + 1] = camera
    end
    rayParams.FilterDescendantsInstances = filterList

    local origin = camera.CFrame.Position
    for player, meta in pairs(playerCache) do
        local char = meta.char
        local hum = meta.humanoid
        if meta.onScreen and char and char.Parent and hum and hum.Health > 0 and meta.root and meta.head then
            local neckPart = meta.upperTorso or meta.torso or meta.root
            meta.visible = checkCharacterVisibility(origin, meta.head, meta.root, neckPart, char)
        else
            meta.visible = false
        end
    end
end

local function rgbFromConfig(arr, fallback)
    if type(arr) == "table" then
        return Color3.fromRGB(arr[1] or fallback[1], arr[2] or fallback[2], arr[3] or fallback[3])
    end
    return Color3.fromRGB(fallback[1], fallback[2], fallback[3])
end

local function darkenColor(col, factor)
    local scale = math.clamp(factor or 0.5, 0.1, 0.95)
    return Color3.new(col.R * scale, col.G * scale, col.B * scale)
end

local function getPlayerColor(player, meta, visible)
    local baseColor
    if isDarkRedTarget(player, meta) then
        baseColor = darkRedColor
    elseif espSettings.ColorMode == "Custom" then
        baseColor = rgbFromConfig(espSettings.CustomColor, {255, 255, 255})
    else
        local roleName = meta and meta.role or "Innocent"
        local style = roleStyle[roleName] or roleStyle["Innocent"]
        baseColor = style.color
    end

    if visible then
        return baseColor
    end
    return darkenColor(baseColor, espSettings.BlockedShade)
end

local function getBaseLabel(player, meta)
    local mode = extractChoice(espSettings.NametagMode, validTagModes, "Role")
    espSettings.NametagMode = mode

    if mode == "Username" then
        return player.Name
    elseif mode == "Character Name" then
        local resolved = (meta and meta.charName) or getCharacterName(player, meta and meta.char)
        if resolved and trimStr(resolved) ~= "" then
            return trimStr(resolved)
        end
        return (trimStr(player.DisplayName) ~= "" and trimStr(player.DisplayName)) or player.Name
    end

    local roleName = (meta and meta.role) or "Innocent"
    local style = roleStyle[roleName] or roleStyle["Innocent"]
    return style.label
end

local function getDistanceText(studs)
    if espSettings.DistanceUnit == "Meters" then
        return string.format("%.0fm", studs * 0.28)
    end
    return string.format("%.0fst", studs)
end

local function getCharacterBounds(meta, camera, camPos)
    local root = meta.root
    local head = meta.head
    if not root or not head then
        return nil
    end

    local distance = (root.Position - camPos).Magnitude
    if distance > espSettings.MaxDistance then
        return nil
    end

    local rootPos, onScreen = camera:WorldToViewportPoint(root.Position)
    if not onScreen or rootPos.Z <= 0 then
        return nil
    end

    local topWorld = head.Position + Vector3.new(0, head.Size.Y * 0.5 + 0.35, 0)
    local bottomWorld = root.Position - Vector3.new(0, 3.1, 0)

    local topScreen = camera:WorldToViewportPoint(topWorld)
    local bottomScreen = camera:WorldToViewportPoint(bottomWorld)

    local height = math.abs(bottomScreen.Y - topScreen.Y)
    if height < 4 then
        return nil
    end

    local width = height * espSettings.BoxWidthScale
    local centerX = rootPos.X
    local topY = topScreen.Y

    return {
        left = centerX - width * 0.5,
        right = centerX + width * 0.5,
        top = topY,
        bottom = topY + height,
        width = width,
        height = height,
        distance = distance
    }
end

local function styleStickLine(line, p1, p2, color, thickness, opacity)
    if not p1 or not p2 then
        line.Visible = false
        return
    end
    line.From = Vector2.new(p1.X, p1.Y)
    line.To = Vector2.new(p2.X, p2.Y)
    line.Color = color
    line.Thickness = thickness
    line.Transparency = opacity
    line.Visible = true
end

local function projectPoint(camera, worldPos)
    local scr, vis = camera:WorldToViewportPoint(worldPos)
    if vis and scr.Z > 0 then
        return scr
    end
    return nil
end

local function drawLimbChain(camera, upperLine, lowerLine, points, color, thickness, opacity)
    if #points < 2 then
        upperLine.Visible = false
        lowerLine.Visible = false
        return
    end

    local p1 = projectPoint(camera, points[1])
    local p2 = projectPoint(camera, points[2])

    if #points >= 3 then
        local p3 = projectPoint(camera, points[3])
        styleStickLine(upperLine, p1, p2, color, thickness, opacity)
        styleStickLine(lowerLine, p2, p3, color, thickness, opacity)
    else
        styleStickLine(upperLine, p1, p2, color, thickness, opacity)
        lowerLine.Visible = false
    end
end

local function getArmPoints(upperPart, lowerPart, handPart, shoulderAnchor, isLeft)
    local pts = {}
    if shoulderAnchor then
        pts[#pts + 1] = shoulderAnchor
    elseif upperPart then
        local upVec = upperPart.CFrame.UpVector
        pts[#pts + 1] = upperPart.Position + upVec * (upperPart.Size.Y * 0.4)
    end

    if upperPart and lowerPart and handPart then
        pts[#pts + 1] = upperPart.Position:Lerp(lowerPart.Position, 0.5)
        pts[#pts + 1] = handPart.Position
    elseif upperPart and handPart and upperPart ~= handPart then
        local cf = upperPart.CFrame
        local sideOffset = cf.RightVector * (isLeft and -0.18 or 0.18)
        pts[#pts + 1] = upperPart.Position:Lerp(handPart.Position, 0.5) + sideOffset
        pts[#pts + 1] = handPart.Position
    elseif upperPart then
        local cf = upperPart.CFrame
        pts[#pts + 1] = cf.Position - cf.UpVector * (upperPart.Size.Y * 0.45)
    end

    return pts
end

local function getLegPoints(upperPart, lowerPart, footPart, hipAnchor, isLeft)
    local pts = {}
    if hipAnchor then
        pts[#pts + 1] = hipAnchor
    elseif upperPart then
        local cf = upperPart.CFrame
        pts[#pts + 1] = cf.Position + cf.UpVector * (upperPart.Size.Y * 0.4)
    end

    if upperPart and lowerPart and footPart then
        pts[#pts + 1] = upperPart.Position:Lerp(lowerPart.Position, 0.5)
        pts[#pts + 1] = footPart.Position - footPart.CFrame.UpVector * (footPart.Size.Y * 0.35)
    elseif upperPart and footPart and upperPart ~= footPart then
        local cf = upperPart.CFrame
        local fwd = cf.LookVector * 0.14 + cf.RightVector * (isLeft and -0.06 or 0.06)
        pts[#pts + 1] = upperPart.Position:Lerp(footPart.Position, 0.52) + fwd
        pts[#pts + 1] = footPart.Position - footPart.CFrame.UpVector * (footPart.Size.Y * 0.35)
    elseif upperPart then
        local cf = upperPart.CFrame
        pts[#pts + 1] = cf.Position - cf.UpVector * (upperPart.Size.Y * 0.48)
    end

    return pts
end

local function updateStickSkeleton(meta, camera, color, vis, bounds)
    local thickness = espSettings.SkeletonThickness
    local opacity = espSettings.FillOpacity

    local head = meta.head
    local neckPart = meta.upperTorso or meta.torso or meta.root
    local hipPart = meta.lowerTorso or meta.torso or meta.root

    if head then
        local headScr = projectPoint(camera, head.Position)
        if headScr then
            vis.headCircle.Position = Vector2.new(headScr.X, headScr.Y)
            vis.headCircle.Radius = math.clamp(bounds.height * 0.082, 3, 26)
            vis.headCircle.Color = color
            vis.headCircle.Thickness = thickness
            vis.headCircle.Transparency = opacity
            vis.headCircle.Visible = true
        else
            vis.headCircle.Visible = false
        end
    else
        vis.headCircle.Visible = false
    end

    if neckPart and hipPart then
        local neckPos = neckPart.Position + neckPart.CFrame.UpVector * (neckPart.Size.Y * 0.42)
        local hipPos = hipPart.Position - hipPart.CFrame.UpVector * (hipPart.Size.Y * 0.35)
        local nScr = projectPoint(camera, neckPos)
        local hScr = projectPoint(camera, hipPos)

        if nScr and hScr then
            styleStickLine(vis.neckToHip, nScr, hScr, color, thickness, opacity)

            local torsoRight = neckPart.CFrame.RightVector
            local torsoUp = neckPart.CFrame.UpVector
            local shoulderY = neckPart.Position + torsoUp * (neckPart.Size.Y * 0.28)
            local lShoulderAnchor = shoulderY - torsoRight * (neckPart.Size.X * 0.55)
            local rShoulderAnchor = shoulderY + torsoRight * (neckPart.Size.X * 0.55)

            local lArmPts = getArmPoints(meta.leftUpperArm, meta.leftLowerArm, meta.leftHand, lShoulderAnchor, true)
            drawLimbChain(camera, vis.leftArmUpper, vis.leftArmLower, lArmPts, color, thickness, opacity)

            local rArmPts = getArmPoints(meta.rightUpperArm, meta.rightLowerArm, meta.rightHand, rShoulderAnchor, false)
            drawLimbChain(camera, vis.rightArmUpper, vis.rightArmLower, rArmPts, color, thickness, opacity)

            local hipRight = hipPart.CFrame.RightVector
            local lHipAnchor = hipPos - hipRight * (hipPart.Size.X * 0.28)
            local rHipAnchor = hipPos + hipRight * (hipPart.Size.X * 0.28)

            local lLegPts = getLegPoints(meta.leftUpperLeg, meta.leftLowerLeg, meta.leftFoot, lHipAnchor, true)
            drawLimbChain(camera, vis.leftLegUpper, vis.leftLegLower, lLegPts, color, thickness, opacity)

            local rLegPts = getLegPoints(meta.rightUpperLeg, meta.rightLowerLeg, meta.rightFoot, rHipAnchor, false)
            drawLimbChain(camera, vis.rightLegUpper, vis.rightLegLower, rLegPts, color, thickness, opacity)
            return
        end
    end

    vis.neckToHip.Visible = false
    vis.leftArmUpper.Visible = false
    vis.leftArmLower.Visible = false
    vis.rightArmUpper.Visible = false
    vis.rightArmLower.Visible = false
    vis.leftLegUpper.Visible = false
    vis.leftLegLower.Visible = false
    vis.rightLegUpper.Visible = false
    vis.rightLegLower.Visible = false
end

local function updateEspVisuals(camera, now)
    if not espSettings.Enabled then
        for _, vis in pairs(playerVisuals) do
            hideVisuals(vis)
        end
        return
    end

    local camPos = camera.CFrame.Position
    local opacity = espSettings.FillOpacity
    local outlineOpacity = math.clamp(opacity * 0.9, 0.1, 1)

    for player, meta in pairs(playerCache) do
        local vis = getOrCreateVisuals(player)
        local char = meta.char
        local hum = meta.humanoid

        if not player.Parent or not char or not char.Parent or not hum or hum.Health <= 0 then
            meta.onScreen = false
            hideVisuals(vis)
        else
            local bounds = getCharacterBounds(meta, camera, camPos)
            if not bounds then
                meta.onScreen = false
                hideVisuals(vis)
                if espSettings.Highlight then
                    local color = getPlayerColor(player, meta, false)
                    updateHighlight(vis, char, color, true)
                end
            else
                meta.onScreen = true
                vis.visible = true

                local color = getPlayerColor(player, meta, meta.visible)
                updateHighlight(vis, char, color, espSettings.Highlight)

                if espSettings.Box then
                    if espSettings.BoxOutline then
                        vis.boxOutline.Position = Vector2.new(bounds.left - 1, bounds.top - 1)
                        vis.boxOutline.Size = Vector2.new(bounds.width + 2, bounds.height + 2)
                        vis.boxOutline.Thickness = espSettings.BoxThickness + 1.8
                        vis.boxOutline.Transparency = outlineOpacity
                        vis.boxOutline.Visible = true
                    else
                        vis.boxOutline.Visible = false
                    end

                    vis.box.Position = Vector2.new(bounds.left, bounds.top)
                    vis.box.Size = Vector2.new(bounds.width, bounds.height)
                    vis.box.Color = color
                    vis.box.Thickness = espSettings.BoxThickness
                    vis.box.Transparency = opacity
                    vis.box.Visible = true
                else
                    vis.boxOutline.Visible = false
                    vis.box.Visible = false
                end

                if espSettings.HealthBar then
                    local maxHp = math.max(hum.MaxHealth, 1)
                    local ratio = math.clamp(hum.Health / maxHp, 0, 1)
                    local barW = espSettings.HealthBarWidth
                    local barX = espSettings.HealthBarSide == "Right"
                        and (bounds.right + 3)
                        or (bounds.left - barW - 3)
                    local fillH = bounds.height * ratio
                    local fillY = bounds.bottom - fillH

                    vis.hpOutline.Position = Vector2.new(barX - 1, bounds.top - 1)
                    vis.hpOutline.Size = Vector2.new(barW + 2, bounds.height + 2)
                    vis.hpOutline.Transparency = outlineOpacity
                    vis.hpOutline.Visible = true

                    vis.hpFill.Position = Vector2.new(barX, fillY)
                    vis.hpFill.Size = Vector2.new(barW, math.max(fillH, 1))
                    vis.hpFill.Color = Color3.fromRGB(
                        math.floor(255 * (1 - ratio)),
                        math.floor(220 * ratio),
                        40
                    )
                    vis.hpFill.Transparency = opacity
                    vis.hpFill.Visible = true

                    if espSettings.HealthText and not espSettings.CompactCqb and ratio < 0.99 then
                        vis.hpText.Text = tostring(math.floor(hum.Health))
                        vis.hpText.Position = espSettings.HealthBarSide == "Right"
                            and Vector2.new(barX + barW + 4, fillY - 6)
                            or Vector2.new(barX - 26, fillY - 6)
                        vis.hpText.Transparency = opacity
                        vis.hpText.Visible = true
                    else
                        vis.hpText.Visible = false
                    end
                else
                    vis.hpOutline.Visible = false
                    vis.hpFill.Visible = false
                    vis.hpText.Visible = false
                end

                if espSettings.Skeleton then
                    updateStickSkeleton(meta, camera, color, vis, bounds)
                else
                    vis.headCircle.Visible = false
                    vis.neckToHip.Visible = false
                    vis.leftArmUpper.Visible = false
                    vis.leftArmLower.Visible = false
                    vis.rightArmUpper.Visible = false
                    vis.rightArmLower.Visible = false
                    vis.leftLegUpper.Visible = false
                    vis.leftLegLower.Visible = false
                    vis.rightLegUpper.Visible = false
                    vis.rightLegLower.Visible = false
                end

                local centerX = (bounds.left + bounds.right) * 0.5
                local topCursorY = bounds.top - (espSettings.NametagSize + 3)

                if espSettings.CompactCqb then
                    if espSettings.Nametag then
                        local baseTxt = getBaseLabel(player, meta)
                        vis.nameText.Text = espSettings.DistanceEsp
                            and (baseTxt .. " [" .. getDistanceText(bounds.distance) .. "]")
                            or baseTxt
                        vis.nameText.Color = color
                        vis.nameText.Size = espSettings.NametagSize
                        vis.nameText.Position = Vector2.new(centerX, topCursorY)
                        vis.nameText.Transparency = opacity
                        vis.nameText.Visible = true
                    elseif espSettings.DistanceEsp then
                        vis.nameText.Text = "[" .. getDistanceText(bounds.distance) .. "]"
                        vis.nameText.Color = color
                        vis.nameText.Size = espSettings.NametagSize
                        vis.nameText.Position = Vector2.new(centerX, topCursorY)
                        vis.nameText.Transparency = opacity
                        vis.nameText.Visible = true
                    else
                        vis.nameText.Visible = false
                    end
                    vis.distText.Visible = false
                else
                    if espSettings.Nametag then
                        vis.nameText.Text = getBaseLabel(player, meta)
                        vis.nameText.Color = color
                        vis.nameText.Size = espSettings.NametagSize
                        vis.nameText.Position = Vector2.new(centerX, topCursorY)
                        vis.nameText.Transparency = opacity
                        vis.nameText.Visible = true
                        topCursorY = topCursorY - (espSettings.NametagSize + 1)
                    else
                        vis.nameText.Visible = false
                    end

                    if espSettings.DistanceEsp then
                        vis.distText.Text = getDistanceText(bounds.distance)
                        vis.distText.Position = Vector2.new(centerX, topCursorY)
                        vis.distText.Transparency = opacity
                        vis.distText.Visible = true
                    else
                        vis.distText.Visible = false
                    end
                end

                local nextY = bounds.bottom + 2

                if espSettings.InventoryEsp then
                    if meta.equipped then
                        vis.equippedText.Text = meta.equipped
                        vis.equippedText.Size = espSettings.InventorySize
                        vis.equippedText.Position = Vector2.new(centerX, nextY)
                        vis.equippedText.Transparency = opacity
                        vis.equippedText.Visible = true
                        nextY = nextY + espSettings.InventorySize + 2
                    else
                        vis.equippedText.Visible = false
                    end

                    if not espSettings.EquippedOnly and not espSettings.CompactCqb then
                        vis.invText.Text = meta.invText
                        vis.invText.Size = espSettings.InventorySize
                        vis.invText.Position = Vector2.new(centerX, nextY)
                        vis.invText.Transparency = opacity
                        vis.invText.Visible = true
                    else
                        vis.invText.Visible = false
                    end
                else
                    vis.equippedText.Visible = false
                    vis.invText.Visible = false
                end
            end
        end
    end

    refreshVisibility(camera, now)
end

local function teleportToDroppedGun()
    if not BloodFolder then
        BloodFolder = Workspace:FindFirstChild("BloodFolder")
    end
    if not BloodFolder or not lp.Character or not lp.Character.PrimaryPart then
        return
    end

    for _, item in ipairs(BloodFolder:GetChildren()) do
        if item:IsA("Tool") and (isToolWeapon(item) or neutralGear[item.Name]) then
            local handle = item:FindFirstChild("Handle")
            if handle then
                lp.Character:SetPrimaryPartCFrame(CFrame.new(handle.Position + Vector3.new(0, 5, 0)))
                break
            end
        end
    end
end

trackConn(RunService.RenderStepped:Connect(function()
    local now = os.clock()
    local camera = Workspace.CurrentCamera
    if not camera then
        return
    end

    if aimbotConfig.ShowFOV and aimbotConfig.Enabled then
        fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
        fovCircle.Radius = aimbotConfig.FOV
        fovCircle.Visible = true
    else
        fovCircle.Visible = false
    end

    if (now - lastEspRender) >= espRenderInterval then
        lastEspRender = now
        updateEspVisuals(camera, now)
    end

    local holdingAim = aimbotConfig.Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)

    if holdingAim then
        if not currentTarget or not isAlive(currentTarget.Character) then
            currentTarget = findClosestTarget()
        end

        if currentTarget and currentTarget.Character then
            local part = currentTarget.Character:FindFirstChild(aimbotConfig.TargetPart)
            if part then
                camera.CFrame = CFrame.new(camera.CFrame.Position, part.Position)
            else
                currentTarget = nil
            end
        end
    else
        currentTarget = nil
        if espSettings.NoRecoil then
            camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + camera.CFrame.LookVector)
        end
    end
end))

local Tabs = {
    ESP = Window:AddTab("ESP"),
    Combat = Window:AddTab("Combat"),
    Config = Window:AddTab("Config")
}

local MainLeft = Tabs.ESP:AddLeftGroupbox("Main & Tags")
local VisualLeft = Tabs.ESP:AddLeftGroupbox("Box & Skeleton")
local BarRight = Tabs.ESP:AddRightGroupbox("Health, Dist & Inventory")
local ColorRight = Tabs.ESP:AddRightGroupbox("Colors")

MainLeft:AddToggle("MasterEspToggle", {
    Text = "Enable ESP",
    Default = espSettings.Enabled,
    Callback = function(value)
        espSettings.Enabled = value
        if value then
            refreshAllPlayersMetadata()
        else
            for _, vis in pairs(playerVisuals) do
                hideVisuals(vis)
            end
        end
    end
})

MainLeft:AddToggle("CompactCqbToggle", {
    Text = "Compact CQB Mode",
    Default = espSettings.CompactCqb,
    Callback = function(value)
        espSettings.CompactCqb = value
    end
})

MainLeft:AddToggle("NametagToggle", {
    Text = "Show Nametag",
    Default = espSettings.Nametag,
    Callback = function(value)
        espSettings.Nametag = value
    end
})

MainLeft:AddDropdown("NametagModeDropdown", {
    Values = {"Role", "Character Name", "Username"},
    Default = 1,
    Multi = false,
    Text = "Tag Mode",
    Callback = function(value)
        if isSyncingUi then
            return
        end
        espSettings.NametagMode = extractChoice(value, validTagModes, espSettings.NametagMode)
        refreshAllPlayersMetadata()
    end
})

MainLeft:AddSlider("NametagSizeSlider", {
    Text = "Tag Text Size",
    Default = espSettings.NametagSize,
    Min = 10,
    Max = 24,
    Rounding = 0,
    Callback = function(value)
        espSettings.NametagSize = value
    end
})

MainLeft:AddSlider("MaxDistanceSlider", {
    Text = "Max Distance",
    Default = espSettings.MaxDistance,
    Min = 100,
    Max = 5000,
    Rounding = 0,
    Callback = function(value)
        espSettings.MaxDistance = value
    end
})

VisualLeft:AddToggle("BoxEspToggle", {
    Text = "Box ESP",
    Default = espSettings.Box,
    Callback = function(value)
        espSettings.Box = value
    end
})

VisualLeft:AddToggle("BoxOutlineToggle", {
    Text = "Box Outline",
    Default = espSettings.BoxOutline,
    Callback = function(value)
        espSettings.BoxOutline = value
    end
})

VisualLeft:AddSlider("BoxThicknessSlider", {
    Text = "Box Thickness",
    Default = espSettings.BoxThickness,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Callback = function(value)
        espSettings.BoxThickness = value
    end
})

VisualLeft:AddSlider("BoxWidthSlider", {
    Text = "Box Width Scale",
    Default = espSettings.BoxWidthScale,
    Min = 0.3,
    Max = 1.0,
    Rounding = 2,
    Callback = function(value)
        espSettings.BoxWidthScale = value
    end
})

VisualLeft:AddToggle("SkeletonToggle", {
    Text = "Stick Skeleton",
    Default = espSettings.Skeleton,
    Callback = function(value)
        espSettings.Skeleton = value
    end
})

VisualLeft:AddSlider("SkeletonThicknessSlider", {
    Text = "Skeleton Thickness",
    Default = espSettings.SkeletonThickness,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Callback = function(value)
        espSettings.SkeletonThickness = value
    end
})

VisualLeft:AddToggle("HighlightToggle", {
    Text = "Highlight ESP",
    Default = espSettings.Highlight,
    Callback = function(value)
        espSettings.Highlight = value
        if not value then
            for _, vis in pairs(playerVisuals) do
                updateHighlight(vis, nil, nil, false)
            end
        end
    end
})

BarRight:AddToggle("HealthBarToggle", {
    Text = "Vertical Health Bar",
    Default = espSettings.HealthBar,
    Callback = function(value)
        espSettings.HealthBar = value
    end
})

BarRight:AddDropdown("HealthSideDropdown", {
    Values = {"Left", "Right"},
    Default = 1,
    Multi = false,
    Text = "Health Bar Side",
    Callback = function(value)
        if isSyncingUi then
            return
        end
        espSettings.HealthBarSide = type(value) == "string" and value or espSettings.HealthBarSide
    end
})

BarRight:AddSlider("HealthWidthSlider", {
    Text = "Health Bar Width",
    Default = espSettings.HealthBarWidth,
    Min = 2,
    Max = 10,
    Rounding = 0,
    Callback = function(value)
        espSettings.HealthBarWidth = value
    end
})

BarRight:AddToggle("HealthTextToggle", {
    Text = "Health Number",
    Default = espSettings.HealthText,
    Callback = function(value)
        espSettings.HealthText = value
    end
})

BarRight:AddToggle("DistanceToggle", {
    Text = "Distance ESP",
    Default = espSettings.DistanceEsp,
    Callback = function(value)
        espSettings.DistanceEsp = value
    end
})

BarRight:AddDropdown("DistanceUnitDropdown", {
    Values = {"Studs", "Meters"},
    Default = 1,
    Multi = false,
    Text = "Distance Unit",
    Callback = function(value)
        if isSyncingUi then
            return
        end
        espSettings.DistanceUnit = type(value) == "string" and value or espSettings.DistanceUnit
    end
})

BarRight:AddToggle("InventoryToggle", {
    Text = "Inventory ESP",
    Default = espSettings.InventoryEsp,
    Callback = function(value)
        espSettings.InventoryEsp = value
    end
})

BarRight:AddToggle("EquippedOnlyToggle", {
    Text = "Equipped Tool Only",
    Default = espSettings.EquippedOnly,
    Callback = function(value)
        espSettings.EquippedOnly = value
        refreshAllPlayersMetadata()
    end
})

BarRight:AddSlider("InventorySizeSlider", {
    Text = "Inventory Text Size",
    Default = espSettings.InventorySize,
    Min = 9,
    Max = 20,
    Rounding = 0,
    Callback = function(value)
        espSettings.InventorySize = value
    end
})

ColorRight:AddDropdown("ColorModeDropdown", {
    Values = {"Role", "Custom"},
    Default = 1,
    Multi = false,
    Text = "Base Color Mode",
    Callback = function(value)
        if isSyncingUi then
            return
        end
        espSettings.ColorMode = extractChoice(value, validColorModes, espSettings.ColorMode)
    end
})

ColorRight:AddSlider("BlockedShadeSlider", {
    Text = "Blocked Shade",
    Default = espSettings.BlockedShade,
    Min = 0.2,
    Max = 0.95,
    Rounding = 2,
    Callback = function(value)
        espSettings.BlockedShade = value
    end
})

ColorRight:AddToggle("DarkRedToggle", {
    Text = "Dark Red Target Priority",
    Default = espSettings.DarkRedPriority,
    Callback = function(value)
        espSettings.DarkRedPriority = value
    end
})

ColorRight:AddSlider("OpacitySlider", {
    Text = "ESP Opacity",
    Default = espSettings.FillOpacity,
    Min = 0.1,
    Max = 1.0,
    Rounding = 2,
    Callback = function(value)
        espSettings.FillOpacity = value
    end
})

ColorRight:AddLabel("Custom Base Color"):AddColorPicker("CustomColorPicker", {
    Default = Color3.fromRGB(espSettings.CustomColor[1], espSettings.CustomColor[2], espSettings.CustomColor[3]),
    Title = "Custom Base Color",
    Callback = function(col)
        espSettings.CustomColor = {math.floor(col.R * 255), math.floor(col.G * 255), math.floor(col.B * 255)}
    end
})

local AimBox = Tabs.Combat:AddLeftGroupbox("Aimbot & Recoil")
local UtilityBox = Tabs.Combat:AddRightGroupbox("Utility")

AimBox:AddToggle("AimbotToggle", {
    Text = "Aimbot Enabled",
    Default = aimbotConfig.Enabled,
    Callback = function(value)
        aimbotConfig.Enabled = value
    end
})

AimBox:AddToggle("ShowFovToggle", {
    Text = "Show FOV Circle",
    Default = aimbotConfig.ShowFOV,
    Callback = function(value)
        aimbotConfig.ShowFOV = value
    end
})

AimBox:AddToggle("NoRecoilToggle", {
    Text = "No Recoil",
    Default = espSettings.NoRecoil,
    Callback = function(value)
        espSettings.NoRecoil = value
    end
})

AimBox:AddDropdown("AimPartDropdown", {
    Values = {"Head", "UpperTorso", "HumanoidRootPart"},
    Default = 1,
    Multi = false,
    Text = "Aim Part",
    Callback = function(value)
        if isSyncingUi then
            return
        end
        aimbotConfig.TargetPart = type(value) == "string" and value or aimbotConfig.TargetPart
    end
})

AimBox:AddSlider("FovRadiusSlider", {
    Text = "FOV Radius",
    Default = aimbotConfig.FOV,
    Min = 0,
    Max = 600,
    Rounding = 0,
    Callback = function(value)
        aimbotConfig.FOV = value
    end
})

UtilityBox:AddButton({
    Text = "Teleport to Dropped Gun",
    Func = teleportToDroppedGun
})

local EspSlotBox = Tabs.Config:AddLeftGroupbox("ESP Config Slots")
local MenuBox = Tabs.Config:AddRightGroupbox("Menu")

EspSlotBox:AddInput("EspSlotInput", {
    Default = configSlotName,
    Numeric = false,
    Finished = false,
    Text = "Config Slot Name",
    Callback = function(value)
        configSlotName = value
    end
})

local function syncLinoriaFromState()
    isSyncingUi = true
    if Toggles.MasterEspToggle then Toggles.MasterEspToggle:SetValue(espSettings.Enabled) end
    if Toggles.CompactCqbToggle then Toggles.CompactCqbToggle:SetValue(espSettings.CompactCqb) end
    if Toggles.BoxEspToggle then Toggles.BoxEspToggle:SetValue(espSettings.Box) end
    if Toggles.BoxOutlineToggle then Toggles.BoxOutlineToggle:SetValue(espSettings.BoxOutline) end
    if Options.BoxThicknessSlider then Options.BoxThicknessSlider:SetValue(espSettings.BoxThickness) end
    if Options.BoxWidthSlider then Options.BoxWidthSlider:SetValue(espSettings.BoxWidthScale) end
    if Toggles.SkeletonToggle then Toggles.SkeletonToggle:SetValue(espSettings.Skeleton) end
    if Options.SkeletonThicknessSlider then Options.SkeletonThicknessSlider:SetValue(espSettings.SkeletonThickness) end
    if Toggles.HighlightToggle then Toggles.HighlightToggle:SetValue(espSettings.Highlight) end
    if Toggles.HealthBarToggle then Toggles.HealthBarToggle:SetValue(espSettings.HealthBar) end
    if Options.HealthSideDropdown then Options.HealthSideDropdown:SetValue(espSettings.HealthBarSide) end
    if Options.HealthWidthSlider then Options.HealthWidthSlider:SetValue(espSettings.HealthBarWidth) end
    if Toggles.HealthTextToggle then Toggles.HealthTextToggle:SetValue(espSettings.HealthText) end
    if Toggles.NametagToggle then Toggles.NametagToggle:SetValue(espSettings.Nametag) end
    if Options.NametagModeDropdown then Options.NametagModeDropdown:SetValue(espSettings.NametagMode) end
    if Options.NametagSizeSlider then Options.NametagSizeSlider:SetValue(espSettings.NametagSize) end
    if Toggles.DistanceToggle then Toggles.DistanceToggle:SetValue(espSettings.DistanceEsp) end
    if Options.DistanceUnitDropdown then Options.DistanceUnitDropdown:SetValue(espSettings.DistanceUnit) end
    if Toggles.InventoryToggle then Toggles.InventoryToggle:SetValue(espSettings.InventoryEsp) end
    if Toggles.EquippedOnlyToggle then Toggles.EquippedOnlyToggle:SetValue(espSettings.EquippedOnly) end
    if Options.InventorySizeSlider then Options.InventorySizeSlider:SetValue(espSettings.InventorySize) end
    if Options.ColorModeDropdown then Options.ColorModeDropdown:SetValue(espSettings.ColorMode) end
    if Options.BlockedShadeSlider then Options.BlockedShadeSlider:SetValue(espSettings.BlockedShade) end
    if Toggles.DarkRedToggle then Toggles.DarkRedToggle:SetValue(espSettings.DarkRedPriority) end
    if Options.OpacitySlider then Options.OpacitySlider:SetValue(espSettings.FillOpacity) end
    if Options.MaxDistanceSlider then Options.MaxDistanceSlider:SetValue(espSettings.MaxDistance) end
    if Options.CustomColorPicker then
        Options.CustomColorPicker:SetValueRGB(Color3.fromRGB(espSettings.CustomColor[1], espSettings.CustomColor[2], espSettings.CustomColor[3]))
    end
    if Toggles.AimbotToggle then Toggles.AimbotToggle:SetValue(aimbotConfig.Enabled) end
    if Toggles.ShowFovToggle then Toggles.ShowFovToggle:SetValue(aimbotConfig.ShowFOV) end
    if Toggles.NoRecoilToggle then Toggles.NoRecoilToggle:SetValue(espSettings.NoRecoil) end
    if Options.AimPartDropdown then Options.AimPartDropdown:SetValue(aimbotConfig.TargetPart) end
    if Options.FovRadiusSlider then Options.FovRadiusSlider:SetValue(aimbotConfig.FOV) end
    isSyncingUi = false
end

EspSlotBox:AddButton({
    Text = "Save ESP Slot",
    Func = function()
        local ok, savedName = saveEspConfig(configSlotName)
        Library:Notify(ok and ("Saved \"" .. savedName .. "\"") or "File saving unavailable")
    end
})

EspSlotBox:AddButton({
    Text = "Load ESP Slot",
    Func = function()
        local cleanName = trimStr(configSlotName)
        if cleanName == "" then
            cleanName = "Default"
        end
        local ok = loadEspConfig(cleanName)
        if ok then
            syncLinoriaFromState()
        end
        Library:Notify(ok and ("Loaded \"" .. cleanName .. "\"") or ("Missing \"" .. cleanName .. "\""))
    end
})

EspSlotBox:AddButton({
    Text = "Delete ESP Slot",
    Func = function()
        local cleanName = trimStr(configSlotName)
        if cleanName == "" then
            cleanName = "Default"
        end
        local ok = deleteEspConfig(cleanName)
        Library:Notify(ok and ("Deleted \"" .. cleanName .. "\"") or ("Missing \"" .. cleanName .. "\""))
    end
})

MenuBox:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI = true,
    Text = "Menu keybind"
})

MenuBox:AddButton({
    Text = "Unload Script",
    Func = function()
        for _, c in ipairs(activeConnections) do
            c:Disconnect()
        end
        for p, _ in pairs(playerVisuals) do
            destroyVisuals(p)
        end
        fovCircle:Remove()
        Library:Unload()
    end
})

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"MenuKeybind"})
ThemeManager:SetFolder("BloodDebtHub")
SaveManager:SetFolder("BloodDebtHub/main")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)

Library:Notify("LOADED SAAR", 4)
