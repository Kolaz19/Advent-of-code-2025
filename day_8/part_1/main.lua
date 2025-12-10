package.path = package.path .. ";../../shared/?.lua"

local content <const> = require "read_file".read_file "input.txt"

local function distance_3d(p1, p2)
	local dx = p2.x - p1.x
	local dy = p2.y - p1.y
	local dz = p2.z - p1.z
	return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local points, connections, circuits = {}, {}, {}
local index = 1

for x, y, z in string.gmatch(content, "(%d+),(%d+),(%d+)") do
	points[index] = { x = x, y = y, z = z }
	index = index + 1
end

index = 1
-- Calculate len between every point
for index_outer, cords_outer in ipairs(points) do
	for index_inner, cords_inner in ipairs(points) do
		if index_outer ~= index_inner and index_inner > index_outer then
			connections[index] = {
				len = distance_3d(cords_outer, cords_inner),
				p1 = cords_outer,
				p2 = cords_inner
			}
			index = index + 1
		end
	end
end

table.sort(connections, function(x1, x2)
	return x1.len < x2.len
end)

--Put shortest connections into their own table (circuits)
--and combine them if they reside in different circuits already
for i = 1, 1000 do
	local found = false
	local combine = nil
	for circuit_index, circuit in pairs(circuits) do
		if circuit[connections[i].p1] or
			circuit[connections[i].p2] then
			circuit[connections[i].p1] = true
			circuit[connections[i].p2] = true
			found = true
			if combine then
				for indx, val in pairs(circuits[combine]) do
					circuit[indx] = val
				end
				circuits[combine] = {}
				break
			else
				combine = circuit_index
			end
		end
	end

	if not found then
		table.insert(circuits, {
			[connections[i].p1] = true,
			[connections[i].p2] = true,
		})
	end
end

table.sort(circuits, function(x1, x2)
	local sum_x1, sum_x2 = 0, 0
	for _, _ in pairs(x1) do
		sum_x1 = sum_x1 + 1
	end
	for _, _ in pairs(x2) do
		sum_x2 = sum_x2 + 1
	end
	return sum_x1 > sum_x2
end)

local all_sum = 0
for i = 1, 3 do
	local sum = 0
	for _, _ in pairs(circuits[i]) do
		sum = sum + 1
	end
	if all_sum == 0 then
		all_sum = sum
	else
		all_sum = sum * all_sum
	end
end

print(all_sum)
