Palla = Class{}

function Palla:init(x, y, width, height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height

	self.deltaX = playerServed == 0 and -100 or 100
	self.deltaY = math.random(-100, 100)
	
end

function Palla:reset()
	self.x = VIRTUAL_WIDTH / 2 - 2
	self.y = VIRTUAL_HEIGHT / 2 - 2
	
	self.deltaX = math.random(2) == 1 and -100 or 100
	self.deltaY = math.random(-100, 100)
end

function Palla:update(dt)
	palla.x = palla.x + palla.deltaX * dt
	palla.y = palla.y + palla.deltaY * dt
end

function Palla:render()
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end


function Palla:collide(pannello)
	if self.x > pannello.x + pannello.width or self.x + self.width < pannello.x then
		return false
	end
	
	if self.y > pannello.y + pannello.height or self.y + self.height < pannello.y then
		return false
	end
	
		--qui ci arriva solo se non esegue il return, quindi solo se non c'e' stata una collisione
	return true
	
end
