OBJC = require 'objc'
OBJECT = require 'object'

local app = OBJC.msg("id,id,id", OBJC.class("UIApplication"), OBJC.SEL("sharedApplication"))
local sel = OBJC.SEL("launchApplicationWithIdentifier:suspended:")
local NSString = OBJC.NSString


local O = OBJECT()

function O:new(identifier, folder)
    if not identifier then error("no identifier") end
    local self = OBJECT.new(self)
    self.identifier = identifier
    self.folder = folder
    return self
end

function O:launch()
    if MOBILE then
        local identifier = NSString(self.identifier)
        local suspended = false
        local result = OBJC.msg("bool, id,id,id,bool", app, sel, identifier, suspended)
        OBJC.release(identifier)
        return result
    else
        os.execute('open "'..self.folder..'"')
        return true
    end
end

return O
