--LE VARIABILI IN LUA SONO GLOBALI IN TUTTO IL PROGETTO, a me no che non usi la seguente sinstassi "local nome..."

	--importo una "classe"
push = require "push"
Class = require "class"		--senza di questo le classi Pannello/Palla darebbero errore alla prima riga

require "Pannello"
require "Palla"
require "IA"

WINDOW_WIDTH = 1260
WINDOW_HEIGHT = 690

VIRTUAL_WIDTH = 426
VIRTUAL_HEIGHT = 243

VELOCITA_SPOST = 3


function love.load()
		--creo il seme per la genereazione di numeri casuali (che mi servira' per la palla) usando come numero l'ora trasformata in secondi
	math.randomseed(os.time())	
	
		--creo nuovi oggetti Font usando file .ttf  (secondo parametro e' la dimensione)
	
	newFont = love.graphics.newFont("nuovoFont/nuovoFont.ttf", 8)
	fontPunteggio = love.graphics.newFont("nuovoFont/nuovoFont.ttf", 32)
	
	suoni = {															--oppure "stream"
		["pannelloColpito"] = love.audio.newSource("suoni/pannelloColpito.wav", "static"),
		["punto"] = love.audio.newSource("suoni/punto.wav", "static"),
		["muroColpito"] = love.audio.newSource("suoni/muroColpito.wav", "static")
	}
	
	
	love.window.setTitle("Pong")
	
	love.graphics.setDefaultFilter("nearest", "nearest")
		
		--uso un metodo del "classe" push
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		vsync = true,
		resizable = false
	})
	
	pannello1 = Pannello(5, 20, 5, 40)
	pannello2 = Pannello(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 40, 5, 40)
	
	IntelArtif = IA(pannello2)
	
	playerServed = math.random(0, 1)
	palla = Palla(VIRTUAL_WIDTH / 2 -2, VIRTUAL_HEIGHT / 2 -2, 6, 6)
	
	ptPlayer1 = 0
	ptPlayer2 = 0
	
	statoDelGioco = "initialState"
	modalita = 5			--giusto per inizializzare la variabile ad un valore
end


function love.update(dt)
	
	if statoDelGioco == "play" then
		
		if palla.x <= 0 then
			suoni["punto"]:play()
			palla:reset()
			pannello1:reset(5)
			pannello2:reset((VIRTUAL_HEIGHT - 40))
			palla.deltaX = -100
			playerServed = 0
			statoDelGioco = "start"
			palla.deltaX = palla.deltaX * 1.5
			
			VELOCITA_SPOST = 3
			IntelArtif.VELOCITA_SPOST_IA = VELOCITA_SPOST+0.5
			
			ptPlayer2 = ptPlayer2 + 1
			if ptPlayer2 == 3 then
				statoDelGioco = "finish"
				playerWinner = 1
			end
		end
		
		if palla.x >= VIRTUAL_WIDTH -4 then
			suoni["punto"]:play()
			palla:reset()
			pannello1:reset(5)
			pannello2:reset((VIRTUAL_HEIGHT - 40))
			palla.deltaX = 100
			playerServed = 1
			statoDelGioco = "start"
			palla.deltaX = palla.deltaX * 1.5

			VELOCITA_SPOST = 3
			IntelArtif.VELOCITA_SPOST_IA = VELOCITA_SPOST+0.5

			ptPlayer1 = ptPlayer1 + 1
			if ptPlayer1 == 3 then
				statoDelGioco = "finish"
				playerWinner = 0
			end
		end
		
		
		if palla:collide(pannello1) then
			IntelArtif:colpisciPalla(palla)
			VELOCITA_SPOST = VELOCITA_SPOST+0.5
			IntelArtif.VELOCITA_SPOST_IA = IntelArtif.VELOCITA_SPOST_IA+0.5
			suoni["pannelloColpito"]:play()
			palla.deltaX = -palla.deltaX
			aumentaVelocitaPalla()
			diminuisciDimensione(pannello1)
			diminuisciDimensione(pannello2)
		end
		
		if palla:collide(pannello2) then
			IntelArtif:colpisciPalla(palla)
			VELOCITA_SPOST = VELOCITA_SPOST+0.5
			IntelArtif.VELOCITA_SPOST_IA = IntelArtif.VELOCITA_SPOST_IA+0.5
			suoni["pannelloColpito"]:play()
			palla.deltaX = -palla.deltaX
			aumentaVelocitaPalla()
			diminuisciDimensione(pannello1)
			diminuisciDimensione(pannello2)
		end
		
		if palla.y <= 0 then
			IntelArtif:colpisciPalla(palla)
			suoni["muroColpito"]:play()
			palla.deltaY = -palla.deltaY
			palla.y = 0
			aumentaVelocitaPalla()
		end
		
		if palla.y >= VIRTUAL_HEIGHT - 4 then
			IntelArtif:colpisciPalla(palla)
			suoni["muroColpito"]:play()
			palla.deltaY = -palla.deltaY
			palla.y = VIRTUAL_HEIGHT - 4
			aumentaVelocitaPalla()
		end
	end
	
	if love.keyboard.isDown("w") then
		pannello1.dy = -VELOCITA_SPOST		
	elseif love.keyboard.isDown("s") then
		pannello1.dy = VELOCITA_SPOST
	else
		pannello1.dy = 0
	end
		
	if modalita == 2 then
		if love.keyboard.isDown("up") then		
			pannello2.dy = -VELOCITA_SPOST		
		elseif love.keyboard.isDown("down") then	
			pannello2.dy = VELOCITA_SPOST
		else
			pannello2.dy = 0	
		end
	else
		IntelArtif:muovi()
	end
	
	if statoDelGioco == "play" then
		palla:update(dt)
	end
	
	pannello1:update()
	pannello2:update()
end

function diminuisciDimensione(pannello)
	if pannello.height > 15 then	
		pannello.height = pannello.height - 3
	end
end

function aumentaVelocitaPalla()
	if palla.deltaY < 0 then
		palla.deltaY = palla.deltaY - 17
	else
		palla.deltaY = palla.deltaY + 17
	end
end


	--evento, dove key prende il valore del tasto cliccato
function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	elseif key == "return" or key == "enter" then
		if statoDelGioco == "start" then
			statoDelGioco = "play"
			IntelArtif:colpisciPalla(palla)
			if playerServed == 1 and modalita == 1 then
				IntelArtif.colpiroLaPalla = 2
			end
		elseif statoDelGioco == "finish" then
			reset()
			statoDelGioco = "initialState"
		else
			if modalita < 0 then
				statoDelGioco = "start"
				modalita = modalita*-1		--(cambio di segno)
			end
		end
	end
	
	if statoDelGioco == "initialState" then
		if key == "left" then
			modalita = -1
		elseif key == "right" then
			modalita = -2
		end
	end
end

function love.draw()
	push:apply("start")
	
		--cambiamo lo sfondo, parametri RGBA, tutti tra 0.0-1.0 (per questo divido per 255)
	love.graphics.clear(40/255, 45/255, 52/255, 255/255)	
		
		--per disegnare rettangolo pieno ("line" solo contorno, posX, posY, larghezza, altezza (!!! è l'angolino in alto a sx che viene posizionato, se voglio centrare il rettangolo dovro' sottrarre la meta' della sua grandezza))
	
	pannello1:render()
	pannello2:render()
	
	palla:render()
	
	love.graphics.setFont(newFont)

	if statoDelGioco == "start" then
		love.graphics.printf("Hello, press enter to play!", 0, 20, VIRTUAL_WIDTH, "center")
		
		love.graphics.setColor(0,1,0,1)
		love.graphics.print("W\nS", VIRTUAL_WIDTH / 2 - 45, VIRTUAL_HEIGHT / 3)
		if modalita == 2 then
			love.graphics.print("FrecciaSU\nFrecciaGIU", VIRTUAL_WIDTH / 2 + 22, VIRTUAL_HEIGHT / 3)
		end
		love.graphics.setColor(1, 1, 1, 1)
	elseif statoDelGioco == "play" then
		love.graphics.printf("Player " .. tostring(playerServed+1) .." starts", 0, 20, VIRTUAL_WIDTH, "center")
	elseif statoDelGioco == "finish" then
		love.graphics.printf("Player " .. tostring(playerWinner+1) .. " WINS THE GAME !", 0, 20, VIRTUAL_WIDTH, "center")
		love.graphics.printf("Press 'esc' to quit or 'enter' to play again", 0, 30, VIRTUAL_WIDTH, "center")
	else
		love.graphics.printf("Hello, choose the mode and press enter to set!", 0, 20, VIRTUAL_WIDTH, "center")
		love.graphics.print("Single\nplayer.", VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT - 40)
		love.graphics.print("Multi\nplayer.", VIRTUAL_WIDTH / 2 + 22, VIRTUAL_HEIGHT - 40)
	end
	
	love.graphics.setColor(0,1,0,1)
	if modalita == -1 then
		love.graphics.rectangle("line", VIRTUAL_WIDTH / 2 - 53, VIRTUAL_HEIGHT - 43, 35, 21)
	elseif modalita == -2 then
		love.graphics.rectangle("line", VIRTUAL_WIDTH / 2 + 18, VIRTUAL_HEIGHT - 43, 35, 21)
	elseif modalita > 0 then
			--non so come rimuovere dallo schermo il rettangolo, quindi lo sposto a mio vantaggio
		love.graphics.rectangle("line", 38, 9, 33, 9)
	end
	love.graphics.setColor(1, 1, 1, 1)
	
	love.graphics.setFont(fontPunteggio)
			--stringa, posizioneX, posY           allineamento rispetto a cosa, che allineamento
	love.graphics.print(ptPlayer1, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3 - 40)
	love.graphics.print(ptPlayer2, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3 - 40)
	
	love.graphics.setFont(newFont)
	love.graphics.print("Player1", VIRTUAL_WIDTH / 2 - 55, VIRTUAL_HEIGHT / 3 - 10)
	love.graphics.print("Player2", VIRTUAL_WIDTH / 2 + 22, VIRTUAL_HEIGHT / 3 - 10)

	mostraFPS()
	
	push:apply("end")
end

function mostraFPS()
		
		--cambio il colore degli oggetti grafici  in verde (RGBA --> 0,255,0,255)
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.setFont(newFont)
				-- ".." simbolo per il concatenamento di stringhe
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 40, 10)
	love.graphics.setColor(1, 1, 1, 1)			--rimetto colore di default: bianco
	
end

function reset()
	VELOCITA_SPOST = 3
	IntelArtif.VELOCITA_SPOST_IA = VELOCITA_SPOST+0.5
	modalita = 5
	
	pannello1:reset(5)
	pannello2:reset(VIRTUAL_HEIGHT - 40)
	
	playerServed = math.random(0, 1)
	palla.deltaX = playerServed == 0 and -100 or 100
	
	ptPlayer1 = 0
	ptPlayer2 = 0
	
	statoDelGioco = "start"
end
