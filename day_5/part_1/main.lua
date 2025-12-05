package.path = package.path .. ";../../shared/?.lua"

local content <const> = require "read_file".read_file "input.txt"

local sum_fresh = 0
local ranges = {}
local ids = {}
local index = 1

-- Save data in tables and sort them
for from, to in content.gmatch(content, "(%d+)-(%d+)") do
	ranges[index] = { from = tonumber(from), to = tonumber(to) }
	index = index + 1
end
table.sort(ranges, function(o1, o2) return o1.from < o2.from end)

index = 1
for id in content.gmatch(content, "(%d+)", string.find(content, "\n\n")) do
	ids[index] = tonumber(id)
	index = index + 1
end
table.sort(ids)

--Look ahead and check if ranges can be combined or eliminated
for indx, val in ipairs(ranges) do
	while true do
		if indx == #ranges then break end
		if val.to >= ranges[indx + 1].to then
			table.remove(ranges, indx + 1)
		elseif val.to >= ranges[indx + 1].from then
			val.to = ranges[indx + 1].to
			table.remove(ranges, indx + 1)
		else
			break
		end
	end
end

--Traverse tables and keep them in sync
--so we only have to traverse both once
index = 1
for _, range in ipairs(ranges) do
	while ids[index] do
		if ids[index] < range.from then
			index = index + 1
		elseif ids[index] > range.to then
			break
		else
			sum_fresh = sum_fresh + 1
			index = index + 1
		end
	end
end

print(sum_fresh)
