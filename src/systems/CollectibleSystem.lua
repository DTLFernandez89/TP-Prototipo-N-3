local Concord = require("concord")
local Spawner = require("src.utils.Spawner")


local CollectibleSystem = Concord.system({

    collectibles = {"collectible", "position", "drawable"}

})


function CollectibleSystem:init(eventManager)

    self.eventManager = eventManager
    self.itemTypes = {"coin", "heart", "shield", "skull"}
    self.cooldownTimer = 15.0
    self.activeInWorld = false

end


function CollectibleSystem:update(dt)

    for _, col in ipairs(self.collectibles) do

        local data = col.collectible
        data.timer = data.timer - dt

        if data.timer <= 0 then

            col:destroy()
            self.activeInWorld = false
            self.cooldownTimer = 15.0

        end

    end

    if #self.collectibles == 0 and self.activeInWorld then

        self.activeInWorld = false
        self.cooldownTimer = 15.0

    end

    if not self.activeInWorld then

        self.cooldownTimer = self.cooldownTimer - dt

        if self.cooldownTimer <= 0 then

            self:spawnRandomCollectible()

        end

    end

end


function CollectibleSystem:spawnRandomCollectible()

    local chosenType = self.itemTypes[math.random(1, #self.itemTypes)]

    local rx = math.random(80, 1280 - 80 - 197)
    local ry = math.random(80, 720 - 80 - 197)

    local w = self:getWorld()
    if w then

        Spawner.spawnCollectible(w, chosenType, rx, ry)
        self.activeInWorld = true

    end

end


return CollectibleSystem
