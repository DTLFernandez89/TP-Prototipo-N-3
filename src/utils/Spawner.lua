local Concord = require("concord")
local Collisions = require("src.utils.Collisions")


local Spawner = {}


function Spawner.spawnPlayer(world)

    local e = Concord.entity(world)

        :give("player")
        :give("position", 1280 / 2 - 45, 720 / 2 - 45)
        :give("velocity", 0, 0)
        :give("health", 100, 150)
        :give("damage", 22)
        :give("drawable", "player", 90, 90)

    return e

end


function Spawner.spawnRandomEnemy(world)

    local enemyTypes = {

        { key = "enemi01", hp = 5,  dmg = 4,  pts = 2  },
        { key = "enemi02", hp = 10, dmg = 8,  pts = 4  },
        { key = "enemi03", hp = 15, dmg = 12, pts = 6  },
        { key = "enemi04", hp = 20, dmg = 16, pts = 8  },
        { key = "enemi05", hp = 25, dmg = 20, pts = 10 }

    }
    local selected = enemyTypes[math.random(1, #enemyTypes)]


    local spawnPoints = {

        { x = 100, y = 100 },
        { x = 1100, y = 100 },
        { x = 100, y = 550 },
        { x = 1100, y = 550 }

    }
    local sp = spawnPoints[math.random(1, #spawnPoints)]


    local e = Concord.entity(world)

        :give("enemy", selected.hp, selected.dmg, selected.pts, 3.0)
        :give("position", sp.x, sp.y)
        :give("velocity", 0, 0)
        :give("health", selected.hp, selected.hp)
        :give("drawable", selected.key, 90, 90)

    return e

end


function Spawner.spawnBoss(world)

    local e = Concord.entity(world)

        :give("enemy", 50, 25, 100, 4.0)
        :give("boss")
        :give("position", 1280 / 2 - 90, 100)
        :give("velocity", 0, 0)
        :give("health", 150, 150)
        :give("drawable", "enemie_boss", 180, 180)

    return e

end


function Spawner.spawnProjectile(world, x, y, dirX, dirY, owner, speed)

    local vx = dirX * speed
    local vy = dirY * speed
    local e = Concord.entity(world)

        :give("projectile", owner)
        :give("position", x, y)
        :give("velocity", vx, vy)
        :give("damage", 10)
        :give("drawable", "proyectile", 50, 50)

    return e

end


function Spawner.spawnCollectible(world, itemType, x, y)

    local e = Concord.entity(world)

        :give("collectible", itemType, 5.0)
        :give("position", x, y)
        :give("drawable", itemType, 75, 75)

    return e

end


function Spawner.spawnDoor(world)

    local e = Concord.entity(world)

        :give("door")
        :give("position", 1280 / 2 - 50, 720 / 2 - 75)
        :give("drawable", "door", 100, 150)

    return e

end


return Spawner
