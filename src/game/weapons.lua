Weapons = {
	asteroid = require("src.game.weapons.asteroid"),
	bat = require("src.game.weapons.bat"),
	bridge = require("src.game.weapons.bridge"),
	clusterGrenade = require("src.game.weapons.clusterGrenade"),
	doubleBerryShogun = require("src.game.weapons.doubleBerryShogun"),
	grenade = require("src.game.weapons.grenade"),
	ladder = require("src.game.weapons.ladder"),
	lavaGrenade = require("src.game.weapons.lavaGrenade"),
	pickaxe = require("src.game.weapons.pickaxe"),
	pistol = require("src.game.weapons.pistol"),
	rain = require("src.game.weapons.rain"),
	rocketLauncher = require("src.game.weapons.rocketLauncher"),
	soup = require("src.game.weapons.soup"),
	teleportationOrb = require("src.game.weapons.teleportationOrb"),
	walking = require("src.game.weapons.walking"),
}

for name, weapon in pairs(Weapons) do
	weapon.name = name
end
