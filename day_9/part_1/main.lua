package.path = package.path .. ";../../shared/?.lua"

local content <const> = require "read_file".read_file "input.txt"

local function calc_area(c1, c2)
	local width = c1.x - c2.x
	local height = c1.y - c2.y
	width = width < 0 and (width * -1) + 1 or width + 1
	height = height < 0 and (height * -1) + 1 or height + 1
	return width * height
end

local cords = {}
local index = 1

for x, y in string.gmatch(content, "(%d+),(%d+)") do
	cords[index] = { x = x, y = y }
	index = index + 1
end

local max_area = 0
for index_outer, cord_outer in ipairs(cords) do
	for index_inner, cord_inner in ipairs(cords) do
		if index_outer ~= index_inner and index_inner > index_outer then
			local area = calc_area(cord_outer, cord_inner)
			if area > max_area then
				max_area = area
			end
		end
	end
end

print(max_area)
