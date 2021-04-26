--[[
    Part of "S50's Intro to Game Development"
    Lecture 3
    
    -- PlayState Class --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04
    
    Represents the main portion of the game in which we are actively playing.
    The player moves a cursor through a grid and selects two tiles to swap. If the swap
    results in three or more tiles lined up verticaly or horizontaly, destroy the tiles
    and add their points to the player's score. Once the player gets enough points,
    proceed to next level. There is also a timer and if the player doesn't move to 
    the next level before the timer runs out, it gets redirected to the main menu or 
    top score menu, if it gets a high score.
]]

PlayState = Class{__includes = BaseState}

function PlayState:init(params)
    -- Tile selected to be swapped
    self.highlightedTile = false
    self.highlightedX, self.highlightedY = 1, 1

    -- Current selected tile, changed with arrow keys
    self.selectedTile = board[1][1]
end

function PlayState:update(dt)
    local x, y = self.selectedTile.gridX, self.selectedTile.gridY

    -- Moving the selected tile
    if love.keyboard.wasPressed('up') then
        if y > 1 then
            self.selectedTile = self.board[y - 1][x]
        end
    elseif love.keyboard.wasPressed('down') then
        if y < 8 then
            self.selectedTile = self.board[y + 1][x]
        end
    elseif love.keyboard.wasPressed('left') then
        if x > 1 then
            self.selectedTile = self.board[y][x - 1]
        end
    elseif love.keyboard.wasPressed('right') then
        if x < 8 then
            self.selectedTile = self.board[y][x + 1]
        end
    end
    
    -- When enter is pressed we highlight a tile
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if not self.highlightedTile then
            self.highlightedTile = true
            self.highlightedX, self.highlightedY = self.selectedTile.gridX, self.selectedTile.gridY
        elseif math.abs(self.highlightedX - self.selectedTile.gridX) + 
        math.abs(self.highlightedY - self.selectedTile.gridY) > 1 then
            self.highlightedTile = false
        else
            local tile1 = self.selectedTile
            local tile2 = self.board[highlightedY][highlightedX]

            -- Temporary swap information
            local tempX, tempY = tile2.x, tile2.y 
            local tempGridX, tempGridY = tile2.gridX, tile2.gridY

            -- Swap places in the board
            local tempTile = tile1
            self.board[tile1.gridY][tile1.gridX] = tile2
            self.board[tile2.gridY][tile2.gridX] = tempTile

            -- Swap tile coordinates using tween
            Timer.tween(0.2, {
                [tile2] = {x = tile1.x, y = tile1.y},
                [tile1] = {x = tempX, y = tempY}
            })
            
            tile2.gridX, tile2.gridY = tile1.gridX, tile1.gridY
            tile1.gridX, tile1.gridY = tempGridX, tempGridY

            -- Unhighlight the tile and reset selection
            self.highlightedTile = false
            self.selectedTile = tile2
        end
    end

    if love.keyboard.wasPressed('escape') then 
        love.event.quit()
    end

    Timer.update(dt)
end

function PlayState:render()
    -- Draws the board with and offset so it's centered
    drawBoard(128, 16)
end