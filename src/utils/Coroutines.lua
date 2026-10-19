local Coroutines = {}


function Coroutines.resume(co, dt)

    if co and coroutine.status(co) ~= "dead" then

        local ok, err = coroutine.resume(co, dt)

        if not ok then

            print("Error en corrutina: ", err)

        end
        return true

    end
    return false

end


return Coroutines
