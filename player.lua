player = {}
bullets = {}
local bullet = require "bullet"

local anim8 = require 'anim8'
-- local walkingImage, walking
local currentAnim
local currentImage
local xoff = -0
local yoff = -0

function player.load()
    player.xvel = 0
    player.yvel = 0
    player.speed = 200
    player.accel = 400
    player.face = "right"

    player.body = love.physics.newBody(world, 60, 60, "kinematic")
    player.shape = love.physics.newCircleShape(14)
    player.fix = love.physics.newFixture(player.body, player.shape, 5)
    player.body:setAngle(0)

    -- Load sprite to anim8
    walkingImage = love.graphics.newImage("assets/player_walk_strip6.png")
    local w = anim8.newGrid(30, 41, walkingImage:getWidth(),
                            walkingImage:getHeight(), 2, 11, 4)
    walking = anim8.newAnimation(w('1-6', 1), 0.1)

    idleImage = love.graphics.newImage("assets/player_9mmhandgun.png")
    local i = anim8.newGrid(66, 60, idleImage:getWidth(), idleImage:getHeight(),
                            14, 15)
    idle = anim8.newAnimation(i(1, 1), 1)

    currentAnim = idle
    currentImage = idleImage

    player.shoot_time = love.timer.getTime()
end

function player.update(dt)

    -- handle input
    if love.keyboard.isDown("d") and player.xvel < player.speed then
        player.xvel = player.xvel + player.accel * dt
        currentAnim = walking
        currentImage = walkingImage
        player.body:setAngle(math.rad(0))
    end

    if love.keyboard.isDown("a") and player.xvel > -player.speed then
        player.xvel = player.xvel - player.accel * dt
        currentAnim = walking
        currentImage = walkingImage
        player.body:setAngle(math.rad(-180))
    end

    if love.keyboard.isDown("s") and player.yvel < player.speed then
        player.yvel = player.yvel + player.accel * dt
        currentAnim = walking
        currentImage = walkingImage
        player.body:setAngle(math.rad(90))
    end

    if love.keyboard.isDown("w") and player.yvel > -player.speed then
        player.yvel = player.yvel - player.accel * dt
        currentAnim = walking
        currentImage = walkingImage
        player.body:setAngle(math.rad(-90))
    end

    if player.xvel == 0 and player.yvel == 0 then
        currentAnim = idle
        currentImage = idleImage
    end

    -- handle physics
    local x, y = player.body:getPosition()
    x = x + player.xvel * dt
    y = y + player.yvel * dt

    player.body:setPosition(x, y)

    -- update animation
    currentAnim:update(dt)

    -- shooting

    if love.keyboard.isDown("space") then
        -- If last show was second ago or more then shoot
        if math.floor(love.timer.getTime() - player.shoot_time) >= 1 then
            player.shoot()
            player.shoot_time = love.timer.getTime()
        end
    end
end

function player.keyreleased(key)
    if key == 'd' or 'a' then player.xvel = 0 end

    if key == 'w' or 's' then player.yvel = 0 end
end

function player.draw()
    --  drawing the body out
    --	love.graphics.circle("fill", player.body:getX(),player.body:getY(), player.shape:getRadius())

    currentAnim:draw(currentImage, player.body:getX(), player.body:getY(),
                     player.body:getAngle(), -- scale: 1  offset: 15
    1, 1, 15, 15)
    love.graphics.print(tostring(player.xvel))
    love.graphics.print(tostring(player.yvel), 0, 10)

end

function player.shoot()
    -- Get point that will be little right and below man's center
    local x, y = player.body:getWorldPoint(65, 5)

    -- Bullet's direction vector coordinates
    local lx, ly = player.body:getWorldVector(400, 0)

    -- Index for new bullet in bullets table
    local i = #bullets + 1

    -- Create bullet
    bullets[i] = BulletClass:new(x, y, lx, ly)
    bullets[i]:create()
end

return player
