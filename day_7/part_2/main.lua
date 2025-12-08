package.path = package.path .. ";../../shared/?.lua"

local splitters, beam_tracker = {}, {}
local line_len = 0

local content <const> = require "read_file".read_file "input.txt"

local index, sum = 1, 0

-- Create lookup table with ^ positions
for line in string.gmatch(content, "(.-)\n") do
	splitters[index] = {}
	line_len = #line
	for i = 1, line_len do
		if string.sub(line, i, i) == "^" then
			splitters[index][i] = true
		end
	end
	index = index + 1
end

beam_tracker[string.find(content, "S")] = 1
for _, splitter_row in ipairs(splitters) do
	for splitter_index, _ in pairs(splitter_row) do
		if beam_tracker[splitter_index] then
			beam_tracker[splitter_index - 1] = beam_tracker[splitter_index - 1] and
				beam_tracker[splitter_index - 1] + beam_tracker[splitter_index] or beam_tracker[splitter_index]
			beam_tracker[splitter_index + 1] = beam_tracker[splitter_index + 1] and
				beam_tracker[splitter_index + 1] + beam_tracker[splitter_index] or beam_tracker[splitter_index]
			beam_tracker[splitter_index] = 0
		end
	end
end

for _, val in pairs(beam_tracker) do
	sum = sum + val
end

print(sum)
