player = {}
function love.load()
    love.window.setMode(320,240)
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

function love.keypressed(key)
    if key == 'u' then
       u_down = true
       text = "The u key was pressed."
    end
    if key == 'y' then
       y_down = true
       text = "The y key was pressed."
    end
 end

function love.draw()
    love.graphics.rectangle("line", player.x, 100, 50, 50)
    love.graphics.print(tostring(player.velo), 100, 100)
    love.graphics.print(tostring(player.accel), 100, 120)
    if u_down then
        love.graphics.print(tostring(text), 100, 130)
    end
    if y_down then
        love.graphics.print(tostring(text), 100, 130)
    end

end
