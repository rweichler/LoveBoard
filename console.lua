VIEW = require 'view'

local CONSOLE = VIEW()

local bg = {0, 0, 0, 200}

local floor = math.floor
local function MAX_BUFFER()
    return floor(SCREEN_HEIGHT/2/TEXT_HEIGHT- 1)
end

function CONSOLE:new()
    local self = VIEW.new(self)
    self.old_commands = {{color = {0, 0.5, 1}, text = "LOL LUA CONSOLE"}}
    self.current_command = ""
    self.x = 0
    self.y = SCREEN_HEIGHT/2
    self.width = SCREEN_WIDTH
    self.height = SCREEN_HEIGHT/2
    self.on = true
    return self
end

function CONSOLE:set_on(on)
    self._on = on
    if on then
        self.background_color = bg
    else
        self.background_color = nil
    end
    love.keyboard.setKeyRepeat(self.on)
end

function CONSOLE:get_on()
    return self._on
end

function CONSOLE:draw()
    if not self.on then return end

    for i, v in ipairs(self.old_commands) do
        if type(v) == "table" then
            SET_COLOR(unpack(v.color))
            v = tostring(v.text)
        else
            SET_COLOR(0.8, 0.8, 0.8)
        end
        DRAW_TEXT(v, 0, (MAX_BUFFER() - #self.old_commands)*TEXT_HEIGHT + self.y + (i - 1)*TEXT_HEIGHT)
    end
    SET_COLOR(1, 1, 1)
    DRAW_TEXT(self.current_command, 0, self.y + self.height - TEXT_HEIGHT)
end

function CONSOLE:keypressed(key)
    if not self.on then return end

    if key == 'return' then
        self:run_command()
    elseif key == 'backspace' then
        self.current_command = string.sub(self.current_command, 1, #self.current_command - 1)
    elseif key == 'escape' then
        self.on = false
    end
end

function CONSOLE:textinput(text)
    if text == '`' then
        self.on = not self.on
    elseif self.on then
        self.current_command = self.current_command..text
    end
end

function CONSOLE:run_command()
    table.insert(self.old_commands, self.current_command)
    local f, err = load(self.current_command)
    local print_error = function() if err then table.insert(self.old_commands, {color = {0.8, 0, 0}, text = err}) err = nil end end
    if err then
        print_error(err)
    else
        f, err = pcall(f)
    end
    if f then
        local result = err
        table.insert(self.old_commands, {color = {0, 0.8, 0}, text = result})
    else
        print_error(err)
    end
    self.current_command = ""
    while #self.old_commands > MAX_BUFFER() do
        table.remove(self.old_commands, 1)
    end
end

return CONSOLE
