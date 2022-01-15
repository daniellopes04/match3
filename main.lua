--[[
    Part of "S50's Intro to Game Development"
    Lecture 3
    
    -- Implementation of game "Match-3" --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04
]]

require 'src/Dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Match-3')

    -- Set the randomseed, used to generate random numbers
    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true,
        canvas = true
    })

    -- Initializa game music
    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    -- Initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['begin-game'] = function() return BeginGameState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end
    }
    gStateMachine:change('start')

    -- Keep track of scrolling our background on the X axis
    backgroundX = 0

    -- To keep track of the keys pressed
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    -- Scroll background
    backgroundX = backgroundX - BACKGROUND_SCROLL_SPEED * dt

    -- If we've scrolled the entire image, reset it to 0
    if backgroundX <= -1024 + VIRTUAL_WIDTH - 4 + 51 then
        backgroundX = 0
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(gTextures['background'], backgroundX, 0)

    gStateMachine:render()

    push:finish()
end
