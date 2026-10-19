local Collisions = {}

Collisions.mapWalls = {

    { x = 0,    y = 0,   w = 590, h = 40 },
    { x = 690,  y = 0,   w = 590, h = 40 },

    { x = 0,    y = 680, w = 590, h = 40 },
    { x = 690,  y = 680, w = 590, h = 40 },

    { x = 0,    y = 0,   w = 40,  h = 310 },
    { x = 0,    y = 410, w = 40,  h = 310 },

    { x = 1240, y = 0,   w = 40,  h = 310 },
    { x = 1240, y = 410, w = 40,  h = 310 }

}


Collisions.spawnPoints = {

    { x = 640,  y = 10 },  -- Norte
    { x = 640,  y = 690 }, -- Sur
    { x = 10,   y = 360 }, -- Oeste
    { x = 1250, y = 360 }  -- Este

}


function Collisions.checkAABB(a, b)

    return a.x < b.x + b.w and
           a.x + a.w > b.x and
           a.y < b.y + b.h and
           a.y + a.h > b.y

end


function Collisions.checkMapCollision(box)

    for _, wall in ipairs(Collisions.mapWalls) do

        if Collisions.checkAABB(box, wall) then
            return true
        end

    end
    return false

end


return Collisions
