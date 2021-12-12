function love.load()
    W, H = love.graphics.getDimensions()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    portraits = require('portraits')
    bleep = love.audio.newSource('bleep010.ogg', 'static')

    love.graphics.setBackgroundColor(1, 1, 1)

    stateStack = require('src/states/stateStack')

    require('src/states/fadeInState')
    require('src/states/fadeOutState')
    require('src/states/splashScreenState')

    require('src/states/dialogueState')
    require('gameTestState')

    soundtrack = love.audio.newSource('assets/audio/soundtrack/prologue.mp3', 'static')
    fieldSoundtrack = love.audio.newSource('assets/audio/soundtrack/village.mp3', 'static')

    startSound = love.audio.newSource('assets/audio/sfx/kettei-02.wav', 'static')
    love.graphics.setBackgroundColor(235/255, 64/255, 52/255)


    stateStack.push(newFadeOutState({r=1,g=1,b=1},2.5, function() stateStack.push(newSplashScreenState()) end))
    

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
