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

local sum_lines = index - 1

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
local i = 1
while true do
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
				circuits[combine] = nil
			else
				combine = circuit_index
			end

			local sum, sum_circuits = 0, 0
			for _, circuit_inner in pairs(circuits) do
				sum_circuits = sum_circuits + 1
				for _, _ in pairs(circuit_inner) do
					sum = sum + 1
				end
			end
			--Check for end condition
			if sum == sum_lines and sum_circuits == 1 then
				print(connections[i].p1.x * connections[i].p2.x)
				os.exit()
			end
		end
	end

	if not found then
		table.insert(circuits, {
			[connections[i].p1] = true,
			[connections[i].p2] = true,
		})
	end
	i = i + 1
end
