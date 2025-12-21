package.path = package.path .. ";../../shared/?.lua"

local content <const> = require "read_file".read_file "input.txt"

local function get_mask_for_button(buttons, len)
	local button_mask = 0
	for _, flag in ipairs(buttons) do
		local shift_left = len - flag - 1
		local mask = 1 << shift_left
		button_mask = button_mask | mask
	end
	return button_mask
end

local function continue_xor(current_value, current_mask, masks)
	local new_value = current_value ~ current_mask
	local new_functions = {}
	for _, mask in ipairs(masks) do
		table.insert(new_functions, function()
			return continue_xor(new_value, mask, masks)
		end
		)
	end
	return new_value, new_functions
end

local data = {}
local index, sum = 1, 0

-- Convert input into binary data for traversal
for lights, buttons_sequence in string.gmatch(content, "%[(%S+)](.-){") do
	data[index] = { target = "" }
	for char in string.gmatch(lights, ".") do
		data[index].target = char == "." and
			data[index].target .. "0" or
			data[index].target .. "1"
	end
	data[index].target = tonumber(data[index].target, 2)

	data[index].masks = {}
	for button in string.gmatch(buttons_sequence, "%(.-%)") do
		local button_flags = {}
		for flag in string.gmatch(button, "%d") do
			table.insert(button_flags, tonumber(flag))
		end
		table.insert(data[index].masks, get_mask_for_button(button_flags, #lights))
	end

	index = index + 1
end

for _, line in ipairs(data) do
	local gathered_functions = {}
	local cur_iteration = 1
	local continue = true
	-- Execute once to start iteration and gather initial functions
	for _, mask in ipairs(line.masks) do
		local current, new_functions = continue_xor(0, mask, line.masks)
		if current == line.target then
			sum = sum + cur_iteration
			continue = false
			break
		end
		for _, new_xor_fun in ipairs(new_functions) do
			table.insert(gathered_functions, new_xor_fun)
		end
	end

	while continue do
		cur_iteration = cur_iteration + 1
		local functions_to_execute = {}

		-- 	prepare functions to execute
		for key, fun in ipairs(gathered_functions) do
			functions_to_execute[key] = fun
			gathered_functions[key] = nil
		end

		-- Execute until target is met and gather functions
		-- for next iteration
		for _, xor_fun in ipairs(functions_to_execute) do
			local current, new_functions = xor_fun()
			if current == line.target then
				sum = sum + cur_iteration
				continue = false
				break
			end
			for _, new_xor_fun in ipairs(new_functions) do
				table.insert(gathered_functions, new_xor_fun)
			end
		end
	end
end

print(sum)
