function newTitleScreenState()
    local titleScreenState = {}

    titleScreenState.backgroundImage = love.graphics.newImage('assets/images/backgrounds/title.png')

    titleScreenState.title = {}
    titleScreenState.title.text = 'A KNIGHT TO REMEMBER act i'
    titleScreenState.title.font = fonts.serif.xl.font
    titleScreenState.title.x = W * 0.05
    titleScreenState.title.y = H * 0.2

    titleScreenState.selectBox = {}
    titleScreenState.selectBox.w = W * 0.25
    titleScreenState.selectBox.h = H * 0.225
    titleScreenState.selectBox.x = W * 0.05
    titleScreenState.selectBox.y = H * 0.7
    titleScreenState.selectBox.font = fonts.serif.md.font

    titleScreenState.selectBox.option1 = {}
    titleScreenState.selectBox.option1.text = 'NEW GAME'
    titleScreenState.selectBox.option1.x = titleScreenState.selectBox.x + (W * 0.075)
    titleScreenState.selectBox.option1.y = titleScreenState.selectBox.y + (H * 0.05)
    titleScreenState.selectBox.option2 = {}
    titleScreenState.selectBox.option2.text = 'CREDITS'
    titleScreenState.selectBox.option2.x = titleScreenState.selectBox.x + (W * 0.075)
    titleScreenState.selectBox.option2.y = titleScreenState.selectBox.option1.y + (H * 0.075)

    titleScreenState.selectBox.selected = 1
    titleScreenState.selectBox.cursor = {}
    titleScreenState.selectBox.cursor.image = love.graphics.newImage('assets/images/icon081.png')
    titleScreenState.selectBox.cursor.sx = 4
    titleScreenState.selectBox.cursor.sy = 4
    titleScreenState.selectBox.cursor.w = titleScreenState.selectBox.cursor.image:getWidth() * titleScreenState.selectBox.cursor.sx
    titleScreenState.selectBox.cursor.h = titleScreenState.selectBox.cursor.image:getHeight() * titleScreenState.selectBox.cursor.sy
    titleScreenState.selectBox.cursor.x = titleScreenState.selectBox.x + (W * 0.025)
    titleScreenState.selectBox.cursor.y = titleScreenState.selectBox.option1.y - (titleScreenState.selectBox.cursor.h * 0.25)

    sounds.soundtrack.title:setLooping(true)
    sounds.soundtrack.title:play()

    function titleScreenState.update(dt)
        if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
            sounds.sfx.cursor:stop()
            sounds.sfx.cursor:play()

            if titleScreenState.selectBox.selected == 1 then
                titleScreenState.selectBox.selected = 2
                titleScreenState.selectBox.cursor.y = titleScreenState.selectBox.option2.y - 
                                                      (titleScreenState.selectBox.cursor.h * 0.25)
            else
                titleScreenState.selectBox.selected = 1
                titleScreenState.selectBox.cursor.y = titleScreenState.selectBox.option1.y - 
                                                      (titleScreenState.selectBox.cursor.h * 0.25)
            end
        elseif love.keyboard.wasPressed('return') then
            sounds.sfx.select:play()

            if titleScreenState.selectBox.selected == 1 then
                local fadeOutState = newFadeOutState(
                    { r = 0, g = 0, b = 0 }, 2.5, true,
                    function()
                        stateStack.push(newDialogueState(
                            'THEY TRAIN RIGOROUSLY EVERY DAY... WITH THE INTENT TO SOMEDAY LEAVE THE FARM AND ' .. 
                            'BECOME KNIGHTS IN THE KING\'S ROYAL ARMY... JUST AS THEIR FATHER HAD ONCE BEEN....', 
                            portraits['4-5'], sounds.sfx.blips[20]))
                        stateStack.push(newDialogueState(
                            'THIS VILLAGE IS WHERE THE LEGEND BEGINS... OF TWO BROTHERS WHO TIRE OF THE FARM LIFE ' .. 
                            'AND SEEK TO FOLLOW IN THEIR FATHER\'S FOOTSTEPS.', 
                            portraits['4-5'], sounds.sfx.blips[20]))
                        stateStack.push(newDialogueState(
                            'IN THE OUTER REACHES OF THE KINGDOM OF XAELORA... '  .. 
                            'THERE IS A SMALL FARMING VILLAGE KNOWN AS ASTEVARIA....', 
                            portraits['4-5'], sounds.sfx.blips[20]))
                    end)
                local fadeInState = newFadeInState(
                    { r = 0, g = 0, b = 0}, 5, true, 
                    function()
                        sounds.soundtrack.title:stop()
                        love.graphics.setBackgroundColor(0, 0, 0)
                        stateStack.push(fadeOutState)
                    end)
                stateStack.push(fadeInState)                
            else
                local fadeOutState = newFadeOutState({ r = 0, g = 0, b = 0 }, 2.5, true)
                local fadeInState = newFadeInState(
                    { r = 0, g = 0, b = 0}, 2.5, true, 
                    function()
                        sounds.soundtrack.title:stop()
                        stateStack.push(newCreditsScreenState())
                        stateStack.push(fadeOutState)
                    end)
                stateStack.push(fadeInState)
            end
        end
    end

    function titleScreenState.draw()
        love.graphics.draw(titleScreenState.backgroundImage, 0, 0, 0,
                           W / titleScreenState.backgroundImage:getWidth(), H / titleScreenState.backgroundImage:getHeight())

        love.graphics.print(titleScreenState.selectBox.selected)

        -- Print the title text with a black outline.
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(titleScreenState.title.font)
        love.graphics.print(titleScreenState.title.text, 
                            titleScreenState.title.x - 3, titleScreenState.title.y)
        love.graphics.print(titleScreenState.title.text,
                            titleScreenState.title.x + 3, titleScreenState.title.y)
        love.graphics.print(titleScreenState.title.text,
                            titleScreenState.title.x, titleScreenState.title.y - 3)
        love.graphics.print(titleScreenState.title.text,
                            titleScreenState.title.x, titleScreenState.title.y + 3)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(titleScreenState.title.text,
                            titleScreenState.title.x, titleScreenState.title.y) 

        -- Draw select box with a black and white border.
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle('fill', titleScreenState.selectBox.x, titleScreenState.selectBox.y,
                                        titleScreenState.selectBox.w, titleScreenState.selectBox.h)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(4)
        love.graphics.rectangle('line', titleScreenState.selectBox.x, titleScreenState.selectBox.y,
                                        titleScreenState.selectBox.w, titleScreenState.selectBox.h)
        love.graphics.setColor(0, 0, 0)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle('line', titleScreenState.selectBox.x - 3, titleScreenState.selectBox.y - 3,
                                        titleScreenState.selectBox.w + 6, titleScreenState.selectBox.h + 6)

        love.graphics.setColor(1, 1, 1)

        -- Print the text for each option with a black outline.
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(titleScreenState.selectBox.font)
        love.graphics.print(titleScreenState.selectBox.option1.text, 
                            titleScreenState.selectBox.option1.x - 2, titleScreenState.selectBox.option1.y)
        love.graphics.print(titleScreenState.selectBox.option1.text,
                            titleScreenState.selectBox.option1.x + 2, titleScreenState.selectBox.option1.y)
        love.graphics.print(titleScreenState.selectBox.option1.text,
                            titleScreenState.selectBox.option1.x, titleScreenState.selectBox.option1.y - 2)
        love.graphics.print(titleScreenState.selectBox.option1.text,
                            titleScreenState.selectBox.option1.x, titleScreenState.selectBox.option1.y + 2)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(titleScreenState.selectBox.option1.text,
                            titleScreenState.selectBox.option1.x, titleScreenState.selectBox.option1.y) 

        love.graphics.setColor(0, 0, 0)
        love.graphics.print(titleScreenState.selectBox.option2.text, 
                            titleScreenState.selectBox.option2.x - 2, titleScreenState.selectBox.option2.y)
        love.graphics.print(titleScreenState.selectBox.option2.text,
                            titleScreenState.selectBox.option2.x + 2, titleScreenState.selectBox.option2.y)
        love.graphics.print(titleScreenState.selectBox.option2.text,
                            titleScreenState.selectBox.option2.x, titleScreenState.selectBox.option2.y - 2)
        love.graphics.print(titleScreenState.selectBox.option2.text,
                            titleScreenState.selectBox.option2.x, titleScreenState.selectBox.option2.y + 2)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(titleScreenState.selectBox.option2.text,
                            titleScreenState.selectBox.option2.x, titleScreenState.selectBox.option2.y) 

        -- Draw the cursor next to the selected option.
        love.graphics.draw(titleScreenState.selectBox.cursor.image,
                           titleScreenState.selectBox.cursor.x, titleScreenState.selectBox.cursor.y, 0, 
                           titleScreenState.selectBox.cursor.sx, titleScreenState.selectBox.cursor.sy)
    end

    return titleScreenState
end