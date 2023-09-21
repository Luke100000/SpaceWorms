love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

require("src.load.textures")

Globals = {
	width = 160,
	height = 144,
}

Clazz = require("libs.clazz")

Classes = { }


local font = love.graphics.newImageFont("textures/font.png", "0123456789abcdefghijklmnopqrstuvwxyz.!?:;,()[]{}><-+_*~# @$%'´`öüÖÜ")
font:setLineHeight(1.2)
love.graphics.setFont(font)