local OBJECT = {}


function OBJECT:new()
    local object = {}
    setmetatable(object, {
        __index = function(t, k)
            if t == OBJECT then return end
            local field = 'get_'..k
            local get_func = rawget(t, field) or self[field]
            if get_func then
                return get_func(t)
            else
                return self[k]
            end
        end,
        __newindex = function(t, k, v)
            local set_func = t['set_'..k]
            if set_func then
                set_func(t, v)
            else
                rawset(t, k, v)
            end
        end,
        __call = function(t, ...)
            return t:new(...)
        end
    })
    object.super = self
    return object
end

return OBJECT:new()
