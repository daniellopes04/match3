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
    Receives an "atlas" (a texture with multiple sprites) then split the texture 
    into all of the quads.
]]
function GenerateQuadsTiles(atlas)
    local tiles = {}

    local x = 0
    local y = 0

    local counter = 1

    -- 9 rows of tiles
    for row = 1, 9 do
        -- Two sets of 6 columns per row
        -- Different tile varieties
        for i = 1, 2 do
            tiles[counter] = {}
            
            for col = 1, 6 do
                table.insert(tiles[counter], love.graphics.newQuad(
                    x, y, 32, 32, atlas:getDimensions()
                ))

                x = x + 32
            end

            counter = counter + 1
        end

        y = y + 32
        x = 0
    end

    return tiles
end