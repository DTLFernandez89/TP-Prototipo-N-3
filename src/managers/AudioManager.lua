local AudioManager = {}
AudioManager.__index = AudioManager

function AudioManager.new(eventManager)

    local self = setmetatable({}, AudioManager)
    self.eventManager = eventManager

    local function loadAudio(path, audioType)

        if love.filesystem.getInfo(path) then
            return love.audio.newSource(path, audioType)
        else

            local lowerPath = path:gsub("^Archives/", "archives/")
            if love.filesystem.getInfo(lowerPath) then

                return love.audio.newSource(lowerPath, audioType)
            else

                print("[WARNING] No se encontro el archivo de audio: " .. path)
                return nil

            end

        end

    end

    --- Carga de efectos de sonido ---
    self.sfx = {

        damage_player   = love.audio.newSource("Archives/audio/damage_player.mp3", "static"),
        death_player    = love.audio.newSource("Archives/audio/death_player.mp3", "static"),
        death_enemies1  = love.audio.newSource("Archives/audio/death_enemies01.mp3", "static"),
        death_enemies2  = love.audio.newSource("Archives/audio/death_enemies02.mp3", "static"),
        enemies_damage1 = love.audio.newSource("Archives/audio/enemies_damage01.mp3", "static"),
        enemies_damage2 = love.audio.newSource("Archives/audio/enemies_damage02.mp3", "static"),
        enemies_damage3 = love.audio.newSource("Archives/audio/enemies_damage03.mp3", "static"),
        enemies_damage4 = love.audio.newSource("Archives/audio/enemies_damage04.mp3", "static"),
        yes             = love.audio.newSource("Archives/audio/yes!.mp3", "static")

    }

    --- Carga de temas musicales ---
    self.music = {

        main_menu = love.audio.newSource("Archives/audio/main_menu.mp3", "stream"),
        gameplay1 = love.audio.newSource("Archives/audio/gameplay01.mp3", "stream"),
        gameplay2 = love.audio.newSource("Archives/audio/gameplay02.mp3", "stream"),
        lose      = love.audio.newSource("Archives/audio/lose.mp3", "stream"),
        win       = love.audio.newSource("Archives/audio/win.mp3", "stream")

    }

    self.currentMusic = nil
    self:registerEvents()
    return self

end


function AudioManager:registerEvents()

    if not self.eventManager then return end

    self.eventManager:on("player_damaged", function()
        self:playSFX("damage_player")
    end)

    self.eventManager:on("player_died", function()
        self:playSFX("death_player")
        self:playMusic("lose", false)
    end)

    self.eventManager:on("enemy_damaged", function()
        local idx = math.random(1, 4)
        self:playSFX("enemies_damage" .. idx)
    end)

    self.eventManager:on("enemy_died", function()
        local idx = math.random(1, 2)
        self:playSFX("death_enemies" .. idx)
    end)

    self.eventManager:on("collectible_picked", function()
        self:playSFX("yes")
    end)

    self.eventManager:on("game_won", function()
        self:playMusic("win", false)
    end)

end


function AudioManager:playSFX(name)

    if self.sfx[name] then
        self.sfx[name]:stop()
        self.sfx[name]:play()

    end

end


function AudioManager:playMusic(name, loop)
    if loop == nil then loop = true end

    for _, source in pairs(self.music) do

        if source then
            source:stop()
        end

    end

    if self.music[name] then

        self.currentMusic = self.music[name]
        self.currentMusic:setLooping(loop)
        self.currentMusic:play()

    end

end


function AudioManager:playRandomGameplayMusic()

    local idx = math.random(1, 3)
    self:playMusic("gameplay" .. idx, true)

end


return AudioManager
