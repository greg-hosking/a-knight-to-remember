function newScene2State()
    local scene2State = {}

    scene2State.map = sti('src/maps/knightOutpost.lua')

    -- Setup the callback function triggered when the player approaches the older brother.
    local fadeOutState = newFadeOutState({ r = 1, g = 1, b = 1 }, 1, true)
    local fadeInState = newFadeInState(
        { r = 1, g = 1, b = 1 }, 1, true,
        function()
            sounds.soundtrack.outpost:stop()
            sounds.soundtrack.battle:play()
            stateStack.push(newBattleState())
            stateStack.push(fadeOutState)
        end
    )
    
    local callback = function()
        stateStack.push(newDialogueState(
            'HEY! I HOPE YOU\'RE READY... CAUSE I\'M NOT GOING EASY ON YOU THIS TIME!', 
            portraits['2-6'], sounds.sfx.blips[10],
            function()
                stateStack.push(fadeInState)
            end))
    end
    
    scene2State.map.layers.eventTriggers.objects[1].callback = callback    

    -- Setup the callback function triggered when the player takes path
    -- back toward the village.
    local fadeOutState = newFadeOutState({ r = 0, g = 0, b = 0 }, 1, true)
    local fadeInState = newFadeInState(
        { r = 0, g = 0, b = 0 }, 1, true,
        function()
            sounds.soundtrack.outpost:stop()
            sounds.soundtrack.village:play()
            stateStack.pop()
            stateStack.push(newScene3State())
            stateStack.push(fadeOutState)
        end
    )
    local callback = function() 
        if love.keyboard.isDown('s', 'down') then
            stateStack.push(fadeInState) 
        end
    end
    scene2State.map.layers.eventTriggers.objects[2].callback = callback
        
    -- Spawn in the player.
    local player = newPlayer(scene2State.map, 704, 952)
    player.currentAnimation = player.animations.walk.up
    player.currentAnimation:gotoFrame(2)

    -- Setup NPC animation.
    local spritesheet = love.graphics.newImage('assets/images/spritesheets/combat_anims2.png')
    local grid = anim8.newGrid(144, 144, spritesheet:getWidth(), spritesheet:getHeight())
    
    local npc = {}
    npc.x = 928
    npc.y = 200
    npc.animation = anim8.newAnimation(grid(4, 2, 4, 2, 4, 2, 5, 2, 6, 2), 0.2)
    
    function scene2State.update(dt)
        player.update(dt)
        -- Animate the older brother swinging a sword.
        npc.animation:update(dt)
    end

    function scene2State.draw()
        love.graphics.setColor(1, 1, 1)
        scene2State.map:draw(0, 0, 4, 4)
        player.draw()
        npc.animation:draw(spritesheet, npc.x, npc.y, 0, 1.4, 1.4)
    end

    return scene2State 
end
