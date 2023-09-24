---@table { [string]: Drawable }
Texture = {}

--automatically loads image when indexed
local meta = {
	__index = function(self, path)
		return love.graphics.newImage(rawget(self, path .. "_path"))
	end
}

Quads = {
	worms = {
		normal = love.graphics.newQuad(0, 0, 6, 7, 18, 14),
		look = love.graphics.newQuad(6, 0, 6, 7, 18, 14),
		idle = love.graphics.newQuad(12, 0, 6, 7, 18, 14),
		walk = love.graphics.newQuad(0, 7, 6, 7, 18, 14),
		jump = love.graphics.newQuad(6, 7, 6, 7, 18, 14),
	},
	death = {
		love.graphics.newQuad(0, 0, 12, 6, 12, 60),
		love.graphics.newQuad(0, 6, 12, 6, 12, 60),
		love.graphics.newQuad(0, 12, 12, 6, 12, 60),
		love.graphics.newQuad(0, 18, 12, 6, 12, 60),
		love.graphics.newQuad(0, 24, 12, 6, 12, 60),
		love.graphics.newQuad(0, 30, 12, 6, 12, 60),
		love.graphics.newQuad(0, 36, 12, 6, 12, 60),
		love.graphics.newQuad(0, 42, 12, 6, 12, 60),
		love.graphics.newQuad(0, 48, 12, 6, 12, 60),
		love.graphics.newQuad(0, 54, 12, 6, 12, 60),
	},
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
