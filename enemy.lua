enemy = {}
local enemies = {}

local backing = false
local impact = 1000
local backDist = 0
local maxBackDist = 30
function enemy.load()
end

function enemy.update(dt)
    for i, v in ipairs(enemies) do
        v.xPos, v.yPos = v.body:getPosition()
        local currentDist = dt * impact

        --  handle gethurt
        if v.fix:getUserData() == "l" then
            v.xPos = v.xPos - currentDist
            backDist = backDist + currentDist
        end

        if v.fix:getUserData() == "r" then
            v.xPos = v.xPos + currentDist
            backDist = backDist + currentDist
        end

        if v.fix:getUserData() == "u" then
            v.yPos = v.yPos - currentDist
            backDist = backDist + currentDist
        end

        if v.fix:getUserData() == "d" then
            v.yPos = v.yPos + currentDist
            backDist = backDist + currentDist
        end

        -- Handle backoff
        if backDist > maxBackDist then
            v.hp = v.hp - 20
            v.fix:setUserData("enemy")
            backDist = 0
        end

        -- Handle Dying
        if v.hp <= 0 then
            table.remove(enemies, i)
        end

        -- Handle moving
        if math.floor(v.pBody:getX() - v.xPos) ~= 0 then
            -- If difference < 0 than player to the left of enemy
            -- Move enemy to left
            if (v.pBody:getX() - v.xPos) < 0 then
                -- Else move enemy to right
                v.xPos = v.xPos - v.speed
            else
                v.xPos = v.xPos + v.speed
            end
        end

        if math.floor(v.pBody:getY() - v.yPos) ~= 0 then
            if (v.pBody:getY() - v.yPos) < 0 then
                v.yPos = v.yPos - v.speed
            else
                v.yPos = v.yPos + v.speed
            end
        end

        v.body:setPosition(v.xPos, v.yPos)
    end
end

function enemy.draw()
    for i, v in ipairs(enemies) do
        love.graphics.circle("fill", v.xPos, v.yPos, 14)
        love.graphics.setColor(200, 0, 0)
        love.graphics.rectangle("fill", v.xPos - 14, v.yPos - 22, 28 * (v.hp / 100), 5)
        love.graphics.setColor(255, 255, 255)
    end
end

function enemy.spawn(x, y, s, pBody)
    body = love.physics.newBody(world, x, y, "kinematic")
    shape = love.physics.newCircleShape(14)
    fix = love.physics.newFixture(body, shape, 5)
    fix:setUserData("enemy")
    xPos, yPos = body:getPosition()
    e = {
        body = body,
        shape = shape,
        fix = fix,
        pBody = pBody,
        speed = s,
        xPos = xPos,
        yPos = ypos,
        hp = 100
    }
    table.insert(enemies, e)
end

return enemy
