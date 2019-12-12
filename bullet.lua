bullet = {}
local bullets = {}
local canFire = false

function bullet.load() bullet.speed = 100 end

function bullet.update(dt)
    for i, v in ipairs(bullets) do
        v.xPos = (v.xPos + v.xSpeed * dt)
        v.yPos = (v.yPos + v.ySpeed * dt)
    end
end

function bullet.draw()
    for i, v in ipairs(bullets) do
        love.graphics.circle("fill", v.xPos, v.yPos, 3)
    end

end

function bullet.spawnBullet(x, y, s, a)
    local dx = s * math.cos(a)
    local dy = s * math.sin(a)
    table.insert(bullets, {xPos = x, yPos = y, xSpeed = dx, ySpeed = dy})
end

return bullet
