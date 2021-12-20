function newTitleScreenState()
    local titleScreenState = {}

    titleScreenState.backgroundImage = love.graphics.newImage('assets/images/backgrounds/title.png')

    titleScreenState.title = {}
    titleScreenState.title.text = 'A KNIGHT TO REMEMBER act i'
    titleScreenState.title.font = fonts.serif.xl.font
    titleScreenState.title.x = W * 0.05
    titleScreenState.title.y = H * 0.2

    titleScreenState.selectBox = {}
    titleScreenState.selectBox.w = W * 0.45
    titleScreenState.selectBox.h = H * 0.15
    titleScreenState.selectBox.x = W * 0.05
    titleScreenState.selectBox.y = H * 0.65

    sounds.soundtrack.title:setLooping(true)
    sounds.soundtrack.title:play()

    function titleScreenState.update(dt)
        if love.keyboard.wasPressed('up') then
    
        elseif love.keyboard.wasPressed('down') then
            
        elseif love.keyboard.wasPressed('return') then
            
        end
    end


    function titleScreenState.draw()
        love.graphics.draw(titleScreenState.backgroundImage, 0, 0, 0,
                           W / titleScreenState.backgroundImage:getWidth(), H / titleScreenState.backgroundImage:getHeight())

        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle('fill', titleScreenState.selectBox.x, titleScreenState.selectBox.y,
                                        titleScreenState.selectBox.w, titleScreenState.selectBox.h)

        -- Print the title text with a black outline.
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(titleScreenState.title.font)
        love.graphics.print(titleScreenState.title.text, 
                            titleScreenState.title.x -3, titleScreenState.title.y)
        love.graphics.print(titleScreenState.title.text,
                            titleScreenState.title.x + 3, titleScreenState.title.y)
        love.graphics.print(titleScreenState.title.text,
                            titleScreenState.title.x, titleScreenState.title.y - 3)
        love.graphics.print(titleScreenState.title.text,
                            titleScreenState.title.x, titleScreenState.title.y + 3)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(titleScreenState.title.text,
                            titleScreenState.title.x, titleScreenState.title.y)    

    end


    return titleScreenState
end



-- function newTitleScreenState()
--     local T = {}

--     sounds.soundtrack.title:play()

--     local image = love.graphics.newImage('assets/images/backgrounds/title.png')

--     function T.update(dt)
--         if love.keyboard.wasPressed('c') then
--             stateStack.push(newCreditsScreenState())
--         end
--         if love.keyboard.wasPressed('return') then
--             stateStack.pop()
--             -- love.graphics.setBackgroundColor(0, 0, 0)
--             stateStack.push(
--                 newFadeInState(
--                     { r = 0, g = 0, b = 0 }, 2.5,
--                     function()
--                         stateStack.push(
--                             newFadeOutState(
--                                 { r = 0, g = 0, b = 0 }, 2.5,
--                                 function()
--                                     stateStack.push(newGameTestState())
--                                     stateStack.push(newDialogueState('THIS IS AN EXAMPLE OF A DIALOGUE BOX. PRESS RETURN TO CONTINUE. HERE IS SOME MORE FILLER TEXT TO TEST OUT PRINTING LONGER MESSAGES IN THESE DIALOGUE BOXES. HOW IS IT?', portraits['1-1'], bleep))
--                                 end
--                             )
--                         )
--                     end
--                 )
--             )        
--         end
--     end

--     function T.draw()
--         love.graphics.setColor(1, 1, 1)
--         love.graphics.draw(image, 0, 0, 0, W / image:getWidth(), H / image:getHeight())

--         love.graphics.setFont(fonts.serif.xl.font)
--         love.graphics.printf('A KNIGHT TO REMEMBER', W * 0.05, H * 0.25, W, 'left')

--         love.graphics.setFont(fonts.serif.lg.font)
--         love.graphics.printf('New Game\nLoad Game\nCredits', 0, H * 0.7, W * 0.66, 'center')
--     end

--     return T
-- end