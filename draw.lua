local brightness = {
	"  ", "``", "..", "--", "''", "::", "__", ",,", "^^", "==", ";;", ">>", "<<", "++", "!!", "rr", "cc", "**", "//",
	"zz", "??", "ss", "LL", "TT", "vv", "))", "JJ", "77", "((", "||", "FF", "ii", "{{", "CC", "}}", "ff", "II", "33",
	"11", "tt", "ll", "uu", "[[", "nn", "ee", "oo", "ZZ", "55", "YY", "xx", "jj",
	"yy", "aa", "]]", "22", "EE", "SS", "ww", "qq", "kk", "PP", "66", "hh", "99", "dd", "44", "VV", "pp", "OO", "GG",
	"bb", "UU", "AA", "KK", "XX", "HH", "mm", "88", "RR", "DD", "##", "$$", "BB", "gg", "00", "MM", "NN", "WW", "QQ",
	"%%", "&&", "@@",
}


local sw, sh = 0, 0

local screen = {}

function round(x)
	return x >= 0 and math.floor(x + 0.2) or math.ceil(x - 0.2)
end

draw = {
	brightness = brightness,
	sleep = function(a)
		local sec = tonumber(os.clock() + a);
		while (os.clock() < sec) do
		end
	end,
	init = function(sw2, sh2)
		sw = sw2
		sh = sh2
		for x = 1, sw do
			screen[x] = {}
			for y = 1, sh do
				screen[x][y] = brightness[1] --math.random(0,1)
			end
		end
	end,
	clear = function()
		for x = 1, sw do
			for y = 1, sh do
				screen[x][y] = brightness[1] --math.random(0,1)
			end
		end
	end,
	pixel = function(t, locy, locx, color)
		if screen[locx] and screen[locx][locy] then
			screen[locx][locy] = color .. brightness[(t~=nil and t or 1) + 1]
		end
	end,
	circle = function(rad, locy, locx, brightness, color, fill)
		fill = fill or false
		--y = k ± √(r² - (x-h)²)
		-- h is x for the center k is y for the center
		for x = -rad, rad do
			local y = round(math.sqrt(rad ^ 2 - (x) ^ 2))
			draw.pixel(brightness, locx + x, locy + y, color)
			draw.pixel(brightness, locx + x, locy - y, color)
			draw.pixel(brightness, locx + y, locy + x, color)
			draw.pixel(brightness, locx - y, locy + x, color)
			if fill then
				for Y = -y, y do
					draw.pixel(brightness, locx + x, locy + Y, color)
				end
			end

			if x < 0 then
			end
		end
	end,
	drawline = function(x1, y1, x2, y2, brightness, color)
		local X1, X2, Y1, Y2 = x1, x2, y1, y2
		--if x2 < x1 then X1 = x2 X2 = x1 else X1 =x1 X2 = x2 end
		--if y2 < y1 then Y1 = y2 Y2 = y1 else Y1 =y1 Y2 = y2 end
		for x = X1, X2 do
			local y = math.floor(((x - X1) / (X2 - X1)) * (Y2 - Y1) + Y1)
			draw.pixel(brightness, y, x, color)
		end
		for x = X2, X1 do
			local y = math.floor(((x - X1) / (X2 - X1)) * (Y2 - Y1) + Y1)
			draw.pixel(brightness, y, x, color)
		end
		for y = Y1, Y2 do
			local x = math.floor(((y - Y1) / (Y2 - Y1)) * (X2 - X1) + X1)
			draw.pixel(brightness, y, x, color)
		end
		for y = Y2, Y1 do
			local x = math.floor(((y - Y1) / (Y2 - Y1)) * (X2 - X1) + X1)
			draw.pixel(brightness, y, x, color)
		end
	end,
	render = function()
		os.execute("clear")
		for x = 1, sw do
			local line = ""
			for y = 1, sh do
				line = line .. screen[y][x]
			end
			print("+ " .. line)
		end
	end
}

return draw
