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

    -- Tile selected to be swapped
    highlightedTile = false
    highlightedX, highlightedY = 1, 1

    -- Current selected tile, changed with arrow keys
    selectedTile = board[1][1]

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
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    local x, y = selectedTile.gridX, selectedTile.gridY

    -- Moving the selected tile
    if love.keyboard.wasPressed('up') then
        if y > 1 then
            selectedTile = board[y - 1][x]
        end
    elseif love.keyboard.wasPressed('down') then
        if y < 8 then
            selectedTile = board[y + 1][x]
        end
    elseif love.keyboard.wasPressed('left') then
        if x > 1 then
            selectedTile = board[y][x - 1]
        end
    elseif love.keyboard.wasPressed('right') then
        if x < 8 then
            selectedTile = board[y][x + 1]
        end
    end
    
    -- When enter is pressed we highlight a tile
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if not highlightedTile then
            highlightedTile = true
            highlightedX, highlightedY = selectedTile.gridX, selectedTile.gridY
        else
            local tile1 = selectedTile
            local tile2 = board[highlightedY][highlightedX]

            -- Temporary swap information
            local tempX, tempY = tile2.x, tile2.y 
            local tempGridX, tempGridY = tile2.gridX, tile2.gridY

            -- Swap places in the board
            local tempTile = tile1
            board[tile1.gridY][tile1.gridX] = tile2
            board[tile2.gridY][tile2.gridX] = tempTile

            -- Swap tile coordinates
            Timer.tween(0.2, {
                [tile2] = {x = tile1.x, y = tile1.y},
                [tile1] = {x = tempX, y = tempY}
            })
            
            tile2.gridX, tile2.gridY = tile1.gridX, tile1.gridY
            tile1.gridX, tile1.gridY = tempGridX, tempGridY

            -- Unhighlight the tile and reset selection
            highlightedTile = false
            selectedTile = tile2
        end
    end

    if love.keyboard.wasPressed('escape') then 
        love.event.quit()
    end

    Timer.update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- Draws the board with and offset so it's centered
    drawBoard(128, 16)

    push:finish()
end
