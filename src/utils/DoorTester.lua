---- Creado para forzar el spawn de la puerta al completarse una de las dos condiciones ----

local Spawner = require("src.utils.Spawner")
local DoorTester = {}


function DoorTester.forceSpawn(world, eventManager)

    if world then

        if Spawner and Spawner.spawnDoor then

            Spawner.spawnDoor(world)

        end
        
        if eventManager then

            eventManager:emit("show_warning", "¡Puerta forzada desde archivo externo!", 3.0)

        end
        
        
        print(" [DoorTester] ¡Puerta generada exitosamente desde módulo externo!")
    else
        print(" [DoorTester] Error: El mundo ECS no existe todavía.")
    end

end


return DoorTester
