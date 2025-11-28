local Ray = {}

function Ray:cast(settings, dt)
    dt = dt or 0
    
    local ray = {
        player = settings.player,
        maze = settings.player.maze,
        
        x = settings.x,
        y = settings.y,
        startX = settings.x,
        startY = settings.y,
        endX = nil,
        endY = nil,

        width = 1,
        height = 1,
        distance = nil,
        collided = false,
        wallSide = nil, -- 'vertical' or 'horizontal'
        
        speed = settings.speed,

        cos = settings.cos,
        sin = settings.sin,
        angle = settings.angle,
        vector = {
            x = settings.cos * settings.speed,
            y = settings.sin * settings.speed
        }
    }
    setmetatable(ray, {__index = self})

    local loops = 0
    local maxLoops = 10000
    local maxDistance = 2000 
    
    while not ray.collided and loops < maxLoops do
        loops = loops + 1
        local prevX = ray.x
        local prevY = ray.y
        ray.x = ray.x + ray.vector.x * dt
        ray.y = ray.y + ray.vector.y * dt
        
        local dx = ray.x - ray.startX
        local dy = ray.y - ray.startY
        local distanceSq = dx * dx + dy * dy
        if distanceSq > maxDistance * maxDistance then
            ray.endX, ray.endY = ray.x, ray.y
            ray.collided = true
            ray.distance = math.sqrt(distanceSq)
            break
        end

        if ray.maze and ray.maze.gridMap then
            for index_row = 1, #ray.maze.gridMap do
                local row = ray.maze.grid[index_row]
                for index_cell = 1, #ray.maze.gridMap[index_row] do
                    local cell = ray.maze.grid[index_row][index_cell]
                    if cell then
                        if collide and collide(ray, cell) then
                            local hitVertical = false
                            local minT = math.huge
                            
                            if ray.vector.x ~= 0 then
                                -- Left edge
                                local t = (cell.x - prevX) / ray.vector.x
                                if t > 0 and t < minT then
                                    local yIntersect = prevY + ray.vector.y * t
                                    if yIntersect >= cell.y and yIntersect <= cell.y + cell.height then
                                        minT = t
                                        hitVertical = true
                                    end
                                end
                                
                                -- Right edge
                                t = (cell.x + cell.width - prevX) / ray.vector.x
                                if t > 0 and t < minT then
                                    local yIntersect = prevY + ray.vector.y * t
                                    if yIntersect >= cell.y and yIntersect <= cell.y + cell.height then
                                        minT = t
                                        hitVertical = true
                                    end
                                end
                            end

                            if ray.vector.y ~= 0 then
                                local t = (cell.y - prevY) / ray.vector.y
                                if t > 0 and t < minT then
                                    local xIntersect = prevX + ray.vector.x * t
                                    if xIntersect >= cell.x and xIntersect <= cell.x + cell.width then
                                        minT = t
                                        hitVertical = false
                                    end
                                end
                                
                                t = (cell.y + cell.height - prevY) / ray.vector.y
                                if t > 0 and t < minT then
                                    local xIntersect = prevX + ray.vector.x * t
                                    if xIntersect >= cell.x and xIntersect <= cell.x + cell.width then
                                        minT = t
                                        hitVertical = false
                                    end
                                end
                            end
                            
                            if minT == math.huge then
                                hitVertical = math.abs(ray.vector.x) > math.abs(ray.vector.y)
                            end
                            
                            ray.wallSide = hitVertical and 'vertical' or 'horizontal'
                            
                            ray.endX, ray.endY = ray.x, ray.y 
                            ray.collided = true
                            dx = ray.endX - ray.startX
                            dy = ray.endY - ray.startY
                            ray.distance = math.sqrt(dx * dx + dy * dy)
                            break
                        end
                    end
                end
                if ray.collided then break end
            end
        end
    end
    
    if not ray.collided then
        ray.endX, ray.endY = ray.x, ray.y
        local dx = ray.endX - ray.startX
        local dy = ray.endY - ray.startY
        ray.distance = math.sqrt(dx * dx + dy * dy)
        ray.collided = true
    end

    return ray
end

function Ray:getDistance()
    return self.distance
end

function Ray:draw()
    local endX = self.endX or self.x or self.startX
    local endY = self.endY or self.y or self.startY
    if endX and endY then
        love.graphics.line(self.startX, self.startY, endX, endY)
    end
end

return Ray