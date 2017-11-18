local xSize
local ySize
local cellSize = 5
local border = 1
local cellDrawSize = cellSize - border

function love.load()
    xSize = love.graphics.getWidth() / cellSize
    ySize = love.graphics.getHeight() / cellSize
end

function love.update()

end

function love.draw()
    for x = 1, xSize do
        for y = 1, ySize do
            love.graphics.rectangle('fill', (x - 1) * cellSize, (y - 1) * cellSize, cellDrawSize, cellDrawSize)
        end
    end
end