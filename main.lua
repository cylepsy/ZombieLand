player = {}
function love.load()
    love.graphics.setBackgroundColor(0, 0, 100)
    player.x = 0
    player.speed = 200
    player.accel = 400
    player.velo = 0
end

function love.update(dt)
    if (love.keyboard.isDown("right")) and (player.velo <= player.speed) then
        player.velo = player.velo + dt * player.accel
    end
        player.x = player.x + player.velo * dt 
end

function love.keyreleased(key)
    if key == 'right' then
        player.velo = 0
    end
end

function love.draw()
    love.graphics.rectangle("line", player.x, 200, 50, 80)
    love.graphics.print(tostring(player.velo), 100, 100)
    love.graphics.print(tostring(player.accel), 100, 120)
end
