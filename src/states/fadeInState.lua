function newFadeInState(color, duration, doFadeVol, callback)
    local fadeInState = {}
    fadeInState.r = color.r
    fadeInState.g = color.g
    fadeInState.b = color.b
    fadeInState.a = 0

    -- Calculate increment rate for alpha.
    fadeInState.duration = duration
    fadeInState.da = 1 / fadeInState.duration
    -- Calculate decrement rate for volume.
    fadeInState.doFadeVol = doFadeVol
    fadeInState.vol = 1
    fadeInState.dVol =  (-1 / fadeInState.duration)

    fadeInState.callback = callback or function() end

    function fadeInState.update(dt)
        fadeInState.a = fadeInState.a + (fadeInState.da * dt)
        if (fadeInState.doFadeVol) then
            fadeInState.vol = fadeInState.vol + (fadeInState.dVol * dt)
            love.audio.setVolume(fadeInState.vol)
        end

        -- Once the fade in is complete, pop this state off the stack and call the callback.
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
