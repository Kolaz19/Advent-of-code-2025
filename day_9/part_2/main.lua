package.path = package.path .. ";../../shared/?.lua"

local content = require "read_file".read_file "input.txt"

local function calc_area(c1, c2)
	local width = c1.x - c2.x
	local height = c1.y - c2.y
	width = width < 0 and (width * -1) + 1 or width + 1
	height = height < 0 and (height * -1) + 1 or height + 1
	return width * height
end

local function get_bottom_right(p1, p2)
	local right = math.max(p1.x, p2.x)
	local bottom = math.max(p1.y, p2.y)
	return { x = right, y = bottom }
end

local function get_top_left(p1, p2)
	local left = math.min(p1.x, p2.x)
	local top = math.min(p1.y, p2.y)
	return { x = left, y = top }
end

local function iter_points_in_line(p1, p2)
	local vert = true
	local current = 0
	if p1.x == p2.x then
		current = math.min(p1.y, p2.y)
	else
		vert = false
		current = math.min(p1.x, p2.x)
	end
	return function()
		if vert then
			if current > (math.max(p1.y, p2.y)) then
				return nil
			else
				current = current + 1
				return { x = p1.x, y = current - 1 }
			end
		else
			if current > (math.max(p1.x, p2.x)) then
				return nil
			else
				current = current + 1
				return { x = current - 1, y = p1.y }
			end
		end
	end
end

local function inside_range(top_left, bottom_right, range, points)
	for x = top_left.x, bottom_right.x, 1 do
		local y = top_left.y
		while y <= bottom_right.y do
			local inside = false
			if range[x] then
				for _, y_range in ipairs(range[x]) do
					if y >= y_range[1] and y <= y_range[2] then
						inside = true
						if bottom_right.y <= y_range[2] then
							y = bottom_right.y
						else
							y = y_range[2]
						end
						break
					end
				end
			end
			if not inside then
				for _, point in ipairs(points) do
					if point.x == x and point.y == y then
						inside = true
						break
					end
				end
			end
			if inside == false then return false end
			y = y + 1
		end
	end
	return true
end

local cords = {}
local index = 1

for x, y in string.gmatch(content, "(%d+),(%d+)") do
	cords[index] = { x = tonumber(x), y = tonumber(y) }
	index = index + 1
end

local max_area = 0
local lines = {}
index = 1

for index_cord, cord in ipairs(cords) do
	lines[index] = index_cord == #cords and
		{ cord, cords[1] } or
		{ cord, cords[index_cord + 1] }
	index = index + 1
end

setmetatable(lines, {
	__pairs = function(t)
		local indx = 0
		return function()
			indx = indx + 1
			while t[indx] and t[indx][1].y ~= t[indx][2].y do
				indx = indx + 1
			end
			if indx > #t then
				return nil
			else
				return indx, t[indx][1], t[indx][2]
			end
		end
	end
})

local range_filled = {}
index = 1

for index_outer, from_outer, to_outer in pairs(lines) do
	local current_point
	for point in iter_points_in_line(from_outer, to_outer) do
		local distance = 0
		for index_inner, from_inner, to_inner in pairs(lines) do
			if index_inner ~= index_outer then
				if point.x >= math.min(from_inner.x, to_inner.x) and
					point.x <= math.max(from_inner.x, to_inner.x) and
					from_inner.y > point.y and
					(distance == 0 or from_inner.y - point.y < distance) then
					distance = from_inner.y - point.y
					local shorten = false
					for _, value in ipairs(lines) do
						if value[1].x == value[2].x and value[1].x == point.x then
							local min = math.min(value[1].y, value[2].y)
							local max = math.max(value[1].y, value[2].y)
							if min == point.y and max == from_inner.y then
								shorten = true
								break
							end
						end
					end
					current_point = shorten and { point.y, from_inner.y - 1 } or { point.y, from_inner.y }
				end
			end
		end
		if not range_filled[point.x] then
			range_filled[point.x] = {}
		end
		table.insert(range_filled[point.x], current_point)
	end
end

for _, range_tab in pairs(range_filled) do
	table.sort(range_tab, function(o1, o2)
		return o1[1] < o2[1]
	end)
	local empty_gap_found = false
	repeat
		empty_gap_found = false
		for indx, point in ipairs(range_tab) do
			if indx > 1 and range_tab[indx - 1][2] == point[1] and
				range_tab[indx + 1] and range_tab[indx + 1][1] == point[2] then
				table.remove(range_tab, indx)
				empty_gap_found = true
				break
			end
		end
	until empty_gap_found == false
end

for index_outer, cord_outer in ipairs(cords) do
	for index_inner, cord_inner in ipairs(cords) do
		if index_outer ~= index_inner and index_inner > index_outer and
			inside_range(get_top_left(cord_outer, cord_inner), get_bottom_right(cord_outer, cord_inner), range_filled, cords) then
			local area = calc_area(cord_outer, cord_inner)
			if area > max_area then
				max_area = area
			end
		end
	end
end

print(max_area)
