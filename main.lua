local player = require("player")

function love.load()
    world = love.physics.newWorld(0, 0, true)
    love.window.setMode(800, 600)
    love.graphics.setBackgroundColor(0, 0, 100)

    player.load()
end

function love.update(dt) player.update(dt) end

function love.keyreleased(key) player.keyreleased(key) end

function love.draw() player.draw(dt) end
