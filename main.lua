love.graphics.setDefaultFilter("nearest", "nearest")

window_height = love.graphics.getHeight()
window_width = love.graphics.getWidth()

function collide(a, b)
    if a.x < b.x + b.width and a.x + a.width > b.x then
        if a.y < b.y + b.height and a.y + a.height > b.y then
            return true
        end
    end
    return false
end

Cell = require('cell')
Maze = require('maze')

Player = require('player')

Ray = require('ray')
Raycaster = require('raycaster')

function love.load()
    maze = Maze:new(Cell)

    player = Player:new(maze)

    raycaster = Raycaster:new(player, Ray)
    
    -- Enable relative mouse mode for smooth mouse look
    love.mouse.setRelativeMode(true)
end

function love.update(dt)
    player:update(dt)
    raycaster:update(dt)
end

function love.draw()
    ---[[
    maze:draw()
    --]]
    raycaster:draw()
    player:draw()
end

function love.keypressed(k) 
    if k == 'escape' then
        love.event.quit()
    end
end

function love.mousemoved(x, y, dx, dy)
    -- rotate player based on horizontal mouse movement
    player:rotateWithMouse(dx)
end