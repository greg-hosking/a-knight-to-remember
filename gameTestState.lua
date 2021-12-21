function newScene1State()
    local scene1State = {}


    function scene1State.update(dt)

    end


    function scene1State.draw()
    
    end

    return scene1State 
end



function newGameTestState()
    local T = {}


    local sti = require('src/lib/sti')

    require('src/player')

    -- Set world meter size (in pixels)
    love.physics.setMeter(32)

    -- Load a map exported to Lua from Tiled
    map = sti('src/maps/astevaria.lua', {"box2d"})
    local testPlayer = newPlayer(map)

    -- Prepare physics world with horizontal and vertical gravity
    world = love.physics.newWorld(0, 0)

    -- Prepare collision objects
    map:box2d_init(world)

    map:addCustomLayer("playerLayer", 7)

    local playerLayer = map.layers['playerLayer']
    function playerLayer:update(dt)
        testPlayer.update(dt)
    end
    function playerLayer:draw()
        testPlayer.draw()
    end

    -- if map['layers'] then
    --     -- sounds.soundtrack.credits:play()
    --     walls = {}
    --     for i, obj in ipairs(map['layers']['walls']['objects']) do
    --         local wall = {}
    --         wall.body = love.physics.newBody(world, obj['x'], obj.y, 'static')
    --         wall.shape = love.physics.newRectangleShape(obj.width, obj.height)
    --         wall.fixture = love.physics.newFixture(wall.body, wall.shape, 1.0)
    --         table.insert(walls, wall)
    --     end
    -- end

    function T.update(dt)
        -- Update world
        map:update(dt)
        -- world:update(dt)

        -- if love.keyboard.isDown('w') then
        --     -- player.body:setY(player.body:getY() - (300 * dt)) 
        --     player.body:applyForce(0, -500)
        -- end
        -- if love.keyboard.isDown('a') then
        --     -- player.body:setX(player.body:getX() - (300 * dt)) 

        -- end
        -- if love.keyboard.isDown('s') then
        --     -- player.body:setY(player.body:getY() + (300 * dt)) 

        -- end
        -- if love.keyboard.isDown('d') then
        --     -- player.body:setX(player.body:getX() + (300 * dt)) 

        -- end

        testPlayer.update(dt)
    end

    function T.draw()
        -- Draw world
        love.graphics.setColor(1, 1, 1)
        map:draw(0, 0, 4, 4)

        -- love.graphics.setColor(0, 0, 1)
        -- map:box2d_draw(0, 0, 4, 4)

        -- for i = 1, #walls do
        -- -- love.graphics.rectangle('fill', walls[i]:getBody():getPosition(), 100, 100, 100)
        --     love.graphics.polygon("fill", walls[i].body:getWorldPoints(walls[i].shape:getPoints()))
        -- end

        -- -- love.graphics.rectangle('fill',player.x, player.y, 100, 100)
        -- love.graphics.polygon('fill', player.body:getWorldPoints(player.shape:getPoints()))
    
        testPlayer.draw()
    end

    -- function T.update(dt)
    -- if love.keyboard.isDown('w') then
    --     T.y = T.y - (300 * dt)
    -- end
    -- if love.keyboard.isDown('a') then
    --     T.x = T.x - (300 * dt)
    -- end
    -- if love.keyboard.isDown('s') then
    --     T.y = T.y + (300 * dt)
    -- end
    -- if love.keyboard.isDown('d') then
    --     T.x = T.x + (300 * dt)
    -- end
    -- end

    -- function T.draw()
    --     love.graphics.setColor(1, 1, 1)
    --     love.graphics.draw(image, 0, 0, 0, W / image:getWidth(), H / image:getHeight())

    -- end

    return T
end
