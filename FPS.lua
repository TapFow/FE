--haha chara gave me it so i try to add it :troll:

local RunService = game:GetService("RunService")
function RainbowifyText(name)
	while RunService.Stepped:Wait() do
		for hue = 0, 1, 0.06 do
			name.TextColor3 = Color3.fromHSV(hue, 1, 1)
			wait(0.0005)
		end
	end
end

function randomString()
	local length = math.random(10,20)
	local array = {}
	for i = 1, length do
		array[i] = string.char(math.random(32, 126))
	end
	return table.concat(array)
end

local FPS = Instance.new("ScreenGui")
local fps_counter = Instance.new("TextLabel")
local corner = Instance.new("UICorner")

FPS.Name = randomString()
FPS.Parent = game:GetService("CoreGui")
FPS.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

fps_counter.Name = randomString()
fps_counter.Parent = FPS
fps_counter.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
fps_counter.BackgroundTransparency = 0.500
fps_counter.BorderSizePixel = 0
fps_counter.Position = UDim2.new(0, 104, 0, -32)
fps_counter.Size = UDim2.new(0, 75, 0, 32)
fps_counter.Font = Enum.Font.Gotham
fps_counter.Text = "FPS | 60"
spawn(function() RainbowifyText(fps_counter) end)
fps_counter.TextSize = 14.000

corner.Name = randomString()
corner.Parent = fps_counter

local FPS = 0

local Tiempo = tick()

spawn(function()
    while game:GetService("RunService").RenderStepped:wait() do
        local Transcurrido = math.abs(Tiempo-tick())
        Tiempo = tick()
        FPS = math.floor(1/Transcurrido)
    end
end)

while wait(0.5) do
    fps_counter.Text = "FPS | "..tostring(FPS) 
end
