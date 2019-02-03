local CelAut = require("src.CelAutCaveGen")
local Camera = require("src.camera")

local xSize
local ySize
local cellSize = 5
local border = 1
local cellDrawSize = cellSize - border
local wallChance = 460
local caveGen = true

-- Camera variables
local x, y = 0, 0
local zoom = 1

local rng = love.math.newRandomGenerator(os.time())

function love.load()
    xSize = love.graphics.getWidth() / cellSize
    ySize = love.graphics.getHeight() / cellSize
    -- xSize = 110
    -- ySize = 110
    love.graphics.setBackgroundColor(255, 255, 255, 255)
    love.keyboard.setKeyRepeat(true)

    if caveGen then
        createCave()
    else
        grid = {}
        for x = 1, xSize do
            grid[x] = {}
            for y = 1, ySize do
                grid[x][y] = false
            end
        end
    end
end

function love.update(dt)
    selectedX = math.floor((love.mouse.getX() + x )/ cellSize) + 1
    selectedY = math.floor((love.mouse.getY() + y )/ cellSize) + 1

    if love.mouse.isDown(1) and selectedX <= xSize and selectedY <= ySize then
        grid[selectedX][selectedY] = true
    elseif love.mouse.isDown(2) and selectedX <= xSize and selectedY <= ySize then
        grid[selectedX][selectedY] = false
    end

    checkKeyboardInput(dt)
    Camera:setPosition(x, y)
    Camera:setScale(zoom, zoom)
    -- Camera:setRotation(rotation)
end

function love.draw()
    Camera:set()
    for x = 1, xSize do
        for y = 1, ySize do
            if x == selectedX and y == selectedY then
                love.graphics.setColor(0, 255, 255)
            elseif grid[x][y] then
                love.graphics.setColor(255, 0, 255)
            else
                love.graphics.setColor(220, 220, 220)
            end
            love.graphics.rectangle('fill', (x - 1) * cellSize, (y - 1) * cellSize, cellDrawSize, cellDrawSize)
        end
    end
    Camera:unset()
    mouse_x = math.floor(Camera.x / cellSize) + selectedX
    mouse_y = math.floor(Camera.y / cellSize) + selectedY
    love.graphics.setColor(0, 0, 0)
    love.graphics.print('selected x: ' .. mouse_x .. ', selected y: ' .. mouse_y)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "r" then

        if caveGen then
            createCave()
        else
            local nextGrid = {}

            for x = 1, xSize do
                nextGrid[x] = {}
                for y = 1, ySize do
                    local neighbourCount = 0

                    for dx = -1, 1 do
                        for dy = -1, 1 do
                            if not (dx == 0 and dy == 0) and grid[x + dx] and grid[x + dx][y + dy] then
                                neighbourCount = neighbourCount + 1
                            end

                            if caveGen then
                                if grid[x + dx] == nil then
                                    neighbourCount = neighbourCount + 1
                                elseif grid[x + dx][y + dy] == nil then
                                    neighbourCount = neighbourCount + 1
                                end
                            end
                        end
                    end
                    nextGrid[x][y] = neighbourCount == 3 or (grid[x][y] and neighbourCount == 2)
                end
            end

            grid = nextGrid
        end
    end
end

function createCave()
    celAut = CelAut.create(xSize, ySize, wallChance)
    grid = celAut.grid
end

function checkKeyboardInput(dt)
    tempX, tempY = 0, 0

    if love.keyboard.isDown("w") then
        tempY = tempY - Camera.panSpeed * dt
    end

    if love.keyboard.isDown("s") then
        tempY = tempY + Camera.panSpeed * dt
    end
    
    if love.keyboard.isDown("a") then
        tempX = tempX - Camera.panSpeed * dt
    end

    if love.keyboard.isDown("d") then
        tempX = tempX + Camera.panSpeed * dt
    end

    x = x + tempX
    y = y + tempY

    if love.keyboard.isDown("q") then
        rotation = rotation + Camera.rotateSpeed * dt
    end
    if love.keyboard.isDown("e") then
        rotation = rotation - Camera.rotateSpeed * dt
    end
    if love.keyboard.isDown("z") then
        zoom = zoom + Camera.zoomSpeed * dt
    end
    if love.keyboard.isDown("x") then
        zoom = zoom - Camera.zoomSpeed * dt
    end
end