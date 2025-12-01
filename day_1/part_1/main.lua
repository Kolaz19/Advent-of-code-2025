package.path = package.path .. ";../../shared/?.lua"
local read = require "read_file"

local left <const> = 'L'

local content <const> = read.read_file "input.txt"

local dial_target = 50
local zero_counter = 0

for dir, number in string.gmatch(content, "(%w)(%d+)") do
	local number_left = number % 100
	if dir == left then
		dial_target = dial_target - number_left
	else
		dial_target = dial_target + number_left
	end

	if dial_target > 99 then
		dial_target = dial_target - 100
	elseif dial_target < 0 then
		dial_target = 100 + dial_target
	end
	if dial_target == 0 then zero_counter = zero_counter + 1 end
end

print(zero_counter)
