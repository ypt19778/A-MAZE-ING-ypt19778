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
end

function love.update(dt)
    player:update(dt)
    raycaster:update(dt)
end

function love.draw()
    --[[
    maze:draw()
    
    player:draw()
    ]]
    raycaster:draw()

    love.graphics.setColor(0, 0, 0)
    love.graphics.circle('fill', love.graphics:getWidth() / 2, love.graphics:getHeight() / 2, 5)
    love.graphics.setColor(1, 1, 1)
end

function love.keypressed(k) 
    if k == 'escape' then
        love.event.quit()
    end
end