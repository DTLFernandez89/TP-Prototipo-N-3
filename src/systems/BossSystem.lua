local Concord = require("concord")
local Spawner = require("src.utils.Spawner")


local BossSystem = Concord.system({

    bosses = {"boss", "position", "drawable"}

})


function BossSystem:init()

    self.bossRoutine = nil
    self.bossActive = false
    self.bossCheckTimer = 0
    self.checkInterval = 10

end


function BossSystem:registerEvents()

    if not self.eventManager then return end

    self.eventManager:on("enemy_died", function(enemyEntity)

        if enemyEntity:has("boss") then

            self.eventManager:emit("add_score", 100)
            enemyEntity:destroy()
            self.eventManager:emit("show_warning", "¡Felicidades! Eliminaste al Gran Jefe. La puerta ha aparecido", 5.0)
            self.eventManager:emit("boss_defeated")

        end

    end)

end


function BossSystem:startBossCheck()

    self.bossRoutine = coroutine.create(function()

        local roll = math.random(1, 100)

        if roll <= 10 then

            self.bossActive = true

            if self.eventManager then

                self.eventManager:emit("show_warning", "¡ADVERTENCIA! El Gran Jefe está apareciendo...", 5.0)

            end

            local elapsed = 0
            while elapsed < 5.0 do

                local dt = coroutine.yield()
                elapsed = elapsed + (dt or 0)

            end

            local w = self:getWorld()
            if w then

                Spawner.spawnBoss(w)

            end

        end

    end)

end


function BossSystem:update(dt)

    if self.bossRoutine and coroutine.status(self.bossRoutine) ~= "dead" then

        coroutine.resume(self.bossRoutine, dt)

    elseif not self.bossActive then

        self.bossCheckTimer = self.bossCheckTimer + dt
        if self.bossCheckTimer >= self.checkInterval then

            self.bossCheckTimer = 0
            self:startBossCheck()

        end

    end

    for _, boss in ipairs(self.bosses) do
        
        local bData = boss.enemy
        local bPos = boss.position
        local bDraw = boss.drawable
        local bCenterX = bPos.x + bDraw.w / 2
        local bCenterY = bPos.y + bDraw.h / 2

        bData.shootTimer = bData.shootTimer + dt

        if bData.shootTimer >= bData.shootInterval then
            bData.shootTimer = 0

            local numProjectiles = 8
            local w = self:getWorld()
            for i = 1, numProjectiles do

                local angle = (i - 1) * (2 * math.pi / numProjectiles)
                local dirX = math.cos(angle)
                local dirY = math.sin(angle)

                if w then

                    local proj = Spawner.spawnProjectile(w, bCenterX, bCenterY, dirX, dirY, "enemy", 250)
                    proj:give("damage", 50)

                end

            end

        end

    end

end


return BossSystem
