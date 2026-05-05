local player = {}


function love.load()
    -- 1. 加载 4x3 的图集
    player.sheet = love.graphics.newImage("kalala.png") -- 请确保文件名正确
    local sw, sh = player.sheet:getDimensions()

    -- 计算每一帧的大小（宽=总宽/3，高=总高/4）
    player.fw = sw / 3
    player.fh = sh / 4

    -- 2. 使用二维表存储 Quad [行][列]
    -- 行索引：1-向下, 2-静止(Idle), 3-向左/右, 4-向上
    player.animations = {}
    for row = 1, 4 do
        player.animations[row] = {}
        for col = 1, 3 do
            local quad = love.graphics.newQuad(
                (col-1) * player.fw, (row-1) * player.fh,
                player.fw, player.fh, sw, sh
            )
            table.insert(player.animations[row], quad)
        end
    end

    -- 3. 状态变量
    player.x, player.y = 400, 300
    player.speed = 150
    player.animRow = 1     -- 当前对应的行
    player.animFrame = 1   -- 当前帧
    player.animTimer = 0
    player.dirX = 1        -- 用于左右镜像
    player.isMoving = false
end


function love.update(dt)
    local isAnyKeyPressed = false
    local vx, vy = 0, 0

    if love.keyboard.isDown("down") then
        vy, player.animRow, isAnyKeyPressed = 1, 1, true
    elseif love.keyboard.isDown("up") then
        vy, player.animRow, isAnyKeyPressed = -1, 4, true
    elseif love.keyboard.isDown("left") then
        vx, player.dirX, player.animRow, isAnyKeyPressed = -1, -1, 3, true
    elseif love.keyboard.isDown("right") then
        vx, player.dirX, player.animRow, isAnyKeyPressed = 1, 1, 3, true
    end

    if not isAnyKeyPressed then
        player.animRow = 1 -- 切换到 Idle
    end

    -- 更新坐标和动画帧（保持不变）
    player.x = player.x + vx * player.speed * dt
    player.y = player.y + vy * player.speed * dt
    player.animTimer = player.animTimer + dt
    if player.animTimer > 0.2 then
        player.animTimer = 0
        player.animFrame = (player.animFrame % 3) + 1
    end
end

function love.draw()
    -- 6. 绘图
    love.graphics.draw(
        player.sheet,
        player.animations[player.animRow][player.animFrame],
        player.x, player.y,
        0,
        player.dirX, 1,    -- 通过 dirX 实现左右镜像
        player.fw/2, player.fh/2 -- 居中绘制
        )
    end
