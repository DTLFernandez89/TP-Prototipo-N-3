local Concord = require("concord")
local Spawner = require("src.utils.Spawner")


local EnemySystem = Concord.system({

    enemies = {"enemy", "position", "velocity", "drawable"},
    player  = {"player", "position", "drawable"}

})


function EnemySystem:init()

    self.respawnQueue = {}
    self.maxEnemies = 5
    self.spawningActive = true
    self.enemySpeed = 100 

end


function EnemySystem:registerEvents()

    if not self.eventManager then return end

    self.eventManager:on("enemy_died", function(enemyEntity)

        if enemyEntity:has("boss") then return end

        local enemyData = enemyEntity.enemy
        self.eventManager:emit("add_score", enemyData.points)
        enemyEntity:destroy()

        if self.spawningActive then

            table.insert(self.respawnQueue, 2.0)

        end

    end)

    self.eventManager:on("door_spawned", function()
        self.spawningActive = false
        self:killAllEnemies()

    end)

end


function EnemySystem:update(dt)

    local playerEntity = self.player[1]

    if playerEntity then

        local pPos = playerEntity.position
        local pCenterX = pPos.x + 45
        local pCenterY = pPos.y + 45

        for _, enemy in ipairs(self.enemies) do

            if not enemy:has("boss") then

                local eData = enemy.enemy
                local ePos = enemy.position
                local eVel = enemy.velocity
                local eCenterX = ePos.x + 45
                local eCenterY = ePos.y + 45

                local dx = pCenterX - eCenterX
                local dy = pCenterY - eCenterY
                local dist = math.sqrt(dx * dx + dy * dy)

                if dist > 0 then

                    local dirX = dx / dist
                    local dirY = dy / dist

                    eVel.vx = dirX * self.enemySpeed
                    eVel.vy = dirY * self.enemySpeed

                    eData.shootTimer = eData.shootTimer + dt

                    if eData.shootTimer >= eData.shootInterval then

                        eData.shootTimer = 0
                        local w = self:getWorld()

                        if w then

                            local proj = Spawner.spawnProjectile(w, eCenterX, eCenterY, dirX, dirY, "enemy", 300)
                            proj:give("damage", eData.damage)

                        end

                    end

                end

            end

        end

    end


    if self.spawningActive then

        for i = #self.respawnQueue, 1, -1 do

            self.respawnQueue[i] = self.respawnQueue[i] - dt
            if self.respawnQueue[i] <= 0 then

                table.remove(self.respawnQueue, i)
                if #self.enemies < self.maxEnemies then

                    local w = self:getWorld()
                    if w then Spawner.spawnRandomEnemy(w) end

                end

            end

        end

    end

end


function EnemySystem:killAllEnemies()

    for _, enemy in ipairs(self.enemies) do
        if not enemy:has("boss") then

            enemy:destroy()

        end

    end

    self.respawnQueue = {}

end


return EnemySystem
