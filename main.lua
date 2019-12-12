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
    enemy.spawn(100, 100, 0.5, player.body)
end

function love.update(dt)
    world:update(dt)
    player.update(dt)
    enemy.update(dt)
end

function love.keyreleased(key)
    player.keyreleased(key)
end

function love.draw()
    player.draw()
    enemy.draw()
    if ifhit then
        love.graphics.print("hit", 30, 0)
    else
        love.graphics.print("no", 30, 0)
    end
end

function beginContact(a, b, coll)
    love.graphics.print("goal!", 0, 30)
    local enemy, bullet

    if a:getUserData() == "enemy" then
        enemy = a
    elseif b:getUserData() == "enemy" then
        enemy = b
    end

    if a:getUserData() == "r" or a:getUserData() == "l" or a:getUserData() == "u" or a:getUserData() == "d" then
        bullet = a
    elseif b:getUserData() == "r" or b:getUserData() == "l" or b:getUserData() == "u" or b:getUserData() == "d" then
        bullet = b
    end
    if bullet and enemy then
        enemy:setUserData(bullet:getUserData())
        bullet:setUserData("bang")
    end
end
