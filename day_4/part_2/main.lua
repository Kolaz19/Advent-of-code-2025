package.path = package.path .. ";../../shared/?.lua"

-- Build 9 char long string that represents chars
-- around chosen '@' and search for '@'
local function is_accessible(bin, x, y)
	local to_check = string.sub(bin[y - 1], x - 1, x + 1) ..
		string.sub(bin[y], x - 1, x + 1) ..
		string.sub(bin[y + 1], x - 1, x + 1)

	--Skip '@' in the middle
	local counter = -1
	for _ in string.gmatch(to_check, '@') do
		counter = counter + 1
		if counter > 3 then
			return false
		end
	end
	return true
end

local function set_to_point(line, index)
	return string.sub(line, 1, index - 1) ..
		'.' .. string.sub(line, index + 1, #line)
end

local content <const> = require "read_file".read_file "input.txt"
local grid = {}
local index = 1
local count = 0
local continue = true

-- Build '.' around grid
for line in string.gmatch(content, "(%S+)") do
	if index == 1 then
		grid[index] = string.rep('.', #line + 2)
	end
	index = index + 1
	grid[index] = '.' .. line .. '.'
end
grid[index + 1] = grid[1]

while continue do
	continue = false
	for key, val in ipairs(grid) do
		if key == #grid then break end
		if key ~= 1 then
			for i = 2, #val - 1 do
				if string.sub(val, i, i) == '@' and is_accessible(grid, i, key) then
					val = set_to_point(val, i)
					grid[key] = val
					count = count + 1
					continue = true
				end
			end
		end
	end
end

print(count)
