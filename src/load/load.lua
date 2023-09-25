love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

math.randomseed(os.time())

require("src.load.textures")

Globals = {
	width = 160,
	height = 144,
	AI = false,
}

Clazz = require("libs.clazz")

Classes = {}


local font = love.graphics.newImageFont("textures/font.png",
	"0123456789abcdefghijklmnopqrstuvwxyz.!?:;,()[]{}><-+_*~# @$%'´`öüÖÜ")
font:setLineHeight(1.5)
love.graphics.setFont(font)

TextureShader = love.graphics.newShader("data/texture.glsl")
MainShader = love.graphics.newShader("data/shader.glsl")

local palette = {
	-- https://lospec.com/palette-list/nintendo-gameboy-bgb
	bgb = {
		{ 8 / 255,   24 / 255,  32 / 255,  1.0 },
		{ 52 / 255,  104 / 255, 86 / 255,  1.0 },
		{ 136 / 255, 192 / 255, 112 / 255, 1.0 },
		{ 224 / 255, 248 / 255, 208 / 255, 1.0 }
	},

	-- https://www.color-hex.com/color-palette/26401
	yusdotcom = {
		{ 15.0 / 255.0,  56.0 / 255.0,  15.0 / 255.0, 1.0 },
		{ 48.0 / 255.0,  98.0 / 255.0,  48.0 / 255.0, 1.0 },
		{ 139.0 / 255.0, 172.0 / 255.0, 15.0 / 255.0, 1.0 },
		{ 155.0 / 255.0, 188.0 / 255.0, 15.0 / 255.0, 1.0 }
	},
}

MainShader:send("COLOR_0", palette.bgb[1])
MainShader:send("COLOR_1", palette.bgb[2])
MainShader:send("COLOR_2", palette.bgb[3])
MainShader:send("COLOR_3", palette.bgb[4])

local music = {
	menu = love.audio.newSource("music/chilled_worm.ogg", "static"),
	war = love.audio.newSource("music/worms_war.ogg", "static"),
}

function PlayMusic(name)
	for _, m in pairs(music) do
		m:pause()
	end
	music[name]:play()
	music[name]:setLooping(true)
end

function SetMusicVolume(volume)
	for _, m in pairs(music) do
		m:setVolume(volume)
	end
end

function DeepCopy(orig, copies)
	copies = copies or {}
	local originalType = type(orig)
	local copy
	if originalType == "table" then
		if copies[orig] then
			copy = copies[orig]
		else
			copy = {}
			copies[orig] = copy
			for orig_key, orig_value in next, orig, nil do
				copy[DeepCopy(orig_key, copies)] = DeepCopy(orig_value, copies)
			end
			setmetatable(copy, getmetatable(orig))
		end
	else
		copy = orig
	end
	return copy
end

local sounds = {}
for _, name in ipairs(love.filesystem.getDirectoryItems("sounds")) do
	sounds[name:sub(1, #name - 4)] = love.audio.newSource("sounds/" .. name, "static")
end

function PlaySound(name)
	if not Globals.AI then
		sounds[name]:seek(0)
		sounds[name]:play()
	end
end
