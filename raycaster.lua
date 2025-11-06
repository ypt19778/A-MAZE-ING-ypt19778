local Raycaster = {}

function Raycaster:new(player, ray)
    local raycaster = {
        player = player,
        Ray = ray,

        rays = {},

        numRays = 100,
        fov = math.pi / 2,
        raySpeed = 2,

        pixelPerX = 20,
        cubesize = 40,
        rectwidth = 10,
        rectheight = nil,
        window_height = love.graphics.getHeight(),

        all = {
            speed = 100
        }
    }
    setmetatable(raycaster, {__index = self})
    return raycaster
end

function Raycaster:castRays(dt)
    self.rays = {}
    
    local angleStep = self.fov / self.numRays
    self.lineWidth = angleStep
    local startAngle = self.player.rotation - (self.fov / 2)
    
    for i = 1, self.numRays do
        local rayAngle = startAngle + (angleStep * (i - 1))
        
        local rayCos = math.cos(rayAngle)
        local raySin = math.sin(rayAngle)
        
        local ray = self.Ray:cast({
            maze = self.player.maze,

            x = self.player.x + self.player.width / 2, 
            y = self.player.y + self.player.height / 2,

            speed = self.raySpeed,
            cos = rayCos, 
            sin = raySin
        }, dt)

        table.insert(self.rays, ray)
    end
end

function Raycaster:update(dt)
    self.x = self.player.x; self.y = self.player.y
    self:castRays(dt)
end

local red = {r = 1, g = 0, b = 0}
local green = {r = 0, g = 1, b = 0}
local blue = {r = 0, g = 0, b = 1}
local white = {r = 1, g = 1, b = 1}
local black = {r = 0, g = 0, b = 0}

local rectOffsetMod = 0
function Raycaster:draw()
    if love.keyboard.isDown('up') then
        rectOffsetMod = rectOffsetMod + self.player.rotationSpeed * 30
    elseif love.keyboard.isDown('down') then
        rectOffsetMod = rectOffsetMod - self.player.rotationSpeed * 30
    end
    for index_ray, ray in ipairs(self.rays) do
        --ray:draw()

        self.rectheight = (self.cubesize * self.window_height) / ray.distance
        local rectOffset = (self.window_height / 2 - (self.rectheight / 2)) + rectOffsetMod
        local rect_texture = {
            white
        }
        local shade = (self.rectheight / 255) -- rgb val
        local textureHeight = self.rectheight / #rect_texture
        
        for height = 1, self.rectheight do
            local textureIndex = math.floor((height - 1) / textureHeight) + 1
            textureIndex = ((textureIndex - 1) % #rect_texture) + 1
            
            local texture = rect_texture[textureIndex]
            local pixelR = shade * texture.r
            local pixelG = shade * texture.g
            local pixelB = shade * texture.b
            love.graphics.setColor(pixelR, pixelG, pixelB)
            
            love.graphics.rectangle('fill', self.pixelPerX * index_ray, rectOffset + height - 1, self.pixelPerX, 1)
        end
        love.graphics.setColor(1, 1, 1)
    end
end

return Raycaster