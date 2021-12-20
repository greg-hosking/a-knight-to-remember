function newCreditsScreenState()
    local creditsScreenState = {}

    creditsScreenState.backgroundImage = love.graphics.newImage('assets/images/backgrounds/credits.png')

    creditsScreenState.backgroundBox = {}
    creditsScreenState.backgroundBox.w = W * 0.45
    creditsScreenState.backgroundBox.h = H * 1.95
    creditsScreenState.backgroundBox.x = (W * 0.5) - (creditsScreenState.backgroundBox.w * 0.5)
    creditsScreenState.backgroundBox.maxY = H * 1.05
    creditsScreenState.backgroundBox.y = creditsScreenState.backgroundBox.maxY
    creditsScreenState.backgroundBox.dy = 150

    -- Calculate text positions.
    creditsScreenState.textArea = {}

    creditsScreenState.textArea.title = {}
    creditsScreenState.textArea.title.text = 'A KNIGHT TO REMEMBER'
    creditsScreenState.textArea.title.font = fonts.serif.lg.font
    creditsScreenState.textArea.title.maxY = creditsScreenState.backgroundBox.maxY + (H * 0.125)
    creditsScreenState.textArea.title.y = creditsScreenState.textArea.title.maxY
    
    creditsScreenState.textArea.body = {}
    creditsScreenState.textArea.body.text = '' ..
                                            'DESIGNED BY'      .. '\n' .. 'GREG HOSKING'   .. '\n\n' ..
                                            'PROGRAMMED BY'    .. '\n' .. 'GREG HOSKING'   .. '\n\n' ..
                                            'PRODUCED BY'      .. '\n' .. 'GREG HOSKING'   .. '\n\n' ..
                                            'GRAPHICS BY'      .. '\n' .. 'FINALBOSSBLUES' .. '\n\n' ..
                                            'SOUNDTRACK BY'    .. '\n' .. 'YOUFULCA'       .. '\n\n' ..
                                            'INTERFACE SFX BY' .. '\n' .. 'YOUFULCA'       .. '\n\n' .. 
                                            'COMBAT SFX BY'    .. '\n' .. 'YOUFULCA'       .. '\n\n' .. 
                                            'DIALOGUE SFX BY'  .. '\n' .. 'DMOCHAS'
    creditsScreenState.textArea.body.font = fonts.serif.md.font
    creditsScreenState.textArea.body.maxY = creditsScreenState.textArea.title.maxY + (H * 0.175)
    creditsScreenState.textArea.body.y = creditsScreenState.textArea.body.maxY
    
    creditsScreenState.textArea.footer = {}
    creditsScreenState.textArea.footer.text = 'RED SKY STUDIOS 2021'
    creditsScreenState.textArea.footer.font = fonts.pixel.md.font
    creditsScreenState.textArea.footer.maxY = creditsScreenState.textArea.body.maxY + (H * 1.55)
    creditsScreenState.textArea.footer.y = creditsScreenState.textArea.footer.maxY
 
    creditsScreenState.textArea.dy = creditsScreenState.backgroundBox.dy

    -- Play the credits screen soundtrack.
    sounds.soundtrack.credits:setPitch(0.75)
    sounds.soundtrack.credits:play()

    local function exitCreditsScreenState()
        local fadeOutState = newFadeOutState({ r = 0, g = 0, b = 0}, 1, true)
        local fadeInState = newFadeInState(
            { r = 0, g = 0, b = 0}, 1, true,
            function()
                sounds.soundtrack.credits:stop()
                stateStack.push(newTitleScreenState())
                stateStack.push(fadeOutState)
            end)
        stateStack.push(fadeInState)
    end

    function creditsScreenState.update(dt)
        if sounds.soundtrack.credits:isPlaying() then
            if love.keyboard.wasPressed('return') then
                exitCreditsScreenState()
            end

            -- Scroll the text from the bottom to the top of the screen.
            creditsScreenState.backgroundBox.y = creditsScreenState.backgroundBox.y - 
                                                 (creditsScreenState.backgroundBox.dy * dt)
            creditsScreenState.textArea.title.y = creditsScreenState.textArea.title.y - 
                                                  (creditsScreenState.textArea.dy * dt)
            creditsScreenState.textArea.body.y = creditsScreenState.textArea.body.y - 
                                                 (creditsScreenState.textArea.dy * dt)
            creditsScreenState.textArea.footer.y = creditsScreenState.textArea.footer.y - 
                                                   (creditsScreenState.textArea.dy * dt) 
        else
            -- Once the soundtrack has stopped playing, send the user back to the title screen.
            exitCreditsScreenState()
        end
    end

        
    function creditsScreenState.draw()
        love.graphics.draw(creditsScreenState.backgroundImage, 0, 0, 0,
                           W / creditsScreenState.backgroundImage:getWidth(), H / creditsScreenState.backgroundImage:getHeight())

        -- Draw background box with a black and white border.
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle('fill', creditsScreenState.backgroundBox.x, creditsScreenState.backgroundBox.y,
                                        creditsScreenState.backgroundBox.w, creditsScreenState.backgroundBox.h)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(4)
        love.graphics.rectangle('line', creditsScreenState.backgroundBox.x, creditsScreenState.backgroundBox.y,
                                        creditsScreenState.backgroundBox.w, creditsScreenState.backgroundBox.h)
        love.graphics.setColor(0, 0, 0)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle('line', creditsScreenState.backgroundBox.x - 3, creditsScreenState.backgroundBox.y - 3,
                                        creditsScreenState.backgroundBox.w + 6, creditsScreenState.backgroundBox.h + 6)

        -- Print the title text with a black outline.
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(creditsScreenState.textArea.title.font)
        love.graphics.printf(creditsScreenState.textArea.title.text, 
                             -3, creditsScreenState.textArea.title.y, W, 'center')
        love.graphics.printf(creditsScreenState.textArea.title.text,
                             3, creditsScreenState.textArea.title.y, W, 'center')
        love.graphics.printf(creditsScreenState.textArea.title.text,
                             0, creditsScreenState.textArea.title.y - 3, W, 'center')
        love.graphics.printf(creditsScreenState.textArea.title.text,
                             0, creditsScreenState.textArea.title.y + 3, W, 'center')
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(creditsScreenState.textArea.title.text,
                             0, creditsScreenState.textArea.title.y, W, 'center')

        -- Print the body text with a black outline.
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(creditsScreenState.textArea.body.font)
        love.graphics.printf(creditsScreenState.textArea.body.text, 
                             -3, creditsScreenState.textArea.body.y, W, 'center')
        love.graphics.printf(creditsScreenState.textArea.body.text,
                             3, creditsScreenState.textArea.body.y, W, 'center')
        love.graphics.printf(creditsScreenState.textArea.body.text,
                             0, creditsScreenState.textArea.body.y - 3, W, 'center')
        love.graphics.printf(creditsScreenState.textArea.body.text,
                             0, creditsScreenState.textArea.body.y + 3, W, 'center')
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(creditsScreenState.textArea.body.text,
                             0, creditsScreenState.textArea.body.y, W, 'center')
        
        -- Print the footer text with a dark gray outline.
        love.graphics.setColor(49/255, 61/255, 69/255)
        love.graphics.setFont(creditsScreenState.textArea.footer.font)
        love.graphics.printf(creditsScreenState.textArea.footer.text, 
                             -3, creditsScreenState.textArea.footer.y, W, 'center')
        love.graphics.printf(creditsScreenState.textArea.footer.text,
                             3, creditsScreenState.textArea.footer.y, W, 'center')
        love.graphics.printf(creditsScreenState.textArea.footer.text,
                             0, creditsScreenState.textArea.footer.y - 3, W, 'center')
        love.graphics.printf(creditsScreenState.textArea.footer.text,
                             0, creditsScreenState.textArea.footer.y + 3, W, 'center')
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(creditsScreenState.textArea.footer.text,
                             0, creditsScreenState.textArea.footer.y, W, 'center')    
    end

    return creditsScreenState
end