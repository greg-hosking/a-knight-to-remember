function newScene2State()
    local scene2State = {}

    scene2State.map = sti('src/maps/knightOutpost.lua')

    -- Setup the callback function triggered when the player takes path
    -- back toward the village.
    local fadeOutState = newFadeOutState({ r = 0, g = 0, b = 0 }, 1, true)
    local fadeInState = newFadeInState(
        { r = 0, g = 0, b = 0 }, 1, true,
        function()
            sounds.soundtrack.outpost:stop()
            stateStack.push(newState3State())
            stateStack.push(fadeOutState)
        end
    )
    local callback = function() stateStack.push(fadeInState) end
    scene2State.map.layers.eventTriggers.objects[1].callback = callback
        
    -- Spawn in the player.
    local player = newPlayer(scene2State.map, W * 0.5, H * 0.8)

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

    function scene2State.update(dt)
        player.update(dt)
        
        -- -- Animate the older brother swinging a sword.
        -- npc.currentAnimation:update(dt)
        -- if npc.currentAnimation == npc.animations.walk.up then
        --     npc.y = npc.y - (64 * dt)
        -- end
    end

    function scene2State.draw()
        love.graphics.setColor(1, 1, 1)
        scene2State.map:draw(0, 0, 4, 4)
        player.draw()
        -- npc.currentAnimation:draw(spritesheet, npc.x, npc.y, 0, 4, 4)
    end

    return scene2State 
end
