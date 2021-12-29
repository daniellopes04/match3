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

function PlayState:enter()
    self.offsetX = 128
    self.offsetY = 16
    self.board = Board(self.offsetX, self.offsetY)

    -- Tile selected to be swapped
    self.highlightedTile = nil
    self.highlightedX, self.highlightedY = 1, 1

    -- Current selected tile, changed with arrow keys
    self.selectedTile = self.board.tiles[1][1]
end

function PlayState:update(dt)
    local x, y = self.selectedTile.gridX, self.selectedTile.gridY

    -- Moving the selected tile
    if love.keyboard.wasPressed('up') then
        if y > 1 then
            self.selectedTile = self.board.tiles[y - 1][x]
        end
    elseif love.keyboard.wasPressed('down') then
        if y < 8 then
            self.selectedTile = self.board.tiles[y + 1][x]
        end
    elseif love.keyboard.wasPressed('left') then
        if x > 1 then
            self.selectedTile = self.board.tiles[y][x - 1]
        end
    elseif love.keyboard.wasPressed('right') then
        if x < 8 then
            self.selectedTile = self.board.tiles[y][x + 1]
        end
    end
    
    -- When enter is pressed we highlight a tile
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if not self.highlightedTile then
            self.highlightedTile = true
            self.highlightedX, self.highlightedY = self.selectedTile.gridX, self.selectedTile.gridY
            self.highlightedTile = self.board.tiles[y][x]
        -- if we select the position already highlighted, remove highlight
        elseif self.highlightedTile == self.board.tiles[y][x] then
            self.highlightedTile = nil
        elseif math.abs(self.highlightedX - self.selectedTile.gridX) + math.abs(self.highlightedY - self.selectedTile.gridY) > 1 then
            self.highlightedTile = nil
        else
            -- Swap grid positions of tiles
            local tempX, tempY = self.highlightedTile.gridX, self.highlightedTile.gridY
            local newTile = self.board.tiles[y][x]

            self.highlightedTile.gridX = newTile.gridX
            self.highlightedTile.gridY = newTile.gridY
            newTile.gridX = tempX
            newTile.gridY = tempY

            -- Swap tiles in the tiles table
            self.board.tiles[self.highlightedTile.gridY][self.highlightedTile.gridX] = self.highlightedTile
            self.board.tiles[newTile.gridY][newTile.gridX] = newTile

            -- Tween coordinates between the two so they swap
            Timer.tween(0.2, {
                [self.highlightedTile] = {x = newTile.x, y = newTile.y},
                [newTile] = {x = self.highlightedTile.x, y = self.highlightedTile.y}
            })

            self.selectedTile = self.highlightedTile
            self.highlightedTile = nil
        end
    end

    if love.keyboard.wasPressed('escape') then 
        love.event.quit()
    end

    Timer.update(dt)
end

function PlayState:render()
    -- Draws the board with and offset so it's centered
    self.board:render()

    -- Highlights selected tile
    if self.highlightedTile then
        -- Multiply so drawing white rect makes it brighter
        love.graphics.setBlendMode('add')

        love.graphics.setColor(1, 1, 1, 96/255)
        love.graphics.rectangle('fill', (self.highlightedTile.gridX - 1) * 32 + self.offsetX,
            (self.highlightedTile.gridY - 1) * 32 + self.offsetY, 32, 32, 4)

        -- Back to alpha
        love.graphics.setBlendMode('alpha')
    end

    -- Draws rectangle around current tile
    love.graphics.setColor(1, 0, 0, 234/255)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', self.selectedTile.x + self.offsetX, self.selectedTile.y + self.offsetY, 32, 32, 4)
    love.graphics.setColor(1, 1, 1, 1)
end