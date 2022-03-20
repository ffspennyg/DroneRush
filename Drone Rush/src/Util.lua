function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

function table.slice(tbl, first, last, step)
    local sliced = {}
  
    for i = first or 1, last or #tbl, step or 1 do
      sliced[#sliced+1] = tbl[i]
    end
  
    return sliced
end

function GenerateQuadsDrones(atlas)
    local x = 0
    local y = 0

    local counter = 1
    local quads = {}

    for i = 0, 11 do
        quads[counter] = love.graphics.newQuad(x, y, 16, 16,
            atlas:getDimensions())
        counter = counter + 1

        quads[counter] = love.graphics.newQuad(x + 16, y, 16, 16,
            atlas:getDimensions())
        counter = counter + 1

        quads[counter] = love.graphics.newQuad(x + 32, y, 16, 16,
            atlas:getDimensions())
        counter = counter + 1

        quads[counter] = love.graphics.newQuad(x + 48, y, 16, 16,
            atlas:getDimensions())
        counter = counter + 1

        quads[counter] = love.graphics.newQuad(x + 64, y, 16, 16,
            atlas:getDimensions())
        counter = counter + 1

        quads[counter] = love.graphics.newQuad(x + 80, y, 16, 16,
            atlas:getDimensions())
        counter = counter + 1

        quads[counter] = love.graphics.newQuad(x, y + 16, 16, 16,
            atlas:getDimensions())
        counter = counter + 1

        quads[counter] = love.graphics.newQuad(x + 16, y + 16, 16, 16,
            atlas:getDimensions())
        counter = counter + 1

        quads[counter] = love.graphics.newQuad(x + 32, y + 16, 16, 16,
            atlas:getDimensions())
        counter = counter + 1

        quads[counter] = love.graphics.newQuad(x + 48, y + 16, 16, 16,
            atlas:getDimensions())
        counter = counter + 1

        quads[counter] = love.graphics.newQuad(x + 64, y + 16, 16, 16,
            atlas:getDimensions())
        counter = counter + 1

        quads[counter] = love.graphics.newQuad(x + 80, y + 16, 16, 16,
            atlas:getDimensions())
        counter = counter + 1
    end

    return quads
end

function GenerateQuadsRocks(atlas)
    local x = 0
    local y = 16

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        quads[counter] = love.graphics.newQuad(x, y, 16, 16,
            atlas:getDimensions())
        x = x + 16
        counter = counter + 1
    end

    return quads
end

function GenerateQuadsDroneHealth(atlas)
    local x = 0
    local y = 0

    local counter = 1
    local quads = {}

    for i = 0, 1 do
        quads[counter] = love.graphics.newQuad(x, y, 16, 16,
            atlas:getDimensions())
        x = x + 16
        counter = counter + 1
    end

    return quads
end

function GenerateQuadsBugs(atlas)
    local x = 0
    local y = 0

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        quads[counter] = love.graphics.newQuad(x, y, 6, 6,
            atlas:getDimensions())
        x = x + 6
        counter = counter + 1
    end

    return quads
end

function GenerateQuadsJelly(atlas)
    local x = 0
    local y = 6

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        quads[counter] = love.graphics.newQuad(x, y, 6, 6,
            atlas:getDimensions())
        x = x + 6
        counter = counter + 1
    end

    return quads
end

function GenerateQuadsBackgrounds(atlas)
    local x = 0
    local y = 0

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        quads[counter] = love.graphics.newQuad(x, y, 223, 800,
            atlas:getDimensions())
        x = x + 223
        counter = counter + 1
    end

    return quads
end

function GenerateQuadsCrabs(atlas)
    local x = 0
    local y = 0

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        quads[counter] = love.graphics.newQuad(x, y, 8, 6,
            atlas:getDimensions())
        x = x + 8
        counter = counter + 1
    end

    return quads
end

function GenerateQuadsBuoys(atlas)
    local x = 0
    local y = 6

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        quads[counter] = love.graphics.newQuad(x, y, 16, 14,
            atlas:getDimensions())
        x = x + 16
        counter = counter + 1
    end

    return quads
end

function GenerateQuadsBoss(atlas)
    local x = 0
    local y = 0

    local counter = 1
    local quads = {}

    for i = 0, 2 do
        quads[counter] = love.graphics.newQuad(x, y, 50, 30,
            atlas:getDimensions())
        x = x + 50
        counter = counter + 1
    end

    return quads
end

function GenerateQuadsTurtles(atlas)
    local x = 0
    local y = 20

    local counter = 1
    local quads = {}

    for i = 0, 1 do
        quads[counter] = love.graphics.newQuad(x, y, 32, 16,
            atlas:getDimensions())
        x = x + 32
        counter = counter + 1
    end

    return quads
end

function GenerateQuadsOctopus(atlas)
    local x = 0
    local y = 36

    local counter = 1
    local quads = {}

    for i = 0, 1 do
        quads[counter] = love.graphics.newQuad(x, y, 32, 16,
            atlas:getDimensions())
        x = x + 32
        counter = counter + 1
    end

    return quads
end

function GenerateQuadsPower(atlas)
    local x = 0
    local y = 0

    local counter = 1
    local quads = {}

    for i = 0, 0 do
        quads[counter] = love.graphics.newQuad(x, y, 12, 12,
            atlas:getDimensions())
        x = x + 12
        counter = counter + 1
    end

    return quads
end

function GenerateQuadsLava(atlas)
    local x = 0
    local y = 0

    local counter = 1
    local quads = {}

    for i = 0, 0 do
        quads[counter] = love.graphics.newQuad(x, y, 16, 16,
            atlas:getDimensions())
        x = x + 12
        counter = counter + 1
    end

    return quads
end

function GenerateQuadsSnake(atlas)
    local x = 16
    local y = 0

    local counter = 1
    local quads = {}

    for i = 0, 1 do
        quads[counter] = love.graphics.newQuad(x, y, 32, 16,
            atlas:getDimensions())
        x = x + 32
        counter = counter + 1
    end

    return quads
end

function GenerateQuadsLizard(atlas)
    local x = 16
    local y = 16

    local counter = 1
    local quads = {}

    for i = 0, 1 do
        quads[counter] = love.graphics.newQuad(x, y, 32, 16,
            atlas:getDimensions())
        x = x + 32
        counter = counter + 1
    end

    return quads
end

function GenerateQuadsBat(atlas)
    local x = 0
    local y = 12

    local counter = 1
    local quads = {}

    for it = 0, 0 do
        quads[counter] = love.graphics.newQuad(x, y, 12, 6,
            atlas:getDimensions())
        x = x + 16
        counter = counter + 1
    end

    return quads
end