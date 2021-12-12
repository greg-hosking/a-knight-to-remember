
function newFadeOutState(color, duration, callback)
    local fadeOutState = {}
    fadeOutState.r = color.r
    fadeOutState.g = color.g
    fadeOutState.b = color.b
    fadeOutState.a = 1

    fadeOutState.duration = duration
    fadeOutState.decrementPerSec = 1 / duration

    fadeOutState.volume = 0

    fadeOutState.callback = callback or function() end

    function fadeOutState.update(dt)
        fadeOutState.a = fadeOutState.a - (fadeOutState.decrementPerSec * dt)
        fadeOutState.volume = fadeOutState.volume + (fadeOutState.decrementPerSec * dt)
        love.audio.setVolume(fadeOutState.volume)

        if fadeOutState.a <= 0 then
            stateStack.pop()
            fadeOutState.callback()
        end
    end

    function fadeOutState.draw()
        love.graphics.setColor(fadeOutState.r, fadeOutState.g, fadeOutState.b, fadeOutState.a)
        love.graphics.rectangle('fill', 0, 0, W, H)
    end

    return fadeOutState
end