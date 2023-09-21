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
function GenerateQuadsTilesOld(atlas)
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

function GenerateQuadsTiles(atlas)
    local tiles = {}

    local x = 0
    local y = 0

    local counter = 1
    -- Color # starts from left to right, then goes down
    local selectedTiles = {1, 4, 6, 9, 10, 11, 12, 17}

    for i = 1, #selectedTiles do
        tiles[counter] = {}

        if selectedTiles[i] % 2 == 0 then
            x = 32 * 6
        end
        y = (math.ceil(selectedTiles[i]/2) * 32) - 32

        for col = 1, 6 do
            table.insert(tiles[counter], love.graphics.newQuad(
                x, y, 32, 32, atlas:getDimensions()
            ))

            x = x + 32
        end

        counter = counter + 1
        x = 0
    end

    return tiles
end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end