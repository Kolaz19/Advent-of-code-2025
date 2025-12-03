package.path = package.path .. ";../../shared/?.lua"
local read = require "read_file"

local content <const> = read.read_file "input.txt"

local function iterate_numbers(bank, start_after)
	return function(str, control)
		if not control then
			control = 1
		else
			control = control + 1
		end
		local char = string.sub(str, control, control)
		if char and char ~= '' then
			return control, tonumber(char)
		else
			return nil
		end
	end, bank, start_after
end

local sum = 0

for bank in string.gmatch(content, "(%d+)") do
	local saved_index = 0
	for i = 12, 1, -1 do
		local highest_number = 0
		for index, number in iterate_numbers(bank, saved_index) do
			if number > highest_number then
				saved_index = index
				highest_number = number
			end
			if number == 9 or index > #bank - i then
				-- Generate number with i amount of digits and multipy with number
				sum = math.floor(sum + highest_number * (10 ^ (i - 1)))
				break
			end
		end
	end
end

print(sum)
