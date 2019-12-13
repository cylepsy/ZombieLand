local player = require("player")
local enemy = require("enemy")
local ifhit = false

function love.load()
    love.window.setMode(800, 600)
    love.graphics.setBackgroundColor(0, 0, 100)
    world = love.physics.newWorld(0, 0, true)
    world:setCallbacks(beginContact, endContact, preSolve, postSolves)

    player.load()
    enemy.load()
    enemy.spawn(0.5, player.body)
    time = love.timer.getTime()
end

function love.update(dt)
    world:update(dt)
    player.update(dt)
    enemy.update(dt)
    if math.floor(love.timer.getTime() - time) >= 5 then
        enemy.spawn(0.5, player.body)
        time = love.timer.getTime()
    end
end

function love.keyreleased(key)
    player.keyreleased(key)
end

function love.draw()
    player.draw()
    enemy.draw()
end

function beginContact(a, b, coll)
    local eFix, bFix, pFix

    if a:getUserData() == "enemy" then
        eFix = a
    elseif b:getUserData() == "enemy" then
        eFix = b
    end

    if a:getUserData() == "player" then
        pFix = a
    elseif b:getUserData() == "player" then
        pFix = b
    end

    if a:getUserData() == "r" or a:getUserData() == "l" or a:getUserData() == "u" or a:getUserData() == "d" then
        bFix = a
    elseif b:getUserData() == "r" or b:getUserData() == "l" or b:getUserData() == "u" or b:getUserData() == "d" then
        bFix = b
    end

    if bFix and eFix then
        eFix:setUserData(bFix:getUserData())
        bFix:setUserData("bang")
    end

    if eFix and pFix then
        player.hurt()
    end
end
