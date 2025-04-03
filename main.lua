local Container = require("container")
require("tprint")
local window
function love.load()
	window = Container.new({ layout = "vertical" })
		:addButton({ w = 80, h = 50, label = "test1" })
		:addButton({ w = 50, h = 50, label = "test2" })
	window
		:addContainer({ layout = "horizontal" })
		:addButton({ w = 80, h = 50, label = "test3" })
		:addButton({ w = 50, h = 50, label = "test4" })

	print(Tprint(window))
end

function love.draw()
	window:draw()
end
