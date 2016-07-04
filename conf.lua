require 'globals'
function love.conf(t)
    if MOBILE then
        t.window.highdpi = true
    else
        t.window.width = 1024
        t.window.height = 768
    end
end
