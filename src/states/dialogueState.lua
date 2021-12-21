function newDialogueState(text, speakerPortrait, speakerBlip, callback)
    local dialogueState = {}

    -- Calculate dialogue box dimensions and position.
    dialogueState.dialogueBox = {}
    dialogueState.dialogueBox.w = W * 0.9
    dialogueState.dialogueBox.h = H * 0.25
    dialogueState.dialogueBox.x = (W * 0.5) - (dialogueState.dialogueBox.w * 0.5)
    dialogueState.dialogueBox.y = (H * 0.8) - (dialogueState.dialogueBox.h * 0.5)

    -- Calculate speaker portrait scale, dimensions, padding, and position.
    dialogueState.dialogueBox.speakerPortrait = speakerPortrait
    dialogueState.dialogueBox.speakerPortrait.sx = 4
    dialogueState.dialogueBox.speakerPortrait.sy = 4
    local quad = {}
    quad.x, quad.y, quad.w, quad.h = dialogueState.dialogueBox.speakerPortrait.quad:getViewport()
    dialogueState.dialogueBox.speakerPortrait.w = quad.w * dialogueState.dialogueBox.speakerPortrait.sx
    dialogueState.dialogueBox.speakerPortrait.h = quad.h * dialogueState.dialogueBox.speakerPortrait.sy
    dialogueState.dialogueBox.padding = (dialogueState.dialogueBox.h - dialogueState.dialogueBox.speakerPortrait.h) * 0.5
    dialogueState.dialogueBox.speakerPortrait.x = dialogueState.dialogueBox.x + dialogueState.dialogueBox.padding
    dialogueState.dialogueBox.speakerPortrait.y = dialogueState.dialogueBox.y + dialogueState.dialogueBox.padding

    -- Calculate text area position, width, and font size.
    dialogueState.dialogueBox.textArea = {}
    dialogueState.dialogueBox.textArea.fullText = text
    dialogueState.dialogueBox.textArea.currentText = ''
    dialogueState.dialogueBox.textArea.x = dialogueState.dialogueBox.speakerPortrait.x +
                                           dialogueState.dialogueBox.speakerPortrait.w +
                                           dialogueState.dialogueBox.padding
    dialogueState.dialogueBox.textArea.y = dialogueState.dialogueBox.speakerPortrait.y
    dialogueState.dialogueBox.textArea.w = (dialogueState.dialogueBox.x + dialogueState.dialogueBox.w) - 
                                           (dialogueState.dialogueBox.padding + dialogueState.dialogueBox.textArea.x)

    dialogueState.dialogueBox.textArea.font = fonts.serif.md.font

    -- Calculate arrow scale, dimensions, and position.
    dialogueState.dialogueBox.textArea.arrow = {}
    dialogueState.dialogueBox.textArea.arrow.image = love.graphics.newImage('assets/images/arrow.png')
    dialogueState.dialogueBox.textArea.arrow.sx = 5
    dialogueState.dialogueBox.textArea.arrow.sy = 5
    dialogueState.dialogueBox.textArea.arrow.w = dialogueState.dialogueBox.textArea.arrow.image:getWidth() *
                                                 dialogueState.dialogueBox.textArea.arrow.sx
    dialogueState.dialogueBox.textArea.arrow.h = dialogueState.dialogueBox.textArea.arrow.image:getHeight() *
                                                 dialogueState.dialogueBox.textArea.arrow.sy
    dialogueState.dialogueBox.textArea.arrow.x = dialogueState.dialogueBox.textArea.x + 
                                                 dialogueState.dialogueBox.textArea.w -
                                                 dialogueState.dialogueBox.textArea.arrow.w
    dialogueState.dialogueBox.textArea.arrow.maxY = dialogueState.dialogueBox.y + dialogueState.dialogueBox.h -
                                                    dialogueState.dialogueBox.padding - 
                                                    (dialogueState.dialogueBox.textArea.arrow.h * 0.75)
    dialogueState.dialogueBox.textArea.arrow.minY = dialogueState.dialogueBox.textArea.arrow.maxY -
                                                    (dialogueState.dialogueBox.textArea.arrow.h * 0.25)
    dialogueState.dialogueBox.textArea.arrow.y = dialogueState.dialogueBox.textArea.arrow.maxY 
    dialogueState.dialogueBox.textArea.arrow.dy = quad.h
    dialogueState.dialogueBox.textArea.arrow.visible = false
    
    dialogueState.blip = speakerBlip
    dialogueState.callback = callback or function() end

    -- Animate the text.
    local tBtwnChars = 0.05
    local tSincePrevChar = 0
    local index = 1
    function dialogueState.update(dt)
        if dialogueState.dialogueBox.textArea.currentText ~= dialogueState.dialogueBox.textArea.fullText then
            -- Allow the user to press return to skip the dialogue.
            if love.keyboard.wasPressed('return') then
                dialogueState.dialogueBox.textArea.currentText = dialogueState.dialogueBox.textArea.fullText
                return
            end                
            tSincePrevChar = tSincePrevChar + dt
            if (tSincePrevChar >= tBtwnChars) then
                tSincePrevChar = 0
                dialogueState.dialogueBox.textArea.currentText = string.sub(dialogueState.dialogueBox.textArea.fullText,
                                                                            1, index)
                index = index + 1
                dialogueState.blip:play()
            end
        else
            -- Set the arrow to visible and animate it.
            dialogueState.dialogueBox.textArea.arrow.visible = true
            if (dialogueState.dialogueBox.textArea.arrow.y > dialogueState.dialogueBox.textArea.arrow.maxY or
                dialogueState.dialogueBox.textArea.arrow.y < dialogueState.dialogueBox.textArea.arrow.minY) then
                dialogueState.dialogueBox.textArea.arrow.dy = -1 * dialogueState.dialogueBox.textArea.arrow.dy
            end
            dialogueState.dialogueBox.textArea.arrow.y = dialogueState.dialogueBox.textArea.arrow.y +
                                                        (dialogueState.dialogueBox.textArea.arrow.dy * dt)

            -- Allow the user to press return to exit the dialogue once it is finished.
            if love.keyboard.wasPressed('return') then
                stateStack.pop()
                dialogueState.callback()
            end
        end
    end

    function dialogueState.draw()
        -- Draw the outer box with a black and white border.
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle('fill', dialogueState.dialogueBox.x, dialogueState.dialogueBox.y,
                                        dialogueState.dialogueBox.w, dialogueState.dialogueBox.h)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(4)
        love.graphics.rectangle('line', dialogueState.dialogueBox.x, dialogueState.dialogueBox.y,
                                        dialogueState.dialogueBox.w, dialogueState.dialogueBox.h)
        love.graphics.setColor(0, 0, 0)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle('line', dialogueState.dialogueBox.x - 3, dialogueState.dialogueBox.y - 3,
                                        dialogueState.dialogueBox.w + 6, dialogueState.dialogueBox.h + 6)

        -- Draw the speaker portrait with a black and white border.
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(dialogueState.dialogueBox.speakerPortrait.image, dialogueState.dialogueBox.speakerPortrait.quad,
                           dialogueState.dialogueBox.speakerPortrait.x, dialogueState.dialogueBox.speakerPortrait.y, 0,
                           dialogueState.dialogueBox.speakerPortrait.sx, dialogueState.dialogueBox.speakerPortrait.sy)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle('line', 
                                dialogueState.dialogueBox.speakerPortrait.x, dialogueState.dialogueBox.speakerPortrait.y, 
                                dialogueState.dialogueBox.speakerPortrait.w, dialogueState.dialogueBox.speakerPortrait.h)
        love.graphics.setColor(0, 0, 0)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle('line',
                                dialogueState.dialogueBox.speakerPortrait.x - 3, dialogueState.dialogueBox.speakerPortrait.y - 3,
                                dialogueState.dialogueBox.speakerPortrait.w + 6, dialogueState.dialogueBox.speakerPortrait.h + 6)
        
        -- Print the text with a black outline.
        love.graphics.printf(dialogueState.dialogueBox.textArea.currentText,
                             dialogueState.dialogueBox.textArea.x - 3, dialogueState.dialogueBox.textArea.y,
                             dialogueState.dialogueBox.textArea.w, 'left')
        love.graphics.printf(dialogueState.dialogueBox.textArea.currentText,
                             dialogueState.dialogueBox.textArea.x + 3, dialogueState.dialogueBox.textArea.y,
                             dialogueState.dialogueBox.textArea.w, 'left')
        love.graphics.printf(dialogueState.dialogueBox.textArea.currentText,
                             dialogueState.dialogueBox.textArea.x, dialogueState.dialogueBox.textArea.y - 3,
                             dialogueState.dialogueBox.textArea.w, 'left')
        love.graphics.printf(dialogueState.dialogueBox.textArea.currentText,
                             dialogueState.dialogueBox.textArea.x, dialogueState.dialogueBox.textArea.y + 3,
                             dialogueState.dialogueBox.textArea.w, 'left')
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(dialogueState.dialogueBox.textArea.currentText,
                             dialogueState.dialogueBox.textArea.x, dialogueState.dialogueBox.textArea.y,
                             dialogueState.dialogueBox.textArea.w, 'left')

        -- Draw the arrow in the bottom right of the dialogue box.
        if dialogueState.dialogueBox.textArea.arrow.visible then
            love.graphics.draw(dialogueState.dialogueBox.textArea.arrow.image,
                               dialogueState.dialogueBox.textArea.arrow.x, dialogueState.dialogueBox.textArea.arrow.y,
                               0, dialogueState.dialogueBox.textArea.arrow.sx, dialogueState.dialogueBox.textArea.arrow.sy)
        end
    end

    return dialogueState
end
