package.path = package.path .. ";../../shared/?.lua"

local content <const> = require "read_file".read_file "input.txt"

local numbers_line, signs, numbers_block = {}, {}, {}
local index, sum, start_substring = 1, 0, 1

-- Collect signs
for sign in content.gmatch(content, "([+*])") do
	signs[index] = sign
	index = index + 1
end

-- Divide into single lines and remove sign column
index = 1
for line in content.gmatch(content, "(.-)\n") do
	numbers_line[index] = line
	index = index + 1
end
numbers_line[#numbers_line] = nil

-- Arrange data into blocks (preserving spaces)
for i = 1, #(numbers_line[1]) + 1 do
	local space_column = true
	for _, line in ipairs(numbers_line) do
		if i ~= #(numbers_line[1]) + 1 and string.sub(line, i, i) ~= " " then
			space_column = false
		end
	end
	-- Divide at space-only columns
	if space_column then
		numbers_block[#numbers_block + 1] = {}
		for line_index, line in ipairs(numbers_line) do
			numbers_block[#numbers_block][line_index] =
				string.sub(line, start_substring, i - 1)
		end
		start_substring = i + 1
	end
end

for block_index, lines in ipairs(numbers_block) do
	local inner_sum = 0
	--Scan column for column and combine digits
	for char_index = 1, #lines[1] do
		local number_as_string = ""
		for _, number_string in ipairs(lines) do
			number_as_string = number_as_string ..
				string.sub(number_string, char_index, char_index)
		end
		local number = tonumber(number_as_string)
		if signs[block_index] == "+" then
			inner_sum = inner_sum == 0 and number or inner_sum + number
		else
			inner_sum = inner_sum == 0 and number or inner_sum * number
		end
	end
	sum = sum + inner_sum
end

print(sum)
