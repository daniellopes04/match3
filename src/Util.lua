--[[
    Part of "S50's Intro to Game Development"
    Lecture 3
    
    -- Utilities file --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04

    All the utilities of the game are stored here. Mainly used in this case
    to manage the sprite sheets.
]]

--[[
    Receives an "atlas" (a texture with multiple sprites) and the tile dimensions
    Then, split the texture into all of the quads by dividing it evenly.
]]
function GenerateQuads(atlas, tileWidth, tileHeight)
    local sheetWidth = atlas:getWidth() / tileWidth
    local sheetHeight = atlas:getHeight() / tileHeight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do 
        for x = 0, sheetWidth - 1  do
            spritesheet[sheetCounter] = 
                love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth,
                tileHeight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

--[[
    Populates a table with mini-tables each containing X and Y coordinates for tiles
    Each tile also have a quad ID associated with it
]] 
function generateBoard()
    local tiles = {}

    -- Iterate over columns of tiles
    for y = 1, 8 do 
        -- Insert empty row
        table.insert(tiles, {})

        -- Iterate over rows of tiles
        for x = 1, 8 do 
            -- For the blank row inserted, add the tiles
            table.insert(tiles[y], {
                -- Coordinates are 0-base, so we subtract one before multiiplying
                x = (x - 1) * 32,
                y = (y - 1) * 32,

                -- Assign a random ID to tile
                tile = math.random(#tileQuads)
            })
        end
    end

    return tiles
end

function drawBoard(offsetX, offsetY)
    -- Draw the columns
    for y = 1, 8 do
        -- Draw the rows
        for x = 1, 8 do
            local tile = board[y][x]

            love.graphics.draw(tileSprite, tileQuads[tile.tile], 
            tile.x + offsetX, tile.y + offsetY)
        end
    end
end