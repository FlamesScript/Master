-- Services
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")

-- Instances
local Open = Instance.new("ImageButton")
local executorGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local mainCorner = Instance.new("UICorner")
local titleBar = Instance.new("Frame")
local titleLabel = Instance.new("TextLabel")
local Corner = Instance.new("UICorner")
local closeButton = Instance.new("TextButton")
local editorContainer = Instance.new("ScrollingFrame")
local lineNumbers = Instance.new("TextLabel")
local scriptEditor = Instance.new("TextBox")
local uiScale = Instance.new("UIScale")

-- File Saving System
local folderName = "UltimateExecutorData"
local fileName = "SavedScript.txt"
local filePath = folderName .. "/" .. fileName

-- Functions
local function saveScript(text)
    writefile(filePath, text)
end

local function loadScript()
    if isfile(filePath) then
        return readfile(filePath)
    end
    return "print('Hello World!');"
end

local function Notif(Title, Text, Time)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = Title;
        Text = Text;
        Duration = Time or "3";
    })
end

local function updateLineNumbers()
    local lineCount = select(2, scriptEditor.Text:gsub("\n", "")) + 1
    local numbers = {}
    for i = 1, lineCount do
        numbers[i] = tostring(i)
    end
    lineNumbers.Text = table.concat(numbers, "\n")
end

-- UI Setup
for _, child in ipairs(CoreGui:GetChildren()) do
    if child:IsA("ScreenGui") and child.Name == "UltimateExecutor" then
        child:Destroy()
    end
end

executorGui.Name = "UltimateExecutor"
executorGui.DisplayOrder = "inf"
executorGui.Parent = CoreGui

mainFrame.Size = UDim2.new(0, 650, 0, 400)
mainFrame.Position = UDim2.new(0.5, 0, 0.435, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Parent = executorGui
mainFrame.Visible = false

mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.ZIndex = 2
titleBar.Parent = mainFrame

titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
titleLabel.Position = UDim2.new(0.02, 0, 0, 0)
titleLabel.Text = "ULTIMATE EXECUTOR V1.2"
titleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.BackgroundTransparency = 1
titleLabel.ZIndex = 3
titleLabel.Parent = titleBar

Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = titleBar

closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0.5, -15)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
closeButton.TextSize = 15
closeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
closeButton.Font = Enum.Font.GothamBold
closeButton.ZIndex = 3
closeButton.BackgroundTransparency = 1
closeButton.Parent = titleBar

editorContainer.Size = UDim2.new(1, -20, 1, -80)
editorContainer.Position = UDim2.new(0, 10, 0, 40)
editorContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
editorContainer.ScrollBarThickness = 6
editorContainer.AutomaticCanvasSize = Enum.AutomaticSize.XY
editorContainer.BorderSizePixel = 0
editorContainer.ElasticBehavior = Enum.ElasticBehavior.Always
editorContainer.Parent = mainFrame

lineNumbers.Name = "LineNumbers"
lineNumbers.Size = UDim2.new(0, 40, 18040, 0)
lineNumbers.BackgroundTransparency = 1
lineNumbers.TextColor3 = Color3.fromRGB(200, 200, 200)
lineNumbers.Font = Enum.Font.Code
lineNumbers.TextSize = 14
lineNumbers.TextYAlignment = Enum.TextYAlignment.Top
lineNumbers.Text = "1"
lineNumbers.Parent = editorContainer

scriptEditor.Name = "ScriptEditor"
scriptEditor.Size = UDim2.new(18040, 18040, 18040, 18040)
scriptEditor.Position = UDim2.new(0, 38, 0, 0)
scriptEditor.BackgroundTransparency = 1
scriptEditor.TextColor3 = Color3.fromRGB(255, 255, 255)
scriptEditor.Font = Enum.Font.Code
scriptEditor.TextSize = 14
scriptEditor.AnchorPoint = Vector2.new(0, 0)
scriptEditor.TextXAlignment = Enum.TextXAlignment.Left
scriptEditor.TextYAlignment = Enum.TextYAlignment.Top
scriptEditor.MultiLine = true
scriptEditor.ClearTextOnFocus = false
scriptEditor.PlaceholderText = "print('Hello World!');"
scriptEditor.Text = loadScript()
scriptEditor.ZIndex = 2
scriptEditor.TextWrapped = false
scriptEditor.ClipsDescendants = true
scriptEditor.Parent = editorContainer

uiScale.Parent = mainFrame
uiScale.Scale = 0.9

-- Buttons
local buttonConfigs = {
    {Name = "Execute", ImageId = "http://www.roblox.com/asset/?id=6026663699", Position = UDim2.new(0.925, 0, 0.91, 0)},
    {Name = "Clear", ImageId = "http://www.roblox.com/asset/?id=6035047409", Position = UDim2.new(0.87, 0, 0.91, 0)},
    {Name = "Copy", ImageId = "rbxassetid://14808228630", Position = UDim2.new(0.811, 0, 0.91, 0)},
    {Name = "Console", ImageId = "rbxassetid://14808232261", Position = UDim2.new(0.75, 0, 0.91, 0)}
}

for _, config in ipairs(buttonConfigs) do
    local btn = Instance.new("ImageButton")
    btn.Name = config.Name
    btn.Size = UDim2.new(0, 31, 0, 31)
    btn.Position = config.Position
    btn.Image = config.ImageId
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.BorderColor3 = Color3.fromRGB(0, 0, 0)
    btn.Parent = mainFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn

    if config.Name == "Execute" then
        btn.MouseButton1Click:Connect(function()
            local success, errorMsg = pcall(function()
                loadstring(scriptEditor.Text)()
                mainFrame.Visible = not mainFrame.Visible
                Open.Visible = not Open.Visible
                Notif("ULTIMATE EXECUTOR", "Script Executed!", "3")
            end)
            if not success then 
                Notif("ULTIMATE EXECUTOR", "Script Error!")
                warn("Error:", errorMsg) 
            end
        end)
    elseif config.Name == "Clear" then
        btn.MouseButton1Click:Connect(function()
            scriptEditor.Text = ""
            updateLineNumbers()
        end)
    elseif config.Name == "Copy" then
        btn.MouseButton1Click:Connect(function()
            setclipboard(scriptEditor.Text)
        end)
    elseif config.Name == "Console" then
        btn.MouseButton1Click:Connect(function()
            game:GetService("StarterGui"):SetCore("DevConsoleVisible", true)                     
        end)
    end
end

-- Open Button
Open.Size = UDim2.new(0, 50, 0, 50)
Open.Position = UDim2.new(0.5, 0, 0.025, 0)
Open.BackgroundTransparency = 1
Open.Image = "rbxthumb://type=Asset&id=123560030893631&w=420&h=420"
Open.AnchorPoint = Vector2.new(0.5, 0.5)
Open.Draggable = true
Open.Parent = executorGui

Open.MouseButton1Click:Connect(function()
    Open.Visible = not Open.Visible
    mainFrame.Visible = not Open.Visible
end)

closeButton.MouseButton1Click:Connect(function()
    Open.Visible = not Open.Visible
    mainFrame.Visible = not Open.Visible
end)

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = Open

updateLineNumbers()

warn(executorGui.Name .. " As loaded successfully")
