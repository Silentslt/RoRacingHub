-- ModuleScript: ReplicatedStorage/RoracingModules/project_apex
-- Or repository file: games/project_apex.lua
return function(hub)
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local UserInputService = game:GetService("UserInputService")
	local Player = Players.LocalPlayer
	assert(Player, "Project Apex must run on the client")
	assert(hub.AddNumberInput, "Update the hub script to include AddNumberInput")
	local Connections = {}
	local Alive = true
	local CCEnabled = false
	local MovedCornerCuts = {}
	local HolderFolder = Instance.new("Folder")
	HolderFolder.Name = "RoracingCornerCutsHolder"
	HolderFolder.Parent = ReplicatedStorage

	local function DisableCornerCuts(PAtiming)
		local PACC = PAtiming:FindFirstChild("CornerCuts")
		if PACC then
			MovedCornerCuts[PACC] = PAtiming
			PACC.Parent = HolderFolder
		end
	end

	local function RestoreCornerCuts()
		for PACC, OriginalParent in pairs(MovedCornerCuts) do
			if PACC.Parent == HolderFolder and OriginalParent:IsDescendantOf(workspace) then
				PACC.Parent = OriginalParent
				MovedCornerCuts[PACC] = nil
			elseif PACC.Parent ~= HolderFolder then
				MovedCornerCuts[PACC] = nil
			end
		end
	end

	local function SetCornerCuts(enabled)
		CCEnabled = enabled
		if enabled then
			RestoreCornerCuts()
		else
			local PAtiming = workspace:FindFirstChild("Timing_System")
			if PAtiming then
				DisableCornerCuts(PAtiming)
			end
		end
	end

	local carRows = hub.AddSection(hub.Page, "Track")
	hub.AddToggle(carRows, "Corner cuts", SetCornerCuts, false)
	SetCornerCuts(false)
	table.insert(Connections, workspace.DescendantAdded:Connect(function(object)
		if CCEnabled then
			return
		end
		if object.Name == "Timing_System" or object.Name == "CornerCuts" then
			task.defer(function()
				if Alive and not CCEnabled then
					SetCornerCuts(false)
				end
			end)
		end
	end))

	local GravityEnabled = false
	local GravityPercent = 100
	local TargetPart
	local GravAttachment
	local Gravforce
	local function ClearForce()
		if Gravforce then
			Gravforce:Destroy()
		end
		if GravAttachment then
			GravAttachment:Destroy()
		end
		TargetPart, GravAttachment, Gravforce = nil, nil, nil
	end

	local function UpdateGravity()
		if not GravityEnabled then
			ClearForce()
			return
		end

		local PlayerModel = Player.Character
		local Humanoid = PlayerModel and PlayerModel:FindFirstChildOfClass("Humanoid")
		local RootPart = PlayerModel and PlayerModel:FindFirstChild("HumanoidRootPart")
		if not Humanoid or Humanoid.Health <= 0 or not RootPart
			or not RootPart:IsDescendantOf(workspace) or GravityPercent == 100 then
			ClearForce()
			return
		end
		-- A seated character may be welded into the seat/chassis assembly.
		local PhysicsPart = Humanoid.SeatPart or RootPart
		if PhysicsPart ~= TargetPart or not Gravforce or Gravforce.Parent ~= PhysicsPart
			or not GravAttachment or GravAttachment.Parent ~= PhysicsPart then
			ClearForce()
			TargetPart = PhysicsPart
			GravAttachment = Instance.new("Attachment")
			GravAttachment.Name = "RoracingGravityAttachment"
			GravAttachment.Parent = PhysicsPart
			Gravforce = Instance.new("VectorForce")
			Gravforce.Name = "RoracingGravityForce"
			Gravforce.Attachment0 = GravAttachment
			Gravforce.ApplyAtCenterOfMass = true
			Gravforce.RelativeTo = Enum.ActuatorRelativeTo.World
			Gravforce.Parent = PhysicsPart
		end
		-- F = mass * acceleration. 0% = zero gravity, 100% = normal, 200% = double.
		local AssemblyMass = PhysicsPart.AssemblyMass
		if AssemblyMass == math.huge or AssemblyMass <= 0 then
			Gravforce.Force = Vector3.zero
			Gravforce.Enabled = false
			return
		end
		Gravforce.Force = Vector3.new(0, AssemblyMass * workspace.Gravity * (1 - GravityPercent / 100), 0)
		Gravforce.Enabled = true
	end

	local raceRows = hub.AddSection(hub.Page, "Gravity")
	hub.AddToggle(raceRows, "Gravity", function(enabled)
		GravityEnabled = enabled
		UpdateGravity()
	end, false)

	hub.AddNumberInput(raceRows, "Gravity (%)", 0, 200, 100, function(value)
		GravityPercent = value
		UpdateGravity()
	end)
	-- Recalculate for respawns, seat changes, mass changes, and world gravity.
	table.insert(Connections, RunService.PreSimulation:Connect(UpdateGravity))

	local SpeedEnabled = false
	local VelocityMult = 0.025

	local speedRows = hub.AddSection(hub.Page, "Car Speed")
	hub.AddToggle(speedRows, "Speed boost (hold W)", function(enabled)
		SpeedEnabled = enabled
	end, false)

	hub.AddNumberInput(speedRows, "Boost (thousandths)", 0, 50, 25, function(value)
		VelocityMult = value / 1000
	end)

	local function UpdateCarSpeed(DeltaTime)
		if not SpeedEnabled or VelocityMult == 0 or UserInputService:GetFocusedTextBox() then
			return
		end

		if not UserInputService:IsKeyDown(Enum.KeyCode.W) then
			return
		end

		local PlayerModel = Player.Character
		local Humanoid = PlayerModel and PlayerModel:FindFirstChildOfClass("Humanoid")
		if not Humanoid or Humanoid.Health <= 0 then
			return
		end

		local SeatPart = Humanoid.SeatPart
		if not SeatPart or not SeatPart:IsA("VehicleSeat") or not SeatPart:IsDescendantOf(workspace) then
			return
		end

		if SeatPart.AssemblyMass == math.huge then
			return
		end

		-- Match the original multiplier at 60 FPS, independent of frame rate.
		local Multiplier = (1 + VelocityMult) ^ (DeltaTime * 60)
		local Velocity = SeatPart.AssemblyLinearVelocity
		SeatPart.AssemblyLinearVelocity = Vector3.new(Velocity.X * Multiplier, Velocity.Y, Velocity.Z * Multiplier)
	end

	table.insert(Connections, RunService.Heartbeat:Connect(UpdateCarSpeed))

	hub.Page.Destroying:Connect(function()
		Alive = false
		for _, Connection in ipairs(Connections) do
			Connection:Disconnect()
		end
		ClearForce()
		RestoreCornerCuts()
		-- Preserve objects whose original parent is temporarily absent.
		if #HolderFolder:GetChildren() == 0 then
			HolderFolder:Destroy()
		end
	end)
end
