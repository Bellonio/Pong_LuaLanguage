IA = Class{}

function  IA:init(pannello)
	math.randomseed(os.time())
	self.pannello = pannello
	self.y_random = pannello2.y
	self.colpiroLaPalla = 0
	self.VELOCITA_SPOST_IA = VELOCITA_SPOST+0.5
end

function IA:muovi()
	
	if self.colpiroLaPalla == 2 then
		self.y_random = palla.y - (palla.height) / 2 - (self.pannello.height / 2) --COLPIRA' LA PALLA IN CENTRO
	end
	
	if self.pannello.y > self.y_random then
		
		if self.pannello.y - self.VELOCITA_SPOST_IA >= self.y_random then
			self.pannello.dy = -self.VELOCITA_SPOST_IA
		else
			self.pannello.dy = self.pannello.y - self.y_random
			if self.pannello.y > self.y_random then
				self.pannello.dy = self.pannello.dy * -1		--devo diminuire le y
			end
		end
		
	elseif self.pannello.y < self.y_random  then
		
		if self.pannello.y + self.VELOCITA_SPOST_IA <= self.y_random then
			self.pannello.dy = self.VELOCITA_SPOST_IA
		else
			self.pannello.dy = self.y_random - self.pannello.y
			if self.pannello.y > self.y_random then
				self.pannello.dy = self.pannello.dy * -1		--devo diminuire le y
			end
		end
	elseif (self.colpiroLaPalla == 2) == false then
		self.pannello.dy = 0
		self.y_random = math.random(0, VIRTUAL_HEIGHT - self.pannello.height)
	end
end

function IA:colpisciPalla(palla)
	
		--1 possibilita su 3 che l'IA colpisca sicuro la palla
	self.colpiroLaPalla = math.random(1,4)
	if self.colpiroPalla == 2 then
	else
		self.y_random = math.random(0, VIRTUAL_HEIGHT - self.pannello.height)
	end
	
end

