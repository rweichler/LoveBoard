#!/usr/bin/env luajit
if not love then
    local cmd = arg[0]
    if cmd == 'luajit' then
        cmd = arg[1]
    end
    local count = #"main.lua"
    GAME_DIRECTORY = string.sub(cmd, 1, #cmd - count)
    package.path = package.path..";"..GAME_DIRECTORY.."?.lua"
    require 'globals'
    require 'bootstrap'
    return
end
require 'globals'

CONSOLE = require 'console'
apps = require('app_list')()
app_id_list = ''
for k,v in pairs(apps) do
    app_id_list = app_id_list..v.identifier..'\n'
end

local big, small, tiny
function love.load()
    LOAD()
    txt = "So yeah this example sucks.\n\n"..
        "Tap to return to SpringBoard\n\n"..
        "Game is stored in\n/var/mobile/LoveBoard\n\n"..
        "Type `relove` in terminal\nto relaunch this\n\n"..
        "width: "..SCREEN_WIDTH.."\nheight:"..SCREEN_HEIGHT
    console = CONSOLE()
    logo = "LöveBoard ("..SCREEN_WIDTH.."x"..SCREEN_HEIGHT..")"
    big = love.graphics.newFont(40)
    medium = love.graphics.newFont(26)
    small = love.graphics.newFont(20)
    tiny = love.graphics.newFont(15)
    list_y = 20 + big:getHeight()
end

function math.distance(x1, y1, x2, y2)
    return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2))
end

TOUCHES = {}
function love.touchreleased( id, x, y, dx, dy, pressure)
    local touch = TOUCHES[id]
    if touch.is_tap then
        local idx = math.ceil((y - list_y)/medium:getHeight())
        if idx < 1 or idx > #apps then
            love.event.quit()
            return
        end

        apps[idx]:launch()
    end
    TOUCHES[id] = nil
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    local touch = TOUCHES[id]    

    if math.distance(touch.orig_x, touch.orig_y, x, y) > 20 then
        touch.is_tap = false
    end

    list_y = list_y + y - touch.y
    touch.x, touch.y = x, y
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    TOUCHES[id] = {x = x, y = y, orig_x = x, orig_y = y, is_tap = true}
end

function love.mousereleased( x, y, button, istouch )
    if istouch then return end
    love.touchreleased(nil, x, y)
end

function love.keypressed(key, scancode, isrepeat)
    console:keypressed(key, scancode, isrepeat)
end

function love.textinput(text)
    console:textinput(text)
end

function love.draw()
    love.graphics.setFont(big)
    love.graphics.setColor(255, 0, 0, 255)
    for i=1,50 do
        local x = math.random(0, SCREEN_WIDTH)
        local y = math.random(0, SCREEN_HEIGHT)
        love.graphics.print('<3', x, y)
    end
    love.graphics.setColor(30, 130, 255, 255)
    love.graphics.print(logo, 20, 20)
    love.graphics.setFont(medium)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(app_id_list, 20,list_y)
    console:render()
end

require 'ios_compat'
