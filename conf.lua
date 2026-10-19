function love.conf(t)
    
    t.identity = " PROTOTIPO N°3 "       --- Nombre de la carpeta de guardado ---

    -- Configuracion de la Ventana
    t.window.title = "PROTOTIPO 3"
    t.window.icon = nil
    t.window.width = 1280
    t.window.height = 720
    t.window.borderless = false
    t.window.resizable = false
    t.window.minwidth = 1280
    t.window.minheight = 720
    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    t.window.vsync = 0                  --- Desactivar VSync para control preciso de FPS por delta ---
    t.window.msaa = 0

    --- Módulos requeridos de LÖVE ---
    t.modules.audio = true
    t.modules.event = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.keyboard = true
    t.modules.mouse = true
    t.modules.sound = true
    t.modules.timer = true
    t.modules.window = true
    t.modules.system = true

end
