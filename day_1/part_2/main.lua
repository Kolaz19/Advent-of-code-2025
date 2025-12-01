package.path = package.path .. ";../../shared/?.lua"
local read = require "read_file"

local left <const> = 'L'

local content <const> = read.read_file "input.txt"
local dial_target = 50

local zero_counter = 0
local function add(num)
	zero_counter = zero_counter + num
end

for dir, number in string.gmatch(content, "(%w)(%d+)") do
	add(math.floor(number / 100))

	if dir == left then
		dial_target = dial_target - (number % 100)
	else
		dial_target = dial_target + (number % 100)
	end

	if dial_target > 99 then
		add(1)
		dial_target = dial_target - 100
	elseif dial_target < 0 then
		if dial_target + (number % 100) ~= 0 then
			add(1)
		end
		dial_target = 100 + dial_target
	elseif number % 100 ~= 0 and dial_target == 0 then
		add(1)
	end
end

print(zero_counter)
