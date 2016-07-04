MOBILE = not require('jit').arch == 'x64'
FILL_RECT = function(x, y, w, h)
end
SET_COLOR = function(r, g, b)
end


function LOAD()
    SCREEN_WIDTH = love.graphics.getWidth()
    SCREEN_HEIGHT = love.graphics.getHeight()
end
