local Text = {}
Text.__index = Text

function Text.new(settings)
	local instance   = setmetatable({}, Text)
	instance.id      = settings.id or nil
	instance.type    = "text"
	instance.text    = settings.text or ""
	instance.font    = settings.font or love.graphics:getFont()
	instance.color   = settings.color or { 1, 1, 1, 1 }
	instance.align   = settings.align or "left" -- left, center, right
	instance.x       = settings.x or 0
	instance.y       = settings.y or 0
	instance.w       = settings.w or 200
	instance.h       = settings.h or 200
	instance.enabled = settings.enabled ~= false

	return instance
end

function Text:draw()
	love.graphics.setFont(self.font)
	love.graphics.setColor(self.color)
	love.graphics.printf(self.text, self.x, self.y, self.w, self.align)
end

return Text
