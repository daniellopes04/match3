![Match-3](https://github.com/daniellopes04/match3/blob/main/graphics/match3-text.png)

***Lecture 3* on "S50's Intro to Game Development" course, available on [YouTube](https://www.youtube.com/playlist?list=PLWKjhJtqVAbluXJKKbCIb4xd7fcRkpzoz)**
 
Implementation of a Match-3 game.

![Match-3](https://github.com/daniellopes04/match3/blob/main/graphics/screen1.png)

## Objectives

- [X] Implement time addition on matches, such that scoring a match extends the timer by 1 second per tile in a match.
- [X] Ensure Level 1 starts just with simple flat blocks (the first of each color in the sprite sheet), with later levels generating the blocks with patterns on them (like the triangle, cross, etc.). These should be worth more points, at your discretion.
- [X] Creat random shiny versions of blocks that will destroy an entire row on match, granting points for each block in the row.
- [X] Only allow swapping when it results in a match. If there are no matches available to perform, reset the board. 

## Possible updates

- [ ] Implement matching using the mouse.

## Installation

### Build

First, you have to install [LÖVE2D](https://love2d.org/), then run the following.

```bash
git clone https://github.com/daniellopes04/match3
cd match3
love .
```

### Play

Simply go to ["Releases"](https://github.com/daniellopes04/match3/releases) and download the version compatible with your system.

## The game

### Controls

* Keyboard arrows to select the block to swap
* "Enter" to swap blocks
* "ESC" to exit the game

### In-game powerups

A glowing block destroys the entire row or column when matched.
