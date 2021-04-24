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

    -- Setting up the screen
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

-- Called when the screen is resized
function love.resize(w, h)
    push:resize(w, h)
end

-- Keyboard entry handler
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

-- Used to check if a key was pressed in the last frame
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    secondTimer = secondTimer + dt

    if secondTimer > 1 then
        currentSecond = currentSecond + 1
        secondTimer =  secondTimer % 1
    end
end

function love.draw()
    push:start()

    love.graphics.printf('Timer: '.. tostring(currentSecond), 0, VIRTUAL_HEIGHT / 2 - 8, VIRTUAL_WIDTH, 'center')

    push:finish()
end
