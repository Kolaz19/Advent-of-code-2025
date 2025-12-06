package.path = package.path .. ";../../shared/?.lua"

local content <const> = require "read_file".read_file "input.txt"

local numbers, signs = {}, {}
local index, sum = 1, 0

for number in content.gmatch(content, "(%d+)") do
	numbers[index] = number
	index = index + 1
end

index = 1
for sign in content.gmatch(content, "([+*])") do
	signs[index] = sign
	index = index + 1
end

for sign_index, sign in ipairs(signs) do
	local line_mult = 1
	local inner_sum = numbers[sign_index]
	repeat
		local cur_number = numbers[sign_index + (#signs * line_mult)]
		if sign == '+' then
			inner_sum = cur_number and (inner_sum + cur_number) or inner_sum
		else
			inner_sum = cur_number and (inner_sum * cur_number) or inner_sum
		end
		line_mult = line_mult + 1
	until not cur_number
	sum = sum + inner_sum
end

print(sum)
