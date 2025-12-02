package.path = package.path .. ";../../shared/?.lua"
local read = require "read_file"

local content <const> = read.read_file "input.txt"

local sum_invalid_ids = 0

local function split_into_equal_parts(num, times)
	local len <const> = string.len(tostring(num))
	if len % times == 0 then
		local tab = {}
		for i = 0, times - 1, 1 do
			tab[i + 1] = string.sub(tostring(num),
				(i * (len / times) + 1),
				i * (len / times) + (len / times))
		end
		return tab
	else
		return nil
	end
end

local function parts_equal(tab)
	local match = tab[1]
	for _, value in ipairs(tab) do
		if value ~= match then return false end
	end
	return true
end

for from, to in string.gmatch(content, "(%d+)-(%d+)") do
	local id = tonumber(from)
	while id <= tonumber(to) do
		local len <const> = string.len(tostring(id))
		for no_splits = 2, len do
			local parts = split_into_equal_parts(id, no_splits)
			if parts and parts_equal(parts) then
				sum_invalid_ids = sum_invalid_ids + id
				break
			end
		end
		id = id + 1
	end
end

print(sum_invalid_ids)
