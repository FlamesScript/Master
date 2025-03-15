getgenv().Settings = {
    FEHitbox = true,
    Size = 10
}

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local connections = {}
local originalSizes = {}

-- UI Library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/FlamesScript/Test/refs/heads/main/SimpleLib.lua", true))()
local window = library:CreateWindow("FE Hitbox Controller")

-- Toggle functionality
local function UpdateHitboxes()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= plr and player.Character then
            if Settings.FEHitbox then
                -- Apply hitbox
                pcall(function()
                    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        originalSizes[player] = originalSizes[player] or rootPart.Size
                        rootPart.Size = Vector3.new(Settings.Size, Settings.Size, Settings.Size)
                        rootPart.Transparency = 0.7
                        rootPart.Material = Enum.Material.Neon
                        rootPart.CanCollide = false
                    end
                end)
            else
                -- Restore original
                pcall(function()
                    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart and originalSizes[player] then
                        rootPart.Size = originalSizes[player]
                        rootPart.Transparency = 1
                        rootPart.CanCollide = true
                    end
                end)
            end
        end
    end
end

-- GUI Elements
window:AddToggle({
    text = "FE Hitbox",
    state = Settings.FEHitbox,
    callback = function(state)
        Settings.FEHitbox = state
        UpdateHitboxes()
    end
})

window:AddSlider({
    text = "Hitbox Size",
    min = 1,
    max = 50,
    value = Settings.Size,
    callback = function(value)
        Settings.Size = value
        if Settings.FEHitbox then
            UpdateHitboxes()
        end
    end
})

library:Init()

-- Player handling system
local function ProcessPlayer(player)
    if player == plr then return end

    local function handleCharacter(character)
        if Settings.FEHitbox then
            pcall(function()
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    originalSizes[player] = originalSizes[player] or rootPart.Size
                    rootPart.Size = Vector3.new(Settings.Size, Settings.Size, Settings.Size)
                    rootPart.Transparency = 0.7
                    rootPart.Material = Enum.Material.Neon
                    rootPart.CanCollide = false
                end
            end)
        end
    end

    -- Handle existing character
    if player.Character then
        handleCharacter(player.Character)
    end

    -- Connect character changes
    local conn = player.CharacterAdded:Connect(function(character)
        task.wait() -- Wait for character to load
        handleCharacter(character)
    end)
    table.insert(connections, conn)
end

-- Initial setup
for _, player in ipairs(Players:GetPlayers()) do
    ProcessPlayer(player)
end

Players.PlayerAdded:Connect(function(newPlayer)
    ProcessPlayer(newPlayer)
end)

-- Cleanup function
return function()
    -- Restore all players
    Settings.FEHitbox = false
    UpdateHitboxes()
    
    -- Disconnect all events
    for _, conn in ipairs(connections) do
        conn:Disconnect()
    end
end
