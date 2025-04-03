local Button = require("button")
local Container = {}
Container.__index = Container

function Container.new(settings)
	local instance           = setmetatable({}, Container)
	instance.x               = settings.x or 0
	instance.y               = settings.y or 0
	instance.w               = settings.w or 0
	instance.h               = settings.h or 0
	instance.layout          = settings.layout or "horizontal"
	instance.spacing         = settings.spacing or 10
	instance.label           = "container"
	instance.border          = settings.border or true
	instance.borderColor     = settings.borderColor or { 0, 0, 0, 1 }
	instance.backgroundColor = settings.backgroundColor or { 0, 0, 0, 1 }
	instance.alignment       = {
		horizontal = settings.alignment and settings.alignment.horizontal or "center",
		vertical = settings.alignment and settings.alignment.vertical or "center"
	}

	instance.children        = {}
	return instance
end

function Container:addButton(settings)
	local button = Button.new(settings)
	table.insert(self.children, button)
	self:updateChildren()
	return self
end

function Container:addContainer(settings)
	local container = Container.new(settings)
	table.insert(self.children, container)
	self:updateChildren()
	return self
end

function Container:attach(targets, side)
	if targets.label then
		targets = { targets }
	end

	for i = 1, #targets do
		if side == "bottom" then
			self.x = targets[1].x
			self.y = targets[1].y + targets[1].h
			self.w = self.w + targets[i].w
		elseif side == "right" then
			self.x = targets[1].x + targets[1].w
			self.y = targets[1].y
			self.h = self.h + targets[i].h
		end
	end
	return self
end

function Container:updateChildren()
	local childrenTotalWidth, childrenTotalHeight = 0, 0

	for i, child in ipairs(self.children) do
		if self.layout == "horizontal" then
			childrenTotalWidth = childrenTotalWidth + child.w + (self.spacing * (i - 1))
			childrenTotalHeight = math.max(childrenTotalHeight, child.h)
		else
			childrenTotalHeight = childrenTotalHeight + child.h + (self.spacing * (i - 1))
			childrenTotalWidth = math.max(childrenTotalWidth, child.w)
		end
	end

	self.w = math.max(self.w, childrenTotalWidth)
	self.h = math.max(self.h, childrenTotalHeight)

	local startX, startY

	-- Horizontal Alignment
	if self.alignment.horizontal == "center" then
		startX = self.x + (self.w - childrenTotalWidth) / 2
	elseif self.alignment.horizontal == "right" then
		startX = self.x + self.w - childrenTotalWidth
	else -- Default to left
		startX = self.x
	end

	-- Vertical Alignment
	if self.alignment.vertical == "center" then
		startY = self.y + (self.h - childrenTotalHeight) / 2
	elseif self.alignment.vertical == "bottom" then
		startY = self.y + self.h - childrenTotalHeight
	else
		startY = self.y
	end

	local offsetX, offsetY = startX, startY
	for _, child in ipairs(self.children) do
		if self.layout == "horizontal" then
			child.x = offsetX
			if self.alignment.vertical == "bottom" then
				child.y = self.y + self.h - child.h
			elseif self.alignment.vertical == "center" then
				child.y = self.y + (self.h - child.h) / 2
			else
				child.y = startY
			end
			offsetX = offsetX + child.w + self.spacing
		else
			child.x = startX + (self.w - child.w) / 2
			child.y = offsetY
			offsetY = offsetY + child.h + self.spacing
		end
	end
end

function Container:mousepressed(x, y, button, isTouch)
	for _, child in ipairs(self.children) do
		if child.mousepressed then
			child:mousepressed(x, y, button, isTouch)
		end
	end
end

function Container:update(dt)

end

function Container:getDimensions()
	return self.w, self.h
end

function Container:getPosition()
	return self.x, self.y
end

function Container:draw()
	if self.backgroundColor then
		love.graphics.setColor(self.backgroundColor)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	end

	if self.border or self.borderColor then
		love.graphics.setColor(self.borderColor)
		love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	end

	love.graphics.setColor(1, 1, 1, 1)
	for _, child in ipairs(self.children) do
		child:draw()
	end
	love.graphics.setColor(1, 1, 1, 1)
end

return Container
