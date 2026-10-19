local Concord = require("concord")
local Spawner = require("src.utils.Spawner")


local PlayerSystem = Concord.system({

    players = {"player", "position", "velocity", "drawable"}

})


function PlayerSystem:init(eventManager)

    self.eventManager = eventManager
    self.speed = 300
    self.canShoot = true
    self.shootCooldown = 0.25
    self.shootTimer = 0

end


function PlayerSystem:update(dt)

    local p = self.players[1]
    if not p then return end

    local vel = p.velocity
    local vx, vy = 0, 0

    if love.keyboard.isDown("w") or love.keyboard.isDown("up") then vy = vy - 1 end
    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then vy = vy + 1 end
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then vx = vx - 1 end
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then vx = vx + 1 end

    if vx ~= 0 and vy ~= 0 then

        local length = math.sqrt(vx * vx + vy * vy)
        vx = vx / length
        vy = vy / length

    end

    vel.vx = vx * self.speed
    vel.vy = vy * self.speed

    if self.shootTimer > 0 then

        self.shootTimer = self.shootTimer - dt

    end

    if p:has("shielded") then

        local shield = p.shielded
        shield.timer = shield.timer - dt
        if shield.timer <= 0 then

            p:remove("shielded")

        end

    end

end


function PlayerSystem:mousepressed(x, y, button)

    if button ~= 1 then return end
    if self.shootTimer > 0 then return end

    local p = self.players[1]
    if not p then return end

    local pos = p.position
    local draw = p.drawable

    local centerX = pos.x + draw.w / 2
    local centerY = pos.y + draw.h / 2

    local dx = x - centerX
    local dy = y - centerY
    local dist = math.sqrt(dx * dx + dy * dy)

    if dist > 0 then

        local dirX = dx / dist
        local dirY = dy / dist

        local w = self:getWorld()
        if w then

            Spawner.spawnProjectile(w, centerX, centerY, dirX, dirY, "player", 500)
            self.shootTimer = self.shootCooldown

        end

    end

end


return PlayerSystem
