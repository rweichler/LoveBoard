MOBILE = not require('jit').arch == 'x64'
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
    courier = love.graphics.newFont('res/mononoki.ttf', 15)
    TEXT_HEIGHT = 18
end

-- Lua implementation of PHP scandir function
function SCANDIR(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls -a "'..directory..'"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

function FILE_EXISTS(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return name else return end
end
