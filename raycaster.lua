local Raycaster = {}

function Raycaster:new(player, ray)
    local raycaster = {
        player = player,
        Ray = ray,

        rays = {},

        numRays = 200,
        fov = math.pi / 3,
        raySpeed = 2,

        cubesize = 50,
        rectwidth = 10,
        rectheight = nil,
        pixelPerX = window_width / 200,

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
            player = self.player,

            x = self.player.x + self.player.width / 2, 
            y = self.player.y + self.player.height / 2,

            speed = self.raySpeed,
            cos = rayCos, 
            sin = raySin,
            angle = rayAngle
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
    
    local rect_texture = {white}
    
    for index_ray, ray in ipairs(self.rays) do
        --ray:draw()

        local angleDiff = ray.angle - self.player.rotation
        angleDiff = ((angleDiff + math.pi) % (2 * math.pi)) - math.pi
        local perpDistance = ray.distance * math.cos(angleDiff)
        if perpDistance < 0.1 then perpDistance = 0.1 end
        
        self.rectheight = (self.cubesize * window_height) / perpDistance
        local rectOffset = (window_height / 2 - (self.rectheight / 2)) + rectOffsetMod
        
        -- Optimize: draw entire rectangle at once instead of pixel by pixel
        local shade = math.min(self.rectheight / 255, 1.0) -- rgb val, clamped to 1.0
        
        -- Use a single rectangle draw call instead of per-pixel
        love.graphics.setColor(shade, shade, shade)
        love.graphics.rectangle('fill', self.pixelPerX * (index_ray - 1), rectOffset, self.pixelPerX, self.rectheight)
    end
    love.graphics.setColor(1, 1, 1)
end

return Raycaster