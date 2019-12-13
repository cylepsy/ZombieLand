player = {}
local bullet = require "bullet"
local anim8 = require "anim8"
-- local walkingImage, walking
local currentAnim
local currentImage
local xoff = -0
local yoff = -0

local pistolTime = 0.3
local bulletTimer = 0
local canFire = false

function player.load()
    bullet.load()

    player.xvel = 0
    player.yvel = 0
    player.speed = 200
    player.accel = 400
    player.hp = 100
    player.beingHurt = false
    player.hurtTime = 0

    player.body = love.physics.newBody(world, 60, 60, "kinematic")
    player.shape = love.physics.newCircleShape(14)
    player.fix = love.physics.newFixture(player.body, player.shape, 5)
    player.fix:setUserData("player")
    player.body:setAngle(0)

    -- Load sprite to anim8
    walkingImage = love.graphics.newImage("assets/player_walk_strip6.png")
    local w = anim8.newGrid(30, 41, walkingImage:getWidth(), walkingImage:getHeight(), 2, 11, 4)
    walking = anim8.newAnimation(w("1-6", 1), 0.1)

    idleImage = love.graphics.newImage("assets/player_9mmhandgun.png")
    local i = anim8.newGrid(66, 60, idleImage:getWidth(), idleImage:getHeight(), 14, 15)
    idle = anim8.newAnimation(i(1, 1), 1)

    currentAnim = idle
    currentImage = idleImage
end

function player.update(dt)
    bullet.update(dt)

    -- handling get hurt
    if player.beingHurt then
        if math.floor(love.timer.getTime() - player.hurtTime) >= 3 then
            player.beingHurt = false
        end
    end

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
    if bulletTimer > 0 then
        bulletTimer = bulletTimer - dt
    else
        canFire = true
    end

    -- shooting
    if love.keyboard.isDown("space") then
        if canFire then
            bullet.spawnBullet(player.body:getX(), player.body:getY(), 1000, player.body:getAngle())
            canFire = false
            bulletTimer = pistolTime
        end
    end
end

function player.keyreleased(key)
    if key == "d" or "a" then
        player.xvel = 0
    end
    if key == "w" or "s" then
        player.yvel = 0
    end
end

function player.draw()
    bullet.draw()
    --  drawing the body out
    -- love.graphics.circle("fill", player.body:getX(), player.body:getY(), player.shape:getRadius())
    love.graphics.setColor(100, 0, 0)
    love.graphics.rectangle("fill", 30, 30, 120 * (player.hp / 100), 10)
    love.graphics.setColor(255, 255, 255)

    if player.beingHurt then
        love.graphics.setColor(100, 0, 0)
    else
        love.graphics.setColor(255, 255, 255)
    end
    currentAnim:draw(
        currentImage,
        player.body:getX(),
        player.body:getY(),
        player.body:getAngle(), -- scale: 1  offset: 15
        1,
        1,
        15,
        15
    )
    love.graphics.setColor(255, 255, 255)

    -- love.graphics.print(tostring(player.xvel))
    -- love.graphics.print(tostring(player.yvel), 0, 10)
    -- love.graphics.print(bulletTimer, 0, 20)
    -- love.graphics.print(player.hp, 0, 30)
    -- if player.beingHurt then
    --     love.graphics.print("being hurt", 0, 40)
    -- else
    --     love.graphics.print("not being hurt", 0, 40)
    -- end
    -- love.graphics.print(math.floor(love.timer.getTime() - player.hurtTime), 0, 50)
end

function player.hurt()
    if not player.beingHurt then
        player.hurtTime = love.timer.getTime()
        player.hp = player.hp - 10
        player.beingHurt = true
    end
end
return player
