local GameOverUI = {}


function GameOverUI.draw(isWin)

    if isWin then

        love.graphics.clear(0.02, 0.12, 0.05, 1)
        love.graphics.setColor(0.3, 1, 0.4, 1)
        love.graphics.printf("¡FELICIDADES! ¡HAS COMPLETADO EL NIVEL!", 0, 200, 1280, "center")

    else

        love.graphics.clear(0.15, 0.02, 0.02, 1)
        love.graphics.setColor(1, 0.3, 0.3, 1)
        love.graphics.printf("¡HAS MUERTO!", 0, 200, 1280, "center")

    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Opciones Disponibles:", 0, 320, 1280, "center")
    love.graphics.setColor(0.9, 0.9, 0.9, 1)
    love.graphics.printf("[R] - Reiniciar Partida", 0, 380, 1280, "center")
    love.graphics.printf("[M] - Menú Inicial", 0, 420, 1280, "center")
    love.graphics.printf("[ESC] - Salir del Juego", 0, 460, 1280, "center")

end


return GameOverUI
