function newGameTestState()
    local T = {}

    love.audio.play(fieldSoundtrack)

    T.x = W / 2
    T.y = H / 2

    T.w = 100
    T.h = 100

    function T.update(dt)
        if love.keyboard.isDown('w') then
            T.y = T.y - (300 * dt)
        end
        if love.keyboard.isDown('a') then
            T.x = T.x - (300 * dt)
        end
        if love.keyboard.isDown('s') then
            T.y = T.y + (300 * dt)
        end
        if love.keyboard.isDown('d') then
            T.x = T.x + (300 * dt)
        end
    end

    function T.draw()
        love.graphics.setColor(0, 0, 1)
        love.graphics.rectangle('fill', T.x, T.y, T.w, T.h)
    end

    return T
end
