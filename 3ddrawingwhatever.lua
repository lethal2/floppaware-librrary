local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local function WorldToScreen(pos)
	local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
	return Vector2.new(screenPos.X, screenPos.Y), onScreen
end

local function IsInView(pos)
	return (pos - Camera.CFrame.Position).Unit:Dot(Camera.CFrame.LookVector) > 0
end

local function Draw3DLine(from, to, color, thickness, duration)
	local fadeTime = 0.25 

	local line = Drawing.new("Line")
	line.Color = color or Color3.new(1, 1, 1)
	line.Thickness = thickness or 1
	line.Transparency = 0
	line.ZIndex = 3
	line.Visible = true

	local connection
	local startTime = tick()

	connection = RunService.RenderStepped:Connect(function()
		local now = tick()
		local elapsed = now - startTime
		local remaining = duration - elapsed

		-- where we fade
		if elapsed < fadeTime then
			line.Transparency = math.clamp(elapsed / fadeTime, 0, 1)
		elseif remaining < fadeTime then
			line.Transparency = math.clamp(remaining / fadeTime, 0, 1)
		else
			line.Transparency = 1
		end
      
		local fromScreen, onScreenFrom = WorldToScreen(from)
		local toScreen, onScreenTo = WorldToScreen(to)

		if (onScreenFrom and onScreenTo) or (IsInView(from) and IsInView(to)) then
			line.From = fromScreen
			line.To = toScreen
			line.Visible = true
		else
			line.Visible = false
		end
		if elapsed >= duration then
			connection:Disconnect()
			line:Remove()
		end
	end)
end
