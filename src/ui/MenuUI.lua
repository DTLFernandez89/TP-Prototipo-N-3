local MenuUI = {}


function MenuUI.draw(selectedScenario)

    love.graphics.clear(0.08, 0.08, 0.1)

    love.graphics.setColor(1, 0.8, 0.2, 1)
    love.graphics.printf("Prototipo 3 - Game", 0, 180, 1280, "center")

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Selecciona el Escenario:", 0, 280, 1280, "center")

    local sc1Text = (selectedScenario == "scenario01") and "> Escenario 01 <" or "  Escenario 01  "
    local sc2Text = (selectedScenario == "scenario02") and "> Escenario 02 <" or "  Escenario 02  "

    love.graphics.setColor(0.4, 0.8, 1, 1)
    love.graphics.printf("[1] " .. sc1Text, 0, 340, 1280, "center")
    love.graphics.printf("[2] " .. sc2Text, 0, 380, 1280, "center")

    love.graphics.setColor(0.2, 1, 0.4, 1)
    love.graphics.printf("Presiona ENTER para Iniciar el Juego", 0, 480, 1280, "center")

    love.graphics.setColor(0.6, 0.6, 0.6, 1)
    love.graphics.printf("Controles: WASD (Mover) | Clic Izquierdo (Disparar)", 0, 580, 1280, "center")
    love.graphics.setColor(1, 1, 1, 1)

end


return MenuUI
