	fun=tick()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/TypicallyAUser/random-stuff/main/4eyesnetlib.lua"))()

	Network.CharacterRelative = false

	--Network["Velocity"]=Vector3.new(0,0,0)

	coroutine.resume(Network["PartOwnership"]["Enable"])

	--wxrn("[MINT]: Net Library loaded.")

	getgenv().Modes = {
		--Default Options
		PermanentDeath = true; -- self explanitory
		HealthHidden = false; -- doesnt work if headless is on
		Headless = false; -- needs perma on
		Animations = false; -- self explanitory
		PublicOffense = false; -- r6 needs mizaru (r15 works just find a torso hat)
		Embarrassment = false; -- cool
		--Extras Added In By Lay.
		FakeLimbs = false;
		Fling = false;
		Bullet = true;
	}

	--wxrn("[MINT]: Here are your settings:\nPermanent Death : "..tostring(Modes.PermanentDeath).."\nHealth Hidden : "..tostring(Modes.HealthHidden).."\nNo Head : "..tostring(Modes.Headless).."\nAnimations : "..tostring(Modes.Animations).."\nPublic Offense (Hat Collisions) : "..tostring(Modes.PublicOffense).."\nEmbarrassment (Fake Head Movement) : "..tostring(Modes.Embarrassment))

	loadstring(game:HttpGet("https://raw.githubusercontent.com/TypicallyAUser/TypicalsConvertingLibrary/main/renameallhatclones"))()
	local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/TypicallyAUser/TypicalsConvertingLibrary/main/Main"))()
	Stopped=false
	local R15toR6
	local Player = game.Players.LocalPlayer
	local Character = Player.Character
	Character.Archivable = true

	for i,v in next, Character.Humanoid:GetPlayingAnimationTracks() do
		v:Stop()
	end

	Character.Animate:Remove()

	if Character:FindFirstChild("Torso") then
		R15toR6 = false
		--print("Turned off r15 to r6. ur r6")
	else
		R15toR6=true
		--Modes.PublicOffense = false
		Modes.Embarrassment=false
	end

	local Dummy = game:GetObjects("rbxassetid://5195737219")[1]


	Dummy.Parent = workspace

	Character.Parent = Dummy

	Dummy.HumanoidRootPart.Anchored=false
	Dummy.HumanoidRootPart.CFrame=Character.HumanoidRootPart.CFrame

	game.RunService.Heartbeat:Connect(function()
		for i,v in pairs(Character:GetChildren()) do
			if not Modes.Fling then
				if v:IsA("BasePart") then
					v.RotVelocity = Vector3.new(0,0,0)
				end
			elseif Modes.Fling and not Modes.PublicOffense then
				if v:IsA("BasePart") and v.Name~="LowerTorso" and v.Name~="HumanoidRootPart" then
					v.RotVelocity = Vector3.new(0,0,0)
				end
			elseif Modes.PublicOffense then
				if v:IsA("BasePart") then
					v.RotVelocity = Vector3.new(0,0,0)
				end
			end
		end
	end)

	local NoclipLoop
	NoclipLoop = game.RunService.Stepped:Connect(function()
		if Stopped then NoclipLoop:Disconnect() end
		for i,v in pairs(Character:GetDescendants()) do
			if v:IsA("BasePart") or v:IsA("MeshPart") then
				v.CanCollide=false
			end
		end
		for i,v in pairs(Dummy:GetChildren()) do
			if R15toR6 then break end
			if v:IsA("Accessory") then
				if not v then return end
				if not v.Handle:FindFirstChildOfClass("SpecialMesh") then
					Library.RemoveMesh(Character:FindFirstChild(v.Name):FindFirstChild("Handle"))
				end
			end
		end
	end)

	RemoveJoints=function(model)
		local torso = model:FindFirstChild("Torso")
		if not torso then
			for i,v in pairs(model:GetChildren()) do
				if v:IsA("MeshPart") and v.Name~='Head' then
					for i,v in pairs(v:GetChildren()) do
						if v:IsA("Motor6D") then
							v:Remove()
						end
					end
				end
			end
		else
			for i,v in pairs(torso:GetChildren()) do
				if v:IsA("Motor6D") and v.Name~='Neck' then
					v:Remove()
				end
			end
			model.HumanoidRootPart:BreakJoints()
		end
		--wxrn("[MINT]: Removed joints in player.")
	end

	local Hat = {
		Rename = function(HatID, NAME)
			for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
				if v:IsA("Accessory") then
					if game.Players.LocalPlayer.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
						if v.Handle:FindFirstChildWhichIsA("SpecialMesh").TextureId == HatID then
							v.Name = NAME
						end
					elseif game.Players.LocalPlayer.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and v.Handle.TextureId == HatID then
						v.Name = NAME
					elseif game.Players.LocalPlayer.Character.Humanoid.RigType == Enum.HumanoidRigType.R15 then
						if v.Handle.TextureID == HatID then
							v.Name = NAME
						end
					end
				end
			end
		end}
	if Modes.PublicOffense then
		Hat.Rename("http://www.roblox.com/asset/?id=5063401240", "FlingBlock")
	elseif Modes.FakeLimbs and R15toR6 then
		Hat.Rename("http://www.roblox.com/asset/?id=11263219250", "Grey unloaded head")
	end

	local Loops={}

	function AddLoop(func)
		table.insert(Loops,func)
	end

	function AddJitterless(instance)
		local Loop
		Network.RetainPart(instance)

		local BodyForce = Instance.new("BodyForce",instance)
		BodyForce.Force=Vector3.new(50,50,50)
		local BodyVelocity = Instance.new("BodyVelocity",instance)
		Loop = game.RunService.Heartbeat:Connect(function()
			if Stopped then Loop:Disconnect() end
			if not instance then Loop:Disconnect() end
			instance.AssemblyLinearVelocity = Vector3.new(
				Dummy.HumanoidRootPart.AssemblyLinearVelocity.X*5,
				25.1,-- Y value
				Dummy.HumanoidRootPart.AssemblyLinearVelocity.Z*5)
			BodyVelocity.Velocity=Dummy.HumanoidRootPart.Velocity*2
		end)
	end

	CFrameAlignment=function(Part0,Part1,Position,Angle)
		local Attachment2 = Instance.new("Attachment",Part0)
		Attachment2.Name="mainattachment"
		local URMOTHERR
		AddJitterless(Part0)
		Attachment2.Position = Position or Vector3.new(0,0,0)
		Attachment2.Orientation = Angle or Vector3.new(0,0,0)
		URMOTHERR=game.RunService.Heartbeat:Connect(function()
			if Stopped then URMOTHERR:Disconnect() end
			if Part0:FindFirstChild("mainattachment") then
				Part0.CFrame=Part1.CFrame*Attachment2.CFrame
			else
				URMOTHERR:Disconnect()
			end
		end)
		return {Attachment2}
	end
	CFrameAlignmentAgain=function(Part0,Part1,Position,Angle)
		local Attachment2 = Instance.new("Attachment",Part0)
		Attachment2.Name="mainattachment"
		local URMOTHERR
		AddJitterless(Part0)
		Attachment2.Position = Position or Vector3.new(0,0,0)
		Attachment2.Orientation = Angle or Vector3.new(0,0,0)
		URMOTHERR=game.RunService.Heartbeat:Connect(function()
			if Stopped then URMOTHERR:Disconnect() end
			if Part0:FindFirstChild("mainattachment") then
				Part0.CFrame=Part1.CFrame*Attachment2.CFrame
			else
				URMOTHERR:Disconnect()
			end
		end)
		return {Attachment2}
	end
	-- /// R6 HERE
	if R15toR6 == false then
		if Modes.PublicOffense == true then
			Modes.PermanentDeath=true
		end
		if Modes.Embarrassment then
			Modes.PermanentDeath=false
			Modes.PublicOffense=false
		end
		for i,v in pairs(Character:GetChildren()) do
			if v:IsA("Accessory") then
				local Clone = v:Clone()
				Clone.Parent=Dummy
				Clone.Handle.Transparency = 1
				Clone.Handle.AccessoryWeld.Part1=Dummy[v.Handle.AccessoryWeld.Part1.Name]
				v.Handle.AccessoryWeld:Remove()
				if not Modes.PublicOffense and not Modes.Embarrassment and not Modes.FakeLimbs then
					CFrameAlignmentAgain(v.Handle,Clone.Handle)
				else
					if Modes.PublicOffense and not Modes.FakeLimbs and v.Name~="Star ManAccessory" then
						CFrameAlignmentAgain(v.Handle,Clone.Handle)
					elseif Modes.PublicOffense and Modes.FakeLimbs and v.Name~="Star ManAccessory" and v.Name~="Kate Hair" and v.Name~="Pal Hair" and v.Name~="Hat1" and v.Name~="LavanderHair" then
						CFrameAlignmentAgain(v.Handle,Clone.Handle)
					elseif not Modes.PublicOffense and Modes.FakeLimbs and v.Name~="Star ManAccessory" and v.Name~="Kate Hair" and v.Name~="Pal Hair" and v.Name~="Hat1" and v.Name~="LavanderHair" then
						CFrameAlignmentAgain(v.Handle,Clone.Handle)
					end
					if Modes.Embarrassment and v.Name~="Star ManAccessory" then
						CFrameAlignmentAgain(v.Handle,Clone.Handle)
					end
				end
			end
		end

		RemoveJoints(Character)

		AddJitterless(Character.Head)
		CFrameAlignment(Character['HumanoidRootPart'],Dummy['HumanoidRootPart'])
		if not Modes.Embarrassment then
			CFrameAlignment(Character['Torso'],Dummy['Torso'])
		else
			local cool = Character["Star ManAccessory"].Handle
			Library.RemoveMesh(cool)
			cool:BreakJoints()
			CFrameAlignment(cool,Dummy.Torso,Vector3.new(),Vector3.new(90,0,0))
			--wxrn("[MINT]: Embarrassment mode loaded successfully.")
			CFrameAlignment(Character['Torso'],Dummy['Head'],Vector3.new(0,-1.5,0))
		end
		if not Modes.FakeLimbs then
			CFrameAlignment(Character['Right Arm'],Dummy['Right Arm'])
			CFrameAlignment(Character['Left Arm'],Dummy['Left Arm'])
			CFrameAlignment(Character['Right Leg'],Dummy['Right Leg'])
			CFrameAlignment(Character['Left Leg'],Dummy['Left Leg'])
		elseif not Modes.FakeLegLeg then
			CFrameAlignment(Character['Right Arm'],Dummy['Right Arm'])
			CFrameAlignment(Character['Left Arm'],Dummy['Left Arm'])
			CFrameAlignment(Character['Right Leg'],Dummy['Right Leg'])
			CFrameAlignment(Character['Left Leg'],Dummy['Left Leg'])
		elseif Modes.FakeLimbs then
			local Y1 = Character['Star ManAccessory'].Handle local Y2 = Character['Kate Hair'].Handle
			local Y3 = Character['Pal Hair'].Handle local Y4 = Character['Hat1'].Handle
			local Y5 = Character['LavanderHair'].Handle
			Y1:BreakJoints() Y2:BreakJoints() Y3:BreakJoints() Y4:BreakJoints() Y5:BreakJoints() 
			Library.RemoveMesh(Y1) Library.RemoveMesh(Y2) Library.RemoveMesh(Y3) Library.RemoveMesh(Y4) Library.RemoveMesh(Y5)
			CFrameAlignmentAgain(Y1,Dummy['Torso'],Vector3.new(0,0,0),Vector3.new(0,0,0))
			CFrameAlignmentAgain(Y2,Dummy['Right Arm'],Vector3.new(0,0,0),Vector3.new(90,0,0))
			CFrameAlignmentAgain(Y3,Dummy['Left Arm'],Vector3.new(0,0,0),Vector3.new(90,0,0))
			CFrameAlignmentAgain(Y4,Dummy['Right Leg'],Vector3.new(0,0,0),Vector3.new(90,0,0))
			CFrameAlignmentAgain(Y5,Dummy['Left Leg'],Vector3.new(0,0,0),Vector3.new(90,0,0))
		end

		local Head

		local headnothiding = true

		Head=game:GetService("RunService").Heartbeat:Connect(function()
			if Stopped then Head:Disconnect() end
			if Modes.PermanentDeath and not Modes.Headless then
				if headnothiding then
					Character.Head.CFrame=Dummy.Head.CFrame
				end
			end
		end)

		if Modes.HealthHidden==true and not Modes.Headless and Modes.PermanentDeath == true then
			spawn(function()
				while not Stopped do
					wait(5)
					--print("Hiding")
					local curpos = Character.Head.Position
					headnothiding=false
					Character.Head.Position=Vector3.new(5000,5000,5000)
					wait(.1)
					Character.Head.Position=curpos
					headnothiding=true
				end
			end)
		end

		task.spawn(function()
			if Modes.PermanentDeath and not Modes.PublicOffense then
				--wxrn("[MINT]: Loading permanent death...")
				game.Players.LocalPlayer.Character=nil
				game.Players.LocalPlayer.Character=Dummy
				wait(game.Players.RespawnTime+.15)
				Character:BreakJoints()
				if Modes.Headless then
					Character.Head:Remove()
				end
				--wxrn("[MINT]: Reanimation successfully ran!")
			elseif Modes.PublicOffense then
				--wxrn("[MINT]: Loading permanent death for hat collide...")
				local cool = Character["Star ManAccessory"].Handle
				Library.RemoveMesh(cool)
				CFrameAlignmentAgain(cool,Dummy.Torso,Vector3.new(),Vector3.new(0,0,0))
				game.Players.LocalPlayer.Character=nil
				game.Players.LocalPlayer.Character=Dummy
				wait(game.Players.RespawnTime+.15)
				Character:BreakJoints()
				if Modes.Headless then
					Character.Head:Remove()
				end
				Character.Torso:Remove()
				Character.HumanoidRootPart:Destroy()
				for i,v in pairs(Character:GetChildren()) do
					if v:IsA("Accessory") then
						sethiddenproperty(v,"BackendAccoutrementState", 0)
					end
				end
				local Clone=Character["Body Colors"]:Clone()
				Character["Body Colors"]:Remove()
				Clone.Parent=Character
				--wxrn("[MINT]: Reanimation successfully ran!")
			else
				--wxrn("[MINT]: Reanimation successfully ran!")
			end
		end)

	end

	-- /// R15 HERE
	if R15toR6 then

		if Modes.PublicOffense == true then
			Modes.PermanentDeath=true
		end

		for i,v in pairs(Character:GetChildren()) do
			if v:IsA("Accessory") then
				local Clone = v:Clone()
				Clone.Parent=Dummy
				Clone.Handle.Transparency = 1
				if v.Handle.AccessoryWeld.Part1.Name == "Head" then
					Clone.Handle.AccessoryWeld.Part1=Dummy[v.Handle.AccessoryWeld.Part1.Name]
				elseif v.Handle.AccessoryWeld.Part1.Name == "LowerTorso" or v.Handle.AccessoryWeld.Part1.Name == "UpperTorso" then
					Clone.Handle.AccessoryWeld.Part1=Dummy.Torso
				end
				v.Handle.AccessoryWeld:Remove()
			end
		end

		RemoveJoints(Character)

		Dummy["Left Leg"].Size = Vector3.new(0,1.9,0)
		Dummy["Right Leg"].Size = Vector3.new(0,1.9,0)

		AddJitterless(Character.Head)
		--CFrameAlignment(Character["Head"],Dummy["Head"],Vector3.new(0,0,0))
		CFrameAlignment(Character["HumanoidRootPart"],Dummy["HumanoidRootPart"],Vector3.new(0,0,0))

		CFrameAlignment(Character["UpperTorso"],Dummy["Torso"],Vector3.new(0,.22,0))
		CFrameAlignment(Character["LowerTorso"],Dummy["Torso"],Vector3.new(0,-0.68,0))

		if not Modes.FakeLimbs then
			CFrameAlignment(Character["RightUpperLeg"],Dummy["Right Leg"],Vector3.new(0,.6,0))
			CFrameAlignment(Character["RightLowerLeg"],Dummy["Right Leg"],Vector3.new(0,-0.15,0))
			CFrameAlignment(Character["RightFoot"],Dummy["Right Leg"],Vector3.new(0,-0.72,0))

			CFrameAlignment(Character["LeftUpperLeg"],Dummy["Left Leg"],Vector3.new(0,.6,0))
			CFrameAlignment(Character["LeftLowerLeg"],Dummy["Left Leg"],Vector3.new(0,-0.15,0))
			CFrameAlignment(Character["LeftFoot"],Dummy["Left Leg"],Vector3.new(0,-0.72,0))

			CFrameAlignment(Character["RightUpperArm"],Dummy["Right Arm"],Vector3.new(0,.415,0))
			CFrameAlignment(Character["RightLowerArm"],Dummy["Right Arm"],Vector3.new(0,-0.175,0))
			CFrameAlignment(Character["RightHand"],Dummy["Right Arm"],Vector3.new(0,-0.72,0))

			CFrameAlignment(Character["LeftUpperArm"],Dummy["Left Arm"],Vector3.new(0,.415,0))
			CFrameAlignment(Character["LeftLowerArm"],Dummy["Left Arm"],Vector3.new(0,-0.175,0))
			CFrameAlignment(Character["LeftHand"],Dummy["Left Arm"],Vector3.new(0,-0.72,0))
		else
			CFrameAlignmentAgain(Character['Unloaded head'].Handle,Dummy['Right Arm'],Vector3.new(0,0,0),Vector3.new(0,-90,90))
			CFrameAlignmentAgain(Character['Yellow unloaded head'].Handle,Dummy['Left Arm'],Vector3.new(0,0,0),Vector3.new(0,90,90))
			CFrameAlignmentAgain(Character['Grey unloaded head'].Handle,Dummy['Right Leg'],Vector3.new(0,0,0),Vector3.new(0,-90,90))

			CFrameAlignmentAgain(Character['Left Shoulder Ink'].Handle,Dummy['Left Leg'],Vector3.new(0,0.4,0),Vector3.new(0,0,0))
			CFrameAlignmentAgain(Character['Right Shoulder Ink'].Handle,Dummy['Left Leg'],Vector3.new(0,-0.325,0),Vector3.new(180,90,0))
		end

		local something

		for i,v in pairs(Character:GetChildren()) do
			if v:IsA("Accessory") then
				if not Modes.FakeLimbs and not Modes.PublicOffense then
					CFrameAlignmentAgain(v.Handle,Dummy[v.Name].Handle)
				elseif not Modes.FakeLimbs and Modes.PublicOffense and v.Name~="Tetra-Suit" then
					CFrameAlignmentAgain(v.Handle,Dummy[v.Name].Handle)
				elseif Modes.FakeLimbs and v.Name~="Tetra-Suit" and v.Name~="Unloaded head" and v.Name~="Yellow unloaded head" and v.Name~="Grey unloaded head" and v.Name~="Right Shoulder Ink" and v.Name~="Left Shoulder Ink" then
					CFrameAlignmentAgain(v.Handle,Dummy[v.Name].Handle)
				end
			end
		end



		local Head

		local headnothiding = true

		Head=game:GetService("RunService").Heartbeat:Connect(function()
			if Stopped then Head:Disconnect() end
			for i,v in next, Character.Humanoid:GetPlayingAnimationTracks() do
				v:Stop()
			end
			if Modes.PermanentDeath and not Modes.Headless then
				if headnothiding then
					Character.Head.CFrame=Dummy.Head.CFrame
				end
			end
		end)
		if Modes.HealthHidden==true and not Modes.Headless and Modes.PermanentDeath then
			spawn(function()
				while not Stopped do
					wait(5)
					--print("Hiding")
					local curpos = Character.Head.Position
					headnothiding=false
					Character.Head.Position=Vector3.new(5000,5000,5000)
					wait(.1)
					Character.Head.Position=curpos
					headnothiding=true
				end
			end)
		end

		task.spawn(function()
			if Modes.PermanentDeath and not Modes.PublicOffense then
				--wxrn("[MINT]: Loading permanent death...")
				game.Players.LocalPlayer.Character=nil
				game.Players.LocalPlayer.Character=Dummy
				wait(game.Players.RespawnTime+.15)
				Character:BreakJoints()
				if Modes.Headless then
					Character.Head:Remove()
				end
				--wxrn("[MINT]: Reanimation successfully ran!")
			elseif Modes.PublicOffense then
				--wxrn("[MINT]: Loading permanent death for hat collide...")
				local cool = Character["Tetra-Suit"].Handle
				cool:BreakJoints()
				CFrameAlignmentAgain(cool,Dummy.Torso,Vector3.new(0,0,0),Vector3.new(0,0,0))
				game.Players.LocalPlayer.Character=nil
				game.Players.LocalPlayer.Character=Dummy
				wait(game.Players.RespawnTime+.15)
				Character:BreakJoints()
				Character.UpperTorso:Remove()
				Character.LowerTorso:Remove()
				Character.HumanoidRootPart:Destroy()
				for i,v in pairs(Character:GetChildren()) do
					if v:IsA("Accessory") then
						sethiddenproperty(v,"BackendAccoutrementState", 0)
					end
				end
				local Clone=Character["Body Colors"]:Clone()
				Character["Body Colors"]:Remove()
				Clone.Parent=Character
				--wxrn("[MINT]: Reanimation successfully ran!")
			else
				--wxrn("[MINT]: Reanimation successfully ran!")
			end
		end)

	end

	local oldCF=workspace.Camera.CFrame

	Player.Character=Dummy
	workspace.CurrentCamera.CameraSubject = Dummy.Humanoid

	workspace.Camera:GetPropertyChangedSignal("CFrame"):wait()
	workspace.Camera.CameraType="Scriptable"
	workspace.Camera.CFrame=oldCF
	workspace.Camera.CameraType="Custom"

	local CharAdd

	CharAdd=Player.CharacterAdded:Connect(function(carlos)
		if carlos ~= Dummy and carlos then
			Dummy:Remove()
			Stopped=true
			for i,v in pairs(Loops) do
				v:Disconnect()
			end
		end
	end)

	if Modes.Animations then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/TypicallyAUser/TypicalsConvertingLibrary/main/Animations"))().R6(Dummy.Animate)
		--wxrn("[MINT]: Animation script loaded.")
	else
		--wxrn("[MINT]: Animation script not loaded. Enable the setting Animations inside of the modes table!")
	end
	--wxrn("[MINT]: Ran main reanimation in "..tostring(tick()-fun.."."))
	wait(.1)

	flinging = false
	shooting = false
	local posoffling
	local FlingBlock
	local Mouse = Player:GetMouse()
	function FlingConnection(character)
		if character == Dummy then return end
		if character == Character then return end
		if not character then return end
		if not character:FindFirstChild("HumanoidRootPart") then return end
		flinging = true
		posoffling = character.HumanoidRootPart.Position
		delay(1, function() flinging = false end)
	end

	if Modes.Bullet then
		xxBullet = Character["TooCoolFireFox"].Handle
		--FlingBlock:BreakJoints()
		xxBullet.HatAttachment:Remove()
		xxBullet.BodyForce:Remove()
		xxBullet.BodyVelocity:Remove()
		if not R15toR6 then
			xxBullet.SpecialMesh:Remove()
		end

		local bav = Instance.new("BodyAngularVelocity", xxBullet)
		bav.P = 1250
		bav.AngularVelocity = Vector3.new(99999999,99999999,99999999)
		bav.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)

		local wowz
		wowz=game.RunService.Heartbeat:Connect(function()
			if Stopped then
				wowz:Disconnect()
			end
			if not shooting then
				xxBullet.Position = Dummy.HumanoidRootPart.Position + Vector3.new(0,-45,0)
			else
				xxBullet.Position = bulposoffling
			end
		end)
	end

--[[
spawn(function()
while wait() do
    repeat wait() until shooting == true
	if shooting == true then
	    repeat
	    xxBullet.Position = Mouse.Hit.p
		wait(.01)
		xxBullet.Position = LocalCharacter.Torso.Position
		wait(.001)
	    until shooting == false
	end
end
end)
]]

	if Modes.Fling then
		if not R15toR6 then
			if Modes.PermanentDeath and not Modes.PublicOffense and not R15toR6 then -- goofiness
				FlingBlock = Character["HumanoidRootPart"]
				if Modes.Fling then
					local greatness
					--FlingBlock:BreakJoints()
					FlingBlock.mainattachment:Remove()
					FlingBlock.BodyForce:Remove()
					FlingBlock.BodyVelocity:Remove()
					FlingBlock.Transparency = .4
					local bav = Instance.new("BodyAngularVelocity", FlingBlock)

					bav.P = 1250

					bav.AngularVelocity = Vector3.new(99999999,99999999,99999999)

					bav.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
					greatness=game.RunService.Heartbeat:Connect(function()
						if Stopped then
							greatness:Disconnect()
						end
						if not flinging then
							FlingBlock.Position = Dummy.HumanoidRootPart.Position + Vector3.new(0,-45,0)
						else
							FlingBlock.Position = posoffling
						end

					end)

				end
			elseif not Modes.PermanentDeath and not Modes.PublicOffense and not R15toR6 then
				FlingBlock = Character["Right Arm"]
				Character.Humanoid:ChangeState("Physics")
				if Modes.Fling and not R15toR6 then
					if not Character:FindFirstChild("Pal Hair") then
						Library.Notification("Mint","Hey! The fling in this script will not operate due to you not having the Pal Hair accessory on! Make sure you have it equipped!")
						return
					end
					local greatness
					FlingBlock:BreakJoints()
					FlingBlock.mainattachment:Remove()
					FlingBlock.BodyForce:Remove()
					FlingBlock.BodyVelocity:Remove()
					FlingBlock.Transparency = .4
					local bav = Instance.new("BodyAngularVelocity", FlingBlock)

					bav.P = 1250

					bav.AngularVelocity = Vector3.new(99999999,99999999,99999999)

					bav.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
					greatness=game.RunService.Heartbeat:Connect(function()
						if Stopped then
							greatness:Disconnect()
						end
						if not flinging then
							FlingBlock.Position = Dummy.HumanoidRootPart.Position + Vector3.new(0,-45,0)
						else
							FlingBlock.Position = posoffling
						end

					end)

				end
			elseif Modes.PermanentDeath and Modes.PublicOffense and not R15toR6 then
				FlingBlock = Character["FlingBlock"].Handle
				if Modes.Fling then
					local greatness
					FlingBlock:BreakJoints()
					FlingBlock.mainattachment:Remove()
					FlingBlock.BodyForce:Remove()
					FlingBlock.BodyVelocity:Remove()
					FlingBlock.SpecialMesh:Remove()
					FlingBlock.Transparency = .4

					local bav = Instance.new("BodyAngularVelocity", FlingBlock)
					bav.P = 1250
					bav.AngularVelocity = Vector3.new(99999999,99999999,99999999)
					bav.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)

					greatness=game.RunService.Heartbeat:Connect(function()
						if Stopped then
							greatness:Disconnect()
						end
						if not flinging then
							FlingBlock.Position = Dummy.Torso.Position + Vector3.new(0,-45,0)
						else
							FlingBlock.Position = posoffling
						end
					end)
				end
			end
		elseif R15toR6 then
			if not Modes.PublicOffense and R15toR6 then
				if Modes.Fling then
					Rep=Character["Neck Ink"].Handle
					Rep:BreakJoints()
					Rep.mainattachment:Remove()
					Rep.BodyForce:Remove()
					Rep.BodyVelocity:Remove()
					wait(0.1)
					CFrameAlignment(Rep,Dummy.Torso,Vector3.new(0,-0.3,0),Vector3.new(0,0,-180))

					FlingBlock = Character["LowerTorso"]
					local greatness
					FlingBlock:BreakJoints()
					FlingBlock.mainattachment:Remove()
					FlingBlock.BodyForce:Remove()
					FlingBlock.BodyVelocity:Remove()
					FlingBlock.Transparency = .4

					local bav = Instance.new("BodyAngularVelocity", FlingBlock)
					bav.P = 1250
					bav.AngularVelocity = Vector3.new(99999999,99999999,99999999)
					bav.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)

					greatness=game.RunService.Heartbeat:Connect(function()
						if Stopped then
							greatness:Disconnect()
						end
						if not flinging then
							FlingBlock.Position = Dummy.Torso.Position + Vector3.new(0,-10,0)
							bav.AngularVelocity = Vector3.new(99999999,99999999,99999999)
						else
							FlingBlock.Position = posoffling
							bav.AngularVelocity = Vector3.new(99999999,99999999,99999999)
						end
					end)
				end
			elseif Modes.PublicOffense and R15toR6 then
				FlingBlock = Character["FlingBlock"].Handle
				if Modes.Fling then
					local greatness
					FlingBlock.mainattachment:Remove()
					FlingBlock.BodyForce:Remove()
					FlingBlock.BodyVelocity:Remove()
					FlingBlock.Transparency = .4

					local bav = Instance.new("BodyAngularVelocity", FlingBlock)
					bav.P = 1250
					bav.AngularVelocity = Vector3.new(99999999,99999999,99999999)
					bav.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)

					greatness=game.RunService.Heartbeat:Connect(function()
						if Stopped then
							greatness:Disconnect()
						end
						if not flinging then
							FlingBlock.Position = Dummy.Torso.Position + Vector3.new(0,-45,0)
						else
							FlingBlock.Position = posoffling
						end
					end)
				end
			else
				Library.Notification("Mint","This script does not have fling compatibility. If this is an error, please contact me at : typicalusername#1444")
			end
		end
	end
	if Modes.Fling and R15toR6==false and not Modes.PermanentDeath then
		local coolnesss=Character:FindFirstChild("Pal Hair")
		--coolnesss.Handle.mainattachment:Remove()
		coolnesss.Handle:BreakJoints()
		Library.RemoveMesh(coolnesss.Handle)
		CFrameAlignment(coolnesss.Handle,Dummy["Right Arm"],Vector3.new(),Vector3.new(90,0,0))
	end
