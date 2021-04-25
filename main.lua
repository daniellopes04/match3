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

    -- Sprite sheet of tiles
    tileSprite = love.graphics.newImage('graphics/match3.png')

    -- Individual tile quads
    tileQuads = GenerateQuads(tileSprite, 32, 32)

    -- Game board of tiles
    board = generateBoard()

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    -- To keep track of the keys pressed
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then 
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    -- Reset the keys pressed
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- Draws the board with and offset so it's centered
    drawBoard(128, 16)

    push:finish()
end
