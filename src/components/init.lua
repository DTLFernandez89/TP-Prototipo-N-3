local Concord = require("concord")

Concord.component("position", function(c, x, y)

    c.x = x or 0
    c.y = y or 0

end)

Concord.component("velocity", function(c, vx, vy)

    c.vx = vx or 0
    c.vy = vy or 0

end)


Concord.component("drawable", function(c, imageKey, width, height)

    c.imageKey = imageKey
    c.w = width or 32
    c.h = height or 32

end)


Concord.component("health", function(c, hp)

    c.hp = hp or 100
    c.maxHp = hp or 100

end)

Concord.component("damage", function(c, amount)

    c.amount = amount or 10

end)


Concord.component("player")


Concord.component("enemy", function(c, enemyType, points, attackDamage)

    c.enemyType = enemyType or "enemi01"
    c.points = points or 5
    c.damage = attackDamage or 10
    c.shootTimer = 0
    c.shootInterval = 2.0

end)

Concord.component("boss", function(c)

    c.shootTimer = 0
    c.shootInterval = 2.0 

end)

Concord.component("projectile", function(c, owner, dirX, dirY, speed)

    c.owner = owner         
    c.dirX = dirX or 0
    c.dirY = dirY or 0
    c.speed = speed or 400

end)


Concord.component("door")



Concord.component("collectible", function(c, itemType, lifetime)

    c.itemType = itemType    
    c.timer = lifetime or 5  

end)

Concord.component("shielded", function(c, duration)

    c.timer = duration or 5 

end)


return true
