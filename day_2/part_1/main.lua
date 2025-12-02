package.path = package.path .. ";../../shared/?.lua"
local read = require "read_file"

local content <const> = read.read_file "input.txt"

local sum_invalid_ids = 0

for from, to in string.gmatch(content, "(%d+)-(%d+)") do
	local id = tonumber(from)
	while id <= tonumber(to) do
		local len = string.len(tostring(id))
		if len % 2 == 0 then
			local first_half = string.sub(tostring(id), 1, len / 2)
			local second_half = string.sub(tostring(id), (len / 2) + 1, len)

			if (first_half == second_half) then
				sum_invalid_ids = sum_invalid_ids + id
				id = id + 1
			elseif tonumber(second_half) < tonumber(first_half) then
				id = tonumber(first_half .. first_half)
			else
				--Increment first half by one, Reset second half to power of ten
				--105 -> 106	+	107 -> 100
				id = tonumber(tostring(tonumber(first_half) + 1) .. tostring(math.floor(10 ^ ((len/2) - 1))))
			end
		else
			--Skip to next larger number of digits
			id = math.floor(10 ^ (len))
		end
	end
end

print(sum_invalid_ids)
