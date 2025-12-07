package.path = package.path .. ";../../shared/?.lua"

local function collect_amount_of_splits(x_start, y_start, collisions)
	while Splitters[y_start + 1] and not Splitters[y_start + 1][x_start] do
		y_start = y_start + 1
	end
	if not Splitters[y_start + 1] then
		return
	end
	if collisions[y_start + 1][x_start] then
		-- Already been there
		return
	end
	collisions[y_start + 1][x_start] = true
	collect_amount_of_splits(x_start - 1, y_start + 1, collisions)
	collect_amount_of_splits(x_start + 1, y_start + 1, collisions)
end

local content <const> = require "read_file".read_file "input.txt"

Splitters = {}
local collisions_tracker = {}
local index, sum = 1, 0

-- Create lookup table with ^ positions
for line in string.gmatch(content, "(.-)\n") do
	Splitters[index] = {}
	collisions_tracker[index] = {}
	for i = 1, #line do
		if string.sub(line, i, i) == "^" then
			Splitters[index][i] = true
		end
	end
	index = index + 1
end

collect_amount_of_splits(string.find(content, "S"), 1, collisions_tracker)

for _, line_collisions in ipairs(collisions_tracker) do
	for _, _ in pairs(line_collisions) do
		sum = sum + 1
	end
end

print(sum)
