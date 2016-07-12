MOBILE = not (require('jit').arch == 'x64')
FILL_RECT = function(x, y, w, h, r, g, b, a)
    love.graphics.setColor(r, g, b, a)
    love.graphics.rectangle("fill", x, y, w, h)
end
SET_COLOR = function(r, g, b, a)
    love.graphics.setColor(r*255, g*255, b*255, a and a*255)
end
local courier
DRAW_TEXT = function(text, x, y)
    love.graphics.setFont(courier)
    love.graphics.print(text, x, y)
end

function LOAD()
    SCREEN_WIDTH = love.graphics.getWidth()
    SCREEN_HEIGHT = love.graphics.getHeight()
    if MOBILE then
        SCREEN_WIDTH, SCREEN_HEIGHT = SCREEN_HEIGHT/2, SCREEN_WIDTH/2
    end
    courier = love.graphics.newFont('res/mononoki.ttf', 15)
    TEXT_HEIGHT = 18
end

-- Lua implementation of PHP scandir function
function SCANDIR(directory)
    local t = {}
    local f = io.popen('ls "'..directory..'"')
    for line in f:lines() do
        table.insert(t, line)
    end
    f:close()
    return t
end

function FILE_EXISTS(name)
   local f = io.open(name, 'r')
   if f then
       io.close(f)
       return name
   end
end
