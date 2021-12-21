function newBattleState()
    local battleState = {}
    
    -- The battle state has its own substates:
    -- 1 for selecting attack or defend, 2 for player attack, 3 for enemy attack
    battleState.state = 1
    
    local function returnToScene2State()
        local fadeOutState = newFadeOutState({ r = 1, g = 1, b = 1 }, 1, true)
        local fadeInState = newFadeInState(
            { r = 1, g = 1, b = 1 }, 1, true,
            function()
                sounds.soundtrack.battle:stop()
                sounds.soundtrack.outpost:play()
                stateStack.pop()
                stateStack.push(newScene2State())
                stateStack.push(fadeOutState)
            end
        )        
        stateStack.push(fadeInState)
    end

    -- Setup player and enemy animation.
    local playerSpritesheet = love.graphics.newImage('assets/images/spritesheets/combat_anims1.png')
    local enemySpritesheet = love.graphics.newImage('assets/images/spritesheets/combat_anims2.png')
    local grid = anim8.newGrid(144, 144, playerSpritesheet:getWidth(), playerSpritesheet:getHeight())
    
    local player = {}
    player.maxHP = 25
    player.HP = player.maxHP
    player.x = (W * 0.5) - (144 * 3.5)
    player.y = H * 0.2

    local enemy = {}
    enemy.maxHP = 35
    enemy.HP = enemy.maxHP
    enemy.x = W * 0.5
    enemy.y = H * 0.2

    player.animations = {}
    player.animations.attack = anim8.newAnimation(
        grid(4, 2, 5, 2, 6, 2), 0.2, 
        function() 
            sounds.sfx.hit:stop()
            sounds.sfx.hit:play()
            enemy.HP = enemy.HP - 5
            if (enemy.HP <= 0) then
                returnToScene2State()
            end
            battleState.state = 3
        end):flipH()
    player.animations.hurt = anim8.newAnimation(
        grid(1, 6, 2, 6, 3, 6), 0.2,
        function()
            player.currentAnimation = player.animations.attack
            player.currentAnimation:gotoFrame(1)
        end):flipH()
    player.currentAnimation = player.animations.attack
    player.currentAnimation:gotoFrame(1)

    enemy.animations = {}
    enemy.animations.attack = anim8.newAnimation(
        grid(4, 2, 5, 2, 6, 2), 0.2,
        function()
            sounds.sfx.hit:stop()
            sounds.sfx.hit:play()
            player.HP = player.HP - 6
            if (player.HP <= 0) then
                returnToScene2State()
            end
            battleState.state = 1
        end)
    enemy.animations.hurt = anim8.newAnimation(
        grid(1, 6, 2, 6, 3, 6), 0.2,
        function()
            enemy.currentAnimation = enemy.animations.attack
            enemy.currentAnimation:gotoFrame(1)
        end)
    enemy.currentAnimation = enemy.animations.attack
    enemy.currentAnimation:gotoFrame(1)

    -- Setup background image and interface elements.
    battleState.backgroundImage = love.graphics.newImage('assets/images/backgrounds/title.png')

    battleState.selectBox = {}
    battleState.selectBox.w = W * 0.2
    battleState.selectBox.h = H * 0.225
    battleState.selectBox.x = W * 0.05
    battleState.selectBox.y = H * 0.7
    battleState.selectBox.font = fonts.serif.md.font

    battleState.selectBox.option1 = {}
    battleState.selectBox.option1.text = 'ATTACK'
    battleState.selectBox.option1.x = battleState.selectBox.x + (W * 0.075)
    battleState.selectBox.option1.y = battleState.selectBox.y + (H * 0.05)
    battleState.selectBox.option2 = {}
    battleState.selectBox.option2.text = 'HEAL'
    battleState.selectBox.option2.x = battleState.selectBox.x + (W * 0.075)
    battleState.selectBox.option2.y = battleState.selectBox.option1.y + (H * 0.075)

    battleState.selectBox.selected = 1
    battleState.selectBox.cursor = {}
    battleState.selectBox.cursor.image = love.graphics.newImage('assets/images/icons/cursor.png')
    battleState.selectBox.cursor.sx = 4
    battleState.selectBox.cursor.sy = 4
    battleState.selectBox.cursor.w = battleState.selectBox.cursor.image:getWidth() * battleState.selectBox.cursor.sx
    battleState.selectBox.cursor.h = battleState.selectBox.cursor.image:getHeight() * battleState.selectBox.cursor.sy
    battleState.selectBox.cursor.x = battleState.selectBox.x + (W * 0.025)
    battleState.selectBox.cursor.y = battleState.selectBox.option1.y - (battleState.selectBox.cursor.h * 0.25)

    battleState.playerPortrait = portraits['2-1']
    battleState.playerPortrait.sx = 4
    battleState.playerPortrait.sy = 4
    local quad = {}
    quad.x, quad.y, quad.w, quad.h = battleState.playerPortrait.quad:getViewport()
    battleState.playerPortrait.w = quad.w * battleState.playerPortrait.sx
    battleState.playerPortrait.h = quad.h * battleState.playerPortrait.sy
    battleState.playerPortrait.x = W * 0.05
    battleState.playerPortrait.y = H * 0.05

    battleState.enemyPortrait = portraits['2-6']
    battleState.enemyPortrait.sx = 4
    battleState.enemyPortrait.sy = 4
    local quad = {}
    quad.x, quad.y, quad.w, quad.h = battleState.enemyPortrait.quad:getViewport()
    battleState.enemyPortrait.w = quad.w * battleState.enemyPortrait.sx
    battleState.enemyPortrait.h = quad.h * battleState.enemyPortrait.sy
    battleState.enemyPortrait.x = W * 0.85
    battleState.enemyPortrait.y = H * 0.05

    function battleState.update(dt)
        if battleState.state == 1 then
            if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
                sounds.sfx.cursor:stop()
                sounds.sfx.cursor:play()
    
                if battleState.selectBox.selected == 1 then
                    battleState.selectBox.selected = 2
                    battleState.selectBox.cursor.y = battleState.selectBox.option2.y - 
                                                     (battleState.selectBox.cursor.h * 0.25)
                else
                    battleState.selectBox.selected = 1
                    battleState.selectBox.cursor.y = battleState.selectBox.option1.y - 
                                                     (battleState.selectBox.cursor.h * 0.25)
                end
            end
            player.currentAnimation = player.animations.attack
            player.currentAnimation:gotoFrame(1)

            if love.keyboard.wasPressed('return') then
                if battleState.selectBox.selected == 1 then
                    battleState.state = 2     
                else
                    battleState.state = 3
                    player.HP = math.min(player.maxHP, player.HP + 7)
                    sounds.sfx.select:stop()
                    sounds.sfx.select:play()        
                end
            end
        elseif battleState.state == 2 then
            -- If the player is attacking, animate the player swinging the sword
            -- and the enemy being hit.
            player.currentAnimation = player.animations.attack
            enemy.currentAnimation = enemy.animations.hurt
            player.currentAnimation:update(dt)
            enemy.currentAnimation:update(dt)
        elseif battleState.state == 3 then
            player.currentAnimation = player.animations.hurt
            enemy.currentAnimation = enemy.animations.attack
            player.currentAnimation:update(dt)
            enemy.currentAnimation:update(dt)
        end
    end

    function battleState.draw()
        love.graphics.draw(battleState.backgroundImage, 0, 0, 0, 
            W / battleState.backgroundImage:getWidth(), H / battleState.backgroundImage:getHeight())

        -- Draw select box with a black and white border.
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle('fill', battleState.selectBox.x, battleState.selectBox.y,
                                        battleState.selectBox.w, battleState.selectBox.h)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(4)
        love.graphics.rectangle('line', battleState.selectBox.x, battleState.selectBox.y,
                                        battleState.selectBox.w, battleState.selectBox.h)
        love.graphics.setColor(0, 0, 0)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle('line', battleState.selectBox.x - 3, battleState.selectBox.y - 3,
                                        battleState.selectBox.w + 6, battleState.selectBox.h + 6)

        love.graphics.setColor(1, 1, 1)

        -- Print the text for each option with a black outline.
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(battleState.selectBox.font)
        love.graphics.print(battleState.selectBox.option1.text, 
                            battleState.selectBox.option1.x - 2, battleState.selectBox.option1.y)
        love.graphics.print(battleState.selectBox.option1.text,
                            battleState.selectBox.option1.x + 2, battleState.selectBox.option1.y)
        love.graphics.print(battleState.selectBox.option1.text,
                            battleState.selectBox.option1.x, battleState.selectBox.option1.y - 2)
        love.graphics.print(battleState.selectBox.option1.text,
                            battleState.selectBox.option1.x, battleState.selectBox.option1.y + 2)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(battleState.selectBox.option1.text,
                            battleState.selectBox.option1.x, battleState.selectBox.option1.y) 

        love.graphics.setColor(0, 0, 0)
        love.graphics.print(battleState.selectBox.option2.text, 
                            battleState.selectBox.option2.x - 2, battleState.selectBox.option2.y)
        love.graphics.print(battleState.selectBox.option2.text,
                            battleState.selectBox.option2.x + 2, battleState.selectBox.option2.y)
        love.graphics.print(battleState.selectBox.option2.text,
                            battleState.selectBox.option2.x, battleState.selectBox.option2.y - 2)
        love.graphics.print(battleState.selectBox.option2.text,
                            battleState.selectBox.option2.x, battleState.selectBox.option2.y + 2)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(battleState.selectBox.option2.text,
                            battleState.selectBox.option2.x, battleState.selectBox.option2.y) 

        -- Draw the cursor next to the selected option.
        love.graphics.draw(battleState.selectBox.cursor.image,
                        battleState.selectBox.cursor.x, battleState.selectBox.cursor.y, 0, 
                        battleState.selectBox.cursor.sx, battleState.selectBox.cursor.sy)

        -- Draw the player portrait with a black and white border.
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(battleState.playerPortrait.image, battleState.playerPortrait.quad,
                           battleState.playerPortrait.x, battleState.playerPortrait.y, 0,
                           battleState.playerPortrait.sx, battleState.playerPortrait.sy)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle('line', 
                                battleState.playerPortrait.x, battleState.playerPortrait.y, 
                                battleState.playerPortrait.w, battleState.playerPortrait.h)
        love.graphics.setColor(0, 0, 0)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle('line',
                                battleState.playerPortrait.x - 3, battleState.playerPortrait.y - 3,
                                battleState.playerPortrait.w + 6, battleState.playerPortrait.h + 6)
    
        -- Print the player HP with a black outline.
        local playerHP = 'HP: ' .. player.HP .. '/' .. player.maxHP

        love.graphics.setColor(0, 0, 0)
        love.graphics.print(playerHP, battleState.playerPortrait.x - 2, battleState.playerPortrait.y + 208)
        love.graphics.print(playerHP, battleState.playerPortrait.x + 2, battleState.playerPortrait.y + 208)
        love.graphics.print(playerHP, battleState.playerPortrait.x, battleState.playerPortrait.y + 206)
        love.graphics.print(playerHP, battleState.playerPortrait.x, battleState.playerPortrait.y + 210)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(playerHP, battleState.playerPortrait.x, battleState.playerPortrait.y + 208) 
        love.graphics.setColor(1, 1, 1)

        -- Draw the enemy portrait with a black and white border.
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(battleState.enemyPortrait.image, battleState.enemyPortrait.quad,
                           battleState.enemyPortrait.x, battleState.enemyPortrait.y, 0,
                           battleState.enemyPortrait.sx, battleState.enemyPortrait.sy)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle('line', 
                                battleState.enemyPortrait.x, battleState.enemyPortrait.y, 
                                battleState.enemyPortrait.w, battleState.enemyPortrait.h)
        love.graphics.setColor(0, 0, 0)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle('line',
                                battleState.enemyPortrait.x - 3, battleState.enemyPortrait.y - 3,
                                battleState.enemyPortrait.w + 6, battleState.enemyPortrait.h + 6)
    
        -- Print the enemy HP with a black outline.
        local enemyHP = 'HP: ' .. enemy.HP .. '/' .. enemy.maxHP

        love.graphics.setColor(0, 0, 0)
        love.graphics.print(enemyHP, battleState.enemyPortrait.x - 2, battleState.enemyPortrait.y + 208)
        love.graphics.print(enemyHP, battleState.enemyPortrait.x + 2, battleState.enemyPortrait.y + 208)
        love.graphics.print(enemyHP, battleState.enemyPortrait.x, battleState.enemyPortrait.y + 206)
        love.graphics.print(enemyHP, battleState.enemyPortrait.x, battleState.enemyPortrait.y + 210)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(enemyHP, battleState.enemyPortrait.x, battleState.enemyPortrait.y + 208) 
        love.graphics.setColor(1, 1, 1)

        player.currentAnimation:draw(playerSpritesheet, player.x, player.y, 0, 3.5, 3.5)
        enemy.currentAnimation:draw(enemySpritesheet, enemy.x, enemy.y, 0, 3.5, 3.5)
    end

    return battleState
end