local AvisosUI = {}
AvisosUI.__index = AvisosUI


function AvisosUI.new(eventManager)

    local self = setmetatable({}, AvisosUI)
    self.eventManager = eventManager
    self.message = nil
    self.timer = 0
    self:registerEvents()
    return self

end


function AvisosUI:registerEvents()

    if not self.eventManager then return end

    self.eventManager:on("collectible_picked", function(itemType)

        local nombres = {

            coin   = "una moneda (+1 Oro)",
            heart  = "un corazón (+10 HP)",
            shield = "un escudo (Invulnerabilidad 5s)",
            skull  = "una calavera (-25 HP)"

        }

        local articulo = nombres[itemType] or itemType
        self:showMessage("Has recogido " .. articulo, 3.0)

    end)

    self.eventManager:on("show_warning", function(msg, duration)

        self:showMessage(msg, duration or 5.0)

    end)

end


function AvisosUI:showMessage(msg, duration)

    self.message = msg
    self.timer = duration

end


function AvisosUI:update(dt)

    if self.timer > 0 then

        self.timer = self.timer - dt

        if self.timer <= 0 then

            self.message = nil

        end

    end

end


function AvisosUI:draw()

    if self.message then

        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 140, 320, 1000, 70, 10, 10)
        love.graphics.setColor(1, 0.9, 0.2, 1)
        love.graphics.printf(self.message, 0, 342, 1280, "center")
        love.graphics.setColor(1, 1, 1, 1)

    end

end


return AvisosUI
