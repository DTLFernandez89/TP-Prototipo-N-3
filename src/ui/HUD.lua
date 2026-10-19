-- src/ui/HUD.lua
-- Renderizado del HUD (Vida, Oro, Puntaje y Temporizador de 3 Minutos)

local HUD = {}
HUD.__index = HUD


function HUD.new(eventManager)

    local self = setmetatable({}, HUD)
    self.score = 0
    self.gold = 0
    self.gameTimer = 120.0 
    self.eventManager = eventManager
    self:registerEvents()
    return self

end


function HUD:registerEvents()

    if not self.eventManager then return end

    self.eventManager:on("add_score", function(pts)

        self.score = self.score + pts

    end)

    self.eventManager:on("add_gold", function(amount)

        self.gold = self.gold + amount

    end)

end


function HUD:update(dt, playerEntity)

    if self.gameTimer > 0 then

        self.gameTimer = self.gameTimer - dt

        if self.gameTimer <= 0 then

            self.gameTimer = 0
            self.eventManager:emit("time_limit_reached")

        end

    end

end


function HUD:draw(playerEntity)

    love.graphics.setColor(1, 1, 1, 1)

    local hp = playerEntity and playerEntity.health and playerEntity.health.hp or 0
    local maxHp = playerEntity and playerEntity.health and playerEntity.health.maxHp or 100

    love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
    love.graphics.rectangle("fill", 20, 20, 250, 25)


    if playerEntity and playerEntity:has("shielded") then
        love.graphics.setColor(0.2, 0.6, 1.0, 0.9) -- Indicador de escudo
    else
        love.graphics.setColor(0.9, 0.2, 0.2, 0.9)
    end


    love.graphics.rectangle("fill", 20, 20, math.max(0, (hp / maxHp) * 250), 25)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", 20, 20, 250, 25)
    love.graphics.print(string.format("HP: %d / %d", math.ceil(hp), maxHp), 30, 25)
    love.graphics.printf(string.format("ORO: %d  |  PUNTOS: %d", self.gold, self.score), 0, 25, 1260, "right")

    local mins = math.floor(self.gameTimer / 60)
    local secs = math.floor(self.gameTimer % 60)

    love.graphics.printf(string.format("TIEMPO: %02d:%02d", mins, secs), 0, 25, 1280, "center")

end


return HUD
