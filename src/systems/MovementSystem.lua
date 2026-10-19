local Concord = require("concord")
local Collisions = require("src.utils.Collisions")


local MovementSystem = Concord.system({

    movables = {"position", "velocity"},
    projectiles = {"projectile", "position", "velocity"}

})


function MovementSystem:update(dt)


    for _, proj in ipairs(self.projectiles) do

        local pos = proj.position
        local vel = proj.velocity
        pos.x = pos.x + vel.vx * dt
        pos.y = pos.y + vel.vy * dt

    end


    for _, e in ipairs(self.movables) do

        if not e:has("projectile") then
            local pos = e.position
            local vel = e.velocity

            local nextX = pos.x + vel.vx * dt
            local nextY = pos.y + vel.vy * dt

            local minX, maxX = 40, 1280 - 40 - 90
            local minY, maxY = 40, 720 - 40 - 90

            pos.x = math.max(minX, math.min(maxX, nextX))
            pos.y = math.max(minY, math.min(maxY, nextY))

        end

    end

end


return MovementSystem
