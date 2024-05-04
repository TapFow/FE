local Effect = tostring(_G.Effect) or "Rainbow" ---// "Rainbow" , "White_Shine" , "Shine"

--// this is ONLY for "White_Shine"
local Red, Green, Blue = 224 , 50 , 50 --// if you are using "Shine", make sure Green + 100 or Blue + 100 isnt superior than 255
local StartRGB = Color3.fromRGB(Red, Green, Blue)

--// this is ONLY for "Shine"
local EndRGB = Color3.fromRGB(Red, Green + 100, Blue + 100)


local CoreGui 		= game:GetService("CoreGui")
local RunService 	= game:GetService("RunService")
local TweenService	= game:GetService("TweenService"); local ts = TweenService

if CoreGui:FindFirstChild("FPS_GUI") then CoreGui:FindFirstChild("FPS_GUI"):Destroy() task.wait() end

local FPS = Instance.new("ScreenGui")
local fps_counter = Instance.new("TextLabel")
local corner = Instance.new("UICorner")

FPS.Name = "FPS_GUI"
FPS.Parent = CoreGui
FPS.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

fps_counter.Name = "FPS_COUNTER"
fps_counter.Parent = FPS
fps_counter.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
fps_counter.BackgroundTransparency = 0.500
fps_counter.BorderSizePixel = 0
fps_counter.TextColor3 = Color3.fromRGB(255 , 255 , 255)
fps_counter.Position = UDim2.new(0, 104, 0, -32)
fps_counter.Size = UDim2.new(0, 75, 0, 32)
fps_counter.Font = Enum.Font.Gotham
fps_counter.Text = "FPS | 60"
fps_counter.TextSize = 14.000

corner.Name = "FPS_CORNER"
corner.Parent = fps_counter

local gradient : UIGradient = Instance.new("UIGradient", fps_counter)

local numberSequence = NumberSequence.new{
	NumberSequenceKeypoint.new(0 , 0),
	NumberSequenceKeypoint.new(1 , 0)
}

gradient.Offset = Vector2.new(0 , 0)
gradient.Rotation = 0
gradient.Transparency = numberSequence

gradient.Archivable = true
gradient.Name = "FPS_GRADIENT"

---// handle the effect | taken out of :
--[[
https://devforum.roblox.com/t/4-uigradient-animations-including-rainbow/557922 : Rainbow & White_Shine (code stolen)
https://devforum.roblox.com/t/uigradient-animation/2637300 : Shine (example)
--]]

if Effect == nil or Effect == "Rainbow" or Effect == "" then
	task.spawn(function()
		local TweenInfos = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
		local TweenParams = {Offset = Vector2.new(1, 0)}
		local CreatedTween = TweenService:Create(gradient, TweenInfos, TweenParams)
		local StartingV2Pos = Vector2.new(-1, 0)
		local list = {}
		local s, kpt = ColorSequence.new, ColorSequenceKeypoint.new
		local counter = 0
		local status = "down"

		gradient.Offset = StartingV2Pos

		local function rainbowColors()

			local sat, val = 255, 255

			for i = 1, 15 do

				local hue = i * 17
				table.insert(list, Color3.fromHSV(hue / 255, sat / 255, val / 255))

			end

		end

		rainbowColors()

		gradient.Color = s({
			kpt(0, list[#list]),
			kpt(0.5, list[#list - 1]),
			kpt(1, list[#list - 2])
		})

		counter = #list

		local function animate()

			CreatedTween:Play()
			CreatedTween.Completed:Wait()
			gradient.Offset = StartingV2Pos
			gradient.Rotation = 180

			if counter == #list - 1 and status == "down" then

				gradient.Color = s({

					kpt(0, gradient.Color.Keypoints[1].Value),
					kpt(0.5, list[#list]),
					kpt(1, list[1])

				})

				counter = 1
				status = "up"

			elseif counter == #list and status == "down" then

				gradient.Color = s({

					kpt(0, gradient.Color.Keypoints[1].Value),
					kpt(0.5, list[1]),
					kpt(1, list[2])

				})

				counter = 2
				status = "up"

			elseif counter <= #list - 2 and status == "down" then 

				gradient.Color = s({

					kpt(0, gradient.Color.Keypoints[1].Value),
					kpt(0.5, list[counter + 1]),
					kpt(1, list[counter + 2])

				})

				counter = counter + 2
				status = "up"

			end

			CreatedTween:Play()
			CreatedTween.Completed:Wait()
			gradient.Offset = StartingV2Pos
			gradient.Rotation = 0

			if counter == #list - 1 and status == "up" then

				gradient.Color = s({

					kpt(0, list[1]),
					kpt(0.5, list[#list]),
					kpt(1, gradient.Color.Keypoints[3].Value)

				})

				counter = 1
				status = "down"

			elseif counter == #list and status == "up" then

				gradient.Color = s({

					kpt(0, list[2]),
					kpt(0.5, list[1]),
					kpt(1, gradient.Color.Keypoints[3].Value)

				})

				counter = 2
				status = "down"

			elseif counter <= #list - 2 and status == "up" then

				gradient.Color = s({

					kpt(0, list[counter + 2]),
					kpt(0.5, list[counter + 1]),
					kpt(1, gradient.Color.Keypoints[3].Value)

				})

				counter = counter + 2
				status = "down"

			end

			animate()

		end

		animate()

	end)
	
elseif Effect == "White_Shine" then
	task.spawn(function()
		local colorSequence = ColorSequence.new{
			ColorSequenceKeypoint.new(0, StartRGB),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(240, 240, 240)),
			ColorSequenceKeypoint.new(1, StartRGB)
		}
		
		gradient.Color = colorSequence
		
		
		local ti = TweenInfo.new(1, Enum.EasingStyle.Circular, Enum.EasingDirection.Out)
		local offset1 = {Offset = Vector2.new(1, 0)}
		local create = ts:Create(gradient, ti, offset1)
		local startingPos = Vector2.new(-1, 0)
		local addWait = 2.5

		gradient.Offset = startingPos

		local function animate()

			create:Play()
			create.Completed:Wait()
			gradient.Offset = startingPos
			create:Play()
			create.Completed:Wait()
			gradient.Offset = startingPos
			wait(addWait)
			animate()

		end

		animate()
	end)
	
elseif Effect == "Shine" then
	task.spawn(function()
		local colorSequence = ColorSequence.new{
			ColorSequenceKeypoint.new(0, StartRGB),
			ColorSequenceKeypoint.new(0.5, EndRGB),
			ColorSequenceKeypoint.new(1, StartRGB)
		}

		gradient.Color = colorSequence


		local ti = TweenInfo.new(1, Enum.EasingStyle.Circular, Enum.EasingDirection.Out)
		local offset1 = {Offset = Vector2.new(1, 0)}
		local create = ts:Create(gradient, ti, offset1)
		local startingPos = Vector2.new(-1, 0)
		local addWait = 2.5

		gradient.Offset = startingPos

		local function animate()

			create:Play()
			create.Completed:Wait()
			gradient.Offset = startingPos
			create:Play()
			create.Completed:Wait()
			gradient.Offset = startingPos
			wait(addWait)
			animate()

		end

		animate()
	end)

end


local FPS = 0

local Time = tick()

task.spawn(function()
	while RunService.RenderStepped:Wait() do
		local Transcurrido = math.abs(Time-tick())
		Time = tick()
		FPS = math.floor(1/Transcurrido)
	end
end)

while task.wait(0.5) do
	fps_counter.Text = "FPS | "..tostring(FPS) 
end
