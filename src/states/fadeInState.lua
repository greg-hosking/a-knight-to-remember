function newFadeInState(color, duration, callback)
    local fadeInState = {}
    fadeInState.r = color.r
    fadeInState.g = color.g
    fadeInState.b = color.b
    fadeInState.a = 0

    fadeInState.volume = 1

    fadeInState.duration = duration
    fadeInState.incrementPerSec = 1 / duration

    fadeInState.callback = callback or function() end

    function fadeInState.update(dt)
        fadeInState.a = fadeInState.a + (fadeInState.incrementPerSec * dt)
        fadeInState.volume = fadeInState.volume - (fadeInState.incrementPerSec * dt)
        love.audio.setVolume(fadeInState.volume)

        if fadeInState.a >= 1 then
            stateStack.pop()
            fadeInState.callback()
        end
    end

    function fadeInState.draw()
        love.graphics.setColor(fadeInState.r, fadeInState.g, fadeInState.b, fadeInState.a)
        love.graphics.rectangle('fill', 0, 0, W, H)
        love.graphics.setColor(1, 1, 1, 1)
    end

    return fadeInState
end
