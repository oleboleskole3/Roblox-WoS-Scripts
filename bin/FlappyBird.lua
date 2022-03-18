local canvas = {
	COL_EMPTY = 1;
	COL_WHITE = 2;
	COL_BLACK = 3;
	COL_RED = 4;
	COL_GREEN = 5;
	COL_BLUE = 6;
	COL_ORANGE = 7;
	COL_YELLOW = 8;
	COL_BROWN = 9;
	COL_PURPLE = 10;
}

-- local Wait = wait
-- wait = function() end

do
	--BEGIN SCOPE
	local PI = math.pi
	
	local Min = math.min
	local Max = math.max
	local Abs = math.abs
	local Sin = math.sin
	local Cos = math.cos
	local Ceil = math.ceil
	local Round = math.round
	local Floor = math.floor
	
	--local TaskSpawn = task.spawn
	
	local CoroRunning = coroutine.running
	local CoroYield = coroutine.yield
	local CoroCreate = coroutine.create
	local CoroResume = coroutine.resume
	
	local width = -1
	local height = -1
	
	local pixels = {}
	local texts = {}
	
	local screen
	
	local color = {
		" ";
		"⬜";
		"⬛";
		"🟥";
		"🟩";
		"🟦";
		"🟧";
		"🟨";
		"🟫";
		"🟪";
	}
	
	local charNums = {
		["❌"] = canvas.COL_EMPTY;
		["⬜"] = canvas.COL_WHITE;
		["⬛"] = canvas.COL_BLACK;
		["🟥"] = canvas.COL_RED;
		["🟩"] = canvas.COL_GREEN;
		["🟦"] = canvas.COL_BLUE;
		["🟧"] = canvas.COL_ORANGE;
		["🟨"] = canvas.COL_YELLOW;
		["🟫"] = canvas.COL_BROWN;
		["🟪"] = canvas.COL_PURPLE;
	}
	
	local drawColor = canvas.COL_WHITE
	local pivotX, pivotY = 0, 0
	local anchorX, anchorY = 0, 0
	local angle = 0
	
	local CVS_Prepare
	local CVS_Present
	local CVS_Clear
	
	local CVS_Push
	local CVS_Pop
	local CVS_SetColor
	local CVS_SetPivot
	local CVS_SetAnchor
	local CVS_SetAngle
	
	local CVS_LoadSprite
	
	local CVS_Pixel
	local CVS_Line
	local CVS_Circle
	local CVS_Sprite
	local CVS_Polygon
	
	local popThread
	
	CVS_Prepare = function(_screen, _width: number, _height: number, scale: number)
		width = _width
		height = _height
		
		for column = 1, width do
			local row = {}
			for i = 1, height do
				table.insert(row, i, canvas.COL_EMPTY)
			end
			table.insert(pixels, column, row)
		end
		
		screen = _screen
		
		screen:ClearElements()
		
		local extra = scale < 3 and 1 or 0
		local xTexts, yTexts = Ceil(width / 64), Ceil(height / 64)
		--print(xTexts, yTexts)
		
		for column = 1, xTexts do
			local row = {}
			for i = 1, yTexts do
				table.insert(row, i, screen:CreateElement("TextLabel", {
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					TextColor3 = Color3.new(1, 1, 1);
					TextSize = scale;
					TextXAlignment = Enum.TextXAlignment.Left;
					TextYAlignment = Enum.TextYAlignment.Top;
					Size = UDim2.new(1, 0, 1, 0);
					Position = UDim2.new(0, 0, 0, 0	);
					Font = Enum.Font.Arial;
					--RichText = true;
					LineHeight = 2;
				}))
			end
			
			table.insert(texts, column, row)
		end
		
		CVS_Present()
		
		for x, row in ipairs(texts) do
			for y, textLabel in ipairs(row) do
				textLabel:ChangeProperties({
					Size = UDim2.new(0, textLabel.TextBounds.X+16, 0, textLabel.TextBounds.Y+16,0);
					Position = UDim2.new(0, 
									--.Instance for studio
						(x - 1)*textLabel.TextBounds.X - x + extra*(x - 1) + 1, 0, --            and here, .Instance
						(y - 1)*textLabel.TextBounds.Y - 2 - (y - 1) - 1*Max(0, (y - 2)) - ((textLabel.TextBounds.Y/64) - 2)*y
					)
				})
			end
		end
	end
	
	local function WriteAt(x64, y64)
		local str = {}

		local diffX, diffY = 64*x64 - width, 64*y64 - height
		diffX, diffY = Max(0, diffX), Max(0, diffY)

		for y = 1 + 64*(y64 - 1), 64*y64 - diffY do--x, column in ipairs(canvas._pixels) do
			--local column = canvas._pixels[x]
			table.insert(str, "\n")

			for x = 1 + 64*(x64 - 1), 64*x64 - diffX do--y, pix in ipairs(column) do
				--print(x64, x, y)
				local pix = pixels[x][y]
				table.insert(str, color[pix])
			end
		end

		--print(x64, #canvas._texts)
		texts[x64][y64]:ChangeProperties({Text = table.concat(str, "")})
	end

	CVS_Present = function()
		for x64 = 1, Ceil(width / 64) do
			for y64 = 1, Ceil(height / 64) do
				--TaskSpawn(WriteAt, x64, y64)
				CoroResume(CoroCreate(WriteAt), x64, y64)
			end
		end
	end
	
	CVS_Clear = function(col: number)
		col = col or canvas.COL_EMPTY

		for x = 1, width do
			for y = 1, height do
				pixels[x][y] = col
			end
		end
	end
	
	local function AwaitPop()
		local _drawColor = drawColor
		local _pivotX, _pivotY = pivotX, pivotY
		local _angle = angle
		
		popThread = CoroRunning()
		CoroYield()
		
		drawColor = _drawColor
		pivotX, pivotY = _pivotX, _pivotY
		angle = _angle
	end
	
	CVS_Push = function()
		--TaskSpawn(AwaitPop)
		local thread = CoroCreate(AwaitPop)
		CoroResume(thread)
	end
	
	CVS_Pop = function()
		CoroResume(popThread)
	end
	
	CVS_SetColor = function(col: number)
		drawColor = col ~= canvas.COL_EMPTY and col or drawColor
	end
	
	CVS_SetPivot = function(x: number, y: number)
		pivotX, pivotY = x, y
	end
	
	CVS_SetAnchor = function(x: number, y: number)
		anchorX, anchorY = x, y
	end
	
	CVS_SetAngle = function(ang: number)
		angle = ang
	end
	
	CVS_LoadSprite = function(spr)
		local sprite = {}
		for y, row in ipairs(spr) do
			local newRow = table.create(#row, canvas.COL_EMPTY)
			for x, char in ipairs(row) do
				newRow[x] = charNums[char]
			end
			
			table.insert(sprite, y, newRow)
		end
		
		return sprite
	end

	CVS_Pixel = function(x: number, y: number)
		local row = pixels[x + 1]
		if not row then return end
		
		local pix = row[y + 1]
		if not pix then return end
		
		row[y + 1] = drawColor
	end

	CVS_Line = function(x0: number, y0: number, x1: number, y1: number)
		x0, y0, x1, y1 = Round(x0), Round(y0), Round(x1), Round(y1)
		
		local d0, d1 = Abs(y1 - y0), Abs(x1 - x0)
		
		local len = d0 > d1 and d0 or d1
		
		local xa, ya = (x1 - x0) / len, (y1 - y0) / len
		
		for i = 1, len do
			CVS_Pixel(Round(x0), Round(y0))
			
			x0 += xa
			y0 += ya
		end
	end

	CVS_Circle = function(x: number, y: number, r: number, segments: number)
		segments = segments or 16
		local step = (PI*2)/segments
		
		local x0, y0 = x, y
		for theta = 0, PI*2 + step, step do		
			local x1, y1 = x + r * Cos(theta), y - r * Sin(theta)
			
			if theta ~= 0 then
				CVS_Line(x0, y0, x1, y1)
			end
			
			x0, y0 = x1, y1
		end
	end
	
	CVS_Sprite = function(sprite, x: number, y: number, scale: number)
		scale = scale and math.round(scale) or 1
		
		local sizeX, sizeY = (#sprite[1]) * scale, (#sprite) * scale
		
		for py, row in ipairs(sprite) do
			for px, col in ipairs(row) do
				if col == canvas.COL_EMPTY then continue end
				local endX, endY = x + px * scale - Round(sizeX * anchorX), y + py * scale - Round(sizeY * anchorY)
				
				CVS_SetColor(col)
				if scale == 1 then
					CVS_Pixel(endX, endY)
				else
					for ox = 1, scale do
						for oy = 1, scale do
							CVS_Pixel(endX - ox, endY - oy)
						end
					end
				end
			end
		end
	end
	
	local function RotateAround(cx, cy, points)
		local s, c = Sin(angle), Cos(angle)
		
		for i = 1, #points, 2 do
			local x, y = points[i], points[i + 1]
			
			x -= cx
			y -= cy
			
			local newX = x * c - y * s
			local newY = x * s + y * c
			
			points[i] = newX + cx
			points[i + 1] = newY + cy
		end
	end

	CVS_Polygon = function(x: number, y: number, ...: number)
		local args = {...}
		if not args[4] then return end
		
		local minX, maxX = width + 2, -3
		local minY, maxY = height + 2, -3
		
		for i = 1, #args do
			local x = args[i]
			local y = x and args[i + 1]
			if not y then break end
			
			minX = Min(minX, x)
			maxX = Max(maxX, x)

			minY = Min(minY, y)
			maxY = Max(minY, y)
		end
		
		local xDiff, yDiff = maxX - minX, maxY - minY
		if angle ~= 0 then
			local cx, cy = Floor(minX + xDiff * pivotX), Floor(minY + yDiff * pivotY)
			RotateAround(cx, cy, args)
		end
		
		local x0, y0 = args[1], args[2]
		
		local ancX, ancY = Round(xDiff * anchorX), Round(yDiff * anchorY)
		
		for i = 1, #args, 2 do
			local x1 = args[i]
			local y1 = x1 and args[i + 1]
			if not y1 then break end
			
			CVS_Line(x + x0 - ancX,  y + y0 - ancY, x + x1 - ancX, y + y1 - ancY)
			x0, y0 = x1, y1
		end
		
		CVS_Line(x + x0 - ancX, y + y0 - ancY, x + args[1] - ancX, y + args[2] - ancY)
	end
	
	canvas.prepare = CVS_Prepare	
	canvas.present = CVS_Present
	canvas.clear = CVS_Clear
	
	canvas.push = CVS_Push
	canvas.pop = CVS_Pop
	canvas.setColor = CVS_SetColor
	canvas.setPivot = CVS_SetPivot
	canvas.setAnchor = CVS_SetAnchor
	canvas.setAngle = CVS_SetAngle
	
	canvas.loadSprite = CVS_LoadSprite
	
	canvas.pixel = CVS_Pixel
	canvas.line = CVS_Line
	canvas.circle = CVS_Circle
	canvas.sprite = CVS_Sprite
	canvas.polygon = CVS_Polygon
	
	--END SCOPE
end
local screen = GetPartFromPort(1, 'Screen')

canvas.prepare(screen, 150, 150, 1)
canvas.polygon(0, 0, 0, 0, 25*3-1, 0, 25*3-1, 25*3-1, 0, 25*3-1)
canvas.present()
