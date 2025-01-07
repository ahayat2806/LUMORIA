-- Wait for game loading
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Load UX/UI Library and other dependencies
local UILib = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Environment
local hubName = "LUMORIA Hub"
local hubCompany = "LUMORIA"
local hubVersion = "25.01.01"
local releaseType = "Beta" -- CHECK BUILD TYPE!!!
local hubTheme = "AmberGlow"
local hwid = gethwid() -- Initialize HWID here

-- Define getUserType function before using it
local function getUserType() -- Get user type
    if devMode then
        return "Developer"
    elseif proMode then
        return "Pro"
    else
        return "Free"
    end
end

local envInfo = ("Userlevel: "..getUserType()..", Release: "..releaseType..", Version: "..hubVersion..", HWID: "..hwid)

-- Function to check if game is compatible or to use universal mode
local function checkForCompatibleGame(gameId, games)
    for i = 1, #games do
        if games[i][1] == gameId then
            return true
        end
    end
    return false
end

-- Flags
gameCompatible = false -- Game compatibility flag
devMode = false
proMode = false
animSpeedMult = 0.33

-- Notify loading
UILib:Notify({
    Title = (hubName.." "..hubVersion),
    Content = ("Loaded!"),
    Duration = (6.5*animSpeedMult),
    Image = "Check"
})

-- Checks
print(hwid) -- Print HWID for development purposes
setclipboard(hwid)
print("-- Copied HWID to clipboard --")

local gameId = game.PlaceId -- Game compatibility check
local games = {
    {893973440, "Flee the Facility"},
    {987987987, "Example"}
}

-- Set flags
gameCompatible = checkForCompatibleGame(gameId, games)

if hwid == "6E61-7941-4D45-4F41-412D-3030-3030-302D-3030-3030-322D-3438-3430-3" then
    devMode = true
end

if not gameCompatible then
    uniMode = true
end

-- Conditions for game specific script
if game.PlaceId == 893973440 then
    local place = "Flee the Facility"
end

-- UI & Frontend
local Window = UILib:CreateWindow({ -- Main Window
    Name = "Home",
    Icon = "Sparkles",
    LoadingTitle = hubName,
    LoadingSubtitle = hubVersion,
    Theme = hubTheme,

    DisableRayfieldPrompts = not devMode,
    DisableBuildWarnings = not devMode,

    ConfigurationSaving = {
        Enabled = true,
        FolderName = hubCompany,
        FileName = hubName
    },

    KeySystem = true,
    KeySettings = {
        Title = hubName .." ".. hubVersion,
        Subtitle = "Enter your license key.",
        Note = "You can obtain a free license from the Discord, ad-free",
        FileName = "LUMORIA.KEY",
        SaveKey = true,
        Key = {"ilovemyeljona", "freepalestine"}
    }
})

-- Functions/Backend

-- Discord webhook function
local HttpService = game:GetService("HttpService")

local urlPart1 = "https://discord.com/api/webhooks/"
local urlPart2 = "1325974648344674404/"
local urlPart3 = "4Vx9CSoA5hqp2XkYdh0FXc3XBzvoMFelL9zxQ5cUUu1xVOPzZHsx0Ni8YWWr8SGL0caB"
local webhookUrl = urlPart1..urlPart2..urlPart3

local function dcLog(log)
    local payload = HttpService:JSONEncode({
        ["content"] = log
    })

    local headers = {
        ["Content-Type"] = "application/json"
    }

    local success, response = pcall(function()
        return HttpService:PostAsync(webhookUrl, payload, Enum.HttpContentType.ApplicationJson, false, headers)
    end)
end

local function createESP(player)
    local Box = Instance.new("BillboardGui")
    local Name = Instance.new("TextLabel")

    Box.Name = "ESP"
    Box.Parent = player.Character.Head
    Box.AlwaysOnTop = true
    Box.Size = UDim2.new(1, 0, 1, 0)
    Box.Adornee = player.Character.Head

    Name.Name = "Name"
    Name.Parent = Box
    Name.BackgroundTransparency = 1
    Name.Position = UDim2.new(0, 0, 0, -40)
    Name.Size = UDim2.new(1, 0, 10, 0)
    Name.Font = Enum.Font.SourceSansBold
    Name.Text = player.Name
    Name.TextColor3 = Color3.new(1, 0, 0)
    Name.TextScaled = true
end

local function removeESP(player)
    if player.Character and player.Character:FindFirstChild("Head") then
        local Box = player.Character.Head:FindFirstChild("ESP")
        if Box then
            Box:Destroy()
        end
    end
end

local function enableESP(enable)
    if enable then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                player.CharacterAdded:Connect(function(character)
                    wait(0.1) -- Small delay to ensure character is loaded
                    createESP(player)
                end)
                if player.Character then
                    createESP(player)
                end
            end
        end
        game.Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function(character)
                wait(0.1) -- Small delay to ensure character is loaded
                createESP(player)
            end)
        end)
    else
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                removeESP(player)
            end
        end
    end
end

local localPlayerTab = Window:CreateTab("Local", "user-round-cog") -- Localplayer Tab
local espToggle = localPlayerTab:CreateToggle({
    Name = "ESP",
    Flag = "ESPToggle",
    Callback = function(value)
        if value then
            enableESP(true)
        else
            enableESP(false)
        end
    end
})

-- Debug Tab - KEEP ME 2ND LAST!
local debugTab = Window:CreateTab("Debug", "bug-off") -- debugTab Init

-- Button to destroy the UI
local destroyGUIButton = debugTab:CreateButton({
    Name = ("Destroy " .. hubName),
    Callback = function()
        UILib:Destroy()
    end
})

-- DEVELOPER MODE - KEEP ME LAST!

if devMode == true then
    proMode = true -- Sets proMode flag to true
    local devModeTab = Window:CreateTab("Developer", "hammer") -- Developer tab
    local Section = devModeTab:CreateSection("Information")
    local Divider = devModeTab:CreateDivider()
    local userInfo = devModeTab:CreateLabel(getUserType(),"circle-user-round") -- Shows userType
    local releaseInfoLabel1 = devModeTab:CreateLabel(releaseType,"git-branch") -- Shows releaseType
    local releaseInfoLabel2 = devModeTab:CreateLabel(hubVersion,"git-commit-horizontal") -- Shows version
    local hwidInfo = devModeTab:CreateParagraph({
        Title = "HWID", Content = hwid
    })
    local copyInfo = devModeTab:CreateButton({
        Name = "Copy",
        Callback = function()
            setclipboard(envInfo)
        end,
    })
end

-- UX/UI Library load configuration
UILib:LoadConfiguration()