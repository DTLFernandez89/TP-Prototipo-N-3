local Concord = require("concord")
local Collisions = require("src.utils.Collisions")


local CollisionSystem = Concord.system({

    projectiles = {"projectile", "position", "drawable"},
    enemies     = {"enemy", "position", "drawable", "health"},
    player      = {"player", "position", "drawable", "health"},
    collectibles= {"collectible", "position", "drawable"},
    doors       = {"door", "position", "drawable"}

})


function CollisionSystem:init(eventManager)

    self.eventManager = eventManager

end


function CollisionSystem:update(dt)

    local playerEntity = self.player[1]
    if not playerEntity then return end

    local pPos = playerEntity.position
    local pDraw = playerEntity.drawable
    local pBox = { x = pPos.x + 10, y = pPos.y + 10, w = 70, h = 70 }

    for _, proj in ipairs(self.projectiles) do

        local prPos = proj.position
        local prDraw = proj.drawable
        local prBox = { x = prPos.x + 10, y = prPos.y + 10, w = 30, h = 30 }

        if Collisions.checkMapCollision(prBox) then
            proj:destroy()
        else

            local owner = proj.projectile.owner

            if owner == "player" then

                for _, enemy in ipairs(self.enemies) do

                    local ePos = enemy.position
                    local eDraw = enemy.drawable
                    local eBox = { x = ePos.x + 10, y = ePos.y + 10, w = 70, h = 70 }

                    if Collisions.checkAABB(prBox, eBox) then

                        local dmg = playerEntity.damage and playerEntity.damage.amount or 12
                        enemy.health.hp = enemy.health.hp - dmg
                        if self.eventManager then self.eventManager:emit("enemy_damaged") end
                        proj:destroy()

                        if enemy.health.hp <= 0 then

                            if self.eventManager then self.eventManager:emit("enemy_died", enemy) end

                        end
                        break

                    end

                end
            elseif owner == "enemy" then
                if Collisions.checkAABB(prBox, pBox) then
                    proj:destroy()

                    if not playerEntity:has("shielded") then
                        local eDmg = proj.damage and proj.damage.amount or 10
                        playerEntity.health.hp = math.max(0, playerEntity.health.hp - eDmg)
                        if self.eventManager then self.eventManager:emit("player_damaged") end

                        if playerEntity.health.hp <= 0 then

                            if self.eventManager then self.eventManager:emit("player_died") end

                        end

                    end

                end

            end

        end

    end


    for _, col in ipairs(self.collectibles) do

        local cPos = col.position
        local cDraw = col.drawable
        local cBox = { x = cPos.x + 10, y = cPos.y + 10, w = 55, h = 55 }

        if Collisions.checkAABB(pBox, cBox) then

            local itemType = col.collectible.itemType
            if self.eventManager then self.eventManager:emit("collectible_picked", itemType) end
            
            if itemType == "coin" then
                if self.eventManager then self.eventManager:emit("add_gold", 1) end
            elseif itemType == "heart" then
                playerEntity.health.hp = math.min(playerEntity.health.maxHp, playerEntity.health.hp + 10)
            elseif itemType == "shield" then
                playerEntity:give("shielded", 5)
            elseif itemType == "skull" then
                if not playerEntity:has("shielded") then

                    playerEntity.health.hp = math.max(0, playerEntity.health.hp - 25)
                    if self.eventManager then self.eventManager:emit("player_damaged") end
                    if playerEntity.health.hp <= 0 then
                        if self.eventManager then self.eventManager:emit("player_died") end

                    end

                end

            end

            col:destroy()

        end

    end


    for _, door in ipairs(self.doors) do

        local dPos = door.position
        local dDraw = door.drawable
        local dBox = { x = dPos.x + 20, y = dPos.y + 20, w = dDraw.w - 40, h = dDraw.h - 40 }

        if Collisions.checkAABB(pBox, dBox) then

            if self.eventManager then self.eventManager:emit("game_won") end

        end

    end

end


return CollisionSystem
