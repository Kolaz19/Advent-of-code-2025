package.path = package.path .. ";../../shared/?.lua"
local read = require "read_file"

local content <const> = read.read_file "input.txt"

--Return iterator stopping one char before end
--or starting one char after start_after and stopping at end
local function iterate_numbers(bank, start_after)
	return function(str, control)
		if not control then
			control = 1
		else
			control = control + 1
		end
		local char = string.sub(str, control, control)
		if char and char ~= '' and (start_after or control < #bank) then
			return control, tonumber(char)
		else
			return nil
		end
	end, bank, start_after
end

local sum = 0

for bank in string.gmatch(content, "(%d+)") do
	local highest_first_index = 0
	local highest_first_number = 0
	for index, number in iterate_numbers(bank) do
		if number > highest_first_number then
			highest_first_index = index
			highest_first_number = number
		end
		if number == 9 then break end
	end
	local highest_second_number = 0
	for _, number in iterate_numbers(bank, highest_first_index) do
		if number > highest_second_number then
			highest_second_number = number
		end
		if number == 9 then break end
	end
	sum = sum + (highest_first_number * 10 + highest_second_number)
end

print(sum)
