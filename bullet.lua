bullet = {}
local bullets = {}
local canFire = false

function bullet.load()
    bullet.speed = 100
end

function bullet.update(dt)
    for i, v in ipairs(bullets) do
        v.xPos = (v.xPos + v.xSpeed * dt)
        v.yPos = (v.yPos + v.ySpeed * dt)
        v.bBody:setPosition(v.xPos, v.yPos)
        if v.xPos > love.graphics.getWidth() or v.yPos > love.graphics.getHeight() or v.xPos < 0 or v.yPos < 0 then
            table.remove(bullets, i)
        end

        if v.bFix:getUserData() == "bang" then
            table.remove(bullets, i)
        end
    end
end

function bullet.draw()
    for i, v in ipairs(bullets) do
        love.graphics.circle("fill", v.xPos, v.yPos, 3)
        love.graphics.print(v.a, 500, 500)
    end
end

function bullet.spawnBullet(x, y, s, a)
    local dx = s * math.cos(a)
    local dy = s * math.sin(a)
    body = love.physics.newBody(world, x, y, "dynamic")
    shape = love.physics.newCircleShape(3)
    fix = love.physics.newFixture(body, shape, 5)

    angle = math.floor(math.deg(a))
    if angle == 0 then
        fix:setUserData("r")
    end
    if angle == 90 then
        fix:setUserData("d")
    end
    if angle == -181 then
        fix:setUserData("l")
    end
    if angle == -91 then
        fix:setUserData("u")
    end
    b = {
        a = angle,
        xPos = x,
        yPos = y,
        xSpeed = dx,
        ySpeed = dy,
        bBody = body,
        bShape = shape,
        bFix = fix
    }
    table.insert(bullets, b)
end

return bullet
