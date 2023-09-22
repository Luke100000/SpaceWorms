---@table { [string]: Drawable }
Texture = {}

--automatically loads image when indexed
local meta = {
	__index = function(self, path)
		return love.graphics.newImage(rawget(self, path .. "_path"))
	end
}

--index function
local function recLoad(path, textures, prefix)
	setmetatable(textures, meta)

	for _, s in ipairs(love.filesystem.getDirectoryItems(path)) do
		if love.filesystem.getInfo(path .. "/" .. s, "directory") then
			rawset(textures, s, rawget(textures, s) or {})

			recLoad(path .. "/" .. s, textures[s], prefix)
		else
			local ext = s:sub(#s - 3)
			if ext == ".png" then
				local name = prefix .. s:sub(1, #s - 4) .. "_path"
				local p = path .. "/" .. s

				rawset(textures, name, p)
			end
		end
	end
end

--start indexing
recLoad("textures", Texture, "")
