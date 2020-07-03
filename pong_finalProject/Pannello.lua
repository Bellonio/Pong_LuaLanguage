Pannello = Class{}

function Pannello:init(x, y, width, height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	
	self.dy = 0
end

function Pannello:update()
	if ((self.y+self.dy)+self.height) < VIRTUAL_HEIGHT and (self.y+self.dy) > 0 then
		self.y = self.y + self.dy
	end
end

function Pannello:render()
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Pannello:reset(y)
	self.y = y
	self.height = 40
end
