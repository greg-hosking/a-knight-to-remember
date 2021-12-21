function newScene3State()
    local scene3State = {}

    scene3State.map = sti('src/maps/astevaria.lua')

    -- Setup the callback function triggered when the player takes path
    -- towards the knight outpost.
    local fadeOutState = newFadeOutState({ r = 0, g = 0, b = 0 }, 1, true)
    local fadeInState = newFadeInState(
        { r = 0, g = 0, b = 0 }, 1, true,
        function()
            sounds.soundtrack.village:stop()
            sounds.soundtrack.outpost:play()
            stateStack.pop()
            stateStack.push(newScene2State())
            stateStack.push(fadeOutState)
        end
    )
    local callback = function() 
        if love.keyboard.isDown('w', 'up') then
            stateStack.push(fadeInState) 
        end
    end
    scene3State.map.layers.eventTriggers.objects[1].callback = callback
        
    -- Spawn in the player.
    local player = newPlayer(scene3State.map, 256, 400)

    function scene3State.update(dt)
        player.update(dt)
    end

    function scene3State.draw()
        love.graphics.setColor(1, 1, 1)
        scene3State.map:draw(0, 0, 4, 4)
        player.draw()
    end

    return scene3State 
end
