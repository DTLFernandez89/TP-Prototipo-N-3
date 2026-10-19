-- src/managers/EventManager.lua
-- Canal de comunicación desacoplado para eventos del juego

local EventManager = {}
EventManager.__index = EventManager

function EventManager.new()
    local self = setmetatable({}, EventManager)
    self.listeners = {}
    return self
end

function EventManager:on(eventName, callback)
    if not self.listeners[eventName] then
        self.listeners[eventName] = {}
    end
    table.insert(self.listeners[eventName], callback)
end

function EventManager:emit(eventName, ...)
    if self.listeners[eventName] then
        for _, callback in ipairs(self.listeners[eventName]) do
            callback(...)
        end
    end
end

function EventManager:clear()
    self.listeners = {}
end

return EventManager