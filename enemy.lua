enemy = {}
local xPos, yPos
local backing = false
local impact = 1000
local backDist = 0
local maxBackDist = 30
function enemy.load()
end

function enemy.update(dt)
    xPos, yPos = enemy.body:getPosition()
    local currentDist = dt * impact

    --  handle gethurt
    if enemy.fix:getUserData() == "l" then
        xPos = xPos - currentDist
        backDist = backDist + currentDist
    end

    if enemy.fix:getUserData() == "r" then
        xPos = xPos + currentDist
        backDist = backDist + currentDist
    end

    if enemy.fix:getUserData() == "u" then
        yPos = yPos - currentDist
        backDist = backDist + currentDist
    end

    if enemy.fix:getUserData() == "d" then
        yPos = yPos + currentDist
        backDist = backDist + currentDist
    end

    -- Handle backoff
    if backDist > maxBackDist then
        enemy.fix:setUserData("enemy")
        backing = false
        backDist = 0
    end

    -- Handle moving
    if math.floor(enemy.pBody:getX() - xPos) ~= 0 then
        -- If difference < 0 than player to the left of enemy
        -- Move enemy to left
        if (enemy.pBody:getX() - xPos) < 0 then
            -- Else move enemy to right
            xPos = xPos - enemy.speed
        else
            xPos = xPos + enemy.speed
        end
    end

    if math.floor(enemy.pBody:getY() - yPos) ~= 0 then
        if (enemy.pBody:getY() - yPos) < 0 then
            yPos = yPos - enemy.speed
        else
            yPos = yPos + enemy.speed
        end
    end

    enemy.body:setPosition(xPos, yPos)
end

function enemy.draw()
    love.graphics.circle("fill", xPos, yPos, 14)
end

function enemy.spawn(x, y, s, pBody)
    enemy.body = love.physics.newBody(world, x, y, "kinematic")
    enemy.shape = love.physics.newCircleShape(14)
    enemy.fix = love.physics.newFixture(enemy.body, enemy.shape, 5)
    enemy.fix:setUserData("enemy")
    enemy.pBody = pBody

    enemy.speed = s

    xPos, yPos = enemy.body:getPosition()
end

function enemy.backoff()
end
return enemy
