local xSize
local ySize
local cellSize = 5
local border = 1
local cellDrawSize = cellSize - border
local wallChance = 35
local mapBorderThickness = 0
local dungeonGen = true

local rng = love.math.newRandomGenerator(os.time())

function love.load()
    xSize = love.graphics.getWidth() / cellSize
    ySize = love.graphics.getHeight() / cellSize
    love.graphics.setBackgroundColor(255, 255, 255, 255)
    love.keyboard.setKeyRepeat(true)

    grid = {}
    for x = 1, xSize do
        grid[x] = {}
        for y = 1, ySize do
            if dungeonGen then
                if rng:random(100) >= wallChance then
                    grid[x][y] = false
                else
                    grid[x][y] = true
                end

                if x <= mapBorderThickness or x >= xSize - mapBorderThickness then
                    grid[x][y] = true
                end

                if y <= mapBorderThickness or y >= ySize - mapBorderThickness then
                    grid[x][y] = true
                end
            else
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

function love.keypressed()
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

                    if dungeonGen then
                        if grid[x + dx] == nil then
                            neighbourCount = neighbourCount + 1
                        elseif grid[x + dx][y + dy] == nil then
                            neighbourCount = neighbourCount + 1
                        end
                    end
                end
            end

            if dungeonGen then
                if x <= mapBorderThickness or x >= xSize - mapBorderThickness then
                    grid[x][y] = true
                end

                if y <= mapBorderThickness or y >= ySize - mapBorderThickness then
                    grid[x][y] = true
                end

                if neighbourCount > 4 then
                    nextGrid[x][y] = true
                elseif neighbourCount < 4 then
                    nextGrid[x][y] = false
                end
            else
                nextGrid[x][y] = neighbourCount == 3 or (grid[x][y] and neighbourCount == 2)
            end
        end
    end

    grid = nextGrid
end