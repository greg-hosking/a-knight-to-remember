function newFadeOutState(color, duration, doFadeVol, callback)
    local fadeOutState = {}
    fadeOutState.r = color.r
    fadeOutState.g = color.g
    fadeOutState.b = color.b
    fadeOutState.a = 1

    -- Calculate decrement rate for alpha.
    fadeOutState.duration = duration
    fadeOutState.da = (-1 / fadeOutState.duration)
    -- Calculate increment rate for volume.
    fadeOutState.doFadeVol = doFadeVol
    fadeOutState.vol = 0
    fadeOutState.dVol = 1 / fadeOutState.duration

    fadeOutState.callback = callback or function() end

    function fadeOutState.update(dt)
        fadeOutState.a = fadeOutState.a + (fadeOutState.da * dt)
        if (fadeOutState.doFadeVol) then
            fadeOutState.vol = fadeOutState.vol + (fadeOutState.dVol * dt)
            love.audio.setVolume(fadeOutState.vol) 
        end

        -- Once the fade is complete, pop this state off the stack and call the callback.
        if fadeOutState.a <= 0 then
            stateStack.pop()
            fadeOutState.callback()
        end
    end

    function fadeOutState.draw()
        love.graphics.setColor(fadeOutState.r, fadeOutState.g, fadeOutState.b, fadeOutState.a)
        love.graphics.rectangle('fill', 0, 0, W, H)
        love.graphics.setColor(1, 1, 1, 1)
    end

    return fadeOutState
end