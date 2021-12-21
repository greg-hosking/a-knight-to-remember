-- IMPORT EXTERNAL LIBRARIES.
sti = require('src/lib/sti')
anim8 = require('src/lib/anim8')

-- IMPORT STATE STACK AND STATES.
local statesPath = 'src/states/'
stateStack = require(statesPath .. 'stateStack')
require(statesPath .. 'fadeInState')
require(statesPath .. 'fadeOutState')
require(statesPath .. 'splashScreenState')
require(statesPath .. 'titleScreenState')
require(statesPath .. 'creditsScreenState')
require(statesPath .. 'dialogueState')

require(statesPath .. 'scene1State')
require(statesPath .. 'scene2State')

-- IMPORT PLAYER.
require('src/player')

-- IMPORT SFX AND SOUNDTRACK.
sounds = {}

local soundtrackPath = 'assets/audio/soundtrack/'
sounds.soundtrack = {}
sounds.soundtrack.title = love.audio.newSource(soundtrackPath .. 'title.mp3', 'static')
sounds.soundtrack.title:setLooping(true)
sounds.soundtrack.village = love.audio.newSource(soundtrackPath .. 'village.mp3', 'static')
sounds.soundtrack.village:setLooping(true)
sounds.soundtrack.outpost = love.audio.newSource(soundtrackPath .. 'outpost.mp3', 'static')
sounds.soundtrack.outpost:setLooping(true)
sounds.soundtrack.credits = love.audio.newSource(soundtrackPath .. 'credits.mp3', 'static')

local sfxPath = 'assets/audio/sfx/'
sounds.sfx = {}
sounds.sfx.blips = {}
for i = 1, 30 do
    sounds.sfx.blips[i] = love.audio.newSource(sfxPath .. 'blips/blip' .. i .. '.ogg', 'static')
end
sounds.sfx.cursor = love.audio.newSource(sfxPath .. 'ui/cursor.wav', 'static')
sounds.sfx.select = love.audio.newSource(sfxPath .. 'ui/select.wav', 'static')


-- IMPORT FONTS.
fonts = {}

local pixelPath = 'assets/fonts/pixel.ttf'
fonts.pixel = {}
fonts.pixel.xl = {}
fonts.pixel.xl.size = 96
fonts.pixel.xl.font = love.graphics.newFont(pixelPath, fonts.pixel.xl.size)
fonts.pixel.lg = {}
fonts.pixel.lg.size = 64
fonts.pixel.lg.font = love.graphics.newFont(pixelPath, fonts.pixel.lg.size)
fonts.pixel.md = {}
fonts.pixel.md.size = 32
fonts.pixel.md.font = love.graphics.newFont(pixelPath, fonts.pixel.md.size)
fonts.pixel.sm = {}
fonts.pixel.sm.size = 16
fonts.pixel.sm.font = love.graphics.newFont(pixelPath, fonts.pixel.sm.size)

local serifPath = 'assets/fonts/serif.ttf'
fonts.serif = {}
fonts.serif.xl = {}
fonts.serif.xl.size = 128
fonts.serif.xl.font = love.graphics.newFont(serifPath, fonts.serif.xl.size)
fonts.serif.lg = {}
fonts.serif.lg.size = 64
fonts.serif.lg.font = love.graphics.newFont(serifPath, fonts.serif.lg.size)
fonts.serif.md = {}
fonts.serif.md.size = 48
fonts.serif.md.font = love.graphics.newFont(serifPath, fonts.serif.md.size)
fonts.serif.sm = {}
fonts.serif.sm.size = 32
fonts.serif.sm.font = love.graphics.newFont(serifPath, fonts.serif.sm.size)

-- IMPORT PORTRAIT IMAGES.
portraits = require('src/portraits')
