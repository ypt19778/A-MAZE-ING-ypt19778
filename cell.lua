local Cell = {}
Cell.__index = Cell 

function Cell:new(x, y, width, height)
    local cell = {
        x = x, 
        y = y, 
        width = width, 
        height = height 
    }
    setmetatable(cell, {__index = self})
    return cell
end

function Cell:draw()
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end

return Cell