-- ⠁⠂⠄
-- ⠃⠅⠆
-- ⠇



local size = 50
local sw = size
local sh = size

local draw = require("draw")

draw.init(sw, sh)

colors = {
	black = "\27[30m",
	red = "\27[31m",
	green = "\27[32m",
	yellow = "\27[33m",
	blue = "\27[34m",
	magenta = "\27[35m",
	cyan = "\27[36m",
	white = "\27[37m",
	reset = "\27[0m"
}


draw.drawline(1, 1, 10, 10, 1, colors.red)
draw.render()



--print(colors.white .. "Choose Example: ")
local ex
repeat ex = io.read() until ex == "1" or ex == "2"

if ex == "1" then
	local objects = {
	}

	function mysplit(inputstr, sep)
		if sep == nil then
			sep = "%s"
		end
		local t = {}
		for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
			table.insert(t, str)
		end
		return t
	end

	function rotate(points, pitch, roll, yaw)
		 cosa = math.cos(yaw);
		 sina = math.sin(yaw);

		 cosb = math.cos(pitch);
		 sinb = math.sin(pitch);

		 cosc = math.cos(roll);
		 sinc = math.sin(roll);

		 Axx = cosa*cosb;
		 Axy = cosa*sinb*sinc - sina*cosc;
		 Axz = cosa*sinb*cosc + sina*sinc;

		 Ayx = sina*cosb;
		 Ayy = sina*sinb*sinc + cosa*cosc;
		 Ayz = sina*sinb*cosc - cosa*sinc;

		 Azx = -sinb;
		 Azy = cosb*sinc;
		 Azz = cosb*cosc;
			 px = points[1];
			 py = points[2];
			 pz = points[3];

			PX = Axx*px + Axy*py + Axz*pz;
			PY = Ayx*px + Ayy*py + Ayz*pz;
			PZ= Azx*px + Azy*py + Azz*pz;
		return PX,PY,PZ
	end

	function model(data, size, position)
		if type(data) == "string" then
			local lines = {}
			local verticies = {}
			local Verticies = {}
			local faces = {}
			local m = {
				vertexes = {},
				color = colors.white
			} -- the actual model
			for line in io.lines(data) do
				lines[#lines + 1] = line
				--print(line:sub(1, 1))
				if line:sub(1, 2) == "v " then
					verticies[#lines] = line
				elseif line:sub(1, 1) == "f" then
					faces[#lines] = line
				end
			end
			for I, v in pairs(verticies) do
				local vert = {}
				local num = 0
				for i in string.gmatch(v, "%S+") do
					num = num + 1
					if num ~= 1 then
						vert[#vert + 1] = i * size
					end
				end
				vert[1] = vert[1] + position[1]
				vert[2] = vert[2] + position[2]
				vert[3] = vert[3] + position[3]
				table.insert(Verticies, vert)
			end
			local Faces = {}
			for i, v in pairs(faces) do
				local num = 0
				local face = {}
				for b in string.gmatch(v, "%S+") do
					num = num + 1
					if num ~= 1 then
						--print(mysplit(b, "//")[1])
						--print(b)
						face[num - 1] = mysplit(b, "//")[1]
					end
				end
				Faces[#Faces + 1] = face
			end
			for i, v in pairs(Faces) do
				--print(v[1])
				--print(Verticies[tonumber(v[1])])
				m.vertexes[i] = { Verticies[tonumber(v[1])], Verticies[tonumber(v[2])], Verticies[tonumber(v[3])] }
				--print(m.vertexes[i][1])
				--print(m.vertexes[i][2])
				--print(m.vertexes[i][3])
			end
			return m
		else

		end
	end

	table.insert(objects, model("rat.txt", 2, { 0,0,0}))

	local cam = { 0, 0, -20, 0, 0, 0 }
	while true do
		local input = io.read()
		for i = 1, #input do
			local inp = input:sub(i, i)
			draw.clear()
			if inp == "d" then
				cam[1] = cam[1] + math.cos(-cam[4])
				cam[2] = cam[2] + math.sin(-cam[5])
				cam[3] = cam[3] + math.sin(-cam[4])
			end
			if inp == "a" then
				cam[1] = cam[1] - math.cos(-cam[4])
				cam[3] = cam[3] - math.sin(-cam[4])
			end
			if inp == "s" then
				cam[3] = cam[3] - math.cos(-cam[4])
				cam[1] = cam[1] + math.sin(-cam[4])
			end
			if inp == "w" then
				cam[3] = cam[3] + math.cos(-cam[4])
				cam[1] = cam[1] - math.sin(-cam[4])
			end
			if inp == "e" then cam[2] = cam[2] - 1 end
			if inp == "q" then cam[2] = cam[2] + 1 end
			if inp == "A" then cam[4] = cam[4] - .1 end
			if inp == "D" then cam[4] = cam[4] + .1 end
			if inp == "W" then cam[5] = cam[5] - .1 end
			if inp == "S" then cam[5] = cam[5] + .1 end
			table.sort(objects, function(a, b)
				return a.vertexes[1][1][3]>b.vertexes[1][1][3]
			end)
			for o, v in pairs(objects) do
				local color = v.color

				for b, v in pairs(v.vertexes) do
					local locs = {}
					for i, v in pairs(v) do
						local x, y, z = v[1] - cam[1], -v[2] - cam[2], v[3] - cam[3]
						local x2,y2,z2 = rotate({x,y,z},-cam[4],cam[5],-cam[6])
						--[[local x2, y2, z2 = 
x * math.cos(cam[4]) - z * math.sin(cam[4]), 
y,
z * math.cos(cam[4]) + x * math.sin(cam[4])]]
						if z2 > 0 then
							local dist = (1 / z2) * 100
							local X, Y = sw / 2 + (x2 * dist), sh / 2 + (y2 * dist)
							--draw.circle(math.floor(2 * dist), math.floor(X), math.floor(Y), 1,colors.red,true)
							--table.insert(locs,
							--{ math.floor(X), math.floor(Y), math.floor(#draw.brightness / (z2 / 10)) <=
							--#draw.brightness and math.floor(#draw.brightness / (z2 / 10)) or #draw.brightness,z2})
							locs[#locs + 1] = { math.floor(X), math.floor(Y), math.floor(#draw.brightness / (z2 / 4)) <=
							#draw.brightness and math.floor(#draw.brightness / (z2 / 4)) or #draw.brightness }
						end
					end
					for i, v in pairs(locs) do
						if locs[i + 1] then
							draw.drawline(v[1], v[2], locs[i + 1][1], locs[i + 1][2], v[3] - 1, color)
						else
							draw.drawline(v[1], v[2], locs[1][1], locs[1][2], v[3] - 1, color)
						end
					end
				end
			end
			draw.render()
		end
	end
else
	local locx = math.random(10, sw - 10)
	local locy = math.random(10, sh - 10)
	local accx = math.random(-20, 20) / 10
	local accy = math.random(-20, 20) / 10
	while true do
		draw.sleep(.005)
		locy = locy + accy
		locx = locx + accx
		if locy < sh - 5 and locy > 5 then
			accy = accy + ((locy > sh - 5) and -0.1 or 0.1)
		else
			accy = -accy / 1.4
			locy = locy - 1
		end
		if locx < sw - 5 and locx > 5 then
			accx = accx * .992
		else
			accx = -accx
		end
		draw.clear()
		draw.drawline(1, 1, sw, 1, 1, colors.red)
		draw.drawline(1, 1, 1, sh, 1, colors.red)
		draw.drawline(sw, 1, sw, sh, 1, colors.red)
		draw.drawline(1, sh, sw, sh, 1, colors.red)
		draw.circle(5, 0 + math.floor(locx), 0 + math.floor(locy), 1, colors.white, true)
		draw.render()
	end
end
