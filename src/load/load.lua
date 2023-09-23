love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

require("src.load.textures")

Globals = {
	width = 160,
	height = 144,
}

Clazz = require("libs.clazz")

Classes = {}


local font = love.graphics.newImageFont("textures/font.png",
	"0123456789abcdefghijklmnopqrstuvwxyz.!?:;,()[]{}><-+_*~# @$%'´`öüÖÜ")
font:setLineHeight(1.2)
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
