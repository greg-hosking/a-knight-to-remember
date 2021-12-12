function newSplashScreenState()
    local splashScreenState = {}

    -- Calculate the scale, dimensions, and position of the splash screen icon.
    splashScreenState.icon = {}
    splashScreenState.icon.image = love.graphics.newImage('assets/images/splash_screen_icon.png')
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
    splashScreenState.textArea.text = 'Red Sky\nStudios'
    splashScreenState.textArea.fontSize = 96
    splashScreenState.textArea.font = love.graphics.setNewFont('assets/fonts/font.ttf',
                                                               splashScreenState.textArea.fontSize)
    splashScreenState.textArea.font:setLineHeight(1.5)
    splashScreenState.textArea.maxX = W * 1.05
    splashScreenState.textArea.minX = (W * 0.5)
    splashScreenState.textArea.x = splashScreenState.textArea.maxX
    splashScreenState.textArea.y = (H * 0.5) - (splashScreenState.textArea.fontSize * 1.5)
    splashScreenState.textArea.dx = (splashScreenState.textArea.minX - splashScreenState.textArea.x) / 1

    splashScreenState.thunder = love.audio.newSource('thunder.mp3', 'static')
    splashScreenState.thunder:setPitch(1.25) 
    splashScreenState.thunder:play()

    function splashScreenState.update(dt)

        if splashScreenState.thunder:isPlaying() then
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
                stateStack.push(
                    newFadeInState(
                        { r = 1, g = 1, b = 1 }, 2.5,
                        function()
                            stateStack.push(
                                newFadeOutState(
                                    { r = 1, g = 1, b = 1 }, 2.5,
                                    function()
                                        stateStack.push(newGameTestState())
                                        stateStack.push(newDialogueState('THIS IS AN EXAMPLE OF A DIALOGUE BOX. PRESS RETURN TO CONTINUE. WHILE YOU DO THAT, I AM GOING TO MAKE A MIDNIGHT SNACK... BE RIGHT BACK!', portraits['1-1'], bleep))
                                    end
                                )
                            )
                        end
                    )
                )        
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
