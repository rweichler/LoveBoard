MOBILE = not require('jit').arch == 'x64'
FILL_RECT = function(x, y, w, h, r, g, b)
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle("fill", x, y, w, h)
end
SET_COLOR = function(r, g, b)
    love.graphics.setColor(r*255, g*255, b*255)
end
local courier
DRAW_TEXT = function(text, x, y)
    love.graphics.setFont(courier)
    love.graphics.print(text, x, y)
end



function LOAD()
    SCREEN_WIDTH = love.graphics.getWidth()
    SCREEN_HEIGHT = love.graphics.getHeight()
    courier = love.graphics.newFont('res/mononoki.ttf', 18)
    TEXT_HEIGHT = 22
end
