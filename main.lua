local Concord = require("concord")
local Spawner     = require("src.utils.Spawner")
local DoorTester  = require("src.utils.DoorTester")


--- Carga de Módulos ---
local EventManager    = require("src.managers.EventManager")
local AudioManager    = require("src.managers.AudioManager")
local Spawner         = require("src.utils.Spawner")
local Collisions      = require("src.utils.Collisions")

require("src.components.init")


--- Sistemas Concord ECS ---
local MovementSystem   = require("src.systems.MovementSystem")
local CollisionSystem  = require("src.systems.CollisionSystem")
local PlayerSystem     = require("src.systems.PlayerSystem")
local EnemySystem      = require("src.systems.EnemySystem")
local BossSystem       = require("src.systems.BossSystem")
local CollectibleSystem= require("src.systems.CollectibleSystem")
local RenderSystem     = require("src.systems.RenderSystem")


--- Módulos de UI ---
local HUD        = require("src.ui.HUD")
local AvisosUI   = require("src.ui.AvisosUI")
local MenuUI     = require("src.ui.MenuUI")
local GameOverUI = require("src.ui.GameOverUI")


--- Variables de Estado ---
local TargetFPS = 60
local FrameTime = 1 / TargetFPS
local doorSpawnedFlag = false
GameState = "MENU" --- "MENU", "GAMEPLAY", "GAMEOVER", "WIN" ---
local selectedScenario = "scenario01"


--- Variables de Instancias del Mundo ---
local world, eventManager, audioManager
local hud, avisosUI, assets
local playerEntity


local function loadAssets()

    assets = {

        --- Escenarios ---
        scenario01   = love.graphics.newImage("Archives/scenarios/scenario01.png"),
        scenario02   = love.graphics.newImage("Archives/scenarios/scenario02.png"),

        --- Entidades ---
        player       = love.graphics.newImage("Archives/player/player.png"),
        enemi01      = love.graphics.newImage("Archives/enemies/enemi01.png"),
        enemi02      = love.graphics.newImage("Archives/enemies/enemi02.png"),
        enemi03      = love.graphics.newImage("Archives/enemies/enemi03.png"),
        enemi04      = love.graphics.newImage("Archives/enemies/enemi04.png"),
        enemi05      = love.graphics.newImage("Archives/enemies/enemi05.png"),
        enemie_boss  = love.graphics.newImage("Archives/enemies/enemie_boss.png"),
        proyectile   = love.graphics.newImage("Archives/proyectile/proyectile.png"),
        door         = love.graphics.newImage("Archives/objects/door.png"),

        --- Coleccionables ---
        coin         = love.graphics.newImage("Archives/collectible/coin.png"),
        heart        = love.graphics.newImage("Archives/collectible/heart.png"),
        shield       = love.graphics.newImage("Archives/collectible/shield.png"),
        skull        = love.graphics.newImage("Archives/collectible/skull.png")

    }

end


local function initGame()

    eventManager = EventManager.new()
    audioManager = AudioManager.new(eventManager)
    world = Concord.world()

    hud = HUD.new(eventManager)
    avisosUI = AvisosUI.new(eventManager)

    world:addSystems(

        MovementSystem,
        CollisionSystem,
        PlayerSystem,
        EnemySystem,
        BossSystem,
        CollectibleSystem,
        RenderSystem

    )

    for _, system in ipairs(world:getSystems()) do

        system.eventManager = eventManager

        if system.setScenario then

            system.assets = assets
            system:setScenario(selectedScenario)

        end
        if system.registerEvents then
            system:registerEvents()
        end
    end

    playerEntity = Spawner.spawnPlayer(world)

    for i = 1, 5 do
        Spawner.spawnRandomEnemy(world)
    end

    eventManager:on("player_died", function()
        GameState = "GAMEOVER"
    end)

    local winSoundPlayed = false 
    eventManager:on("game_won", function()
        GameState = "WIN"

        if not winSoundPlayed then

            winSoundPlayed = true
            audioManager:playMusic("win") 

        end
    end)

    local doorSpawned = false

    eventManager:on("time_limit_reached", function()

        if not doorSpawned then
            doorSpawned = true
            eventManager:emit("show_warning", "¡Has aguantado los 2 minutos! La puerta ha aparecido", 5.0)

            local doorTimer = 0
            local co = coroutine.create(function()

                while doorTimer < 5.0 do

                    local dt = coroutine.yield()
                    doorTimer = doorTimer + dt

                end

                Spawner.spawnDoor(world)
                eventManager:emit("door_spawned")

            end)

            if not world.coroutines then world.coroutines = {} end
            table.insert(world.coroutines or {}, co)

        end

    end)

    eventManager:on("boss_defeated", function()

        if not doorSpawnedFlag then

            doorSpawnedFlag = true
            local doorTimer = 0
            local co = coroutine.create(function()

                while doorTimer < 5.0 do

                    local dt = coroutine.yield()
                    doorTimer = doorTimer + (dt or 0)

                end

                Spawner.spawnDoor(world)
                eventManager:emit("door_spawned")

            end)

            if not world.coroutines then world.coroutines = {} end
            table.insert(world.coroutines or {}, co)

        end

    end)

    audioManager:playRandomGameplayMusic()

end


function love.load()

    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest", "nearest")
    loadAssets()
    audioManager = AudioManager.new(nil)
    audioManager:playMusic("main_menu")

end


function love.update(dt)

    if dt < FrameTime then
        love.timer.sleep(FrameTime - dt)
    end

    if GameState == "GAMEPLAY" then
        world:emit("update", dt)

        if world and world.coroutines then
            for i = #world.coroutines, 1, -1 do

                local co = world.coroutines[i]

                if coroutine.status(co) == "dead" then
                    table.remove(world.coroutines, i)
                else
                    coroutine.resume(co, dt)
                end

            end

        end

        hud:update(dt, playerEntity)
        avisosUI:update(dt)

    end

end


function love.draw()

    if GameState == "MENU" then
        MenuUI.draw(selectedScenario)

    elseif GameState == "GAMEPLAY" then
        world:emit("draw")
        hud:draw(playerEntity)
        avisosUI:draw()

    elseif GameState == "GAMEOVER" then
        GameOverUI.draw(false)

    elseif GameState == "WIN" then
        GameOverUI.draw(true)
    end
end


function love.keypressed(key)
    if GameState == "MENU" then
        if key == "1" then
            selectedScenario = "scenario01"
        elseif key == "2" then
            selectedScenario = "scenario02"
        elseif key == "return" or key == "space" then
            GameState = "GAMEPLAY"
            initGame()
        elseif key == "escape" then
            love.event.quit()
        end


    elseif GameState == "GAMEOVER" or GameState == "WIN" then
        if key == "r" then
            GameState = "GAMEPLAY"
            initGame()
        elseif key == "m" then
            GameState = "MENU"
            if audioManager then audioManager:playMusic("main_menu") end
        elseif key == "escape" then
            love.event.quit()
        end


    elseif GameState == "GAMEPLAY" then
        if key == "escape" then
            GameState = "MENU"
            if audioManager then audioManager:playMusic("main_menu") end

         -- SOLO DE PRUEBA --- No se muestra el mensaje en pantalla --- Error de puerta no aparece --- Revisar ---
         -- PRUEBA TEMPORAL: Presiona 'P' para forzar la aparición de la puerta ya mismo
        elseif key == "p" then
            Spawner.spawnDoor(world)
            print(" ¡Puerta forzada con la tecla P! ") --- Reemplazado por DoorTester.lua ---
        end

    end

end


function love.mousepressed(x, y, button)

    if GameState == "GAMEPLAY" then
        world:emit("mousepressed", x, y, button)
    end

end
