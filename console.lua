VIEW = require 'lua.view'

local CONSOLE = VIEW()

local bg = {20, 20, 20}

local MAX_BUFFER = math.floor(SCREEN_HEIGHT/2/15 - 1)

function CONSOLE:new()
    local self = VIEW.new(self)
    self.old_commands = {{color = {0, 0.5, 1}, text = "LOL LUA CONSOLE"}}
    self.current_command = ""
    self.x = 0
    self.y = SCREEN_HEIGHT/2
    self.width = SCREEN_WIDTH
    self.height = SCREEN_HEIGHT/2
    return self
end

function CONSOLE:set_on(on)
    self._on = on
    if on then
        self.background_color = bg
    else
        self.background_color = nil
    end
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
        DRAW_TEXT(v, 0, (MAX_BUFFER - #self.old_commands)*15 + self.y + (i - 1)*15)
    end
    SET_COLOR(1, 1, 1)
    DRAW_TEXT(self.current_command, 0, self.y + self.height - 15)
end

function CONSOLE:keypress(key)
    if key == '`' then
        self.on = not self.on
        return true
    end
    if not self.on or #key ~= 1 then return end
    if key == '\n' or key == '\r' then
        self:run_command()
    elseif key == '\b' or string.byte(key) == 127 then
        self.current_command = string.sub(self.current_command, 1, #self.current_command - 1)
    else
        self.current_command = self.current_command..key
    end
    return true
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
    while #self.old_commands > MAX_BUFFER do
        table.remove(self.old_commands, 1)
    end
end

return CONSOLE
