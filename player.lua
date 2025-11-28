local Player = {}

function Player:new(maze)
    local player = {
        maze = maze,

        x = 400,
        y = 300,
        lastX = nil,
        lastY = nil,

        width = 10,
        height = 10,
        hand_sprite = love.graphics.newImage('sprites/hand.png'),
        hand_x = nil,
        hand_y = nil,

        rotation = 0,
        rotationSpeed = 0.7,
        mouseSensitivity = 0.002,
        rotationCos = nil,
        rotationSin = nil,
        rotationAngle = nil,

        speed = 130,
        vector = {
            x = 0,
            y = 0
        }
    }
    setmetatable(player, {__index = self})
    return player
end

function Player:checkCollisions()
    for index_row = 1, #self.maze.gridMap do
        local row = self.maze.grid[index_row]
        for index_cell = 1, #self.maze.gridMap[index_row] do
            local cell = self.maze.grid[index_row][index_cell]
            if cell then
                --print('(stat): cellindex: '..index_cell..', cellwidth/height: '..cell.width..'/'..cell.height..', cellx/y: '..cell.x..'/'..cell.y..'.')
                if collide and collide(self, cell) then
                    self.x = self.lastX
                    self.y = self.lastY
                end
            end
        end
    end
end

function Player:move(dt)
	self.lastX = self.x; self.lastY = self.y
    self.rotationCos = math.cos(self.rotation)
    self.rotationSin = math.sin(self.rotation)
    self.rotationAngle = math.atan2(self.y, self.x)

	self.vector.x, self.vector.y = 0, 0
	if love.keyboard.isDown('w') then 
		self.vector.x = self.vector.x + self.rotationCos
		self.vector.y = self.vector.y + self.rotationSin
	end
	if love.keyboard.isDown('s') then 
		self.vector.x = self.vector.x - self.rotationCos
		self.vector.y = self.vector.y - self.rotationSin
	end
	if love.keyboard.isDown('a') then 
		self.vector.x = self.vector.x + self.rotationSin
		self.vector.y = self.vector.y - self.rotationCos
	end
	if love.keyboard.isDown('d') then 
		self.vector.x = self.vector.x - self.rotationSin
		self.vector.y = self.vector.y + self.rotationCos
	end

	local length = math.sqrt(self.vector.x * self.vector.x + self.vector.y * self.vector.y)
	if length > 0 then
		self.vector.x = self.vector.x / length
		self.vector.y = self.vector.y / length
		self.x = self.x + self.vector.x * self.speed * dt
		self.y = self.y + self.vector.y * self.speed * dt
	end

    if love.keyboard.isDown('left') then self.rotation = self.rotation - self.rotationSpeed * dt end
    if love.keyboard.isDown('right') then self.rotation = self.rotation + self.rotationSpeed * dt end
end

function Player:rotateWithMouse(dx)
    self.rotation = self.rotation + dx * self.mouseSensitivity
end

function Player:update(dt)
    self:move(dt)
    self:checkCollisions()
end

function Player:draw()
    ---[[
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.line(self.x + self.width / 2, self.y + self.height / 2, self.x + (self.rotationCos * 30), self.y + (self.rotationSin * 30))
    --]]
    love.graphics.draw(self.hand_sprite, window_width / 2 + (window_width / 6) - self.hand_sprite:getHeight() / 3, window_height / 2.2, nil, window_height / 38)
end

return Player