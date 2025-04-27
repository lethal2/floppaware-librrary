
do -- UI funcs and tables
	local Menu = {}
	local KeyBindList = {}
	local UILibrary = {}
	local UIUtilities = {}
	local OpenCloseItems = {}
	local CheatSections = {}
	local SubSections = {}
	local UIAccents = {}

	local Signal = loadstring(game:HttpGet("https://raw.githubusercontent.com/Quenty/NevermoreEngine/version2/Modules/Shared/Events/Signal.lua"))()

	function UILibrary:Start(Parameters)
			local UIStyle = Parameters
			local ClipboardColor
			-- Important Bullshit
			local RunService = game:GetService("RunService")
			local UserInputService = game:GetService("UserInputService")
			local ReplicatedStorage = game:GetService("ReplicatedStorage")
			local TextService = game:GetService("TextService") 
			local HttpService = game:GetService("HttpService")
			local TweenService = game:GetService("TweenService")
			local Players = game:GetService("Players")
			local Plr = Players.localPlayer
			local Mouse = Plr:GetMouse()
			local fading = false

			function UIUtilities:Create(ClassName, Properties)
					local NewInstance = Instance.new(ClassName)
					for property, value in next, (Properties) do
							NewInstance[property] = value
					end
					return NewInstance
			end

			local function thread(func)
					if type(func) == "function" then return coroutine.resume(coroutine.create(func)) end
			end

			local valid_chars = {}

			local function set_valid(x, y)
					for i = string.byte(x), string.byte(y) do
							table.insert(valid_chars, string.char(i))
					end
			end

			set_valid('a', 'z')
			set_valid('A', 'Z')
			set_valid('0', '9')

			function UIUtilities:random_string(length)
					local s = {}
					for i = 1, length do s[i] = valid_chars[math.random(1, #valid_chars)] end
					return table.concat(s)
			end

			function UIUtilities:Tween(...)
					TweenService:Create(...):Play()
			end

			local function RGBtoHSV(Color)
					local color = Color3.new(Color.R, Color.G, Color.B)
					local h, s, v = color:ToHSV()
					return h, s, v
			end

			local function realWait(n)
					return task.wait(n)
			end
			
			local Core = UIUtilities:Create("ScreenGui", {
					Name = UIUtilities:random_string(math.random(16, 64)),
					DisplayOrder = 6942069,
			})

			Core.Parent = game.CoreGui

			local function AutoApplyBorder(Parented, Suffix, StartZIndex, c1, c2, forgetIt)
					local BorderContainer = UIUtilities:Create("Folder", {
							Name = "Border" .. Suffix,
							Parent = Parented
					})
					local v1 = UIUtilities:Create("Frame", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = c1,
							BorderSizePixel = 0,
							Name = "v1" .. Suffix,
							Parent = BorderContainer,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(1, 2, 1, 2),
							ZIndex = StartZIndex - 1
					})
					local v2 = UIUtilities:Create("Frame", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = c2,
							BorderSizePixel = 0,
							Name = "v2" .. Suffix,
							Parent = v1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(1, 2, 1, 2),
							ZIndex = v1.ZIndex - 1
					})
					if forgetIt then
							table.insert(OpenCloseItems, v1)
							table.insert(OpenCloseItems, v2)
					end
					return BorderContainer, v1, v2
			end

			local function AutoApplyAccent(Parented, Suffix, StartZIndex, forgetIt)
					local Accent = UIUtilities:Create("Frame", {
							AnchorPoint = Vector2.new(0.5, 0),
							BackgroundColor3 = UIStyle.UIcolors.FullWhite,
							BorderSizePixel = 1,
							BorderColor3 = UIStyle.UIcolors.ColorJ,
							Name = "UI",
							Parent = Parented,
							Position = UDim2.new(0.5, 0, 0, -1),
							Size = UDim2.new(1, 0, 0, 2),
							ZIndex = StartZIndex
					})
					if forgetIt then
							table.insert(OpenCloseItems, Accent)
					end
					local Hue, Sat, Val = RGBtoHSV(UIStyle.UIcolors.Accent)
					local color = UIStyle.UIcolors.Accent
					local AccentStyling = UIUtilities:Create("UIGradient", {
							Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, Color3.fromHSV(Hue, Sat, Val)),
									ColorSequenceKeypoint.new(1, Color3.fromRGB(math.clamp(color.R * 255 - 40, 0, 255), math.clamp(color.G * 255 - 40, 0, 255), math.clamp(color.B * 255 - 40, 0, 255)))
							}),
							Rotation = 90,
							Parent = Accent
					})
					table.insert(UIAccents, AccentStyling)
					return Accent, AccentStyling
			end
			
			local isColorThingOpen
			local isColorThingOpen2
			local isDropDownOpen

			UILibrary.tooltip = {}
			do
					local FakeBackGround = UIUtilities:Create("Frame", {
							AnchorPoint = Vector2.new(0, 0),
							BackgroundColor3 = UIStyle.UIcolors.FullWhite,
							BackgroundTransparency = 1,
							BorderColor3 = UIStyle.UIcolors.FullWhite,
							BorderMode = Enum.BorderMode.Outline,
							BorderSizePixel = 0,
							Name = "Event",
							Parent = Core, 
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(0, 0, 0, 0),
							ZIndex = 29
					})
					local EventLogContainer = UIUtilities:Create("Frame", {
							AnchorPoint = Vector2.new(0, 0),
							BackgroundColor3 = UIStyle.UIcolors.FullWhite,
							BackgroundTransparency = 1,
							BorderColor3 = UIStyle.UIcolors.FullWhite,
							BorderMode = Enum.BorderMode.Outline,
							BorderSizePixel = 0,
							Name = "Event",
							Parent = FakeBackGround,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, -4),
							ZIndex = 29
					})
					local fuckingFolder, fuckingThing, fuckingOtherThing = AutoApplyBorder(EventLogContainer, "a", 29, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)
					local BackGroundStyling = UIUtilities:Create("UIGradient", {
							Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, UIStyle.UIcolors.ColorD),
									ColorSequenceKeypoint.new(1, UIStyle.UIcolors.ColorA)
							}),
							Rotation = 90,
							Parent = EventLogContainer
					})
					local BackGroundAccent = UIUtilities:Create("Frame", {
							AnchorPoint = Vector2.new(0, 0),
							BackgroundColor3 = UIStyle.UIcolors.FullWhite,
							BorderSizePixel = 0,
							BackgroundTransparency = 1,
							Name = "UI",
							Parent = EventLogContainer,
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(0, 2, 1, 0),
							ZIndex = 30
					})
					local Hue, Sat, Val = RGBtoHSV(UIStyle.UIcolors.Accent)
					local BackGroundAccentStyling = UIUtilities:Create("UIGradient", {
							Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, Color3.fromHSV(Hue, Sat, Val - 0.1)),
									ColorSequenceKeypoint.new(1, Color3.new(UIStyle.UIcolors.Accent.R, UIStyle.UIcolors.Accent.G, UIStyle.UIcolors.Accent.B))
							}),
							Rotation = 180,
							Parent = BackGroundAccent
					})
					local BackGroundText = UIUtilities:Create("TextLabel", {
							AnchorPoint = Vector2.new(1, 0),
							BackgroundTransparency = 1, 
							Position = UDim2.new(1, 0, 0, 0),
							Parent = EventLogContainer,
							Size = UDim2.new(1, -6, 1, 0),
							ZIndex = 31,
							Font = UIStyle.HeaderFont.Font,
							LineHeight = 1.1,
							Text = "idiot",
							TextColor3 = UIStyle.UIcolors.FullWhite,
							TextSize = UIStyle.HeaderFont.WatermarkTxtSize,
							TextTransparency = 1,
							TextStrokeColor3 = Color3.new(),
							TextStrokeTransparency = 1,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center
					})
					local currentTrans = 1
					local hoverTime = 0
					local bounds = Vector2.new(0, 0)
					local objectPos = Vector2.new(0, 0)
					local loop; loop = RunService.Heartbeat:Connect(function(deltaTime)
							local hovering = Mouse.X > objectPos.X and Mouse.X < objectPos.X + bounds.X and Mouse.Y > objectPos.Y and Mouse.Y < objectPos.Y + bounds.Y and not (isColorThingOpen or isColorThingOpen2 or isDropDownOpen)

							if hovering then
									if hoverTime > 2 then
											currentTrans = math.max(0, currentTrans - deltaTime * 4)
									else
											hoverTime = hoverTime + deltaTime
											currentTrans = 1
									end
							else
									hoverTime = 0
									currentTrans = math.min(1, currentTrans + deltaTime * 8)
							end

							EventLogContainer.BackgroundTransparency = currentTrans
							BackGroundAccent.BackgroundTransparency = currentTrans
							BackGroundText.TextTransparency = currentTrans
							fuckingThing.BackgroundTransparency = currentTrans
							fuckingOtherThing.BackgroundTransparency = currentTrans

							if currentTrans >= 1 then
									return
							end

							BackGroundAccentStyling.Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, Color3.fromHSV(Hue, Sat, Val - 0.1)),
									ColorSequenceKeypoint.new(1, Color3.new(UIStyle.UIcolors.Accent.R, UIStyle.UIcolors.Accent.G, UIStyle.UIcolors.Accent.B))
							})
					end)

					function UILibrary.CallToolTip(msg, showAt, pos, showInside)
							objectPos = showAt
							bounds = showInside

							local Message = msg
							local maxWidth = 30
							local text = Message
							local msgsize = TextService:GetTextSize(Message, UIStyle.HeaderFont.WatermarkTxtSize, UIStyle.HeaderFont.Font, Vector2.new(9999999999999999999999999999999, 0))
							do -- WARNING !! ALAN CODE AHEAD!!
									local split = text:split("")
									local lastspaceidx = 0 -- the text idx that the last space is
									local charinline = 0
									for i, v in next, (split) do
											charinline = charinline + 1
											if v == " " then
													lastspaceidx = i
											end
											if charinline >= maxWidth then
													split[lastspaceidx] = "\n" -- insert a thing
													charinline = 0
											end
									end
									text = ""
									for i, v in next, (split) do
											text = text .. v
									end
							end
							-- ok most of the gayness is over
							local split = text:split("\n")
							local textlinelength = {}
							local verticalLength = 8
							for i, v in next, (split) do
									local d = TextService:GetTextSize(v, UIStyle.HeaderFont.WatermarkTxtSize, UIStyle.HeaderFont.Font, Vector2.new(9999999999999999999999999999999, 0))
									textlinelength[i] = d.x
									verticalLength = verticalLength + d.y
							end
							table.sort(textlinelength, function(a, b) return a > b end)
							local longestthing = textlinelength[1]

							FakeBackGround.Size = UDim2.new(0, longestthing + 12, 0, verticalLength)
							FakeBackGround.Position = UDim2.new(0, pos.x, 0, pos.y)
							BackGroundText.Text = text
					end
			end

			local function CreateColorThing(Parameters)
					local fakeFlagsShit = {}
					local dropKickFlag

					Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance] = {}
					Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Color"] = Parameters.StartColor
					Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance].Save = function()
							local garbageshit = {}
							for anim, data in next, fakeFlagsShit do
									garbageshit[anim] = {}
									for name, values in next, data do
											garbageshit[anim][name] = {}
											if fakeFlagsShit[anim][name]["Value"] then
													garbageshit[anim][name]["Value"] = fakeFlagsShit[anim][name]["Value"]
											elseif fakeFlagsShit[anim][name]["Color"] then
													garbageshit[anim][name]["Color"] = {r = fakeFlagsShit[anim][name]["Color"].r, g = fakeFlagsShit[anim][name]["Color"].g, b = fakeFlagsShit[anim][name]["Color"].b}
													if Parameters.StartTrans and fakeFlagsShit[anim][name]["Transparency"] then
															garbageshit[anim][name]["Transparency"] = fakeFlagsShit[anim][name]["Transparency"]
													end
											end
									end
							end
							return {
									["Color"] = {r = Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Color"].r, g = Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Color"].g, b = Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Color"].b},
									["Transparency"] = Parameters.StartTrans and Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Transparency"] or nil,
									["Animation Selection"] = {["Value"] = dropKickFlag["Value"]},
									["Animations"] =  garbageshit,
							}
					end
					local TransparencySlider = false
					if Parameters.StartTrans then
							TransparencySlider = true
							Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Transparency"] = Parameters.StartTrans
					end
					Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance].Changed = Signal.new()   
					local ColorProxy = Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]

					local ColorH, ColorS, ColorV = RGBtoHSV(Parameters.StartColor)
					local ColorP = UIUtilities:Create("ImageButton", {
							Name = "ColorP" .. Parameters.Stance,
							Parent = Parameters.Parented,
							AnchorPoint = Vector2.new(1, 0.5),
							BackgroundColor3 = Parameters.StartColor,
							BorderColor3 = Color3.fromRGB(255, 0, 0),
							BorderSizePixel = 2,
							BackgroundTransparency = Parameters.StartTrans or 0,
							BorderMode = Enum.BorderMode.Inset,
							Position = UDim2.new(1, Parameters.Pos, 0.5, 0),
							Size = UDim2.new(0, 24, 0, 10),
							ZIndex = 28
					})
					local actualtrans
					if Parameters.StartTrans then
							actualtrans = UIUtilities:Create("NumberValue", {
									Parent = ColorP,
									Value = Parameters.StartTrans,
									Name = "actual"
							})
					end
					local Alpha = UIUtilities:Create("ImageButton", {
							Name = "Alpha",
							Parent = ColorP,
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BorderColor3 = UIStyle.UIcolors.ColorC,
							BorderSizePixel = 0,
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(1, 4, 1, 4),
							ScaleType = "Tile",
							ZIndex = 27,
							Image = "rbxassetid://3887014957"
					})
					AutoApplyBorder(Alpha, "COLORPBACK", 27, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH, true)
					local inDented = 20
					local YBounds = 190
					if not Parameters.StartTrans then
							YBounds = YBounds - 16
					end
					local MasterFrame = UIUtilities:Create("Frame", {
							Name = "Picker",
							Parent = ColorP,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BorderColor3 = Color3.fromRGB(27, 27, 27),
							Position = UDim2.new(0, -5, 0, -1),
							Size = UDim2.new(0, -300, 0, YBounds + inDented),
							BackgroundTransparency = 1,
							Visible = false,
							ZIndex = 30,
					})
					AutoApplyAccent(MasterFrame, "", 34)
					AutoApplyBorder(MasterFrame, "COLORBACK", 25, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)

					local Frame = UIUtilities:Create("Frame", {
							Name = "Picker",
							Parent = MasterFrame,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BorderColor3 = Color3.fromRGB(27, 27, 27),
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, 0),
							Visible = true,
							ZIndex = 30,
					})

					local otherFrame = UIUtilities:Create("Frame", {
							Name = "Picker2",
							Parent = MasterFrame,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BorderColor3 = Color3.fromRGB(27, 27, 27),
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 1, 0),
							Visible = false,
							Transparency = 0,
							ZIndex = 30,
					})

					local imHungover = {
							Rainbow = {
									{ 
											type = "slider",
											name = "Speed",
											max = 1000,
											min = 1,
											suffix = "%"
									}
							},
							Linear = {
									{
											type = "color",
											name = "Keyframe 1"
									},
									{
											type = "color",
											name = "Keyframe 2"
									},
									{
											type = "slider",
											name = "Speed",
											max = 1000,
											min = 1,
											suffix = "%"
									}
							},
							Oscillating = {
									{
											type = "color",
											name = "Keyframe 1"
									},
									{
											type = "color",
											name = "Keyframe 2"
									},
									{
											type = "slider",
											name = "Speed",
											max = 1000,
											min = 1,
											suffix = "%"
									}
							},
							Sawtooth = {
									{
											type = "color",
											name = "Keyframe 1"
									},
									{
											type = "color",
											name = "Keyframe 2"
									},
									{
											type = "slider",
											name = "Speed",
											max = 1000,
											min = 1,
											suffix = "%"
									}
							},
							Strobe = {
									{
											type = "color",
											name = "Keyframe 1"
									},
									{
											type = "color",
											name = "Keyframe 2"
									},
									{
											type = "slider",
											name = "Speed",
											max = 1000,
											min = 1,
											suffix = "%"
									}
							}
					}

					for fix, hangover in next, imHungover do
							local faggot = UIUtilities:Create("Frame", {
									AnchorPoint = Vector2.new(0.5, 0),
									Name = fix,
									Parent = otherFrame,
									BackgroundColor3 = Color3.fromRGB(0, 0, 0),
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									Position = UDim2.new(0.5, 0, 0, 72),
									Size = UDim2.new(1, 0, 1, -72),
									ZIndex = 20 + 22,
									Visible = false
							})
							local i_hate_this = UIUtilities:Create("UIListLayout", {
									Padding = UDim.new(0, 8),
									Parent = faggot,
									FillDirection = Enum.FillDirection.Vertical,
									HorizontalAlignment = Enum.HorizontalAlignment.Center,
									SortOrder = Enum.SortOrder.LayoutOrder,
									VerticalAlignment = Enum.VerticalAlignment.Top
							})
							fakeFlagsShit[fix] = {}

							local whoresFucked = 0

							for bullshit, data in next, hangover do
									local fakeFlagNigger
									if data.type == "color" then
											local whoreCoonNig = UIUtilities:Create("Frame", {
													BackgroundTransparency = 1,
													Name = "nigga",
													Parent = faggot,
													Size = UDim2.new(1, 0, 0, 8),
													Visible = true,
													ZIndex = 19
											})

											local TextGarbage = UIUtilities:Create("TextLabel", {
													AnchorPoint = Vector2.new(1, 0),
													BackgroundTransparency = 1,
													Parent = whoreCoonNig,
													Position = UDim2.new(1, 0, 0, 0),
													Size = UDim2.new(1, -10, 1, 0),
													ZIndex = 20 + 28,
													Text = data.name,
													TextColor3 = UIStyle.UIcolors.FullWhite,
													Font = UIStyle.TextFont.Font,
													LineHeight = 1.05,
													TextSize = UIStyle.TextFont.TxtSize,
													TextStrokeColor3 = Color3.new(),
													TextStrokeTransparency = 0.5,
													TextXAlignment = Enum.TextXAlignment.Left,
													TextYAlignment = Enum.TextYAlignment.Center
											})

											local garbageParameters = table.clone(Parameters)

											garbageParameters.Pos = -1 * (((1 - 1) * 24) + (10 * 1 - 1))
											garbageParameters.Stance = whoresFucked
											whoresFucked = whoresFucked + 1
											garbageParameters.ObjectName = data.name

											fakeFlagNigger = {}
											fakeFlagNigger["Color"] = garbageParameters.StartColor
											local TransparencySlider = false
											if garbageParameters.StartTrans then
													TransparencySlider = true
													fakeFlagNigger["Transparency"] = garbageParameters.StartTrans
											end
											fakeFlagNigger.Changed = Signal.new()   

											local ColorProxy = fakeFlagNigger

											local ColorH, ColorS, ColorV = RGBtoHSV(garbageParameters.StartColor)
											local ColorP = UIUtilities:Create("ImageButton", {
													Name = "ColorP" .. garbageParameters.Stance,
													Parent = whoreCoonNig,
													AnchorPoint = Vector2.new(1, 0.5),
													BackgroundColor3 = garbageParameters.StartColor,
													BorderColor3 = Color3.fromRGB(255, 0, 0),
													BorderSizePixel = 2,
													BackgroundTransparency = garbageParameters.StartTrans or 0,
													BorderMode = Enum.BorderMode.Inset,
													Position = UDim2.new(1, garbageParameters.Pos, 0.5, 0),
													Size = UDim2.new(0, 24, 0, 10),
													ZIndex = 22 + 28
											})
											local actualtrans
											if garbageParameters.StartTrans then
													actualtrans = UIUtilities:Create("NumberValue", {
															Parent = ColorP,
															Value = garbageParameters.StartTrans,
															Name = "actual"
													})
											end
											local Alpha = UIUtilities:Create("ImageButton", {
													Name = "Alpha",
													Parent = ColorP,
													AnchorPoint = Vector2.new(0.5, 0.5),
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													BorderColor3 = UIStyle.UIcolors.ColorC,
													BorderSizePixel = 0,
													BackgroundTransparency = 1,
													Position = UDim2.new(0.5, 0, 0.5, 0),
													Size = UDim2.new(1, 4, 1, 4),
													ScaleType = "Tile",
													ZIndex = 22 + 27,
													Image = "rbxassetid://3887014957"
											})
											AutoApplyBorder(Alpha, "COLORPBACK", 22 + 27, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)
											local inDented = 20
											local YBounds = 190
											if not garbageParameters.StartTrans then
													YBounds = YBounds - 16
											end
											local MasterFrame = UIUtilities:Create("Frame", {
													Name = "Picker",
													Parent = ColorP,
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													BorderColor3 = Color3.fromRGB(27, 27, 27),
													Position = UDim2.new(0, -5, 0, -1),
													Size = UDim2.new(0, -300, 0, YBounds + inDented),
													BackgroundTransparency = 1,
													Visible = false,
													ZIndex = 22 + 30,
											})
											AutoApplyAccent(MasterFrame, "", 22 + 34)
											AutoApplyBorder(MasterFrame, "COLORBACK", 22 + 25, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)

											local Frame = UIUtilities:Create("Frame", {
													Name = "Picker",
													Parent = MasterFrame,
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													BorderColor3 = Color3.fromRGB(27, 27, 27),
													Position = UDim2.new(0, 0, 0, 0),
													Size = UDim2.new(1, 0, 1, 0),
													Visible = true,
													ZIndex = 22 + 30,
											})
											local Colorpick = UIUtilities:Create("ImageButton", {
													Name = "Colorpick",
													Parent = Frame,
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													BorderColor3 = UIStyle.UIcolors.ColorA,
													ClipsDescendants = false,
													BorderSizePixel = 0,
													Position = UDim2.new(0, 8, 0, 10 + inDented),
													Size = UDim2.new(0, 156, 0, 156),
													AutoButtonColor = false,
													Image = "rbxassetid://4155801252",
													ImageColor3 = Color3.fromRGB(255, 0, 0),
													ZIndex = 22 + 33
											})
											AutoApplyBorder(Colorpick, "Picker", 22 + 33, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)
											local ColorDrag = UIUtilities:Create("Frame", {
													Name = "ColorDrag",
													Parent = Colorpick,
													AnchorPoint = Vector2.new(0.5, 0.5),
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													BorderColor3 = Color3.fromRGB(27, 27, 27),
													Size = UDim2.new(0, 4, 0, 4),
													ZIndex = 22 + 33
											})

											local backThing = UIUtilities:Create("Frame", {
													Name = "thingy",
													Parent = Frame,
													BackgroundColor3 = UIStyle.UIcolors.ColorE,
													BorderColor3 = Color3.fromRGB(27, 27, 27),
													Position = UDim2.new(0, 0, 0, 0),
													Size = UDim2.new(1, 0, 1, 0),
													BackgroundTransparency = 1,
													Visible = true,
													ZIndex = 32,
											})
											local realThing = UIUtilities:Create("Frame", {
													Name = "Picker",
													Parent = backThing,
													AnchorPoint = Vector2.new(0.5, 0.5),
													BackgroundColor3 = UIStyle.UIcolors.ColorA,
													BorderColor3 = Color3.fromRGB(27, 27, 27),
													BorderSizePixel = 0,
													Position = UDim2.new(0.5, 1 * (-1), 0.5, 1),
													Size = UDim2.new(1, -2, 1, -2),
													BackgroundTransparency = 1,
													Visible = true,
													Active = true,
													ZIndex = 22 + 33,
											})
											local theText = UIUtilities:Create("TextLabel", {
													Name = "theText",
													Parent = realThing,
													AnchorPoint = Vector2.new(0, 0),
													Size = UDim2.new(1, 0, 1, 0),
													Text = garbageParameters.ObjectName,
													BackgroundTransparency = 1,
													TextColor3 = UIStyle.UIcolors.FullWhite,
													Font = UIStyle.TextFont.Font,
													LineHeight = 1.1,   
													ZIndex = 22 + 34,
													Position = UDim2.new(0, 8, 0, 4),
													TextSize = UIStyle.TextFont.TxtSize,
													TextXAlignment = Enum.TextXAlignment.Left,
													TextYAlignment = Enum.TextYAlignment.Top,
													TextStrokeColor3 = Color3.new(),
													TextStrokeTransparency = 0.5,
											})

											local Huepick = UIUtilities:Create("ImageButton", {
													Name = "Huepick",
													Parent = Frame,
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													BorderColor3 = UIStyle.UIcolors.ColorA,
													ClipsDescendants = false,
													BorderSizePixel = 0,
													Position = UDim2.new(0, 172, 0, 10 + inDented),
													Size = UDim2.new(0, 14, 0, 156),
													AutoButtonColor = false,
													Image = "rbxassetid://3641079629",
													ImageColor3 = Color3.fromRGB(255, 0, 0),
													ImageTransparency = 1,
													BackgroundTransparency = 0,
													ZIndex = 22 + 33
											})
											AutoApplyBorder(Huepick, "Picker", 22 + 33, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)
											local Huedrag = UIUtilities:Create("Frame", {
													Name = "Huedrag",
													Parent = Huepick,
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													BorderColor3 = UIStyle.UIcolors.ColorA,
													Size = UDim2.new(1, 0, 0, 2),
													ZIndex = 22 + 33
											})

											local HueFrameGradient = UIUtilities:Create("UIGradient", {
													Rotation = 90,
													Name = "HueFrameGradient",
													Parent = Huepick,
													Color = ColorSequence.new {
															ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
															ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 0, 255)),
															ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 0, 255)),
															ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
															ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 0)),
															ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 255, 0)),
															ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
													},  
											})

											local Transpick, Transcolor, Transdrag

											if TransparencySlider then
													Transpick = UIUtilities:Create("ImageButton", {
															Name = "Transpick",
															Parent = Frame,
															BackgroundColor3 = Color3.fromRGB(255, 255, 255),
															BorderColor3 = UIStyle.UIcolors.ColorA,
															Position = UDim2.new(0, 8, 0, 172 + inDented),
															Size = UDim2.new(0, 156, 0, 12),
															AutoButtonColor = false,
															Image = "rbxassetid://3887014957",
															ScaleType = Enum.ScaleType.Tile,
															TileSize = UDim2.new(0, 10, 0, 10),
															ZIndex = 22 + 33
													})
													AutoApplyBorder(Transpick, "Picker", 22 + 33, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)
													Transcolor = UIUtilities:Create("ImageLabel", {
															Name = "Transcolor",
															Parent = Transpick,
															BackgroundColor3 = Color3.fromRGB(255, 255, 255),
															BackgroundTransparency = 1,
															Size = UDim2.new(1, 0, 1, 0),
															Image = "rbxassetid://3887017050",
															ImageColor3 = ColorP.BackgroundColor3,
															ZIndex = 22 + 33,
													})
													Transdrag = UIUtilities:Create("Frame", {
															Name = "Transdrag",
															Parent = Transcolor,
															BackgroundColor3 = Color3.fromRGB(255, 255, 255),
															BorderColor3 = UIStyle.UIcolors.ColorA,
															Position = UDim2.new(0, -1, 0, 0),
															Size = UDim2.new(0, 2, 1, 0),
															ZIndex = 22 + 33
													})
											end

											local OldColorText = UIUtilities:Create("TextLabel", {
													Name = "OldColorText",
													Parent = Frame,
													Size = UDim2.new(0, 16, 0, 14),
													Text = "Old Color",
													BackgroundTransparency = 1,
													TextColor3 = UIStyle.UIcolors.FullWhite,
													Font = UIStyle.TextFont.Font,
													LineHeight = 1.1,
													ZIndex = 22 + 34,
													Position = UDim2.new(0, 212, 0, 78 + inDented),
													TextSize = UIStyle.TextFont.TxtSize,
													TextStrokeColor3 = Color3.new(),
													TextStrokeTransparency = 0.5,
											})
											local OldColor = UIUtilities:Create("Frame", {
													Name = "OldColor",
													Parent = Frame,
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													BorderColor3 = UIStyle.UIcolors.ColorC,
													BorderSizePixel = 0,
													Position = UDim2.new(0, 196, 0, 94 + inDented),
													Size = UDim2.new(0, 92, 0, 48),
													ZIndex = 22 + 35,
											})
											local OldAlpha = UIUtilities:Create("ImageButton", {
													Name = "OldAlpha",
													Parent = Frame,
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													BorderColor3 = UIStyle.UIcolors.ColorC,
													BorderSizePixel = 0,
													Position = UDim2.new(0, 196, 0, 94 + inDented),
													BackgroundTransparency = 1,
													Size = UDim2.new(0, 92, 0, 48),
													ScaleType = "Tile",
													ZIndex = 22 + 34,
													Image = "rbxassetid://3887014957"
											})

											AutoApplyBorder(OldAlpha, "OldAlpha", 22 + 34, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)

											local NewColorText = UIUtilities:Create("TextLabel", {
													Name = "NewColorText",
													Parent = Frame,
													Size = UDim2.new(0, 16, 0, 14),
													Text = "New Color",
													BackgroundTransparency = 1,
													TextColor3 = UIStyle.UIcolors.FullWhite,
													Font = UIStyle.TextFont.Font,
													LineHeight = 1.1,
													ZIndex = 22 + 34,
													Position = UDim2.new(0, 212, 0, 6 + inDented),
													TextSize = UIStyle.TextFont.TxtSize,
													TextStrokeColor3 = Color3.new(),
													TextStrokeTransparency = 0.5,
											})
											local NewColor = UIUtilities:Create("Frame", {
													Name = "NewColor",
													Parent = Frame,
													BackgroundColor3 = garbageParameters.StartColor,
													BackgroundTransparency = garbageParameters.StartTrans,
													BorderColor3 = UIStyle.UIcolors.ColorC,
													BorderSizePixel = 0,
													Position = UDim2.new(0, 196, 0, 22 + inDented),
													Size = UDim2.new(0, 92, 0, 48),
													ZIndex = 22 + 35,
											})
											local NewAlpha = UIUtilities:Create("ImageButton", {
													Name = "NewAlpha",
													Parent = Frame,
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													BorderColor3 = UIStyle.UIcolors.ColorC,
													BorderSizePixel = 0,
													Position = UDim2.new(0, 196, 0, 22 + inDented),
													BackgroundTransparency = 1,
													Size = UDim2.new(0, 92, 0, 48),
													ScaleType = "Tile",
													ZIndex = 22 + 34,
													Image = "rbxassetid://3887014957"
											})
											AutoApplyBorder(NewAlpha, "NewAlpha", 22 + 34, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)
											local YOffset = -24
											if garbageParameters.StartTrans then
													YOffset = -22
											end
											local ApplyButton = UIUtilities:Create("TextButton", {
													Name = "Apply",
													AutoButtonColor = false,
													Parent = Frame,
													Size = UDim2.new(0, 52, 0, 16),
													Text = "[ Apply ]",
													BackgroundTransparency = 1,
													TextColor3 = UIStyle.UIcolors.FullWhite,
													Font = UIStyle.TextFont.Font,
													LineHeight = 1.1,
													ZIndex = 22 + 34,
													Position = UDim2.new(0, 196, 0, YBounds + YOffset + inDented),
													TextSize = UIStyle.TextFont.TxtSize,
													TextStrokeColor3 = Color3.new(),
													TextStrokeTransparency = 0.5,
											})

											local okFrameBackGroundGradient = UIUtilities:Create("UIGradient",{
													Color = ColorSequence.new({
															ColorSequenceKeypoint.new(0, UIStyle.UIcolors.ColorD),
															ColorSequenceKeypoint.new(0.06, UIStyle.UIcolors.ColorA),
															ColorSequenceKeypoint.new(1, UIStyle.UIcolors.ColorA)
													}),
													Rotation = 90,
													Parent = Frame
											})

											local CopyNewColor = UIUtilities:Create("TextButton", {
													Name = "CopyNewColor",
													Parent = NewColor,
													AutoButtonColor = false,
													Size = UDim2.new(1, 0, 0.5, 0),
													Text = "Copy",
													BackgroundTransparency = 1,
													TextColor3 = UIStyle.UIcolors.FullWhite,
													Font = UIStyle.TextFont.Font,
													Visible = false,
													LineHeight = 1.1,
													ZIndex = 22 + 35,
													Position = UDim2.new(0, 0, 0, 0),
													TextSize = UIStyle.TextFont.TxtSize,
													TextStrokeColor3 = Color3.new(),
													TextXAlignment = Enum.TextXAlignment.Center,
													TextYAlignment = Enum.TextYAlignment.Center,
													TextStrokeTransparency = 0.5,
											})

											local PasteNewColor = UIUtilities:Create("TextButton", {
													Name = "PasteNewColor",
													Parent = NewColor,
													AnchorPoint = Vector2.new(0, 1),
													AutoButtonColor = false,
													Size = UDim2.new(1, 0, 0.5, 0),
													Text = "Paste",
													BackgroundTransparency = 1,
													Visible = false,
													TextColor3 = UIStyle.UIcolors.FullWhite,
													Font = UIStyle.TextFont.Font,
													LineHeight = 1.1,
													ZIndex = 22 + 35,
													Position = UDim2.new(0, 0, 1, 0),
													TextSize = UIStyle.TextFont.TxtSize,
													TextStrokeColor3 = Color3.new(),
													TextXAlignment = Enum.TextXAlignment.Center,
													TextYAlignment = Enum.TextYAlignment.Center,
													TextStrokeTransparency = 0.5,
											})

											local CopyOldColor = UIUtilities:Create("TextButton", {
													Name = "PasteOldColor",
													Parent = OldColor,
													Size = UDim2.new(1, 0, 1, 0),
													AutoButtonColor = false,
													Text = "Copy",
													BackgroundTransparency = 1,
													TextColor3 = UIStyle.UIcolors.FullWhite,
													Visible = false,
													Font = UIStyle.TextFont.Font,
													LineHeight = 1.1,
													ZIndex = 22 + 35,
													Position = UDim2.new(0, 0, 0, 0),
													TextSize = UIStyle.TextFont.TxtSize,
													TextStrokeColor3 = Color3.new(),
													TextXAlignment = Enum.TextXAlignment.Center,
													TextYAlignment = Enum.TextYAlignment.Center,
													TextStrokeTransparency = 0.5,
											})

											local abc = false
											local inCP = false
											ColorP.MouseEnter:Connect(function()
													abc = true
											end)
											ColorP.MouseLeave:Connect(function()
													abc = false
											end)
											MasterFrame.MouseEnter:Connect(function()
													inCP = true
											end)
											MasterFrame.MouseLeave:Connect(function()
													inCP = false
											end)

											NewColor.MouseEnter:Connect(function()
													CopyNewColor.Visible = true
													PasteNewColor.Visible = true
											end)

											NewColor.MouseLeave:Connect(function()
													CopyNewColor.Visible = false
													PasteNewColor.Visible = false
											end)

											OldColor.MouseEnter:Connect(function()
													CopyOldColor.Visible = true
											end)

											OldColor.MouseLeave:Connect(function()
													CopyOldColor.Visible = false
											end)

											local function UpdatePickers(Color)
													ColorH, ColorS, ColorV = RGBtoHSV(Color)

													ColorH = math.clamp(ColorH, 0, 1)
													ColorS = math.clamp(ColorS, 0, 1)
													ColorV = math.clamp(ColorV, 0, 1)

													ColorDrag.Position = UDim2.new(1 - ColorS, 0, 1 - ColorV, 0)
													Colorpick.ImageColor3 = Color3.fromHSV(ColorH, 1, 1)
													Huedrag.Position = UDim2.new(0, 0, 1-ColorH, -1)
													if Transcolor then
															Transcolor.ImageColor3 = Color
													end
											end

											UpdatePickers(ColorP.BackgroundColor3)

											ColorP.MouseButton1Down:Connect(function()
													if isColorThingOpen2 and isColorThingOpen2 ~= MasterFrame then
															return
													end
													MasterFrame.Visible = not MasterFrame.Visible
													if MasterFrame.Visible == false then
															isColorThingOpen2 = nil
													else
															isColorThingOpen2 = MasterFrame
													end
													UpdatePickers(ColorP.BackgroundColor3)
													if MasterFrame.Visible then
															OldColor.BackgroundTransparency = ColorP.BackgroundTransparency
															OldColor.BackgroundColor3 = ColorP.BackgroundColor3
													end
											end)

											PasteNewColor.MouseButton1Down:Connect(function()
													if ClipboardColor then
															NewColor.BackgroundColor3 = ClipboardColor
															UpdatePickers(NewColor.BackgroundColor3)
													end
											end)

											CopyOldColor.MouseButton1Down:Connect(function()
													ClipboardColor = OldColor.BackgroundColor3
											end)

											CopyNewColor.MouseButton1Down:Connect(function()
													ClipboardColor = NewColor.BackgroundColor3
											end)

											UserInputService.InputBegan:Connect(function(input)
													if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
															if not dragging and not abc and not inCP then
																	MasterFrame.Visible = false
																	isColorThingOpen2 = nil
															end
													end
											end)

											local function updateColor()
													local ColorX = (math.clamp(Mouse.X - Colorpick.AbsolutePosition.X, 0, Colorpick.AbsoluteSize.X)/Colorpick.AbsoluteSize.X)
													local ColorY = (math.clamp(Mouse.Y - Colorpick.AbsolutePosition.Y, 0, Colorpick.AbsoluteSize.Y)/Colorpick.AbsoluteSize.Y)
													ColorDrag.Position = UDim2.new(ColorX, 0, ColorY, 0)
													ColorS = 1-ColorX
													ColorV = 1-ColorY
													Colorpick.ImageColor3 = Color3.fromHSV(ColorH, 1, 1)
													NewColor.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
													if Transcolor then
															Transcolor.ImageColor3 = NewColor.BackgroundColor3
													end
											end

											local function updateHue()
													local y = math.clamp(Mouse.Y - Huepick.AbsolutePosition.Y, 0, Huepick.AbsoluteSize.Y)
													Huedrag.Position = UDim2.new(0, 0, 0, y)
													hue = y/Huepick.AbsoluteSize.Y
													ColorH = 1-hue
													Colorpick.ImageColor3 = Color3.fromHSV(ColorH, 1, 1)
													NewColor.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
													if Transcolor then
															Transcolor.ImageColor3 = NewColor.BackgroundColor3
													end
											end
											local function updateTrans()
													if Transcolor then
															local x = math.clamp(Mouse.X - Transpick.AbsolutePosition.X, 0, Transpick.AbsoluteSize.X)
															NewColor.BackgroundTransparency = x/Transpick.AbsoluteSize.X
															Transdrag.Position = UDim2.new(0, x, 0, 0)
															Transcolor.ImageColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
													end
											end
											if Transcolor then
													Transpick.MouseButton1Down:Connect(function()
															updateTrans()
															moveconnection = Mouse.Move:Connect(function()
																	updateTrans()
															end)
															releaseconnection = UserInputService.InputEnded:Connect(function(mouse)
																	if mouse.UserInputType == Enum.UserInputType.MouseButton1 then
																			updateTrans()
																			moveconnection:Disconnect()
																			releaseconnection:Disconnect()
																	end
															end)
													end)
											end
											Colorpick.MouseButton1Down:Connect(function()
													updateColor()
													moveconnection = Mouse.Move:Connect(function()
															updateColor()
													end)
													releaseconnection = UserInputService.InputEnded:Connect(function(mouse)
															if mouse.UserInputType == Enum.UserInputType.MouseButton1 then
																	updateColor()
																	moveconnection:Disconnect()
																	releaseconnection:Disconnect()
															end
													end) 
											end)

											ApplyButton.MouseButton1Down:Connect(function()
													ColorP.BackgroundColor3 = NewColor.BackgroundColor3
													ColorP.BackgroundTransparency = NewColor.BackgroundTransparency
													MasterFrame.Visible = false
													isColorThingOpen = nil
											end)

											Huepick.MouseButton1Down:Connect(function()
													updateHue()
													moveconnection = Mouse.Move:Connect(function()
															updateHue()
													end)
													releaseconnection = game:GetService("UserInputService").InputEnded:Connect(function(mouse)
															if mouse.UserInputType == Enum.UserInputType.MouseButton1 then
																	updateHue()
																	moveconnection:Disconnect()
																	releaseconnection:Disconnect()
															end
													end)
											end)
											ColorP.BorderColor3 = Color3.fromRGB(math.clamp((ColorP.BackgroundColor3.R * 255) - 40, 40, 255), math.clamp((ColorP.BackgroundColor3.G * 255) - 40, 40, 255), math.clamp((ColorP.BackgroundColor3.B * 255) - 40, 40, 255))
											ColorP:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
													local Hue, Sat, Val = RGBtoHSV(ColorP.BackgroundColor3)
													fakeFlagNigger["Color"] = ColorP.BackgroundColor3
													fakeFlagNigger.Changed:Fire(ColorP.BackgroundColor3, ColorP.BackgroundTransparency)
													local Color = ColorP.BackgroundColor3
													ColorP.BorderColor3 = Color3.fromRGB(math.clamp((Color.R * 255) - 40, 40, 255), math.clamp((Color.G * 255) - 40, 40, 255), math.clamp((Color.B * 255) - 40, 40, 255))
											end)
											if Parameters.StartTrans then
													ColorP:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
															if fading == false then
																	fakeFlagNigger["Transparency"] = ColorP.BackgroundTransparency
																	fakeFlagNigger.Changed:Fire(ColorP.BackgroundColor3, ColorP.BackgroundTransparency)
																	actualtrans.Value = ColorP.BackgroundTransparency
															end
													end)
											end

											fakeFlagNigger = setmetatable({}, {
													__index = function(self, i)
															if ColorProxy[i] == nil then
																	if i == "Transparency" then
																			return ColorP.BackgroundTransparency
																	elseif i == "Color" then
																			return ColorP.BackgroundColor3
																	end
															else
																	return ColorProxy[i]
															end 
													end,
													__newindex = function(self, i, v)
															if i == "Color" then
																	if type(v) == "table" then
																			local af = Color3.new(v.r, v.g, v.b)
																			v = af
																	end
																	ColorP.BackgroundColor3 = v
															elseif i == "Transparency" then
																	ColorP.BackgroundTransparency = v
															end
															ColorProxy[i] = v
													end
											})                      
									elseif data.type == "slider" then

											local garbageParameters = {
													Name = data.name,
													MinimumNumber = data.min,
													MaximumNumber = data.max,
													Suffix = data.suffix
											}

											fakeFlagNigger = {}
											fakeFlagNigger.Changed = Signal.new()
											local Proxy = fakeFlagNigger
											if not garbageParameters.Suffix then
													garbageParameters.Suffix = ""
											end
											local Slider = UIUtilities:Create("Frame", {
													Name = garbageParameters.Name,
													Parent = faggot,
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													BackgroundTransparency = 1,
													ZIndex = 20 + 22,
													Position = UDim2.new(0, 0, 0, 0),
													Size = UDim2.new(1, 0, 0, 20)
											})
											local TextLabel = UIUtilities:Create("TextButton", {
													Parent = Slider,
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													BackgroundTransparency = 1,
													Position = UDim2.new(0, 8, 0, -4),
													Size = UDim2.new(1, 0, 0, 15),
													Font = UIStyle.TextFont.Font,
													ZIndex = 20 + 22,
													Text = garbageParameters.Name,
													TextColor3 = UIStyle.UIcolors.FullWhite,
													TextStrokeColor3 = Color3.new(),
													LineHeight = 1.2,
													TextStrokeTransparency = 0.5,
													TextSize = UIStyle.TextFont.TxtSize,
													TextXAlignment = Enum.TextXAlignment.Left
											})
											local AddText = UIUtilities:Create("TextButton", {
													Parent = Slider,
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													BackgroundTransparency = 1,
													Position = UDim2.new(1, -32, 0, -4),
													Size = UDim2.new(0, 8, 0, 15),
													Font = UIStyle.TextFont.Font,
													ZIndex = 20 + 22,
													Visible = false,
													Text = "+",
													TextColor3 = UIStyle.UIcolors.FullWhite,
													TextStrokeColor3 = Color3.new(),
													TextStrokeTransparency = 0.5,
													TextSize = UIStyle.TextFont.TxtSize,
													TextXAlignment = Enum.TextXAlignment.Center
											})
											local SubtractText = UIUtilities:Create("TextButton", {
													Parent = Slider,
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													BackgroundTransparency = 1,
													Position = UDim2.new(1, -22, 0, -4),
													Size = UDim2.new(0, 8, 0, 15),
													Font = UIStyle.TextFont.Font,
													ZIndex = 20 + 22,
													Visible = false,
													Text = "-",
													TextColor3 = UIStyle.UIcolors.FullWhite,
													TextStrokeColor3 = Color3.new(),
													TextStrokeTransparency = 0.5,
													TextSize = UIStyle.TextFont.TxtSize,
													TextXAlignment = Enum.TextXAlignment.Center
											})

											local Button = UIUtilities:Create("TextButton", {
													AnchorPoint = Vector2.new(0.5, 0),
													Name = "Button",
													Parent = Slider,
													BackgroundTransparency = 1,
													BackgroundColor3 = UIStyle.UIcolors.ColorD,
													BorderSizePixel = 0,
													Position = UDim2.new(0.5, 0, 0, 12),
													Size = UDim2.new(1, -18, 0, 8),
													AutoButtonColor = false,
													ZIndex = 20 + 21,
													Text = ""
											})
											local ButtonStyle = UIUtilities:Create("Frame", {
													AnchorPoint = Vector2.new(0.5, 0.5),
													Name = "Button",
													Parent = Button,
													BackgroundTransparency = 0,
													BackgroundColor3 = UIStyle.UIcolors.ColorD,
													BorderSizePixel = 0,
													Position = UDim2.new(0.5, 0, 0.5, 0),
													Size = UDim2.new(1, 0, 1, 0),
													ZIndex = 20 + 22
											})
											local ButtonStyleStyling = UIUtilities:Create("UIGradient", {
													Color = ColorSequence.new({
															ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
															ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
													}),
													Rotation = 90,
													Parent = ButtonStyle
											})

											AutoApplyBorder(ButtonStyle, garbageParameters.Name, 20 + 22, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)
											local Frame = UIUtilities:Create("Frame", {
													Parent = Button,
													BackgroundColor3 = UIStyle.UIcolors.Accent,
													BorderSizePixel = 0,
													ZIndex = 20 + 22,
													Size = UDim2.new(0, 0, 1, 0)
											})
											table.insert(UIAccents, Frame)
											local FrameStyling = UIUtilities:Create("UIGradient", {
													Color = ColorSequence.new({
															ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
															ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
													}),
													Rotation = 90,
													Parent = Frame
											})

											local Value = UIUtilities:Create("TextLabel", {
													AnchorPoint = Vector2.new(0.5, 0.5),
													Name = "Value",
													Parent = ButtonStyle,
													BackgroundColor3 = Color3.fromRGB(255, 255, 255),
													BackgroundTransparency = 1,
													Position = UDim2.new(0.5, 0, 0.5, 0),
													Size = UDim2.new(1, 0, 0, 2),
													LineHeight = 1.1,
													Font = UIStyle.TextFont.Font,
													Text = garbageParameters.MinimumText or garbageParameters.MinimumNumber .. garbageParameters.Suffix,
													ZIndex = 20 + 24,
													TextColor3 = UIStyle.UIcolors.FullWhite,
													TextStrokeColor3 = Color3.new(),
													TextStrokeTransparency = 0.5,
													TextSize = UIStyle.TextFont.TxtSize,
													TextXAlignment = Enum.TextXAlignment.Center
											})

											local NumberValue = UIUtilities:Create("NumberValue", {
													Value = garbageParameters.MinimumNumber,
													Parent = Slider,
													Name = garbageParameters.Name
											})
											fakeFlagNigger["Value"] = NumberValue.Value
											local mouse = Mouse
											local val
											local Absolute = Button.AbsoluteSize.X
											local Moving = false

											Button.MouseButton1Down:Connect(function()
													Absolute = Button.AbsoluteSize.X
													if moveconnection then
															moveconnection:Disconnect()
													end
													if releaseconnection then
															releaseconnection:Disconnect() -- fixing the issue where if ur mouse goes off screen while dragging itll cancel it on click
													end
													Moving = true
													Frame.Size = UDim2.new(0, math.clamp(mouse.X - Frame.AbsolutePosition.X, 0, Absolute), 1, 0)
													val = math.floor(0.5 + (((garbageParameters.MaximumNumber - garbageParameters.MinimumNumber) / Absolute) * Frame.AbsoluteSize.X) + garbageParameters.MinimumNumber) or 0
													NumberValue.Value = val
													moveconnection = mouse.Move:Connect(function()
															Frame.Size = UDim2.new(0, math.clamp(mouse.X - Frame.AbsolutePosition.X, 0, Absolute), 1, 0)
															val = math.floor(0.5 + (((garbageParameters.MaximumNumber - garbageParameters.MinimumNumber) / Absolute) * Frame.AbsoluteSize.X) + garbageParameters.MinimumNumber)
															NumberValue.Value = val
													end)
													releaseconnection = UserInputService.InputEnded:Connect(function(Mouse)
															if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then
																	Frame.Size = UDim2.new(0, math.clamp(mouse.X - Frame.AbsolutePosition.X, 0, Absolute), 1, 0)
																	val = (((garbageParameters.MaximumNumber - garbageParameters.MinimumNumber) / Absolute) * Frame.AbsoluteSize.X) + garbageParameters.MinimumNumber
																	moveconnection:Disconnect()
																	releaseconnection:Disconnect()
																	Moving = false
															end
													end)
											end)
											NumberValue.Changed:Connect(function()
													Absolute = Button.AbsoluteSize.X
													NumberValue.Value = math.clamp(NumberValue.Value, garbageParameters.MinimumNumber, garbageParameters.MaximumNumber)
													if not Moving then
															local Portion = 0.5
															if garbageParameters.MinimumNumber > 0 then
																	Portion = ((NumberValue.Value - garbageParameters.MinimumNumber)) / (garbageParameters.MaximumNumber - garbageParameters.MinimumNumber)
															else
																	Portion = (NumberValue.Value - garbageParameters.MinimumNumber) / (garbageParameters.MaximumNumber - garbageParameters.MinimumNumber)
															end
															Frame.Size = UDim2.new(Portion, 0, 1, 0) -- itll go back to offset when someone tries moving it
															val = math.floor(0.5 + (((garbageParameters.MaximumNumber - garbageParameters.MinimumNumber) / Absolute) * Frame.AbsoluteSize.X) + garbageParameters.MinimumNumber) or 0
													end
													if NumberValue.Value == garbageParameters.MaximumNumber and garbageParameters.MaximumText ~= nil then
															Value.Text = garbageParameters.MaximumText
													elseif NumberValue.Value == garbageParameters.MinimumNumber and garbageParameters.MinimumText ~= nil then
															Value.Text = garbageParameters.MinimumText
													else
															Value.Text = val .. garbageParameters.Suffix  
													end
													fakeFlagNigger["Value"] = NumberValue.Value
													if garbageParameters.Callback then
															garbageParameters.Callback(NumberValue.Value)
													end
													fakeFlagNigger.Changed:Fire(NumberValue.Value)
											end)
											Slider.MouseEnter:Connect(function()
													AddText.Visible = true
													SubtractText.Visible = true
											end)
											Slider.MouseLeave:Connect(function()
													AddText.Visible = false
													SubtractText.Visible = false
											end)
											AddText.MouseEnter:Connect(function()
													AddText.TextColor3 = UIStyle.UIcolors.Accent
											end)
											AddText.MouseLeave:Connect(function()
													AddText.TextColor3 = UIStyle.UIcolors.FullWhite
											end)
											SubtractText.MouseEnter:Connect(function()
													SubtractText.TextColor3 = UIStyle.UIcolors.Accent
											end)
											SubtractText.MouseLeave:Connect(function()
													SubtractText.TextColor3 = UIStyle.UIcolors.FullWhite
											end)
											AddText.MouseButton1Down:Connect(function()
													NumberValue.Value = NumberValue.Value + 1
											end)
											SubtractText.MouseButton1Down:Connect(function()
													NumberValue.Value = NumberValue.Value - 1
											end)
											fakeFlagNigger = setmetatable({}, {
													__index = function(self, i)
															return Proxy[i]
													end,
													__newindex = function(self, i, v)
															if i == "Value" then
																	NumberValue.Value = v
															end
															Proxy[i] = v
													end
											})
									end
									fakeFlagsShit[fix][data.name] = fakeFlagNigger
							end
					end

					local reUpdate = function() end

					do
							local zindexBoost = 20
							local fakeFlag = {}
							local Proxy = fakeFlag
							fakeFlag["Dropdown"] = {}
							fakeFlag["Dropdown"].Changed = Signal.new()
							local Parameters = {
									Name = "Animation Type",
									Values = {
											"None",
											"Rainbow",
											"Linear",
											"Oscillating",
											"Strobe",
											"Sawtooth"
									}
							}

							local Contained = UIUtilities:Create("Frame", {
									AnchorPoint = Vector2.new(0.5, 0),
									Name = Parameters.Name,
									Parent = otherFrame,
									BackgroundColor3 = Color3.fromRGB(0, 0, 0),
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									Position = UDim2.new(0.5, 0, 0, inDented + 8),
									Size = UDim2.new(1, 0, 0, 32),
									ZIndex = zindexBoost + 22,
							})
							local ValueContainer = UIUtilities:Create("Frame", {
									AnchorPoint = Vector2.new(0.5, 0),
									Name = "ValueContainer",
									Parent = Contained,
									BackgroundTransparency = 1,
									Position = UDim2.new(0.5, 0, 1, 4),
									Size = UDim2.new(1, -18, 0, 16),
									Visible = false,
									ZIndex = zindexBoost + 23,
							})
							local FakeSelection = UIUtilities:Create("TextButton", {
									Active = true,
									AnchorPoint = Vector2.new(0.5, 1),
									Name = "FAKE",
									Parent = Contained,
									BackgroundColor3 = Color3.fromRGB(44, 44, 44),
									BackgroundTransparency = 1,
									BorderColor3 = Color3.fromRGB(39, 39, 39),
									BorderSizePixel = 3,
									Position = UDim2.new(0.5, 0, 1, 0),
									Selectable = true,
									Size = UDim2.new(1, -18, 0, 20),
									ZIndex = zindexBoost + 24,
									Font = UIStyle.TextFont.Font,
									ClipsDescendants = false,
									LineHeight = 1.1,
									Text = "",
									TextColor3 = UIStyle.UIcolors.FullWhite,
									TextSize = UIStyle.TextFont.TxtSize,
									TextStrokeColor3 = Color3.new(),
									TextStrokeTransparency = 0.5,
									TextXAlignment = Enum.TextXAlignment.Left,
							})
							local Selection = UIUtilities:Create("TextButton", {
									Active = true,
									AnchorPoint = Vector2.new(0.5, 1),
									Name = "Selection",
									Parent = Contained,
									BackgroundColor3 = Color3.fromRGB(44, 44, 44),
									BackgroundTransparency = 1,
									BorderColor3 = Color3.fromRGB(39, 39, 39),
									BorderSizePixel = 3,
									Position = UDim2.new(0.5, 0, 1, 0),
									Selectable = true,
									Size = UDim2.new(1, -18, 0, 20),
									ZIndex = zindexBoost + 24,
									Font = UIStyle.TextFont.Font,
									ClipsDescendants = true,
									LineHeight = 1.1,
									Text = Parameters.Values[1],
									TextColor3 = UIStyle.UIcolors.FullWhite,
									TextSize = UIStyle.TextFont.TxtSize,
									TextStrokeColor3 = Color3.new(),
									TextStrokeTransparency = 0.5,
									TextXAlignment = Enum.TextXAlignment.Left,
							})
							local DropDownTypeText = UIUtilities:Create("TextButton", {
									AnchorPoint = Vector2.new(0.5, 1),
									Name = "TypeOf",
									Parent = Contained,
									BackgroundColor3 = Color3.fromRGB(44, 44, 44),
									BackgroundTransparency = 1,
									BorderColor3 = Color3.fromRGB(39, 39, 39),
									BorderSizePixel = 3,
									Position = UDim2.new(0.5, 0, 1, 0),
									Size = UDim2.new(1, -32, 0, 18),
									ZIndex = zindexBoost + 23,
									Font = UIStyle.TextFont.Font,
									LineHeight = 1.1,
									Text = "-",
									TextColor3 = UIStyle.UIcolors.FullWhite,
									TextSize = UIStyle.TextFont.TxtSize,
									TextStrokeColor3 = Color3.new(),
									TextStrokeTransparency = 0.5,
									TextXAlignment = Enum.TextXAlignment.Right,
							})
							if Parameters.MultiChoice then 
									DropDownTypeText.Text = "..."
							end
							local Padding = UIUtilities:Create("UIPadding", {
									Parent = Selection,
									PaddingLeft = UDim.new(0, 12)
							}) 
							local Padding2 = UIUtilities:Create("UIPadding", {
									Parent = FakeSelection,
									PaddingLeft = UDim.new(0, 12)
							}) 
							local SelectionStyling = UIUtilities:Create("Frame", {
									BackgroundColor3 = UIStyle.UIcolors.FullWhite,
									Parent = FakeSelection,
									BorderSizePixel = 0,
									Position = UDim2.new(0, -12, 0, 0),
									Size = UDim2.new(1, 12, 1, 0),
									ZIndex = zindexBoost + 23,
							})
							local SelectionStylingGradient = UIUtilities:Create("UIGradient", {
									Color = ColorSequence.new({
											ColorSequenceKeypoint.new(0, UIStyle.UIcolors.ColorD),
											ColorSequenceKeypoint.new(0.84, UIStyle.UIcolors.ColorA),
											ColorSequenceKeypoint.new(1, UIStyle.UIcolors.ColorA)
									}),
									Rotation = 90,
									Parent = SelectionStyling
							})
							AutoApplyBorder(SelectionStyling, "SelectionStyling", 22 + zindexBoost, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)
							local NameTag = UIUtilities:Create("TextLabel", {
									Name = "NAMETAG",
									Parent = Contained,
									BackgroundTransparency = 1,
									Position = UDim2.new(0, 8, 0, 0),
									Size = UDim2.new(1, -12, 1, -24),
									Font = UIStyle.TextFont.Font,
									Text = Parameters.Name,
									TextColor3 = UIStyle.UIcolors.FullWhite,
									TextSize = UIStyle.TextFont.TxtSize,
									TextStrokeColor3 = Color3.new(),
									TextStrokeTransparency = 0.5,
									TextXAlignment = Enum.TextXAlignment.Left,
									ZIndex = zindexBoost + 22
							})
							local Organizer = UIUtilities:Create("UIListLayout", {
									Padding = UDim.new(0, 0),
									Parent = ValueContainer,
									HorizontalAlignment = Enum.HorizontalAlignment.Center,
									SortOrder = Enum.SortOrder.LayoutOrder,
							})
							for iC, vC in next, (Parameters.Values) do
									local Button = UIUtilities:Create("TextButton", {
											AnchorPoint = Vector2.new(0.5, 0),
											Name = "Button",
											Parent = ValueContainer,
											AutoButtonColor = false,
											BackgroundColor3 = UIStyle.UIcolors.ColorI,
											BorderColor3 = UIStyle.UIcolors.ColorB,
											BorderSizePixel = 0,
											BackgroundTransparency = 0,
											Position = UDim2.new(0.5, 0, 0, 0),
											Size = UDim2.new(1, 0, 0, 18),
											ZIndex = zindexBoost + 32,
											Font = UIStyle.TextFont.Font,
											TextStrokeColor3 = Color3.new(),
											TextStrokeTransparency = 0,
											Text = vC,
											TextColor3 = UIStyle.UIcolors.FullWhite,
											TextSize = UIStyle.TextFont.TxtSize
									})
									local valsthing = UIUtilities:Create("BoolValue", {
											Parent = Button,
											Value = false,
											Name = "Selection"
									})
									if iC == 1 and Parameters.MultiChoice then
											Button.TextColor3 = UIStyle.UIcolors.Accent
											valsthing.Value = true
									end
									local ButtonStyling = UIUtilities:Create("Frame", {
											AnchorPoint = Vector2.new(0.5, 0.5),
											Parent = Button,
											BackgroundColor3 = UIStyle.UIcolors.ColorA,
											BorderSizePixel = 1,
											BorderColor3 = UIStyle.UIcolors.ColorB,
											Position = UDim2.new(0.5, 0, 0.5, 0),
											Size = UDim2.new(1, 0, 1, 0),
											ZIndex = zindexBoost + 31
									})
									AutoApplyBorder(ButtonStyling, vC, 31 + zindexBoost, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)
							end
							local closeconnection
							local inDropDown = false
							local mouseent, mouseext
							local function trigger()
									ValueContainer.Size = UDim2.new(1, -18, 0, #Parameters.Values * 18)
									ValueContainer.Visible = not ValueContainer.Visible
									if ValueContainer.Visible then
											if not Parameters.MultiChoice then
													for _, Button in next, (ValueContainer:GetChildren()) do
															if Button:IsA("TextButton") then
																	if Button.Text == Selection.Text then
																			Button.TextColor3 = UIStyle.UIcolors.Accent
																	else
																			Button.TextColor3 = UIStyle.UIcolors.FullWhite
																	end 
															end
													end
											else
													for _, Button in next, (ValueContainer:GetChildren()) do
															if Button:IsA("TextButton") then
																	if table.find(fakeFlag["Value"], Button.Text) ~= nil then
																			Button.TextColor3 = UIStyle.UIcolors.Accent
																	else
																			Button.TextColor3 = UIStyle.UIcolors.FullWhite
																	end 
															end
													end
											end
											task.wait()
											mouseent = ValueContainer.MouseEnter:Connect(function()
													inDropDown = true
											end)
											mouseext = ValueContainer.MouseLeave:Connect(function()
													inDropDown = false
											end)
											closeconnection = UserInputService.InputBegan:Connect(function(input)
													if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
															if not inDropDown then
																	ValueContainer.Visible = false
																	closeconnection:Disconnect()
																	mouseent:Disconnect()
																	mouseext:Disconnect()
															end
													end
											end)
									else
											if closeconnection then
													closeconnection:Disconnect()
											end
											if mouseent then
													mouseent:Disconnect()
											end
											if mouseext then
													mouseext:Disconnect()
											end
									end
							end
							Selection.MouseButton1Down:Connect(trigger)
							local function initialize()
									if Parameters.MultiChoice then  
											fakeFlag["Value"] = {Parameters.Values[1]}

											local function update()
													local chosentext = {}
													Selection.Text = ""

													for cf, c in next, (ValueContainer:GetChildren()) do
															if c:IsA("TextButton") then
																	if c:FindFirstChild("Selection") and c.Selection.Value == true then
																			table.insert(chosentext, c.Text)
																	end
															end
													end

													for e = 1, #chosentext do
															if e == #chosentext then
																	Selection.Text = Selection.Text .. chosentext[e]
															else
																	Selection.Text = Selection.Text .. chosentext[e] .. ", "
															end
													end
											end

											for _, button in next, (ValueContainer:GetChildren()) do
													if button:IsA("TextButton") then
															button.MouseButton1Down:Connect(function()
																	button.TextColor3 = UIStyle.UIcolors.Accent
																	button.Selection.Value = not button.Selection.Value
																	if button:FindFirstChild("Selection") and button.Selection.Value == true then
																			button.TextColor3 = UIStyle.UIcolors.FullWhite
																	end
																	update()
															end)
													end
											end

									else
											fakeFlag["Value"] = Parameters.Values[1]
											for _, ButtonA in next, (ValueContainer:GetChildren()) do
													if ButtonA:IsA("TextButton") then
															ButtonA.MouseButton1Down:Connect(function()
																	Selection.Text = ButtonA.Text
																	trigger()
															end)
													end
											end
									end
							end
							initialize()
							Selection:GetPropertyChangedSignal("Text"):Connect(function()
									if Parameters.MultiChoice then
											if ValueContainer.Visible == false then
													local selectedvalues = (Selection.Text):split(", ")
													for _, button in next, (ValueContainer:GetChildren()) do
															if button:IsA("TextButton") then
																	if table.find(selectedvalues, button.Text) then
																			button.TextColor3 = UIStyle.UIcolors.Accent
																	else
																			button.TextColor3 = Color3.fromRGB(255, 255, 255)
																	end
															end
													end
													fakeFlag["Value"] = selectedvalues
											else
													local selection = {}
													for cf, c in next, (ValueContainer:GetChildren()) do
															if c:IsA("TextButton") then
																	if c:FindFirstChild("Selection") and c.Selection.Value == true then
																			table.insert(selection, c.Text)
																	end
															end
													end
													if selection[1] == nil then
															Selection.Text = "None"
													end
													fakeFlag["Value"] = selection
											end
									else
											fakeFlag["Value"] = Selection.Text
									end
									if Parameters.Callback then
											Parameters.Callback(fakeFlag["Value"])
									end
									fakeFlag["Dropdown"].Changed:Fire(fakeFlag["Value"])
							end)
							fakeFlag.UpdateValues = function(NewValues)
									if Parameters.MultiChoice then
											fakeFlag["Value"] = {}
									else
											fakeFlag["Value"] = ""
									end
									for i, v in next, (ValueContainer:GetChildren()) do
											if v ~= Organizer then
													v:Destroy()
											end
									end
									for iC, vC in next, (NewValues) do
											local Button = UIUtilities:Create("TextButton", {
													AnchorPoint = Vector2.new(0.5, 0),
													Name = "Button",
													Parent = ValueContainer,
													AutoButtonColor = false,
													BackgroundColor3 = UIStyle.UIcolors.ColorI,
													BorderColor3 = UIStyle.UIcolors.ColorB,
													BorderSizePixel = 0,
													BackgroundTransparency = 0,
													Position = UDim2.new(0.5, 0, 0, 0),
													Size = UDim2.new(1, 0, 0, 18),
													ZIndex = zindexBoost + 32,
													Font = UIStyle.TextFont.Font,
													TextStrokeColor3 = Color3.new(),
													TextStrokeTransparency = 0,
													Text = vC,
													TextColor3 = UIStyle.UIcolors.FullWhite,
													TextSize = UIStyle.TextFont.TxtSize
											})
											if iC == 1 and Parameters.MultiChoice then
													Button.TextColor3 = UIStyle.UIcolors.Accent
											end
											local ButtonStyling = UIUtilities:Create("Frame", {
													AnchorPoint = Vector2.new(0.5, 0.5),
													Parent = Button,
													BackgroundColor3 = UIStyle.UIcolors.ColorA,
													BorderSizePixel = 1,
													BorderColor3 = UIStyle.UIcolors.ColorB,
													Position = UDim2.new(0.5, 0, 0.5, 0),
													Size = UDim2.new(1, 0, 1, 0),
													ZIndex = zindexBoost + 31
											})
											AutoApplyBorder(ButtonStyling, vC, 31 + zindexBoost, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)
									end
									Parameters.Values = NewValues
									Selection.Text = NewValues[1]
									initialize()
							end
							fakeFlag = setmetatable({}, {
									__index = function(self, i)
											return Proxy[i]
									end,
									__newindex = function(self, i, v)
											Proxy[i] = v
											if i == "Value" then
													if not Parameters.MultiChoice then
															Selection.Text = v
													else
															for _, button in next, (ValueContainer:GetChildren()) do
																	if button:IsA("TextButton") then
																			if table.find(v, button.Text) then
																					button.Selection.Value = true
																					button.TextColor3 = UIStyle.UIcolors.Accent
																			else
																					button.TextColor3 = Color3.fromRGB(255, 255, 255)
																					button.Selection.Value = false
																			end
																	end
															end
													end
											end
									end
							})

							fakeFlag["Dropdown"].Changed:Connect(function(value)
									for i, v in next, otherFrame:GetChildren() do
											for i2, v2 in next, imHungover do
													if v.Name == i2 then
															if v.Name == value then
																	v.Visible = true
															else
																	v.Visible = false
															end
													end
											end
									end
									reUpdate(value)
							end)

							dropKickFlag = fakeFlag
					end

					local okFrameBackGroundGradient = UIUtilities:Create("UIGradient",{
							Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, UIStyle.UIcolors.ColorD),
									ColorSequenceKeypoint.new(0.06, UIStyle.UIcolors.ColorA),
									ColorSequenceKeypoint.new(1, UIStyle.UIcolors.ColorA)
							}),
							Rotation = 90,
							Parent = otherFrame
					})

					local TabHolder = UIUtilities:Create("Frame", {
							Name = "Picker",
							Parent = MasterFrame,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BorderColor3 = Color3.fromRGB(27, 27, 27),
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 0, inDented),
							Visible = true,
							ZIndex = 31,
					})

					AutoApplyBorder(TabHolder, "COLORBACK", 31, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)
					local TabFrameBackGroundGradient = UIUtilities:Create("UIGradient",{
							Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, UIStyle.UIcolors.ColorD),
									ColorSequenceKeypoint.new(0.06, UIStyle.UIcolors.ColorA),
									ColorSequenceKeypoint.new(1, UIStyle.UIcolors.ColorA)
							}),
							Rotation = 90,
							Parent = TabHolder
					})

					local toggleablethingos = {}

					for i, v in next, {"Color", "Animation"} do
							local textLeng = TextService:GetTextSize(v, UIStyle.TextFont.TxtSize, UIStyle.TextFont.Font, Vector2.new(900, 900)).X
							local backThing = UIUtilities:Create("Frame", {
									Name = "thingy",
									Parent = TabHolder,
									BackgroundColor3 = UIStyle.UIcolors.ColorE,
									BorderColor3 = Color3.fromRGB(27, 27, 27),
									Position = UDim2.new(0, 0, 0, 0),
									Size = UDim2.new(0, textLeng + 10, 1, 0),
									BackgroundTransparency = 1,
									Visible = true,
									ZIndex = 32,
							})
							local realThing = UIUtilities:Create("Frame", {
									Name = "Picker",
									Parent = backThing,
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundColor3 = UIStyle.UIcolors.ColorA,
									BorderColor3 = Color3.fromRGB(27, 27, 27),
									BorderSizePixel = 0,
									Position = UDim2.new(0.5, i * (-1), 0.5, 1),
									Size = UDim2.new(1, -2, 1, -2),
									BackgroundTransparency = 0,
									Visible = true,
									Active = true,
									ZIndex = 33,
							})
							local theText = UIUtilities:Create("TextLabel", {
									Name = "theText",
									Parent = realThing,
									AnchorPoint = Vector2.new(0.5, 0.5),
									Size = UDim2.new(1, 0, 1, 0),
									Text = v,
									BackgroundTransparency = 1,
									TextColor3 = UIStyle.UIcolors.FullWhite,
									Font = UIStyle.TextFont.Font,
									LineHeight = 1.1,   
									ZIndex = 34,
									Position = UDim2.new(0.5, 0, 0.5, 0),
									TextSize = UIStyle.TextFont.TxtSize,
									TextStrokeColor3 = Color3.new(),
									TextStrokeTransparency = 0.5,
							})

							toggleablethingos[1 + #toggleablethingos] = {
									backThing,
									realThing,
									theText
							}

							realThing.InputBegan:Connect(function(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 then
											for i2, v2 in next, toggleablethingos do
													v2[2].BackgroundColor3 = UIStyle.UIcolors.ColorA
											end
											realThing.BackgroundColor3 = UIStyle.UIcolors.ColorG
									end
							end)
					end

					for i2, v2 in next, toggleablethingos do
							v2[2].BackgroundColor3 = UIStyle.UIcolors.ColorA
					end
					toggleablethingos[1][2].BackgroundColor3 = UIStyle.UIcolors.ColorG

					toggleablethingos[1][2].InputBegan:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
									Frame.Visible = true
									otherFrame.Visible = false
							end
					end)

					toggleablethingos[2][2].InputBegan:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
									Frame.Visible = false
									otherFrame.Visible = true
							end
					end)

					local TabsOrganiser = UIUtilities:Create("UIListLayout", {
							Parent = TabHolder,
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							SortOrder = Enum.SortOrder.LayoutOrder,
							VerticalAlignment = Enum.VerticalAlignment.Top
					})

					local FrameBackGroundGradient = UIUtilities:Create("UIGradient",{
							Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, UIStyle.UIcolors.ColorD),
									ColorSequenceKeypoint.new(0.06, UIStyle.UIcolors.ColorA),
									ColorSequenceKeypoint.new(1, UIStyle.UIcolors.ColorA)
							}),
							Rotation = 90,
							Parent = Frame
					})
					local Colorpick = UIUtilities:Create("ImageButton", {
							Name = "Colorpick",
							Parent = Frame,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BorderColor3 = UIStyle.UIcolors.ColorA,
							ClipsDescendants = false,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 8, 0, 10 + inDented),
							Size = UDim2.new(0, 156, 0, 156),
							AutoButtonColor = false,
							Image = "rbxassetid://4155801252",
							ImageColor3 = Color3.fromRGB(255, 0, 0),
							ZIndex = 33
					})
					AutoApplyBorder(Colorpick, "Picker", 33, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)
					local ColorDrag = UIUtilities:Create("Frame", {
							Name = "ColorDrag",
							Parent = Colorpick,
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BorderColor3 = Color3.fromRGB(27, 27, 27),
							Size = UDim2.new(0, 4, 0, 4),
							ZIndex = 33
					})

					local Huepick = UIUtilities:Create("ImageButton", {
							Name = "Huepick",
							Parent = Frame,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BorderColor3 = UIStyle.UIcolors.ColorA,
							ClipsDescendants = false,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 172, 0, 10 + inDented),
							Size = UDim2.new(0, 14, 0, 156),
							AutoButtonColor = false,
							Image = "rbxassetid://3641079629",
							ImageColor3 = Color3.fromRGB(255, 0, 0),
							ImageTransparency = 1,
							BackgroundTransparency = 0,
							ZIndex = 33
					})
					AutoApplyBorder(Huepick, "Picker", 33, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)
					local Huedrag = UIUtilities:Create("Frame", {
							Name = "Huedrag",
							Parent = Huepick,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BorderColor3 = UIStyle.UIcolors.ColorA,
							Size = UDim2.new(1, 0, 0, 2),
							ZIndex = 33
					})

					local HueFrameGradient = UIUtilities:Create("UIGradient", {
							Rotation = 90,
							Name = "HueFrameGradient",
							Parent = Huepick,
							Color = ColorSequence.new {
									ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
									ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 0, 255)),
									ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 0, 255)),
									ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
									ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 0)),
									ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 255, 0)),
									ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
							},  
					})

					local Transpick, Transcolor, Transdrag

					if TransparencySlider then
							Transpick = UIUtilities:Create("ImageButton", {
									Name = "Transpick",
									Parent = Frame,
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BorderColor3 = UIStyle.UIcolors.ColorA,
									Position = UDim2.new(0, 8, 0, 172 + inDented),
									Size = UDim2.new(0, 156, 0, 12),
									AutoButtonColor = false,
									Image = "rbxassetid://3887014957",
									ScaleType = Enum.ScaleType.Tile,
									TileSize = UDim2.new(0, 10, 0, 10),
									ZIndex = 33
							})
							AutoApplyBorder(Transpick, "Picker", 33, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)
							Transcolor = UIUtilities:Create("ImageLabel", {
									Name = "Transcolor",
									Parent = Transpick,
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1,
									Size = UDim2.new(1, 0, 1, 0),
									Image = "rbxassetid://3887017050",
									ImageColor3 = ColorP.BackgroundColor3,
									ZIndex = 33,
							})
							Transdrag = UIUtilities:Create("Frame", {
									Name = "Transdrag",
									Parent = Transcolor,
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BorderColor3 = UIStyle.UIcolors.ColorA,
									Position = UDim2.new(0, -1, 0, 0),
									Size = UDim2.new(0, 2, 1, 0),
									ZIndex = 33
							})
					end

					local OldColorText = UIUtilities:Create("TextLabel", {
							Name = "OldColorText",
							Parent = Frame,
							Size = UDim2.new(0, 16, 0, 14),
							Text = "Old Color",
							BackgroundTransparency = 1,
							TextColor3 = UIStyle.UIcolors.FullWhite,
							Font = UIStyle.TextFont.Font,
							LineHeight = 1.1,
							ZIndex = 34,
							Position = UDim2.new(0, 212, 0, 78 + inDented),
							TextSize = UIStyle.TextFont.TxtSize,
							TextStrokeColor3 = Color3.new(),
							TextStrokeTransparency = 0.5,
					})
					local OldColor = UIUtilities:Create("Frame", {
							Name = "OldColor",
							Parent = Frame,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BorderColor3 = UIStyle.UIcolors.ColorC,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 196, 0, 94 + inDented),
							Size = UDim2.new(0, 92, 0, 48),
							ZIndex = 35,
					})
					local OldAlpha = UIUtilities:Create("ImageButton", {
							Name = "OldAlpha",
							Parent = Frame,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BorderColor3 = UIStyle.UIcolors.ColorC,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 196, 0, 94 + inDented),
							BackgroundTransparency = 1,
							Size = UDim2.new(0, 92, 0, 48),
							ScaleType = "Tile",
							ZIndex = 34,
							Image = "rbxassetid://3887014957"
					})

					AutoApplyBorder(OldAlpha, "OldAlpha", 34, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)

					local NewColorText = UIUtilities:Create("TextLabel", {
							Name = "NewColorText",
							Parent = Frame,
							Size = UDim2.new(0, 16, 0, 14),
							Text = "New Color",
							BackgroundTransparency = 1,
							TextColor3 = UIStyle.UIcolors.FullWhite,
							Font = UIStyle.TextFont.Font,
							LineHeight = 1.1,
							ZIndex = 34,
							Position = UDim2.new(0, 212, 0, 6 + inDented),
							TextSize = UIStyle.TextFont.TxtSize,
							TextStrokeColor3 = Color3.new(),
							TextStrokeTransparency = 0.5,
					})
					local NewColor = UIUtilities:Create("Frame", {
							Name = "NewColor",
							Parent = Frame,
							BackgroundColor3 = Parameters.StartColor,
							BackgroundTransparency = Parameters.StartTrans,
							BorderColor3 = UIStyle.UIcolors.ColorC,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 196, 0, 22 + inDented),
							Size = UDim2.new(0, 92, 0, 48),
							ZIndex = 35,
					})
					local NewAlpha = UIUtilities:Create("ImageButton", {
							Name = "NewAlpha",
							Parent = Frame,
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BorderColor3 = UIStyle.UIcolors.ColorC,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 196, 0, 22 + inDented),
							BackgroundTransparency = 1,
							Size = UDim2.new(0, 92, 0, 48),
							ScaleType = "Tile",
							ZIndex = 34,
							Image = "rbxassetid://3887014957"
					})
					AutoApplyBorder(NewAlpha, "NewAlpha", 34, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)
					local YOffset = -24
					if Parameters.StartTrans then
							YOffset = -22
					end
					local ApplyButton = UIUtilities:Create("TextButton", {
							Name = "Apply",
							AutoButtonColor = false,
							Parent = Frame,
							Size = UDim2.new(0, 52, 0, 16),
							Text = "[ Apply ]",
							BackgroundTransparency = 1,
							TextColor3 = UIStyle.UIcolors.FullWhite,
							Font = UIStyle.TextFont.Font,
							LineHeight = 1.1,
							ZIndex = 34,
							Position = UDim2.new(0, 196, 0, YBounds + YOffset + inDented),
							TextSize = UIStyle.TextFont.TxtSize,
							TextStrokeColor3 = Color3.new(),
							TextStrokeTransparency = 0.5,
					})

					local CopyNewColor = UIUtilities:Create("TextButton", {
							Name = "CopyNewColor",
							Parent = NewColor,
							AutoButtonColor = false,
							Size = UDim2.new(1, 0, 0.5, 0),
							Text = "Copy",
							BackgroundTransparency = 1,
							TextColor3 = UIStyle.UIcolors.FullWhite,
							Font = UIStyle.TextFont.Font,
							Visible = false,
							LineHeight = 1.1,
							ZIndex = 35,
							Position = UDim2.new(0, 0, 0, 0),
							TextSize = UIStyle.TextFont.TxtSize,
							TextStrokeColor3 = Color3.new(),
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center,
							TextStrokeTransparency = 0.5,
					})

					local PasteNewColor = UIUtilities:Create("TextButton", {
							Name = "PasteNewColor",
							Parent = NewColor,
							AnchorPoint = Vector2.new(0, 1),
							AutoButtonColor = false,
							Size = UDim2.new(1, 0, 0.5, 0),
							Text = "Paste",
							BackgroundTransparency = 1,
							Visible = false,
							TextColor3 = UIStyle.UIcolors.FullWhite,
							Font = UIStyle.TextFont.Font,
							LineHeight = 1.1,
							ZIndex = 35,
							Position = UDim2.new(0, 0, 1, 0),
							TextSize = UIStyle.TextFont.TxtSize,
							TextStrokeColor3 = Color3.new(),
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center,
							TextStrokeTransparency = 0.5,
					})

					local CopyOldColor = UIUtilities:Create("TextButton", {
							Name = "PasteOldColor",
							Parent = OldColor,
							Size = UDim2.new(1, 0, 1, 0),
							AutoButtonColor = false,
							Text = "Copy",
							BackgroundTransparency = 1,
							TextColor3 = UIStyle.UIcolors.FullWhite,
							Visible = false,
							Font = UIStyle.TextFont.Font,
							LineHeight = 1.1,
							ZIndex = 35,
							Position = UDim2.new(0, 0, 0, 0),
							TextSize = UIStyle.TextFont.TxtSize,
							TextStrokeColor3 = Color3.new(),
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center,
							TextStrokeTransparency = 0.5,
					})

					local abc = false
					local inCP = false
					ColorP.MouseEnter:Connect(function()
							abc = true
					end)
					ColorP.MouseLeave:Connect(function()
							abc = false
					end)
					MasterFrame.MouseEnter:Connect(function()
							inCP = true
					end)
					MasterFrame.MouseLeave:Connect(function()
							inCP = false
					end)

					NewColor.MouseEnter:Connect(function()
							CopyNewColor.Visible = true
							PasteNewColor.Visible = true
					end)

					NewColor.MouseLeave:Connect(function()
							CopyNewColor.Visible = false
							PasteNewColor.Visible = false
					end)

					OldColor.MouseEnter:Connect(function()
							CopyOldColor.Visible = true
					end)

					OldColor.MouseLeave:Connect(function()
							CopyOldColor.Visible = false
					end)

					local function UpdatePickers(Color)
							ColorH, ColorS, ColorV = RGBtoHSV(Color)

							ColorH = math.clamp(ColorH, 0, 1)
							ColorS = math.clamp(ColorS, 0, 1)
							ColorV = math.clamp(ColorV, 0, 1)

							ColorDrag.Position = UDim2.new(1 - ColorS, 0, 1 - ColorV, 0)
							Colorpick.ImageColor3 = Color3.fromHSV(ColorH, 1, 1)
							Huedrag.Position = UDim2.new(0, 0, 1-ColorH, -1)
							if Transcolor then
									Transcolor.ImageColor3 = Color
							end
					end

					UpdatePickers(ColorP.BackgroundColor3)

					ColorP.MouseButton1Down:Connect(function()
							if isColorThingOpen and isColorThingOpen ~= MasterFrame then
									return
							end
							MasterFrame.Visible = not MasterFrame.Visible
							if MasterFrame.Visible == false then
									isColorThingOpen = nil
							else
									isColorThingOpen = MasterFrame
							end
							UpdatePickers(ColorP.BackgroundColor3)
							if MasterFrame.Visible then
									OldColor.BackgroundTransparency = ColorP.BackgroundTransparency
									OldColor.BackgroundColor3 = ColorP.BackgroundColor3
							end
					end)

					PasteNewColor.MouseButton1Down:Connect(function()
							if ClipboardColor then
									NewColor.BackgroundColor3 = ClipboardColor
									UpdatePickers(NewColor.BackgroundColor3)
							end
					end)

					CopyOldColor.MouseButton1Down:Connect(function()
							ClipboardColor = OldColor.BackgroundColor3
					end)

					CopyNewColor.MouseButton1Down:Connect(function()
							ClipboardColor = NewColor.BackgroundColor3
					end)

					local function updateColor()
							local ColorX = (math.clamp(Mouse.X - Colorpick.AbsolutePosition.X, 0, Colorpick.AbsoluteSize.X)/Colorpick.AbsoluteSize.X)
							local ColorY = (math.clamp(Mouse.Y - Colorpick.AbsolutePosition.Y, 0, Colorpick.AbsoluteSize.Y)/Colorpick.AbsoluteSize.Y)
							ColorDrag.Position = UDim2.new(ColorX, 0, ColorY, 0)
							ColorS = 1-ColorX
							ColorV = 1-ColorY
							Colorpick.ImageColor3 = Color3.fromHSV(ColorH, 1, 1)
							NewColor.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
							if Transcolor then
									Transcolor.ImageColor3 = NewColor.BackgroundColor3
							end
					end

					local function updateHue()
							local y = math.clamp(Mouse.Y - Huepick.AbsolutePosition.Y, 0, Huepick.AbsoluteSize.Y)
							Huedrag.Position = UDim2.new(0, 0, 0, y)
							hue = y/Huepick.AbsoluteSize.Y
							ColorH = 1-hue
							Colorpick.ImageColor3 = Color3.fromHSV(ColorH, 1, 1)
							NewColor.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
							if Transcolor then
									Transcolor.ImageColor3 = NewColor.BackgroundColor3
							end
					end
					local function updateTrans()
							if Transcolor then
									local x = math.clamp(Mouse.X - Transpick.AbsolutePosition.X, 0, Transpick.AbsoluteSize.X)
									NewColor.BackgroundTransparency = x/Transpick.AbsoluteSize.X
									Transdrag.Position = UDim2.new(0, x, 0, 0)
									Transcolor.ImageColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
							end
					end
					if Transcolor then
							Transpick.MouseButton1Down:Connect(function()
									updateTrans()
									moveconnection = Mouse.Move:Connect(function()
											updateTrans()
									end)
									releaseconnection = UserInputService.InputEnded:Connect(function(mouse)
											if mouse.UserInputType == Enum.UserInputType.MouseButton1 then
													updateTrans()
													moveconnection:Disconnect()
													releaseconnection:Disconnect()
											end
									end)
							end)
					end
					Colorpick.MouseButton1Down:Connect(function()
							updateColor()
							moveconnection = Mouse.Move:Connect(function()
									updateColor()
							end)
							releaseconnection = UserInputService.InputEnded:Connect(function(mouse)
									if mouse.UserInputType == Enum.UserInputType.MouseButton1 then
											updateColor()
											moveconnection:Disconnect()
											releaseconnection:Disconnect()
									end
							end) 
					end)

					ApplyButton.MouseButton1Down:Connect(function()
							ColorP.BackgroundColor3 = NewColor.BackgroundColor3
							ColorP.BackgroundTransparency = NewColor.BackgroundTransparency
							MasterFrame.Visible = false
							isColorThingOpen = nil
					end)

					Huepick.MouseButton1Down:Connect(function()
							updateHue()
							moveconnection = Mouse.Move:Connect(function()
									updateHue()
							end)
							releaseconnection = game:GetService("UserInputService").InputEnded:Connect(function(mouse)
									if mouse.UserInputType == Enum.UserInputType.MouseButton1 then
											updateHue()
											moveconnection:Disconnect()
											releaseconnection:Disconnect()
									end
							end)
					end)
					ColorP.BorderColor3 = Color3.fromRGB(math.clamp((ColorP.BackgroundColor3.R * 255) - 40, 40, 255), math.clamp((ColorP.BackgroundColor3.G * 255) - 40, 40, 255), math.clamp((ColorP.BackgroundColor3.B * 255) - 40, 40, 255))
					ColorP:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
							local Hue, Sat, Val = RGBtoHSV(ColorP.BackgroundColor3)
							Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Color"] = ColorP.BackgroundColor3
							Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance].Changed:Fire(ColorP.BackgroundColor3, ColorP.BackgroundTransparency)
							local Color = ColorP.BackgroundColor3
							ColorP.BorderColor3 = Color3.fromRGB(math.clamp((Color.R * 255) - 40, 40, 255), math.clamp((Color.G * 255) - 40, 40, 255), math.clamp((Color.B * 255) - 40, 40, 255))
					end)
					if Parameters.StartTrans then
							ColorP:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
									if fading == false then
											Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Transparency"] = ColorP.BackgroundTransparency
											Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance].Changed:Fire(ColorP.BackgroundColor3, ColorP.BackgroundTransparency)
											actualtrans.Value = ColorP.BackgroundTransparency
									end
							end)
					end
					table.insert(OpenCloseItems, Alpha)
					table.insert(OpenCloseItems, ColorP)

					Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Animations"] = fakeFlagsShit
					Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Animation Selection"] = dropKickFlag

					Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance] = setmetatable({}, {
							__index = function(self, i)
									return ColorProxy[i]
							end,
							__newindex = function(self, i, v)
									if i == "Color" then
											if type(v) == "table" then
													v = Color3.new(v.r, v.g, v.b)
											end
											ColorP.BackgroundColor3 = v
									elseif i == "Transparency" then
											ColorP.BackgroundTransparency = v
									elseif i == "Animations" then
											for anim, data in next, v do
													for name, values in next, data do
															if v[anim][name]["Value"] then
																	fakeFlagsShit[anim][name]["Value"] = v["Value"]
															elseif v[anim][name]["Color"] then
																	fakeFlagsShit[anim][name]["Color"] = Color3.new(v[anim][name]["Color"].r, v[anim][name]["Color"].g, v[anim][name]["Color"].b)
																	if v[anim][name]["Transparency"] then
																			fakeFlagsShit[anim][name]["Transparency"] = v[anim][name]["Transparency"]
																	end
															end
													end
											end
									end
									ColorProxy[i] = v
							end
					})

					local animationLoop
					reUpdate = function(anim)
							if animationLoop then
									animationLoop:Disconnect()
							end
							if anim == "Rainbow" then
									animationLoop = RunService.Stepped:Connect(function()
											local oldhue, oldsat, oldval = Color3.toHSV(Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Color"])
											Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Color"] = (Color3.fromHSV((tick() * (fakeFlagsShit["Rainbow"]["Speed"]["Value"] / 100) - math.floor(tick() * (fakeFlagsShit["Rainbow"]["Speed"]["Value"] / 100))), oldsat, oldval))
									end)
							elseif anim == "Linear" then
									animationLoop = RunService.Stepped:Connect(function()
											local percentage = (tick() * (fakeFlagsShit["Linear"]["Speed"]["Value"] / 100) - math.floor(tick() * (fakeFlagsShit["Linear"]["Speed"]["Value"] / 100)))
											if percentage > 0.5 then
													percentage = percentage - 0.5
													percentage = percentage * 2
													Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Color"] = fakeFlagsShit["Linear"]["Keyframe 2"]["Color"]:Lerp(fakeFlagsShit["Linear"]["Keyframe 1"]["Color"], percentage)
													if Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Transparency"] then
															local a = fakeFlagsShit["Linear"]["Keyframe 2"]["Transparency"]
															local b = fakeFlagsShit["Linear"]["Keyframe 1"]["Transparency"]
															local c = percentage
															Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Transparency"] = (a + (b - a)*c)
													end
											else
													percentage = percentage * 2
													Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Color"] = (fakeFlagsShit["Linear"]["Keyframe 1"]["Color"]:Lerp(fakeFlagsShit["Linear"]["Keyframe 2"]["Color"], percentage))
													if Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Transparency"] then
															local a = fakeFlagsShit["Linear"]["Keyframe 1"]["Transparency"]
															local b = fakeFlagsShit["Linear"]["Keyframe 2"]["Transparency"]
															local c = percentage
															Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Transparency"] = (a + (b - a)*c)
													end
											end
									end)
							elseif anim == "Oscillating" then
									animationLoop = RunService.Stepped:Connect(function()
											local percentage = (tick() * (fakeFlagsShit["Oscillating"]["Speed"]["Value"] / 100) - math.floor(tick() * (fakeFlagsShit["Oscillating"]["Speed"]["Value"] / 100)))
											if percentage > 0.5 then
													percentage = percentage - 0.5
													Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Color"] = (fakeFlagsShit["Oscillating"]["Keyframe 2"]["Color"]:Lerp(fakeFlagsShit["Oscillating"]["Keyframe 1"]["Color"], math.sin(percentage * math.pi)))
													if Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Transparency"] then
															local a = fakeFlagsShit["Oscillating"]["Keyframe 2"]["Transparency"]
															local b = fakeFlagsShit["Oscillating"]["Keyframe 1"]["Transparency"]
															local c = math.sin(percentage * math.pi)
															Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Transparency"] = (a + (b - a)*c)
													end
											else
													Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Color"] = (fakeFlagsShit["Oscillating"]["Keyframe 1"]["Color"]:Lerp(fakeFlagsShit["Oscillating"]["Keyframe 2"]["Color"], math.sin(percentage * math.pi)))
													if Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Transparency"] then
															local a = fakeFlagsShit["Oscillating"]["Keyframe 1"]["Transparency"]
															local b = fakeFlagsShit["Oscillating"]["Keyframe 2"]["Transparency"]
															local c = math.sin(percentage * math.pi)

															Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Transparency"] = (a + (b - a)*c)
													end
											end
									end)
							elseif anim == "Strobe" then
									animationLoop = RunService.Stepped:Connect(function()
											local percentage = (tick() * (fakeFlagsShit["Strobe"]["Speed"]["Value"] / 100) - math.floor(tick() * (fakeFlagsShit["Strobe"]["Speed"]["Value"] / 100)))
											if percentage > 0.5 then
													Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Color"] = fakeFlagsShit["Strobe"]["Keyframe 2"]["Color"]
													if Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Transparency"] then
															Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Transparency"] = (fakeFlagsShit["Strobe"]["Keyframe 2"]["Transparency"])
													end
											else
													Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Color"] = fakeFlagsShit["Strobe"]["Keyframe 1"]["Color"]
													if Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Transparency"] then
															Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Transparency"] = (fakeFlagsShit["Strobe"]["Keyframe 1"]["Transparency"])
													end
											end
									end)
							elseif anim == "Sawtooth" then
									animationLoop = RunService.Stepped:Connect(function()
											local percentage = (tick() * (fakeFlagsShit["Sawtooth"]["Speed"]["Value"] / 100) - math.floor(tick() * (fakeFlagsShit["Sawtooth"]["Speed"]["Value"] / 100)))
											Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Color"] = (fakeFlagsShit["Sawtooth"]["Keyframe 1"]["Color"]:Lerp(fakeFlagsShit["Sawtooth"]["Keyframe 2"]["Color"], percentage))
											if Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Transparency"] then
													local a = fakeFlagsShit["Sawtooth"]["Keyframe 1"]["Transparency"]
													local b = fakeFlagsShit["Sawtooth"]["Keyframe 2"]["Transparency"]
													local c = percentage
													Menu[Parameters.Tab][Parameters.Section][Parameters.ObjectName]["Color " .. Parameters.Stance]["Transparency"] = (a + (b - a)*c)
											end
									end)
							end
					end
			end

			local function CreateKeyBindThing(Parented, Default, Tab, Section, ObjectName)
					local Options = {"Hold", "Toggle", "Hold Off", "Always"}
					Menu[Tab][Section][ObjectName]["Bind"] = {}
					Menu[Tab][Section][ObjectName]["Bind"]["Activation Type"] = Options[1]
					Menu[Tab][Section][ObjectName]["Bind"]["Key"] = Default
					Menu[Tab][Section][ObjectName]["Bind"]["Active"] = false
					Menu[Tab][Section][ObjectName]["Bind"].Changed = Signal.new()
					local BindsProxy = Menu[Tab][Section][ObjectName]["Bind"]

					UILibrary:AddKeyBindList(Section .. ": " .. ObjectName)
					local corresponding = KeyBindList[Section .. ": " .. ObjectName] 
					corresponding.Text = ObjectName .. ": Disabled"
					local Bind = UIUtilities:Create("TextButton", {
							AnchorPoint = Vector2.new(0, 0.5),
							Name = "Bind",  
							BackgroundColor3 = UIStyle.UIcolors.ColorE,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = UDim2.new(1, -44, 0.5, 0),
							Parent = Parented,
							Size = UDim2.new(0, 36, 1, 4),
							ZIndex = 26,
							Text = Default,
							TextColor3 = UIStyle.UIcolors.FullWhite,
							Font = UIStyle.TextFont.Font,
							LineHeight = 1.1,
							TextSize = UIStyle.TextFont.TxtSize,
							TextStrokeColor3 = Color3.new(),
							TextStrokeTransparency = 0.5,
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center
					})
					local FakeBind = UIUtilities:Create("Frame", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							Name = "Fake",  
							BackgroundColor3 = UIStyle.UIcolors.ColorE,
							BackgroundTransparency = 0,
							BorderSizePixel = 0,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Parent = Bind,
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 25,
					})
					table.insert(OpenCloseItems, FakeBind)
					local Val = UIUtilities:Create("StringValue", {
							Name = "RealKey",
							Parent = Bind,
							Value = "None"
					})
					local a, b, c = AutoApplyBorder(Bind, "Bind", 24, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH, true)
					local ActivationMethod = UIUtilities:Create("StringValue", {
							Name = "BindType",
							Parent = Bind,
							Value = "Always"
					})
					local Dropdown = UIUtilities:Create("Frame", {
							AnchorPoint = Vector2.new(0, 0),
							Parent = Bind,
							Name = "Type",
							BackgroundColor3 = UIStyle.UIcolors.ColorI,
							Visible = false,
							ZIndex = 31,
							Size = UDim2.new(0, 68, 0, 6 + TextService:GetTextSize(Options[1], UIStyle.TextFont.TxtSize, UIStyle.TextFont.Font, Vector2.new(900, 900)).Y * 4),
							Position = UDim2.new(0, 0, 1, 4),
							BorderSizePixel = 0,
					})
					AutoApplyBorder(Dropdown, "Options Outline", 31, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)
					local inDropDown = false
					Dropdown.MouseEnter:Connect(function()
							inDropDown = true
					end)
					Dropdown.MouseLeave:Connect(function()
							inDropDown = false
					end)
					local Connection
					local UpdateConnection
					Bind.MouseButton2Click:Connect(function()
							for i, v in next, (Dropdown:GetChildren()) do
									if v:IsA("TextButton") then
											if v.Text == Menu[Tab][Section][ObjectName]["Bind"]["Activation Type"] then
													v.TextColor3 = UIStyle.UIcolors.Accent
											else
													v.TextColor3 = UIStyle.UIcolors.FullWhite
											end
									end
							end
							Dropdown.Visible = true
							for i, v in next, (Dropdown:GetChildren()) do
									if v:IsA("TextButton") then
											if v.Text == Menu[Tab][Section][ObjectName]["Bind"]["Activation Type"] then
													v.TextColor3 = UIStyle.UIcolors.Accent
											else
													v.TextColor3 = UIStyle.UIcolors.FullWhite
											end
									end
							end
							Connection = UserInputService.InputBegan:Connect(function(input)
									if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
											if not inDropDown then
													Dropdown.Visible = false
													Connection:Disconnect()
											end
									end
							end)
					end)
					for i, v in next, (Options) do
							local Button = UIUtilities:Create("TextButton", {
									Name = v,   
									BackgroundTransparency = 1,
									Position = UDim2.new(0, 2, 0, (i - 1) * (TextService:GetTextSize(Options[1], UIStyle.TextFont.TxtSize, UIStyle.TextFont.Font, Vector2.new(900, 900)).Y + 2)),
									Parent = Dropdown,
									Size = UDim2.new(1, 0, 0, 18),
									ZIndex = 31,
									Text = v,
									TextColor3 = UIStyle.UIcolors.FullWhite,
									Font = UIStyle.TextFont.Font,
									LineHeight = 1,
									TextSize = UIStyle.TextFont.TxtSize,
									TextStrokeColor3 = Color3.new(),
									TextStrokeTransparency = 0,
									TextXAlignment = Enum.TextXAlignment.Left,
									TextYAlignment = Enum.TextYAlignment.Center
							})
							Button.MouseButton1Down:Connect(function()
									Menu[Tab][Section][ObjectName]["Bind"]["Activation Type"] = Button.Text
									ActivationMethod.Value = Menu[Tab][Section][ObjectName]["Bind"]["Activation Type"]
									Dropdown.Visible = false
							end)
					end     
					table.insert(OpenCloseItems, Bind)

					local thing = ObjectName
					if thing == "Enabled" then
							thing = Section
					end
					corresponding.Text = thing .. ": Disabled"
					local function Updater()
							if Connection then
									Connection:Disconnect()
							end
							if AuxUpdateConnection then
									AuxUpdateConnection:Disconnect()
							end
							if UpdateConnection then
									UpdateConnection:Disconnect()
							end
							if Menu[Tab][Section][ObjectName]["Bind"]["Activation Type"] ~= Options[2] then
									UpdateConnection =  RunService.Heartbeat:Connect(function()
											if Menu[Tab][Section][ObjectName]["Toggle"]["Enabled"] then
													if Menu[Tab][Section][ObjectName]["Bind"]["Activation Type"] == Options[4] then 
															Menu[Tab][Section][ObjectName]["Bind"]["Active"] = true
															Menu[Tab][Section][ObjectName]["Bind"].Changed:Fire(true)
															corresponding.Text = Section .. ": " .. ObjectName
													end
													if Menu[Tab][Section][ObjectName]["Bind"]["Activation Type"] == Options[1] then
															if Bind.Text ~= "None" and UserInputService:IsKeyDown(tostring(Menu[Tab][Section][ObjectName]["Bind"]["Key"]):sub(14)) then
																	Menu[Tab][Section][ObjectName]["Bind"]["Active"] = true
																	Menu[Tab][Section][ObjectName]["Bind"].Changed:Fire(true)
																	corresponding.Text = Section .. ": " .. ObjectName
															else
																	Menu[Tab][Section][ObjectName]["Bind"]["Active"] = false
																	Menu[Tab][Section][ObjectName]["Bind"].Changed:Fire(false)
																	corresponding.Text = thing .. ": Disabled"
															end
													end
													if Menu[Tab][Section][ObjectName]["Bind"]["Activation Type"] == Options[3] then
															if Bind.Text ~= "None" and UserInputService:IsKeyDown(tostring(Menu[Tab][Section][ObjectName]["Bind"]["Key"]):sub(14)) then
																	corresponding.Text = thing .. ": Disabled"
																	Menu[Tab][Section][ObjectName]["Bind"]["Active"] = false
																	Menu[Tab][Section][ObjectName]["Bind"].Changed:Fire(false)
															else
																	Menu[Tab][Section][ObjectName]["Bind"]["Active"] = true
																	Menu[Tab][Section][ObjectName]["Bind"].Changed:Fire(true)
																	corresponding.Text = Section .. ": " .. ObjectName
															end
													end
											else
													corresponding.Text = thing .. ": Disabled"
											end
									end)
							else
									UpdateConnection = UserInputService.InputBegan:Connect(function(Input, gameProcessed)
											if Menu[Tab][Section][ObjectName]["Bind"]["Key"] == "None" then return end
											if Input.UserInputType == Enum.UserInputType.Keyboard then
													local keyPressed = Input.KeyCode
													if Bind.Text ~= "None" and tostring(keyPressed) == tostring(Menu[Tab][Section][ObjectName]["Bind"]["Key"]) then
															if Parameters.Callback ~= nil then
																	Parameters.Callback(Menu[Tab][Section][ObjectName]["Toggle"]["Enabled"], Menu[Tab][Section][ObjectName]["Bind"]["Active"])
															end
															Menu[Tab][Section][ObjectName]["Bind"]["Active"] = not Menu[Tab][Section][ObjectName]["Bind"]["Active"]
															Menu[Tab][Section][ObjectName]["Bind"].Changed:Fire(Menu[Tab][Section][ObjectName]["Bind"]["Active"])
															if Menu[Tab][Section][ObjectName]["Bind"]["Active"] then
																	corresponding.Text = Section .. ": " .. ObjectName
															else
																	corresponding.Text =  thing .. ": Disabled"
															end
													end
											end
									end)
							end
					end

					Updater()
					ActivationMethod.Changed:Connect(function()
							Menu[Tab][Section][ObjectName]["Bind"]["Activation Type"] = ActivationMethod.Value
							Updater()
					end)

					local recording = false

					UserInputService.InputBegan:Connect(function(Input, gameProcessed)
							if recording == true and Input.UserInputType == Enum.UserInputType.Keyboard then
									if Input.KeyCode.Value == 27 then 
											Val.Value = "None"
											Menu[Tab][Section][ObjectName]["Bind"]["Key"] = "None"
											Bind.Text = "None"
									else
											local key = tostring(Input.KeyCode)
											Val.Value = key:sub(14)
											Menu[Tab][Section][ObjectName]["Bind"]["Key"] = Input.KeyCode
											Bind.Text = string.sub(string.upper(Val.Value), 1, 4)
									end
									recording = false
									b.BackgroundColor3 = UIStyle.UIcolors.ColorG
							end
					end)

					Val.Changed:Connect(function()
							if not recording then
									local key = Val.Value
									if key == "" or key == "None" then
											Menu[Tab][Section][ObjectName]["Bind"]["Key"] = "None"
											Bind.Text = "None"
									else
											Menu[Tab][Section][ObjectName]["Bind"]["Key"] = Enum.KeyCode[key]
											Bind.Text = string.upper(string.sub(key, 1, 4))
									end
							end
					end)
					local function onButtonActivated()
							b.BackgroundColor3 = UIStyle.UIcolors.Accent
							Bind.Text = "None"
							recording = true
					end
					Bind.MouseButton1Down:Connect(onButtonActivated)

					Menu[Tab][Section][ObjectName]["Bind"] = setmetatable({}, {
							__index = function(self, i)
									return BindsProxy[i]
							end,
							__newindex = function(self, i, v)
									if i == "Key" and not recording then
											Val.Value = tostring(v):sub(14)
									elseif i == "Activation Type" then
											ActivationMethod.Value = v
									end
									BindsProxy[i] = v
							end
					})
					Menu[Tab][Section][ObjectName]["Bind"]["Activation Type"] = "Always"
			end

			local MessageLogs = UIUtilities:Create("Frame", {
					AnchorPoint = Vector2.new(0, 0),
					BackgroundTransparency = 1,
					Parent = Core,
					Position = UDim2.new(0, 12, 0, -2),
					Size = UDim2.new(0, 317, 0, 532)
			})

			local MessageLogsListOrganizer = UIUtilities:Create("UIListLayout", {
					Parent = MessageLogs,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Top
			})

			UILibrary.Watermark = UIUtilities:Create("Frame", {
					AnchorPoint = Vector2.new(0, 1),
					BackgroundColor3 = Color3.fromRGB(40, 40, 40),
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(40, 40, 40),
					Visible = false,
					BorderMode = Enum.BorderMode.Outline,
					BorderSizePixel = 0,
					Name = "Watermark",
					Parent = Core, 
					Position = UDim2.new(0, 12, 0, -10),
					Size = UDim2.new(0, 428, 0, 24),
					ZIndex = 1
			})

			local WatermarkAccent = UIUtilities:Create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(40, 40, 40),
					BorderSizePixel = 0,
					Name = "UI",
					Parent = UILibrary.Watermark,
					Position = UDim2.new(0.5, 0, 0, 1),
					Size = UDim2.new(1, 0, 0, 2),
					ZIndex = 2
			})
			UILibrary.Watermark.MouseEnter:Connect(function()
					UIUtilities:Tween(UILibrary.Watermark, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), { BackgroundTransparency = 1, Active = false })
					--UIUtilities:Tween(WatermarkAccent, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), { BackgroundTransparency = 1, Active = false })
					UIUtilities:Tween(WatermarkText, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), { TextTransparency = 1, Active = false })
			end)

			UILibrary.Watermark.MouseLeave:Connect(function()
					UIUtilities:Tween(UILibrary.Watermark, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), { BackgroundTransparency = 0, Active = true })
				 -- UIUtilities:Tween(WatermarkAccent, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), { BackgroundTransparency = 0, Active = true })
					UIUtilities:Tween(WatermarkText, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), { TextTransparency = 0, Active = true })
			end)

			local months = {"Jan.","Feb.","Mar.","Apr.","May","Jun.","Jul.","Aug.","Sep.","Oct.","Nov.","Dec."}
			local daysinmonth = {31,28,31,30,31,30,31,31,30,31,30,31}

			local function getDate()
					local time = os.time()
					local year = math.floor(time/60/60/24/365.25+1970)
					local day = math.ceil(time/60/60/24%365.25)
					local month
					for i=1, #daysinmonth do
							if day > daysinmonth[i] then
									day = day - daysinmonth[i]
							else
									month = i
									break
							end
					end
					return month, day, year
			end

            function UILibrary:EventLog(Message, Time) -- laziness below
              --thread(function()
                      local MoveTime = 1
                      local FadeTime = 0.25
                      local TweenStyling = Enum.EasingStyle.Quint
                      local TweenDir = Enum.EasingDirection.Out
                      
                      local maxWidth = 60
                      local text = Message
                      local msgsize = TextService:GetTextSize(Message, UIStyle.HeaderFont.WatermarkTxtSize, UIStyle.HeaderFont.Font, Vector2.new(9999999999999999999999999999999, 0))
                      do -- WARNING !! ALAN CODE AHEAD!!
                              local split = text:split("")
                              local lastspaceidx = 0 -- the text idx that the last space is
                              local charinline = 0
                              for i, v in next, (split) do
                                      charinline = charinline + 1
                                      if v == " " then
                                              lastspaceidx = i
                                      end
                                      if charinline >= maxWidth then
                                              split[lastspaceidx] = "\n" -- insert a thing
                                              charinline = 0
                                      end
                              end
                              text = ""
                              for i, v in next, (split) do
                                      text = text .. v
                              end
                      end
                      -- ok most of the gayness is over
                      local split = text:split("\n")
                      local textlinelength = {}
                      local verticalLength = 8
                      for i, v in next, (split) do
                              local d = TextService:GetTextSize(v, UIStyle.HeaderFont.WatermarkTxtSize, UIStyle.HeaderFont.Font, Vector2.new(9999999999999999999999999999999, 0))
                              textlinelength[i] = d.x
                              verticalLength = verticalLength + d.y
                      end
                      table.sort(textlinelength, function(a, b) return a > b end)
                      local longestthing = textlinelength[1]
                      local FakeBackGround = UIUtilities:Create("Frame", {
                              AnchorPoint = Vector2.new(0, 0),
                              BackgroundColor3 = UIStyle.UIcolors.FullWhite,
                              BackgroundTransparency = 1,
                              BorderColor3 = UIStyle.UIcolors.FullWhite,
                              BorderMode = Enum.BorderMode.Outline,
                              BorderSizePixel = 0,
                              Name = "Event",
                              Parent = MessageLogs, 
                              Position = UDim2.new(0, 0, 0, 0),
                              Size = UDim2.new(0, longestthing + 12, 0, verticalLength),
                              ZIndex = 1
                      })
                      local EventLogContainer = UIUtilities:Create("Frame", {
                              AnchorPoint = Vector2.new(0, 0),
                              BackgroundColor3 = UIStyle.UIcolors.FullWhite,
                              BackgroundTransparency = 1,
                              BorderColor3 = UIStyle.UIcolors.FullWhite,
                              BorderMode = Enum.BorderMode.Outline,
                              BorderSizePixel = 0,
                              Name = "Event",
                              Parent = FakeBackGround,
                              Position = UDim2.new(0, -msgsize.X + 32, 0, 0),
                              Size = UDim2.new(1, 0, 1, -4),
                              ZIndex = 1
                      })
                      local BackGroundStyling = UIUtilities:Create("UIGradient", {
                              Color = ColorSequence.new({
                                      ColorSequenceKeypoint.new(0, UIStyle.UIcolors.ColorD),
                                      ColorSequenceKeypoint.new(1, UIStyle.UIcolors.ColorA)
                              }),
                              Rotation = 90,
                              Parent = EventLogContainer
                      })
                      local BackGroundAccent = UIUtilities:Create("Frame", {
                              AnchorPoint = Vector2.new(0, 0),
                              BackgroundColor3 = UIStyle.UIcolors.FullWhite,
                              BorderSizePixel = 0,
                              BackgroundTransparency = 1,
                              Name = "UI",
                              Parent = EventLogContainer,
                              Position = UDim2.new(0, 0, 0, 0),
                              Size = UDim2.new(0, 2, 1, 0),
                              ZIndex = 2
                      })
                      local Hue, Sat, Val = RGBtoHSV(UIStyle.UIcolors.Accent)
                      local BackGroundAccentStyling = UIUtilities:Create("UIGradient", {
                              Color = ColorSequence.new({
                                      ColorSequenceKeypoint.new(0, Color3.fromHSV(Hue, Sat, Val - 0.1)),
                                      ColorSequenceKeypoint.new(1, Color3.new(UIStyle.UIcolors.Accent.R, UIStyle.UIcolors.Accent.G, UIStyle.UIcolors.Accent.B))
                              }),
                              Rotation = 180,
                              Parent = BackGroundAccent
                      })
                      local BackGroundText = UIUtilities:Create("TextLabel", {
                              AnchorPoint = Vector2.new(1, 0),
                              BackgroundTransparency = 1, 
                              Position = UDim2.new(1, 0, 0, 0),
                              Parent = EventLogContainer,
                              Size = UDim2.new(1, -6, 1, 0),
                              ZIndex = 2,
                              Font = UIStyle.HeaderFont.Font,
                              LineHeight = 1.1,
                              Text = text,
                              TextColor3 = UIStyle.UIcolors.FullWhite,
                              TextSize = UIStyle.HeaderFont.WatermarkTxtSize,
                              TextTransparency = 1,
                              TextStrokeColor3 = Color3.new(),
                              TextStrokeTransparency = 1,
                              TextXAlignment = Enum.TextXAlignment.Left,
                              TextYAlignment = Enum.TextYAlignment.Center
                      })
                      local DurationBar = UIUtilities:Create("Frame", {
                          AnchorPoint = Vector2.new(0, 1),
                          BackgroundColor3 = UIStyle.UIcolors.Accent,
                          BorderSizePixel = 0,
                          Name = "DurationBar",
                          Parent = EventLogContainer,
                          Position = UDim2.new(0, 0, 1, 0),
                          Size = UDim2.new(1, 0, 0, 2),
                          ZIndex = 3
                      })							
                      coroutine.wrap(function()
                          local targetSize = UDim2.new(0, longestthing + 12, 0, verticalLength)
                              FakeBackGround.Size = UDim2.new(0, 0, 0, 0)
                              UIUtilities:Tween(
                                  FakeBackGround,
                                  TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                                  {Size = targetSize}
                              )
                              UIUtilities:Tween(
                                      EventLogContainer,
                                      TweenInfo.new(FadeTime, TweenStyling, TweenDir),
                                      {BackgroundTransparency = 0}
                              )
                              UIUtilities:Tween(
                                      BackGroundAccent,
                                      TweenInfo.new(FadeTime, TweenStyling, TweenDir),
                                      {BackgroundTransparency = 0}
                              )
                              UIUtilities:Tween(
                                      BackGroundText,
                                      TweenInfo.new(FadeTime, TweenStyling, TweenDir),
                                      {TextTransparency = 0}
                              )
                              EventLogContainer:TweenPosition(
                                      UDim2.new(0, 0, 0, 0),
                                      TweenDir,
                                      TweenStyling,
                                      MoveTime
                              )
                              realWait(MoveTime)
                              UIUtilities:Tween(
                                  DurationBar,
                                  TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
                                  {Size = UDim2.new(0, 0, 0, 2)}
                              )
                              realWait(Time)
                              MoveTime = 1
                              FadeTime = 0.75
                              TweenDir = Enum.EasingDirection.In
                              UIUtilities:Tween(
                                      EventLogContainer,
                                      TweenInfo.new(FadeTime, TweenStyling, TweenDir),
                                      {BackgroundTransparency = 1}
                              )
                              UIUtilities:Tween(
                                      BackGroundAccent,
                                      TweenInfo.new(FadeTime, TweenStyling, TweenDir),
                                      {BackgroundTransparency = 1}
                              )
                              UIUtilities:Tween(
                                      BackGroundText,
                                      TweenInfo.new(FadeTime, TweenStyling, TweenDir),
                                      {TextTransparency = 1}
                              )
                              EventLogContainer:TweenPosition(
                                      UDim2.new(0, -msgsize.X + 48, 0, 0),
                                      TweenDir,
                                      TweenStyling,
                                      MoveTime
                              )

                              realWait(FadeTime)
                              FakeBackGround:Destroy()
                      end)()
              --end)
      end
			
			local SpectatorList = UIUtilities:Create("Frame", {
					AnchorPoint = Vector2.new(1, 0),
					BackgroundTransparency = 1,
					Parent = Core,
					Position = UDim2.new(1, -8, 0.2, 0),
					Size = UDim2.new(0, 317, 0, 532)
			})

			local SpectatorListOrganizer = UIUtilities:Create("UIListLayout", {
					Parent = SpectatorList,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Top
			})

			UILibrary.KeyBindContainer = UIUtilities:Create("Frame", {
					AnchorPoint = Vector2.new(0, 0),
					BackgroundTransparency = 1,
					Parent = Core,
					Visible = false,
					Position = UDim2.new(0, 8, 0.45, 0),
					Size = UDim2.new(0, 256, 0, 532)
			})
			local KeyBindContainerOrganizer = UIUtilities:Create("UIListLayout", {
					Parent = UILibrary.KeyBindContainer,
					Padding = UDim.new(0, -18),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Top
			})
				 UILibrary.UseListSize = false
	function UILibrary:AddKeyBindList(KeyBindName)
		local KeyBindTitleFakeBackGround = UIUtilities:Create("Frame", {
			AnchorPoint = Vector2.new(0, 0),
			Visible = true,
			BackgroundColor3 = UIStyle.UIcolors.FullWhite,
			BackgroundTransparency = 1,
			BorderColor3 = UIStyle.UIcolors.FullWhite,
			BorderMode = Enum.BorderMode.Outline,
			BorderSizePixel = 0,
			Name = KeyBindName,
			Parent = UILibrary.KeyBindContainer, 
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, 14),
			ZIndex = 6
		})
		local KeyBindTitleEventLogContainer = UIUtilities:Create("Frame", {
			AnchorPoint = Vector2.new(0, 0),
			BackgroundColor3 = UIStyle.UIcolors.FullWhite,
			BackgroundTransparency = 0,
			BorderColor3 = UIStyle.UIcolors.FullWhite,
			BorderMode = Enum.BorderMode.Outline,
			BorderSizePixel = 0,
			Name = KeyBindName,
			Parent = KeyBindTitleFakeBackGround, 
			Position = UDim2.new(0, 0, 0, 3),
			Size = UDim2.new(1, 0, 0, 18),
			ZIndex = 7
		})
		local KeyBindTitleBackGroundStyling
		if KeyBindName == "Keybinds" then -- too lazy srry
			local PercentageCover = 10/KeyBindTitleFakeBackGround.AbsoluteSize.Y
			KeyBindTitleBackGroundStyling = UIUtilities:Create("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, UIStyle.UIcolors.ColorD),
					ColorSequenceKeypoint.new(PercentageCover - PercentageCover/8, UIStyle.UIcolors.ColorA),
					ColorSequenceKeypoint.new(1, UIStyle.UIcolors.ColorA)
				}),
				Rotation = 90,
				Parent = KeyBindTitleEventLogContainer
			})
		else
			KeyBindTitleBackGroundStyling = UIUtilities:Create("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, UIStyle.UIcolors.ColorA),
					ColorSequenceKeypoint.new(1, UIStyle.UIcolors.ColorA)
				}),
				Rotation = 0,
				Parent = KeyBindTitleEventLogContainer
			})
		end
					local v1 = UIUtilities:Create("Frame", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = UIStyle.UIcolors.ColorC,
							BorderSizePixel = 0,
							Name = "v1",
							Parent = KeyBindTitleEventLogContainer,
							Position = UDim2.new(0.5, 0, 0.5, -1),
							Size = UDim2.new(1, 2, 1, 3),
							ZIndex = 5
					})
					local v2 = UIUtilities:Create("Frame", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = UIStyle.UIcolors.ColorB,
							BorderSizePixel = 0,
							Name = "v2",
							Parent = v1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(1, 2, 1, 2),
							ZIndex = v1.ZIndex - 1
					})
					local KeyBindTitleBackGroundAccent = UIUtilities:Create("Frame", {
							AnchorPoint = Vector2.new(0.5, 0),
							BackgroundColor3 = Color3.fromRGB(40, 40, 40),
							BorderSizePixel = 0,
							BorderColor3 = UIStyle.UIcolors.ColorG,
							BackgroundTransparency = 0,
							Name = KeyBindName,
							Parent = KeyBindTitleFakeBackGround,
							Position = UDim2.new(0.5, 0, 0, 1),
							Size = UDim2.new(1, 0, 0, 2),
							ZIndex = 6
					})
					local KeyBindTitleBackGroundAccentBorder = UIUtilities:Create("Frame", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = Color3.fromRGB(40, 40, 40),
							BorderSizePixel = 0,
							BorderColor3 = Color3.fromRGB(40, 40, 40),
							BackgroundTransparency = 0,
							Name = "nut",
							Parent = KeyBindTitleBackGroundAccent,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(1, 1, 1, 1),
							ZIndex = 4
					})
					local KeyBindTitleHue, KeyBindTitleSat, KeyBindTitleVal = RGBtoHSV(UIStyle.UIcolors.Accent)
					local KeyBindTitleBackGroundAccentStyling = UIUtilities:Create("UIGradient", {
							Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, Color3.fromHSV(KeyBindTitleHue, KeyBindTitleSat, KeyBindTitleVal - 0.1)),
									ColorSequenceKeypoint.new(1, Color3.new(UIStyle.UIcolors.Accent.R, UIStyle.UIcolors.Accent.G, UIStyle.UIcolors.Accent.B))
							}),
							Rotation = 90,
							Parent = KeyBindTitleBackGroundAccent
					})
					table.insert(UIAccents, KeyBindTitleBackGroundAccentStyling)
					local KeyBindTitleBackGroundText = UIUtilities:Create("TextLabel", {
							AnchorPoint = Vector2.new(1, 0.5),
							BackgroundTransparency = 1, 
							Position = UDim2.new(1, 0, 0.5, 0),
							Parent = KeyBindTitleEventLogContainer,
							Name = "TEXTEFFECT",
							Size = UDim2.new(1, -4, 1, 0),
							Position = UDim2.new(1, 4, 0, 9),
							ZIndex = 7,
							Font = UIStyle.HeaderFont.Font,
							LineHeight = 1,
							Text = KeyBindName,
							TextColor3 = UIStyle.UIcolors.FullWhite,
							TextSize = UIStyle.HeaderFont.WatermarkTxtSize,
							TextTransparency = 0,
							TextStrokeColor3 = Color3.new(),
							TextStrokeTransparency = 1,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center
					})
					KeyBindList[KeyBindName] = KeyBindTitleBackGroundText
					KeyBindTitleFakeBackGround.Size = UDim2.new(0, TextService:GetTextSize(KeyBindName, UIStyle.HeaderFont.WatermarkTxtSize, UIStyle.HeaderFont.Font, Vector2.new(10000, 0)).X + 8, 0, 36)
					local function UpdateSize()
							if UILibrary.UseListSize then
									for i, v in next, (KeyBindList) do
											v.Parent.Parent.Size = UDim2.new(0, TextService:GetTextSize(v.Text, UIStyle.HeaderFont.WatermarkTxtSize, UIStyle.HeaderFont.Font, Vector2.new(10000, 0)).X + 8, 0, 36)
									end
							else
									local biggest = 0
									for i, v in next, (KeyBindList) do
											local size = TextService:GetTextSize(v.Text, UIStyle.HeaderFont.WatermarkTxtSize, UIStyle.HeaderFont.Font, Vector2.new(10000, 0)).X + 8
											if v.Visible and size > biggest then
													biggest = size
											end
									end
									KeyBindTitleBackGroundText.Size = UDim2.new(0, biggest, 0, 36)
									for i, v in next, (KeyBindList) do
											v.Parent.Parent.Size = UDim2.new(0, biggest, 0, 36) 
									end
							end
					end
					KeyBindTitleBackGroundText:GetPropertyChangedSignal("Text"):Connect(function()
							KeyBindTitleFakeBackGround.Size = UDim2.new(0, TextService:GetTextSize(KeyBindTitleBackGroundText.Text, UIStyle.HeaderFont.WatermarkTxtSize, UIStyle.HeaderFont.Font, Vector2.new(10000, 0)).X + 8, 0, 36)
							UpdateSize()
					end)
					KeyBindTitleFakeBackGround:GetPropertyChangedSignal("Size"):Connect(function()
							KeyBindTitleBackGroundText.Size = KeyBindTitleFakeBackGround.Size
					end)
					KeyBindTitleBackGroundText:GetPropertyChangedSignal("Visible"):Connect(function()
							KeyBindTitleFakeBackGround.Visible = KeyBindTitleBackGroundText.Visible
							UpdateSize()
					end)
					KeyBindTitleBackGroundText.Visible = false
			end
			UILibrary:AddKeyBindList("Keybinds")
			KeyBindList["Keybinds"].Visible = true
			local MainContainer = UIUtilities:Create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = UIStyle.UIcolors.FullWhite,
					BorderSizePixel = 0,
					Name = "UI",
					Parent = Core,
					Position = UDim2.new(0.5, 0, 0.5, -18),
					Size = UDim2.new(0, 400, 0, 635),
					ZIndex = 6,
					Active = true, 
					Selectable = true, 
			})

			local MainContainerOutline, MainContainerOutlinev1, MainContainerOutlinev2 = AutoApplyBorder(MainContainer, "A", 6, UIStyle.UIcolors.ColorC, UIStyle.UIcolors.ColorB, true)
			local MainContainerAccent, MainContainerAccentStyling = AutoApplyAccent(MainContainer, "A", 7, true)
			table.insert(OpenCloseItems, MainContainer)

			local MainContainerBackGroundGradient = UIUtilities:Create("UIGradient",{
					Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, UIStyle.UIcolors.ColorD),
							ColorSequenceKeypoint.new(0.06, UIStyle.UIcolors.ColorA),
							ColorSequenceKeypoint.new(1, UIStyle.UIcolors.ColorA)
					}),
					Rotation = 90,
					Parent = MainContainer
			})

			UILibrary.CheatNameText = UIUtilities:Create("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 1, 4),
					Size = UDim2.new(1, 0, 0, 14),
					ZIndex = 8,
					Font = UIStyle.TextFont.Font,
					Text = UIStyle.CheatName,
					Parent = MainContainerAccent,
					TextColor3 = UIStyle.UIcolors.FullWhite,
					LineHeight = 1.2,
					TextSize = UIStyle.TextFont.CheatTextSize,
					TextStrokeColor3 = Color3.new(),
					TextStrokeTransparency = 0.5,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center
			})
			table.insert(OpenCloseItems, UILibrary.CheatNameText)

			local CheatNameTextPadding = UIUtilities:Create("UIPadding", {
					Parent = UILibrary.CheatNameText,
					PaddingLeft = UDim.new(0, 4)
			})

			local RunService = game:GetService("RunService")
			local TextService = game:GetService("TextService")
			local Workspace = game:GetService("Workspace")
			
			local month, day, year = getDate()
			
			local UIServices = game:GetService("RunService")
			--[[local WatermarkText = UIUtilities:Create("TextLabel", {
					AnchorPoint = Vector2.new(0, 0),
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 0, 0),
					Parent = UILibrary.Watermark,
					Size = UDim2.new(1, 0, 1, 0),
					ZIndex = 2,
					Font = UIStyle.HeaderFont.Font,
					LineHeight = 1,
					Text = "",
					TextColor3 = Color3.new(1, 1, 1),
					TextSize = UIStyle.HeaderFont.WatermarkTxtSize,
					TextStrokeColor3 = Color3.new(),
					TextStrokeTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					RichText = true -- RICH TEXT$$$$
			})

			local rainbowSaturation = 0.6 -- $$$$
			local rainbowBrightness = 1
			local function getRainbowColor(hue)
					return Color3.fromHSV(hue % 1, rainbowSaturation, rainbowBrightness)
			end

			local oscillationSpeed = 2 -- speed
			local hueOffset = 0 

			local function animateTextWithRainbow(message, deltaTime)
					hueOffset = hueOffset + deltaTime * oscillationSpeed 

					local animatedText = "" 
					for i = 1, #message do
							local char = message:sub(i, i)
							local hue = (hueOffset + i * 0.1) % 1 
							local color = getRainbowColor(hue)
							local colorHex = string.format("#%02X%02X%02X", color.R * 255, color.G * 255, color.B * 255)
							animatedText = animatedText .. string.format('<font color="%s">%s</font>', colorHex, char)
					end

					return animatedText
			end
			--spoofingfps
					local fps = 0
					local deltaTimeAccumulator = 0
					local frameCount = 0
					local fpsUpdateInterval = 1 
					--[[ UNSPOOFED
					local function updateFPS(deltaTime)
							deltaTimeAccumulator = deltaTimeAccumulator + deltaTime
							frameCount = frameCount + 1

							if deltaTimeAccumulator >= fpsUpdateInterval then
									fps = math.floor(frameCount / deltaTimeAccumulator)
									frameCount = 0
									deltaTimeAccumulator = 0
							end
					end]]--
					-- SPOOFED
					--[[local function updateFPS(deltaTime)
							deltaTimeAccumulator = deltaTimeAccumulator + deltaTime
							frameCount = frameCount + 1
					
							if deltaTimeAccumulator >= fpsUpdateInterval then
									local actualFPS = math.floor(frameCount / deltaTimeAccumulator)
									fps = actualFPS * 3
									frameCount = 0
									deltaTimeAccumulator = 0
							end
					end
					--
					local function getObjectCount()
							return #Workspace:GetChildren()
					end

					local function getPlayerSpeed()
							local character = game.Players.LocalPlayer.Character
							if character and character:FindFirstChild("HumanoidRootPart") then
									return math.floor(character.HumanoidRootPart.Velocity.Magnitude)
							end
							return 0 
					end

					local month, day, year = getDate()

					local function setWatermarkText(deltaTime)
							local objectCount = getObjectCount()
							local playerSpeed = getPlayerSpeed() 
							local rawMessage = tostring(UILibrary.CheatNameText.Text) ..
									"  |  " .. Parameters.UserType ..
									"  |  " .. tostring(months[month]) .. " " .. tostring(day) .. " " .. tostring(year) ..
									"  |  FPS: " .. fps ..
									"  |  Objects: " .. objectCount ..
									"  |  Speed: " .. playerSpeed .. " studs/s" 

							local animatedText = animateTextWithRainbow(rawMessage, deltaTime)
							local fullsize = TextService:GetTextSize(rawMessage, UIStyle.HeaderFont.WatermarkTxtSize, UIStyle.HeaderFont.Font, Vector2.new(16000, 0))
							UILibrary.Watermark.Size = UDim2.new(0, fullsize.X + 24, 0, fullsize.Y + 8)
							WatermarkText.Text = animatedText
					end


					UIServices.Heartbeat:Connect(function(deltaTime)
							updateFPS(deltaTime)
							setWatermarkText(deltaTime)
					end)


					function UILibrary.Setwatermarkcheatname(text)
							local objectCount = getObjectCount()
							local playerSpeed = getPlayerSpeed()
							local rawMessage = text ..
									"  |  " .. Parameters.UserType ..
									"  |  " .. tostring(months[month]) .. " " .. tostring(day) .. " " .. tostring(year) ..
									"  |  FPS: " .. fps ..
									"  |  Objects: " .. objectCount ..
									"  |  Speed: " .. playerSpeed .. " studs/s"

							local animatedText = animateTextWithRainbow(rawMessage, 0) 
							local fullsize = TextService:GetTextSize(rawMessage, UIStyle.HeaderFont.WatermarkTxtSize, UIStyle.HeaderFont.Font, Vector2.new(16000, 0))
							UILibrary.Watermark.Size = UDim2.new(0, fullsize.X + 24, 0, fullsize.Y + 8)
							WatermarkText.Text = animatedText
					end

					-- Set rainbow color for customization
					function UILibrary.SetRainbowColor(saturation, brightness)
							rainbowSaturation = saturation or 0.4  -- Default value if none provided
							rainbowBrightness = brightness or 1    -- Default value if none provided
					end
			--]]
			local MainTabsContainer = UIUtilities:Create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = UIStyle.UIcolors.FullWhite,
					BorderSizePixel = 0,
					Name = "UI",
					Parent = MainContainer,
					Position = UDim2.new(0.5, 0, 0.5, 7),
					Size = UDim2.new(1, -16, 1, -30),
					ZIndex = 9,
			})
			local MainTabsContainerOutline, MainTabsContainerOutlinev1, MainTabsContainerOutlinev2 = AutoApplyBorder(MainTabsContainer, "B", 9, UIStyle.UIcolors.ColorC, UIStyle.UIcolors.ColorB, true)
			local AccentB, AccentBStyling = AutoApplyAccent(MainTabsContainer, "B", 10, true)
			table.insert(OpenCloseItems, MainTabsContainer)

			local MainTabsContainerBackGroundGradient = UIUtilities:Create("UIGradient",{
					Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, UIStyle.UIcolors.ColorD),
							ColorSequenceKeypoint.new(0.06, UIStyle.UIcolors.ColorA),
							ColorSequenceKeypoint.new(1, UIStyle.UIcolors.ColorA)
					}),
					Rotation = 90,
					Parent = MainTabsContainer
			})

			local TabsHolder = UIUtilities:Create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Name = "UI",
					Parent = MainTabsContainer,
					Position = UDim2.new(0.5, 0, 0, 4),
					Size = UDim2.new(1, 0, 0, 34),
					ZIndex = 12
			})

			local TopBar = UIUtilities:Create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
					BackgroundColor3 = UIStyle.UIcolors.ColorF,
					Name = "UI",
					Parent = MainTabsContainer,
					Position = UDim2.new(0.5, 0, 0, 2),
					Size = UDim2.new(1, 0, 0, 2),
					ZIndex = 12
			})
			table.insert(OpenCloseItems, TopBar)

			local BottomBar = UIUtilities:Create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
					BackgroundColor3 = UIStyle.UIcolors.ColorF,
					Name = "UI",
					Parent = MainTabsContainer,
					Position = UDim2.new(0.5, 0, 1, -1),
					Size = UDim2.new(1, 0, 0, 1),
					ZIndex = 12
			})
			table.insert(OpenCloseItems, BottomBar)

			local LeftBar = UIUtilities:Create("Frame", {
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
					BackgroundColor3 = UIStyle.UIcolors.ColorF,
					Name = "UI",
					Parent = MainTabsContainer,
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.new(0, 1, 1, 0),
					ZIndex = 9
			})
			table.insert(OpenCloseItems, LeftBar)

			local RightBar = UIUtilities:Create("Frame", {
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
					BackgroundColor3 = UIStyle.UIcolors.ColorF,
					Name = "UI",
					Parent = MainTabsContainer,
					Position = UDim2.new(1, -1, 0.5, 0),
					Size = UDim2.new(0, 1, 1, 0),
					ZIndex = 9
			})
			table.insert(OpenCloseItems, RightBar)

			local UIListLayoutTabsHolder = UIUtilities:Create("UIListLayout", {
					Padding = UDim.new(0, 4),
					Parent = TabsHolder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center
			})

			local TabsContainer = UIUtilities:Create("Frame", {
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = 1,
					BorderSizePixel = 1,
					Parent = MainTabsContainer,
					Position = UDim2.new(0, 0, 1, -2),
					Size = UDim2.new(1, 0, 1, -36),
					Visible = true,
			})

			for k, v in next, UIStyle.Tabs do
					local ClickAble = UIUtilities:Create("TextButton", {
							Active = true,
							BackgroundColor3 = UIStyle.UIcolors.ColorB,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Name = v,
							Parent = TabsHolder, 
							Selectable = true,
							Size = UDim2.new(1/#UIStyle.Tabs, -4, 1, -4),
							ZIndex = 12,
							Font = UIStyle.TextFont.Font,
							Text = v,
							TextColor3 = Color3.fromHSV(0, 0, 0.7),
							TextSize = UIStyle.TextFont.TabTextSize,
							LineHeight = 1.38,
							TextStrokeColor3 = Color3.new(),
							TextStrokeTransparency = 0.5,
							TextXAlignment = Enum.TextXAlignment.Center,
							TextYAlignment = Enum.TextYAlignment.Center
					})
					table.insert(OpenCloseItems, ClickAble)
					local ClickAbleStyling = UIUtilities:Create("Frame", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = UIStyle.UIcolors.ColorE,
							BorderColor3 = UIStyle.UIcolors.ColorF,
							BorderMode = Enum.BorderMode.Middle,
							BorderSizePixel = 2,
							Name = "Out",
							Parent = ClickAble,
							Position = UDim2.new(0.5, 0, 0.5, -2),
							Size = UDim2.new(1, 4, 1, 2),
							ZIndex = 11
					})
					table.insert(OpenCloseItems, ClickAbleStyling)
					local Button = ClickAble
					local function OpenTab()
							ClickAbleStyling.Visible = false
							for k4, v4 in next, (TabsHolder:GetChildren()) do
									if v4:FindFirstChild("Out") then
											if v4.Text == ClickAble.Text then
													v4.TextColor3 = UIStyle.UIcolors.FullWhite
											else
													v4.TextColor3 = Color3.fromHSV(0, 0, 0.8)
											end
											for k5, v5 in next, (v4:GetChildren()) do
													if v4.Name == ClickAble.Text then
															v5.Visible = false
													else
															v5.Visible = true
													end
											end
									end
							end
							for k3, v3 in next, (CheatSections) do
									if v3.Name == ClickAble.Text then
											v3.Visible = true
									else
											v3.Visible = false
									end
							end
					end
					Button.MouseButton1Down:Connect(OpenTab)
					if k == 1 then
							thread(function()
									realWait()
									OpenTab()
							end)
					end
					Menu[v] = {}
					SubSections[v] = {}
			end

			for k2, v2 in next, UIStyle.Tabs do
					local CorrespondingTab = UIUtilities:Create("Frame", {
							BackgroundTransparency = 1,
							Name = v2,
							Parent = TabsContainer,
							Size = UDim2.new(1, 0, 1, -4),
							Visible = false,
							ZIndex = 10
					})
					table.insert(CheatSections, CorrespondingTab)
					local LeftSection = UIUtilities:Create("Frame", {
							AnchorPoint = Vector2.new(0, 0),
							BackgroundTransparency = 1,
							Name = "L",
							Parent = CorrespondingTab,
							Position = UDim2.new(0, 8, 0, 10),
							Size = UDim2.new(0.5, -14, 1, -12),
							Visible = true,
							ZIndex = 11
					})
					local LStabilizer = UIUtilities:Create("UIListLayout", {
							Padding = UDim.new(0, 8),
							Parent = LeftSection,
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder,
							VerticalAlignment = Enum.VerticalAlignment.Top
					})
					local RightSection = UIUtilities:Create("Frame", {
							AnchorPoint = Vector2.new(0, 0),
							BackgroundTransparency = 1,
							Name = "R",
							Parent = CorrespondingTab,
							Position = UDim2.new(0.5, 6, 0, 10),
							Size = UDim2.new(0.5, -14, 1, -12),
							Visible = true,
							ZIndex = 11
					})
					local RStabilizer = UIUtilities:Create("UIListLayout", {
							Padding = UDim.new(0, 8),
							Parent = RightSection,
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder,
							VerticalAlignment = Enum.VerticalAlignment.Top
					})
			end

			function UILibrary:CreateSubSection(CheatSection, Tag, SubSubSections, RightSide, Sizeing, Comp)
					local Current, Side
					if RightSide == true then 
							Side = "R"
					else
							Side = "L"
					end
					for k6, v6 in next, CheatSections do
							if v6.Name == CheatSection then
									Current = v6
							end
					end
					if #SubSubSections <= 1 then
							for k7, v7 in next, SubSubSections do
									local Contained = UIUtilities:Create("Frame",{
											AnchorPoint = Vector2.new(0, 0),
											BackgroundTransparency = 0,
											BackgroundColor3 = UIStyle.UIcolors.FullWhite,
											Name = Tag,
											BorderSizePixel = 0,
											Parent = Current[Side],
											Position = UDim2.new(0, 0, 0, 0),
											Size = UDim2.new(1, 0, Sizeing, Comp),
											Visible = true,
											ZIndex = 18
									})
									table.insert(OpenCloseItems, Contained)
									AutoApplyBorder(Contained, v7, 18, UIStyle.UIcolors.ColorC, UIStyle.UIcolors.ColorB, true)
									AutoApplyAccent(Contained, v7, 18, UIStyle.UIcolors.ColorC, UIStyle.UIcolors.ColorB, true)
									local SubTabTag = UIUtilities:Create("TextLabel",{
											BackgroundTransparency = 1,
											BorderSizePixel = 0,
											Position = UDim2.new(0, 0, 0, 4),
											Size = UDim2.new(1, 0, 0, 16),
											ZIndex = 19,
											Font = UIStyle.TextFont.Font,
											Text = v7,
											Parent = Contained,
											TextColor3 = UIStyle.UIcolors.FullWhite,
											TextSize = UIStyle.TextFont.TxtSize,
											TextStrokeColor3 = Color3.new(),
											TextStrokeTransparency = 0.5,
											TextXAlignment = Enum.TextXAlignment.Left,
											TextYAlignment = Enum.TextYAlignment.Center
									})
									table.insert(OpenCloseItems, SubTabTag)
									local ContainedSection = UIUtilities:Create("Frame", {
											AnchorPoint = Vector2.new(0, 1),
											BackgroundTransparency = 1,
											BorderSizePixel = 0,
											Name = v7,
											Parent = Contained,
											Position = UDim2.new(0, 0, 1, 0),
											Size = UDim2.new(1, 0, 1, -26),
											ZIndex = 19
									})
									local ContainedSectionOrganizer = UIUtilities:Create("UIListLayout", {
											Padding = UDim.new(0, 8),
											Parent = ContainedSection,
											SortOrder = Enum.SortOrder.LayoutOrder
									})
									local Absolute = Contained.AbsoluteSize
									local YSize = Absolute.Y
									local PercentageCover = 24/YSize
									local ContainedStyling = UIUtilities:Create("UIGradient", {
											Color = ColorSequence.new({
													ColorSequenceKeypoint.new(0, UIStyle.UIcolors.ColorD),
													ColorSequenceKeypoint.new(PercentageCover - PercentageCover/8, UIStyle.UIcolors.ColorA),
													ColorSequenceKeypoint.new(1, UIStyle.UIcolors.ColorA)
											}),
											Rotation = 90,
											Parent = Contained
									})
									local CheatNameTextPadding = UIUtilities:Create("UIPadding", {
											Parent = SubTabTag, 
											PaddingLeft = UDim.new(0, 6),
									})
									Menu[CheatSection][v7] = {}
									SubSections[CheatSection][v7] = ContainedSection
							end
					else
							local Contained = UIUtilities:Create("Frame",{
									AnchorPoint = Vector2.new(0, 0),
									BackgroundTransparency = 0,
									BackgroundColor3 = UIStyle.UIcolors.FullWhite,
									Name = Tag,
									BorderSizePixel = 0,
									Parent = Current[Side],
									Position = UDim2.new(0, 0, 0, 0),
									Size = UDim2.new(1, 0, Sizeing, Comp),
									Visible = true,
									ZIndex = 18
							})
							table.insert(OpenCloseItems, Contained)
							AutoApplyBorder(Contained, "G", 18, UIStyle.UIcolors.ColorC, UIStyle.UIcolors.ColorB, true)
							AutoApplyAccent(Contained, "G", 19, UIStyle.UIcolors.ColorC, UIStyle.UIcolors.ColorB, true)
							local Absolute = Contained.AbsoluteSize
							local YSize = Absolute.Y
							local PercentageCover = 24/YSize
							local ContainedStyling = UIUtilities:Create("UIGradient", {
									Color = ColorSequence.new({
											ColorSequenceKeypoint.new(0, Color3.fromRGB(54, 54, 54)),
											ColorSequenceKeypoint.new(PercentageCover - PercentageCover/10, UIStyle.UIcolors.ColorA),
											ColorSequenceKeypoint.new(1, UIStyle.UIcolors.ColorA)
									}),
									Rotation = 90,
									Parent = Contained
							})
							local Holder = UIUtilities:Create("Frame", {
									AnchorPoint = Vector2.new(0.5, 0),
									BackgroundColor3 = UIStyle.UIcolors.ColorB,
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									Name = "Holder",
									Parent = Contained,
									Position = UDim2.new(0.5, 0, 0, 4),
									Size = UDim2.new(1, -4, 0, 16),
									ZIndex = 18
							})
							local HolderOrganizer = UIUtilities:Create("UIListLayout", {
									Padding = UDim.new(0, 2),
									Parent = Holder,
									FillDirection = Enum.FillDirection.Horizontal,
									HorizontalAlignment = Enum.HorizontalAlignment.Left,
									SortOrder = Enum.SortOrder.LayoutOrder,
									VerticalAlignment = Enum.VerticalAlignment.Center
							})
							local SubSectionsSizePixel = 0
							for k7, v7 in next, SubSubSections do
									local ElTextSize = UIStyle.TextFont.TxtSize
									local TextSize = TextService:GetTextSize(
											v7,
											ElTextSize,
											UIStyle.TextFont.Font,
											Vector2.new(1000, 1000)
									)
									local ClickAble2 = UIUtilities:Create("TextButton", {
											AnchorPoint = Vector2.new(0, 0),
											AutoButtonColor = false,
											BackgroundColor3 = UIStyle.UIcolors.ColorE,
											BackgroundTransparency = 1,
											BorderColor3 = UIStyle.UIcolors.ColorF,
											BorderSizePixel = 2,
											Name = v7,
											Parent = Holder,
											Size = UDim2.new(0, TextSize.X + 8, 1, 0),
											ZIndex = 19,
											Font = UIStyle.TextFont.Font,
											Text = v7,
											TextColor3 = Color3.fromHSV(0, 0, 0.7),
											TextSize = UIStyle.TextFont.TxtSize,
											TextStrokeColor3 = Color3.new(),
											TextStrokeTransparency = 0.5,
											TextXAlignment = Enum.TextXAlignment.Center,
											TextYAlignment = Enum.TextYAlignment.Center
									})
									table.insert(OpenCloseItems, ClickAble2)
									SubSectionsSizePixel = SubSectionsSizePixel + TextSize.X + 8
									local Spacer = UIUtilities:Create("Frame", {
											BackgroundColor3 = UIStyle.UIcolors.ColorE,
											BackgroundTransparency = 0,
											BorderColor3 = UIStyle.UIcolors.ColorF,
											BorderSizePixel = 2,
											Name = "Spacer",
											Parent = ClickAble2,
											Size = UDim2.new(1, 0, 1, 0),
											ZIndex = 18
									})
									table.insert(OpenCloseItems, Spacer)
									local SubSubSectionContainer = UIUtilities:Create("Frame", {
											Active = false,
											AnchorPoint = Vector2.new(0, 1),
											BackgroundTransparency = 1,
											Parent = Contained,
											Name = v7,
											Position = UDim2.new(0, 0, 1, 0),
											Size = UDim2.new(1, 0, 1, -32),
											Visible = false
									})
									local ContainedSectionOrganizer = UIUtilities:Create("UIListLayout", {
											Padding = UDim.new(0, 8),
											Parent = SubSubSectionContainer,
											SortOrder = Enum.SortOrder.LayoutOrder
									})
									local Button = ClickAble2
									function OpenSubSection()
											for k8, v8 in next, (Holder:GetChildren()) do
													if v8:FindFirstChild("Spacer") and v8:IsA("TextButton") then
															for k9, v9 in next, (v8:GetChildren()) do
																	if v8.Text == ClickAble2.Text then
																			v8.TextColor3 = Color3.fromHSV(0, 0, 1)
																	else
																			v8.TextColor3 = Color3.fromHSV(0, 0, 0.8)
																	end
																	if v8.Name == ClickAble2.Text then
																			v9.Visible = false
																	else
																			v9.Visible = true
																	end
															end
													end
											end
											for kA, vA in next, (Contained:GetChildren()) do
													if vA.Name == ClickAble2.Text and vA:IsA("Frame") then
															vA.Visible = true
													elseif vA.Name ~= ClickAble2.Text and vA:IsA("Frame") and vA.Name ~= "UI" and vA.Name ~= "Holder" then
															vA.Visible = false
													end
											end
									end
									if k7 == 1 then
											OpenSubSection()
									end
									Button.MouseButton1Down:Connect(OpenSubSection)
									Menu[CheatSection][v7] = {}
									SubSections[CheatSection][v7] = SubSubSectionContainer
							end
							local modify = 4
							if #SubSubSections >= 3 then
									modify = 4 + (2 * (#SubSubSections - 2))
							end
							local Filler = UIUtilities:Create("Frame", {
									BackgroundColor3 = UIStyle.UIcolors.ColorE,
									BackgroundTransparency = 0,
									BorderColor3 = UIStyle.UIcolors.ColorF,
									BorderSizePixel = 2,
									Name = "FILLER",
									Parent = Holder,
									Size = UDim2.new(1, (-1 * SubSectionsSizePixel) - modify, 1, 0),
									ZIndex = 18
							})
							table.insert(OpenCloseItems, Filler)
					end
			end

			function UILibrary:CreateButton(Parameters)
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name] = {}
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"] = {}
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"].Changed = Signal.new()
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name].Save = function()
							return Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Color 2"] and {
									["Toggle"] = {
											["Enabled"] = Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"]["Enabled"]
									},
									["Color 1"] = Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Color 1"].Save(),
									["Color 2"] = Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Color 2"].Save(),
							} or Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Color 1"] and {
									["Toggle"] = {
											["Enabled"] = Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"]["Enabled"]
									},
									["Color 1"] = Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Color 1"].Save(),
							} or Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Bind"] and {
									["Toggle"] = {
											["Enabled"] = Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"]["Enabled"]
									},
									["Bind"] = {
											["Activation Type"] = Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Bind"]["Activation Type"],
											["Key"] = tostring(Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Bind"]["Key"]),
									}
							} or {
									["Toggle"] = {
											["Enabled"] = Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"]["Enabled"]
									}
							}
					end
					local Proxy = Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"]
					local Hitbox = UIUtilities:Create("TextButton", {
							BackgroundTransparency = 1,
							Name = Parameters.Name,
							Parent = SubSections[Parameters.Tab][Parameters.Section],
							Size = UDim2.new(1, 0, 0, 8),
							Visible = true,
							ZIndex = 19,
							Text = ""
					})

					if Parameters.Tooltip then
							Hitbox.MouseEnter:Connect(function()
									UILibrary.CallToolTip(Parameters.Tooltip, Hitbox.AbsolutePosition, Hitbox.AbsolutePosition + Vector2.new(8, 16), Hitbox.AbsoluteSize)
							end)
					end

					local Bool = UIUtilities:Create("BoolValue", {
							Name = Parameters.Name,
							Parent = Hitbox,
							Value = false
					})
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"]["Enabled"] = Bool.Value
					local ClickMask = UIUtilities:Create("Frame", {
							BackgroundColor3 = UIStyle.UIcolors.ColorD,
							BackgroundTransparency = 0,
							AnchorPoint = Vector2.new(0, 0.5),
							BorderSizePixel = 0,
							Name = "ButtonMask",
							Parent = Hitbox,
							Position = UDim2.new(0, 8, 0.5, 0),
							Size = UDim2.new(0, 8, 0, 8),
							ZIndex = 24
					})
					table.insert(UIAccents, ClickMask)
					table.insert(OpenCloseItems, ClickMask)
					AutoApplyBorder(ClickMask, Parameters.Name, 24, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH, true)
					local ClickMaskStyling = UIUtilities:Create("UIGradient", {
							Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
									ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 160, 160))
							}),
							Rotation = 90,
							Parent = ClickMask
					})
					local TextBox = UIUtilities:Create("TextLabel", {
							AnchorPoint = Vector2.new(1, 0),
							BackgroundTransparency = 1,
							Parent = Hitbox,
							Position = UDim2.new(1, 0, 0, 0),
							Size = UDim2.new(1, -22, 1, 0),
							ZIndex = 19,
							Text = Parameters.Name,
							TextColor3 = UIStyle.UIcolors.FullWhite,
							Font = UIStyle.TextFont.Font,
							LineHeight = 1.05,
							TextSize = UIStyle.TextFont.TxtSize,
							TextStrokeColor3 = Color3.new(),
							TextStrokeTransparency = 0.5,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center
					})
					table.insert(OpenCloseItems, TextBox)
					if Parameters.Colors then
							for i, v in next, (Parameters.Colors) do
									CreateColorThing({Pos = -1 * (((i - 1) * 24) + (10 * i - 1)), Parented = Hitbox, Stance = i, StartColor = v, StartTrans = Parameters.Transparency and Parameters.Transparency[i], Tab = Parameters.Tab, ObjectName = Parameters.Name, Section = Parameters.Section})
							end
					else
							if Parameters.KeyBind then
									CreateKeyBindThing(Hitbox, Parameters.KeyBind, Parameters.Tab, Parameters.Section, Parameters.Name)
							end 
					end
							--[[Hitbox.MouseButton1Down:Connect(function()
									Bool.Value = not Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"]["Enabled"]
									Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"]["Enabled"] = Bool.Value
									Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"].Changed:Fire(Bool.Value)
							end)]]
					Hitbox.MouseButton1Down:Connect(function()
							if isColorThingOpen then return end
							Bool.Value = not Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"]["Enabled"]
					end)

					Bool.Changed:Connect(function()
							Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"]["Enabled"] = Bool.Value
							Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"].Changed:Fire(Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"]["Enabled"])
							if Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"]["Enabled"] == true then
									ClickMask.BackgroundColor3 = UIStyle.UIcolors.Accent
							else
									ClickMask.BackgroundColor3 = UIStyle.UIcolors.ColorD
							end
							if Parameters.KeyBind then
									KeyBindList[Parameters.Section .. ": " .. Parameters.Name].Visible = Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"]["Enabled"]
									if Parameters.Callback then
											Parameters.Callback(Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"]["Enabled"], Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Bind"]["Active"])
									end
									Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"].Changed:Fire(v, Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Bind"]["Active"])
							else
									if Parameters.Callback then
											Parameters.Callback(Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"]["Enabled"])
									end
									Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"].Changed:Fire(Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"]["Enabled"])
							end
					end)

					Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Toggle"] = setmetatable({}, {
							__index = function(self, i)
									return Proxy[i]
							end,
							__newindex = function(self, i, v) -- so that you can do Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"] = true or false
									if i == "Enabled" then-- if ur tryna set the value of the toggle
											Bool.Value = v
									end
									Proxy[i] = v
							end
					})
			end
							function UILibrary:CreateSlider(Parameters) -- Parameters.MaximumNumber
					Parameters.DefaultValue = Parameters.DefaultValue and math.max(math.min(Parameters.DefaultValue, Parameters.MaximumNumber), Parameters.MinimumNumber) or nil

					if Parameters.Precision and Parameters.Precision > 0 then
							Parameters.DefaultValue = Parameters.DefaultValue and math.round(Parameters.DefaultValue / Parameters.Precision) * Parameters.Precision or nil
					end
					
					Parameters.Precision = Parameters.Precision or 1
			
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name] = {}
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name].Changed = Signal.new()
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name].Save = function()
							return {["Value"] = Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"]}
					end
			
					local Proxy = Menu[Parameters.Tab][Parameters.Section][Parameters.Name]
					if not Parameters.Suffix then
							Parameters.Suffix = ""
					end
						local Slider = UIUtilities:Create("Frame", {
								Name = Parameters.Name,
								Parent = SubSections[Parameters.Tab][Parameters.Section],
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1,
								ZIndex = 22,
								Position = UDim2.new(0, 0, 0, 0),
								Size = UDim2.new(1, 0, 0, 20)
						})
						local TextLabel = UIUtilities:Create("TextButton", {
								Parent = Slider,
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1,
								Position = UDim2.new(0, 8, 0, -4),
								Size = UDim2.new(1, 0, 0, 15),
								Font = UIStyle.TextFont.Font,
								ZIndex = 22,
								Text = Parameters.Name,
								TextColor3 = UIStyle.UIcolors.FullWhite,
								TextStrokeColor3 = Color3.new(),
								LineHeight = 1.2,
								TextStrokeTransparency = 0.5,
								TextSize = UIStyle.TextFont.TxtSize,
								TextXAlignment = Enum.TextXAlignment.Left
						})
						local AddText = UIUtilities:Create("TextButton", {
								Parent = Slider,
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1,
								Position = UDim2.new(1, -32, 0, -4),
								Size = UDim2.new(0, 8, 0, 15),
								Font = UIStyle.TextFont.Font,
								ZIndex = 22,
								Visible = false,
								Text = "+",
								TextColor3 = UIStyle.UIcolors.FullWhite,
								TextStrokeColor3 = Color3.new(),
								TextStrokeTransparency = 0.5,
								TextSize = UIStyle.TextFont.TxtSize,
								TextXAlignment = Enum.TextXAlignment.Center
						})
						local SubtractText = UIUtilities:Create("TextButton", {
								Parent = Slider,
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1,
								Position = UDim2.new(1, -22, 0, -4),
								Size = UDim2.new(0, 8, 0, 15),
								Font = UIStyle.TextFont.Font,
								ZIndex = 22,
								Visible = false,
								Text = "-",
								TextColor3 = UIStyle.UIcolors.FullWhite,
								TextStrokeColor3 = Color3.new(),
								TextStrokeTransparency = 0.5,
								TextSize = UIStyle.TextFont.TxtSize,
								TextXAlignment = Enum.TextXAlignment.Center
						})
						table.insert(OpenCloseItems, TextLabel)
						local Button = UIUtilities:Create("TextButton", {
								AnchorPoint = Vector2.new(0.5, 0),
								Name = "Button",
								Parent = Slider,
								BackgroundTransparency = 1,
								BackgroundColor3 = UIStyle.UIcolors.ColorD,
								BorderSizePixel = 0,
								Position = UDim2.new(0.5, 0, 0, 12),
								Size = UDim2.new(1, -18, 0, 8),
								AutoButtonColor = false,
								ZIndex = 21,
								Text = ""
						})
						local ButtonStyle = UIUtilities:Create("Frame", {
								AnchorPoint = Vector2.new(0.5, 0.5),
								Name = "Button",
								Parent = Button,
								BackgroundTransparency = 0,
								BackgroundColor3 = UIStyle.UIcolors.ColorD,
								BorderSizePixel = 0,
								Position = UDim2.new(0.5, 0, 0.5, 0),
								Size = UDim2.new(1, 0, 1, 0),
								ZIndex = 22
						})
						local ButtonStyleStyling = UIUtilities:Create("UIGradient", {
								Color = ColorSequence.new({
										ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
										ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
								}),
								Rotation = 90,
								Parent = ButtonStyle
						})
						table.insert(OpenCloseItems, ButtonStyle)
						AutoApplyBorder(ButtonStyle, Parameters.Name, 22, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH, true)
						local Frame = UIUtilities:Create("Frame", {
								Parent = Button,
								BackgroundColor3 = UIStyle.UIcolors.Accent,
								BorderSizePixel = 0,
								ZIndex = 22,
								Size = UDim2.new(0, (Parameters.DefaultValue and (Parameters.DefaultValue - Parameters.MinimumNumber) or 0) / (Parameters.MaximumNumber - Parameters.MinimumNumber) * Button.AbsoluteSize.X, 1, 0)
						})
						
						local FrameStyling = UIUtilities:Create("UIGradient", {
								Color = ColorSequence.new({
										ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
										ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
								}),
								Rotation = 90,
								Parent = Frame
						})
						table.insert(UIAccents, Frame)
						table.insert(OpenCloseItems, Frame)
						--local sliderText = (Parameters.DefaultValue and ((Parameters.MaximumText and Parameters.DefaultValue == Parameters.MaximumNumber) and Parameters.MaximumText) or ((Parameters.MinimumText and Parameters.DefaultValue == Parameters.MinimumNumber) and Parameters.MinimumText) or Parameters.DefaultValue) or (Parameters.MinimumText or Parameters.MinimumNumber .. Parameters.Suffix)
						local Value = UIUtilities:Create("TextLabel", {
								AnchorPoint = Vector2.new(0.5, 0.5),
								Name = "Value",
								Parent = ButtonStyle,
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BackgroundTransparency = 1,
								Position = UDim2.new(0.5, 0, 0.5, 0),
								Size = UDim2.new(1, 0, 0, 2),
								LineHeight = 1.1,
								Font = UIStyle.TextFont.Font,
								Text = (Parameters.DefaultValue and ((Parameters.MaximumText and Parameters.DefaultValue == Parameters.MaximumNumber) and Parameters.MaximumText) or ((Parameters.MinimumText and Parameters.DefaultValue == Parameters.MinimumNumber) and Parameters.MinimumText) or Parameters.DefaultValue) or (Parameters.MinimumText or Parameters.MinimumNumber .. Parameters.Suffix), -- Text = Parameters.DefaultValue or Parameters.MinimumText or Parameters.MinimumNumber .. Parameters.Suffix,
								ZIndex = 24,
								TextColor3 = UIStyle.UIcolors.FullWhite,
								TextStrokeColor3 = Color3.new(),
								TextStrokeTransparency = 0.5,
								TextSize = UIStyle.TextFont.TxtSize,
								TextXAlignment = Enum.TextXAlignment.Center
						})
						table.insert(OpenCloseItems, Value)
						local NumberValue = UIUtilities:Create("NumberValue", {
								Value = Parameters.DefaultValue or Parameters.MinimumNumber,
								Parent = Slider,
								Name = Parameters.Name
						})
						Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"] = NumberValue.Value
						local mouse = Mouse
						local val
						local Absolute = Button.AbsoluteSize.X
						local Moving = false
				
						if Parameters.Tooltip then
								Button.MouseEnter:Connect(function()
										UILibrary.CallToolTip(Parameters.Tooltip, Button.AbsolutePosition, Button.AbsolutePosition + Vector2.new(0, 16), Button.AbsoluteSize)
								end)
						end
				
						Button.MouseButton1Down:Connect(function()
								if moveconnection then moveconnection:Disconnect() end
								if releaseconnection then releaseconnection:Disconnect() end
								if isColorThingOpen then return end
								Moving = true
				
								Frame.Size = UDim2.new(0, math.clamp(mouse.X - Frame.AbsolutePosition.X, 0, Absolute), 1, 0)
								val = (((Parameters.MaximumNumber - Parameters.MinimumNumber) / Absolute) * Frame.AbsoluteSize.X) + Parameters.MinimumNumber
								val = math.round(val / Parameters.Precision) * Parameters.Precision
								NumberValue.Value = val
				
								moveconnection = mouse.Move:Connect(function()
										Frame.Size = UDim2.new(0, math.clamp(mouse.X - Frame.AbsolutePosition.X, 0, Absolute), 1, 0)
										val = (((Parameters.MaximumNumber - Parameters.MinimumNumber) / Absolute) * Frame.AbsoluteSize.X) + Parameters.MinimumNumber
										val = math.round(val / Parameters.Precision) * Parameters.Precision
										NumberValue.Value = val
								end)
				
								releaseconnection = UserInputService.InputEnded:Connect(function(Mouse)
										if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then
												moveconnection:Disconnect()
												releaseconnection:Disconnect()
												Moving = false
										end
								end)
						end)
				
						NumberValue.Changed:Connect(function()
								NumberValue.Value = math.clamp(NumberValue.Value, Parameters.MinimumNumber, Parameters.MaximumNumber)
								if not Moving then
										local Portion = (NumberValue.Value - Parameters.MinimumNumber) / (Parameters.MaximumNumber - Parameters.MinimumNumber)
										Frame.Size = UDim2.new(Portion, 0, 1, 0)
										val = (((Parameters.MaximumNumber - Parameters.MinimumNumber) / Absolute) * Frame.AbsoluteSize.X) + Parameters.MinimumNumber
										val = math.round(val / Parameters.Precision) * Parameters.Precision
								end
				
								if NumberValue.Value == Parameters.MaximumNumber and Parameters.MaximumText then
										Value.Text = Parameters.MaximumText
								elseif NumberValue.Value == Parameters.MinimumNumber and Parameters.MinimumText then
										Value.Text = Parameters.MinimumText
								else
										Value.Text = string.format("%." .. tostring(math.log10(1/Parameters.Precision)) .. "f", NumberValue.Value) .. Parameters.Suffix
								end

								Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"] = NumberValue.Value
								if Parameters.Callback then
										Parameters.Callback(NumberValue.Value)
								end
								Menu[Parameters.Tab][Parameters.Section][Parameters.Name].Changed:Fire(NumberValue.Value)
						end)

						Slider.MouseEnter:Connect(function()
								AddText.Visible = true
								SubtractText.Visible = true
						end)
						Slider.MouseLeave:Connect(function()
								AddText.Visible = false
								SubtractText.Visible = false
						end)
				
						AddText.MouseEnter:Connect(function()
								AddText.TextColor3 = UIStyle.UIcolors.Accent
						end)
						AddText.MouseLeave:Connect(function()
								AddText.TextColor3 = UIStyle.UIcolors.FullWhite
						end)
						SubtractText.MouseEnter:Connect(function()
								SubtractText.TextColor3 = UIStyle.UIcolors.Accent
						end)
						SubtractText.MouseLeave:Connect(function()
								SubtractText.TextColor3 = UIStyle.UIcolors.FullWhite
						end)
						AddText.MouseButton1Down:Connect(function()
								NumberValue.Value = math.round((NumberValue.Value + Parameters.Precision) / Parameters.Precision) * Parameters.Precision
						end)
						SubtractText.MouseButton1Down:Connect(function()
								NumberValue.Value = math.round((NumberValue.Value - Parameters.Precision) / Parameters.Precision) * Parameters.Precision
						end)
						Menu[Parameters.Tab][Parameters.Section][Parameters.Name] = setmetatable({}, {
								__index = function(self, i)
										return Proxy[i]
								end,
								__newindex = function(self, i, v)
										if i == "Value" then
												NumberValue.Value = v
										end
										Proxy[i] = v
								end
						})
				end

			function UILibrary:CreateDropdown(Parameters)
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name] = {}
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Dropdown"] = {}
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Dropdown"].Changed = Signal.new()
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name].Save = function()
							return {
									["Value"] = Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"]
							}
					end
					local Contained = UIUtilities:Create("Frame", {
							AnchorPoint = Vector2.new(0.5, 0),
							Name = Parameters.Name,
							Parent = SubSections[Parameters.Tab][Parameters.Section],
							BackgroundColor3 = Color3.fromRGB(0, 0, 0),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = UDim2.new(0.5, 0, 0, 0),
							Size = UDim2.new(1, 0, 0, 32),
							ZIndex = 22,
					})
					local ValueContainer = UIUtilities:Create("Frame", {
							AnchorPoint = Vector2.new(0.5, 0),
							Name = "ValueContainer",
							Parent = Contained,
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 1, 4),
							Size = UDim2.new(1, -18, 0, 16),
							Visible = false,
							ZIndex = 23,
					})
					local FakeSelection = UIUtilities:Create("TextButton", {
							Active = true,
							AnchorPoint = Vector2.new(0.5, 1),
							Name = "FAKE",
							Parent = Contained,
							BackgroundColor3 = Color3.fromRGB(44, 44, 44),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(39, 39, 39),
							BorderSizePixel = 3,
							Position = UDim2.new(0.5, 0, 1, 0),
							Selectable = true,
							Size = UDim2.new(1, -18, 0, 20),
							ZIndex = 24,
							Font = UIStyle.TextFont.Font,
							ClipsDescendants = false,
							LineHeight = 1.1,
							Text = "",
							TextColor3 = UIStyle.UIcolors.FullWhite,
							TextSize = UIStyle.TextFont.TxtSize,
							TextStrokeColor3 = Color3.new(),
							TextStrokeTransparency = 0.5,
							TextXAlignment = Enum.TextXAlignment.Left,
					})
					local Selection = UIUtilities:Create("TextButton", {
							Active = true,
							AnchorPoint = Vector2.new(0.5, 1),
							Name = "Selection",
							Parent = Contained,
							BackgroundColor3 = Color3.fromRGB(44, 44, 44),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(39, 39, 39),
							BorderSizePixel = 3,
							Position = UDim2.new(0.5, 0, 1, 0),
							Selectable = true,
							Size = UDim2.new(1, -18, 0, 20),
							ZIndex = 24,
							Font = UIStyle.TextFont.Font,
							ClipsDescendants = true,
							LineHeight = 1.1,
							Text = Parameters.Values[1],
							TextColor3 = UIStyle.UIcolors.FullWhite,
							TextSize = UIStyle.TextFont.TxtSize,
							TextStrokeColor3 = Color3.new(),
							TextStrokeTransparency = 0.5,
							TextXAlignment = Enum.TextXAlignment.Left,
					})
					local DropDownTypeText = UIUtilities:Create("TextButton", {
							AnchorPoint = Vector2.new(0.5, 1),
							Name = "TypeOf",
							Parent = Contained,
							BackgroundColor3 = Color3.fromRGB(44, 44, 44),
							BackgroundTransparency = 1,
							BorderColor3 = Color3.fromRGB(39, 39, 39),
							BorderSizePixel = 3,
							Position = UDim2.new(0.5, 0, 1, 0),
							Size = UDim2.new(1, -32, 0, 18),
							ZIndex = 23,
							Font = UIStyle.TextFont.Font,
							LineHeight = 1.1,
							Text = "-",
							TextColor3 = UIStyle.UIcolors.FullWhite,
							TextSize = UIStyle.TextFont.TxtSize,
							TextStrokeColor3 = Color3.new(),
							TextStrokeTransparency = 0.5,
							TextXAlignment = Enum.TextXAlignment.Right,
					})
					if Parameters.MultiChoice then 
							DropDownTypeText.Text = "..."
					end
					table.insert(OpenCloseItems, DropDownTypeText)
					table.insert(OpenCloseItems, Selection)
					local Padding = UIUtilities:Create("UIPadding", {
							Parent = Selection,
							PaddingLeft = UDim.new(0, 12)
					}) 
					local Padding2 = UIUtilities:Create("UIPadding", {
							Parent = FakeSelection,
							PaddingLeft = UDim.new(0, 12)
					}) 
					local SelectionStyling = UIUtilities:Create("Frame", {
							BackgroundColor3 = UIStyle.UIcolors.FullWhite,
							Parent = FakeSelection,
							BorderSizePixel = 0,
							Position = UDim2.new(0, -12, 0, 0),
							Size = UDim2.new(1, 12, 1, 0),
							ZIndex = 23,
					})
					table.insert(OpenCloseItems, SelectionStyling)
					local SelectionStylingGradient = UIUtilities:Create("UIGradient", {
							Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, UIStyle.UIcolors.ColorD),
									ColorSequenceKeypoint.new(0.84, UIStyle.UIcolors.ColorA),
									ColorSequenceKeypoint.new(1, UIStyle.UIcolors.ColorA)
							}),
							Rotation = 90,
							Parent = SelectionStyling
					})
					AutoApplyBorder(SelectionStyling, "SelectionStyling", 22, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH, true)
					local NameTag = UIUtilities:Create("TextLabel", {
							Name = "NAMETAG",
							Parent = Contained,
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 8, 0, 0),
							Size = UDim2.new(1, -12, 1, -24),
							Font = UIStyle.TextFont.Font,
							Text = Parameters.Name,
							TextColor3 = UIStyle.UIcolors.FullWhite,
							TextSize = UIStyle.TextFont.TxtSize,
							TextStrokeColor3 = Color3.new(),
							TextStrokeTransparency = 0.5,
							TextXAlignment = Enum.TextXAlignment.Left,
							ZIndex = 22
					})
					table.insert(OpenCloseItems, NameTag)
					local Organizer = UIUtilities:Create("UIListLayout", {
							Padding = UDim.new(0, 0),
							Parent = ValueContainer,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder,
					})
					for iC, vC in next, (Parameters.Values) do
							local Button = UIUtilities:Create("TextButton", {
									AnchorPoint = Vector2.new(0.5, 0),
									Name = "Button",
									Parent = ValueContainer,
									AutoButtonColor = false,
									BackgroundColor3 = UIStyle.UIcolors.ColorI,
									BorderColor3 = UIStyle.UIcolors.ColorB,
									BorderSizePixel = 0,
									BackgroundTransparency = 0,
									Position = UDim2.new(0.5, 0, 0, 0),
									Size = UDim2.new(1, 0, 0, 18),
									ZIndex = 32,
									Font = UIStyle.TextFont.Font,
									TextStrokeColor3 = Color3.new(),
									TextStrokeTransparency = 0,
									Text = vC,
									TextColor3 = UIStyle.UIcolors.FullWhite,
									TextSize = UIStyle.TextFont.TxtSize
							})
							local valsthing = UIUtilities:Create("BoolValue", {
									Parent = Button,
									Value = false,
									Name = "Selection"
							})
							if iC == 1 and Parameters.MultiChoice then
									Button.TextColor3 = UIStyle.UIcolors.Accent
									valsthing.Value = true
							end
							local ButtonStyling = UIUtilities:Create("Frame", {
									AnchorPoint = Vector2.new(0.5, 0.5),
									Parent = Button,
									BackgroundColor3 = UIStyle.UIcolors.ColorA,
									BorderSizePixel = 1,
									BorderColor3 = UIStyle.UIcolors.ColorB,
									Position = UDim2.new(0.5, 0, 0.5, 0),
									Size = UDim2.new(1, 0, 1, 0),
									ZIndex = 31
							})
							AutoApplyBorder(ButtonStyling, vC, 31, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)
					end
					local closeconnection
					local inDropDown = false
					local mouseent, mouseext
					local function trigger()
							if isColorThingOpen then
									return
							end
							if isDropDownOpen and isDropDownOpen ~= ValueContainer then
									return
							end
							ValueContainer.Size = UDim2.new(1, -18, 0, #Parameters.Values * 18)
							ValueContainer.Visible = not ValueContainer.Visible
							isDropDownOpen = ValueContainer.Visible and ValueContainer or nil

							if ValueContainer.Visible then
									if not Parameters.MultiChoice then
											for _, Button in next, (ValueContainer:GetChildren()) do
													if Button:IsA("TextButton") then
															if Button.Text == Selection.Text then
																	Button.TextColor3 = UIStyle.UIcolors.Accent
															else
																	Button.TextColor3 = UIStyle.UIcolors.FullWhite
															end 
													end
											end
									else
											for _, Button in next, (ValueContainer:GetChildren()) do
													if Button:IsA("TextButton") then
															if Button.Selection.Value then
																	Button.TextColor3 = UIStyle.UIcolors.Accent
															else
																	Button.TextColor3 = UIStyle.UIcolors.FullWhite
															end 
													end
											end
									end
									task.wait()
									mouseent = ValueContainer.MouseEnter:Connect(function()
											inDropDown = true
									end)
									mouseext = ValueContainer.MouseLeave:Connect(function()
											inDropDown = false
									end)
									closeconnection = UserInputService.InputBegan:Connect(function(input)
											if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
													if not inDropDown then
															ValueContainer.Visible = false
															closeconnection:Disconnect()
															mouseent:Disconnect()
															mouseext:Disconnect()
													end
											end
									end)
							else
									if closeconnection then
											closeconnection:Disconnect()
									end
									if mouseent then
											mouseent:Disconnect()
									end
									if mouseext then
											mouseext:Disconnect()
									end
							end
					end
					Selection.MouseButton1Down:Connect(trigger)
					if Parameters.Tooltip then
							Selection.MouseEnter:Connect(function()
									UILibrary.CallToolTip(Parameters.Tooltip, Selection.AbsolutePosition, Selection.AbsolutePosition + Vector2.new(0, 24), Selection.AbsoluteSize)
							end)
					end
					local function update()
							local chosentext = {}
							Selection.Text = ""

							for cf, c in next, (ValueContainer:GetChildren()) do
									if c:IsA("TextButton") then
											if c:FindFirstChild("Selection") and c.Selection.Value == true then
													table.insert(chosentext, c.Text)
											end
									end
							end

							for e = 1, #chosentext do
									if e == #chosentext then
											Selection.Text = Selection.Text .. chosentext[e]
									else
											Selection.Text = Selection.Text .. chosentext[e] .. ", "
									end
							end
					end           
					local function initialize()
							if Parameters.MultiChoice then  
									Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"] = {Parameters.Values[1]}

									for _, button in next, (ValueContainer:GetChildren()) do
											if button:IsA("TextButton") then
													button.MouseButton1Down:Connect(function()
															button.Selection.Value = not button.Selection.Value
															if button:FindFirstChild("Selection") and button.Selection.Value == true then
																	button.TextColor3 = UIStyle.UIcolors.Accent
															else
																	button.TextColor3 = UIStyle.UIcolors.FullWhite
															end
															update()

															local chosentext = {}

															for cf, c in next, (ValueContainer:GetChildren()) do
																	if c:IsA("TextButton") then
																			if c:FindFirstChild("Selection") and c.Selection.Value == true then
																					table.insert(chosentext, c.Text)
																			end
																	end
															end

															Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"] = chosentext
													end)
											end
									end

							else
									Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"] = Parameters.Values[1]
									for _, ButtonA in next, (ValueContainer:GetChildren()) do
											if ButtonA:IsA("TextButton") then
													ButtonA.MouseButton1Down:Connect(function()
															Selection.Text = ButtonA.Text
															trigger()
															Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"] = Selection.Text
													end)
											end
									end
							end
					end
					initialize()
					Selection:GetPropertyChangedSignal("Text"):Connect(function()
							if Parameters.Callback then
									Parameters.Callback(Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"])
							end
							Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Dropdown"].Changed:Fire(Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"])
					end)
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name].UpdateValues = function(NewValues)
							if Parameters.MultiChoice then
									Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"] = {}
							else
									Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"] = ""
							end
							for i, v in next, (ValueContainer:GetChildren()) do
									if v ~= Organizer then
											v:Destroy()
									end
							end
							for iC, vC in next, (NewValues) do
									local Button = UIUtilities:Create("TextButton", {
											AnchorPoint = Vector2.new(0.5, 0),
											Name = "Button",
											Parent = ValueContainer,
											AutoButtonColor = false,
											BackgroundColor3 = UIStyle.UIcolors.ColorI,
											BorderColor3 = UIStyle.UIcolors.ColorB,
											BorderSizePixel = 0,
											BackgroundTransparency = 0,
											Position = UDim2.new(0.5, 0, 0, 0),
											Size = UDim2.new(1, 0, 0, 18),
											ZIndex = 32,
											Font = UIStyle.TextFont.Font,
											TextStrokeColor3 = Color3.new(),
											TextStrokeTransparency = 0,
											Text = vC,
											TextColor3 = UIStyle.UIcolors.FullWhite,
											TextSize = UIStyle.TextFont.TxtSize
									})
									if iC == 1 and Parameters.MultiChoice then
											Button.TextColor3 = UIStyle.UIcolors.Accent
									end
									local ButtonStyling = UIUtilities:Create("Frame", {
											AnchorPoint = Vector2.new(0.5, 0.5),
											Parent = Button,
											BackgroundColor3 = UIStyle.UIcolors.ColorA,
											BorderSizePixel = 1,
											BorderColor3 = UIStyle.UIcolors.ColorB,
											Position = UDim2.new(0.5, 0, 0.5, 0),
											Size = UDim2.new(1, 0, 1, 0),
											ZIndex = 31
									})
									AutoApplyBorder(ButtonStyling, vC, 31, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH)
							end
							Parameters.Values = NewValues
							Selection.Text = NewValues[1]
							initialize()
					end
					local Proxy = Menu[Parameters.Tab][Parameters.Section][Parameters.Name]
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name] = setmetatable({}, {
							__index = function(self, i)
									return Proxy[i]
							end,
							__newindex = function(self, i, v)
									Proxy[i] = v
									if i == "Value" then
											if Parameters.MultiChoice then
													for _, button in next, (ValueContainer:GetChildren()) do
															if button:IsA("TextButton") then
																	button.Selection.Value = false
															end
													end
													for _, button in next, (ValueContainer:GetChildren()) do
															if button:IsA("TextButton") then
																	for ball, sack in next, v do
																			if button.Text == sack then
																					button.Selection.Value = true
																			end
																	end 
																	update()
															end
													end
													if Parameters.Callback then
															Parameters.Callback(Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"])
													end
													Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Dropdown"].Changed:Fire(Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"])
											else
													Selection.Text = v
													if Parameters.Callback then
															Parameters.Callback(Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"])
													end
													Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Dropdown"].Changed:Fire(Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"])
											end
									end
							end
					})
			end

			function UILibrary:CreateTap(Parameters)
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name] = {}
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Button"] = {}
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Button"].Pressed = Signal.new()
					local Hitbox = UIUtilities:Create("TextButton", {
							BackgroundTransparency = 1,
							Name = Parameters.Name,
							Parent = SubSections[Parameters.Tab][Parameters.Section],
							Size = UDim2.new(1, 0, 0, 20),
							ZIndex = 24,
							Font = UIStyle.TextFont.Font,
							TextStrokeColor3 = Color3.new(),
							TextStrokeTransparency = 0.5,
							Text = Parameters.Name,
							TextSize = UIStyle.TextFont.TxtSize,
							TextColor3 = UIStyle.UIcolors.FullWhite
					})
					table.insert(OpenCloseItems, Hitbox)
					local HitboxStyling = UIUtilities:Create("Frame", {
							AnchorPoint = Vector2.new(0.5, 0),
							BackgroundColor3 = UIStyle.UIcolors.FullWhite,
							BorderSizePixel = 0,
							Name = "Styling",
							Parent = Hitbox,
							Position = UDim2.new(0.5, 0, 0, 0),
							Size = UDim2.new(1, -18, 1, 0),
							ZIndex = 23
					})
					AutoApplyBorder(HitboxStyling, Parameters.Name, 21, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH, true)
					table.insert(OpenCloseItems, HitboxStyling)
					local HitboxStylingGradient = UIUtilities:Create("UIGradient", {
							Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, UIStyle.UIcolors.ColorD),
									ColorSequenceKeypoint.new(0.84, UIStyle.UIcolors.ColorA),
									ColorSequenceKeypoint.new(1, UIStyle.UIcolors.ColorA)
							}),
							Rotation = 90,
							Parent = HitboxStyling
					})
					local releaseconnection
					if Parameters.Tooltip then
							Hitbox.MouseEnter:Connect(function()
									UILibrary.CallToolTip(Parameters.Tooltip, Hitbox.AbsolutePosition, Hitbox.AbsolutePosition + Vector2.new(0, 24), Hitbox.AbsoluteSize)
							end)
					end
					Hitbox.MouseButton1Down:Connect(function()
							HitboxStylingGradient.Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, UIStyle.UIcolors.ColorA),
									ColorSequenceKeypoint.new(0.84, UIStyle.UIcolors.ColorA),
									ColorSequenceKeypoint.new(1, UIStyle.UIcolors.ColorA)
							})
							releaseconnection = UserInputService.InputEnded:Connect(function(Input)
									if Input.UserInputType == Enum.UserInputType.MouseButton1 then
											realWait()
											HitboxStylingGradient.Color = ColorSequence.new({
													ColorSequenceKeypoint.new(0, UIStyle.UIcolors.ColorD),
													ColorSequenceKeypoint.new(0.84, UIStyle.UIcolors.ColorA),
													ColorSequenceKeypoint.new(1, UIStyle.UIcolors.ColorA)
											})
											releaseconnection:Disconnect()
									end
							end)
					end)
					local LastActivation
					local connection
					Hitbox.MouseButton1Down:Connect(function()
							if Parameters.Confirmation then
									if Hitbox.Text ~= "Confirm?" then
											Hitbox.Text = "Confirm?"
											Hitbox.TextColor3 = UIStyle.UIcolors.Accent
											LastActivation = tick()
											connection = RunService.Heartbeat:Connect(function()
													if tick() - LastActivation > 2 then
															Hitbox.Text = Parameters.Name
															Hitbox.TextColor3 = UIStyle.UIcolors.FullWhite
															LastActivation = tick()
															connection:Disconnect()
													end
											end)
									else
											if Parameters.Callback then
													Parameters.Callback()
											end
											Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Button"].Pressed:Fire()
											Hitbox.Text = Parameters.Name
											Hitbox.TextColor3 = UIStyle.UIcolors.FullWhite
											connection:Disconnect()
											LastActivation = tick()
									end
							else
									if Parameters.Callback then
											Parameters.Callback()
									end
									Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Button"].Pressed:Fire()
							end
					end)    
			end

			function UILibrary:CreateTextBox(Parameters)
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name] = {}
					local Proxy = Menu[Parameters.Tab][Parameters.Section][Parameters.Name]
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"] = Parameters.Default
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name].Changed = Signal.new()
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name].Save = function()
							return {["Value"] = Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"]}
					end
					local Hitbox = UIUtilities:Create("TextButton", {
							BackgroundTransparency = 1,
							Name = Parameters.Name,
							Parent = SubSections[Parameters.Tab][Parameters.Section],
							Size = UDim2.new(1, 0, 0, 20),
							ZIndex = 24,    
							TextTruncate = Enum.TextTruncate.AtEnd,
							Text = ""
					})
					table.insert(OpenCloseItems, Hitbox)
					local HitboxStyling = UIUtilities:Create("Frame", {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = UIStyle.UIcolors.FullWhite,
							BorderSizePixel = 0,
							Name = "Styling",
							Parent = Hitbox,
							Size = UDim2.new(1, -18, 1, 0),
							Position = UDim2.new(0.5, 0, 0.5, 0),
							ZIndex = 24
					})
					AutoApplyBorder(HitboxStyling, Parameters.Name, 21, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH, true)
					table.insert(OpenCloseItems, HitboxStyling)
					local EntryBox = UIUtilities:Create("TextBox", {
							ClearTextOnFocus = false,
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							Parent = Hitbox,
							Name = Parameters.Name,
							Position = UDim2.new(0.5, 14, 0.5, 0),
							Size = UDim2.new(1, -14, 1, 0),
							ZIndex = 24,
							Font = UIStyle.TextFont.Font,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextColor3 = UIStyle.UIcolors.FullWhite,
							LineHeight = 1.1,
							TextStrokeColor3 = Color3.new(),
							TextStrokeTransparency = 0.5,
							PlaceholderText = "...",
							Text = Parameters.Default,
							TextSize = UIStyle.TextFont.TxtSize
					})
					table.insert(OpenCloseItems, EntryBox)
					local HitboxStylingGradient = UIUtilities:Create("UIGradient", {
							Color = ColorSequence.new({
									ColorSequenceKeypoint.new(0, UIStyle.UIcolors.ColorD),
									ColorSequenceKeypoint.new(0.84, UIStyle.UIcolors.ColorA),
									ColorSequenceKeypoint.new(1, UIStyle.UIcolors.ColorA)
							}),
							Rotation = 90,
							Parent = HitboxStyling
					})
					EntryBox.Focused:Connect(function()
							EntryBox.TextColor3 = UIStyle.UIcolors.Accent
					end)
					EntryBox.FocusLost:Connect(function()
							EntryBox.TextColor3 = UIStyle.UIcolors.FullWhite
					end)
					EntryBox:GetPropertyChangedSignal("Text"):Connect(function()
							Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"] = EntryBox.Text
							Menu[Parameters.Tab][Parameters.Section][Parameters.Name].Changed:Fire()
					end)
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name] = setmetatable({}, {
							__index = function(self, i)
									return Proxy[i]
							end,
							__newindex = function(self, i, v)
									if i == "Value" then
											EntryBox.Text = v
									end
									Proxy[i] = v
							end
					})
			end

			function UILibrary:CreateScrollingList(Parameters)
					Menu[Parameters.Tab][Parameters.Section][Parameters.Name] = {}
					local Proxy = Menu[Parameters.Tab][Parameters.Section][Parameters.Name]
					local TotalMenu = {}
					local OffsetThing = 0
					local Bounds = UIUtilities:Create("Frame", {
							BackgroundTransparency = 1,
							Parent = SubSections[Parameters.Tab][Parameters.Section],
							Name = Parameters.Name,
							ZIndex = 26,
							Size = UDim2.new(1, 0, 0, Parameters.Size),
					})
					if Parameters.Name ~= "" then
							local NameTag = UIUtilities:Create("TextLabel", {
									AnchorPoint = Vector2.new(0.5, 0),
									BackgroundTransparency = 1,
									Parent = Bounds,
									Size = UDim2.new(1, -24, 0, 18),
									Position = UDim2.new(0.5, 0, 0, -4),
									ZIndex = 26,
									Font = UIStyle.TextFont.Font,
									TextStrokeColor3 = Color3.new(),
									TextStrokeTransparency = 0.5,
									Text = Parameters.Name,
									TextSize = UIStyle.TextFont.TxtSize,
									TextXAlignment = Enum.TextXAlignment.Left,
									TextColor3 = UIStyle.UIcolors.FullWhite
							})
							OffsetThing = 18
							table.insert(OpenCloseItems, NameTag)
					end
					local OtherBounds = UIUtilities:Create("Frame", {
							AnchorPoint = Vector2.new(0.5, 0),
							BackgroundTransparency = 1,
							Parent = Bounds,
							Name = "Scrollerbound",
							ZIndex = 26,
							Size = UDim2.new(1, -16, 1, -1 * (OffsetThing - 2)),
							Position = UDim2.new(0.5, 0, 0, OffsetThing - 2)
					})
					AutoApplyAccent(OtherBounds, " e", 26)
					AutoApplyBorder(OtherBounds, " scroll", 26, UIStyle.UIcolors.ColorG, UIStyle.UIcolors.ColorH, true)
					local ScrollableFrame = UIUtilities:Create("ScrollingFrame", {
							AnchorPoint = Vector2.new(0.5, 0),
							BackgroundColor3 = UIStyle.UIcolors.ColorA,
							BorderSizePixel = 0,
							Parent = OtherBounds,
							ZIndex = 26,
							ScrollBarThickness = 0,
							CanvasSize = UDim2.new(1, 0, 0, #Parameters.Values * 18),
							Size = UDim2.new(1, 0, 1, -2),
							Position = UDim2.new(0.5, 0, 0, 2) 
					})
					local Organizer = UIUtilities:Create("UIListLayout", {
							Padding = UDim.new(0, 0),
							Parent = ScrollableFrame,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder,
					})
					table.insert(OpenCloseItems, ScrollableFrame)
					local Selection = UIUtilities:Create("StringValue", {
							Value = "",
							Name = "ScrollingListResult",
							Parent = Bounds
					}) 
					for k, v in next, (Parameters.Values) do
							local Hitbox = UIUtilities:Create("TextButton", {
									AnchorPoint = Vector2.new(0.5, 0),
									BackgroundTransparency = 1,
									Name = v,
									Parent = ScrollableFrame,
									Size = UDim2.new(1, -16, 0, 18),
									Position = UDim2.new(0.5, 0, 0, 0),
									ZIndex = 26,    
									Font = UIStyle.TextFont.Font,
									TextXAlignment = Enum.TextXAlignment.Left,
									TextColor3 = UIStyle.UIcolors.FullWhite,
									LineHeight = 1.1,
									TextStrokeColor3 = Color3.new(),
									TextStrokeTransparency = 0.5,
									Text = v,
									TextSize = UIStyle.TextFont.TxtSize,
									TextTruncate = Enum.TextTruncate.AtEnd,
							})
							if k == 1 then
									Hitbox.TextColor3 = UIStyle.UIcolors.Accent
							end
							table.insert(UIAccents, Hitbox)
							table.insert(OpenCloseItems, Hitbox)
							table.insert(TotalMenu, Hitbox)
							Hitbox.MouseButton1Down:Connect(function()
									Selection.Value = Hitbox.Text
									for i, v in next, (TotalMenu) do
											if v.Text == Hitbox.Text then
													v.TextColor3 = UIStyle.UIcolors.Accent
											else
													v.TextColor3 = UIStyle.UIcolors.FullWhite
											end
									end
							end)
					end
					Selection.Changed:Connect(function()    
							for i, v in next, (TotalMenu) do
									if Selection.Value == v.Text then
											v.TextColor3 = UIStyle.UIcolors.Accent
									else
											v.TextColor3 = UIStyle.UIcolors.FullWhite
									end
							end
							Menu[Parameters.Tab][Parameters.Section][Parameters.Name]["Value"] = Selection.Value
					end)

					Menu[Parameters.Tab][Parameters.Section][Parameters.Name] = setmetatable({}, {
							__index = function(self, i)
									return Proxy[i]
							end,
							__newindex = function(self, i, v)
									if i == "Value" then
											Selection.Value = v
									end
									Proxy[i] = v
							end
					})
			end
			-- i went with the alan route, alr had this function from before the ui was even in use so im using this instead of utilizing the __newindex shit im doing
			function UILibrary:OldSaveConfiguration()
					local Configuration = {}
					for i, v in next, (Core:GetDescendants()) do
							if v:IsA("TextButton") then
									if v:FindFirstChildOfClass("BoolValue") then
											local SubConfiguration = {}
											table.insert(SubConfiguration, "NewButton")
											table.insert(SubConfiguration, v.Parent.Name)
											for i2, v2 in next, (v:GetChildren()) do
													if v2:IsA("BoolValue") then
															table.insert(SubConfiguration, v2.Name)
															table.insert(SubConfiguration, v2.Value)
													end
													if v2.Name == "Bind" then
															table.insert(SubConfiguration, "Bind")
															table.insert(SubConfiguration, v2.Text)
															table.insert(SubConfiguration, v2.BindType.Value)
															table.insert(SubConfiguration, v2.RealKey.Value)
													end
													if v2.Name == "ColorP1" then
															table.insert(SubConfiguration, v2.Name)
															table.insert(SubConfiguration, v2.BackgroundColor3.R)
															table.insert(SubConfiguration, v2.BackgroundColor3.G)
															table.insert(SubConfiguration, v2.BackgroundColor3.B)
															table.insert(SubConfiguration, v2.BackgroundTransparency)
													end
													if v2.Name == "ColorP2" then
															table.insert(SubConfiguration, v2.Name)
															table.insert(SubConfiguration, v2.BackgroundColor3.R)
															table.insert(SubConfiguration, v2.BackgroundColor3.G)
															table.insert(SubConfiguration, v2.BackgroundColor3.B)
															table.insert(SubConfiguration, v2.BackgroundTransparency)
													end
											end
											table.insert(Configuration, SubConfiguration)
									end
									if v:FindFirstChildOfClass("TextBox") and v.Parent ~= SubSections["Settings"]["Configurations"] then -- ignore the configs section
											local SubConfiguration = {}
											table.insert(SubConfiguration, "NewTextEntry")
											table.insert(SubConfiguration, v.Parent.Name)
											table.insert(SubConfiguration, v.Name)
											for i2, v2 in next, (v:GetChildren()) do
													if v2:IsA("TextBox") then
															table.insert(SubConfiguration, v2.Text)
													end
											end
											table.insert(Configuration, SubConfiguration)
									end
							elseif v:IsA("Frame") and v.Parent ~= SubSections["Settings"]["Configurations"] then -- ignore the configs section
									if v:FindFirstChildOfClass("NumberValue") then
											local SubConfiguration = {}
											table.insert(SubConfiguration, "NewSlider")
											table.insert(SubConfiguration, v.Parent.Name)
											for i2, v2 in next, (v:GetChildren()) do
													if v2:IsA("NumberValue") then
															table.insert(SubConfiguration, v2.Name)
															table.insert(SubConfiguration, v2.Value)
													end
											end
											table.insert(Configuration, SubConfiguration)
									elseif v:FindFirstChild("Selection") then
											local SubConfiguration = {}
											table.insert(SubConfiguration, "NewDropDown")
											table.insert(SubConfiguration, v.Parent.Name)
											for i2, v2 in next, (v:GetChildren()) do
													if v2.Name == "NAMETAG" then
															table.insert(SubConfiguration, v2.Text)
													end
													if v2.Name == "Selection" then
															table.insert(SubConfiguration, v2.Text)
													end
											end
											table.insert(Configuration, SubConfiguration)
									elseif v:FindFirstChildOfClass("StringValue") then
											local SubConfiguration = {}
											table.insert(SubConfiguration, "NewScrollingList")
											table.insert(SubConfiguration, v.Name)
											table.insert(SubConfiguration, v.Parent.Name)
											table.insert(SubConfiguration, v.ScrollingListResult.Value)
											table.insert(Configuration, SubConfiguration)
									end
							end
					end
					Configuration = HttpService:JSONEncode(Configuration)
					return Configuration
			end

			function UILibrary:OldLoadConfiguration(Tbl)
					local MainTable = HttpService:JSONDecode(Tbl)
					local UIIndex = Core:GetDescendants()
					for i, v in next, (UIIndex) do
							if v:IsA("TextButton") then
									if v:FindFirstChildOfClass("BoolValue") then
											for index, SubConfiguration in next, (MainTable) do
													if SubConfiguration[1] == "NewButton" then
															if v.Parent.Name == SubConfiguration[2] then
																	if v.Name == SubConfiguration[3] then
																			for ObjectIndex, Object in next, (v:GetChildren()) do
																					if Object:IsA("BoolValue") then
																							Object.Value = SubConfiguration[4]
																					end
																					if Object.Name == "Bind" then
																							Object.Text = SubConfiguration[6]
																							Object:FindFirstChild("BindType").Value = SubConfiguration[7]
																							Object:FindFirstChild("RealKey").Value = SubConfiguration[8]
																					end
																					if Object.Name == "ColorP1" then
																							Object.BackgroundColor3 = Color3.new(SubConfiguration[6], SubConfiguration[7], SubConfiguration[8])
																							Object.BackgroundTransparency = SubConfiguration[9]
																					end
																					if Object.Name == "ColorP2" then
																							Object.BackgroundColor3 = Color3.new(SubConfiguration[11], SubConfiguration[12], SubConfiguration[13])
																							Object.BackgroundTransparency = SubConfiguration[14]
																					end
																			end
																	end
															end
													end
											end
									end
									if v:FindFirstChildOfClass("TextBox") then
											for index, SubConfiguration in next, (MainTable) do
													if SubConfiguration[1] == "NewTextEntry" then
															if v.Parent.Name == SubConfiguration[2] then
																	if v.Name == SubConfiguration[3] then
																			for ObjectIndex, Object in next, (v:GetChildren()) do
																					if Object:IsA("TextBox") then
																							Object.Text = SubConfiguration[4]
																					end
																			end
																	end
															end
													end
											end
									end
							elseif v:IsA("Frame") then
									if v:FindFirstChildOfClass("NumberValue") then
											for index, SubConfiguration in next, (MainTable) do
													if SubConfiguration[1] == "NewSlider" then
															if v.Parent.Name == SubConfiguration[2] then
																	if v.Name == SubConfiguration[3] then
																			for ObjectIndex, Object in next, (v:GetChildren()) do
																					if Object:IsA("NumberValue") then
																							Object.Value = SubConfiguration[4]
																					end
																			end
																	end
															end
													end
											end
									elseif v:FindFirstChild("Selection") then
											for index, SubConfiguration in next, (MainTable) do
													if SubConfiguration[1] == "NewDropDown" then
															if v.Parent.Name == SubConfiguration[2] then
																	if v.Name == SubConfiguration[4] then
																			for ObjectIndex, Object in next, (v:GetChildren()) do
																					if Object.Name == "Selection" then
																							Object.Text = SubConfiguration[3]
																					end
																			end
																	end
															end
													end
											end
									elseif v:FindFirstChildOfClass("StringValue") then
											for index, SubConfiguration in next, (MainTable) do
													if SubConfiguration[1] == "NewScrollingList" then
															if v.Name == SubConfiguration[2] then
																	if v.Parent.Name == SubConfiguration[3] then
																			for ObjectIndex, Object in next, (v:GetChildren()) do
																					if Object.Name == "ScrollingListResult" then
																							Object.Value = SubConfiguration[4]
																					end
																			end
																	end
															end
													end
											end
									end
							end
					end
			end
	
			function UILibrary:SaveConfiguration()
					local Configuration = {}

					for tab, section in next, Menu do
							if SubSections[tab] then
									Configuration[tab] = {}
									for panel, elements in next, section do
											Configuration[tab][panel] = {}
											if panel ~= "Configurations" then
													for element, data in next, elements do
															if data.Save then
																	Configuration[tab][panel][element] = {}
																	for key, value in next, data.Save() do
																			Configuration[tab][panel][element][key] = value
																	end
															end
													end
											end
									end
							end
					end

					return HttpService:JSONEncode(Configuration)
			end

			function UILibrary:LoadConfiguration(Tbl)
					local MainTable = HttpService:JSONDecode(Tbl)

					for tab, section in next, MainTable do
							if Menu[tab] then
									for panel, elements in next, section do
											if Menu[tab][panel] then
													for element, data in next, elements do
															if Menu[tab][panel][element] then
																	for k, v in next, data do
																			if type(v) == "table" and k ~= "Value" then
																					for k2, v2 in next, v do
																							if type(v2) == "table" and not v2.r then
																									if k2 == "Animation Selection" then
																											Menu[tab][panel][element][k][k2]["Value"] = v2["Value"]
																									elseif k2 == "Animations" then
																											local animdata = v2
																											for anim, data in next, animdata do
																													for name, values in next, data do
																															if animdata[anim][name]["Value"] then
																																	Menu[tab][panel][element][k][k2][anim][name]["Value"] = animdata[anim][name]["Value"]
																															elseif animdata[anim][name]["Color"] then
																																	Menu[tab][panel][element][k][k2][anim][name]["Color"] = {r = animdata[anim][name]["Color"].r, g = animdata[anim][name]["Color"].g, b = animdata[anim][name]["Color"].b}
																																	if animdata[anim][name]["Transparency"] then
																																			Menu[tab][panel][element][k][k2][anim][name]["Transparency"] = animdata[anim][name]["Transparency"]
																																	end
																															end
																													end
																											end
																									end
																							else
																									-- minor error
																									Menu[tab][panel][element][k][k2] = v2
																							end
																					end
																			else
																					Menu[tab][panel][element][k] = v
																			end
																	end
															end
													end
											end
									end
							end
					end
			end

			-- UI Open/Close animation
			local tweentime = 0
			local OpenTweens = {}
			local CloseTweens = {}
			local OpenObjects = {}
			local bullshit = {} -- yes i FUCKING had to do this bullshit

			local tweenstyle = Enum.EasingStyle.Linear
			local easingdir = Enum.EasingDirection.InOut

			--integor was here
			local backgroundTransShit = Instance.new("NumberValue")

			backgroundTransShit.Value = 0

			local imageEnabledShit = Instance.new("BoolValue");
			imageEnabledShit.Value = true

			local textTransShit = Instance.new("NumberValue")
			textTransShit.Value = 0

			local fadedconnections = {}

			local function UpdateTweens()
					for i = 1, #fadedconnections do
							local conn = fadedconnections[i]
							conn:Disconnect()
					end
					table.clear(bullshit)
					for i = 1, #OpenCloseItems do
							local val = OpenCloseItems[i]
							if val:IsA("Frame") or val:IsA("ScrollingFrame") then
									fadedconnections[1 + #fadedconnections] = backgroundTransShit.Changed:Connect(function()
											val.BackgroundTransparency = backgroundTransShit.Value
									end)
							elseif val:IsA("ImageButton") then
									if val.Name == "Alpha" then
											fadedconnections[1 + #fadedconnections] = backgroundTransShit.Changed:Connect(function()
													val.ImageTransparency = backgroundTransShit.Value
											end)
									end
									if val.Name:match("ColorP") then
											if val:FindFirstChild("actual") then
													table.insert(bullshit, val)
											else
													fadedconnections[1 + #fadedconnections] = backgroundTransShit.Changed:Connect(function()
															val.BackgroundTransparency = backgroundTransShit.Value
													end)
											end
									end
							elseif val:IsA("TextLabel") or val:IsA("TextButton") or val:IsA("TextBox") then
									fadedconnections[1 + #fadedconnections] = textTransShit.Changed:Connect(function()
											val.TextTransparency = textTransShit.Value
											val.TextStrokeTransparency = textTransShit.Value
									end)
							end
					end
			end

			UILibrary.updateFade = UpdateTweens
			
			function OpenUI()
					fading = true
					easingdir = Enum.EasingDirection.Out
					MainContainer.Visible = true
					TweenService:Create(backgroundTransShit, TweenInfo.new(tweentime, tweenstyle, easingdir), {Value = 0}):Play()
					TweenService:Create(textTransShit, TweenInfo.new(tweentime, tweenstyle, easingdir), {Value = 0}):Play()
					for i, v in next, (bullshit) do
							TweenService:Create(v, TweenInfo.new(tweentime, tweenstyle, easingdir), {BackgroundTransparency = v.actual.Value}):Play()
					end
					realWait(tweentime)
					imageEnabledShit.Value = true
					task.wait()
					Menu.closed = false
					fading = false
			end
			function CloseUI()
					fading = true
					easingdir = Enum.EasingDirection.In
					imageEnabledShit.Value = false
					TweenService:Create(backgroundTransShit, TweenInfo.new(tweentime, tweenstyle, easingdir), {Value = 1}):Play()
					TweenService:Create(textTransShit, TweenInfo.new(tweentime, tweenstyle, easingdir), {Value = 1}):Play()
					for i, v in next, (bullshit) do
							TweenService:Create(v, TweenInfo.new(tweentime, tweenstyle, easingdir), {BackgroundTransparency = 1}):Play()
					end
					realWait(tweentime)
					MainContainer.Visible = false
					task.wait()
					Menu.closed = true
					fading = false
			end
			CloseUI()
			realWait(0.2)
			tweentime = 0.25

	RunService.Heartbeat:Connect(function()
			if MainContainer.Visible then 
					UserInputService.MouseBehavior = Enum.MouseBehavior.Default
					UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceShow
			else
					UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
			end
	end)

			local CursorObject = Drawing.new("Triangle")
			CursorObject.Filled = true
			
	local function UpdateCursor()
	end

			function UILibrary:Initialize()
					MainContainer:GetPropertyChangedSignal("Visible"):Connect(UpdateCursor)

					Mouse.Move:Connect(UpdateCursor)

					-- Dragging the UI
					local gui = MainContainer

					local dragging
					local dragInput
					local dragStart
					local startPos

				local function update(input)
							local delta = input.Position - dragStart
							gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
					end
					
					gui.InputBegan:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
									dragging = true
									dragStart = input.Position
									startPos = gui.Position
									
									input.Changed:Connect(function()
											if input.UserInputState == Enum.UserInputState.End then
													dragging = false
											end
									end)
							end
					end)

					gui.InputChanged:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
									dragInput = input
							end
					end)
				 
					UserInputService.InputChanged:Connect(function(input)
							if input == dragInput and dragging then
									update(input)
							end
					end) 
					MainContainer:GetPropertyChangedSignal("Visible"):Connect(UpdateCursor)

					Mouse.Move:Connect(UpdateCursor)
					UpdateTweens()
					-- retarded
					task.wait()
					OpenUI()
					UserInputService.InputBegan:Connect(function(Input, gameProcessedEvent)
							if Input.UserInputType == Enum.UserInputType.Keyboard then
									-- MENU BIND
									if Input.KeyCode == Enum.KeyCode.Insert or Input.KeyCode == Enum.KeyCode.Delete or Input.KeyCode == Enum.KeyCode.Backquote then
											if MainContainer.BackgroundTransparency == 0 and MainContainer.Visible == true then
													CloseUI()
											else
													if MainContainer.BackgroundTransparency ~= 0 and MainContainer.Visible ~= true then
															OpenUI()
													end
											end
									end 
							end
					end)
			end
	end

	Library = {["UI"] = UILibrary, ["Menu"] = Menu, ["Accents"] = UIAccents, ["Subsections"] = SubSections, ["KeyBindList"] = KeyBindList, ["Signal"] = Signal, ["Utilities"] = UIUtilities}
end
