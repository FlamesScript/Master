-- Destroy previous instance if it exists
if getgenv().DestroyScript then
    getgenv().DestroyScript()
end

-- Define a new destroy function
getgenv().DestroyScript = function()
    Run = false -- Stop the main loop

    -- Disconnect stored connections
    for _, connection in ipairs(getgenv().configs.connections or {}) do
        if connection then
            connection:Disconnect()
        end
    end
    getgenv().configs.connections = {}

    -- Clear other global variables if needed
    getgenv().configs = nil
    getgenv().SETTINGS = nil
end


getgenv().SETTINGS = {
    reach = 7, 
    hit_distance = false,
    auto_swing = false,
    auto_equip = true,
    multi = 5,
    CircleT = 0.5
}

local Disable = Instance.new("BindableEvent")
getgenv().configs = {
    connections = {},
    Disable = Disable,
    Size = Vector3.new(SETTINGS.reach, SETTINGS.reach, SETTINGS.reach),
    DeathCheck = true,
    AutoSwing = SETTINGS.auto_swing,
    AutoEquip = SETTINGS.auto_equip,
}

local Destroy = game:GetService("Workspace"):FindFirstChild("Circle")
if Destroy then
    Destroy:Destroy()
end

-- Create Circle Function
local function createCircle()
    local circle = Instance.new("Part")
    circle.Name = "Circle"
    circle.Anchored = true
    circle.CanCollide = false
    circle.CanTouch = true
    circle.CanQuery = true
    circle.Color = Color3.fromRGB(255, 0, 0)
    circle.Material = Enum.Material.ForceField
    circle.Shape = Enum.PartType.Ball
    circle.CastShadow = false
    circle.Transparency = 1
    circle.Size = Vector3.new(SETTINGS.reach, SETTINGS.reach, SETTINGS.reach)
    circle.Parent = workspace
    return circle
end

local function updateCircle(circle, handle)
    if handle then
        circle.Size = Vector3.new(SETTINGS.reach, SETTINGS.reach, SETTINGS.reach)
        circle.CFrame = handle.CFrame
        circle.Transparency = SETTINGS.CircleT
    else
        circle.Transparency = 1
    end
end

local circle = createCircle()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- Variables
local Run = true
local Ignorelist = OverlapParams.new()
Ignorelist.FilterType = Enum.RaycastFilterType.Include
local EquippedTool = nil
local Swinging = false  

local function getchar(plr)
    return (plr or lp).Character
end

local function gethumanoid(plr)
    local char = plr:IsA("Model") and plr or getchar(plr)
    return char and char:FindFirstChildWhichIsA("Humanoid")
end

local function IsAlive(Humanoid)
    return Humanoid and Humanoid.Health > 0
end

local function GetTouchInterest(Tool)
    return Tool and Tool:FindFirstChildWhichIsA("TouchTransmitter", true)
end

local function GetCharacters(LocalPlayerChar)
    local Characters = {}
    for _, v in ipairs(Players:GetPlayers()) do
        local char = getchar(v)
        if char and char ~= LocalPlayerChar then
            table.insert(Characters, char)
        end
    end
    return Characters
end

-- Check for ForceField
local function HasFF(character)
    return character:FindFirstChildOfClass("ForceField") ~= nil
end

-- Attack Function
local function Attack(Tool, TouchPart, ToTouch)
    if not HasFF(ToTouch.Parent) then
        if Tool:IsDescendantOf(workspace) then
            Tool:Activate()
            for _ = 1, SETTINGS.multi do
                firetouchinterest(TouchPart, ToTouch, 1)
                firetouchinterest(TouchPart, ToTouch, 0)
            end
        end
    end
end

-- Updated Auto Swing Function
local function StartAutoSwing(Tool)
    Swinging = true
    while SETTINGS.auto_swing and Tool == EquippedTool and Run do
        if Tool:IsDescendantOf(workspace) and Tool.Parent == lp.Character then
            Tool:Activate()
        else
            break
        end
        task.wait()
    end
    Swinging = false
end

lp.CharacterAdded:Connect(function()
    task.wait()
    EquippedTool = nil
end)

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/FlamesScript/Test/refs/heads/main/SimpleLib.lua", true))()

local window = library:CreateWindow("Universal Reach")

window:AddSlider({
    text = "Reach",
    min = 1,
    max = 100,
    value = SETTINGS.reach,
    callback = function(value)
       SETTINGS.reach = value
    end
})

window:AddToggle({
    text = "Hit Distance",
    state = SETTINGS.hit_distance,
    callback = function(state)
        SETTINGS.hit_distance = state
    end
})

window:AddToggle({
    text = "Auto Swing",
    state = SETTINGS.auto_swing,
    callback = function(state)
        SETTINGS.auto_swing = state
        if state and EquippedTool and not Swinging then
            StartAutoSwing(EquippedTool)
        end
    end
})

window:AddSlider({
    text = "Damage Multi",
    min = 1,
    max = 5,
    value = SETTINGS.multi,
    callback = function(value)
        SETTINGS.multi = value
    end
})

window:AddSlider({
    text = "Circle Transparency",
    min = 0,
    max = 1,
    value = SETTINGS.CircleT,
    callback = function(value)
        SETTINGS.CircleT = value
    end
})

window:AddLabel({ text = "Creator: FlamesEvo" })

print("Loaded")

library:Init()

while Run do
    local char = getchar()
    if char and IsAlive(gethumanoid(char)) then
        local Tool = char:FindFirstChildWhichIsA("Tool")
        if Tool and Tool ~= EquippedTool then
            EquippedTool = Tool
            if SETTINGS.auto_swing and not Swinging then
                StartAutoSwing(Tool)
            end
        elseif not Tool and EquippedTool then
            EquippedTool = nil
        end

        updateCircle(circle, EquippedTool and EquippedTool:FindFirstChild("Handle"))

        if EquippedTool then
            local TouchInterest = GetTouchInterest(EquippedTool)
            if TouchInterest then
                local TouchPart = TouchInterest.Parent
                local Characters = GetCharacters(char)
                Ignorelist.FilterDescendantsInstances = Characters
                local InstancesInBox = workspace:GetPartBoundsInBox(
                    TouchPart.CFrame,
                    TouchPart.Size + Vector3.new(SETTINGS.reach, SETTINGS.reach, SETTINGS.reach),
                    Ignorelist
                )
                for _, v in ipairs(InstancesInBox) do
                    local Character = v:FindFirstAncestorWhichIsA("Model")
                    if table.find(Characters, Character) then
                        local distance = (char.PrimaryPart.Position - Character.PrimaryPart.Position).Magnitude
                        if distance <= SETTINGS.reach then
                            if Character ~= lp and HasFF(Character) then
                                -- Skip if FF is active
                            else
                                if getgenv().configs.DeathCheck then
                                    if IsAlive(gethumanoid(Character)) then
                                        Attack(EquippedTool, TouchPart, v)
                                    end
                                else
                                    Attack(EquippedTool, TouchPart, v)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    RunService.Heartbeat:Wait()
end
