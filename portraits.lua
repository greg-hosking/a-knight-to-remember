-- Each image is made up of eight portraits (in two rows and four columns).
-- Each image itself is 192x96 pixels, thus making each portrait 48x48 pixels.
local quadW, quadH = 48, 48
local imageW, imageH = 192, 96
local quads = {}
for row = 1, 2 do
    for col = 1, 4 do
        local x = (col - 1) * quadW
        local y = (row - 1) * quadH
        local quad = love.graphics.newQuad(x, y, quadW, quadH, imageW, imageH)
        table.insert(quads, quad)
    end
end

-- Each portrait is stored as table with an image and a quad, and is accessible
-- from the portraits table using a string in the following format: 
-- local portrait = portraits['{imageNum}-{quadNum}']
local portraits = {}
for imageNum = 1, 13 do
    local image = love.graphics.newImage('assets/images/portraits/' .. imageNum .. '.png')
    for quadNum = 1, 8 do
        local portraitNum = imageNum .. '-' .. quadNum
        local portrait = {}
        portrait.image = image
        portrait.quad = quads[quadNum]
        portraits[portraitNum] = portrait
    end
end

return portraits
