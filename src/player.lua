local anim8 = require('src/lib/anim8')

function newPlayer(map)
    local player = {}

    local spritesheet = love.graphics.newImage('assets/images/spritesheets/characters1.png')
    local grid = anim8.newGrid(26, 36, spritesheet:getWidth(), spritesheet:getHeight())

    -- Setup player animations.
    player.animations = {}
    player.animations.walk = {}
    player.animations.walk.up = anim8.newAnimation(grid(1, 4, 2, 4, 3, 4, 2, 4), 0.2)
    player.animations.walk.left = anim8.newAnimation(grid(1, 2, 2, 2, 3, 2, 2, 2), 0.2)
    player.animations.walk.down = anim8.newAnimation(grid(1, 1, 2, 1, 3, 1, 2, 1), 0.2)
    player.animations.walk.right = anim8.newAnimation(grid(1, 3, 2, 3, 3, 3, 2, 3), 0.2)
    player.currentAnimation = player.animations.walk.down

    player.hitbox = {}
    player.hitbox.x = 256
    player.hitbox.y = 400
    player.hitbox.w = 64
    player.hitbox.h = 32

    player.sprite = {}
    player.sprite.x = player.hitbox.x - 16
    player.sprite.y = player.hitbox.y - 20
    player.sprite.y = player.hitbox.y - 36

    -- player.hitbox.x = 
    -- love.graphics.rectangle('line', player.x + 16, player.y + 20, w * 4 - 20 - 16, h * 4 - 20)

    player.x = 256
    player.y = 400

    player.speed = 160


    -- Setup wall collisions for the current map.
    local walls = {}
    if map.layers.walls then
        for i, obj in ipairs(map.layers.walls.objects) do
            local wall = {}
            wall.x = obj.x * 4
            wall.y = obj.y * 4
            wall.w = obj.width * 4
            wall.h = obj.height * 4
            table.insert(walls, wall)
        end
    end

    local function attemptMove(dir, dt)
        local prevX, prevY = player.hitbox.x, player.hitbox.y

        -- Attempt to move in the desired direction.
        if dir == 'up' then
            player.hitbox.y = player.hitbox.y - (player.speed * dt)            
        end
        if dir == 'left' then
            player.hitbox.x = player.hitbox.x - (player.speed * dt)            
        end
        if dir == 'down' then
            player.hitbox.y = player.hitbox.y + (player.speed * dt)            
        end
        if dir == 'right' then
            player.hitbox.x = player.hitbox.x + (player.speed * dt)            
        end
        
        -- If the player attempts to move out of the bounds of the screen,
        -- set the position to the bound that was exceeded.
        if player.hitbox.x < 0 then
            player.hitbox.x = 0
        end
        if player.hitbox.x > W - player.hitbox.w then
            player.hitbox.x = W - player.hitbox.w
        end
        if player.hitbox.y < 92 then
            player.hitbox.y = 92
        end
        if player.hitbox.y > H - player.hitbox.h then
            player.hitbox.y = H - player.hitbox.h
        end

        -- Check for collisions with structures and obstacles.
        for i = 1, #walls do
            local wall = walls[i]
            if ((player.hitbox.x > wall.x and player.hitbox.x < wall.x + wall.w) or
                (player.hitbox.x + player.hitbox.w > wall.x and player.hitbox.x < wall.x + wall.w)) and
               ((player.hitbox.y > wall.y and player.hitbox.y < wall.y + wall.h) or 
                (player.hitbox.y + player.hitbox.h > wall.y and player.hitbox.y < wall.y + wall.h)) then
                player.hitbox.x = prevX
                player.hitbox.y = prevY
            end
        end

    end

    function player.update(dt)
        if love.keyboard.isDown('w', 'up') then
            player.currentAnimation = player.animations.walk.up
            attemptMove('up', dt)
        elseif love.keyboard.isDown('a', 'left') then
            player.currentAnimation = player.animations.walk.left
            attemptMove('left', dt)            
        elseif love.keyboard.isDown('s', 'down') then
            player.currentAnimation = player.animations.walk.down
            attemptMove('down', dt)
        elseif love.keyboard.isDown('d', 'right') then
            player.currentAnimation = player.animations.walk.right
            attemptMove('right', dt)            
        else
            player.currentAnimation:gotoFrame(2)             
        end

        player.sprite.x = player.hitbox.x - 16
        player.sprite.y = player.hitbox.y - 112
        player.currentAnimation:update(dt)
    end


    function player.draw()

        player.currentAnimation:draw(spritesheet, player.sprite.x, player.sprite.y, 0, 4, 4)
        local w, h = player.currentAnimation:getDimensions()

        love.graphics.rectangle('line', player.hitbox.x, player.hitbox.y, player.hitbox.w, player.hitbox.h)
        love.graphics.rectangle('line', player.sprite.x, player.sprite.y, w * 4, h * 4)
        -- love.graphics.rectangle('line', player.x + 16, player.y + 20, w * 4 - 20 - 16, h * 4 - 20)


        love.graphics.setColor(1, 0, 0)
        for i = 1, #walls do
            local wall = walls[i]
            -- love.graphics.rectangle('fill', wall.x, wall.y, wall.w, wall.h)
        end
        -- animation:draw(spritesheet, W/2, H/2, 0, 4, 4)
    end


    
    return player
end