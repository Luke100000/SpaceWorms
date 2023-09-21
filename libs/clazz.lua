---@class Clazz
---@field private __instances any
---@field private __unlocked boolean
---@field name string
---@field super Clazz
local Clazz = {}

function Clazz:create()
	return setmetatable({}, self)
end

---Creates a new instance
---@param ... any
---@return Clazz
function Clazz:new(...)
	local instance = self:create()
	rawset(instance, "__unlocked", true)
	instance:init(...)
	rawset(instance, "__unlocked", false)
	return instance
end

function Clazz:init(...)

end

local inheritedMetaMethods = {
	"__add", "__sub", "__mul", "__div", "__mod", "__unm", "__concat", "__eq", "__lt", "__le", "__tostring"
}

---Extends that class and returns a child class
---@param name? string
---@return Clazz
function Clazz:extend(name)
	assert(self:isClass(), "Can not extend an instance.")

	---@type Clazz
	local c = { super = self, __unlocked = false, name = name or "undefined" }
	c.__index = c

	--Copy and extend instances
	c.__instances = setmetatable({}, { __mode = "k" })
	for i, _ in pairs(self.__instances or {}) do
		c.__instances[i] = true
	end
	c.__instances[c] = true

	--While metamethodes are inherited via __index, they are not valid methamethods when not linked explicitly
	for _, method in ipairs(inheritedMetaMethods) do
		c[method] = self[method]
	end

	return setmetatable(c, {
		__call = self.new,
		__tostring = self.__class__tostring,
		__index = self
	})
end

---Implements an array of classes, that is, weakly copies every field of the interfaces and its supers to the class, if that field does not exist yet.
---@return Clazz
function Clazz:implement(...)
	assert(self:isClass(), "Can not implement into an instance.")
	for _, class in ipairs({ ... }) do
		while class do
			self.__instances[class] = true
			for i, v in pairs(class) do
				if not self[i] then
					self[i] = v
				end
			end
			class = class.super
		end
	end
	return self
end

---Locks the class, which prevents new instance fields from being created outside the constructor, and prevents new class fields altogether
---@return Clazz
function Clazz:lock()
	assert(self:isClass(), "Can not lock an instance.")
	self.__newindex = self._newindex_lock
	getmetatable(self).__newindex = self._newindex_lock
	return self
end

function Clazz:isClass()
	return rawget(self, "__index") ~= nil
end

function Clazz:instanceOf(class)
	return self.__instances[class] and true or false
end

function Clazz:cast(class)
	return setmetatable(self, class)
end

function Clazz:__tostring()
	return "Instance"
end

function Clazz:__class__tostring()
	return "Class"
end

function Clazz:_newindex_lock(key, value)
	if self.__unlocked then
		rawset(self, key, value)
	else
		error(
			"Attempt to set field '" ..
			tostring(key) ..
			"' with value '" .. tostring(value) .. "' of a locked " .. (self:isClass() and "class" or "instance") .. ".",
			2)
	end
end

Clazz.__index = Clazz

return setmetatable(Clazz, {
	__call = Clazz.extend,
	__tostring = Clazz.__class__tostring
})
