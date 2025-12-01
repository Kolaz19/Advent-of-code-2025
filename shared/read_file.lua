return {
	---Return string from file
	---@param path string
	---@return string
	read_file = function(path)
		local file = io.open(path, "rb") -- r read mode and b binary mode
		if not file then error("Can not read file "..path) end
		local content = file:read "*a" -- *a or *all reads the whole file
		file:close()
		return content
	end

}
