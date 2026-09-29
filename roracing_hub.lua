local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local Playergui = player:WaitForChild("PlayerGui")

local DiscordLink = "https://discord.gg/YOUR_INVITE"

-- Every entry appears in the Games list. No game ID is needed.
-- Module is used in Studio; Url is used by the external loadstring loader.
local GameModules = {
	{
		Name = "PROJECT APEX",
		Module = "project_apex",
		Url = "https://raw.githubusercontent.com/Silentslt/RoRacingHub/main/games/project_apex.lua",
	},
}

local previousGui = Playergui:FindFirstChild("RoracingHub")
if previousGui then
	previousGui:Destroy()
end

local Roracinggui = Instance.new("ScreenGui")
Roracinggui.Name = "RoracingHub"
Roracinggui.Parent = Playergui
Roracinggui.Enabled = true
Roracinggui.IgnoreGuiInset = false
Roracinggui.ResetOnSpawn = false
Roracinggui.DisplayOrder = 999999999

-- Applies to module-created text too. TextSize constraints prevent oversized text.
local function StyleText(object)
	if not (object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")) then
		return
	end
	object.TextScaled = true
	object.BackgroundTransparency = 1
	object.BorderSizePixel = 0
	local limit = object:FindFirstChildOfClass("UITextSizeConstraint")
	if not limit then
		limit = Instance.new("UITextSizeConstraint")
		limit.MinTextSize = 1
		limit.MaxTextSize = object.Name == "Heading" and 22 or 20
		limit.Parent = object
	end
	if object:IsA("TextButton") then
		object.AutoButtonColor = false
		object.MouseEnter:Connect(function()
			TweenService:Create(object, TweenInfo.new(0.12), {TextTransparency = 0.25}):Play()
		end)
		object.MouseLeave:Connect(function()
			TweenService:Create(object, TweenInfo.new(0.12), {TextTransparency = 0}):Play()
		end)
	end
end
Roracinggui.DescendantAdded:Connect(function(object)
	task.defer(function()
		if object:IsDescendantOf(Roracinggui) then StyleText(object) end
	end)
end)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = Roracinggui
MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
MainFrame.Position = UDim2.new(0.5,0,0.5,0)
MainFrame.Size = UDim2.new(0.88,0,0.75,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,27,32)
MainFrame.BorderSizePixel = 0

local sizeLimit = Instance.new("UISizeConstraint")
sizeLimit.MaxSize = Vector2.new(820, 520)
sizeLimit.Parent = MainFrame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = MainFrame
local outline = Instance.new("UIStroke")
outline.Color = Color3.fromRGB(65, 70, 82)
outline.Transparency = 0.35
outline.Parent = MainFrame

local UIConstraint = Instance.new("UIAspectRatioConstraint")
UIConstraint.Parent = MainFrame
UIConstraint.AspectRatio = 1.58
UIConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
UIConstraint.DominantAxis = Enum.DominantAxis.Width

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.Size = UDim2.new(1,0,0.1,0)
TopBar.BackgroundTransparency = 1

local NameOfHub = Instance.new("TextLabel")
NameOfHub.Name = "NameOfHub"
NameOfHub.Parent = TopBar
NameOfHub.Position = UDim2.new(0,14,0,0)
NameOfHub.Size = UDim2.new(0.41,-14,1,0)
NameOfHub.BackgroundTransparency = 1
NameOfHub.FontFace = Font.fromName("BuilderExtended",Enum.FontWeight.Bold)
NameOfHub.Text = "RORACING HUB"
NameOfHub.TextColor3 = Color3.fromRGB(255,255,255)
NameOfHub.TextScaled = true
NameOfHub.TextXAlignment = Enum.TextXAlignment.Left

local CurrentScriptLoaded = Instance.new("TextLabel")
CurrentScriptLoaded.Name = "CurrentScriptLoaded"
CurrentScriptLoaded.Parent = TopBar
CurrentScriptLoaded.Position = UDim2.new(0.435,0,0.12,0)
CurrentScriptLoaded.Size = UDim2.new(0.39,0,0.76,0)
CurrentScriptLoaded.BackgroundTransparency = 1
CurrentScriptLoaded.FontFace = Font.fromName("BuilderExtended",Enum.FontWeight.Bold)
CurrentScriptLoaded.Text = "CURRENTLY LOADED:\nUNIVERSAL"
CurrentScriptLoaded.TextColor3 = Color3.fromRGB(255,255,255)
CurrentScriptLoaded.TextScaled = true
CurrentScriptLoaded.TextWrapped = true
CurrentScriptLoaded.TextXAlignment = Enum.TextXAlignment.Left

local CloseGui = Instance.new("TextButton")
CloseGui.Name = "CloseGui"
CloseGui.Parent = TopBar
CloseGui.Position = UDim2.new(0.95,0,0,0)
CloseGui.Size = UDim2.new(0.05,0,1,0)
CloseGui.BackgroundTransparency = 1
CloseGui.FontFace = Font.fromName("BuilderExtended",Enum.FontWeight.Bold)
CloseGui.Text = "X"
CloseGui.TextColor3 = Color3.fromRGB(255,0,0)
CloseGui.TextScaled = true
CloseGui.Activated:Connect(function()
	MainFrame.Visible = false
end)

local UserInputService = game:GetService("UserInputService")
local toggleConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed or UserInputService:GetFocusedTextBox() then
		return
	end
	if input.KeyCode == Enum.KeyCode.RightBracket then
		MainFrame.Visible = not MainFrame.Visible
	end
end)

-- Disconnect the global input listener if the hub is removed or replaced.
Roracinggui.Destroying:Connect(function()
	toggleConnection:Disconnect()
end)

local TabHolderFrame = Instance.new("Frame")
TabHolderFrame.Name = "TabHolder"
TabHolderFrame.Parent = MainFrame
TabHolderFrame.Position = UDim2.new(0.228,0,0.1,0)
TabHolderFrame.Size = UDim2.new(0.769,0,0.896,0)
TabHolderFrame.BackgroundTransparency = 1

local SideBarFrame = Instance.new("Frame")
SideBarFrame.Name = "SideBar"
SideBarFrame.Parent = MainFrame
SideBarFrame.Size = UDim2.new(0.23,0,0.897,0)
SideBarFrame.Position = UDim2.new(0,0,0.1,0)
SideBarFrame.BackgroundTransparency = 1

local SideBarPadding = Instance.new("UIPadding")
SideBarPadding.Parent = SideBarFrame
SideBarPadding.PaddingTop = UDim.new(0.02,0)

local SideBarUIList = Instance.new("UIListLayout")
SideBarUIList.Parent = SideBarFrame
SideBarUIList.SortOrder = Enum.SortOrder.LayoutOrder
SideBarUIList.Padding = UDim.new(0,6)

local SideBarTemplate = Instance.new("Frame")
SideBarTemplate.Size = UDim2.new(1,0,0,48)
SideBarTemplate.BackgroundTransparency = 1
SideBarTemplate.Name = "Template"
SideBarTemplate.Parent = SideBarFrame
SideBarTemplate.Visible = false

local SideBarTemplateButton = Instance.new("TextButton")
SideBarTemplateButton.Name = "Name"
SideBarTemplateButton.Parent = SideBarTemplate
SideBarTemplateButton.BackgroundTransparency = 1
SideBarTemplateButton.Position = UDim2.fromOffset(10,0)
SideBarTemplateButton.Size = UDim2.new(1,-20,0.846,0)
SideBarTemplateButton.FontFace = Font.fromName("BuilderExtended",Enum.FontWeight.Bold)
SideBarTemplateButton.TextColor3 = Color3.fromRGB(255,255,255)
SideBarTemplateButton.Text = ""
SideBarTemplateButton.TextScaled = true

local SepLine1 = Instance.new("Frame")
SepLine1.Name = "TopLine"
SepLine1.Parent = MainFrame
SepLine1.BackgroundColor3 = Color3.fromRGB(65,70,82)
SepLine1.BorderSizePixel = 0
SepLine1.Position = UDim2.new(0,0,0.1,0)
SepLine1.Size = UDim2.new(1,0,0,2)

local SepLine2 = Instance.new("Frame")
SepLine2.Name = "SideLine"
SepLine2.Parent = MainFrame
SepLine2.BackgroundColor3 = Color3.fromRGB(65,70,82)
SepLine2.BorderSizePixel = 0
SepLine2.Position = UDim2.new(0.229,0,0.1,0)
SepLine2.Size = UDim2.new(0,2,0.9,0)

local Pages = {}
local Buttons = {}
local ActivePage = nil
local PageOrder = 0

local function ShowPage(name)
	for pageName, page in pairs(Pages) do
		page.Visible = pageName == name
		Buttons[pageName]:FindFirstChild("Name").TextColor3 = pageName == name
			and Color3.fromRGB(255,255,255)
			or Color3.fromRGB(155,155,160)
	end
	ActivePage = name
end

local function AddPage(name, buttonText)
	PageOrder = PageOrder + 1
	local button = SideBarTemplate:Clone()
	button.LayoutOrder = PageOrder
	button.Name = name .. "Button"
	button:FindFirstChild("Name").Text = buttonText
	button.Visible = true
	button.Parent = SideBarFrame

	local page = Instance.new("ScrollingFrame")
	page.Name = name .. "Page"
	page.Parent = TabHolderFrame
	page.Size = UDim2.new(1,0,1,0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 4
	page.ScrollBarImageColor3 = Color3.fromRGB(180,180,185)
	page.CanvasSize = UDim2.new(0,0,0,0)
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.Visible = false

	local padding = Instance.new("UIPadding")
	padding.Parent = page
	padding.PaddingTop = UDim.new(0,12)
	padding.PaddingBottom = UDim.new(0,12)
	padding.PaddingLeft = UDim.new(0,14)
	padding.PaddingRight = UDim.new(0,14)

	local list = Instance.new("UIListLayout")
	list.Parent = page
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0,12)

	Pages[name] = page
	Buttons[name] = button
	button:FindFirstChild("Name").Activated:Connect(function()
		ShowPage(name)
	end)
	return page
end

local function AddSection(page, title)
	local section = Instance.new("Frame")
	section.Name = title:gsub("%W", "") .. "Section"
	section.LayoutOrder = #page:GetChildren()
	section.Parent = page
	section.Size = UDim2.new(1,0,0,0)
	section.AutomaticSize = Enum.AutomaticSize.Y
	section.BackgroundTransparency = 1

	local list = Instance.new("UIListLayout")
	list.Parent = section
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0,7)

	local heading = Instance.new("TextLabel")
	heading.Name = "Heading"
	heading.Parent = section
	heading.Size = UDim2.new(1,0,0,28)
	heading.BackgroundTransparency = 1
	heading.FontFace = Font.fromName("BuilderExtended",Enum.FontWeight.Bold)
	heading.Text = title:upper()
	heading.TextColor3 = Color3.fromRGB(255,255,255)
	heading.TextSize = 22
	heading.TextXAlignment = Enum.TextXAlignment.Left

	local rows = Instance.new("Frame")
	rows.Name = "Rows"
	rows.LayoutOrder = 1
	rows.Parent = section
	rows.Size = UDim2.new(1,0,0,0)
	rows.AutomaticSize = Enum.AutomaticSize.Y
	rows.BackgroundTransparency = 1

	local rowList = Instance.new("UIListLayout")
	rowList.Parent = rows
	rowList.SortOrder = Enum.SortOrder.LayoutOrder
	rowList.Padding = UDim.new(0,7)

	return rows
end

local function AddRow(rows, label, buttonText, callback)
	local row = Instance.new("Frame")
	row.Name = label:gsub("%W", "")
	row.LayoutOrder = #rows:GetChildren()
	row.Parent = rows
	row.Size = UDim2.new(1,0,0,48)
	row.BackgroundTransparency = 1
	row.BorderSizePixel = 0

	local text = Instance.new("TextLabel")
	text.Name = "Name"
	text.Parent = row
	text.Position = UDim2.new(0,12,0,0)
	text.Size = UDim2.new(0.65,-12,1,0)
	text.BackgroundTransparency = 1
	text.FontFace = Font.fromName("BuilderExtended",Enum.FontWeight.Regular)
	text.Text = label
	text.TextColor3 = Color3.fromRGB(255,255,255)
	text.TextSize = 17
	text.TextXAlignment = Enum.TextXAlignment.Left

	local action = Instance.new("TextButton")
	action.Name = "Action"
	action.Parent = row
	action.AnchorPoint = Vector2.new(1,0.5)
	action.Position = UDim2.new(1,-10,0.5,0)
	action.Size = UDim2.new(0.3,0,0,30)
	action.BackgroundTransparency = 1
	action.BorderSizePixel = 0
	action.FontFace = Font.fromName("BuilderExtended",Enum.FontWeight.Bold)
	action.Text = buttonText
	action.TextColor3 = Color3.fromRGB(255,255,255)
	action.TextSize = 14
	if callback then
		action.Activated:Connect(function()
			local ok, err = pcall(callback, action)
			if not ok then warn("RORACING HUB: action failed: " .. tostring(err)) end
		end)
	end
	return row
end

local function AddToggle(rows, label, callback, defaultEnabled)
	local enabled = defaultEnabled == true
	local ToggleRow
	local function UpdateToggle()
		local button = ToggleRow:FindFirstChild("Action")
		button.Text = enabled and "ON" or "OFF"
		button.TextColor3 = enabled and Color3.fromRGB(90,220,150)
			or Color3.fromRGB(255,255,255)
	end
	ToggleRow = AddRow(rows, label, enabled and "ON" or "OFF", function()
		local nextEnabled = not enabled
		if callback then
			callback(nextEnabled)
		end
		enabled = nextEnabled
		UpdateToggle()
	end)
	UpdateToggle()
	return ToggleRow
end

local function AddNumberInput(rows, label, minimum, maximum, defaultValue, callback)
	local InputRow = AddRow(rows, label, "", nil)
	InputRow:FindFirstChild("Action"):Destroy()

	local InputBox = Instance.new("TextBox")
	InputBox.Name = "NumberInput"
	InputBox.Parent = InputRow
	InputBox.AnchorPoint = Vector2.new(1,0.5)
	InputBox.Position = UDim2.new(1,-10,0.5,0)
	InputBox.Size = UDim2.new(0.3,0,0,30)
	InputBox.BackgroundTransparency = 1
	InputBox.BorderSizePixel = 0
	InputBox.FontFace = Font.fromName("BuilderExtended",Enum.FontWeight.Bold)
	InputBox.TextColor3 = Color3.fromRGB(255,255,255)
	InputBox.TextSize = 14
	InputBox.TextXAlignment = Enum.TextXAlignment.Center
	InputBox.ClearTextOnFocus = false
	InputBox.MultiLine = false
	InputBox.TextEditable = true
	InputBox.PlaceholderText = tostring(minimum) .. " - " .. tostring(maximum)

	local InputCorner = Instance.new("UICorner")
	InputCorner.Parent = InputBox
	InputCorner.CornerRadius = UDim.new(0,6)

	local InputOutline = Instance.new("UIStroke")
	InputOutline.Parent = InputBox
	InputOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	InputOutline.Color = Color3.fromRGB(65,70,82)
	InputOutline.Thickness = 1

	local CurrentValue = math.clamp(defaultValue, minimum, maximum)

	local function ApplyValue(NewValue)
		if not NewValue or NewValue ~= NewValue or math.abs(NewValue) == math.huge then
			InputBox.Text = tostring(CurrentValue)
			return
		end

		NewValue = math.clamp(NewValue, minimum, maximum)

		if callback then
			local ok, err = pcall(callback, NewValue)
			if not ok then
				warn("RORACING HUB: number input failed: " .. tostring(err))
				InputBox.Text = tostring(CurrentValue)
				return
			end
		end

		CurrentValue = NewValue
		InputBox.Text = tostring(CurrentValue)
	end

	InputBox.FocusLost:Connect(function()
		ApplyValue(tonumber(InputBox.Text))
	end)

	ApplyValue(CurrentValue)
	return InputRow
end

local MainPage = AddPage("Main", "MAIN")
local GeneralRows = AddSection(MainPage, "General")
AddRow(GeneralRows, "Discord Server", "COPY LINK", function(button)
	if type(setclipboard) == "function" then
		setclipboard(DiscordLink)
		button.Text = "COPIED!"
		task.delay(2, function()
			if button.Parent then
				button.Text = "COPY LINK"
			end
		end)
	else
		local linkBox = button.Parent:FindFirstChild("LinkBox")
		if not linkBox then
			linkBox = Instance.new("TextBox")
			linkBox.Name = "LinkBox"
			linkBox.Parent = button.Parent
			linkBox.Position = UDim2.new(0,12,0,7)
			linkBox.Size = UDim2.new(1,-24,1,-14)
			linkBox.BackgroundTransparency = 1
			linkBox.BorderSizePixel = 0
			linkBox.FontFace = Font.fromName("BuilderExtended",Enum.FontWeight.Regular)
			linkBox.TextColor3 = Color3.fromRGB(255,255,255)
			linkBox.TextSize = 16
			linkBox.TextXAlignment = Enum.TextXAlignment.Left
			linkBox.ClearTextOnFocus = false
			linkBox.TextEditable = true
			linkBox.ZIndex = button.ZIndex + 1
		end
		linkBox.Text = DiscordLink
		linkBox.Visible = true
		button.Visible = false
		button.Parent:FindFirstChild("Name").Visible = false
		if not linkBox:GetAttribute("FocusHooked") then
			linkBox:SetAttribute("FocusHooked", true)
			linkBox.FocusLost:Connect(function()
				linkBox.Visible = false
				button.Visible = true
				button.Parent:FindFirstChild("Name").Visible = true
			end)
		end
		linkBox:CaptureFocus()
		linkBox.SelectionStart = 1
		linkBox.CursorPosition = #linkBox.Text + 1
	end
end)

local GameRows = AddSection(MainPage, "Games")
local LoadingModule = false
local SelectedModule = nil
local SelectedButton = nil
local HubAlive = true

CurrentScriptLoaded.Text = "SELECT A GAME:\nMAIN > GAMES"

Roracinggui.Destroying:Connect(function()
	HubAlive = false
end)

local function RemoveGamePage()
	if Pages.Game then
		-- Destroying the page lets the module restore its changes and connections.
		Pages.Game:Destroy()
		Pages.Game = nil
	end
	if Buttons.Game then
		Buttons.Game:Destroy()
		Buttons.Game = nil
	end
	SelectedModule = nil
	if SelectedButton and SelectedButton.Parent then
		SelectedButton.Text = "LOAD"
	end
	SelectedButton = nil
	ShowPage("Main")
end

local function LoadGameModule(GameModule, button)
	if LoadingModule then
		return
	end

	if SelectedModule == GameModule then
		ShowPage("Game")
		return
	end

	LoadingModule = true
	button.Text = "LOADING..."
	CurrentScriptLoaded.Text = "LOADING:\n" .. GameModule.Name

	local ok, result = pcall(function()
		if RunService:IsStudio() or not GameModule.Url then
			assert(GameModule.Module, "Set a ModuleScript name for Studio")
			local folder = ReplicatedStorage:WaitForChild("RoracingModules", 5)
			assert(folder, "Create ReplicatedStorage.RoracingModules")
			local module = folder:WaitForChild(GameModule.Module, 5)
			assert(module and module:IsA("ModuleScript"), "Missing ModuleScript: " .. GameModule.Module)
			return require(module)
		end

		assert(type(loadstring) == "function", "This environment does not support loadstring")
		local source = game:HttpGet(GameModule.Url)
		local compiled, compileError = loadstring(source)
		assert(compiled, compileError)
		return compiled()
	end)

	if not HubAlive then
		return
	end

	if ok and type(result) ~= "function" then
		ok = false
		result = "The game module must return function(hub)"
	end

	if ok then
		RemoveGamePage()
		local GamePage = AddPage("Game", GameModule.Name)
		local built, buildError = pcall(result, {
			Page = GamePage,
			AddSection = AddSection,
			AddRow = AddRow,
			AddToggle = AddToggle,
			AddNumberInput = AddNumberInput,
		})

		if not HubAlive then
			return
		end

		if built then
			SelectedModule = GameModule
			SelectedButton = button
			button.Text = "OPEN"
			CurrentScriptLoaded.Text = "CURRENTLY LOADED:\n" .. GameModule.Name
			ShowPage("Game")
		else
			RemoveGamePage()
			button.Text = "RETRY"
			CurrentScriptLoaded.Text = "MODULE ERROR:\nCHECK OUTPUT"
			warn("RORACING HUB: game module failed: " .. tostring(buildError))
		end
	else
		button.Text = "RETRY"
		if SelectedModule then
			CurrentScriptLoaded.Text = "CURRENTLY LOADED:\n" .. SelectedModule.Name
		else
			CurrentScriptLoaded.Text = "MODULE ERROR:\nCHECK OUTPUT"
		end
		warn("RORACING HUB: could not load " .. GameModule.Name .. ": " .. tostring(result))
	end

	LoadingModule = false
end

for _, GameModule in ipairs(GameModules) do
	AddRow(GameRows, GameModule.Name, "LOAD", function(button)
		LoadGameModule(GameModule, button)
	end)
end

ShowPage("Main")

for _, object in ipairs(Roracinggui:GetDescendants()) do
	if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
		object.TextScaled = true
		object.BackgroundTransparency = 1
	end
end
