function newScene1State()
    local scene1State = {}

    scene1State.map = sti('src/maps/astevaria.lua')

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
    scene1State.map.layers.eventTriggers.objects[1].callback = callback
        
    -- Setup the callback for returning to the title screen.
    local fadeOutState = newFadeOutState({ r = 0, g = 0, b = 0 }, 1, true)
    local fadeInState = newFadeInState(
        { r = 0, g = 0, b = 0 }, 1, true,
        function()
            sounds.soundtrack.village:stop()
            sounds.soundtrack.title:play()
            stateStack.pop()
            stateStack.push(newTitleScreenState())
            stateStack.push(fadeOutState)
        end
    )
    local callback = function() 
        if love.keyboard.isDown('w', 'up') then
            stateStack.push(fadeInState) 
        end
    end
    scene1State.map.layers.eventTriggers.objects[2].callback = callback

    -- Spawn in the player.
    local player = newPlayer(scene1State.map, 256, 400)

    -- Setup NPC animation.
    local spritesheet = love.graphics.newImage('assets/images/spritesheets/walk_anims.png')
    local grid = anim8.newGrid(26, 36, spritesheet:getWidth(), spritesheet:getHeight())
    
    local npc = {}
    npc.animations = {}
    npc.animations.walk = {}
    npc.animations.walk.up = anim8.newAnimation(grid(4, 8, 5, 8, 6, 8, 5, 8), 0.2)
    npc.animations.walk.down = anim8.newAnimation(
        grid(5, 5), 0.2, 
        function() 
            npc.currentAnimation = npc.animations.walk.up
        end)
    npc.currentAnimation = npc.animations.walk.down
    npc.x = W * 0.45
    npc.y = H * 0.1

    function scene1State.update(dt)
        player.update(dt)
        
        -- Animate the older brother taking the path towards the knight outpost.
        npc.currentAnimation:update(dt)
        if npc.currentAnimation == npc.animations.walk.up then
            npc.y = npc.y - (64 * dt)
        end
    end

    function scene1State.draw()
        love.graphics.setColor(1, 1, 1)
        scene1State.map:draw(0, 0, 4, 4)
        player.draw()
        npc.currentAnimation:draw(spritesheet, npc.x, npc.y, 0, 4, 4)
    end

    return scene1State 
end
