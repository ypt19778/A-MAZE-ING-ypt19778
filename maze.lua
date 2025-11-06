local Maze = {}
Maze.__index = Maze

-- add a maze generation function 

function Maze:new(cell)
    local maze = {
        Cell = cell, 

        startX = 10, 
        startY = 10,
        gridMap = {
            {1, 1, 1, 1, 1, 1},
            {1, 0, 0, 0, 0, 1},
            {1, 0, 1, 1, 0, 1},
            {1, 0, 0, 0, 0, 1},
            {1, 1, 1, 1, 1, 1}
        },
        grid = {},

        all = {
            width = 100,
            height = 100
        }
    }

    for y, _ in ipairs(maze.gridMap) do
        maze.grid[y] = {}
        for x, _ in ipairs(maze.gridMap[y]) do
            maze.grid[y][x] = nil
        end
    end

	for index_row = 1, #maze.gridMap do
		local row = maze.gridMap[index_row]
		for index_cell = 1, #row do
			if row[index_cell] == 1 then
				maze.grid[index_row][index_cell] = maze.Cell:new(
					maze.startX + (index_cell * maze.all.width),
					maze.startY + (index_row * maze.all.height),
					maze.all.width,
					maze.all.height
				)
				--print('cell ('..index_cell..'), state = '..type(row[index_cell]))
			end
		end
	end

    setmetatable(maze, {__index = self})

    return maze
end

function Maze:draw()
    for index_row = 1, #self.gridMap do
        local row = self.grid[index_row]
        for index_cell = 1, #self.gridMap[index_row] do
            local cell = row[index_cell]
            if type(cell) == 'table' then
                cell:draw() 
                --print('drawn cell ('..index_cell..')')
            end
        end
    end
end

return Maze