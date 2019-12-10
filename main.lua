local anim8 = require 'anim8'

local image, animation

function love.load()
    love.window.setMode(800, 600)
    image = love.graphics.newImage("assets/player_walk_strip6.png")
    local g = anim8.newGrid(35, 57, image:getWidth(), image:getHeight())
    animation = anim8.newAnimation(g('1-6', 1), 0.1)
    x = 0
end

function love.update(dt)
    animation:update(dt)
    if love.keyboard.isDown("right") then
        x = x + 1
    end

end

function love.draw()
    animation:draw(image, 100 + x, 200)
end
