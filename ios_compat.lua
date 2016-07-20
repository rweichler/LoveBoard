if not MOBILE then return end

local orig = love.draw
love.draw = function()
    love.graphics.rotate(math.pi/2)
    orig()
end

local orig = love.graphics.newFont
love.graphics.newFont = function(a, b)
    if not b then
        local size = a
        return orig(size*2)
    else
        local size = b
        return orig(a, size*2)
    end
end

local orig = love.graphics.print
love.graphics.print = function(x, y, z)
    return orig(x, y, z - SCREEN_HEIGHT)
end

local function tmp(x)
    local orig = love.graphics['get'..x]
    love.graphics['get'..x] = function()
        return orig()*2
    end
end

tmp('Width')
tmp('Height')


local orig = {'touchreleased', 'touchpressed', 'touchmoved'}
for k, v in pairs(orig) do
    local orig = love[v]
    love[v] = function(id, x, y, dx, dy, pressure)
        orig(id, y, SCREEN_HEIGHT - x, dy, -dx, pressure)
    end
end
