function love.load()
    W, H = love.graphics.getDimensions()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    require('src/dependencies')

    -- stateStack.push(newSplashScreenState())
    -- stateStack.push(newFadeOutState({r=0, g=0, b=0}, 2.5, false))

    -- stateStack.push(newScene1State())
    stateStack.push(newBattleState())

    -- stateStack.push(newTitleScreenState())

    love.keyboard.keysPressed = {}
end

function love.update(dt)
    stateStack.update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    stateStack.draw()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'r' then
        love.event.quit('restart')
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end
