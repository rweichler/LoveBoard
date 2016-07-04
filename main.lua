CONSOLE = require 'console'

function love.load()
    LOAD()
    txt = "So yeah this example sucks.\n\n"..
        "Tap to return to SpringBoard\n\n"..
        "Game is stored in\n/var/mobile/LoveBoard\n\n"..
        "Type `relove` in terminal\nto relaunch this\n\n"..
        "width: "..SCREEN_WIDTH.."\nheight:"..SCREEN_HEIGHT
    console = CONSOLE()
    love.keyboard.setTextInput(true)
end


function love.touchreleased( id, x, y, dx, dy, pressure)
    --love.system.openURL("cydia://package/loveboard")
    love.event.quit()
end

function love.mousereleased( x, y, button, istouch )
    --if istouch then return end
    --love.touchreleased(nil, x, y)
end

function love.keypressed(key, scancode, isrepeat)
    console:keypressed(key, scancode, isrepeat)
end

function love.textinput(text)
    console:textinput(text)
end

local big = love.graphics.newFont(40)
local small = love.graphics.newFont(20)
local tiny = love.graphics.newFont(10)

function love.draw()
    love.graphics.setFont(big)
    love.graphics.setColor(255, 0, 0, 255)
    for i=1,50 do
        love.graphics.print("<3", math.random(-100, SCREEN_WIDTH), math.random(-100, SCREEN_HEIGHT))
    end
    love.graphics.setColor(30, 130, 255, 255)
    love.graphics.print("LöveBoard", 20, 20)
    love.graphics.setFont(small)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(txt, 20, 60)
    console:render()
end

require 'ios_compat'
