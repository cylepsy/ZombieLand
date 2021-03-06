enemy = {}
local enemies = {}

local anim8 = require "anim8"
local backing = false
local impact = 1000
local backDist = 0
local maxBackDist = 30
local deadtime = 0
function enemy.load()
    eWalkingImage = love.graphics.newImage("assets/officer_walk_strip.png")
    eDyingImage = love.graphics.newImage("assets/officer_die_strip.png")
    local w = anim8.newGrid(32, 45, eWalkingImage:getWidth(), eWalkingImage:getHeight())
    local d = anim8.newGrid(49, 54, eDyingImage:getWidth(), eDyingImage:getHeight())
    eWalking = anim8.newAnimation(w("1-8", 1), 0.4)
    eDying = anim8.newAnimation(d("1-4", 1), 0.1, "pauseAtEnd")
end

function enemy.update(dt)
    for i, v in ipairs(enemies) do
        if not v.dying then
            v.xPos, v.yPos = v.body:getPosition()
            local direction = math.atan2(v.pBody:getY() - v.body:getY(), v.pBody:getX() - v.body:getX())
            v.body:setAngle(direction)

            v.eWalking:update(dt)

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
                v.dying = true
                deadtime = love.timer.getTime()
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
        else
            if math.floor(love.timer.getTime() - deadtime) >= 2 then
                table.remove(enemies, i)
            else
                v.eDying:update(dt)
            end
        end
    end
end

function enemy.draw()
    for i, v in ipairs(enemies) do
        -- love.graphics.circle("fill", v.xPos, v.yPos, 14)
        if v.dying then
            v.eDying:draw(eDyingImage, v.xPos, v.yPos, v.body:getAngle(), 1, 1, 25, 25)
        else
            v.eWalking:draw(eWalkingImage, v.xPos, v.yPos, v.body:getAngle(), 1, 1, 18, 20)
        end

        love.graphics.setColor(200, 0, 0)
        love.graphics.rectangle("fill", v.xPos - 14, v.yPos - 22, 28 * (v.hp / 100), 5)
        love.graphics.setColor(255, 255, 255)
    end
end

function enemy.spawn(s, pBody)
    local near_player = true
    -- while near_player do
    -- Random coordinates
    x = math.floor(love.math.random(0, 1))
    if x == 1 then
        y = 0
        x = love.math.random(0, love.graphics.getWidth())
    else
        y = love.math.random(0, love.graphics.getHeight())
    end

    -- Distance between player and zombie by X
    local dist_x = math.abs(pBody:getX() - x)

    -- Distance between player and zombie by Y
    local dist_y = math.abs(pBody:getY() - y)

    -- If distance > 100 by X and Y then quit loop
    if dist_x > 100 and dist_y > 100 then
        near_player = false
    end
    -- end

    body = love.physics.newBody(world, x, y, "dynamic")
    shape = love.physics.newCircleShape(14)
    fix = love.physics.newFixture(body, shape, 5)
    fix:setUserData("enemy")
    e = {
        body = body,
        shape = shape,
        fix = fix,
        pBody = pBody,
        speed = s,
        xPos = x,
        yPos = y,
        hp = 100,
        eWalking = eWalking,
        eDying = eDying,
        dying = false
    }
    table.insert(enemies, e)
end

return enemy
