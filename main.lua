local xSize
local ySize
local cellSize = 5
local border = 1
local cellDrawSize = cellSize - border

function love.load()
    xSize = love.graphics.getWidth() / cellSize
    ySize = love.graphics.getHeight() / cellSize
    love.graphics.setBackgroundColor(255, 255, 255, 255)

    grid = {}
    for x = 1, xSize do
        grid[x] = {}
        for y = 1, ySize do
            grid[x][y] = false
        end
    end
end

function love.update()
    selectedX = math.floor(love.mouse.getX() / cellSize) + 1
    selectedY = math.floor(love.mouse.getY() / cellSize) + 1

    if love.mouse.isDown(1) and selectedX <= gridXCount and selectedY <= gridYCount then
        grid[selectedX][selectedY] = true
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
            nextGrid[x][y] = true
        end
    end

    grid = nextGrid
end