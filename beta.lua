-- Load UX/UI Library and other dependencies
local UILib = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Environment
local hubName = "LUMORIA Hub"
local hubCompany = "LUMORIA"
local hubVersion = "25.01.03 rev.0"
local releaseType = "Beta"
local hubTheme = "AmberGlow"
local hwid = gethwid() -- Initialize HWID here
local localPlayer = game.Players.LocalPlayer.Name

-- Global variables
selectedPlayer = nil

-- Commonly used
local styledSpacer = " • "
local strSpace = " "

-- Checks
print(hwid) -- Print HWID for development purposes
setclipboard(hwid)
print("-- Copied HWID to clipboard --")
local gameId = game.PlaceId -- Get gameId for checking

-- Game library
local games = {
    {893973440, "Flee the Facility"}, -- 1
    {16732694052, "Fisch"}, -- 2
    {192800, "Work at a Pizza Place"} -- 3
    {10975855395, "Korrupt Zombies"} -- 4
}

-- Script library
local iyfe = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
local sirius = "https://sirius.menu/sirius"
local ddexv3 = "https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua"
local function runHydroxide() -- Func to run Hydroxide
    local owner = "Upbolt"
    local branch = "revision"
    local function webImport(file)
        return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')()
    end
    webImport("init")
    webImport("ui/main")
end

-- Flags
devMode = false
proMode = false
animSpeedMult = 0.33
animSpeed = 6.5
vipGamepassID = 116997062088479

-- Function to check if game is compatible or to use universal mode
local function checkForCompatibleGame()
    for _, gameEntry in ipairs(games) do
        if gameEntry[1] == gameId then
            return gameEntry[2]
        end
    end
    return "Universal"
end

-- Developer HWID DB
local devHWIDs = {
    {"6E61-7941-4D45-4F41-412D-3030-3030-302D-3030-3030-322D-3438-3430-3", "Ayan"},
    {"62383262636663326262613164343230323438633632663466333363393265326263633361383232363138316365323736343236376363343064613763663864", "traptoy🔥🔥"}
}

-- Function to get developer name and HWIDs
local function getDevNameFromHWID(hwid)
    for i = 1, #devHWIDs do
        if devHWIDs[i][1] == hwid then
            return devHWIDs[i][2]
        end
    end
end

-- Set flags
for i=1, #devHWIDs do
    if hwid == devHWIDs[i][1] then
        devMode = true
        proMode = true
    end
end

-- Functions/Backend

-- Debug functions backend
local function sysNoti(msg) -- Inform using UILib notify function
    UILib:Notify({
        Title = "System Notification",
        Content = msg,
        Duration = animSpeed*animSpeedMult,
        Image = "info",
    })
end

-- Localplayer scripts backend

-- Players scripts backend

-- Game Library

-- Flee the Facility [1]
local function spoofVIPFlee() -- Spoof VIP function
    local vipDBPath = game:GetService("ReplicatedStorage").GamePassIds
    local vipDB = require(vipDBPath)
    vipDB.VIP = vipGamepassID
end

-- Fisch [2]
local function perfectCast() -- Perfect cast function -- BROKEN
    local ohNumber1 = 100
    local ohNumber2 = 1
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local toolName = "Flimsy Rod" -- The name of the tool
    -- Ensure the tool is equipped
    local tool = character:FindFirstChild(toolName) or player.Backpack:FindFirstChild(toolName)
    if tool then
        tool.events.cast:FireServer(ohNumber1, ohNumber2)
    else
        warn("Tool not found: " .. toolName)
    end
end
local function catchFish() -- Catch fish function
    game:GetService("ReplicatedStorage").events.reelfinished:FireServer(100, false)
end

-- Work At A Pizza Place [3]
-- Jobs
local function waappJobManage(action, job) -- Function to change and tp to jobs
    local actions = {"ChangeJob", "TeleportToJob"} -- Actions
    game:GetService("ReplicatedStorage").PlayerChannel:FireServer(actions[action], job) -- Fire job manager remote with action and job
end

-- Houses
local function getWaappHouses() -- Get Work at a Pizza Place houses
    local waappHouses = {} -- Table to store Work at a Pizza Place houses
    for _, house in ipairs(game:GetService("Workspace").Houses:GetChildren()) do
        table.insert(waappHouses, house)
        return waappHouses
    end
end
if gameId == games[3][1] then
    waappHouses = getWaappHouses()
end

-- Manager tools
local function waappManageEmployee(action, player)
    local actions = {"BackToWork", "GiveBonus", "EmployeeOfTheDay", "NominateForBan", "QuitJob", "On Break"} -- Table of actions
    local playerParent = game:GetService("Players") -- Get selected player
    game:GetService("ReplicatedStorage").ManagerChannel:FireServer(actions[action], playerParent[selectedPlayer]) -- Fire remote with conditions passed
end

-- Korrupt Zombies [4]

-- END OF BACKEND FUNCTIONS --

-- Env/Program
local function getUserType() -- Returns usertype
    if devMode then
        return "Developer"
    elseif proMode then
        return "Pro"
    else
        return "Free"
    end
end

-- Build envInfo
local envInfo = ("Userlevel: " .. getUserType() .. ", DeveloperID: " .. getDevNameFromHWID(hwid) .. ", localPlayer: ".. localPlayer .. ", Release: " .. releaseType .. ", Version: " .. hubVersion .. ", HWID: " .. hwid .. ", GameSync: " .. checkForCompatibleGame() .. ", PlaceId: " .. gameId)

-- UI & Frontend
local Window = UILib:CreateWindow({
    Name = hubName .. " • " .. checkForCompatibleGame(),
    Icon = "Sparkles",
    LoadingTitle = hubName,
    LoadingSubtitle = hubVersion,
    Theme = hubTheme,
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = not devMode,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = hubCompany,
        FileName = hubName
    },
    KeySystem = true,
    KeySettings = {
        Title = hubName .. " " .. hubVersion,
        Subtitle = "Enter your license key.",
        Note = "You can obtain a free license from the Discord, ad-free",
        FileName = hubCompany..".KEY",
        SaveKey = true,
        Key = {"ilovemyeljona", "freepalestine"}
    }
})

-- TABS
if gameId == games[1][1] then   -- Flee the Facility TAB CREATION
    local fleeTab = Window:CreateTab(games[1][2], "gamepad-2")
    if devMode == true then -- Devmode functions
        local devSec = fleeTab:CreateSection("Developer") -- Developer section name
        local pCastBttn = fleeTab:CreateButton({ -- Corrected reference from fischTab to fleeTab
            Name = "Perfect Cast", -- Title
            Callback = function()
                perfectCast() -- Call func
            end
        })
    end
end

if gameId == games[2][1] then   -- FISCH TAB CREATION
    local fischTab = Window:CreateTab(games[2][2], "gamepad-2")
    if devMode == true then -- Devmode functions
        local devSec = fischTab:CreateSection("Developer") -- Developer section name
        local pCastBttn = fischTab:CreateButton({ -- Perfect Cast button
            Name = "Perfect Cast", -- Title
            Callback = function()
                perfectCast() -- Call func
            end
        })
        local catchFishBttn = fischTab:CreateButton({ -- Catch fish button
            Name = "Catch Fish", -- Title
            Callback = function()
                catchFish() -- Call func
            end
        })
        local sellAllBttn = fischTab:CreateButton({ -- Sell all button
            Name = "Sell all", -- Title
            Callback = function()
                game:GetService("ReplicatedStorage").events.SellAll:InvokeServer() -- remote to fire
            end
        })
    end
end

if gameId == games[3][1] then -- WorkAtAPizzaPlace TAB CREATION
    local waappTab = Window:CreateTab(games[3][2], "gamepad-2")
    if devMode == true then -- Devmode functions
        -- local devSec = waappTab:CreateSection("Developer") -- Developer section
    end
    local tpSec = waappTab:CreateSection("Job Manager") -- Teleport section

        local jobs = {"Cashier", "Cook", "Pizza Boxer", "Supplier", "Delivery", "Manager", "Break"} -- Array of pizza place jobs
        local selectedJob
        local tpDropDown = waappTab:CreateDropdown({ -- Dropdown for jobs
            Name = "Select Job", -- Title
            Options = jobs, -- Options
            CurrentOption = jobs[1], -- Default
            MultipleOptions = false, -- Allow multiple selections
            Flag = "waappJobSelector", -- Flag set
            Callback = function(CurrentOption)
                selectedJob = CurrentOption[1] -- Set selectedJob
            end
        })

        local tpBttn = waappTab:CreateButton({ -- Teleport to job button
            Name = "Teleport to Job", -- Title
            Callback = function()
                waappJobManage(2, selectedJob) -- Call func
            end,
        })

        local changeJobBttn = waappTab:CreateButton({ -- Change job button
            Name = "Change Job", -- Title
            Callback = function()
                waappJobManage(1, selectedJob) -- Call func
            end,
        })

        local tpSec = waappTab:CreateSection("Teleports") -- Teleports section

        --[[local waappHousesDropdown = waappTab:CreateDropdown({ -- Dropdown for houses
            Name = "Select House", -- Title
            Options = waappHouses, -- Options
            CurrentOption = waappHouses[1], -- Default
            MultipleOptions = false, -- Allow multiple selections
            Flag = "waappHouseSelector", -- Flag set
            Callback = function(CurrentOption)
                selectedHouse = CurrentOption[1] -- Set selectedHouse
                print(selectedHouse)
            end
        })--]]

        local playerSec = waappTab:CreateSection("Player Manager (Must be manager)") -- Player manager section

        waappSelectedPlayerLabel = waappTab:CreateLabel("Selected Player: ", "circle-user-round") -- Selected player label
        local backToWorkBttn = waappTab:CreateButton({
            Name = "Send back to work", -- Title
            Callback = function()
                waappManageEmployee(1, selectedPlayer) -- Call func
            end,
        })
        local giveBonusBttn = waappTab:CreateButton({
            Name = "Give bonus", -- Title
            Callback = function()
                waappManageEmployee(2, selectedPlayer) -- Call func
            end,
        })
        local giveEmployeeOfTheDayBttn = waappTab:CreateButton({
            Name = "Give employee of the day", -- Title
            Callback = function()
                waappManageEmployee(3, selectedPlayer) -- Call func
            end,
        })
        local voteBanBttn = waappTab:CreateButton({
            Name = "Vote for ban", -- Title
            Callback = function()
                waappManageEmployee(4, selectedPlayer) -- Call func
            end,
        })

        local selfSec = waappTab:CreateSection("Self") -- Self manager section

        local quitJobBttn = waappTab:CreateButton({
            Name = "Quit Job", -- Title
            Callback = function()
                waappManageEmployee(5, selectedPlayer) -- Call func
            end,
        })
end

if gameId == games[4][1] then -- Korrupt Zombies TAB CREATION
    local korruptTab = Window:CreateTab(games[4][2], "gamepad-2")
    if devMode == true then -- Devmode functions
        local devSec = korruptTab:CreateSection("Developer") -- Developer section name
    end
end

local generalTab = Window:CreateTab("General", "menu") -- General tab
local localPlayerTab = Window:CreateTab("Local", "user-round-cog") -- Localplayer tab init
local playersTab = Window:CreateTab("Players", "users-round") -- Players tab init
local scriptsTab = Window:CreateTab("Scripts", "file-code-2") -- Scripts tab init
local debugTab = Window:CreateTab("Debug", "bug-off") -- Debug tab init
local infoTab = Window:CreateTab("Info", "info") -- Information tab init

if devMode then -- If devMode condition
    devModeTab = Window:CreateTab("Developer", "hammer") -- Devmode tab init
end

-- Localplayer tab elements
if devMode == true then -- Devmode functions
    local devSec = localPlayerTab:CreateSection("Developer") -- Developer section name

    local respawnBttn = localPlayerTab:CreateButton({ -- Respawn button
    Name = "Respawn", -- Title
    Callback = function()
        print("Respawn func callback")
    end,
})
end

-- Players tab elements
if devMode == true then -- Devmode functions
    local devSec = playersTab:CreateSection("Developer") -- Developer section name
end

local function playerSelected() -- playerSelected event
    if gameId == games[3][1] then -- Work at a Pizza Place playerSelected event
        waappSelectedPlayerLabel:Set("Selected Player: " .. selectedPlayer, "circle-user-round") -- Set 
    end
end

local playersDropdown = playersTab:CreateDropdown({
    Name = "Select Player",
    Options = {localPlayer},
    CurrentOption = {localPlayer},
    MultipleOptions = false,
    Flag = "selectPlayerDropdown",
    Callback = function(CurrentOption)
        selectedPlayer = CurrentOption[1]
        playerSelected()
    end,
})

-- selectPlayerDropdown Mini-Backend
local function updatePlayerDropdown()
    local players = {}
    for _, player in ipairs(game.Players:GetPlayers()) do
        table.insert(players, player.Name)
    end
    playersDropdown:Refresh(players, true)
end

game.Players.PlayerAdded:Connect(function(player) -- Player added event
    updatePlayerDropdown()
end)

game.Players.PlayerRemoving:Connect(function(player) -- Player removed event
    updatePlayerDropdown()
end)

updatePlayerDropdown() -- Initialise player dropdown

-- Scripts tab elements
-- UNIVERSAL SCRIPTLIB
local universalSection = scriptsTab:CreateSection("Universal") -- Universal scripts section

local runIY = scriptsTab:CreateButton({ -- Run IY button
    Name = "Run 'Infinite Yield'", -- Title
    Callback = function()
        loadstring(game:HttpGet(iyfe, true))() -- Loadstring
    end
})
local runSirius = scriptsTab:CreateButton({ -- Run Sirius button
    Name = "Run 'Sirius'", -- Title
    Callback = function()
        loadstring(game:HttpGet(sirius, true))() -- Loadstring
    end
})

-- Reverse Engineering SCRIPTLIB
local reSection = scriptsTab:CreateSection("Reverse Engineering") -- Debug scripts section

local runHydroxide = scriptsTab:CreateButton({ -- Run Hydroxide button
    Name = "Run 'Hydroxide'", -- Title
    Callback = function()
        runHydroxide() -- Call func
    end
})
local runDex = scriptsTab:CreateButton({ -- Run Dark Dex V3 button
    Name = "Run 'Dark Dex V3'", -- Title
    Callback = function()
        loadstring(game:HttpGet(ddexv3, true))()
    end
})
-- ALWAYS RUN TOGGLES
local alwaysSection = scriptsTab:CreateSection("Always run scripts") -- Always run scripts section
local alwaysIY = scriptsTab:CreateToggle({ -- Always run IY toggle
    Name = "Always run 'Infinite Yield'", -- Title
    Flag = "alwaysRunIY", -- Flag set
    Callback = function(run)
        if run then
            loadstring(game:HttpGet(iyfe, true))() -- Loadstring
        end
    end
})
local alwaysSirius = scriptsTab:CreateToggle({ -- Always run Sirius toggle
    Name = "Always run 'Sirius'", -- Title
    Flag = "alwaysRunSirius", -- Flag set
    Callback = function(run)
        if run then
            loadstring(game:HttpGet(sirius, true))() -- Loadstring
        end
    end
})
local alwaysDex = scriptsTab:CreateToggle({ -- Always run Sirius toggle
    Name = "Always run 'Dark Dex V3'", -- Title
    Flag = "alwaysRunDex", -- Flag set
    Callback = function(run)
        if run then
            loadstring(game:HttpGet(ddexv3, true))() -- Loadstring
        end
    end
})
local alwaysHydrox = scriptsTab:CreateToggle({ -- Always run Hydroxide toggle
    Name = "Always run 'Hydroxide'", -- Title
    Flag = "alwaysRunHydroxide", -- Flag set
    Callback = function(run)
        if run then
            runHydroxide() -- Call func
        end
    end
})

-- Always run scripts
if _G.alwaysRunIY then -- Always run IY condition
    loadstring(game:HttpGet(iyfe, true))()
end
if _G.alwaysRunSirius then -- Always run Sirius condition
    loadstring(game:HttpGet(sirius, true))()
end
if _G.alwaysRunDex then -- Always run Sirius condition
    loadstring(game:HttpGet(ddexv3, true))()
end
if _G.alwaysRunHydroxide then -- Always run Hydroxide condition
    runHydroxide()  -- Call func
end

-- Debug Tab Elements
local uiSection = debugTab:CreateSection("UI") -- Debug section
local destroyGUIButton = debugTab:CreateButton({ -- Destroy GUI Button frame
    Name = "Destroy " .. hubName, -- Title and stringbuild
    Callback = function()
        UILib:Destroy()
    end
})

local debugOptionsSection = debugTab:CreateSection("Options") -- Debug options section

local visualiseConsoleToggle = debugTab:CreateToggle({ -- Visualise console toggle
    Name = "Notify console outputs", -- Title
    Flag = "visualiseConsoleToggle", -- Flag set
    Callback = function(visualiseConsole)
        if visualiseConsole then
            function print(val)
                sysNoti(val)
            end
            function warn(msg)
                sysNoti(msg) -- Corrected variable name from val to msg
            end
        else
            function print(val)
                print(val)
            end
            function warn(msg)
                warn(msg) -- Corrected variable name from val to msg
            end
        end
    end
})

-- Info Tab Elements

local infoSection = infoTab:CreateSection("Information") -- Information section

-- Developer tab elements
if devMode == true then
    local Section = devModeTab:CreateSection("Information") -- Information sections
    local userInfo = devModeTab:CreateLabel(getUserType()..styledSpacer..getDevNameFromHWID(hwid).. " - Playing as: " ..localPlayer, "circle-user-round") -- Usertype Label
    local releaseInfoLabel1 = devModeTab:CreateLabel(releaseType, "git-branch") -- Releasetype label
    local releaseInfoLabel2 = devModeTab:CreateLabel(hubVersion, "git-commit-horizontal") -- Version label
    -- Promode check and display
    local proModeLabel = devModeTab:CreateLabel("Pro", "circle-x")
    if proMode then
        proModeLabel:Set("Pro", "circle-check")
    else
        proModeLabel:Set("Free", "circle-x")
    end

    local hwidInfo = devModeTab:CreateParagraph({ -- HWID Field
        Title = "HWID", Content = hwid
    })
    local copyInfo = devModeTab:CreateButton({ -- Copy info button
        Name = "Copy", -- Title
        Callback = function()
            setclipboard(envInfo) -- Copy envInfo
        end
    })
end

-- Load configuration
UILib:LoadConfiguration()