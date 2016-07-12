require 'globals'
function love.conf(t)
    if MOBILE then
        t.window.highdpi = true
    else
        t.window.width = 900
        t.window.height = 600
    end
end
