local CelAut = require("src.CelAutCaveGen")

local xSize
local ySize
local cellSize = 5
local border = 1
local cellDrawSize = cellSize - border
local wallChance = 480
local caveGen = true

local rng = love.math.newRandomGenerator(os.time())

function love.load()
    xSize = love.graphics.getWidth() / cellSize
    ySize = love.graphics.getHeight() / cellSize
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

function love.update()
    selectedX = math.floor(love.mouse.getX() / cellSize) + 1
    selectedY = math.floor(love.mouse.getY() / cellSize) + 1

    if love.mouse.isDown(1) and selectedX <= xSize and selectedY <= ySize then
        grid[selectedX][selectedY] = true
    elseif love.mouse.isDown(2) and selectedX <= xSize and selectedY <= ySize then
        grid[selectedX][selectedY] = false
    end
end

function love.draw()
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
    love.graphics.setColor(0, 0, 0)
    love.graphics.print('selected x: ' .. selectedX .. ', selected y: ' .. selectedY)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

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

function createCave()
    celAut = CelAut.create(xSize, ySize)
    grid = celAut.grid
end