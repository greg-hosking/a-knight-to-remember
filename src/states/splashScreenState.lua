function newSplashScreenState()
    local splashScreenState = {}

    -- Calculate the scale, dimensions, and position of the splash screen icon.
    splashScreenState.icon = {}
    splashScreenState.icon.image = love.graphics.newImage('assets/images/icons/cloud.png')
    splashScreenState.icon.sx = 1.25
    splashScreenState.icon.sy = 1.25
    splashScreenState.icon.w = splashScreenState.icon.image:getWidth() * splashScreenState.icon.sx
    splashScreenState.icon.h = splashScreenState.icon.image:getHeight() * splashScreenState.icon.sy
    splashScreenState.icon.maxX = (W * 0.25) - (splashScreenState.icon.w * 0.5)
    splashScreenState.icon.minX = (splashScreenState.icon.w * -1.25)
    splashScreenState.icon.x = splashScreenState.icon.minX  
    splashScreenState.icon.y = (H * 0.5) - (splashScreenState.icon.h * 0.5)
    splashScreenState.icon.dx = splashScreenState.icon.maxX - splashScreenState.icon.x

    -- Calculate text area font size, width, and position.
    splashScreenState.textArea = {}
    splashScreenState.textArea.text = 'Red Sky' .. '\n' .. 'Studios'
    splashScreenState.textArea.font = fonts.pixel.xl.font
    splashScreenState.textArea.font:setLineHeight(1.5)
    splashScreenState.textArea.maxX = W * 1.05
    splashScreenState.textArea.minX = (W * 0.5)
    splashScreenState.textArea.x = splashScreenState.textArea.maxX
    splashScreenState.textArea.y = (H * 0.5) - (96 * 1.5)
    splashScreenState.textArea.dx = (splashScreenState.textArea.minX - splashScreenState.textArea.x) / 1

    -- Create and play splash screen sound effect (rolling thunder).
    splashScreenState.sfx = love.audio.newSource('assets/audio/sfx/splash_screen.mp3', 'static')
    splashScreenState.sfx:setPitch(1.5)
    splashScreenState.sfx:play()

    function splashScreenState.update(dt)
        if splashScreenState.sfx:isPlaying() then
            -- Animate the cloud icons and text sliding into view.
            if (splashScreenState.icon.x < splashScreenState.icon.maxX) then
                splashScreenState.icon.x = splashScreenState.icon.x + (splashScreenState.icon.dx * dt)            
            end
            if (splashScreenState.textArea.x > splashScreenState.textArea.minX) then
                splashScreenState.textArea.x = splashScreenState.textArea.x + (splashScreenState.textArea.dx * dt)
            end
        else
            -- Animate the cloud icons and text sliding out of view.
            if (splashScreenState.icon.x > splashScreenState.icon.minX) then
                splashScreenState.icon.x = splashScreenState.icon.x - (splashScreenState.icon.dx * dt)
            end
            if (splashScreenState.textArea.x < splashScreenState.textArea.maxX) then
                splashScreenState.textArea.x = splashScreenState.textArea.x - (splashScreenState.textArea.dx * dt)
            end
            -- Fade out of the splash screen once the cloud icons and text are out of view.
            if (splashScreenState.icon.x <= splashScreenState.icon.minX and
                splashScreenState.textArea.x >= splashScreenState.textArea.maxX) then
                stateStack.pop()
                -- And fade into the title screen.
                local fadeOutState = newFadeOutState({ r = 0, g = 0, b = 0}, 2.5, true)
                local fadeInState = newFadeInState(
                    { r = 0, g = 0, b = 0}, 2.5, false,
                    function()
                        stateStack.push(newTitleScreenState())
                        stateStack.push(fadeOutState)
                    end)
                stateStack.push(fadeInState)
            end
        end
    end
    
    function splashScreenState.draw()
        -- Set a red background for the splash screen.
        love.graphics.setBackgroundColor(235/255, 64/255, 52/255)

        -- Draw two cloud icons offset from each other.
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(splashScreenState.icon.image, splashScreenState.icon.x - (splashScreenState.icon.w * 0.25), splashScreenState.icon.y - (splashScreenState.icon.h * 0.35),
                           0, splashScreenState.icon.sx, splashScreenState.icon.sy)
        love.graphics.draw(splashScreenState.icon.image, splashScreenState.icon.x + (splashScreenState.icon.w * 0.25), splashScreenState.icon.y + (splashScreenState.icon.h * 0.1),
                           0, splashScreenState.icon.sx, splashScreenState.icon.sy)
        
        -- Print the text with a dark gray outline.
        love.graphics.setFont(splashScreenState.textArea.font)
        love.graphics.setColor(49/255, 61/255, 69/255)
        love.graphics.print(splashScreenState.textArea.text, splashScreenState.textArea.x - 8, splashScreenState.textArea.y)
        love.graphics.print(splashScreenState.textArea.text, splashScreenState.textArea.x + 8, splashScreenState.textArea.y)
        love.graphics.print(splashScreenState.textArea.text, splashScreenState.textArea.x, splashScreenState.textArea.y - 8)
        love.graphics.print(splashScreenState.textArea.text, splashScreenState.textArea.x, splashScreenState.textArea.y + 8)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(splashScreenState.textArea.text, splashScreenState.textArea.x, splashScreenState.textArea.y)
    end

    return splashScreenState
end
