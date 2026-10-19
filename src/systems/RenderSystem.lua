local Concord = require("concord")


local RenderSystem = Concord.system({

    drawables = {"position", "drawable"}

})


function RenderSystem:init(assets)

    self.assets = assets or {}
    self.currentScenario = "scenario01"
    
end

function RenderSystem:setScenario(scenarioKey)

    self.currentScenario = scenarioKey

end


function RenderSystem:draw()

    love.graphics.setColor(1, 1, 1, 1)

    if self.assets[self.currentScenario] then

        love.graphics.draw(self.assets[self.currentScenario], 0, 0)

    end

    for _, e in ipairs(self.drawables) do

        local pos = e.position
        local draw = e.drawable
        local img = self.assets[draw.imageKey]

        if img then

            if e:has("shielded") then
                love.graphics.setColor(0.3, 0.7, 1.0, 0.8)
            else
                love.graphics.setColor(1, 1, 1, 1)
            end

            love.graphics.draw(img, pos.x, pos.y)

        end

    end

    love.graphics.setColor(1, 1, 1, 1)

end


return RenderSystem
